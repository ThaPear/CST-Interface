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

% This object is used to create a new line curve item.
classdef Line < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Line object.
        function obj = Line(project, hProject)
            obj.project = project;
            obj.hLine = hProject.invoke('Line');
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
        function Name(obj, linename)
            % Sets the name of the line.
            obj.AddToHistory(['.Name "', num2str(linename, '%.15g'), '"']);
            obj.name = linename;
        end
        function Curve(obj, curvename)
            % Sets the name of the curve for the new line curve item. The curve must already exist.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
            obj.curve = curvename;
        end
        function X1(obj, x1)
            % Sets the x-coordinate from the first point of the line.
            obj.AddToHistory(['.X1 "', num2str(x1, '%.15g'), '"']);
        end
        function Y1(obj, y1)
            % Sets the y-coordinate from the first point of the line.
            obj.AddToHistory(['.Y1 "', num2str(y1, '%.15g'), '"']);
        end
        function X2(obj, x2)
            % Sets the x-coordinate from the second point of the line.
            obj.AddToHistory(['.X2 "', num2str(x2, '%.15g'), '"']);
        end
        function Y2(obj, y2)
            % Sets the y-coordinate from the second point of the line.
            obj.AddToHistory(['.Y2 "', num2str(y2, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new line curve item. All necessary settings for this line have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Line and append End With
            obj.history = [ 'With Line', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Line: ', obj.curve, ':', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hLine
        history

        name
        curve
    end
end

%% Default Settings
% X1(0.0)
% Y1(0.0)
% X2(0.0)
% Y2(0.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% line = project.Line();
%     line.Reset
%     line.Name('line1');
%     line.Curve('curve1');
%     line.X1(-3)
%     line.Y1(1)
%     line.X2(2.5)
%     line.Y2(0, 'a+1.6');
%     line.Create
