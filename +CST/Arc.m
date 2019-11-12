%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Authors: Alexander van Katwijk, Cyrus Tirband                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object is used to create a new arc curve item.
classdef Arc < handle
    properties
        project
        hArc
        history
        
        name
        curvename
        orientation
        xcenter, ycenter
        x1, x2
        y1, y2
        angle
        useangle
        segments
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.AnalyticalCurve object.
        function obj = Arc(project, hProject)
            obj.project = project;
            obj.hArc = hProject.invoke('Arc');
            obj.Reset();
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = ['With Arc', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define curve arc: ', obj.curvename, ':', obj.name], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.curvename ='';
            obj.orientation = 'Clockwise';
            obj.xcenter = '0';   obj.ycenter = '0';
            obj.x1 = '0';  obj.x2 = '0';
            obj.y1 = '0';  obj.y2 = '0';
            obj.angle = 90;
            obj.useangle = 0;
            obj.segments = '0';
        end
        function Name(obj, name)
            % Sets the name of the arc.
            obj.AddToHistory(['.Name "', name, '"']);
            obj.name = name;
        end
        function Curve(obj, curvename)
            % Sets the name of the curve for the new arc curve item. The curve must already exist.
            obj.AddToHistory(['.Curve "', curvename, '"']);
            obj.curvename = curvename;
        end
        function Orientation(obj, orientation)
            % Sets the direction for the arc. If the start point and the end point is connected clockwise or counter clockwise.
            % orientationtype: 'Clockwise'
            %                  'CounterClockwise'
            obj.AddToHistory(['.orientation "', orientation, '"']);
            obj.orientation = orientation;
        end
        function Xcenter(obj, xcenter)
            % Sets the x-coordinate from the center point of the arc.
            obj.AddToHistory(['.Xcenter "', num2str(xcenter), '"']);
            obj.xcenter = xcenter; 
        end
        function Ycenter(obj, ycenter)
            % Sets the y-coordinate from the center point of the arc.
            obj.AddToHistory(['.Ycenter "', num2str(ycenter), '"']);
            obj.ycenter = ycenter;
        end
        function X1(obj, x1)
            % Sets the x-coordinate from the start point of the arc.
            obj.AddToHistory(['.X1 "', num2str(x1), '"']);
            obj.x1 = x1;
        end
        function Y1(obj, y1)
            % Sets the y-coordinate from the start point of the arc.
            obj.AddToHistory(['.Y1 "', num2str(y1), '"']);
            obj.y1 = y1;
        end
        function X2(obj, x2)
            % Sets the x-coordinate from the end point of the arc. The end
            % point will be projected to the circle, because the radius is
            % already defined by center point and start point. If UseAngle
            % is true, this information is not used.
            obj.AddToHistory(['.X2 "', num2str(x2), '"']);
            obj.x2 = x2;
        end
        function Y2(obj, y2)
            % Sets the y-coordinate from the end point of the arc. The end
            % point will be projected to the circle, because the radius is
            % already defined by center point and start point. If UseAngle
            % is true, this information is not used.
            obj.AddToHistory(['.Y2 "', num2str(y2), '"']);
            obj.y2 = y2;
        end
        function Angle(obj, angle)
            % Sets the interior angle of the arc. This is alternative
            % information to the end point. See UseAngle.
            obj.AddToHistory(['.Angle "', num2str(angle), '"']);
            obj.angle = angle;
        end
        function UseAngle(obj, boolean)
            % If this boolean is true, the angle information is used and
            % has to be specified instead of an end point. This Method
            % might be omitted, as well as Angle; the end point is used as
            % default.
            obj.AddToHistory(['.UseAngle "', num2str(boolean), '"']);
            obj.useangle = boolean;
        end
        function Segments(obj, segments)
            % Sets the number of parts the arc should be segmented.
            obj.AddToHistory(['.Segments "', num2str(segments), '"']);
            obj.segments = segments;
        end
    end
end

%% Default Settings
% Orientation('Clockwise')
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
% arc = project.Arc()
%      arc.Reset();
%      arc.Name('arc1');
%      arc.Curve('curve1');
%      arc.Orientation('Clockwise');
%      arc.XCenter('-2');
%      arc.YCenter('a+4.7');
%      arc.X1('-0.2');
%      arc.Y1('7.3');
%      arc.X2('-8.2');
%      arc.Y2('4');
%      arc.UseAngle('False');
%      arc.Segments('0');
%      arc.Create();