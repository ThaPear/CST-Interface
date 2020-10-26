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

% NOTE: This object was introduced in CST 2020.
% Offers methods to create the ray results and register them in the result manager. The binary tree is used for the construction of the rays.
classdef RayResultCreator < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.RayResultCreator object.
        function obj = RayResultCreator(project, hProject)
            obj.project = project;
            obj.hRayResultCreator = hProject.invoke('RayResultCreator');
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their initial values.
            obj.hRayResultCreator.invoke('Reset');
        end
        function SetLastPointName(obj, labelName)
            % Define the node with given name to be able to visit them again and add  point to the "right" brunch. If it exists,  it will be rewritten.
            obj.hRayResultCreator.invoke('SetLastPointName', labelName);
        end
        function GoToPoint(obj, labelName)
            % Go to the node with given name. The next  point will be added to the "right" brunch in the binary tree. If it exists,  it will be rewritten.
            obj.hRayResultCreator.invoke('GoToPoint', labelName);
        end
        function EndRay(obj)
            % This commands ends the definition of the ray.
            obj.hRayResultCreator.invoke('EndRay');
        end
        function AddPointAndQuantity(obj, x, y, z, q)
            % Add a node with point coordinates x, y, z and the quantity value q to the tree. If the node is empty, the point is added to the "left"( reflection)  brunch in the binary tree, otherwise in the "right"( transition/refraction)
            obj.hRayResultCreator.invoke('AddPointAndQuantity', x, y, z, q);
        end
        function SetRayplotType(obj, Filter)
            % Set the interpolation mode.
            % Filter          Action
            % "discrete"      The quantity values are not interpolated between two points.
            % other(default)  The quantity values are t interpolated linear between two points.
            obj.hRayResultCreator.invoke('SetRayplotType', Filter);
        end
        function SetQuantityName(obj, q)
            % Define quantity name with given name, that should be stored in file.
            obj.hRayResultCreator.invoke('SetQuantityName', q);
        end
        function SetQuantityUnit(obj, unit)
            % Define unit with given name, that should be stored in file.  The unit string uses the syntax described on the Units help page.
            obj.hRayResultCreator.invoke('SetQuantityUnit', unit);
        end
        function WriteFile(obj, filename)
            % Write the result file with the given filename.
            obj.hRayResultCreator.invoke('WriteFile', filename);
        end
        function AddRayResult(obj, treepath)
            % Add the result t the tree with given tree path( i.e. "2D\3D Results\Rays\own result").
            obj.hRayResultCreator.invoke('AddRayResult', treepath);
        end
        function DeleteResult(obj)
            % Delete defined results.
            obj.hRayResultCreator.invoke('DeleteResult');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hRayResultCreator

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% rayresultcreator = project.RayResultCreator();
%     rayresultcreator.Reset
%     rayresultcreator.SetRayplotType('discrete');
%     rayresultcreator.SetQuantityName('Reflections');
%     rayresultcreator.SetQuantityUnit('1');
% Dim ray As Integer, num_rays As Integer
% Dim ystart As Double, zstart As Double
% ystart = -480.0
% zstart = 1760
% num_rays = 5
% For ray = 1 To num_rays
% Dim i As Integer, num As Integer
% num = 5
% Dim y As Double, z As Double, deltaY As Double, deltaZ As Double
% deltaY =(960-480) / num
% deltaZ =(1760-1340) / num
% y = ystart -(ray-1) *deltaY
% z = zstart
% For i = 1 To num
%     rayresultcreator.AddPointAndQuantity(1310.0, y, z, i)
%     rayresultcreator.SetLastPointName('1');
%     rayresultcreator.AddPointAndQuantity(1310.0, y, z - deltaZ, i)
%     rayresultcreator.GoToPoint('1');
%     rayresultcreator.AddPointAndQuantity(1310.0, y - deltaY, z, i)
% y = y - deltaY
% z = z - deltaZ
% Next i
%     rayresultcreator.EndRay
% Next ray
%     rayresultcreator.WriteFile('test.bix');
%     rayresultcreator.AddRayResult('2D/3D Results\Rays\ray');
% SelectTreeItem('2D/3D Results\Rays\ray');
%
%
%
