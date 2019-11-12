clear;

% txt = clipboard('paste');
% txt = fileread('asciiexport.txt');
% txt = fileread('brick.txt');
% txt = fileread('curve.txt');
% txt = fileread('floquetport.txt');
% txt = fileread('combineresults.txt');
% txt = fileread('plot1d.txt');
txt = fileread('result1d.txt');
% txt = fileread('project.txt');
split = strsplit(txt, newline);
split = strrep(split, split(1), '');
split([cellfun(@isempty, split)]) = [];

% Find object name (e.g. 'Brick', 'Material').
objecttype = strrep(split{3}, ' Object', '');
objectdescr = split{4};

% Open output file.
hOutfile = fopen(['CST Interface/test_', objecttype, '.m'], 'wt');
if(hOutfile == -1)
    warning('Error opening file %s', ['test_', objecttype, '.m']);
    return;
end

% Find Methods, Example, and Default Settings
methodsstartI = find(strcmp(split, 'Methods'), 1, 'last');
if(isempty(methodsstartI))
    methodsstartI = find(strcmp(split, 'General Methods'), 1, 'last');
    if(isempty(methodsstartI))
        warning('Could not find methods.');
        return;
    end
end
defaultsettingsstartI = find(strcmp(split, 'Default Settings'), 1, 'last');
if(isempty(defaultsettingsstartI))
    defaultsettingsstartI = length(split)+1;
end
examplesstartI = find(strcmp(split, 'Example'), 1, 'last');
if(isempty(examplesstartI))
    examplesstartI = find(strcmp(split, 'Examples'), 1, 'last');
    if(isempty(examplesstartI))
        examplesstartI = length(split)+1;
    end
end

% Store properties for class.
properties = {};

GENERATEFILE_HISTORY;

