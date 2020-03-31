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

% This object is used to create a new sphere shape.
classdef Sphere < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Sphere object.
        function obj = Sphere(project, hProject)
            obj.project = project;
            obj.hSphere = hProject.invoke('Sphere');
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
        end
        function Name(obj, spherename)
            % Sets the name of the sphere.
            obj.AddToHistory(['.Name "', num2str(spherename, '%.15g'), '"']);
        end
        function Component(obj, componentname)
            % Sets the name of the component for the new sphere. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
        end
        function Material(obj, materialname)
            % Sets the material name for the new sphere. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function Axis(obj, direction)
            % Sets the axis of the sphere.
            % direction: 'x'
            %            'y'
            %            'z'
            obj.AddToHistory(['.Axis "', num2str(direction, '%.15g'), '"']);
        end
        function CenterRadius(obj, radius)
            % Sets the center radius of the sphere.
            obj.AddToHistory(['.CenterRadius "', num2str(radius, '%.15g'), '"']);
        end
        function TopRadius(obj, radius)
            % Sets the radius at the top of the sphere.
            obj.AddToHistory(['.TopRadius "', num2str(radius, '%.15g'), '"']);
        end
        function BottomRadius(obj, radius)
            % Sets the radius at the bottom of the sphere.
            obj.AddToHistory(['.BottomRadius "', num2str(radius, '%.15g'), '"']);
        end
        function Center(obj, xcenter, ycenter, zcenter)
            % Sets the (x, y, z) or (u, v, w) coordinates of the sphere's center point depending on whether a local coordinate system is active or not.
            obj.AddToHistory(['.Center "', num2str(xcenter, '%.15g'), '", '...
                                      '"', num2str(ycenter, '%.15g'), '", '...
                                      '"', num2str(zcenter, '%.15g'), '"']);
        end
        function Segments(obj, number)
            % This setting specifies how the sphere's geometry is modelled, either as a smooth surface of by a facetted approximation. If this value is set to "0", an analytical (smooth) representation of the sphere will be created. If this number is set to another value greater than 2, the sphere's face will be approximated by this number of planar facets along each of the angular directions. The higher the number of segments, the better the representation of the sphere will be.
            obj.AddToHistory(['.Segments "', num2str(number, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new sphere. All necessary settings for this sphere have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Sphere and append End With
            obj.history = [ 'With Sphere', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Sphere'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hSphere
        history

    end
end

%% Default Settings
% Material('Vacuum');
% Center(0, 0, 0)
% Segments(0)
% TopRadius(0)
% BottomRadius(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% sphere = project.Sphere();
%     sphere.Reset
%     sphere.Name('sphere1');
%     sphere.Component('component1');
%     sphere.Material('PEC');
%     sphere.Axis('z');
%     sphere.CenterRadius(1)
%     sphere.TopRadius(0)
%     sphere.BottomRadius(0)
%     sphere.Center(2, 1, 3)
%     sphere.Segments(0)
%     sphere.Create
