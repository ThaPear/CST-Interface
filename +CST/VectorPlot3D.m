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

% With this object three dimensional complex vector fields can be plotted in various ways. To choose what field to plot the SelectTreeItem command can be used.
classdef VectorPlot3D < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.VectorPlot3D object.
        function obj = VectorPlot3D(project, hProject)
            obj.project = project;
            obj.hVectorPlot3D = hProject.invoke('VectorPlot3D');
        end
    end
    %% CST Object functions.
    methods
        function Type(obj, key)
            % Selects the type of Plot.
            % key can have one of  the following values:
            % "arrows"            The field vectors will be plotted as arrows.
            % "cone"              The field vectors will be plotted as cones.
            % "thinarrows"        The field vectors will be plotted as thin arrows.
            % "bubble"            The field vectors will be plotted as bubble.
            % "hedgehog”          The field vectors will be plotted as ”lines”.
            % "streamline”        Stream lines (cylindrical shapes) will be used to represent the fields. (Interesting mainly for the representation of pointing vectors)
            % "thinstreamline”    Stream lines (line shapes) will be used to represent the fields. (Interesting mainly for the representation of pointing vectors)
            obj.hVectorPlot3D.invoke('Type', key);
        end
        function PhaseValue(obj, phase)
            % Specifies the phase of to be plotted complex field values.
            obj.hVectorPlot3D.invoke('PhaseValue', phase);
        end
        function PhaseStep(obj, phasestep)
            % Specifies the step width used by phase incrementing actions.
            obj.hVectorPlot3D.invoke('PhaseStep', phasestep);
        end
        function SetDensityInPercent(obj, objects)
            % Specifies the relative  number of plotted objects. Default density is set to 50%. The density  should be between 0% and 100%
            obj.hVectorPlot3D.invoke('SetDensityInPercent', objects);
        end
        function Scaling(obj, scale)
            % Defines a scale factor of the plotted objects. A value between 0 and 100 may be given. This value influences the size of the objects.
            obj.hVectorPlot3D.invoke('Scaling', scale);
        end
        function ActivateStreamLines(obj, SeedPoints)
            % Specifies the number of seedpoints used to generate stream lines and activates the stream line plot.
            obj.hVectorPlot3D.invoke('ActivateStreamLines', SeedPoints);
        end
        function SetTime(obj, time)
            % The current time value of a time monitor plot is set.
            obj.hVectorPlot3D.invoke('SetTime', time);
        end
        function SetSample(obj, sample)
            % The current time sample number of a time monitor plot is set.
            obj.hVectorPlot3D.invoke('SetSample', sample);
        end
        %% Query
        function enum = GetDomain(obj)
            % Returns the domain of the monitor used, return code can have the following values:
            % "frequency"     The plot is based on recordings of a frequency domain monitor.
            % "time"          The plot is based on recordings of a time domain monitor.
            % "static"        The plot is based on recordings of a static monitor.
            enum = obj.hVectorPlot3D.invoke('GetDomain');
        end
        function long = GetNumberOfSamples(obj)
            % Returns the total number of samples if the plot is based on recordings of a time monitor else 0.
            long = obj.hVectorPlot3D.invoke('GetNumberOfSamples');
        end
        function double = GetTStart(obj)
            % Returns the start time of recording if the plot is based on recordings of a time monitor else 0.0.
            double = obj.hVectorPlot3D.invoke('GetTStart');
        end
        function double = GetTEnd(obj)
            % Returns the end time of recording if the plot is based on recordings of a time monitor else 0.0.
            double = obj.hVectorPlot3D.invoke('GetTEnd');
        end
        function double = GetTStep(obj)
            % Returns the time step width of recording if the plot is based on recordings of a time monitor else 0.0.
            double = obj.hVectorPlot3D.invoke('GetTStep');
        end
        function double = GetTime(obj)
            % Returns the current  time set of a time monitor plot.
            double = obj.hVectorPlot3D.invoke('GetTime');
        end
        function long = GetSample(obj)
            % Returns the current time sample number of a time monitor plot.
            long = obj.hVectorPlot3D.invoke('GetSample');
        end
        function AddListItem(obj, x, y, z)
            % Adds a field value query point to the internal coordinate list. Coordinates are expected in project units.
            obj.hVectorPlot3D.invoke('AddListItem', x, y, z);
        end
        function SetPoints(obj, var_x, var_y, var_z)
            % Adds a field value arrays query point to the internal coordinate list. Coordinates are expected in project units.
            obj.hVectorPlot3D.invoke('SetPoints', var_x, var_y, var_z);
        end
        function CalculateList(obj)
            % Calculates field values at all query points provided by the AddListItem command.
            obj.hVectorPlot3D.invoke('CalculateList');
        end
        function long = GetListLength(obj)
            % Returns the number of field values calculated by CalculateList.
            long = obj.hVectorPlot3D.invoke('GetListLength');
        end
        function [FieldXRe, FieldXIm, FieldYRe, FieldYIm, FieldZRe, FieldZIm] = GetListItem(obj, index)
            % Returns the field value at position index calculated by CalculateList.
            functionString = [...
                'Dim FieldXRe As Double, FieldXIm As Double', newline, ...
                'Dim FieldYRe As Double, FieldYIm As Double', newline, ...
                'Dim FieldZRe As Double, FieldZIm As Double', newline, ...
                'VectorPlot3D.GetListItem(', num2str(index, '%.15g'), ', FieldXRe, FieldXIm, FieldYRe, FieldYIm, FieldZRe, FieldZIm)', newline, ...
            ];
            returnvalues = {'FieldXRe', 'FieldXIm', 'FieldYRe', 'FieldYIm', 'FieldZRe', 'FieldZIm'};
            [FieldXRe, FieldXIm, FieldYRe, FieldYIm, FieldZRe, FieldZIm] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            FieldXRe = str2double(FieldXRe);
            FieldXIm = str2double(FieldXIm);
            FieldYRe = str2double(FieldYRe);
            FieldYIm = str2double(FieldYIm);
            FieldZRe = str2double(FieldZRe);
            FieldZIm = str2double(FieldZIm);
        end
        function variant = GetList(obj, fieldComponent)
            % Returns the field values calculated by CalculateList as an array of doubles. Allowed values for fieldComponent are "xre", "yre", "zre", "xim", "yim", "zim".
            variant = obj.hVectorPlot3D.invoke('GetList', fieldComponent);
        end
        function double = GetLogarithmicFactor(obj)
            % Returns the logarithmic factor of selected result. This factor is used .for dB scaling.
            double = obj.hVectorPlot3D.invoke('GetLogarithmicFactor');
        end
        function Reset(obj)
            % Clears the internal storage used by the field list evaluation and empties the evaluation point storage.
            obj.hVectorPlot3D.invoke('Reset');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hVectorPlot3D

    end
end

%% Default Settings
% Type('arrowscolor');
% PhaseValue(0.0)
% PhaseStep(22.5)
% SetDensityInPercent(50)
% Scaling(50)
% SetTime(0.0)
% SetSample(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% The following script plots the electric field('e1');(if available) in a linear scale by using  thin arrows with density 30%.
% 
% % Plot only a wire frame of the structure to be able to look inside
% Plot.wireframe(1)
% 
% % Select the desired monitor in the tree.
% SelectTreeItem('2D/3D Results\E-Field\e1');
% 
% % Plot the field of the selected monitor
% vectorplot3d = project.VectorPlot3D();
%     vectorplot3d.Type('thinarrows');
%     vectorplot3d.SetDensityInPercent(30)
% End With 
% 
