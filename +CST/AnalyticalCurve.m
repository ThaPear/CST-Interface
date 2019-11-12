%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Authors: Alexander van Katwijk, Cyrus Tirband                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object is used to create a new analytical curve item.
classdef AnalyticalCurve < handle
    properties
        project
        hAnalyticalCurve
        history
        
        analyticalcurvename
        curvename
        xlaw, ylaw, zlaw
        tmin, tmax
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.AnalyticalCurve object.
        function obj = AnalyticalCurve(project, hProject)
            obj.project = project;
            obj.hAnalyticalCurve = hProject.invoke('AnalyticalCurve');
            
            obj.Reset();
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            % Creates a new analytical curve item. All necessary settings for this analytical curve have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = ['With AnalyticalCurve', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define curve ', obj.curvename, ':', obj.name, '"'], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.history = [];
            obj.AddToHistory(['.Reset']);
        end
        function Name(obj, analyticalcurvename)
            % Sets the name of the analytical curve.
            obj.AddToHistory(['.Name "', analyticalcurvename, '"']);
            obj.analyticalcurvename = analyticalcurvename;
        end
        function Curve(obj, curvename)
            % Sets the name of the curve for the new analytical curve item. The curve must already exist.
            obj.AddToHistory(['.Curve "', curvename, '"']);
            obj.curvename = curvename;
        end
        function LawX(obj, xlaw)
            % Sets the analytical function defining the x-coordinates for the analytical curve dependent on the parameter t.
            obj.AddToHistory(['.LawX "', num2str(xlaw), '"']);
            obj.xlaw = xlaw;
        end
        function LawY(obj, ylaw)
            % Sets the analytical function defining the y-coordinates for the analytical curve dependent on the parameter t.
            obj.AddToHistory(['.LawY "', num2str(ylaw), '"']);
            obj.ylaw = ylaw;
        end
        function LawZ(obj, zlaw)
            % Sets the analytical function defining the z-coordinates for the analytical curve dependent on the parameter t.
            obj.AddToHistory(['.LawZ "', num2str(zlaw), '"']);
            obj.zlaw = zlaw;
        end
        function ParameterRange(obj, tmin, tmax)
            % Sets the bounds for the parameter t.
            obj.AddToHistory(['.ParameterRange "', num2str(tmin), '", '...
                                              '"', num2str(tmax), '"']);
            obj.tmin = tmin;
            obj.tmax = tmax;
        end
    end
end

%% Default settings
% LawX(0.0)
% LawY(0.0)
% LawZ(0.0)
% ParameterRange(0.0, 1.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% analyticalcurve = project.AnalyticalCurve()
%      analyticalcurve.Reset()
%      analyticalcurve.Name('analytical1')
%      analyticalcurve.Curve('curve1');
%      analyticalcurve.LawX('r * cos(t)');
%      analyticalcurve.LawY('r * sin(t)');
%      analyticalcurve.LawZ('t');
%      analyticalcurve.ParameterRange('-r*pi', 'r*pi');
%      analyticalcurve.Create();