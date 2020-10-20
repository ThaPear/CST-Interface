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

% This object is used to create a new circle curve item.
classdef Circle < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Circle object.
        function obj = Circle(project, hProject)
            obj.project = project;
            obj.hCircle = hProject.invoke('Circle');
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
        function Name(obj, circlename)
            % Sets the name of the circle.
            obj.AddToHistory(['.Name "', num2str(circlename, '%.15g'), '"']);
        end
        function Curve(obj, curvename)
            % Sets the name of the curve for the new circle curve item. The curve must already exist.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
        end
        function Radius(obj, radius)
            % Sets the radius for the circle.
            obj.AddToHistory(['.Radius "', num2str(radius, '%.15g'), '"']);
        end
        function Xcenter(obj, xcenter)
            % Sets the x-coordinate from the center point of the circle.
            obj.AddToHistory(['.Xcenter "', num2str(xcenter, '%.15g'), '"']);
        end
        function Ycenter(obj, ycenter)
            % Sets the y-coordinate from the center point of the circle.
            obj.AddToHistory(['.Ycenter "', num2str(ycenter, '%.15g'), '"']);
        end
        function Segments(obj, segments)
            % Sets the number of parts the circle should be segmented.
            % The value must be either 0 or greater than 2.
            obj.AddToHistory(['.Segments "', num2str(segments, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new circle curve item. All necessary settings for this circle have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With Circle and append End With
            obj.history = [ 'With Circle', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Circle'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCircle
        history

    end
end

%% Default Settings
% Xcenter(0.0)
% Ycenter(0.0)
% Segments(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% circle = project.Circle();
%     circle.Reset
%     circle.Name('circle1');
%     circle.Curve('curve1');
%     circle.Radius(1.6)
%     circle.Xcenter(2.2)
%     circle.Ycenter(a+8)
%     circle.Segments(0)
%     circle.Create
