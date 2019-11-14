%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The Component Object lets you define or change components. Each solid is
% sorted into a component.
classdef Component < handle
    properties(SetAccess = protected)
        project
        hComponent
        
        components % List of existing components.
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Component object.
        function obj = Component(project, hProject)
            obj.project = project;
            obj.hComponent = hProject.invoke('Component');
            
            obj.components = [];
        end
    end
    
    methods
        function New(obj, name)
            % Creates a new component with the given name.
            %
            % Subcomponents are specified using 'parent/subcomp'
            
            % Delete the old one first.
            try
                if(obj.Exists(name))
                    disp(['Deleting old component "', name, '"']);
                    obj.Delete(name);
                end
            catch exception %#ok<NASGU>
%                 breakpoint;
            end
            obj.project.AddToHistory(['Component.New "', name, '"']);
            name = strrep(name, '/', '__');
            obj.components.(name) = 1;
        end
        function Delete(obj, name)
            % Deletes an existing component and all the containing solids.
            obj.project.AddToHistory(['Component.Delete "', name, '"']);
            name = strrep(name, '/', '__');
            obj.components.(name) = 0;
        end
        function Rename(obj, oldname, newname)
            % Changes the name of an existing component.
            obj.project.AddToHistory(['Component.Rename "', oldname, '", '...
                                                       '"', newname, '"']);
            oldname = strrep(oldname, '/', '__');
            newname = strrep(newname, '/', '__');
            obj.components.(oldname) = 0;
            obj.components.(newname) = 1;
        end
        function name = GetNextFreeName(obj)
            % Returns the next unused component name.
            name = obj.hComponent.invoke('GetNextFreeName');
        end
        
        %%
        function number = GetNextFreeNameWithBase(obj, name)
            % Returns the next unused component name with given base.
            % e.g. component1, component2, etc...
            available = 0;
            i = 0;
            while(~available)
                i = i + 1;
                namei = [name, num2str(i)];
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
end

%% Example - Taken from CST documentation and translated to MATLAB.
% % Create a new component
% component = project.Component();
%     component.New('component1')
% 
% % Rename an existing component
% component = project.Component();
%     component.Rename(;component1', 'MyComponent');