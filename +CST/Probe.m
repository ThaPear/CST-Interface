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
% Warning: Decoupling plane related functions might not work as expected.
%          I don't know if those settings are global or per-probe.
%          They are currently set per-probe, which means they require a .Create to be applied.

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK>

% Defines probes within your structure that store one field component at that location. The field values during time as well as the corresponding S-Parameter are stored. You may have either electric or magnetic field probes in nearfield as well as in farfield region.
classdef Probe < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Probe object.
        function obj = Probe(project, hProject)
            obj.project = project;
            obj.hProbe = hProject.invoke('Probe');
            obj.history = [];
        end
    end
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal values to their default settings.
            obj.AddToHistory(['.Reset']);

            obj.id = [];
        end
        function ID(obj, id)
            % Set the ID to be used for the next probe to created. If it is not set or set to a value smaller than zero, an ID will automatically be generated. See also "GetNextValidId" and "GetLastAddedId". To ensure backward compatibility, the caption of a probe still needs to be unique for each probe. However, probes should be handled using the integer value used as ID.
            obj.AddToHistory(['.ID "', num2str(id, '%.15g'), '"']);
            obj.id = id;
        end
        function AutoLabel(obj, flag)
            % If true the caption of the probe will be generated out of its type and its position. It will be updated accordingly once the position will change (due to transformations or parameter changes) and makes sure the caption is always unique
            obj.AddToHistory(['.AutoLabel "', num2str(flag, '%.15g'), '"']);
        end
        function Field(obj, fieldType)
            % Selects whether the probe should monitor an electric ("efield") or magnetic ("hfield") field inside the calculation domain or an electric ("efarfield") or magnetic ("hfarfield") farfield or RCS values.
            % fieldType: 'efield'
            %            'hfield'
            %            'efarfield'
            %            'hfarfield'
            %            'rcs'
            obj.AddToHistory(['.Field "', num2str(fieldType, '%.15g'), '"']);
        end
        function fieldType = GetField(obj)
            % Returns the field type of the currently selected probe. The selection is done either with the GetFirst or the GetNext function.
            % fieldType: 'efield'
            %            'hfield'
            %            'efarfield'
            %            'hfarfield'
            %            'rcs'
            fieldType = obj.hProbe.invoke('GetField');
        end
        function Create(obj)
            % Creates the probe.
            obj.AddToHistory(['.Create']);

            % Prepend With Probe and append End With
            obj.history = [ 'With Probe', newline, ...
                                obj.history, ...
                            'End With'];
            if(~isempty(obj.id))
                obj.project.AddToHistory(['define Probe: ', num2str(obj.id, '%.15g')], obj.history);
            else
                obj.project.AddToHistory(['define Probe'], obj.history);
            end
            obj.history = [];
        end
        function long = GetNextValidId(obj)
            % Returns the ID for the next probe to be generated. In most cases you will not need this function, since the ID can be generated automatically by the Create method.
            long = obj.hProbe.invoke('GetNextValidId');
        end
        function long = GetLastAddedId(obj)
            % Returns the last ID automatically generated by the Create method.
            long = obj.hProbe.invoke('GetLastAddedId');
        end
        function string = GetCaption(obj, id)
            % Returns the current caption of a given Probe. To ensure backward compatibility the caption of a probe still needs to be unique for each probe. However, probes should be handled using the integer value used as ID.
            string = obj.hProbe.invoke('GetCaption', id);
        end
        function DeleteById(obj, id)
            % Deletes the probe with the given ID.
            obj.project.AddToHistory(['Probe.DeleteById "', num2str(id, '%.15g'), '"']);
        end
        function NewCaption(obj, id, caption)
            % Assigns a new caption to the probe with the given ID.
            obj.project.AddToHistory(['Probe.NewCaption "', num2str(id, '%.15g'), '", '...
                                                       '"', num2str(caption, '%.15g'), '"']);
        end
        function Name(obj, probeName)
            % WARNING: Deprecated
            % Deprecated sine version 2016. Use "ID" and "NewCaption" instead. Sets the name for the probe to probeName.
            obj.AddToHistory(['.Name "', num2str(probeName, '%.15g'), '"']);
        end
        function Rename(obj, oldName, newName)
            % WARNING: Deprecated
            % Deprecated sine version 2016. Use "NewCaption" instead. Renames an already existing probe from oldName to newName.
            obj.project.AddToHistory(['Probe.Rename "', num2str(oldName, '%.15g'), '", '...
                                                   '"', num2str(newName, '%.15g'), '"']);
        end
        function name = GetName(obj)
            % WARNING: Deprecated
            % Deprecated sine version 2016. Use "GetCaption" instead. Returns the name of the currently selected probe. The selection is done either with the GetFirst or the GetNext function.
            name = obj.hProbe.invoke('GetName');
        end
        function Delete(obj, probeName)
            % WARNING: Deprecated
            % Deletes the probe named probeName.
            obj.project.AddToHistory(['Probe.Delete "', num2str(probeName, '%.15g'), '"']);
        end
        %% Methods Concerning Probe Position and Orientation
        function Xpos(obj, pos)
            % Defines the position of the probe for the respective coordinate direction.
            obj.AddToHistory(['.Xpos "', num2str(pos, '%.15g'), '"']);
        end
        function Ypos(obj, pos)
            % Defines the position of the probe for the respective coordinate direction.
            obj.AddToHistory(['.Ypos "', num2str(pos, '%.15g'), '"']);
        end
        function Zpos(obj, pos)
            % Defines the position of the probe for the respective coordinate direction.
            obj.AddToHistory(['.Zpos "', num2str(pos, '%.15g'), '"']);
        end
        function SetPosition1(obj, pos)
            % Defines the first, second or third  farfield coordinate parameter of the probe due to the selected coordinate system (using SetCoordinateSystemType method).
            obj.AddToHistory(['.SetPosition1 "', num2str(pos, '%.15g'), '"']);
        end
        function SetPosition2(obj, pos)
            % Defines the first, second or third  farfield coordinate parameter of the probe due to the selected coordinate system (using SetCoordinateSystemType method).
            obj.AddToHistory(['.SetPosition2 "', num2str(pos, '%.15g'), '"']);
        end
        function SetPosition3(obj, pos)
            % Defines the first, second or third  farfield coordinate parameter of the probe due to the selected coordinate system (using SetCoordinateSystemType method).
            % The actual coordinate component with SetPostion1/2/3 is listed below depending on the coordinate system type:
            % Coordinate System Type      Parameter 1     Parameter 2     Parameter 3
            % Cartesian                   X               Y               Z
            % Spherical                   Theta           Phi             Radius
            % Ludwig 2 Azim. over Elev.   Elevation       Azimuth         Radius
            % Ludwig 2 Elev. over Azim.   Alpha           Epsilon         Radius
            % Ludwig 3                    Theta           Phi             Radius
            % Please note that Cartesian uses global coordinates while all Spherical / Ludwig coordinates are relative to the probe origin.
            obj.AddToHistory(['.SetPosition3 "', num2str(pos, '%.15g'), '"']);
        end
        function Orientation(obj, orientType)
            % Defines the orientation of the probe regarding the coordinate system type set with SetCoordinateSystemType and therefore the field component that is monitored.
            % orientType can have one of the following values:
            % "x"             component in x-direction of the cartesian coordinate system
            % "y"             component in y-direction of the cartesian coordinate system
            % "z"             component in z-direction of cartesian coordinate system
            % "all"           create a set of probes with all the available orientations depending on the coordinate system.  For instance for the cartesian coordinate system the probes are generated in the x-, y- and z- direction whereas for the spherical coordinate system the probes are in the theta- and phi- direction. The option allows to inspect all the field components at the same time together with the global field magnitude computation.
            % "theta"         component in theta-direction of spherical coordinate system
            % "phi"           component in phi-direction of spherical coordinate system
            % "radial"        component in radial-direction of spherical and Ludwig2/3 coordinate systems
            % "azimuth"       component in azimuth-direction of Ludwig 2 Azim. over Elev. coordinate system
            % "elevation"     component in elevation-direction of Ludwig 2 Azim. over Elev. coordinate system
            % "epsilon"       component in epsilon-direction of Ludwig 2 Elev. over Azim. coordinate system
            % "alpha"         component in alpha-direction of Ludwig 2 Elev. over Azim. coordinate system
            % "horizontal"    component in horizontal-direction of Ludwig 3 coordinate system
            % "vertical"      component in vertical-direction of Ludwig 3 coordinate system
            % Note: Using the orientType  "all" the global field magnitude of a probe signal in the time domain is computed with the standard norm of a vector according to the formula
            % Here F represents any real valued field vector and the sum is performed over the field components.
            % In case of a probe spectra in the frequency domain the global field magnitude is computed according to the maximum field amplitude defined by the formula (here F represents any complex valued field vector)
            % This definition is consistent with the 2D and 3D field monitor processing, see also the 2D and 3D Field Results / Evaluate Field in arbitrary Coordinates and Probe General pages.
            obj.AddToHistory(['.Orientation "', num2str(orientType, '%.15g'), '"']);
        end
        %% Queries Concerning Probe Position and Orientation
        function double = GetPosition1(obj)
            % Returns the first, second or third component of the position of the currently selected probe, depending on the corresponding coordinate system type, respectively.The selection of the probe is done either with the GetFirst or the GetNext function.
            double = obj.hProbe.invoke('GetPosition1');
        end
        function double = GetPosition2(obj)
            % Returns the first, second or third component of the position of the currently selected probe, depending on the corresponding coordinate system type, respectively. The selection of the probe is done either with the GetFirst or the GetNext function.
            double = obj.hProbe.invoke('GetPosition2');
        end
        function double = GetPosition3(obj)
            % Returns the first, second or third component of the position of the currently selected probe, depending on the corresponding coordinate system type, respectively. The selection of the probe is done either with the GetFirst or the GetNext function.
            double = obj.hProbe.invoke('GetPosition3');
        end
        function double = GetXPos(obj)
            % Returns the position of the probe for the respective coordinate direction.
            double = obj.hProbe.invoke('GetXPos');
        end
        function double = GetYPos(obj)
            % Returns the position of the probe for the respective coordinate direction.
            double = obj.hProbe.invoke('GetYPos');
        end
        function double = GetZPos(obj)
            % Returns the position of the probe for the respective coordinate direction.
            double = obj.hProbe.invoke('GetZPos');
        end
        function enum = GetOrientation(obj)
            % Returns the orientation of the probe as a string value orientType. Please find the meaning of the different string values in the description of the Orientation method above.
            % The selection of the probe is done either with the GetFirst or the GetNext function.
            enum = obj.hProbe.invoke('GetOrientation');
        end
        function double = GetTheta(obj)
            % Returns the location of the probe in spherical coordinates. The selection of the probe is done either with the GetFirst or the GetNext function.
            double = obj.hProbe.invoke('GetTheta');
        end
        function double = GetPhi(obj)
            % Returns the location of the probe in spherical coordinates. The selection of the probe is done either with the GetFirst or the GetNext function.
            double = obj.hProbe.invoke('GetPhi');
        end
        function double = GetRadius(obj)
            % Returns the location of the probe in spherical coordinates. The selection of the probe is done either with the GetFirst or the GetNext function.
            double = obj.hProbe.invoke('GetRadius');
        end
        function double = GetXComp(obj)
            % Returns the orientation of the probe in cartesian coordinates. The selection of the probe is done either with the GetFirst or the GetNext function.
            double = obj.hProbe.invoke('GetXComp');
        end
        function double = GetYComp(obj)
            % Returns the orientation of the probe in cartesian coordinates. The selection of the probe is done either with the GetFirst or the GetNext function.
            double = obj.hProbe.invoke('GetYComp');
        end
        function double = GetZComp(obj)
            % Returns the orientation of the probe in cartesian coordinates. The selection of the probe is done either with the GetFirst or the GetNext function.
            double = obj.hProbe.invoke('GetZComp');
        end
        %% Methods Concerning Farfield Specials
        function SetCoordinateSystemType(obj, coordType)
            % Sets or returns the coordinate system type for a farfield probe, respectively. For the GetCoordinateSystemType method the selection of the probe is done either with the GetFirst or the GetNext function.
            % coordType can have one of the following values:
            % ”Cartesian”     Cartesian coordinate system
            % ”Spherical”     Spherical coordinate system
            % ”Ludwig2ae”     Ludwig 2 Azimuth over Elevation coordinate system
            % ”Ludwig2ea”     Ludwig 2 Elevation over Azimuth coordinate system
            % ”Ludwig3”       Ludwig 3 coordinate system
            obj.AddToHistory(['.SetCoordinateSystemType "', num2str(coordType, '%.15g'), '"']);
        end
        function coordType = GetCoordinateSystemType(obj)
            % Sets or returns the coordinate system type for a farfield probe, respectively. For the GetCoordinateSystemType method the selection of the probe is done either with the GetFirst or the GetNext function.
            % coordType can have one of the following values:
            % ”Cartesian”     Cartesian coordinate system
            % ”Spherical”     Spherical coordinate system
            % ”Ludwig2ae”     Ludwig 2 Azimuth over Elevation coordinate system
            % ”Ludwig2ea”     Ludwig 2 Elevation over Azimuth coordinate system
            % ”Ludwig3”       Ludwig 3 coordinate system
            coordType = obj.hProbe.invoke('GetCoordinateSystemType');
        end
        function Origin(obj, originType)
            % The origin type of all farfield probes.
            % originType can have one of the following values:
            % ”bbox”  The center of the bounding box of the structure.
            % ”zero”  Origin of coordinate system.
            % ”free”  Any desired point defined by Userorigin
            obj.project.AddToHistory(['Probe.Origin "', num2str(originType, '%.15g'), '"']);
        end
        function Userorigin(obj, x, y, z)
            % Sets origin of the farfield probe calculation if the origin type is set to ”free”.
            obj.project.AddToHistory(['Probe.Userorigin "', num2str(x, '%.15g'), '", '...
                                                       '"', num2str(y, '%.15g'), '", '...
                                                       '"', num2str(z, '%.15g'), '"']);
        end
        function UseDecouplingPlane(obj, bFlag)
            % Enables or disables a decoupling plane for a farfield probe calculation.
            obj.AddToHistory(['.UseDecouplingPlane "', num2str(bFlag, '%.15g'), '"']);
        end
        function DecouplingPlaneAxis(obj, axis)
            % This command sets the normal of user defined decoupling plane. The normal is always aligned with one of the three cartesian coordinate axes x, y, or z.
            % axis: 'x'
            %       'y'
            %       'z'
            obj.AddToHistory(['.DecouplingPlaneAxis "', num2str(axis, '%.15g'), '"']);
        end
        function DecouplingPlanePosition(obj, position)
            % Enter here the coordinate of the user defined decoupling plane in normal direction.
            obj.AddToHistory(['.DecouplingPlanePosition "', num2str(position, '%.15g'), '"']);
        end
        function SetDecouplingMirrorPlane(obj, bFlag)
            % If activated a user defined decoupling plane for a  farfield probe calculation is used instead of an automatically detected decoupling plane.
            obj.AddToHistory(['.SetDecouplingMirrorPlane "', num2str(bFlag, '%.15g'), '"']);
        end
        %% Probe Iteration
        function long = GetFirst(obj)
            % Selects the first probe in the internal probe list and returns 1 on success and 0 if no probes are defined. The following probes of the list are then selectable using the GetNext function.
            long = obj.hProbe.invoke('GetFirst');
        end
        function long = GetNext(obj)
            % Selects the next probe in the internal probe list and returns 1 on success and 0 if no probes are defined. The first probe of the list is selectable using the GetFirst function.
            long = obj.hProbe.invoke('GetNext');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hProbe
        history

        id
    end
end

%% Default Settings
% ID -1
% AutoLabel 0
% Field('efield');
% Xpos(0.0)
% Ypos(0.0)
% Zpos(0.0)
% Orientation('x');
% SetCoordinateSystemType('Cartesian');
% Origin('bbox');
% Userorigin(0.0, 0.0, 0.0)
% UseMirrorPlane(0)
% MirrorPlaneAxis('x');
% MirrorPlanePosition(0.0)
% SetUserMirrorPlane(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% probe = project.Probe();
% .Reset
% .ID 0
% .AutoLabel 1
% .Field('efarfield');
% .SetCoordinateSystemType('Spherical');
% .SetPosition1(90.0)
% .SetPosition2(0.0)
% .SetPosition3(1.0)
% .Orientation('Theta');
% .Origin('zero');
% .Create
%
