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
     %#ok<*NBRAK> s

% This object is used to create a new torus shape.
classdef Torus < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Torus object.
        function obj = Torus(project, hProject)
            obj.project = project;
            obj.hTorus = hProject.invoke('Torus');
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
        function Name(obj, torusname)
            % Sets the name of the torus.
            obj.AddToHistory(['.Name "', num2str(torusname, '%.15g'), '"']);
            obj.name = torusname;
        end
        function Component(obj, componentname)
            % Sets the name of the component for the new torus. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
            obj.name = componentname;
        end
        function Material(obj, materialname)
            % Sets the material name for the new torus. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function Axis(obj, direction)
            % Sets the axis of the torus.
            % direction: 'x'
            %            'y'
            %            'z'
            obj.AddToHistory(['.Axis "', num2str(direction, '%.15g'), '"']);
        end
        function Outerradius(obj, radius)
            % Sets the large radius of the torus.
            obj.AddToHistory(['.Outerradius "', num2str(radius, '%.15g'), '"']);
        end
        function Innerradius(obj, radius)
            % Sets the small radius of the torus.
            obj.AddToHistory(['.Innerradius "', num2str(radius, '%.15g'), '"']);
        end
        function Xcenter(obj, centercoordinate)
            % Sets the x- or u-coordinate of the center point of the torus depending on whether a local coordinate system is active or not.
            obj.AddToHistory(['.Xcenter "', num2str(centercoordinate, '%.15g'), '"']);
        end
        function Ycenter(obj, centercoordinate)
            % Sets the y- or v-coordinate of the center point of the torus, depending on whether a local coordinate system is active or not.
            obj.AddToHistory(['.Ycenter "', num2str(centercoordinate, '%.15g'), '"']);
        end
        function Zcenter(obj, centercoordinate)
            % Sets the z- or w-coordinate of the center point of the torus, depending on whether a local coordinate system is active or not.
            obj.AddToHistory(['.Zcenter "', num2str(centercoordinate, '%.15g'), '"']);
        end
        function Segments(obj, number)
            % This setting specifies how the torus' geometry is modelled, either as a smooth surface of by a facetted approximation. If this value is set to "0", an analytical (smooth) representation of the torus will be created. If this number is set to another value greater than 2, the torus' face will be approximated by this number of planar facets along each angular direction. The higher the number of segments, the better the representation of the torus will be.
            obj.AddToHistory(['.Segments "', num2str(number, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new torus. All necessary settings for this torus have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With Torus and append End With
            obj.history = [ 'With Torus', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Torus: ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTorus
        history

        name
        component
    end
end

%% Default Settings
% Material('Vacuum');
% Xcenter(0)
% Ycenter(0)
% Zcenter(0)
% Segments(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% torus = project.Torus();
%     torus.Reset
%     torus.Name('torus1');
%     torus.Component('component1');
%     torus.Material('PEC');
%     torus.Axis('z');
%     torus.Outerradius(1.5)
%     torus.Innerradius(0.5)
%     torus.Xcenter(2)
%     torus.Ycenter(1)
%     torus.Zcenter(0)
%     torus.Segments(0)
%     torus.Create
