%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Group < handle
    properties(SetAccess = protected)
        project
        hGroup
        history
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Group object.
        function obj = Group(project, hProject)
            obj.project = project;
            obj.hGroup = hProject.invoke('Group');
        end
    end
    
    methods
        
        function Add(obj, name, type)
            % type: normal, mesh
            obj.project.AddToHistory(['Group.Add "', name, '", "', type, '"']);
        end
        
        function AddItem(obj, itemname, groupname)
            % itemname: solid$component:name
            %           port$portname
            obj.project.AddToHistory(['Group.AddItem "', itemname, '", "', groupname, '"']);
        end
    end
end
