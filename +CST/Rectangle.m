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

classdef Rectangle < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Rectangle object.
        function obj = Rectangle(project, hProject)
            obj.project = project;
            obj.hRectangle = hProject.invoke('Rectangle');
            obj.Reset();
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
            obj.history = [];
            obj.AddToHistory(['.Reset']);

            obj.name = [];
            obj.curve = [];
        end
        function Name(obj, name)
            % Sets the name of the rectangle.
            obj.AddToHistory(['.Name "', name, '"']);
            obj.name = name;
        end
        function Curve(obj, curve)
            % Sets the name of the curve for the new rectangle curve item. The curve must already exist.
            obj.AddToHistory(['.Curve "', curve, '"']);
            obj.curve = curve;
        end
        function Xrange(obj, x1, x2)
            % Sets the bounds for the x- or u-coordinate for the new rectangle, depending if a local coordinate system is active or not.
            obj.AddToHistory(['.Xrange "', num2str(x1, '%.15g'), '", '...
                                      '"', num2str(x2, '%.15g'), '"']);
        end
        function Yrange(obj, y1, y2)
            % Sets the bounds for the y- or v-coordinate for the new rectangle, depending if a local coordinate system is active or not.
            obj.AddToHistory(['.Yrange "', num2str(y1, '%.15g'), '", '...
                                      '"', num2str(y2, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new rectangle curve item. All necessary settings for this rectangle have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With and append End With
            obj.history = ['With Rectangle', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define rectangle: ', obj.curve, ':', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties
        project
        hRectangle
        history

        name
        curve
    end
end

%% Default Settings
% Xrange (0.0, 0.0)
% Yrange (0.0, 0.0)
%% Example
% With Rectangle
%      .Reset
%      .Name "rectangle1"
%      .Curve "curve1"
%      .Xrange "-8.2", "-0.7"
%      .Yrange "0.3", "a-0.9"
%      .Create
% End With