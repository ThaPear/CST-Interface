%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object is used to create a new polygon curve item.
classdef Polygon < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Polygon object.
        function obj = Polygon(project, hProject)
            obj.project = project;
            obj.hPolygon = hProject.invoke('Polygon');
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
        function Name(obj, polygonname)
            % Sets the name of the polygon.
            obj.AddToHistory(['.Name "', num2str(polygonname, '%.15g'), '"']);
            obj.name = polygonname;
        end
        function Curve(obj, curvename)
            % Sets the name of the curve for the new polygon curve item. The curve must already exist.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
            obj.curve = curvename;
        end
        function Point(obj, xCoord, yCoord)
            % Sets the coordinates for the first point of the polygon to be defined.
            obj.AddToHistory(['.Point "', num2str(xCoord, '%.15g'), '", '...
                                     '"', num2str(yCoord, '%.15g'), '"']);
            obj.point.xCoord = xCoord;
            obj.point.yCoord = yCoord;
        end
        function LineTo(obj, xCoord, yCoord)
            % Sets a line from the point previously defined to the point defined by x, y here. x and y specify a location in absolute coordinates in the actual working coordinate system.
            obj.AddToHistory(['.LineTo "', num2str(xCoord, '%.15g'), '", '...
                                      '"', num2str(yCoord, '%.15g'), '"']);
            obj.lineto.xCoord = xCoord;
            obj.lineto.yCoord = yCoord;
        end
        function RLine(obj, xCoord, yCoord)
            % Sets a line from the point previously defined to the point defined by x, y here. x and y specify a location relative to the previous point in the current working coordinate system.
            obj.AddToHistory(['.RLine "', num2str(xCoord, '%.15g'), '", '...
                                     '"', num2str(yCoord, '%.15g'), '"']);
            obj.rline.xCoord = xCoord;
            obj.rline.yCoord = yCoord;
        end
        function Create(obj)
            % Creates a new polygon curve item. All necessary settings for this polygon have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Polygon and append End With
            obj.history = [ 'With Polygon', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define polygon: ', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPolygon
        history

        name
        curve
        point
        lineto
        rline
    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% polygon = project.Polygon();
%     polygon.Reset
%     polygon.Name('polygon1');
%     polygon.Curve('curve1');
%     polygon.Point('-9.2', '8.5');
%     polygon.LineTo('-5.4', '-1.2');
%     polygon.LineTo('-0.2', 'a+6.5');
%     polygon.RLine('5.3', '-0.6');
%     polygon.LineTo('8.3', '5.3');
%     polygon.Create
