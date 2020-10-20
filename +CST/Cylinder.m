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

% This object is used to create a new cylinder shape.
classdef Cylinder < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Cylinder object.
        function obj = Cylinder(project, hProject)
            obj.project = project;
            obj.hCylinder = hProject.invoke('Cylinder');
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
        function Name(obj, cylindername)
            % Sets the name of the cylinder.
            obj.AddToHistory(['.Name "', num2str(cylindername, '%.15g'), '"']);
            obj.name = cylindername;
        end
        function Component(obj, componentname)
            % Sets the name of the component for the new cylinder. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
            obj.component = componentname;
        end
        function Material(obj, materialname)
            % Sets the material name for the new cylinder. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function Axis(obj, direction)
            % Sets the axis of the cylinder. According to this setting, either Xrange, Yrange or Zrange need to be set for the extension of the cylinder along the axis.
            % direction: 'x'
            %            'y'
            %            'z'
            obj.AddToHistory(['.Axis "', num2str(direction, '%.15g'), '"']);
        end
        function Outerradius(obj, radius)
            % Sets the outer radius of the cylinder.
            obj.AddToHistory(['.Outerradius "', num2str(radius, '%.15g'), '"']);
        end
        function OuterRadius(obj, radius)
            % Sets the outer radius of the cylinder.
            obj.Outerradius(radius);
        end
        function Innerradius(obj, radius)
            % Sets the inner radius of the cylinder. This setting may be set to zero to define a solid cylinder.
            obj.AddToHistory(['.Innerradius "', num2str(radius, '%.15g'), '"']);
        end
        function InnerRadius(obj, radius)
            % Sets the inner radius of the cylinder. This setting may be set to zero to define a solid cylinder.
            obj.Innerradius(radius);
        end
        function Xcenter(obj, centercoordinate)
            % Sets the x- or u-coordinate of the center point of the bottom face of the cylinder, depending on whether a local coordinate system is active or not.
            obj.AddToHistory(['.Xcenter "', num2str(centercoordinate, '%.15g'), '"']);
        end
        function Ycenter(obj, centercoordinate)
            % Sets the y- or v-coordinate of the center point of the bottom face of the cylinder, depending on whether a local coordinate system is active or not.
            obj.AddToHistory(['.Ycenter "', num2str(centercoordinate, '%.15g'), '"']);
        end
        function Zcenter(obj, centercoordinate)
            % Sets the z- or w-coordinate of the center point of the bottom face of the cylinder, depending on whether a local coordinate system is active or not.
            obj.AddToHistory(['.Zcenter "', num2str(centercoordinate, '%.15g'), '"']);
        end
        function XCenter(obj, centercoordinate)
            % Sets the x- or u-coordinate of the center point of the bottom face of the cylinder, depending on whether a local coordinate system is active or not.
            obj.Xcenter(centercoordinate);
        end
        function YCenter(obj, centercoordinate)
            % Sets the y- or v-coordinate of the center point of the bottom face of the cylinder, depending on whether a local coordinate system is active or not.
            obj.Ycenter(centercoordinate);
        end
        function ZCenter(obj, centercoordinate)
            % Sets the z- or w-coordinate of the center point of the bottom face of the cylinder, depending on whether a local coordinate system is active or not.
            obj.Zcenter(centercoordinate);
        end
        function Xrange(obj, xmin, xmax)
            % Sets the bounds for the x- or u-coordinate extensions of the new cylinder depending on whether a local coordinate system is active or not. This setting is only used if the axis is set to "x".
            obj.AddToHistory(['.Xrange "', num2str(xmin, '%.15g'), '", '...
                                      '"', num2str(xmax, '%.15g'), '"']);
        end
        function Yrange(obj, ymin, ymax)
            % Sets the bounds for the y- or v-coordinate extensions of the new cylinder depending on whether a local coordinate system is active or not. This setting is only used if the axis is set to "y".
            obj.AddToHistory(['.Yrange "', num2str(ymin, '%.15g'), '", '...
                                      '"', num2str(ymax, '%.15g'), '"']);
        end
        function Zrange(obj, zmin, zmax)
            % Sets the bounds for the z- or w-coordinate extensions of the new cylinder depending on whether a local coordinate system is active or not. This setting is only used if the axis is set to "z".
            obj.AddToHistory(['.Zrange "', num2str(zmin, '%.15g'), '", '...
                                      '"', num2str(zmax, '%.15g'), '"']);
        end
        function XRange(obj, ymin, ymax)
            % Sets the bounds for the x- or u-coordinate extensions of the new cylinder depending on whether a local coordinate system is active or not. This setting is only used if the axis is set to "x".
            obj.Xrange(ymin, ymax);
        end
        function YRange(obj, ymin, ymax)
            % Sets the bounds for the y- or v-coordinate extensions of the new cylinder depending on whether a local coordinate system is active or not. This setting is only used if the axis is set to "y".
            obj.Yrange(ymin, ymax);
        end
        function ZRange(obj, zmin, zmax)
            % Sets the bounds for the z- or w-coordinate extensions of the new cylinder depending on whether a local coordinate system is active or not. This setting is only used if the axis is set to "z".
            obj.Zrange(zmin, zmax);
        end
        function Segments(obj, number)
            % This setting specifies how the cylinder's geometry is modelled, either as a smooth surface of by a facetted approximation. If this value is set to "0", an analytical (smooth) representation of the cylinder will be created. If this number is set to another value greater than 2, the cylinder's face will be approximated by this number of planar facets. The higher the number of segments, the better the representation of the cylinder will be.
            obj.AddToHistory(['.Segments "', num2str(number, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new cylinder. All necessary settings for this cylinder have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With Cylinder and append End With
            obj.history = [ 'With Cylinder', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define cylinder: ', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCylinder
        history

        name
        component
    end
end

%% Default Settings
% Material('Vacuum');
% Innerradius(0)
% Xcenter(0)
% Ycenter(0)
% Zcenter(0)
% Xrange(0, 0)
% Yrange(0, 0)
% Zrange(0, 0)
% Segments(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% cylinder = project.Cylinder();
%     cylinder.Reset
%     cylinder.Name('cylinder1');
%     cylinder.Component('component1');
%     cylinder.Material('PEC');
%     cylinder.Axis('z');
%     cylinder.Outerradius(1.5)
%     cylinder.Innerradius(0.5)
%     cylinder.Xcenter(2)
%     cylinder.Ycenter(1)
%     cylinder.Zcenter(0)
%     cylinder.Zrange(0, 'a+3');
%     cylinder.Segments(0)
%     cylinder.Create
