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

% This object is used to create a new ellipse curve item.
classdef Ellipse < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Ellipse object.
        function obj = Ellipse(project, hProject)
            obj.project = project;
            obj.hEllipse = hProject.invoke('Ellipse');
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
        function Name(obj, ellipsename)
            % Sets the name of the ellipse.
            obj.AddToHistory(['.Name "', num2str(ellipsename, '%.15g'), '"']);
        end
        function Curve(obj, curvename)
            % Sets the name of the curve for the new ellipse curve item. The curve must already exist.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
        end
        function XRadius(obj, radiusXdirection)
            % Sets the radius in x-direction for the ellipse.
            obj.AddToHistory(['.XRadius "', num2str(radiusXdirection, '%.15g'), '"']);
        end
        function YRadius(obj, radiusYdirection)
            % Sets the radius in y-direction for the ellipse.
            obj.AddToHistory(['.YRadius "', num2str(radiusYdirection, '%.15g'), '"']);
        end
        function Xcenter(obj, xcenter)
            % Sets the x-coordinate from the center point of the ellipse.
            obj.AddToHistory(['.Xcenter "', num2str(xcenter, '%.15g'), '"']);
        end
        function Ycenter(obj, ycenter)
            % Sets the y-coordinate from the center point of the ellipse.
            obj.AddToHistory(['.Ycenter "', num2str(ycenter, '%.15g'), '"']);
        end
        function Segments(obj, segments)
            % Sets the number of parts the ellipse should be segmented.
            % The value must be either 0 or greater than 2.
            obj.AddToHistory(['.Segments "', num2str(segments, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new ellipse curve item. All necessary settings for this ellipse have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With Ellipse and append End With
            obj.history = [ 'With Ellipse', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Ellipse'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hEllipse
        history

    end
end

%% Default Settings
% Xcenter(0.0)
% Ycenter(0.0)
% Segments(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% ellipse = project.Ellipse();
%     ellipse.Reset
%     ellipse.Name('ellipse1');
%     ellipse.Curve('curve1');
%     ellipse.XRadius('3.9');
%     ellipse.YRadius('1.6');
%     ellipse.Xcenter('-1.7');
%     ellipse.Ycenter('a+1.7');
%     ellipse.Segments('0');
%     ellipse.Create
