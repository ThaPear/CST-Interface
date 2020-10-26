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
% Warning: Untested

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK>

% Use this to change the color order for the color-by-value field plots.
classdef ColorRamp < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a ColorRamp object.
        function obj = ColorRamp(project, hProject)
            obj.project = project;
            obj.hColorRamp = hProject.invoke('ColorRamp');
            obj.history = [];
            obj.bulkmode = 0;
        end
    end
    methods
        function StartBulkMode(obj)
            % Buffers all commands instead of sending them to CST
            % immediately.
            obj.bulkmode = 1;
        end
        function EndBulkMode(obj)
            % Flushes all commands since StartBulkMode to CST.
            obj.bulkmode = 0;
            % Prepend With ColorRamp and append End With
            obj.history = [ 'With ColorRamp', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ColorRamp settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['ColorRamp', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets internal settings to defaults.
            obj.AddToHistory(['.Reset']);
        end
        function Type(obj, ramptype)
            % Sets the color ramp to a predefined color order.
            % enum ramptype
            % color order
            % "Rainbow" - blue-cyan-green-yellow-red (default)
            % "Fire" - cyan-blue-magenta-red-yellow
            % "Inspire" - green-blue-magenta-red-yellow
            % "FarFire" - blue-magenta-red-yellow (for far fields)
            % "Gray" - for black-and-white printer
            % "Hot" - black-red-yellow-white
            % (2014) "Phase" - red-magenta-blue-cyan-green-yellow-red
            % (2014) "Free" - user defined, see .AddPoint method
            % (2019) "Free" - user-defined color order
            % (2020) "Phase" - red-magenta-blue-cyan-green-yellow-red
            % (2020) "Mono" - white to user-defined color
            obj.AddToHistory(['.Type "', num2str(ramptype, '%.15g'), '"']);
        end
        function Invert(obj, boolean)
            % Inverts the color order, e.g. turn the rainbow type to red-yellow-green-cyan-blue.
            obj.AddToHistory(['.Invert "', num2str(boolean, '%.15g'), '"']);
        end
        function NumberOfContourValues(obj, number)
            % Changes the number of contour values. The number must be greater 2, numbers greater 99 are not recommended for normal use. A higher value results in a smoother coloring.
            obj.AddToHistory(['.NumberOfContourValues "', num2str(number, '%.15g'), '"']);
        end
        function long = GetNumberOfContourValues(obj)
            % Returns the number of contour values.
            long = obj.hColorRamp.invoke('GetNumberOfContourValues');
        end
        function DrawContourLines(obj, boolean)
            % Outline the contour values with black lines between the color steps. Does only apply for 2D / 3D contour plots and 3D farfield plots.
            obj.AddToHistory(['.DrawContourLines "', num2str(boolean, '%.15g'), '"']);
        end
        function SetClampRange(obj, min, max)
            % Sets the min and max value of the "clamp to range" feature. Is ignored for 3D farfield plots.
            obj.AddToHistory(['.SetClampRange "', num2str(min, '%.15g'), '", '...
                                             '"', num2str(max, '%.15g'), '"']);
        end
        function SetScalingMode(obj, scalingmode)
            % Sets the scaling mode.  Is ignored for 3D farfield plots.
            % enum scalingtype
            % scaling
            % "linear" - linear scaling (default)
            % "log" - logarithmic color scaling
            % "dbmax" - dB scaling mode with maximum as reference value
            % "db" - dB scaling mode with 1[unit] as reference value
            % "dbmilli" - dB scaling mode with 0.001[unit] as reference value
            % "dbmicro" - dB scaling mode with 1e-6[unit] as reference value
            obj.AddToHistory(['.SetScalingMode "', num2str(scalingmode, '%.15g'), '"']);
        end
        function SetLogStrength(obj, strength)
            % Sets the log strength if the log scaling mode is active. Values from >1.0 to 100000 are allowed.  Is ignored for 3D farfield plots.
            obj.AddToHistory(['.SetLogStrength "', num2str(strength, '%.15g'), '"']);
        end
        function SetdBRange(obj, range)
            % Sets the dB range if a db scaling mode is active.  Is ignored for 3D farfield plots.
            obj.AddToHistory(['.SetdBRange "', num2str(range, '%.15g'), '"']);
        end
        function Style(obj, enum)
            % This switch either hides (None) the color ramp or positions it vertically in the main view.
            % enum: 'None'
            %       'Vertical'
            %       (2014) 'Vertical
            obj.AddToHistory(['.Style "', num2str(enum, '%.15g'), '"']);
        end
        %% CST 2014 Functions.
        function Scaling(obj, scaletype)
            % Stretches or squeezes the color ramp.
            % enum scaletype  meaning                                                             result for rainbow type
            % "None"          The color ramp is neither squeezed nor stretched.                   blue-cyan-green-yellow-red
            % "Stretch"       The range 0..max is stretched to -max..max.                         green-yellow-red
            % "Squeeze"       The range -max..max is squeezed to 0..max and inverted to -max..0.  red-yellow-green-cyan-blue-cyan-green-yellow-red
            obj.AddToHistory(['.Scaling "', num2str(scaletype, '%.15g'), '"']);
        end
        function AddPoint(obj, value, red, green, blue)
            % A user defined color ramp is shown for .Type "Free". For any field value in the range from -1 (minimum) to +1 (maximum), the desired color can be defined by three doubles ranging from 0 to 1. The color values between two adjacent points will be interpolated. At least two color definitions are needed. See Example.
            obj.AddToHistory(['.AddPoint "', num2str(value, '%.15g'), '", '...
                                        '"', num2str(red, '%.15g'), '", '...
                                        '"', num2str(green, '%.15g'), '", '...
                                        '"', num2str(blue, '%.15g'), '"']);
        end
        function AddFreeRampVertex(obj, value, red, green, blue)
            % Adds a vertex to the user-defined color ramp. All parameters need to be in the range [0.0, 1.0]. The value defines the relative position on the color ramp, with value = 0.0 referring to the lower bound of the color ramp and value = 1.0 to the upper bound. The color given in red, green, blue is interpolated linearly between the given color ramp vertices.
            % For example a simple color ramp ranging from red to white is defined as follows:
            % AddFreeRampVertex (0.0, 1.0, 0.0, 0.0)
            % AddFreeRampVertex (1.0, 1.0, 1.0, 1.0)
            obj.AddToHistory(['.AddFreeRampVertex "', num2str(value, '%.15g'), '", '...
                                                 '"', num2str(red, '%.15g'), '", '...
                                                 '"', num2str(green, '%.15g'), '", '...
                                                 '"', num2str(blue, '%.15g'), '"']);
        end
        function DeleteFreeRampVertices(obj)
            % Delete all vertices from the user-defined color ramp. This results in an empty black user-defined color ramp.
            obj.AddToHistory(['.DeleteFreeRampVertices']);
        end
        %% CST 2020 Functions.
        function SetMonoRampColor(obj, red, green, blue)
            % Set user-defined color of the "Mono" color ramp. This results in a color ramp ranging from white to the given color.
            obj.hColorRamp.invoke('SetMonoRampColor', red, green, blue);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hColorRamp
        history
        bulkmode

    end
end

%% Default Settings
% Type('rainbow');
% Invert(0)
% NumberOfContourValues(33)
% DrawContourLines(0)
%
