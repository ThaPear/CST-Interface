% CST Interface - Interface with CST from MATLAB.
% Copyright (C) 2020 Alexander van Katwijk
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

function TranslateHistoryList(path, cstfile, matfilepath, usebulkmode)
% Example input arguments
% path = 'h:\temp\';
% cstfile = 'Single_dip_trunc_array.cst';
% [optional] matfilepath = [path, 'translated.m'];  (default: [path, cstfile(-.cst), '.m'])
% [optional] usebulkmode = 1;                       (default: 1)
% Bulk mode is recommended, as it shortens the history list significantly.
% If there's issues in the project after hitting Update in the history list, you should disable it.

if(path(end) ~= '\' && path(end) ~= '/')
    path = [path, '\'];
end

if(nargin < 3)
    matfile = ['translated_', cstfile(1:end-4)];
    % Replace ., +, -, and <space> with _.
    matfile = strrep(strrep(strrep(strrep(matfile, '.', '_'), '+', '_'), '-', '_'), ' ', '_');
    matfilepath = [path, matfile, '.m'];
else
    islash = [strfind(matfilepath, '/'), strfind(matfilepath, '\')];
    matfile = matfilepath(max(islash):end-2);
end
if(nargin < 4)
    usebulkmode = 1;
end

fclose('all');

%%
% Open the cst project.
CST.Application.CloseProject([path, cstfile]);
project = CST.Application.OpenFile([path, cstfile]);

% Save to ensure the folder containing the model exists.
project.Save();

% Extract all parameters.
[parameters, descriptions] = project.GetAllParametersWithDescription();
project.Quit();

%% Open the history list file.
cstfolder = [path, cstfile(1:end-4), '\'];
if(exist(cstfolder, 'dir') ~= 7)
    error('Project data folder not found. Open the .cst, save, and quit to create it.');
end

historylistpath = [cstfolder, 'Model\3D\Model.mod'];

hInFile = fopen(historylistpath, 'r');
if(hInFile == -1)
    error('Failed to open ''%s''.', historylistpath);
end
%% Open the output file.
hOutFile = fopen(matfilepath, 'w');
if(hOutFile == -1)
    error('Failed to open ''%s''.', matfilepath);
end

%% Start writing the file.
fprintf(hOutFile, '%%%% Translated from ''%s''.\n', historylistpath);
% New project.
fprintf(hOutFile, 'project = CST.Application.NewMWS();\n\n');

% Store all parameters.
fnames = fieldnames(parameters);
for(i = 1:length(fnames))
    fname = fnames{i};
    % Convert to double if it's not a string value.
    if(~isnan(str2double(parameters.(fname))))
        parameters.(fname) = str2double(parameters.(fname));
    end
    
    % Convert to double and back to string to remove float errors such as 2.2999999999999998.
    fprintf(hOutFile, 'project.StoreParameterWithDescription(''%s'', ''%s'', ''%s'');\n', fname, num2str(parameters.(fname), '%.15g'), descriptions.(fname));
end
fprintf(hOutFile, '\n');

currentobject = '';
definedobjects = struct();
bulkmode = 0;
itemmeshsettingsname = [];
version = [];
curfilenumber = 1;

warnedversion = 0;
warnedslant = 0;
zippedfiles = 0;

linenumber = 0;
historylistnumber = 0;
while(1)
    line = fgetl(hInFile);
    linenumber = linenumber + 1;
    
    if(mod(linenumber, 1000) == 999)
        fprintf(hOutFile, 'fprintf(''Line %i\\n'');\n', linenumber+1);
        fprintf('Line %i\n', linenumber+1);
    end
    %% Split the file into 5k-line parts.
    if(linenumber / 5000 > curfilenumber)
        curfilenumber = curfilenumber + 1;
        if(curfilenumber == 2)
            % Add the call to the next part.
            fprintf(hOutFile, '\n\n%%%% Continue in the next part(s).\n');
            fprintf(hOutFile, '%s_part%i;\n', matfile, curfilenumber);
        else
            % Reopen the first file and add the call to the next part.
            fclose(hOutFile);
            hOutFile = fopen(matfilepath, 'a');
            fprintf(hOutFile, '%s_part%i;\n', matfile, curfilenumber);
        end
        fclose(hOutFile);
        matfilepath_part = [matfilepath(1:end-2), '_part', num2str(curfilenumber), '.m'];
        hOutFile = fopen(matfilepath_part, 'w');
        if(hOutFile == -1)
            error('Failed to open ''%s''.', matfilepath_part);
        end
    end
    %% End of file.
    if(~ischar(line))
        break;
    end
    % Skip empty lines and lines that only contain a single apostrophe '
    if(isempty(line) || (line(1) == '''') && (length(line) < 2))
        continue;
    end
    %% Handle comments and list item headers.
    if(line(1) == '''')
        if(line(2) == '[')
            version = str2double(line(11:14));
            continue;
        elseif(line(2) == '@' || line(3) == '@')
            % ''@ <history list name>'
                historylistnumber = historylistnumber + 1;
                % 'execute macro' is simply a bunch of VBA code.
                % 'define monitors' of version 2014 is simply a bunch of VBA code.
                if(contains(line, 'execute macro') ...
                  || contains(line, 'define monitors') && version == 2014)
                    code = '';
                    templine = fgetl(hInFile);
                    while(  ((length(templine) < 2) || (templine(2) ~= '@')) ...
                         && ((length(templine) < 3) || (templine(3) ~= '@')))
                        if(~ischar(templine))
                            error('End of file reached.');
                        end
                        codeline = strrep(templine, '''', ''''''); % Double the number of '
                        code = [code, '''', codeline, ''', newline, ...', newline]; %#ok<AGROW>
                        templine = fgetl(hInFile);
                    end
                    code = ['project.AddToHistory(''', line(3:end), ''', [', code, ''''']);']; %#ok<AGROW>
                    fprintf(hOutFile, '\n%%%%%s\n', line(3:end));
                    fprintf(hOutFile, '%s\n', code);
                    % Go back 1 line, since we use the start of the next block as a stop signal.
                    fseek(hInFile, -(length(templine)+2), 0);
                    continue;
                end
                fprintf(hOutFile, '\n%%%%%s\n', line(3:end));
            % Output:
            % <Blank line>
            % %% <history list name>
            continue;
        else
            fprintf(hOutFile, '%%%s\n', line(2:end));
            continue;
        end
    end
    
    %% Special cases.
    line = strrep(line, 'Plot.DrawBox True', 'Plot.DrawBox "True" ');
    line = strrep(line, 'SlantAngle 0.000000e+000 ', 'SlantAngle "0.000000e+000"');
    line = strrep(line, 'SlantAngle 0.000000e+00 ', 'SlantAngle "0.000000e+00"');
    line = strrep(line, 'Set "Version", 1%', 'Set "Version", "1%"');
    line = strrep(line, 'Set "Version", 0%', 'Set "Version", "0%"');
    line = strrep(line, '.Version 10', '.Version "10" ');
    line = strrep(line, '.Version 9', '.Version "9" ');
    line = strrep(line, '.Version 1', '.Version "1" ');
    for(i = 1:5); line = strrep(line, '", 0', '", "0"'); end
    for(i = 1:5); line = strrep(line, '", 1', '", "1"'); end
    
    %% Tolerate tabs and 3- to 40-space function calls.
%     line = strrep(line, char(9), '    '); % 9 is a tab character.
%     line = strrep(line, '          ', '     ');
%     line = strrep(line, '          ', '     ');
%     line = strrep(line, '          .', '<spaces>.');
%     line = strrep(line, '        .', '<spaces>.');
%     line = strrep(line, '       .', '<spaces>.');
%     line = strrep(line, '      .', '<spaces>.');
%     line = strrep(line, '     .', '<spaces>.');
%     line = strrep(line, '    .', '<spaces>.');
%     line = strrep(line, '   .', '<spaces>.');
%     line = strrep(line, '  .', '<spaces>.');
%     line = strrep(line, '<spaces>.', '     .');
%     if(line(1) == '.'); line = ['     ', line]; end %#ok<AGROW>
    %% Ensure consistent formatting for function calls.
    linetrim = strtrim(line);
    if(linetrim(1) == '.')
        line = ['     ', linetrim];
    end
    
    % Replace VBA comment symbol with MATLAB comment symbol.
    line = strrep(line, '''', '%');
    
    %% Translate VBA-style arguments to Matlab-style arguments.
    translateargumentstring = @(str) strrep(strrep(strrep(strrep(strrep(...
                                     strrep(strrep(strrep(strrep(strrep(...
                                     strrep(strrep(...
                                        str, '  "', ' "'),      ...   " to  "
                                             ' ,', ','),        ...  , to ,
                                             '("', '('''),      ... (" to ('
                                             '")', ''')'),      ... ") to ')
                                             '", "', ''', '''), ... ", " to ', '
                                             '","', ''', '''),  ... "," to ', '
                                             ' "', '('''),      ...  " to ('
                                             '" ', ''');'),     ... "  to ');
                                             '")', ''');'),     ... ") to ');
                                             '("', ''');'),     ... (" to ('
                                             '"', ''');'),      ... " to ');
                                             ' (', '(');          %  ( to (
    translateargumentstring = @TranslateHistoryList_TranslateArguments;
    
    if(length(line) >= 6 && strcmpi(line(1:4), 'With'))
        %% With <object>
            if(~isempty(currentobject))
                error('Nested With <object> not supported.');
            end
            line = strtrim(line);
            currentobject = lower(line(6:end));
            currentobjecttype = line(6:end);
            if(~isfield(definedobjects, currentobject))
                fprintf(hOutFile, '%s = project.%s();\n', currentobject, line(6:end));
                definedobjects.(currentobject) = 1;
            end
            % Does the object support bulkmode?
            if(usebulkmode ...
              && any(contains(properties(['CST.', currentobjecttype]), 'bulkmode')) ...
              && ~strcmp(currentobject, 'parametersweep'))
                fprintf(hOutFile, '%s.StartBulkMode();\n', currentobject);
                bulkmode = 1;
            end
        % Output:
        % lower(<object>) = project.<object>();
        % <object>.StartBulkMode(); % If supported
    elseif(length(line) >= 6 && strcmpi(line(1:6), '     .'))
        %% '     .<function> "<arg1>", "<arg2>" '
            if(~warnedversion && strcmp(currentobject, 'meshsettings') && contains(line, 'Version'))
                warning(['meshsettings.Set "Version" may be incorrectly translated.', newline, ...
                         'Check resulting .m file.']);
                warnedversion = 1;
            end
            if(~warnedslant && strcmp(currentobject, 'farfieldplot') && contains(line, 'SlantAngle'))
                warning(['farfieldplot.SlantAngle may be incorrectly translated.', newline, ...
                         'Check resulting .m file.']);
                warnedslant = 1;
            end
            if(~zippedfiles && ((strcmp(currentobject, 'sat') && contains(line, 'Read')) ...
                                || (strcmp(currentobject, 'dxf') && contains(line, 'Read')) ...
                                || (strcmp(currentobject, 'fieldsource') && contains(line, 'Read')) ...
                                || (strcmp(currentobject, 'step') && contains(line, 'Read')) ...
                                || (strcmp(currentobject, 'iges') && contains(line, 'Read'))))
                warning(['%s.Read uses files in the Model/3D folder, which do not exist in a new project.', newline, ...
                         'Created a zip of all sat, dxf, fsm, stp, and igs files which will be extracted into the new project.'], currentobject);
                % Pack all those kinds of files into a zip.
                zippath = [path, matfile, '.zip'];
                zip(zippath, ...
                    {[cstfolder, 'Model\3D\*.cby'], ...
                     [cstfolder, 'Model\3D\*.dxf'], ...
                     [cstfolder, 'Model\3D\*.fsm'], ...
                     [cstfolder, 'Model\3D\*.stp'], ...
                     [cstfolder, 'Model\3D\*.step']});
                 % Make the translated file unzip the files.
                fprintf(hOutFile, ['modelpath = project.GetProjectPath(''Model3D'');\n', ...
                                   'unzip(''%s'', modelpath);\n'], zippath);
                zippedfiles = 1;
            end

            line = strtrim(translateargumentstring(line));
            if(line(end) ~= ';')
                line = [line, '();']; %#ok<AGROW>
            end

            fprintf(hOutFile, '%s.%s\n', currentobject, line(2:end));
        % Output:
        % <object>.<function>('<arg1>', '<arg2>');
    elseif(strcmpi(strtrim(line), 'End With'))
        %% End With
            % If this is the 'With .ItemMeshSettings("<arg>")' block, replace one 'End With' with a
            % call to ApplyToMeshGroup('<arg>');
            if(~isempty(itemmeshsettingsname))
                fprintf(hOutFile, 'meshsettings.ApplyToMeshGroup(''%s'');\n', itemmeshsettingsname);
                itemmeshsettingsname = [];
                continue;
            end
            % End bulk mode if it's active.
            if(bulkmode)
                fprintf(hOutFile, '%s.EndBulkMode();\n', currentobject);
                bulkmode = 0;
            end
            currentobject = '';
        % Output:
        % <object>.EndBulkMode(); % If supported
    elseif(contains(line, 'With .ItemMeshSettings '))
        %% '     With .ItemMeshSettings("<arg>")'
            line = strtrim(line);
            itemmeshsettingsname = line(26:end-2);
        % Output:
        % <none>
    else
        if(line(1) == ' ')
            trimline = strtrim(line);
            if(trimline(1) == '%')
                % It's just a comment.
                fprintf(hOutFile, line);
                continue;
            else
                error('Unexpected space at start of line.\n\t''%s''', line);
            end
        end
        
        ispace = strfind(line, ' ');
        idot = strfind(line, '.');
        
        line = translateargumentstring(line);
        
        if(~isempty(idot) && (isempty(ispace) || idot(1) < ispace(1)))
            % <object>.<function> "<arg1>", "<arg2>"
            currentobject = lower(line(1:idot-1));
            if(~isfield(definedobjects, currentobject))
                fprintf(hOutFile, '%s = project.%s();\n', currentobject, line(1:idot-1));
                definedobjects.(currentobject) = 1;
            end
            fprintf(hOutFile, '%s.%s\n', currentobject, line(idot+1:end));
            currentobject = '';
            % Output:
            % lower(<object>) = project.<object>();
            % lower(<object>).<function>('<arg1>', '<arg2>');
        else
            % <function> "<arg1>", "<arg2>"
            fprintf(hOutFile, 'project.%s\n', line);
            % Output:
            % project.<function>('<arg1>', '<arg2>');
        end
    end
end

fprintf(hOutFile, 'fprintf(''CST project successfully generated\\n'');\n');

fclose(hInFile);
fclose(hOutFile);

fprintf('Translation successful, opening ''%s''.\n', matfilepath);
open(matfilepath);