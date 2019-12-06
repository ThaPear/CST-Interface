%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Warning: Untested                                                   %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
            obj.AddToHistory(['.Type "', num2str(ramptype, '%.15g'), '"']);
            obj.type = ramptype;
        end
        function Invert(obj, boolean)
            % Inverts the color order, e.g. turn the rainbow type to red-yellow-green-cyan-blue.
            obj.AddToHistory(['.Invert "', num2str(boolean, '%.15g'), '"']);
            obj.invert = boolean;
        end
        function NumberOfContourValues(obj, number)
            % Changes the number of contour values. The number must be greater 2, numbers greater 99 are not recommended for normal use. A higher value results in a smoother coloring.
            obj.AddToHistory(['.NumberOfContourValues "', num2str(number, '%.15g'), '"']);
            obj.numberofcontourvalues = number;
        end
        function long = GetNumberOfContourValues(obj)
            % Returns the number of contour values.
            long = obj.hColorRamp.invoke('GetNumberOfContourValues');
        end
        function DrawContourLines(obj, boolean)
            % Outline the contour values with black lines between the color steps. Does only apply for 2D / 3D contour plots and 3D farfield plots.
            obj.AddToHistory(['.DrawContourLines "', num2str(boolean, '%.15g'), '"']);
            obj.drawcontourlines = boolean;
        end
        function SetClampRange(obj, min, max)
            % Sets the min and max value of the "clamp to range" feature. Is ignored for 3D farfield plots.
            obj.AddToHistory(['.SetClampRange "', num2str(min, '%.15g'), '", '...
                                             '"', num2str(max, '%.15g'), '"']);
            obj.setclamprange.min = min;
            obj.setclamprange.max = max;
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
            obj.setscalingmode = scalingmode;
        end
        function SetLogStrength(obj, strength)
            % Sets the log strength if the log scaling mode is active. Values from >1.0 to 100000 are allowed.  Is ignored for 3D farfield plots.
            obj.AddToHistory(['.SetLogStrength "', num2str(strength, '%.15g'), '"']);
            obj.setlogstrength = strength;
        end
        function SetdBRange(obj, range)
            % Sets the dB range if a db scaling mode is active.  Is ignored for 3D farfield plots.
            obj.AddToHistory(['.SetdBRange "', num2str(range, '%.15g'), '"']);
            obj.setdbrange = range;
        end
        function Style(obj, enum)
            % This switch either hides (None) the color ramp or positions it vertically in the main view.
            % enum: 'None' / 'Vertical'
            obj.AddToHistory(['.Style "', num2str(enum, '%.15g'), '"']);
            obj.style = enum;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hColorRamp
        history
        bulkmode

        type
        invert
        numberofcontourvalues
        drawcontourlines
        setclamprange
        setscalingmode
        setlogstrength
        setdbrange
        style
    end
end

%% Default Settings
% Type('rainbow');
% Invert(0)
% NumberOfContourValues(33)
% DrawContourLines(0)
%  
