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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generates the code for the CST.Project object to access all the objects.

clc;

% Get filenames of object files.
files = dir('CST-Interface/+CST/*.m');
filenames = {files.name};
ignored = {'Application.m', 'Project.m'};
[~, ind, ~] = intersect(filenames, ignored);
filenames(ind) = [];

% Sort filenames alphabetically.
[~,I] = sort(lower(filenames));
filenames = filenames(I);

% Remove all .m
c = cell(1, length(filenames)); c(:) = {'.m'};
c2 = cell(1, length(filenames)); c2(:) = {''};
objectnames = cellfun(@strrep, filenames, c, c2, 'UniformOutput', 0);

maxlength = max(cellfun(@length, filenames));
alignindex = ceil(maxlength/4)*4;

propertystring = sprintf('    properties(Access = protected)\n');
methodstring = sprintf('    methods\n');
for(i = 1:length(objectnames))
    objectname = objectnames{i};
    lobjectname = lower(objectname);
    funcname = objectname;
    
    % Special cases for naming.
    if(strcmpi(lobjectname, 'obj'));        lobjectname = 'obj_';       end
    if(strcmpi(lobjectname, 'transform_')); lobjectname = 'transform';  funcname = 'Transform'; end
    if(strcmpi(lobjectname, 'align_'));     lobjectname = 'align';      funcname = 'Align';     end
    
    spaces = repmat(' ', alignindex - length(lobjectname), 1);
    
    % These objects are not stored in project.
    if(   strcmpi(objectname, 'Result0D') ...
       || strcmpi(objectname, 'Result1D') ...
       || strcmpi(objectname, 'Result1DComplex') ...
       || strcmpi(objectname, 'Result3D') ...
       || strcmpi(objectname, 'ResultMap') ...
       || strcmpi(objectname, 'Table'))
        argname = 'resultname';
        if(strcmpi(objectname, 'ResultMap'))
            argname = 'treepath';
        elseif(strcmpi(objectname, 'Table'))
            argname = 'tablefilename';
        end
        propertystring = [propertystring, sprintf('%%         %s%sCST.%s\n', lobjectname, spaces, objectname)]; %#ok<AGROW>
        methodstring = [methodstring, sprintf('        function %s = %s(obj, resultname)\n', lobjectname, funcname), ...
                                      sprintf('%%             if(isempty(obj.%s))\n', lobjectname), ...
                                      sprintf('%%                 obj.%s = CST.%s(obj, obj.hProject, %s);\n', lobjectname, objectname, argname), ...
                                      sprintf('%%             end\n'), ...
                                      sprintf('%%             %s = obj.%s;\n', lobjectname, lobjectname), ...
                                      sprintf('            %% Each %s can be different depending on %s, so don''t store it.\n', lobjectname, argname), ...
                                      sprintf('            %s = CST.%s(obj, obj.hProject, resultname);\n', lobjectname, objectname), ...
                                      sprintf('        end\n')]; %#ok<AGROW>
    else
        propertystring = [propertystring, sprintf('        %s%sCST.%s\n', lobjectname, spaces, objectname)]; %#ok<AGROW>
        methodstring = [methodstring, sprintf('        function %s = %s(obj)\n', lobjectname, funcname), ...
                                      sprintf('            if(isempty(obj.%s))\n', lobjectname), ...
                                      sprintf('                obj.%s = CST.%s(obj, obj.hProject);\n', lobjectname, objectname), ...
                                      sprintf('            end\n'), ...
                                      sprintf('            %s = obj.%s;\n', lobjectname, lobjectname), ...
                                      sprintf('        end\n')]; %#ok<AGROW>
    end
end
propertystring = [propertystring, sprintf('    end\n')];
methodstring = [methodstring, sprintf('    end\n')];

fprintf('%s\n%s', propertystring, methodstring);