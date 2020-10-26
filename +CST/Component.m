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

% The Component Object lets you define or change components. Each solid is
% sorted into a component.
classdef Component < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Component object.
        function obj = Component(project, hProject)
            obj.project = project;
            obj.hComponent = hProject.invoke('Component');

            obj.components = [];
        end
    end
    %% CST Object functions.
    methods
        function New(obj, name)
            % Creates a new component with the given name.
            %
            % Subcomponents are specified using 'parent/subcomp'

            % Delete the old one first.
            try
                if(obj.Exists(name))
                    fprintf('Deleting old component ''%s''', name);
                    obj.Delete(name);
                end
            catch exception %#ok<NASGU>
%                 breakpoint;
            end
            obj.project.AddToHistory(['Component.New "', name, '"']);
            name = strrep(strrep(name, ' ', '__'), '/', '__');
            obj.components.(name) = 1;
        end
        function Delete(obj, name)
            % Deletes an existing component and all the containing solids.
            obj.project.AddToHistory(['Component.Delete "', name, '"']);
            name = strrep(strrep(name, ' ', '__'), '/', '__');
            obj.components.(name) = 0;
        end
        function Rename(obj, oldname, newname)
            % Changes the name of an existing component.
            obj.project.AddToHistory(['Component.Rename "', oldname, '", '...
                                                       '"', newname, '"']);
            oldname = strrep(strrep(oldname, ' ', '__'), '/', '__');
            newname = strrep(strrep(newname, ' ', '__'), '/', '__');
            obj.components.(oldname) = 0;
            obj.components.(newname) = 1;
        end
        function name = GetNextFreeName(obj)
            % Returns the next unused component name.
            name = obj.hComponent.invoke('GetNextFreeName');
        end
        %% Utility functions.
        function number = GetNextFreeNameWithBase(obj, name)
            % Returns the next unused component name with given base.
            % e.g. component1, component2, etc...
            available = 0;
            i = 0;
            while(~available)
                i = i + 1;
                namei = [name, num2str(i)];
                namei = strrep(strrep(namei, ' ', '__'), '/', '__');
                if(~isfield(obj.components, namei) || ~obj.components.(namei))
                    available = 1;
                end
            end
            number = i;
        end
        function exists = Exists(obj, name)
            exists = isfield(obj.components, name) && obj.components.(name);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hComponent

        components % List of existing components.
    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% % Create a new component
% component = project.Component();
%     component.New('component1')
%
% % Rename an existing component
% component = project.Component();
%     component.Rename(;component1', 'MyComponent');