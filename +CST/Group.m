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
