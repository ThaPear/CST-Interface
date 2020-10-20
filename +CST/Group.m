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

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK>

% The Group Object lets you define or change the groups. Solids can be assigned to groups in order to facilitate changing the properties of multiple solids.
classdef Group < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Group object.
        function obj = Group(project, hProject)
            obj.project = project;
            obj.hGroup = hProject.invoke('Group');
            obj.history = [];
        end
    end
    methods
        function AddToHistory(obj, command)
            obj.project.AddToHistory(['Group', command]);
        end
    end
    %% CST Object functions.
    methods
        function Add(obj, groupname, type)
            % Creates a new group of a give type with the given name.
            % type: 'normal'
            %       'mesh'
            obj.AddToHistory(['.Add "', num2str(groupname, '%.15g'), '", '...
                                   '"', num2str(type, '%.15g'), '"']);
        end
        function Delete(obj, groupname)
            % Deletes a group. The solids assigned to this group will lose their assignment.
            obj.AddToHistory(['.Delete "', num2str(groupname, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Changes the name of an existing group.
            obj.AddToHistory(['.Rename "', num2str(oldname, '%.15g'), '", '...
                                      '"', num2str(newname, '%.15g'), '"']);
        end
        function AddItem(obj, name, groupname)
            % Adds an item to an existing group.
            obj.AddToHistory(['.AddItem "', num2str(name, '%.15g'), '", '...
                                       '"', num2str(groupname, '%.15g'), '"']);
        end
        function RemoveItem(obj, name, groupname)
            % Removes an item from an existing group.
            obj.AddToHistory(['.RemoveItem "', num2str(name, '%.15g'), '", '...
                                          '"', num2str(groupname, '%.15g'), '"']);
        end
        function NewFolder(obj, folder)
            % Creates a new group folder
            obj.AddToHistory(['.NewFolder "', num2str(folder, '%.15g'), '"']);
        end
        function RenameFolder(obj, oldname, newname)
            % Changes the name of an existing group folder.
            obj.AddToHistory(['.RenameFolder "', num2str(oldname, '%.15g'), '", '...
                                            '"', num2str(newname, '%.15g'), '"']);
        end
        function DeleteFolder(obj, folder)
            % Deletes a group folder
            obj.AddToHistory(['.DeleteFolder "', num2str(folder, '%.15g'), '"']);
        end
        function Reset(obj)
            % Removes all items from groups and then all groups are deleted.
            obj.AddToHistory(['.Reset']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hGroup
        history

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% % Create a new group
% Group.Add('group1', 'mesh');
% 
% % Rename an existing group
% Group.Rename('group1', 'MyGroup');
% 
% % Add a solid to a group
% Group.AddItem('solid$component1:solid1', 'MyGroup');
% 
% % Add a port to a group
% Group.AddItem('port$port1', 'MyGroup');
% 
% % Remove a solid from group
% Group.RemoveItem('solid$component1:solid1', 'MyGroup');
% 
% % Delete group
% Group.Delete('MyGroup');
