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

% This object allows to plot three dimensional vector fields on a cutting plane. Therefore the 3D Fields on 2D Plane option has to be active. To choose what field to plot, the SelectTreeItem command can be used.
classdef ScalarPlot2D < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ScalarPlot2D object.
        function obj = ScalarPlot2D(project, hProject)
            obj.project = project;
            obj.hScalarPlot2D = hProject.invoke('ScalarPlot2D');
        end
    end
    %% CST Object functions.
    methods
        function Type(obj, key)
            % Selects the type of Plot.
            % key can have one of  the following values:
            % "contour"       The field values of the chosen scalar field will be plotted on the chosen cutting plane in different colors.
            % "isoline"       Lines of equal value of the chosen scalar field will be plotted on the chosen cutting plane.
            % "carpet"        Plots a carpet or a surface where the distance of a point on the cutting plane to the surface represents the field value at this point.
            % "carpetcolor"   The same as "carpet", but additionally it is colored in relation to the field values.
            obj.hScalarPlot2D.invoke('Type', key);
        end
        function PlotAmplitude(obj, boolean)
            % If switch is True, the absolute values (the amplitudes) of the complex scalar values are plotted.
            obj.hScalarPlot2D.invoke('PlotAmplitude', boolean);
        end
        function PhaseValue(obj, phase)
            % Specifies the phase of to be plotted complex field values.
            obj.hScalarPlot2D.invoke('PhaseValue', phase);
        end
        function PhaseStep(obj, step)
            % Specifies the step width used by phase incrementing actions.
            obj.hScalarPlot2D.invoke('PhaseStep', step);
        end
        function Quality(obj, quality)
            % The Plot data for scalar values on surfaces is represented by triangles. This setting influences the number of triangles used for the plot. A fine plot quality will result in a longer plot generation time and thus in slower movies as well. A value between 0 and 100 may be given.
            obj.hScalarPlot2D.invoke('Quality', quality);
        end
        function Transparency(obj, transparency)
            % Sets the transparency for drawing contour plots or carpet plots. The transparency value is a floating point number in the range from 0.0 to 1.0. A value of 0.0 means that the field visualization is drawn opaquely whereas a value of 1.0 indicates that the field data is drawn completely transparent (invisible).
            obj.hScalarPlot2D.invoke('Transparency', transparency);
        end
        function PlaneNormal(obj, normal)
            % Sets the direction of the cutting plane where the fields are to be plotted. The position of the plane can be set by PlaneCoordinate.
            % normal can have one of  the following values:
            % "x"     x  is the coordinate direction of the cutting plane.
            % "y"     y  is the coordinate direction of the cutting plane.
            % "z"     z  is the coordinate direction of the cutting plane.
            obj.hScalarPlot2D.invoke('PlaneNormal', normal);
        end
        function PlaneCoordinate(obj, position)
            % Sets the position of the cutting plane where the fields are to be plotted. The direction of the plane can be set by PlaneNormal.
            obj.hScalarPlot2D.invoke('PlaneCoordinate', position);
        end
        function SetTime(obj, time)
            % The current time value of a time monitor plot is set.
            obj.hScalarPlot2D.invoke('SetTime', time);
        end
        function SetSample(obj, sample)
            % The current time sample number of a time monitor plot is set.
            obj.hScalarPlot2D.invoke('SetSample', sample);
        end
        function SetComponent(obj, component)
            % Sets the vector component of a vector result that should be visualized by a Scalar Plot.
            % component can have one of  the following values:
            % "x"             The x component of the vector result
            % "y"             The y component of the vector result
            % "z"             The z component of the vector result
            % "abs"           The absolute value of the vector result
            % "normal"        The normal part of the vector field is the scalar product of the surface’s normal vector and the field vector on the surface.
            % "tangential"    The tangential part is the absolute value of the difference between the vector and the normal part of the vector.
            obj.hScalarPlot2D.invoke('SetComponent', component);
        end
        %% Queries
        function enum = GetDomain(obj)
            % Returns the domain of the monitor used, return code can have the following values:
            % "frequency"     The plot is based on recordings of a frequency domain monitor.
            % "time"          The plot is based on recordings of a time domain monitor.
            % "static"        The plot is based on recordings of a static monitor.
            enum = obj.hScalarPlot2D.invoke('GetDomain');
        end
        function long = GetNumberOfSamples(obj)
            % Returns the total number of samples if the plot is based on recordings of a time monitor else 0.
            long = obj.hScalarPlot2D.invoke('GetNumberOfSamples');
        end
        function double = GetTStart(obj)
            % Returns the start time of recording if the plot is based on recordings of a time monitor else 0.0.
            double = obj.hScalarPlot2D.invoke('GetTStart');
        end
        function double = GetTEnd(obj)
            % Returns the end time of recording if the plot is based on recordings of a time monitor else 0.0.
            double = obj.hScalarPlot2D.invoke('GetTEnd');
        end
        function double = GetTStep(obj)
            % Returns the time step width of recording if the plot is based on recordings of a time monitor else 0.0.
            double = obj.hScalarPlot2D.invoke('GetTStep');
        end
        function double = GetTime(obj)
            % Returns the current  time set of a time monitor plot.
            double = obj.hScalarPlot2D.invoke('GetTime');
        end
        function long = GetSample(obj)
            % Returns the current time sample number of a time monitor plot.
            long = obj.hScalarPlot2D.invoke('GetSample');
        end
        %% CST 2014 Functions.
        function Scaling(obj, scale)
            % Defines a scale factor of the plotted objects. A value between 0 and 100 may be given. This value influences the size of the objects.
            obj.hScalarPlot2D.invoke('Scaling', scale);
        end
        function dBScale(obj, boolean)
            % Decides whether the fields should be plotted in a dB scale or not.
            obj.hScalarPlot2D.invoke('dBScale', boolean);
        end
        function dBUnit(obj, unit)
            % Sets the a unit for logarithmic farfield plots. The unit must be integer and between "0" and "4". ("0" = "3D Max = 0 dB", "1" = "2D Max = 0 dB",
            % "2" = "dBV/m", "3" = "dBmV/m", "4" = "dBuV/m").
            obj.hScalarPlot2D.invoke('dBUnit', unit);
        end
        function dBRange(obj, range)
            % Sets the logarithmic field plot range in dB.
            % Please note: range must be a double value here. Any expression is not allowed.
            obj.hScalarPlot2D.invoke('dBRange', range);
        end
        function LogScale(obj, boolean)
            % Decides whether the fields should be plotted in a logarithmical scale or not.
            obj.hScalarPlot2D.invoke('LogScale', boolean);
        end
        function LogStrength(obj, strength)
            % The characteristic curve used for logarithmic scaling can be varied. Values from 1.0e-6 to 100000 are allowed.
            obj.hScalarPlot2D.invoke('LogStrength', strength);
        end
        function ScaleToVectorMaximum(obj, boolean)
            % All components will be scaled to the vector maximum. Thus different components can be compared. If not enabled, the components are scaled to their own maximum.
            obj.hScalarPlot2D.invoke('ScaleToVectorMaximum', boolean);
        end
        function ScaleToRange(obj, boolean)
            % Scales the plot to a range given by ScaleRange. (The used color ramp represents the values between the given interval) This is useful to compare plots with different maximum values.
            obj.hScalarPlot2D.invoke('ScaleToRange', boolean);
        end
        function ScaleRange(obj, min, max)
            % Sets the minimal and maximal values of the plot. This setting has only an effect, if ScaleToRange is True.
            obj.hScalarPlot2D.invoke('ScaleRange', min, max);
        end
        function Plot(obj)
            % Plots the field with the previously made settings.
            obj.hScalarPlot2D.invoke('Plot');
        end
        %% CST 2020 Functions.
        function Attribute(obj, key)
            % Selects the result mapping attribute of the Plot.
            % key can have one of the following values:
            % "animated" - Shows the instantaneous result values regarding given phase or time (see PhaseValue, SetTime, SetSample).
            % "maximum" - Shows the maximum result values.
            % "average" - Shows the average result values (only for complex result values).
            % "rms" - Shows the RMS result values (only for complex result values).
            % "phase" - Shows the phase of the result values (only for complex result values).
            obj.hScalarPlot2D.invoke('Attribute', key);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hScalarPlot2D

    end
end

%% Default Settings
% Type('contour');
% PlotAmplitude(0)
% PhaseValue(0.0)
% PhaseStep(22.5)
% Quality(50)
% PlaneNormal('x');
% PlaneCoordinate(0.0)
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
% % Enables plotting of 3D fields on 2D planes
% Plot3DPlotsOn2DPlane(1)
%
% % Plot the scalar field of the selected monitor
% scalarplot2d = project.ScalarPlot2D();
%     scalarplot2d.Type('isoline');
%     scalarplot2d.PlaneNormal('x');
%     scalarplot2d.PlotAmplitude(0)
%     scalarplot2d.PlaneCoordinate(0.0)
%     scalarplot2d.Quality(60)
