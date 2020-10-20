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

% Monitors currents along closed curves.
classdef CurrentMonitor < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.CurrentMonitor object.
        function obj = CurrentMonitor(project, hProject)
            obj.project = project;
            obj.hCurrentMonitor = hProject.invoke('CurrentMonitor');
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
            % Resets all internal settings to their values after the last modifying function.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Name(obj, name)
            % Sets a name.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Curve(obj, curvekey)
            % Assigns a path to the current monitor.
            obj.AddToHistory(['.Curve "', num2str(curvekey, '%.15g'), '"']);
        end
        function InvertOrientation(obj, boolean)
            % Inverts orientation.
            obj.AddToHistory(['.InvertOrientation "', num2str(boolean, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Rename the monitor.
            obj.project.AddToHistory(['CurrentMonitor.Rename "', num2str(oldname, '%.15g'), '", '...
                                                            '"', num2str(newname, '%.15g'), '"']);
        end
        function Delete(obj, name)
            % Deletes the object.
            obj.project.AddToHistory(['CurrentMonitor.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Add(obj)
            % Adds the new element.
            obj.AddToHistory(['.Add']);

            % Prepend With CurrentMonitor and append End With
            obj.history = [ 'With CurrentMonitor', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define CurrentMonitor: ', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCurrentMonitor
        history

        name
    end
end

%% Default Settings
% InvertOrientation(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% currentmonitor = project.CurrentMonitor();
%     currentmonitor.Reset
%     currentmonitor.Name('current1');
%     currentmonitor.Curve('curve1:line1');
%     currentmonitor.InvertOrientation(0)
%     currentmonitor.Add
