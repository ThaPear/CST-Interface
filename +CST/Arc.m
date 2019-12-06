%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object is used to create a new arc curve item.
classdef Arc < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Arc object.
        function obj = Arc(project, hProject)
            obj.project = project;
            obj.hArc = hProject.invoke('Arc');
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
        function Name(obj, arcname)
            % Sets the name of the arc.
            obj.AddToHistory(['.Name "', num2str(arcname, '%.15g'), '"']);
            obj.name = arcname;
        end
        function Curve(obj, curvename)
            % Sets the name of the curve for the new arc curve item. The curve must already exist.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
            obj.curve = curvename;
        end
        function Orientation(obj, orientationtype)
            % Sets the direction for the arc. If the start point and the end point is connected clockwise or counter clockwise.
            % orientationtype: 'Clockwise'
            %                  'CounterClockwise'
            obj.AddToHistory(['.Orientation "', num2str(orientationtype, '%.15g'), '"']);
            obj.orientation = orientationtype;
        end
        function Xcenter(obj, xcenter)
            % Sets the x-coordinate from the center point of the arc.
            obj.AddToHistory(['.Xcenter "', num2str(xcenter, '%.15g'), '"']);
            obj.xcenter = xcenter;
        end
        function Ycenter(obj, ycenter)
            % Sets the y-coordinate from the center point of the arc.
            obj.AddToHistory(['.Ycenter "', num2str(ycenter, '%.15g'), '"']);
            obj.ycenter = ycenter;
        end
        function X1(obj, xStartPoint)
            % Sets the x-coordinate from the start point of the arc.
            obj.AddToHistory(['.X1 "', num2str(xStartPoint, '%.15g'), '"']);
            obj.x1 = xStartPoint;
        end
        function Y1(obj, yStartPoint)
            % Sets the y-coordinate from the start point of the arc.
            obj.AddToHistory(['.Y1 "', num2str(yStartPoint, '%.15g'), '"']);
            obj.y1 = yStartPoint;
        end
        function X2(obj, xEndPoint)
            % Sets the x-coordinate from the end point of the arc. The end point will be projected to the circle, because the radius is already defined by center point and start point. If UseAngle is true, this information is not used.
            obj.AddToHistory(['.X2 "', num2str(xEndPoint, '%.15g'), '"']);
            obj.x2 = xEndPoint;
        end
        function Y2(obj, yEndPoint)
            % Sets the y-coordinate from the end point of the arc. The end point will be projected to the circle, because the radius is already defined by center point and start point. If UseAngle is true, this information is not used.
            obj.AddToHistory(['.Y2 "', num2str(yEndPoint, '%.15g'), '"']);
            obj.y2 = yEndPoint;
        end
        function Angle(obj, angle)
            % Sets the interior angle of the arc. This is alternative information to the end point. See UseAngle.
            obj.AddToHistory(['.Angle "', num2str(angle, '%.15g'), '"']);
            obj.angle = angle;
        end
        function UseAngle(obj, useAngle)
            % If this boolean is true, the angle information is used and has to be specified instead of an end point. This Method might be omitted, as well as Angle; the end point is used as default.
            obj.AddToHistory(['.UseAngle "', num2str(useAngle, '%.15g'), '"']);
            obj.useangle = useAngle;
        end
        function Segments(obj, segments)
            % Sets the number of parts the arc should be segmented.
            obj.AddToHistory(['.Segments "', num2str(segments, '%.15g'), '"']);
            obj.segments = segments;
        end
        function Create(obj)
            % Creates a new arc curve item. All necessary settings for this arc have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Arc and append End With
            obj.history = [ 'With Arc', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define arc: ', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hArc
        history

        name
        curve
        orientation
        xcenter
        ycenter
        x1
        y1
        x2
        y2
        angle
        useangle
        segments
    end
end

%% Default Settings
% Orientation('Clockwise');
% Xcenter(0.0)
% Ycenter(0.0)
% X1(0.0)
% Y1(0.0)
% X2(0.0)
% Y2(0.0)
% Angle(90.0)
% UseAngle(0)
% Segments(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% arc = project.Arc();
%     arc.Reset
%     arc.Name('arc1');
%     arc.Curve('curve1');
%     arc.Orientation('Clockwise');
%     arc.XCenter('-2');
%     arc.YCenter('a+4.7');
%     arc.X1('-0.2');
%     arc.Y1('7.3');
%     arc.X2('-8.2');
%     arc.Y2('4');
%     arc.UseAngle('0');
%     arc.Segments('0');
%     arc.Create
