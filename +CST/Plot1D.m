%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Description: This object allows to plot one dimensional curves, for example S-parameters. It also allows various modifications to the plot, such as changing the ticking, modifying the curve line style, or adding curve markers.
classdef Plot1D < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Plot1D object.
        function obj = Plot1D(project, hProject)
            obj.project = project;
            obj.hPlot1D = hProject.invoke('Plot1D');
        end
    end
    %% CST Object functions.
    methods
        function Plot(obj)
            % Plots the field with the actual settings. Most of the following commands need a subsequent call of this method to make changes visible.
            obj.hPlot1D.invoke('Plot');
        end
        function bool = PlotView(obj, type)
            % This method corresponds to selecting a certain plot of the plot toolbar. The variable type specifies the type of view that should be plotted and can be one of the following strings: "real", "imaginary", "magnitude", "magnitudedb", "phase", "polar", "smith", "smithy". If the data could be plotted with the given view type, the method returns true, otherwise false.
            bool = obj.hPlot1D.invoke('PlotView', type);
        end
        function ResetView(obj)
            % Resets the settings of the 1-dimensional plot to its default values. This does not affect the plot styles.
            obj.hPlot1D.invoke('ResetView');
        end
        function SetCurveLimit(obj, boolean, curvelimit)
            % This command allows enabling and specifying a global limit for the number of curves that will be plotted within a single 1D plot. The variable switch specifies if the limit should be enabled, and the variable curvelimit specifies the global upper limit. These settings correspond to the setting "No. of curves" shown in the 1D Plot Ribbon. Please note that these settings are global and independent of the project, i.e. changes will affect all 1D Plots within CST Studio Suite. If curves are omitted in a plot, then a hint will be shown in the 1D plot legend. The stored settings can be queried with the GetCurveLimit command. The Plot method has to be called afterwards to make the changes visible.
            obj.hPlot1D.invoke('SetCurveLimit', boolean, curvelimit);
        end
        function SetSmithChartZoom(obj, value)
            % The Smith chart will be zoomed in a logarithmic scale in dB. This method is available only for Smith chart plots.
            obj.hPlot1D.invoke('SetSmithChartZoom', value);
        end
        function ShowReferenceCircle(obj, boolean, radius)
            % In polar plots and Smith chart plots this method shows a background circle with the given radius. In polar plots, the radius unit is the same as in the current plot. In Smith charts the radius unit is a linear value. The Plot method has to be called afterwards to make the changes visible. This method is available only for polar and Smith chart plots.
            obj.hPlot1D.invoke('ShowReferenceCircle', boolean, radius);
        end
        function UseCurveSmoothing(obj, boolean)
            % The method enables or disables automatic smoothening of curves in polar plots and Smith chart plots. The Plot method has to be called afterwards to make the changes visible. This method is available only for polar and Smith chart plots.
            obj.hPlot1D.invoke('UseCurveSmoothing', boolean);
        end
        function SetFont(obj, fontname, fonttype, fontsize)
            % This method modifies the font which is used in the plot. The variable fontname contains the name of the font (i.e. "Arial"). The variable fonttype can be either "bold", "italic", "bold italic" or an empty string. The variable fonstsize can be a positive integer value. The Plot method has to be called afterwards to make the changes visible.
            obj.hPlot1D.invoke('SetFont', fontname, fonttype, fontsize);
        end
        function XAutorange(obj, boolean)
            % This method enables or disables auto-scaling of the x-axis. If switch is True the plot will always be auto-scaled to the maximum range. For polar and Smith chart plots this method enables or disables auto-scaling of the frequency range of the curve.
            obj.hPlot1D.invoke('XAutorange', boolean);
        end
        function XAutoTick(obj, boolean)
            % This method enables or disables automatic determination of the ticking of the x/phi-axis. If switch is True the ticking will be done automatically. See also XTicksDistance.
            obj.hPlot1D.invoke('XAutoTick', boolean);
        end
        function XLogarithmic(obj, boolean)
            % This method enables or disables logarithmic plotting of the x-axis. If the lower bound of the current x-axis is non-positive, an error will be returned. Use the command XRange to change the plot range of the x-axis. The Plot method has to be called afterwards to make the changes visible. This method is available only for cartesian plots.
            obj.hPlot1D.invoke('XLogarithmic', boolean);
        end
        function XRange(obj, min, max)
            % Specifies the range to be plotted for the x-axis. This method automatically turns the XAutorange switch off. For polar and Smith chart plots this method changes the frequency range of the curve.
            obj.hPlot1D.invoke('XRange', min, max);
        end
        function XRoundscale(obj, boolean)
            % This method will round the values of the x-axis ticks (switch = True). Otherwise the values are displayed up to four digits (switch = False). This method is available only for cartesian plots.
            obj.hPlot1D.invoke('XRoundscale', boolean);
        end
        function XTicks(obj, number)
            % Specifies the number of ticks to be displayed at the x/phi-axis. This method automatically turns the XAutoTick switch off.
            obj.hPlot1D.invoke('XTicks', number);
        end
        function XTicksDistance(obj, distance)
            % Specifies the distance between two successive ticks to be displayed at the x/phi-axis. This method automatically turns the XAutoTick switch off.
            obj.hPlot1D.invoke('XTicksDistance', distance);
        end
        function YAutorange(obj, boolean)
            % This method enables or disables auto-scaling of the y/r-axis. If switch is True the plot will always be auto-scaled to the maximum range. For Smith chart plots this command has no effect.
            obj.hPlot1D.invoke('YAutorange', boolean);
        end
        function YAutoTick(obj, boolean)
            % This method enables or disables automatic determination of the ticking of the y/r-axis. If switch is True the ticking will be done automatically. See also YTicksDistance.
            obj.hPlot1D.invoke('YAutoTick', boolean);
        end
        function YLogarithmic(obj, boolean)
            % This method enables or disables logarithmic plotting of the y/r-axis. If the lower bound of the current y-axis is non-positive, an error will be returned. Use the command YRange to change the plot range of the y-axis. The Plot method has to be called afterwards to make the changes visible.
            obj.hPlot1D.invoke('YLogarithmic', boolean);
        end
        function YRange(obj, min, max)
            % Specifies the range to be plotted for the y/r-axis. This method automatically turns the YAutorange switch off. For Smith chart plots this command has no effect.
            obj.hPlot1D.invoke('YRange', min, max);
        end
        function YRoundscale(obj, boolean)
            % This method will round the values of the y/r-axis ticks (switch = True). Otherwise the values are displayed up to four digits (switch = False).
            obj.hPlot1D.invoke('YRoundscale', boolean);
        end
        function YTicks(obj, number)
            % Specifies the number of ticks to be displayed at the y/r-axis.
            obj.hPlot1D.invoke('YTicks', number);
        end
        function YTicksDistance(obj, distance)
            % Specifies the distance between two successive ticks to be displayed at the y/r-axis. This method automatically turns the YAutoTick switch off.
            obj.hPlot1D.invoke('YTicksDistance', distance);
        end
        function AddMarker(obj, absczissa)
            % On each curve in the selected plot a curve marker will be set
            % at the specified abscissa. For polar or Smith chart plots the
            % markers will be set at the specified frequency. The Plot
            % method has to be called afterwards to show the added markers.
            obj.hPlot1D.invoke('AddMarker', absczissa);
        end
        function AddMarkerToCurve(obj, abscissa, curveindex)
            % A curve marker will be set at the specified abscissa to the curve with the specified curve index. The curve index is zero based. The Plot method has to be called afterwards to show the added markers.
            obj.hPlot1D.invoke('AddMarkerToCurve', abscissa, curveindex);
        end
        function DeleteAllMarker(obj)
            % All curve markers that have been previously defined in the selected plot will be deleted. The Plot method has to be called afterwards to make the changes visible.
            obj.hPlot1D.invoke('DeleteAllMarker');
        end
        function DeleteMarker(obj, abscissa)
            % All curve markers that have previously been defined at the specified abscissa will be deleted. The argument corresponds with the frequency for polar or Smith chart plots. The Plot method has to be called afterwards to make the changes visible.
            obj.hPlot1D.invoke('DeleteMarker', abscissa);
        end
        function MeasureLines(obj, boolean)
            % If switch is True four measure lines are displayed, each
            % defining an interval on the x-axis and y-axis. The intervals
            % can be defined using the methods XMeasureLines and
            % YMeasureLines. The resulting widths are displayed together
            % with the measure lines. This method is available only for
            % cartesian plots.
            obj.hPlot1D.invoke('MeasureLines', boolean);
        end
        function XMarker(obj, boolean)
            % If switch is True a marker is displayed, positioned with
            % regard to the x-axis using XMarkerPos. In a box beside the
            % marker axis the y-values of all curves are shown. This method
            % is available only for cartesian plots.
            obj.hPlot1D.invoke('XMarker', boolean);
        end
        function ShowMarkerAtMin(obj)
            % Activates the marker and positions the marker at  the global
            % y-minimum of all displayed curves. This method is available
            % only for cartesian plots.
            obj.hPlot1D.invoke('ShowMarkerAtMin');
        end
        function ShowMarkerAtMax(obj)
            % Activates the marker and positions the marker at  the global y-maximum of all displayed curves. This method is available only for cartesian plots.
            obj.hPlot1D.invoke('ShowMarkerAtMax');
        end
        function XMarkerPos(obj, value)
            % If XMarker is active, its position with respect to the x-axis will be specified here. This method is available only for cartesian plots.
            obj.hPlot1D.invoke('XMarkerPos', value);
        end
        function XMeasureLines(obj, min, max)
            % If MeasureLines are active, their positions with respect to the x-axis will be specified here. This method is available only for cartesian plots.
            obj.hPlot1D.invoke('XMeasureLines', min, max);
        end
        function YMeasureLines(obj, min, max)
            % If MeasureLines are active, their positions with respect to the y-axis will be specified here. This method is available only for cartesian plots.
            obj.hPlot1D.invoke('YMeasureLines', min, max);
        end
        function AddThickBackGroundLine(obj, x0, y0, x1, y1)
            % Adds a thick background line to a cartesian plot going from (x0, y0) to (x1, y1). The points are given in data coordinates with respect to current plot. This method is available only for cartesian plots.
            obj.hPlot1D.invoke('AddThickBackGroundLine', x0, y0, x1, y1);
        end
        function AddThinBackGroundLine(obj, x0, y0, x1, y1)
            % Adds a thin background line to a cartesian plot going from (x0, y0) to (x1, y1). The points are given in data coordinates with respect to current plot. This method is available only for cartesian plots.
            obj.hPlot1D.invoke('AddThinBackGroundLine', x0, y0, x1, y1);
        end
        function DeleteAllBackGroundShapes(obj)
            % Deletes all previously set background lines. This method is available only for cartesian plots.
            obj.hPlot1D.invoke('DeleteAllBackGroundShapes');
        end
        function SetLineColor(obj, curveindex, red, green, blue)
            % Sets the color of the curve with the given curve index to the specified RGB-value. Each parameter red, green and blue can be a value between 0 and 255. After this method has been called it is necessary to call the Plot method to make the changes visible.
            obj.hPlot1D.invoke('SetLineColor', curveindex, red, green, blue);
        end
        function RemoveLineColor(obj, curveindex)
            % Sets the color of the curve with the given curve index to a default value. After this method has been called it is necessary to call the Plot method to make the changes visible.
            obj.hPlot1D.invoke('RemoveLineColor', curveindex);
        end
        function SetLineStyle(obj, curveindex, linetype, linewidth)
            % Sets the line style and the line thickness of the curve with the given curve index. The parameter linetype will specify the line style of the curve and can be either "solid", "dashed", "dotted" or "dashdotted". Any other string will not change the line style. The parameter linewidth specifies the line thickness and can be a value between 1 and 8. Any other value will not change the line thickness. After this method has been called it is necessary to call the Plot method to make the changes visible.
            obj.hPlot1D.invoke('SetLineStyle', curveindex, linetype, linewidth);
        end
        function RemoveLineStyle(obj, curveindex)
            % Sets the line style and line thickness of the curve with the given curve index to default values. After this method has been called it is necessary to call the Plot method to make the changes visible.
            obj.hPlot1D.invoke('RemoveLineStyle', curveindex);
        end
        function SetMarkerStyle(obj, curveindex, markertype, markershape, markersize)
            % Sets the style and shape of additional marks of the curve with the given curve index.  The parameter markertype specifies the type of the additional marks and can be either "auto", "additionalmarks","marksonly" or "nomarks" . Any other string will not change the type of the markers. The parameter markershape specifies the shape of the markers and can be an be either "auto", "circles", "diamonds", "squares", "triangle up" or "triangle down". Any other string will not change the shape of the markers. The parameter markersize specifies the size of the additional markers and can be a value between 1 and 8. Any other value will not change the size of the markers. After this method has been called it is necessary to call the Plot method to make the changes visible. The markers are not visible in Polar plots and Smith chart plots.
            obj.hPlot1D.invoke('SetMarkerStyle', curveindex, markertype, markershape, markersize);
        end
        function RemoveMarkerStyle(obj, curveindex)
            % Sets the line style and line thickness of the curve with the given curve index to default values. After this method has been called it is necessary to call the Plot method to make the changes visible. The markers are not visible in Polar plots and Smith chart plots.
            obj.hPlot1D.invoke('RemoveMarkerStyle', curveindex);
        end
        function int = GetCurveIndexOfCurveLabel(obj, curvelabel)
            % Returns the index of the curve with the specified curve label. If the curve label is not found  -1 will be returned. In case the curve label is not unique, the first matching index will be returned. Please note that it is the curve label which is needed, not the name of the Tree entry. In a Smith chart plot, this could be for example "S1,1 (var. ref. imp.)". Use the method GetCurveLabelOfCurveIndex to get the correct spelling of a certain curve label.
            int = obj.hPlot1D.invoke('GetCurveIndexOfCurveLabel', curvelabel);
        end
        function string = GetCurveLabelOfCurveIndex(obj, curveindex)
            % Returns the label of the curve with the specified index. If no curve with this index is found an empty string will be returned.
            string = obj.hPlot1D.invoke('GetCurveLabelOfCurveIndex', curveindex);
        end
        function double = GetCurveValue(obj, curvelabel, abscissa)
            % This method returns the ordinate value of the curve specified
            % by curvelabel at the abscissa value specified by abscissa. If
            % the value abscissa is in between two data points, the
            % ordinate of the closest data point is returned. This method
            % is available only for cartesian plots.
            double = obj.hPlot1D.invoke('GetCurveValue', curvelabel, abscissa);
        end
        function double = GetMaximumLocation(obj, curvlabel)
            % Get the maximum location of the specified curve. This method is available only for cartesian plots.
            double = obj.hPlot1D.invoke('GetMaximumLocation', curvlabel);
        end
        function double = GetMinimumLocation(obj, curvelabel)
            % Get the minimum location of the specified curve. This method is available only for cartesian plots.
            double = obj.hPlot1D.invoke('GetMinimumLocation', curvelabel);
        end
        function double = GetNumberOfCurves(obj)
            % Returns the total number of displayed curves in a 1D plot. If some curves are hidden they are not counted anymore.
            double = obj.hPlot1D.invoke('GetNumberOfCurves');
        end
        function string = GetCurrentPlotSettings(obj, options)
            % Returns the current plot settings as a string. The parameter 'options' is expected to be an empty string. The string returned by this method contains VBA commands that can be used to restore the current plot state.
            string = obj.hPlot1D.invoke('GetCurrentPlotSettings', options);
        end
        function [enabled, curvelimit] = GetCurveLimit(obj)
            % This method allows querying the settings that correspond to the "No. of curves" option
            % shown in the 1D Plot Ribbon. The variable enabled will be set to True if a global
            % limit for the number of plotted curves is enabled, otherwise to False. The variable
            % curvelimit will be set to the stored global limit for the number of plotted curves.
            % Please note that these settings are global and independent of the project. The
            % settings can be modified with the SetCurveLimit command.
            functionString = [...
                'Dim enabled As Boolean', newline, ...
                'Dim curvelimit As Long', newline, ...
                'Plot1D.GetCurveLimit(enabled, curvelimit)', newline, ...
            ];
            returnvalues = {'enabled', 'curvelimit'};
            [enabled, curvelimit] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            enabled = str2double(enabled);
            curvelimit = str2double(curvelimit);
        end
        function ExportBitmap(obj, width, height, filename)
            % Creates a bitmap file of the current plot with the specified size. The string filename is expected to be an absolute file path.
            obj.hPlot1D.invoke('ExportBitmap', width, height, filename);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPlot1D

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% project.% change the plot style of S-Parameter S1,1
% project.SelectTreeItem('1D Results\S-Parameters');
% project.Dim index As Integer
% plot1d = project.Plot1D();
%     index =.GetCurveIndexOfCurveLabel('S1,1');
%     plot1d.SetLineStyle(index, 'dashed', 8) % thick dashed line
%     plot1d.SetLineColor(index,255,255,0)  % yellow
%     plot1d.Plot % make changes visible
