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

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK> 

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
            
            obj.name = [];
            obj.curve = [];
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
        end
        function LineTo(obj, xCoord, yCoord)
            % Sets a line from the point previously defined to the point defined by x, y here. x and y specify a location in absolute coordinates in the actual working coordinate system.
            obj.AddToHistory(['.LineTo "', num2str(xCoord, '%.15g'), '", '...
                                      '"', num2str(yCoord, '%.15g'), '"']);
        end
        function RLine(obj, xCoord, yCoord)
            % Sets a line from the point previously defined to the point defined by x, y here. x and y specify a location relative to the previous point in the current working coordinate system.
            obj.AddToHistory(['.RLine "', num2str(xCoord, '%.15g'), '", '...
                                     '"', num2str(yCoord, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new polygon curve item. All necessary settings for this polygon have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Polygon and append End With
            obj.history = [ 'With Polygon', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define polygon: ', obj.curve, ':', obj.name], obj.history);
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
