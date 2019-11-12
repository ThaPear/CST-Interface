%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Plot1D < handle
    properties(SetAccess = protected)
        project
        hPlot1D
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Plot1D object.
        function obj = Plot1D(project, hProject)
            obj.project = project;
            obj.hPlot1D = hProject.invoke('Plot1D');
        end
    end
    
    methods
        function Plot(obj)
            obj.hPlot1D.invoke('Plot');
        end
        
        function success = PlotView(obj, type)
            % type: real, imaginary, magnitude, magnitudedb, phase, polar, 
            %       smith, smithy
            success = obj.hPlot1D.invoke('PlotView', type);
        end
        
        function SetLineColor(obj, curveindex, r, g, b)
            % r, g, b: 0 to 255
            % Requires calling Plot to apply changes.
            obj.hPlot1D.invoke('SetLineColor', curveindex, r, g, b);
        end
        
        function RemoveLineColor(obj, curveindex)
            % Requires calling Plot to apply changes.
            obj.hPlot1D.invoke('RemoveLineColor', curveindex);
        end
        
        function SetLineStyle(obj, curveindex, linetype, linewidth)
            % linetype: solid, dashed, dotted, dashdotted
            % linewidth: 1 to 8
            % Requires calling Plot to apply changes.
            obj.hPlot1D.invoke('SetLineStyle', curveindex, linetype, linewidth);
        end
        
        function RemoveLineStyle(obj, curveindex)
            % Requires calling Plot to apply changes.
            obj.hPlot1D.invoke('RemoveLineStyle', curveindex);
        end
        
        function SetMarkerStyle(obj, curveindex, markertype, markershape, markersize)
            % markertype: auto, additionalmarks, marksonly, nomarks
            % markershape: auto, circles, diamonds, squares, 
            %              triangle up, triangle down
            % markersize: 1 to 8
            % Requires calling Plot to apply changes.
            obj.hPlot1D.invoke('SetMarkerStyle', curveindex, markertype, markershape, markersize);
        end
        
        function RemoveMarkerStyle(obj, curveindex)
            % Requires calling Plot to apply changes.
            obj.hPlot1D.invoke('RemoveMarkerStyle', curveindex);
        end
        
        function index = GetCurveIndexOfCurveLabel(obj, curvelabel)
            index = obj.hPlot1D.invoke('GetCurveIndexOfCurveLabel', curvelabel);
        end
        
        function label = GetCurveLabelOfCurveIndex(obj, curveindex)
            label = obj.hPlot1D.invoke('GetCurveLabelOfCurveIndex', curveindex);
        end
        
        function number = GetNumberOfCurves(obj)
            number = obj.hPlot1D.invoke('GetNumberOfCurves');
        end
    end
end
