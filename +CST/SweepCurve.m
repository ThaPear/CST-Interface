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

% This object enables a sweep operation on a curve item. The item will be moved along a specified path represented by another curve item so that a solid structure is created. Constraint: The curve to be swept must be closed and planar. As soon as the new shape is created it will appear in the main plot window and on the Navigation Tree.
classdef SweepCurve < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.SweepCurve object.
        function obj = SweepCurve(project, hProject)
            obj.project = project;
            obj.hSweepCurve = hProject.invoke('SweepCurve');
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
        function Twistangle(obj, twistvalue)
            % Sets the angle to twist the created shape around the path curve.
            obj.AddToHistory(['.Twistangle "', num2str(twistvalue, '%.15g'), '"']);
        end
        function Taperangle(obj, tapervalue)
            % Sets the angle to taper the created shape along the path curve. A negative angle will taper the shape, a positive angle will flare the shape.
            obj.AddToHistory(['.Taperangle "', num2str(tapervalue, '%.15g'), '"']);
        end
        function ProjectProfileToPathAdvanced(obj, value)
            % If activated the profile curve is projected onto the path curve by aligning the profile curve with  the face normal defined by the path curve.
            obj.AddToHistory(['.ProjectProfileToPathAdvanced "', num2str(value, '%.15g'), '"']);
        end
        function Path(obj, pathname)
            % Specifies a curve item which will serve as a path for the sweep operation. The correct format for the name should be 'curvename:curveitemname' (see the example below). If the curve item (e.g. a line) is connected with an other curve item (e.g. a polygon) both curve items will be used as path.
            obj.AddToHistory(['.Path "', num2str(pathname, '%.15g'), '"']);
        end
        function Curve(obj, curvename)
            % Specifies the curve item which will be swept along the specified path. The correct format for the name should be 'curvename:curveitemname' (see the example below). If the curve item (e.g. a line) is connected with an other curve item (e.g. a polygon) both curve items will be swept along the path.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new solid. All necessary settings for this solid have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With SweepCurve and append End With
            obj.history = [ 'With SweepCurve', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define SweepCurve: ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hSweepCurve
        history

        name
        component
    end
end

%% Default Settings
% Material('Vacuum');
% Twistangle(0.0)
% Taperangle(0.0)
% ProjectProfileToPathAdvanced(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% sweepcurve = project.SweepCurve();
%     sweepcurve.Reset
%     sweepcurve.Name('solid1');
%     sweepcurve.Component('component1');
%     sweepcurve.Material('Vacuum');
%     sweepcurve.Twistangle('0.0');
%     sweepcurve.Taperangle('0.0');
%     sweepcurve.ProjectProfileToPathAdvanced('1');
%     sweepcurve.Path('curve1:line2');
%     sweepcurve.Curve('curve1:polygon1');
%     sweepcurve.Create
