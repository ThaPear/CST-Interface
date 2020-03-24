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

clear;
close all;
fclose('all');

%% Settings
path = 'h:\temp\';
% cstfile = 'T-junction_curved_transformer.cst';
cstfile = 'Single_dip_trunc_array.cst';

usebulkmode = 1;
matfileprefix = 'translated_';

%%
% Open the cst project.
try
    project = CST.Application.OpenFile([path, cstfile]);
    % Save to ensure the folder containing the model exists.
    project.Save();
catch exception
    error('Could not open CST file ''%s''.\nThis could be due to it being open already or due to an incorrect path.', [path, cstfile]);
end

% Extract all parameters.
parameters = project.GetAllParameters();
project.Quit();

cstfolder = [path, cstfile(1:end-4), '\'];
if(exist(cstfolder, 'dir') ~= 7)
    error('Project data folder not found. Open the .cst, save, and quit to create it.');
end

historylistpath = [cstfolder, 'Model\3D\Model.mod'];

matfile = [matfileprefix, cstfile(1:end-4)];
% Replace ., +, -, and <space> with _.
matfile = strrep(strrep(strrep(strrep(matfile, '.', '_'), '+', '_'), '-', '_'), ' ', '_');
matpath = [path, matfile, '.m'];

fileID = fopen(historylistpath, 'r');
if(fileID == -1)
    error('Failed to open ''%s''.', historylistpath);
end
outFileID = fopen(matpath, 'w');
if(outFileID == -1)
    error('Failed to open ''%s''.', matpath);
end

%% Start writing the file.
fprintf(outFileID, '%%%% Translated from ''%s''.\n', historylistpath);
% New project.
fprintf(outFileID, 'project = CST.Application.NewMWS();\n\n');

% Store all parameters.
fnames = fieldnames(parameters);
for(i = 1:length(fnames))
    fname = fnames{i};
    % Convert to double and back to string to remove float errors such as 2.2999999999999998.
    fprintf(outFileID, 'project.StoreParameter(''%s'', ''%.15g'');\n', fname, str2double(parameters.(fname)));
end
fprintf(outFileID, '\n');

currentobject = '';
currentobjecttype = [];
definedobjects = struct();
bulkmode = 0;

while(1)
    line = fgetl(fileID);
    if(~ischar(line))
        break;
    end
    if(isempty(line))
        continue;
    end
    if(line(1) == '''')
        if(line(2) == '[')
            continue;
        elseif(line(2) == '@')
            fprintf(outFileID, '%%%%%s\n', line(3:end));
            continue;
        else
            fprintf(outFileID, '%%%s\n', line(2:end));
            continue;
        end
    end
    
    % Special cases
    line = strrep(line, 'Plot.DrawBox True', 'Plot.DrawBox "True" ');
    line = strrep(line, 'SlantAngle 0.000000e+000 ', 'SlantAngle "0.000000e+000"');
    line = strrep(line, 'SlantAngle 0.000000e+00 ', 'SlantAngle "0.000000e+00"');
    line = strrep(line, 'Set "Version", 1%', 'Set "Version", "1%"');
    
    % Tolerate tabs and 3- to 40-space function calls.
    line = strrep(line, char(9), '    '); % 9 is a tab character.
    line = strrep(line, '          ', '     ');
    line = strrep(line, '          ', '     ');
    line = strrep(line, '          .', '<spaces>.');
    line = strrep(line, '        .', '<spaces>.');
    line = strrep(line, '       .', '<spaces>.');
    line = strrep(line, '      .', '<spaces>.');
    line = strrep(line, '     .', '<spaces>.');
    line = strrep(line, '    .', '<spaces>.');
    line = strrep(line, '   .', '<spaces>.');
    line = strrep(line, '<spaces>.', '     .');
    
    % Replace VBA comment symbol with MATLAB comment symbol.
    line = strrep(line, '''', '%'); % 9 is a tab character.
    
    translateargumentstring = @(str) strrep(strrep(strrep(strrep(strrep(strrep(strrep(str, '("', '('''), '")', ''')'), '", "', ''', '''), ' "', '('''), '" ', ''');'), '"', ''');'), ' (', '(');
%     line = strrep(line, '("', '(''');
%     line = strrep(line, '")', ''')');
%     line = strrep(line, '", "', ''', ''');
%     line = strrep(line, ' "', '(''');
%     line = strrep(line, '" ', ''');');
%     line = strrep(line, '"', ''');');
    
    if(length(line) >= 6 && strcmpi(line(1:4), 'With'))
        % 'With <object>'
        if(~isempty(currentobject))
            error('Nested With <object> not supported.');
        end
        line = strtrim(line);
        currentobject = lower(line(6:end));
        currentobjecttype = line(6:end);
        if(~isfield(definedobjects, currentobject))
            fprintf(outFileID, '%s = project.%s();\n', currentobject, line(6:end));
            definedobjects.(currentobject) = 1;
        end
        % Does the object support bulkmode?
        if(usebulkmode ...
          && any(contains(properties(['CST.', currentobjecttype]), 'bulkmode')) ...
          && ~strcmp(currentobject, 'parametersweep'))
            fprintf(outFileID, '%s.StartBulkMode();\n', currentobject);
            bulkmode = 1;
        end
        
        % Output:
        % lower(<object>) = project.<object>();
        % <object>.StartBulkMode(); % If supported
    elseif(length(line) >= 6 && strcmpi(line(1:6), '     .'))
        % '     .<function> "<arg1>", "<arg2>" '
        if(strcmp(currentobject, 'meshsettings') && contains(line, 'Version'))
            warning(['meshsettings.Set "Version" is sometimes incorrectly translated.', newline, ...
                     'Check resulting .m file.']);
        end
        if(strcmp(currentobject, 'farfieldplot') && contains(line, 'SlantAngle'))
            warning(['farfieldplot.SlantAngle is sometimes incorrectly translated.', newline, ...
                     'Check resulting .m file.']);
        end
        if(strcmp(currentobject, 'meshsettings') && contains(line, 'ApplyToMeshGroup'))
            bulkmode = 0;
        end
        
        line = strtrim(translateargumentstring(line));
        if(line(end) ~= ';')
            line = [line, '();']; %#ok<AGROW>
        end
        
        fprintf(outFileID, '%s.%s\n', currentobject, line(2:end));
        % Output:
        % <object>.<function>('<arg1>', '<arg2>');
    elseif(strcmpi(strtrim(line), 'End With'))
        % 'End With'
        % End bulk mode if it's active.
        if(bulkmode)
            fprintf(outFileID, '%s.EndBulkMode();\n', currentobject);
            bulkmode = 0;
        end
        currentobject = '';
        fprintf(outFileID, '\n');
        % Output:
        % <object>.EndBulkMode(); % If supported
        % <blank line>
    else
        if(line(1) == ' ')
            error('Unexpected space at start of line.\n\t''%s''', line);
        end
        
        ispace = strfind(line, ' ');
        idot = strfind(line, '.');
        
        line = translateargumentstring(line);
        
        if(~isempty(idot) && (isempty(ispace) || idot(1) < ispace(1)))
            % <object>.<function> "<arg1>", "<arg2>"
            currentobject = lower(line(1:idot-1));
            if(~isfield(definedobjects, currentobject))
                fprintf(outFileID, '%s = project.%s();\n', currentobject, line(1:idot-1));
                definedobjects.(currentobject) = 1;
            end
            fprintf(outFileID, '%s.%s\n\n', currentobject, line(idot+1:end));
            currentobject = '';
            % Output:
            % lower(<object>) = project.<object>();
            % lower(<object>).<function>('<arg1>', '<arg2>');
            % <blank line>
        else
            % <function> "<arg1>", "<arg2>"
            fprintf(outFileID, 'project.%s\n\n', line);
            % Output:
            % project.<function>('<arg1>', '<arg2>');
            % <blank line>
        end
    end
end

fclose(fileID);
fclose(outFileID);

open(matpath);