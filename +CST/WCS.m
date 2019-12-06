%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
        %% Extra methods, implemented by interface.
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
        %% General Methods
        function ActivateWCS(obj, axis)
            % This method allows to switch from global to local coordinates and reverse.
            % axis: 'local'
            %       'global'
            obj.AddToHistory(['.ActivateWCS "', num2str(axis, '%.15g'), '"']);
            obj.activatewcs = axis;
        end
        function Store(obj, WCSName)
            % Stores the active WCS with the given name.
            obj.AddToHistory(['.Store "', num2str(WCSName, '%.15g'), '"']);
            obj.store = WCSName;
        end
        function Restore(obj, WCSName)
            % Restores the WCS with the given name.
            obj.AddToHistory(['.Restore "', num2str(WCSName, '%.15g'), '"']);
            obj.restore = WCSName;
        end
        function Delete(obj, WCSName)
            % Deletes the WCS with the given name.
            obj.AddToHistory(['.Delete "', num2str(WCSName, '%.15g'), '"']);
            obj.delete = WCSName;
        end
        function Rename(obj, oldName, newName)
            % Changes the name of an already named WCS.
            obj.AddToHistory(['.Rename "', num2str(oldName, '%.15g'), '", '...
                                      '"', num2str(newName, '%.15g'), '"']);
            obj.rename.oldName = oldName;
            obj.rename.newName = newName;
        end
        %% Defining a WCS
        function SetNormal(obj, x, y, z)
            % Defines the Normal axis (w) of the Working Coordinate System (WCS) in global coordinates (x,y,z).
            obj.AddToHistory(['.SetNormal "', num2str(x, '%.15g'), '", '...
                                         '"', num2str(y, '%.15g'), '", '...
                                         '"', num2str(z, '%.15g'), '"']);
            obj.setnormal.x = x;
            obj.setnormal.y = y;
            obj.setnormal.z = z;
        end
        function SetOrigin(obj, x, y, z)
            % Defines the origin of the Working Coordinate System (WCS).
            obj.AddToHistory(['.SetOrigin "', num2str(x, '%.15g'), '", '...
                                         '"', num2str(y, '%.15g'), '", '...
                                         '"', num2str(z, '%.15g'), '"']);
            obj.setorigin.x = x;
            obj.setorigin.y = y;
            obj.setorigin.z = z;
        end
        function SetUVector(obj, x, y, z)
            % Define u-vector of the WCS coordinate system.
            obj.AddToHistory(['.SetUVector "', num2str(x, '%.15g'), '", '...
                                          '"', num2str(y, '%.15g'), '", '...
                                          '"', num2str(z, '%.15g'), '"']);
            obj.setuvector.x = x;
            obj.setuvector.y = y;
            obj.setuvector.z = z;
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
            % RotateWCS ( enum{ "u", "v", "w" } axis,   double angle )
            % Rotates the axis of the Working Coordinate System clockwise of about the angle degree.
            % mode: 'Point'
            %       '3Points'
            %       'Edge'
            %       'EdgeCenter'
            %       'RotationEdge'
            %       'Face'
            obj.AddToHistory(['.AlignWCSWithSelected "', num2str(mode, '%.15g'), '"']);
            obj.alignwcswithselected = mode;
        end
        function MoveWCS(obj, axis, du, dv, dw)
            % Shifts the Working Coordinate System (WCS). With the key option ”local” you can move the WCS about (du, dv, dw) in local coordinates. To move the WCS in global coordinates use the key setting ”global”.
            % axis,: 'global'
            %        'local'
            obj.AddToHistory(['.MoveWCS "', num2str(axis, '%.15g'), '", '...
                                       '"', num2str(du, '%.15g'), '", '...
                                       '"', num2str(dv, '%.15g'), '", '...
                                       '"', num2str(dw, '%.15g'), '"']);
            obj.movewcs.axis = axis;
            obj.movewcs.du = du;
            obj.movewcs.dv = dv;
            obj.movewcs.dw = dw;
        end
        function AlignWCSWithGlobalCoordinates(obj)
            % The position of the WCS will be changed to the position of the Global Coordinate System. In other words, a reset of the WCS into its origin position.
            obj.AddToHistory(['.AlignWCSWithGlobalCoordinates']);
        end
        %% WCS Appearance
        function SetWorkplaneSize(obj, wpSize)
            % The workplane is a square grid. This setting can be used to enlarge its size. The value wpSize defines the shortest distance between the origin and one of the sizes of the workplane. A value of wpSize smaller than the outer dimensions of a already defined structure will have no effect.
            obj.AddToHistory(['.SetWorkplaneSize "', num2str(wpSize, '%.15g'), '"']);
            obj.setworkplanesize = wpSize;
        end
        function SetWorkplaneRaster(obj, rasterSize)
            % Sets the raster width of the working plane.
            obj.AddToHistory(['.SetWorkplaneRaster "', num2str(rasterSize, '%.15g'), '"']);
            obj.setworkplaneraster = rasterSize;
        end
        function SetWorkplaneSnap(obj, flag)
            % Switches the snap option on or off. This causes that only input values that match the snap width can be input by mouse because the value will always be snapped to the snap raster.
            obj.AddToHistory(['.SetWorkplaneSnap "', num2str(flag, '%.15g'), '"']);
            obj.setworkplanesnap = flag;
        end
        function SetWorkplaneAutoadjust(obj, flag)
            % Switches the raster auto adjust option on or off. This causes an automatic change of  the raster size if the working plane is too large or too small.
            obj.AddToHistory(['.SetWorkplaneAutoadjust "', num2str(flag, '%.15g'), '"']);
            obj.setworkplaneautoadjust = flag;
        end
        function SetWorkplaneSnapAutoadjust(obj, flag)
            % Switches the snap width auto adjust option on or off. If enabled, the snap steps is dependent on zoom state, raster size, screen size and a factor given by SetWorkplaneAutosnapFactor. If switched off, the snap width is determined by SetWorkplaneSnapRaster alone.
            obj.AddToHistory(['.SetWorkplaneSnapAutoadjust "', num2str(flag, '%.15g'), '"']);
            obj.setworkplanesnapautoadjust = flag;
        end
        function SetWorkplaneAutosnapFactor(obj, autosnapFactor)
            % This value acts as a factor to the snap width if the auto flag for snapping is set. If you prefer bigger steps while snapping, use a bigger factor here. The default factor is 1.0 which yields to a snapping behavior of more or less the raster width in not zoomed state. This setting has only an effect on the interactive construction via mouse. The Snap Raster is a grid of snap points. Any point picked on the workplane is snapped to this grid. The Snap switch must be turned on, otherwise this setting will have no effect.
            obj.AddToHistory(['.SetWorkplaneAutosnapFactor "', num2str(autosnapFactor, '%.15g'), '"']);
            obj.setworkplaneautosnapfactor = autosnapFactor;
        end
        function SetWorkplaneSnapRaster(obj, snapRasterSize)
            % Sets the Snap Raster width. This setting has only an effect on the interactive construction via mouse and auto adjustment for snapping is turned off. The Snap Raster is a grid of snap points. If a point is picked by mouse near to one of these snap points, the selected point snaps to the grid point. The Snap switch must be turned on, otherwise this setting will have no effect.
            obj.AddToHistory(['.SetWorkplaneSnapRaster "', num2str(snapRasterSize, '%.15g'), '"']);
            obj.setworkplanesnapraster = snapRasterSize;
        end
        %% Queries
        % A general remark to Queries:
        % Those methods need special care in case of being used within macros that are added to the History List. During fast opening and Rebuilds, not all information is generally available that is queried by those methods. To improve the situation, it might be necessary to add some of the following commands to the macro or the beginning of the history:
        % ResultTree.UpdateTree()
        % FastModelLoad ("False")
        % IsWCSActive (  ) string <"local","global">
        
        % This method queries whether global or local coordinates are active
        function bool = DoesExist(obj, WCSName)
            % Checks if the WCS with the given name does exist.
            bool = obj.hWCS.invoke('DoesExist', WCSName);
            obj.doesexist = WCSName;
        end
        function bool = GetOrigin(obj, WCSName, x, y, z)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetOrigin''.');
            bool = nan;
            return;
            % Stores the origin of the specified* working coordinate system in x, y and z, returns True if successful.
            bool = obj.hWCS.invoke('GetOrigin', WCSName, x, y, z);
            obj.getorigin.WCSName = WCSName;
            obj.getorigin.x = x;
            obj.getorigin.y = y;
            obj.getorigin.z = z;
        end
        function bool = GetNormal(obj, WCSName, x, y, z)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetNormal''.');
            bool = nan;
            return;
            % Stores the normal of the specified* working coordinate system in x, y and z, returns True if successful.
            bool = obj.hWCS.invoke('GetNormal', WCSName, x, y, z);
            obj.getnormal.WCSName = WCSName;
            obj.getnormal.x = x;
            obj.getnormal.y = y;
            obj.getnormal.z = z;
        end
        function bool = GetUVector(obj, WCSName, x, y, z)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetUVector''.');
            bool = nan;
            return;
            % Stores the u-vector of the specified* working coordinate system in x, y and z, returns True if successful.
            % *If you don't specify a WCSName for the commands above (use an empty string instead), the current local coordinates system is queried instead.
            bool = obj.hWCS.invoke('GetUVector', WCSName, x, y, z);
            obj.getuvector.WCSName = WCSName;
            obj.getuvector.x = x;
            obj.getuvector.y = y;
            obj.getuvector.z = z;
        end
        function bool = GetAffineMatrixUVW2XYZ(obj, WCSName, ux, uy, uz, vx, vy, vz, wx, wy, wz)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetAffineMatrixUVW2XYZ''.');
            bool = nan;
            return;
            % Returns True if succeeded and fills the 9 parameters with the affine transformation matrix from the specified working coordinate system to the global coordinate system.
            bool = obj.hWCS.invoke('GetAffineMatrixUVW2XYZ', WCSName, ux, uy, uz, vx, vy, vz, wx, wy, wz);
            obj.getaffinematrixuvw2xyz.WCSName = WCSName;
            obj.getaffinematrixuvw2xyz.ux = ux;
            obj.getaffinematrixuvw2xyz.uy = uy;
            obj.getaffinematrixuvw2xyz.uz = uz;
            obj.getaffinematrixuvw2xyz.vx = vx;
            obj.getaffinematrixuvw2xyz.vy = vy;
            obj.getaffinematrixuvw2xyz.vz = vz;
            obj.getaffinematrixuvw2xyz.wx = wx;
            obj.getaffinematrixuvw2xyz.wy = wy;
            obj.getaffinematrixuvw2xyz.wz = wz;
        end
        function bool = GetAffineMatrixXYZ2UVW(obj, WCSName, ux, vx, wx, uy, vy, wy, uz, vz, wz)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetAffineMatrixXYZ2UVW''.');
            bool = nan;
            return;
            % Returns True if succeeded and fills the 9 parameters with the affine transformation matrix from the global coordinate system to the specified working coordinate system.
            bool = obj.hWCS.invoke('GetAffineMatrixXYZ2UVW', WCSName, ux, vx, wx, uy, vy, wy, uz, vz, wz);
            obj.getaffinematrixxyz2uvw.WCSName = WCSName;
            obj.getaffinematrixxyz2uvw.ux = ux;
            obj.getaffinematrixxyz2uvw.vx = vx;
            obj.getaffinematrixxyz2uvw.wx = wx;
            obj.getaffinematrixxyz2uvw.uy = uy;
            obj.getaffinematrixxyz2uvw.vy = vy;
            obj.getaffinematrixxyz2uvw.wy = wy;
            obj.getaffinematrixxyz2uvw.uz = uz;
            obj.getaffinematrixxyz2uvw.vz = vz;
            obj.getaffinematrixxyz2uvw.wz = wz;
        end
        function bool = GetWCSPointFromGlobal(obj, WCSName, u, v, w, x, y, z)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetWCSPointFromGlobal''.');
            bool = nan;
            return;
            % Fills u, v and w with the coordinates in the WCS of a point specified by the global coordinates, returns True if successful.
            bool = obj.hWCS.invoke('GetWCSPointFromGlobal', WCSName, u, v, w, x, y, z);
            obj.getwcspointfromglobal.WCSName = WCSName;
            obj.getwcspointfromglobal.u = u;
            obj.getwcspointfromglobal.v = v;
            obj.getwcspointfromglobal.w = w;
            obj.getwcspointfromglobal.x = x;
            obj.getwcspointfromglobal.y = y;
            obj.getwcspointfromglobal.z = z;
        end
        function bool = GetGlobalPointFromWCS(obj, WCSName, x, y, z, u, v, w)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetGlobalPointFromWCS''.');
            bool = nan;
            return;
            % Fills x, y and z with the global coordinates of a point specified by the local coordinates of the working coordinate system, returns True if successful.
            bool = obj.hWCS.invoke('GetGlobalPointFromWCS', WCSName, x, y, z, u, v, w);
            obj.getglobalpointfromwcs.WCSName = WCSName;
            obj.getglobalpointfromwcs.x = x;
            obj.getglobalpointfromwcs.y = y;
            obj.getglobalpointfromwcs.z = z;
            obj.getglobalpointfromwcs.u = u;
            obj.getglobalpointfromwcs.v = v;
            obj.getglobalpointfromwcs.w = w;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hWCS
        history
        bulkmode

        activatewcs
        store
        restore
        delete
        rename
        setnormal
        setorigin
        setuvector
        alignwcswithselected
        movewcs
        setworkplanesize
        setworkplaneraster
        setworkplanesnap
        setworkplaneautoadjust
        setworkplanesnapautoadjust
        setworkplaneautosnapfactor
        setworkplanesnapraster
        doesexist
        getorigin
        getnormal
        getuvector
        getaffinematrixuvw2xyz
        getaffinematrixxyz2uvw
        getwcspointfromglobal
        getglobalpointfromwcs
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
