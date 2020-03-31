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

% This object allows to plot three dimensional vector fields in a cutting plane. Therefore the 3D Fields on 2D Plane option has to be active. To choose what field to plot the SelectTreeItem command can be used.
classdef VectorPlot2D < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.VectorPlot2D object.
        function obj = VectorPlot2D(project, hProject)
            obj.project = project;
            obj.hVectorPlot2D = hProject.invoke('VectorPlot2D');
        end
    end
    %% CST Object functions.
    methods
        function Type(obj, key)
            % Selects the type of Plot.
            % key can have one of  the following values:
            % "arrows"        The field vectors will be plotted as arrows.
            % "cone"          The field vectors will be plotted as cones.
            % "thinarrows"    The field vectors will be plotted as thin arrows.
            % "hedgehog”      The field vectors will be plotted as ”lines”.
            obj.hVectorPlot2D.invoke('Type', key);
        end
        function PhaseValue(obj, phase)
            % Specifies the phase of to be plotted complex field values.
            obj.hVectorPlot2D.invoke('PhaseValue', phase);
        end
        function PhaseStep(obj, phasestep)
            % Specifies the step width used by phase incrementing actions.
            obj.hVectorPlot2D.invoke('PhaseStep', phasestep);
        end
        function SetDensityInPercent(obj, objects)
            % Specifies the relative  number of plotted objects. Default density is set to 50%. The density  should be between 0% and 100%
            obj.hVectorPlot2D.invoke('SetDensityInPercent', objects);
        end
        function ArrowSize(obj, size)
            % Defines the size of the arrows by scaling the field. The scaling size factor must be between 0 and 100
            obj.hVectorPlot2D.invoke('ArrowSize', size);
        end
        function PlaneNormal(obj, normal)
            % Sets the direction of the cutting plane where the fields are to be plotted. The position of the plane can be set by PlaneCoordinate.
            % normal can have one of  the following values:
            % "x"     x  is the coordinate direction of the cutting plane.
            % "y"     y  is the coordinate direction of the cutting plane.
            % "z"     z  is the coordinate direction of the cutting plane.
            obj.hVectorPlot2D.invoke('PlaneNormal', normal);
        end
        function PlaneCoordinate(obj, position)
            % Sets the position of the cutting plane where the fields are to be plotted. The direction of the plane can be set by PlaneNormal.
            obj.hVectorPlot2D.invoke('PlaneCoordinate', position);
        end
        function SetTime(obj, time)
            % The current time value of a time monitor plot is set.
            obj.hVectorPlot2D.invoke('SetTime', time);
        end
        function SetSample(obj, sample)
            % The current time sample number of a time monitor plot is set.
            obj.hVectorPlot2D.invoke('SetSample', sample);
        end
        %% Query
        function enum = GetDomain(obj)
            % Returns the domain of the monitor used, return code can have the following values:
            % "frequency"     The plot is based on recordings of a frequency domain monitor.
            % "time"          The plot is based on recordings of a time domain monitor.
            % "static"        The plot is based on recordings of a static monitor.
            enum = obj.hVectorPlot2D.invoke('GetDomain');
        end
        function long = GetNumberOfSamples(obj)
            % Returns the total number of samples if the plot is based on recordings of a time monitor else 0.
            long = obj.hVectorPlot2D.invoke('GetNumberOfSamples');
        end
        function double = GetTStart(obj)
            % Returns the start time of recording if the plot is based on recordings of a time monitor else 0.0.
            double = obj.hVectorPlot2D.invoke('GetTStart');
        end
        function double = GetTEnd(obj)
            % Returns the end time of recording if the plot is based on recordings of a time monitor else 0.0.
            double = obj.hVectorPlot2D.invoke('GetTEnd');
        end
        function double = GetTStep(obj)
            % Returns the time step width of recording if the plot is based on recordings of a time monitor else 0.0.
            double = obj.hVectorPlot2D.invoke('GetTStep');
        end
        function double = GetTime(obj)
            % Returns the current  time set of a time monitor plot.
            double = obj.hVectorPlot2D.invoke('GetTime');
        end
        function long = GetSample(obj)
            % Returns the current time sample number of a time monitor plot.
            long = obj.hVectorPlot2D.invoke('GetSample');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hVectorPlot2D

    end
end

%% Default Settings
% PhaseValue(0.0)
% PhaseStep(22.5)
% SetDensityInPercent(50)
% ArrowSize(50)
% LogScale(0)
% LogStrength(10.0)
% PlaneNormal('x');
% PlaneCoordinate(0)
% SetTime(0.0)
% SetSample(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% The following script plots the electric field('e1');(if available) in a linear scale by using arrows with density equal 30% . The y-z-plane is defined as cutting plane.
% 
% % Plot only a wire frame of the structure to be able to look inside
% Plot.wireframe(1)
% 
% % Select the desired monitor in the tree.
% SelectTreeItem('2D/3D Results\E-Field\e1');
% 
% % Enables plotting of 3D fields on 2D planes
% Plot3DPlotsOn2DPlane(1)
% 
% % Plot the field of the selected monitor
% vectorplot2d = project.VectorPlot2D();
%     vectorplot2d.SetDensityInPercent(30)
%     vectorplot2d.ArrowSize(50)
%     vectorplot2d.PlaneNormal('x');
%     vectorplot2d.PlaneCoordinate(0.0)
%     vectorplot2d.LogScale(0)
% End With 
% 
% 
