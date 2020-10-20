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

% This object is used to create a new cone shape.
classdef Cone < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Cone object.
        function obj = Cone(project, hProject)
            obj.project = project;
            obj.hCone = hProject.invoke('Cone');
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
        function Name(obj, conename)
            % Sets the name of the cone.
            obj.AddToHistory(['.Name "', num2str(conename, '%.15g'), '"']);
            obj.name = conename;
        end
        function Component(obj, componentname)
            % Sets the name of the component for the new cone. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
            obj.component = componentname;
        end
        function Material(obj, materialname)
            % Sets the material name for the new cone. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function Axis(obj, direction)
            % Sets the axis of the cone. According to this setting, either Xrange, Yrange or Zrange need to be set for the extension of the cone along the axis.
            % direction: 'x'
            %            'y'
            %            'z'
            obj.AddToHistory(['.Axis "', num2str(direction, '%.15g'), '"']);
        end
        function Topradius(obj, radius)
            % Sets the top radius of the cone. This setting may be set to zero to define a cone with an infinitely sharp cone end. Please note that the settings Topradius and Bottomradius must not both be set to zero.
            obj.AddToHistory(['.Topradius "', num2str(radius, '%.15g'), '"']);
        end
        function Bottomradius(obj, radius)
            % Sets the bottom radius of the cone. This setting may be set to zero to define a cone with an infinitely sharp cone end. Please note that the settings Topradius and Bottomradius must not both be set to zero.
            obj.AddToHistory(['.Bottomradius "', num2str(radius, '%.15g'), '"']);
        end
        function Xcenter(obj, centercoordinate)
            % Sets the x- or u-coordinate of the center point of the bottom face of the cone, depending on whether a local coordinate system is active or not.
            obj.AddToHistory(['.Xcenter "', num2str(centercoordinate, '%.15g'), '"']);
        end
        function Ycenter(obj, centercoordinate)
            % Sets the y- or v-coordinate of the center point of the bottom face of the cone, depending on whether a local coordinate system is active or not.
            obj.AddToHistory(['.Ycenter "', num2str(centercoordinate, '%.15g'), '"']);
        end
        function Zcenter(obj, centercoordinate)
            % Sets the z- or w-coordinate of the center point of the bottom face of the cone, depending on whether a local coordinate system is active or not.
            obj.AddToHistory(['.Zcenter "', num2str(centercoordinate, '%.15g'), '"']);
        end
        function Xrange(obj, xmin, xmax)
            % Sets the bounds for the x- or u-coordinate extensions of the new cone depending on whether a local coordinate system is active or not. This setting is only used if the axis is set to "x".
            obj.AddToHistory(['.Xrange "', num2str(xmin, '%.15g'), '", '...
                                      '"', num2str(xmax, '%.15g'), '"']);
        end
        function Yrange(obj, ymin, ymax)
            % Sets the bounds for the y- or v-coordinate extensions of the new cone depending on whether a local coordinate system is active or not. This setting is only used if the axis is set to "y".
            obj.AddToHistory(['.Yrange "', num2str(ymin, '%.15g'), '", '...
                                      '"', num2str(ymax, '%.15g'), '"']);
        end
        function Zrange(obj, zmin, zmax)
            % Sets the bounds for the z- or w-coordinate extensions of the new cone depending on whether a local coordinate system is active or not. This setting is only used if the axis is set to "z".
            obj.AddToHistory(['.Zrange "', num2str(zmin, '%.15g'), '", '...
                                      '"', num2str(zmax, '%.15g'), '"']);
        end
        function Segments(obj, number)
            % This setting specifies how the cone's geometry is modelled, either as a smooth surface of by a facetted approximation. If this value is set to "0", an analytical (smooth) representation of the cone will be created. If this number is set to another value greater than 2, the cone's face will be approximated by this number of planar facets. The higher the number of segments, the better the representation of the cone will be.
            obj.AddToHistory(['.Segments "', num2str(number, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new cone. All necessary settings for this cone have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With Cone and append End With
            obj.history = [ 'With Cone', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Cone: ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCone
        history

        name
        component
    end
end

%% Default Settings
% Material('Vacuum');
% Topradius(0)
% Bottomradius(0)
% Xcenter(0)
% Ycenter(0)
% Zcenter(0)
% Xrange(0, 0)
% Yrange(0, 0)
% Zrange(0, 0)
% Segments(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% cone = project.Cone();
%     cone.Reset
%     cone.Name('cone1');
%     cone.Component('component1');
%     cone.Material('PEC');
%     cone.Axis('z');
%     cone.Topradius(0.5)
%     cone.Bottomradius(2.0)
%     cone.Xcenter(2)
%     cone.Ycenter(1)
%     cone.Zcenter(0)
%     cone.Zrange(0, 'a+3');
%     cone.Segments(0)
%     cone.Create
