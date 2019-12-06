%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object is used to create a new analytical curve item.
classdef AnalyticalCurve < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a AnalyticalCurve object.
        function obj = AnalyticalCurve(project, hProject)
            obj.project = project;
            obj.hAnalyticalCurve = hProject.invoke('AnalyticalCurve');
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
        function Name(obj, analyticalcurvename)
            % Sets the name of the analytical curve.
            obj.AddToHistory(['.Name "', num2str(analyticalcurvename, '%.15g'), '"']);
            obj.name = analyticalcurvename;
        end
        function Curve(obj, curvename)
            % Sets the name of the curve for the new analytical curve item. The curve must already exist.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
            obj.curve = curvename;
        end
        function LawX(obj, xlaw)
            % Sets the analytical function defining the x-coordinates for the analytical curve dependent on the parameter t.
            obj.AddToHistory(['.LawX "', num2str(xlaw, '%.15g'), '"']);
            obj.lawx = xlaw;
        end
        function LawY(obj, ylaw)
            % Sets the analytical function defining the y-coordinates for the analytical curve dependent on the parameter t.
            obj.AddToHistory(['.LawY "', num2str(ylaw, '%.15g'), '"']);
            obj.lawy = ylaw;
        end
        function LawZ(obj, zlaw)
            % Sets the analytical function defining the z-coordinates for the analytical curve dependent on the parameter t.
            obj.AddToHistory(['.LawZ "', num2str(zlaw, '%.15g'), '"']);
            obj.lawz = zlaw;
        end
        function ParameterRange(obj, tmin, tmax)
            % Sets the bounds for the parameter t.
            obj.AddToHistory(['.ParameterRange "', num2str(tmin, '%.15g'), '", '...
                                              '"', num2str(tmax, '%.15g'), '"']);
            obj.parameterrange.tmin = tmin;
            obj.parameterrange.tmax = tmax;
        end
        function Create(obj)
            % Creates a new analytical curve item. All necessary settings for this analytical curve have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With AnalyticalCurve and append End With
            obj.history = [ 'With AnalyticalCurve', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define AnalyticalCurve'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hAnalyticalCurve
        history

        name
        curve
        lawx
        lawy
        lawz
        parameterrange
    end
end

%% Default Settings
% LawX(0.0)
% LawY(0.0)
% LawZ(0.0)
% ParameterRange(0.0, 1.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% analyticalcurve = project.AnalyticalCurve();
%     analyticalcurve.Reset
%     analyticalcurve.Name('analytical1');
%     analyticalcurve.Curve('curve1');
%     analyticalcurve.LawX('r * cos(t)');
%     analyticalcurve.LawY('r * sin(t)');
%     analyticalcurve.LawZ('t');
%     analyticalcurve.ParameterRange('-r*pi', 'r*pi');
%     analyticalcurve.Create