%% Methods
fprintf(hOutfile, '    %%%% CST Object functions.\n');
fprintf(hOutfile, '    methods\n');
methodlines = split(methodsstartI+1:min(defaultsettingsstartI, examplesstartI)-1);
funcs = [];
i = 1;
while(i <= length(methodlines))
    line = methodlines{i};
    if(isempty(strtrim(line)))
        i = i + 1;
        continue;
    end
    
    errorfunc = 0;
    invoking = 0;
    nargs = 1;
    argdescr = '';
    bropen = strfind(line, '(');
    brclose = strfind(line, ')');
    if(~isempty(bropen))
        args = line(bropen+1:brclose-1);
        if(~isempty(args))
            % Detect enums that use brackets.
            if(contains(args, '{'))
                enumstart = strfind(args, '{');
                enumend = strfind(args, '}');
                enumargs = args(enumstart+1:enumend-1);
                % Cut out the enum
                args = args([1:enumstart-1, enumend+1:end]);
                % Find the variable name of this enum.
                enumname = strtrim(args(find(args(1:enumstart-3) == ' ', 1, 'last'):enumstart-1));
                % If we find enum, the variable name is after the list.
                if(strcmp(enumname, 'enum'))
                    endval = find(args(enumstart:end) == ',', 1, 'first');
                    % If there's no comma it's the end of the line.
                    if(isempty(endval))
                        endval = length(args(enumstart:end))-1;
                    end
                    enumname = strtrim(args(enumstart+(1:endval)));
                end
                % Add this enum to the method description.
                enumargs = strtrim(strsplit(strrep(enumargs, '"', ''''), ','));
                enumdescr = '';
                for(enumargi = 1:length(enumargs))
                    enumarg = enumargs{enumargi};
                    if(enumargi == 1)
                        enumdescr = [enumdescr, '            % ', enumname, ': ', enumarg, newline];
                    else
                        enumdescr = [enumdescr, '            % ', repmat(' ', 1, length(enumname)+2), enumarg, newline];
                    end
                end
                argdescr = [argdescr, enumdescr];
            end
            % Split into separate args
            args = strsplit(args, ',');
            funcargs = {'obj'};
            for(argi = 1:length(args))
                % Process each arg.
                arg = args{argi};
                % Split on spaces
                arg = strsplit(arg);
                % Remove empty elements
                arg([cellfun(@isempty, arg)]) = [];
                if(~isempty(arg))
                    % Switch is often used as parameter name, replace with
                    % boolean.
                    arg = strrep(arg, 'switch', 'boolean');
                    % Append to MATLAB function argument list.
                    if(length(arg) > 1)
                        funcargs = [funcargs, {arg{2}}];
                        if(contains(arg{1}, '_ref'))
                            errorfunc = 1;
                        end
                    else
                        funcargs = [funcargs, {arg{1}}];
                    end
                    nargs = nargs + 1;
                end
            end
        else
            % The function has empty braces ().
            funcargs = {'obj'};
        end
        % Cut out the arguments from the function name.
        line = line([1:bropen-1, brclose+1:end]);
    else
        funcargs = {'obj'};
    end
    % Get function return value
    linesplit = strsplit(line);
    funcname = linesplit{1};
    if(length(linesplit) > 1)
        argout = linesplit{2};
    else
        argout = '';
    end

    
    % Find end of description (given by blank line).
%     descrend = find(([cellfun(@length, methodlines(i+1:end))] < 2), 1, 'first');
    descrend = find(strcmp(methodlines(i+1:end), ' '), 1, 'first');
    if(isempty(descrend))
        descrend = length(methodlines) - i + 1;
    end
    % Extract the method's description.
    funcdescr = methodlines(i+1:i+descrend-1);
    % Add newlines after each line of the description.
    funcdescr = strcat({'            % '}, funcdescr, {newline});
    
    %% Write function to output file.
    if(~isempty(argout))
        fprintf(hOutfile, '        function %s = %s(', argout, funcname);
    else
        fprintf(hOutfile, '        function %s(', funcname);
    end
    % Write function args.
    for(argi = 1:nargs)
        if(argi ~= 1)
            fprintf(hOutfile, ', ');
        end
        fprintf(hOutfile, '%s', funcargs{argi});
    end
    fprintf(hOutfile, ')\n');
    % If the function takes any _ref arguments (e.g. double_ref), error.
    if(errorfunc)
        fprintf(hOutfile, '            %% This function was not implemented due to the double_ref\n');
        fprintf(hOutfile, '            %% arguments being seemingly impossible to pass from MATLAB.\n');
        fprintf(hOutfile, '            warning(''Used unimplemented function ''''%s''''.'');\n', funcname);
        if(~isempty(argout))
            fprintf(hOutfile, '            %s = nan;\n', argout);
        end
        fprintf(hOutfile, '            return;\n');
    end
    % Function description from CST documentation.
    fprintf(hOutfile, '%s', [funcdescr{:}]);
    % Enum argument descriptions.
    fprintf(hOutfile, '%s', [argdescr]);
    % MATLAB interface call.
    if(histtype == 0 && isempty(argout))
        fprintf(hOutfile,               '            obj.h%s.invoke(''%s''', objecttype, funcname);
        basecalllength = length(sprintf('            obj.h%s.invoke(''%s''', objecttype, funcname));
        invoking = 1;
    elseif(isempty(argout))
        fprintf(hOutfile,               '            obj.AddToHistory([''.%s', funcname);
        basecalllength = length(sprintf('            obj.AddToHistory([''.%s', funcname));
    else
        fprintf(hOutfile,               '            %s = obj.h%s.invoke(''%s''', argout, objecttype, funcname);
        basecalllength = length(sprintf('            %s = obj.h%s.invoke(''%s''', argout, objecttype, funcname));
        invoking = 1;
    end
    % Arguments of interface call.
    if(~invoking)
        % Arguments are converted to string and aligned on multiple lines.
        for(argi = 2:nargs)
            if(argi == 2) % First one is behind the AddToHistory call, so only 1 space.
                fprintf(hOutfile, ' ');
            else % Align subsequent lines with initial one.
                fprintf(hOutfile, [repmat(' ', 1, basecalllength), '''']);
            end
            fprintf(hOutfile, '"'', num2str(%s, ''%%.15g''), ''"', funcargs{argi});
            if(argi < nargs)
                fprintf(hOutfile, ', ''...\n');
            end
        end
        fprintf(hOutfile, ''']);\n');
    else
        % Arguments for invoke are just behind the call.
        for(argi = 2:nargs)
            fprintf(hOutfile, ', %s', funcargs{argi});
        end
        fprintf(hOutfile, ');\n');
    end
    if(histtype ~= 0)
        % Store given value in object.
        for(argi = 2:nargs)
            if(nargs == 2)
                fprintf(hOutfile, '            obj.%s = %s;\n', lower(funcname), funcargs{argi});
            else
                fprintf(hOutfile, '            obj.%s.%s = %s;\n', lower(funcname), funcargs{argi}, funcargs{argi});
            end
        end
        if(nargs > 1)
            properties = [properties, {lower(funcname)}];
        end
    end
    
    % If this function should be the one to send history to CST, do so.
    % (e.g. Brick.Create)
    if(strcmpi(funcname, createfunctionname))
        fprintf(hOutfile, '            \n');
        fprintf(hOutfile, '            %% Prepend With %s and append End With\n', objecttype);
        fprintf(hOutfile, '            obj.history = [ ''With %s'', newline, ...\n', objecttype);
        fprintf(hOutfile, '                                obj.history, ...\n');
        fprintf(hOutfile, '                            ''End With''];\n');
        fprintf(hOutfile, '            obj.project.AddToHistory([''define %s''], obj.history);\n', objecttype);
        fprintf(hOutfile, '            obj.history = [];\n');
    end
    
    fprintf(hOutfile, '        end\n');
    
%     if(createconditional && strcmpi(funcname, createfunctionname))
%         % Repeat input argument and function name of earlier.
%         if(~isempty(argout))
%             fprintf(hOutfile, '        function %s = %sConditional(', argout, funcname);
%         else
%             fprintf(hOutfile, '        function %sConditional(', funcname);
%         end
%         % Write function args.
%         for(argi = 1:nargs)
%             if(argi ~= 1)
%                 fprintf(hOutfile, ', ');
%             end
%             fprintf(hOutfile, '%s', funcargs{argi});
%         end
%         fprintf(hOutfile, ', condition)\n');
%         % Function description from CST documentation.
%         fprintf(hOutfile, '%s', [funcdescr{:}]);
%         fprintf(hOutfile, '            %% condition: A string of a VBA expression that evaluates to True or False\n');
%         % Enum argument descriptions.
%         fprintf(hOutfile, '%s', [argdescr]);
%         % Conditional code
%         fprintf(hOutfile, '            obj.AddToHistory([''.%s'']);\n');
%         fprintf(hOutfile, '            \n');
%         fprintf(hOutfile, '            % Prepend With and append End With\n');
%         fprintf(hOutfile, '            obj.history = [ ''If '', condition, '' Then'', newline, ...\n');
%         fprintf(hOutfile, '                                ''With Brick'', newline, ...\n');
%         fprintf(hOutfile, '                                    obj.history, ...\n');
%         fprintf(hOutfile, '                                ''End With'', newline, ...\n');
%         fprintf(hOutfile, '                            ''End If''];\n');
%         fprintf(hOutfile, '            obj.project.AddToHistory(['define conditional brick ', obj.componentname, ':', obj.name], obj.history);\n');
%         fprintf(hOutfile, '            obj.history = [];\n');
%     end
    
    i = i + descrend + 1;
end
% End 'methods'
fprintf(hOutfile, '    end\n');

%% Properties
fprintf(hOutfile, '    %%%% MATLAB-side stored settings of CST state.\n');
fprintf(hOutfile, '    %% Note that these can be incorrect at times.\n');
fprintf(hOutfile, '    properties(SetAccess = protected)\n');
fprintf(hOutfile, '        project\n');
fprintf(hOutfile, '        h%s\n', objecttype);
if(histtype ~= 0)
fprintf(hOutfile, '        history\n');
end
if(histtype == 1)
fprintf(hOutfile, '        bulkmode\n');
end
fprintf(hOutfile, '\n');
for(i = 1:length(properties))
    fprintf(hOutfile, '        %s\n', properties{i});
end
fprintf(hOutfile, '    end\n');

% End classdef
fprintf(hOutfile, 'end\n');

%% Default Settings
if(defaultsettingsstartI <= length(split))
    fprintf(hOutfile, '\n%%%% Default Settings\n');
    defaultsettingslines = split(defaultsettingsstartI+1:examplesstartI-1);
    for(i = 1:length(defaultsettingslines))
        line = defaultsettingslines{i};
        % Replace all VBA-style arguments to MATLAB-style.
        line = strrep(line, ' ("', '(''');
        line = strrep(line, '", "', ''', ''');
        line = strrep(line, '", ', ''', ');
        line = strrep(line, ', "', ', ''');
        line = strrep(line, '")', ''');');
        line = strrep(line, ' "', '(''');
        line = strrep(line, '"', ''');');
        line = strrep(line, ' (', '(');
        line = strrep(line, 'False', '0');
        line = strrep(line, 'True', '1');
        % Write line to output file.
        fprintf(hOutfile, '%% %s\n', line);
    end
end

%% Example
if(examplesstartI <= length(split))
    fprintf(hOutfile, '\n%%%% Example - Taken from CST documentation and translated to MATLAB.\n');
    
    objectcreated = 0;
    
    examplelines = split(examplesstartI+1:end);
    for(i = 1:length(examplelines))
        line = examplelines{i};
        % Replace all VBA-style arguments to MATLAB-style.
        line = strrep(line, '''', '%');
        line = strrep(line, ' ("', '(''');
        line = strrep(line, '("', '(''');
        line = strrep(line, '", "', ''', ''');
        line = strrep(line, '","', ''', ''');
        line = strrep(line, '", ', ''', ');
        line = strrep(line, '",', ''', ');
        line = strrep(line, ', "', ', ''');
        line = strrep(line, ',"', ', ''');
        line = strrep(line, '")', ''');');
        line = strrep(line, ' "', '(''');
        line = strrep(line, '"', ''');');
        line = strrep(line, ' (', '(');
        line = strrep(line, 'False', '0');
        line = strrep(line, 'True', '1');
        
        % Skip End With, not needed in MATLAB.
        if(strcmp(line, 'End With'))
            continue;
        end
        % Skip blank lines.
        if(length(line) < 2)
            fprintf(hOutfile, '%% \n');
            continue;
        end
        % Just copy over comments as-is.
        if(line(1) == '''')
            fprintf(hOutfile, '%% %% %s\n', line(3:end));
            continue;
        end
        
        % If the object is referenced VBA-style, ensure it exists.
        if(line(1:4) == 'With')
            % Ensure object is retrieved from the project object.
            if(~objectcreated)
                fprintf(hOutfile, '%% %s = project.%s();\n', lower(objecttype), objecttype);
                objectcreated = 1;
            end
            continue;
        end
        % Write line to output file.
        if(length(line) >= 5 && strcmp(line(1:5), '    .'))
            % The example uses With Brick   .Function(...)   End With style.
            % Write line to file with proper MATLAB-style method reference.
            fprintf(hOutfile, '%%     %s.%s\n', lower(objecttype), line(6:end));
        elseif(length(line) >= 6 && strcmp(line(1:6), '     .'))
            % Same as above but with 5 spaces....
            fprintf(hOutfile, '%%     %s.%s\n', lower(objecttype), line(7:end));
        elseif(length(line) >= length(objecttype) && strcmpi(line(1:length(objecttype)), objecttype))
            % The example uses Brick.Function(...) style.
            % Ensure object is retrieved from the project object.
            if(~objectcreated)
                fprintf(hOutfile, '%% %s = project.%s();\n', lower(objecttype), objecttype);
                objectcreated = 1;
            end
            % Replace VBA-style object reference to MATLAB-style.
            line(1:length(objecttype)) = lower(objecttype);
            fprintf(hOutfile, '%%     %s\n', line);
        else
            % If it's not been handled, just copy it.
            fprintf(hOutfile, '%% %s\n', line);
        end
    end
end
fclose(hOutfile);


























