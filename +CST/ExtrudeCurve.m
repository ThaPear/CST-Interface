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

% This object enables an extrude operation on a curve item, which has to be closed and planar. The curve plane will be filled up as a solid with a specified thickness associated to a determined component and material. After that operation the curve item will not exist any longer. As soon as the new shape is created it will appear in the main plot window and on the Navigation Tree.
classdef ExtrudeCurve < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a ExtrudeCurve object.
        function obj = ExtrudeCurve(project, hProject)
            obj.project = project;
            obj.hExtrudeCurve = hProject.invoke('ExtrudeCurve');
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
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
            obj.component = [];
        end
        function Name(obj, solidname)
            % Sets the name of the new solid.
            obj.AddToHistory(['.Name "', num2str(solidname, '%.15g'), '"']);
            obj.name = solidname;
        end
        function Component(obj, componentname)
            % Sets the name of the component for the new solid. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
            obj.component = componentname;
        end
        function Material(obj, materialname)
            % Sets the material name for the new solid. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function Thickness(obj, thicknessvalue)
            % Sets the thickness which the extrude operation will take place. Thus it determines the extension of the resulting solid shape. Negative thickness settings will result in an extrusion into the opposite direction.
            obj.AddToHistory(['.Thickness "', num2str(thicknessvalue, '%.15g'), '"']);
        end
        function Twistangle(obj, twistvalue)
            % Sets the angle to twist the created shape around the direction of the extrusion.
            obj.AddToHistory(['.Twistangle "', num2str(twistvalue, '%.15g'), '"']);
        end
        function Taperangle(obj, tapervalue)
            % Sets the angle to taper the created shape along the direction of the extrusion. A negative angle will taper the shape, a positive angle will flare the shape.
            obj.AddToHistory(['.Taperangle "', num2str(tapervalue, '%.15g'), '"']);
        end
        function Curve(obj, curvename)
            % The name of the curve item the new solid should be created. The correct format for the name should be 'curvename:curveitemname' (see the example below). If the curve item (e.g. a line) is connected with an other curve item (e.g. a polygon) both curve items will be transformed into the new solid.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new solid. All necessary settings for this solid have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With ExtrudeCurve and append End With
            obj.history = [ 'With ExtrudeCurve', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define extrudecurve: ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end


        %% Undocumented functions.
        % Implemented from History List.
        function DeleteProfile(obj, boolean)
            % Should CST delete the curve after extruding it?
            obj.AddToHistory(['.DeleteProfile "', num2str(boolean, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hExtrudeCurve
        history

        name
        component
    end
end

%% Default Settings
% Material('Vacuum');
% Thickness(0.0)
% Twistangle(0.0)
% Taperangle(0.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% extrudecurve = project.ExtrudeCurve();
%     extrudecurve.Reset
%     extrudecurve.Name('solid2');
%     extrudecurve.Component('component1');
%     extrudecurve.Material('Vacuum');
%     extrudecurve.Thickness('2');
%     extrudecurve.Twistangle('0.0');
%     extrudecurve.Taperangle('0.0');
%     extrudecurve.Curve('curve1:circle1');
%     extrudecurve.Create
