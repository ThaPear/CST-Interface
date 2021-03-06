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

%% Creates CST Interface specific functions and headers.

% Create class header in output file.
% fprintf(hOutfile, '%s\n', ['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%', newline, ...
%                            '%%% CST Interface                                                       %%%', newline, ...
%                            '%%% Author: Alexander van Katwijk                                       %%%', newline, ...
%                            '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%', newline]);
fprintf(hOutfile, '%s\n', [ '% CST Interface - Interface with CST from MATLAB.',                            newline, ...
                            '% Copyright (C) 2020 Alexander van Katwijk',                                   newline, ...
                            '%',                                                                            newline, ...
                            '% This program is free software: you can redistribute it and/or modify',       newline, ...
                            '% it under the terms of the GNU General Public License as published by',       newline, ...
                            '% the Free Software Foundation, either version 3 of the License, or',          newline, ...
                            '% (at your option) any later version.',                                        newline, ...
                            '%',                                                                            newline, ...
                            '% This program is distributed in the hope that it will be useful,',            newline, ...
                            '% but WITHOUT ANY WARRANTY; without even the implied warranty of',             newline, ...
                            '% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the',              newline, ...
                            '% GNU General Public License for more details.',                               newline, ...
                            '%',                                                                            newline, ...
                            '% You should have received a copy of the GNU General Public License',          newline, ...
                            '% along with this program.  If not, see <https://www.gnu.org/licenses/>.',     newline, ...
                            '',                                                                             newline, ...
                            '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',  newline]);
fprintf(hOutfile, '%% %s\n', objectdescr);
fprintf(hOutfile, 'classdef %s < handle\n', objecttype);

histtype = input('History Type: (0) None, (1) Bulkmode, (2) Simple ');

% Create class constructor in output file.
fprintf(hOutfile, '    %%%% CST Interface specific functions.\n');
fprintf(hOutfile, '    methods(Access = ?CST.Project)\n');
fprintf(hOutfile, '        %% Only CST.Project can create a CST.%s object.\n', objecttype);
fprintf(hOutfile, '        function obj = %s(project, hProject)\n', objecttype);
fprintf(hOutfile, '            obj.project = project;\n');
fprintf(hOutfile, '            obj.h%s = hProject.invoke(''%s'');\n', objecttype, objecttype);
if(histtype ~= 0 && histtype ~= 3)
    fprintf(hOutfile, '            obj.history = [];\n');
end
if(histtype == 1)
    fprintf(hOutfile, '            obj.bulkmode = 0;\n');
end
fprintf(hOutfile, '        end\n');
fprintf(hOutfile, '    end\n');

% Create AddToHistory function.
switch(histtype)
    case 0
    case 1
        fprintf(hOutfile, '    methods\n');
        fprintf(hOutfile, '        function StartBulkMode(obj)\n');
        fprintf(hOutfile, '            %% Buffers all commands instead of sending them to CST\n');
        fprintf(hOutfile, '            %% immediately.\n');
        fprintf(hOutfile, '            obj.bulkmode = 1;\n');
        fprintf(hOutfile, '        end\n');
        fprintf(hOutfile, '        function EndBulkMode(obj)\n');
        fprintf(hOutfile, '            %% Flushes all commands since StartBulkMode to CST.\n');
        fprintf(hOutfile, '            obj.bulkmode = 0;\n');
        fprintf(hOutfile, '            %% Prepend With %s and append End With\n', objecttype);
        fprintf(hOutfile, '            obj.history = [ ''With %s'', newline, ...\n', objecttype);
        fprintf(hOutfile, '                                obj.history, ...\n');
        fprintf(hOutfile, '                            ''End With''];\n');
        fprintf(hOutfile, '            obj.project.AddToHistory([''define %s settings''], obj.history);\n', objecttype);
        fprintf(hOutfile, '            obj.history = [];\n');
        fprintf(hOutfile, '        end\n');
        fprintf(hOutfile, '        function AddToHistory(obj, command)\n');
        fprintf(hOutfile, '            if(obj.bulkmode)\n');
        fprintf(hOutfile, '                obj.history = [obj.history, ''     '', command, newline];\n');
        fprintf(hOutfile, '            else\n');
        fprintf(hOutfile, '                obj.project.AddToHistory([''%s'', command]);\n', objecttype);
        fprintf(hOutfile, '            end\n');
        fprintf(hOutfile, '        end\n');
        fprintf(hOutfile, '    end\n');
    case 2
        fprintf(hOutfile, '    methods\n');
        fprintf(hOutfile, '        function AddToHistory(obj, command)\n');
        fprintf(hOutfile, '            obj.history = [obj.history, ''     '', command, newline];\n');
        fprintf(hOutfile, '        end\n');
        fprintf(hOutfile, '    end\n');
    case 3
end

if(histtype == 2)
    createfunctionname = input('Which function should add everything to the CST history list and clear the MATLAB history list?\n', 's');
%     createconditional = input(sprintf('Add %sConditional as well? (y/n): ', createfunctionname), 's');
%     createconditional = strcmpi(createconditional, 'y');
else
    createfunctionname = '';
%     createconditional = 0;
end