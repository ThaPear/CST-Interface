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

% This object allows to plot three dimensional complex scalar values. To choose what scalar field to plot the SelectTreeItem command can be used.
classdef ScalarPlot3D < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ScalarPlot3D object.
        function obj = ScalarPlot3D(project, hProject)
            obj.project = project;
            obj.hScalarPlot3D = hProject.invoke('ScalarPlot3D');
        end
    end
    %% CST Object functions.
    methods
        function Type(obj, key)
            % Selects the type of Plot.
            % key can have one of  the following values:
            % "contour"
            % The field values of the chosen scalar field will be plotted on the surfaces of the structure in different colors.
            % "isosurfaces"
            % Surfaces of equal value of the chosen scalar field will be plotted.
            % "bubbles"
            % Spheres of color and size depending on field value are plotted on equidistant positions.
            obj.hScalarPlot3D.invoke('Type', key);
        end
        function PlotAmplitude(obj, boolean)
            % If switch is True, the absolute values (the amplitudes) of the complex scalar values are plotted.
            obj.hScalarPlot3D.invoke('PlotAmplitude', boolean);
        end
        function PhaseValue(obj, phase)
            % Specifies the phase of to be plotted complex field values.
            obj.hScalarPlot3D.invoke('PhaseValue', phase);
        end
        function PhaseStep(obj, step)
            % Specifies the step width used by phase incrementing actions.
            obj.hScalarPlot3D.invoke('PhaseStep', step);
        end
        function Quality(obj, quality)
            % The Plot data for scalar values on surfaces is represented by triangles. This setting influences the number of triangles used for the plot. A fine plot quality will result in a longer plot generation time and thus in slower movies as well. A value between 0 and 100 may be given.
            obj.hScalarPlot3D.invoke('Quality', quality);
        end
        function SetTime(obj, time)
            % The current time value of a time monitor plot is set.
            obj.hScalarPlot3D.invoke('SetTime', time);
        end
        function SetSample(obj, sample)
            % The current time sample number of a time monitor plot is set.
            obj.hScalarPlot3D.invoke('SetSample', sample);
        end
        function IsoValue(obj, value)
            % Draw surfaces on which the selected component or absolute value have a specific value.
            obj.hScalarPlot3D.invoke('IsoValue', value);
        end
        function SetComponent(obj, component)
            % Sets the vector component of a vector result that should be visualized by a Scalar Plot.
            % component can have one of  the following values:
            % "x"
            % The x component of the vector result
            % "y"
            % The y component of the vector result
            % "z"
            % The z component of the vector result
            % "abs"
            % The absolute value of the vector result
            % "normal"
            % The normal part of the vector field is the scalar product of the surface’s normal vector and the field vector on the surface.
            % "tangential"
            % The tangential part is the absolute value of the difference between the vector and the normal part of the vector.
            obj.hScalarPlot3D.invoke('SetComponent', component);
        end
        %% Query
        function enum = GetDomain(obj)
            % Returns the domain of the monitor used, return code can have the following values:
            % "frequency"     The plot is based on recordings of a frequency domain monitor.
            % "time"          The plot is based on recordings of a time domain monitor.
            % "static"        The plot is based on recordings of a static monitor.
            enum = obj.hScalarPlot3D.invoke('GetDomain');
        end
        function long = GetNumberOfSamples(obj)
            % Returns the total number of samples if the plot is based on recordings of a time monitor else 0.
            long = obj.hScalarPlot3D.invoke('GetNumberOfSamples');
        end
        function double = GetTStart(obj)
            % Returns the start time of recording if the plot is based on recordings of a time monitor else 0.0.
            double = obj.hScalarPlot3D.invoke('GetTStart');
        end
        function double = GetTEnd(obj)
            % Returns the end time of recording if the plot is based on recordings of a time monitor else 0.0.
            double = obj.hScalarPlot3D.invoke('GetTEnd');
        end
        function double = GetTStep(obj)
            % Returns the time step width of recording if the plot is based on recordings of a time monitor else 0.0.
            double = obj.hScalarPlot3D.invoke('GetTStep');
        end
        function double = GetTime(obj)
            % Returns the current  time set of a time monitor plot.
            double = obj.hScalarPlot3D.invoke('GetTime');
        end
        function long = GetSample(obj)
            % Returns the current time sample number of a time monitor plot.
            long = obj.hScalarPlot3D.invoke('GetSample');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hScalarPlot3D

    end
end

%% Default Settings
% Type('contour');
% PlotAmplitude(0)
% PhaseValue(0.0)
% PhaseStep(22.5)
% Quality(50)
% SetTime(0.0)
% SetSample(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% The following script plots surfaces of equal amplitude of the vector field component Y of the electric field('e1');.
% 
% % Plot only a wire frame of the structure to be able to look inside
% Plot.wireframe(1)
% 
% % Select the Y-Component of the electric field e1 in the tree
% SelectTreeItem('2D/3D Results\E-Field\e1');
% SetComponent('Y');
% 
% % Plot the scalar field of the selected monitor
% scalarplot3d = project.ScalarPlot3D();
%     scalarplot3d.Type('isosurfaces');
%     scalarplot3d.PlotAmplitude(0)
%     scalarplot3d.Quality(60)
