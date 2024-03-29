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

% Defines a working coordinate system which will be the base for the next new solids.
classdef WCS < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a WCS object.
        function obj = WCS(project, hProject)
            obj.project = project;
            obj.hWCS = hProject.invoke('WCS');
            obj.history = [];
			obj.bulkmode = 0;
        end
    end
    methods
        function StartBulkMode(obj)
            % Buffers all commands instead of sending them to CST
            % immediately.
            obj.bulkmode = 1;
        end
        function EndBulkMode(obj)
            % Flushes all commands since StartBulkMode to CST.
            obj.bulkmode = 0;
            % Prepend With WCS and append End With
            obj.history = [ 'With WCS', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define WCS settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['WCS', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        %% General Methods
        function ActivateWCS(obj, axis)
            % This method allows to switch from global to local coordinates and reverse.
            % axis: 'local'
            %       'global'
            obj.AddToHistory(['.ActivateWCS "', num2str(axis, '%.15g'), '"']);
        end
        function Store(obj, WCSName)
            % Stores the active WCS with the given name.
            obj.AddToHistory(['.Store "', num2str(WCSName, '%.15g'), '"']);
        end
        function Restore(obj, WCSName)
            % Restores the WCS with the given name.
            obj.AddToHistory(['.Restore "', num2str(WCSName, '%.15g'), '"']);
        end
        function Delete(obj, WCSName)
            % Deletes the WCS with the given name.
            obj.AddToHistory(['.Delete "', num2str(WCSName, '%.15g'), '"']);
        end
        function Rename(obj, oldName, newName)
            % Changes the name of an already named WCS.
            obj.AddToHistory(['.Rename "', num2str(oldName, '%.15g'), '", '...
                                      '"', num2str(newName, '%.15g'), '"']);
        end
        %% Defining a WCS
        function SetNormal(obj, x, y, z)
            % Defines the Normal axis (w) of the Working Coordinate System (WCS) in global coordinates (x,y,z).
            obj.AddToHistory(['.SetNormal "', num2str(x, '%.15g'), '", '...
                                         '"', num2str(y, '%.15g'), '", '...
                                         '"', num2str(z, '%.15g'), '"']);
        end
        function SetOrigin(obj, x, y, z)
            % Defines the origin of the Working Coordinate System (WCS).
            obj.AddToHistory(['.SetOrigin "', num2str(x, '%.15g'), '", '...
                                         '"', num2str(y, '%.15g'), '", '...
                                         '"', num2str(z, '%.15g'), '"']);
        end
        function SetUVector(obj, x, y, z)
            % Define u-vector of the WCS coordinate system.
            obj.AddToHistory(['.SetUVector "', num2str(x, '%.15g'), '", '...
                                          '"', num2str(y, '%.15g'), '", '...
                                          '"', num2str(z, '%.15g'), '"']);
        end
        function AlignWCSWithSelected(obj, mode)
            % Depending on mode does the following:
            % "Point": Moves the origin of the Working Coordinate System to the coordinates of the selected point.
            % "3Points": Aligns the Working Coordinate System with the plane of the three most recently selected points. The origin is placed at the first selected point, while the u axis is orientated from point No.1 to No.2.
            % "Edge": Aligns the WCS to the previously picked edge. The u axis will be parallel to the edge. If possible, the w axis will be preserved. If the edge is nonlinear, the direction will be taken from closest point on that edge relative to the current WCS.
            % "EdgeCenter": This moves the origin of the WCS to the center of the selected edge, the u axis will be aligned onto the edge's direction. If any faces are connected to the selected edge, the w axis of the WCS will be aligned to the normal of one of these faces. If not, the w axis will be preserved as much as possible.
            % "RotationEdge": This mode is used for defining the rotation axis of Rotate Objects. It does the same as the "Edge" mode but additionally moves the WCS to the start point of the picked edge.
            % "Face": For selected planar faces, the WCS will be moved to the face center. For all other faces it will be moved to the closest point on the face, relative to the current WCS. After moving, the w axis of the WCS (w axis) will be aligned to the normal of the face in the given point.
            % "EdgeAndFace": If the selected edge is not directly connected to the selected face, this will do the same as AlignWCSWithSelected "EdgeCenter". Else, this will place the WCS origin onto the middle of the selected edge; The u axis will be aligned to the direction of the selected edge in the given point. The w axis will be set to the normal of the selected face in the given point.
            % mode: 'Point'
            %       '3Points'
            %       'Edge'
            %       'EdgeCenter'
            %       'RotationEdge'
            %       'Face'

            obj.AddToHistory(['.AlignWCSWithSelected "', num2str(mode, '%.15g'), '"']);
        end
        function RotateWCS(obj, axis, angle)
            % Rotates the axis of the Working Coordinate System clockwise of about the angle degree.
            % axis: 'u'
            %       'v'
            %       'w'
            obj.AddToHistory(['.RotateWCS "', num2str(axis, '%.15g'), '", '...
                                         '"', num2str(angle, '%.15g'), '"']);
        end
        function MoveWCS(obj, axis, du, dv, dw)
            % Shifts the Working Coordinate System (WCS). With the key option "local" you can move the WCS about (du, dv, dw) in local coordinates. To move the WCS in global coordinates use the key setting "global".
            % axis,: 'global'
            %        'local'
            obj.AddToHistory(['.MoveWCS "', num2str(axis, '%.15g'), '", '...
                                       '"', num2str(du, '%.15g'), '", '...
                                       '"', num2str(dv, '%.15g'), '", '...
                                       '"', num2str(dw, '%.15g'), '"']);
        end
        function AlignWCSWithGlobalCoordinates(obj)
            % The position of the WCS will be changed to the position of the Global Coordinate System. In other words, a reset of the WCS into its origin position.
            obj.AddToHistory(['.AlignWCSWithGlobalCoordinates']);
        end
        %% WCS Appearance
        function SetWorkplaneSize(obj, wpSize)
            % The workplane is a square grid. This setting can be used to enlarge its size. The value wpSize defines the shortest distance between the origin and one of the sizes of the workplane. A value of wpSize smaller than the outer dimensions of a already defined structure will have no effect.
            obj.AddToHistory(['.SetWorkplaneSize "', num2str(wpSize, '%.15g'), '"']);
        end
        function SetWorkplaneRaster(obj, rasterSize)
            % Sets the raster width of the working plane.
            obj.AddToHistory(['.SetWorkplaneRaster "', num2str(rasterSize, '%.15g'), '"']);
        end
        function SetWorkplaneSnap(obj, flag)
            % Switches the snap option on or off. This causes that only input values that match the snap width can be input by mouse because the value will always be snapped to the snap raster.
            obj.AddToHistory(['.SetWorkplaneSnap "', num2str(flag, '%.15g'), '"']);
        end
        function SetWorkplaneAutoadjust(obj, flag)
            % Switches the raster auto adjust option on or off. This causes an automatic change of  the raster size if the working plane is too large or too small.
            obj.AddToHistory(['.SetWorkplaneAutoadjust "', num2str(flag, '%.15g'), '"']);
        end
        function SetWorkplaneSnapAutoadjust(obj, flag)
            % Switches the snap width auto adjust option on or off. If enabled, the snap steps is dependent on zoom state, raster size, screen size and a factor given by SetWorkplaneAutosnapFactor. If switched off, the snap width is determined by SetWorkplaneSnapRaster alone.
            obj.AddToHistory(['.SetWorkplaneSnapAutoadjust "', num2str(flag, '%.15g'), '"']);
        end
        function SetWorkplaneAutosnapFactor(obj, autosnapFactor)
            % This value acts as a factor to the snap width if the auto flag for snapping is set. If you prefer bigger steps while snapping, use a bigger factor here. The default factor is 1.0 which yields to a snapping behavior of more or less the raster width in not zoomed state. This setting has only an effect on the interactive construction via mouse. The Snap Raster is a grid of snap points. Any point picked on the workplane is snapped to this grid. The Snap switch must be turned on, otherwise this setting will have no effect.
            obj.AddToHistory(['.SetWorkplaneAutosnapFactor "', num2str(autosnapFactor, '%.15g'), '"']);
        end
        function SetWorkplaneSnapRaster(obj, snapRasterSize)
            % Sets the Snap Raster width. This setting has only an effect on the interactive construction via mouse and auto adjustment for snapping is turned off. The Snap Raster is a grid of snap points. If a point is picked by mouse near to one of these snap points, the selected point snaps to the grid point. The Snap switch must be turned on, otherwise this setting will have no effect.
            obj.AddToHistory(['.SetWorkplaneSnapRaster "', num2str(snapRasterSize, '%.15g'), '"']);
        end
        %% Queries
        % A general remark to Queries:
        % Those methods need special care in case of being used within macros that are added to the History List. During fast opening and Rebuilds, not all information is generally available that is queried by those methods. To improve the situation, it might be necessary to add some of the following commands to the macro or the beginning of the history:
        % ResultTree.UpdateTree()
        % FastModelLoad ("False")
        function active = IsWCSActive(obj)
            % This method queries whether global or local coordinates are active
            % active: 'local', 'global'
            active = obj.hWCS.invoke('IsWCSActive');
        end
        function bool = DoesExist(obj, WCSName)
            % Checks if the WCS with the given name does exist.
            bool = obj.hWCS.invoke('DoesExist', WCSName);
        end
        function [bool, x, y, z] = GetOrigin(obj, WCSName)
            % Stores the origin of the specified* working coordinate system in x, y and z, returns
            % True if successful.
            %
            % *If you don't specify a WCSName for the commands above (use an empty string instead),
            % the current local coordinates system is queried instead.
            if(nargin < 2)
                WCSName = '""';
            end
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim x As Double, y As Double, z As Double', newline, ...
                'bool = WCS.GetOrigin("', WCSName, '", x, y, z)', newline, ...
            ];
            returnvalues = {'bool', 'x', 'y', 'z'};
            [bool, x, y, z] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            x = str2double(x);
            y = str2double(y);
            z = str2double(z);
        end
        function [bool, x, y, z] = GetNormal(obj, WCSName)
            % Stores the normal of the specified* working coordinate system in x, y and z, returns
            % True if successful.
            %
            % *If you don't specify a WCSName for the commands above (use an empty string instead),
            % the current local coordinates system is queried instead.
            if(nargin < 2)
                WCSName = '""';
            end
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim x As Double, y As Double, z As Double', newline, ...
                'bool = WCS.GetNormal("', WCSName, '", x, y, z)', newline, ...
            ];
            returnvalues = {'bool', 'x', 'y', 'z'};
            [bool, x, y, z] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            x = str2double(x);
            y = str2double(y);
            z = str2double(z);
        end
        function [bool, x, y, z] = GetUVector(obj, WCSName)
            % Stores the u-vector of the specified* working coordinate system in x, y and z, returns
            % True if successful.
            %
            % *If you don't specify a WCSName for the commands above (use an empty string instead),
            % the current local coordinates system is queried instead.
            if(nargin < 2)
                WCSName = '""';
            end
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim x As Double, y As Double, z As Double', newline, ...
                'bool = WCS.GetUVector("', WCSName, '", x, y, z)', newline, ...
            ];
            returnvalues = {'bool', 'x', 'y', 'z'};
            [bool, x, y, z] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            x = str2double(x);
            y = str2double(y);
            z = str2double(z);
        end
        function [bool, ux, uy, uz, vx, vy, vz, wx, wy, wz] = GetAffineMatrixUVW2XYZ(obj, WCSName)
            % Returns True if succeeded and fills the 9 parameters with the affine transformation
            % matrix from the specified working coordinate system to the global coordinate system.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim ux As Double, uy As Double, uz As Double', newline, ...
                'Dim vx As Double, vy As Double, vz As Double', newline, ...
                'Dim wx As Double, wy As Double, wz As Double', newline, ...
                'bool = WCS.GetAffineMatrixUVW2XYZ("', WCSName, '", ux, uy, uz, vx, vy, vz, wx, wy, wz)', newline, ...
            ];
            returnvalues = {'bool', 'ux', 'uy', 'uz', 'vx', 'vy', 'vz', 'wx', 'wy', 'wz'};
            [bool, ux, uy, uz, vx, vy, vz, wx, wy, wz] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            ux = str2double(ux);
            uy = str2double(uy);
            uz = str2double(uz);
            vx = str2double(vx);
            vy = str2double(vy);
            vz = str2double(vz);
            wx = str2double(wx);
            wy = str2double(wy);
            wz = str2double(wz);
        end
        function [bool, ux, vx, wx, uy, vy, wy, uz, vz, wz] = GetAffineMatrixXYZ2UVW(obj, WCSName)
            % Returns True if succeeded and fills the 9 parameters with the affine transformation
            % matrix from the global coordinate system to the specified working coordinate system.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim ux As Double, uy As Double, uz As Double', newline, ...
                'Dim vx As Double, vy As Double, vz As Double', newline, ...
                'Dim wx As Double, wy As Double, wz As Double', newline, ...
                'bool = WCS.GetAffineMatrixXYZ2UVW("', WCSName, '", ux, uy, uz, vx, vy, vz, wx, wy, wz)', newline, ...
            ];
            returnvalues = {'bool', 'ux', 'uy', 'uz', 'vx', 'vy', 'vz', 'wx', 'wy', 'wz'};
            [bool, ux, uy, uz, vx, vy, vz, wx, wy, wz] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            ux = str2double(ux);
            uy = str2double(uy);
            uz = str2double(uz);
            vx = str2double(vx);
            vy = str2double(vy);
            vz = str2double(vz);
            wx = str2double(wx);
            wy = str2double(wy);
            wz = str2double(wz);
        end
        function [bool, u, v, w] = GetWCSPointFromGlobal(obj, WCSName, x, y, z)
            % Fills u, v and w with the coordinates in the WCS of a point specified by the global
            % coordinates, returns True if successful.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim u As Double, v As Double, w As Double', newline, ...
                'bool = WCS.GetWCSPointFromGlobal("', WCSName, '", u, v, w, ', num2str(x, '%.15g'), ', ', num2str(y, '%.15g'), ', ', num2str(z, '%.15g'), ')', newline, ...
            ];
            returnvalues = {'bool', 'u', 'v', 'w'};
            [bool, u, v, w] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            u = str2double(u);
            v = str2double(v);
            w = str2double(w);
        end
        function [bool, x, y, z] = GetGlobalPointFromWCS(obj, WCSName, u, v, w)
            % Fills x, y and z with the global coordinates of a point specified by the local
            % coordinates of the working coordinate system, returns True if successful.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim x As Double, y As Double, z As Double', newline, ...
                'bool = WCS.GetGlobalPointFromWCS("', WCSName, '", x, y, z, ', num2str(u, '%.15g'), ', ', num2str(v, '%.15g'), ', ', num2str(w, '%.15g'), ')', newline, ...
            ];
            returnvalues = {'bool', 'x', 'y', 'z'};
            [bool, x, y, z] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            x = str2double(x);
            y = str2double(y);
            z = str2double(z);
        end
        %% Utility functions.
        function Enable(obj)
            % Enables the local coordinate system.
            obj.ActivateWCS('local');
        end
        function Disable(obj)
            % Disables the local coordinate system.
            obj.ActivateWCS('global');
        end
        function Reset(obj)
            % Resets the origin to 0,0,0, and the normal to 0,0,1.
            obj.SetOrigin(0, 0, 0);
            obj.SetNormal(0, 0, 1);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hWCS
        history
        bulkmode

    end
end

%% Default Settings
% SetWorkplaneSnap(1)
% ActivateWCS('global');
% SetWorkplaneAutoadjust(1)
% SetWorkplaneSnapRaster(0.1)

%% Example - Taken from CST documentation and translated to MATLAB.
% wcs = project.WCS();
%     wcs.MoveWCS('local', 0.0, 'b+5', 10)
%
