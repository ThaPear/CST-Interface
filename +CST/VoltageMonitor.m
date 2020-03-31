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

% Monitors voltages along curves.
classdef VoltageMonitor < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.VoltageMonitor object.
        function obj = VoltageMonitor(project, hProject)
            obj.project = project;
            obj.hVoltageMonitor = hProject.invoke('VoltageMonitor');
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
            % Assigns a path to the voltage monitor.
            obj.AddToHistory(['.Curve "', num2str(curvekey, '%.15g'), '"']);
        end
        function InvertOrientation(obj, boolean)
            % Inverts orientation.
            obj.AddToHistory(['.InvertOrientation "', num2str(boolean, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Rename the monitor.
            obj.project.AddToHistory(['VoltageMonitor.Rename "', num2str(oldname, '%.15g'), '", '...
                                                            '"', num2str(newname, '%.15g'), '"']);
        end
        function Delete(obj, name)
            % Deletes the object.
            obj.project.AddToHistory(['VoltageMonitor.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Add(obj)
            % Adds the new element.
            obj.AddToHistory(['.Add']);
            
            % Prepend With VoltageMonitor and append End With
            obj.history = [ 'With VoltageMonitor', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define VoltageMonitor: ', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hVoltageMonitor
        history

        name
    end
end

%% Default Settings
% InvertOrientation(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% voltagemonitor = project.VoltageMonitor();
%     voltagemonitor.Reset
%     voltagemonitor.Name('voltage1');
%     voltagemonitor.Curve('curve1:line1');
%     voltagemonitor.InvertOrientation(0)
%     voltagemonitor.Add
