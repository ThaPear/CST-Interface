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

% This object allows controlling the visualization of color map plots.
classdef ColourMapPlot < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ColourMapPlot object.
        function obj = ColourMapPlot(project, hProject)
            obj.project = project;
            obj.hColourMapPlot = hProject.invoke('ColourMapPlot');
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Reset all plot options to their default values.
            obj.hColourMapPlot.invoke('Reset');
        end
        function bool = PlotView(obj, type)
            % This method corresponds to selecting a certain plot of the plot toolbar. The variable type specifies the type of view that should be plotted and can be one of the following strings: "real", "imaginary", "magnitude", "magnitudedb", "phase". If the data could be plotted with the given view type, the method returns true, otherwise false.
            bool = obj.hColourMapPlot.invoke('PlotView', type);
        end
        function SetXTicks(obj, nticks)
            % Specifies the number of ticks along the horizontal axis. Please note that at least two ticks must be specified.
            obj.hColourMapPlot.invoke('SetXTicks', nticks);
        end
        function SetYTicks(obj, nticks)
            % Specifies the number of ticks along the vertical axis. Please note that at least two ticks must be specified.
            obj.hColourMapPlot.invoke('SetYTicks', nticks);
        end
        function SetDrawGrid(obj, grid)
            % This option specifies whether a grid is drawn on top of the data.
            obj.hColourMapPlot.invoke('SetDrawGrid', grid);
        end
        function SetClampToRange(obj, clamp)
            % This option specifies whether the color ramp is scaled to the maximum data range or to a custom lower and upper limit. If this setting is turned on, the color ramp limits are specified by the SetClampToRangeMin and SetClampToRangeMax settings.
            obj.hColourMapPlot.invoke('SetClampToRange', clamp);
        end
        function SetClampToRangeMin(obj, limit)
            % This option is used only if the SetClampToRange option is turned on. The limit specifies the lower bound of the color ramp scale.
            obj.hColourMapPlot.invoke('SetClampToRangeMin', limit);
        end
        function SetClampToRangeMax(obj, limit)
            % This option is used only if the SetClampToRange option is turned on. The limit specifies the upper bound of the color ramp scale.
            obj.hColourMapPlot.invoke('SetClampToRangeMax', limit);
        end
        function SetSkipLessThan(obj, skip)
            % This option specifies whether data values below a given threshold shall be skipped from visualization. The threshold value is specified by the SetSkipLessThanValue setting.
            obj.hColourMapPlot.invoke('SetSkipLessThan', skip);
        end
        function SetSkipLessThanValue(obj, threshold)
            % This option is used only if the SetSkipLessThan option is turned on. The limit specifies the threshold such that data values below this limit will be skipped from visualization.
            obj.hColourMapPlot.invoke('SetSkipLessThanValue', threshold);
        end
        function double = GetXMinData(obj)
            % Get the x and y ranges of the data.
            double = obj.hColourMapPlot.invoke('GetXMinData');
        end
        function double = GetXMaxData(obj)
            % Get the x and y ranges of the data.
            double = obj.hColourMapPlot.invoke('GetXMaxData');
        end
        function double = GetYMinData(obj)
            % Get the x and y ranges of the data.
            double = obj.hColourMapPlot.invoke('GetYMinData');
        end
        function double = GetYMaxData(obj)
            % Get the x and y ranges of the data.
            double = obj.hColourMapPlot.invoke('GetYMaxData');
        end
        function double = GetXMinView(obj)
            % Get the x and y ranges of the current view.
            double = obj.hColourMapPlot.invoke('GetXMinView');
        end
        function double = GetXMaxView(obj)
            % Get the x and y ranges of the current view.
            double = obj.hColourMapPlot.invoke('GetXMaxView');
        end
        function double = GetYMinView(obj)
            % Get the x and y ranges of the current view.
            double = obj.hColourMapPlot.invoke('GetYMinView');
        end
        function double = GetYMaxView(obj)
            % Get the x and y ranges of the current view.
            double = obj.hColourMapPlot.invoke('GetYMaxView');
        end
        function double = GetDataMinValue(obj)
            % Get the minimum and maximum values of the data.
            double = obj.hColourMapPlot.invoke('GetDataMinValue');
        end
        function double = GetDataMaxValue(obj)
            % Get the minimum and maximum values of the data.
            double = obj.hColourMapPlot.invoke('GetDataMaxValue');
        end
        function double = GetViewMinValue(obj)
            % Get the minimum and maximum values of the subset of the data which is currently displayed in the view.
            double = obj.hColourMapPlot.invoke('GetViewMinValue');
        end
        function double = GetViewMaxValue(obj)
            % Get the minimum and maximum values of the subset of the data which is currently displayed in the view.
            double = obj.hColourMapPlot.invoke('GetViewMaxValue');
        end
        function long = GetDataNx(obj)
            % Get the number of data samples along the x and y axes.
            long = obj.hColourMapPlot.invoke('GetDataNx');
        end
        function long = GetDataNy(obj)
            % Get the number of data samples along the x and y axes.
            long = obj.hColourMapPlot.invoke('GetDataNy');
        end
        function double = GetDataValue(obj, x, y)
            % Get the value of the data with the given indices x and y. Valid indices are greater or equal 0 and lower than the number of data samples in the corresponding direction.
            double = obj.hColourMapPlot.invoke('GetDataValue', x, y);
        end
        %% CST 2019 Functions.
        function SetSkipValuesMode(obj, mode)
            % This option specifies which data values shall be skipped from visualization.
            % enum mode           Skip values
            % "lessorequal"       less or equal threshold
            % "greaterorequal"    greater or equal threshold
            % "outsiderange"      outside clamp range
            % "insiderange"       inside clamp range
            % "clamp" (default)   don't skip any values
            obj.hColourMapPlot.invoke('SetSkipValuesMode', mode);
        end
        function SetSkipValuesThreshold(obj, threshold)
            % This threshold is used only if the SetSkipValuesMode option is set to "lessorequal" or "greaterorequal".
            obj.hColourMapPlot.invoke('SetSkipValuesThreshold', threshold);
        end
        %% CST 2020 Functions.
        function SetXAutoTick(obj, on)
            % If set to true (default), the plot ticks of the horizontal / vertical axis are chosen automatically as round values. Otherwise the number of ticks is defined by the 'SetXTicks' / 'SetYTicks' command.
            obj.hColourMapPlot.invoke('SetXAutoTick', on);
        end
        function SetYAutoTick(obj, on)
            % If set to true (default), the plot ticks of the horizontal / vertical axis are chosen automatically as round values. Otherwise the number of ticks is defined by the 'SetXTicks' / 'SetYTicks' command.
            obj.hColourMapPlot.invoke('SetYAutoTick', on);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hColourMapPlot

    end
end

%% Default Settings

%% Example - Taken from CST documentation and translated to MATLAB.
