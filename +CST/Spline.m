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

% This object is used to create a new spline curve item.
classdef Spline < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Spline object.
        function obj = Spline(project, hProject)
            obj.project = project;
            obj.hSpline = hProject.invoke('Spline');
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
        function Name(obj, splinename)
            % Sets the name of the spline curve.
            obj.AddToHistory(['.Name "', num2str(splinename, '%.15g'), '"']);
        end
        function Curve(obj, curvename)
            % Sets the name of the curve for the new spline curve item. The curve must already exist.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
        end
        function Point(obj, xCoord, yCoord)
            % Sets the coordinates for the first point of the spline to be defined.
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
            % Creates a new spline curve item. All necessary settings for this spline have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With Spline and append End With
            obj.history = [ 'With Spline', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Spline'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hSpline
        history

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% spline = project.Spline();
%     spline.Reset
%     spline.Name('spline1');
%     spline.Curve('curve1');
%     spline.Point('-16.5', 'a+25.6');
%     spline.LineTo('-4.9', '18.4');
%     spline.RLine('7.6', '30.5');
%     spline.LineTo('12.3', '18.6');
%     spline.Create
