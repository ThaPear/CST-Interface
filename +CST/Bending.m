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

% This object is used to bend a planar sheet on a solid shape.
classdef Bending < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Bending object.
        function obj = Bending(project, hProject)
            obj.project = project;
            obj.hBending = hProject.invoke('Bending');
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
        function ParamSweepAndOptimizerChecksResult(obj, boolean)
            % To activate a check routine performed during a parameter sweep or optimizer calculation. The check verifies whether the sheets are entirely bent on the solid.
            obj.AddToHistory(['.ParamSweepAndOptimizerChecksResult "', num2str(boolean, '%.15g'), '"']);
        end
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);

            obj.sheet = [];
            obj.solid = [];
        end
        function Sheet(obj, sheetname)
            % Sets the name of the sheet to bend..
            obj.AddToHistory(['.Sheet "', num2str(sheetname, '%.15g'), '"']);
            obj.sheet = sheetname;
        end
        function Solid(obj, solidname)
            % Sets the name of the solid to bend on.
            obj.AddToHistory(['.Solid "', num2str(solidname, '%.15g'), '"']);
            obj.solid = solidname;
        end
        function Faces(obj, list)
            % Sets the list of faces to bend on. The faces are specified by the face ids. For example: "10,9,8,7".
            if(any(isnumeric(list)))
                % Convert MATLAB array to correct string format.
                list = strcat(strsplit(num2str(a)), ',');
                list = [list{:}];
                list = list(1:end-1);
            end
            obj.AddToHistory(['.Faces "', num2str(list, '%.15g'), '"']);
        end
        function Bend(obj)
            % Performs the bending operation.
            obj.AddToHistory(['.Bend']);

            % Prepend With Bending and append End With
            obj.history = [ 'With Bending', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Bending: ', obj.sheet, ' on ', obj.solid], obj.history);
            obj.history = [];
        end
        %% CST 2019 Functions.
        function Stackup(obj, stackupname)
            % Sets the name of the folder which will be used for the layer stackup bending. The shapes in this folder are used for the bending operation. This can be a material or group folder. For example: "material$Folder1".
            obj.AddToHistory(['.Stackup "', num2str(stackupname, '%.15g'), '"']);
        end
        function Shape(obj, shapename)
            % Sets the name of the shape which will be used for the layer stackup bending. Several shape names can be used. You may not use the commands Stackup and Shape at the same time.
            obj.AddToHistory(['.Shape "', num2str(shapename, '%.15g'), '"']);
        end
        function FlexBending(obj, boolean)
            % This flag is only used by a layer stackup bending. The default is "True" and means that the length of the layers will be adapted flexible such that they match together after the bending.
            obj.AddToHistory(['.FlexBending "', num2str(boolean, '%.15g'), '"']);
        end
        function CylindricalBend(obj, solidname, onesided, angle, radius, length)
            % Performs a bending around a virtual cylinder defined by either an angle or an radius. Either the angle or the radius must be zero. The position and orientation of the cylinder is determined by setting the local WCS. The y-axis and the x-axis of the local WCS define the "neutral plane" of the bend. This is the area where the material will neither be stretched nor compressed when wrapping the solid around the virtual cylinder. The z-axis defines the direction of the bend. The flag "onesided" indicated whether only the half-space to the local x-direction will be bend or both sides. The length parameter allows it to restrict the effect to a certain area.
            obj.AddToHistory(['.CylindricalBend "', num2str(solidname, '%.15g'), '", '...
                                               '"', num2str(onesided, '%.15g'), '", '...
                                               '"', num2str(angle, '%.15g'), '", '...
                                               '"', num2str(radius, '%.15g'), '", '...
                                               '"', num2str(length, '%.15g'), '"']);

            % Prepend With Bending and append End With
            obj.history = [ 'With Bending', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Bending: ', obj.sheet, ' on ', obj.solid], obj.history);
            obj.history = [];
        end
        %% CST 2020 Functions.
        function Centralized(obj, onesided)
            % Sets the impact direction of the cylindrical bending operation. False indicates a one-sided direction which means that only the half-space of the u-axis will be bent. True indicates that the bending is performed along the entire u-axis.
            obj.AddToHistory(['.Centralized "', num2str(onesided, '%.15g'), '"']);
        end
        function Angle(obj, angle)
            % Sets the angle of the cylinder around which the items are going to be bent. Either the angle or the radius must be zero.
            obj.AddToHistory(['.Angle "', num2str(angle, '%.15g'), '"']);
        end
        function Radius(obj, radius)
            % Sets the radius of the cylinder around which the items are going to be bent. Either the angle or the radius must be zero.
            obj.AddToHistory(['.Radius "', num2str(radius, '%.15g'), '"']);
        end
        function ULength(obj, length)
            % Optionally, the u-length can be specified to limit the bending region along the u-axis of the local WCS.
            obj.AddToHistory(['.ULength "', num2str(length, '%.15g'), '"']);
        end
        function VLength(obj, length)
            % Optionally, the v-length can be specified to limit the bending region along the v-axis of the local WCS.
            obj.AddToHistory(['.VLength "', num2str(length, '%.15g'), '"']);
        end
        function ReferenceSolid(obj, shapename)
            % Sets the name of the reference solid. The reference solid is used internally to determine whether unconnected items shall be bent. If the reference solid is not specified then the algorithm determines an internally reference solid by uniting all items which shall be bent. This operation can be very time-consuming therefore it is recommended to use a reference solid when many shapes shall be bent.
            obj.AddToHistory(['.ReferenceSolid "', num2str(shapename, '%.15g'), '"']);
        end
        function FlexBend(obj)
            % Performs the cylindrical bending operation around a virtual cylinder defined by either an angle or an radius. The position and orientation of the cylinder is determined by setting the local WCS.
            obj.AddToHistory(['.FlexBend']);

            % Prepend With Bending and append End With
            obj.history = [ 'With Bending', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Bending'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hBending
        history

        sheet
        solid
    end
end

%% Default Settings
% Sheet('');
% Solid('');
% Faces('');

%% Example - Taken from CST documentation and translated to MATLAB.
% bending = project.Bending();
% bending.Reset
% bending.Sheet('component1:sheet');
% bending.Solid('component2:solid1');
% bending.Faces('10,9,8,7');
% bending.Bend
