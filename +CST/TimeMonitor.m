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

% Defines 3D or 2D field monitors. Each monitor stores the field values for a specified set of time samples. There are different kinds of monitors: magnetic and electric field or energy monitors.
classdef TimeMonitor < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TimeMonitor object.
        function obj = TimeMonitor(project, hProject)
            obj.project = project;
            obj.hTimeMonitor = hProject.invoke('TimeMonitor');
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
            % Resets all internal values to their default settings.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Name(obj, monitorName)
            % Sets the name of the monitor.
            obj.AddToHistory(['.Name "', num2str(monitorName, '%.15g'), '"']);
            obj.name = monitorName;
        end
        function Rename(obj, oldName, newName)
            % Renames the monitor named oldName to newName.
            obj.project.AddToHistory(['TimeMonitor.Rename "', num2str(oldName, '%.15g'), '", '...
                                                         '"', num2str(newName, '%.15g'), '"']);
        end
        function Delete(obj, monitorName)
            % Deletes the monitor named monitorName.
            obj.project.AddToHistory(['TimeMonitor.Delete "', num2str(monitorName, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the monitor with the previously applied settings.
            obj.AddToHistory(['.Create']);

            % Prepend With TimeMonitor and append End With
            obj.history = [ 'With TimeMonitor', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define TimeMonitor: ', obj.name], obj.history);
            obj.history = [];
        end
        function FieldType(obj, fType)
            % Sets what field is to be monitored.
            %
            % fType can have one of the following values:
            % "B-Field"                   The magnetic flux density will be monitored.
            % "H-Field"                   The magnetic field strength will be monitored.
            % "E-Field"                   The electric field will be monitored.
            % "D-Field"                   The electric displacement field will be monitored.
            % "Cond. Current Dens."       The conductive current density will be monitored.
            % "Displ. Current Dens."      The displacement current density will be monitored.
            % "Total Current Dens."       The total current density will be monitored.
            % "Potential"                 The electric scalar potential will be monitored.
            % "Material"                  The relative permeability of the materials will be monitored.
            % "Ohmic Losses"              The Ohmic loss density will be monitored.
            % "Averaged Ohmic Losses"     The Ohmic loss density  will be monitored and averaged over a given time period.
            % "Magnetic Energy Density"   The magnetic energy density will be monitored.
            % "Temperature"               The temperature will be monitored.
            % "Heat Flow Density"         The heat flow density will be monitored.
            % "CEM43"                     The cumulative equivalent minutes at 43°C will be monitored in the biologically active tissues.
            % (2014) "J-Field"            The current density will be monitored.
            obj.AddToHistory(['.FieldType "', num2str(fType, '%.15g'), '"']);
        end
        function Tstart(obj, startTime)
            % Sets starting time for a time domain monitor to startTime.
            obj.AddToHistory(['.Tstart "', num2str(startTime, '%.15g'), '"']);
        end
        function Tstep(obj, timeStep)
            % Sets the time increment for a time domain monitor to timeStep.
            obj.AddToHistory(['.Tstep "', num2str(timeStep, '%.15g'), '"']);
        end
        function Tend(obj, stopTime)
            % Sets the end time for a time domain monitor to stopTime.
            obj.AddToHistory(['.Tend "', num2str(stopTime, '%.15g'), '"']);
        end
        function UseTend(obj, bFlag)
            % If bFlag is True the time domain monitor stops storing the results when the end time set with Tend is reached. Otherwise the monitor will continue until the simulation stops.
            obj.AddToHistory(['.UseTend "', num2str(bFlag, '%.15g'), '"']);
        end
        function TimeAveraging(obj, period, method, value)
            % This setting only applies to the Averaged Ohmic Losses monitor type.
            % period specifies the length of the time interval over which the losses are averaged.
            %
            % method can have one of the following values:
            % "Auto"  This is the default option for the time averaging. The end time will be set automatically to the simulation duration, and the start time will be given by the end time minus the specified "period".
            % "Start" Choose this option to explicitly set the start time of the time-averaging. The end time will be given by "value + period" .
            % "End"   Choose this option to explicitly set the end time of the time-averaging. The start time will be given by "value - period".
            obj.AddToHistory(['.TimeAveraging "', num2str(period, '%.15g'), '", '...
                                             '"', num2str(method, '%.15g'), '", '...
                                             '"', num2str(value, '%.15g'), '"']);
        end
        %% Queries
        function long = GetNumberOfMonitors(obj)
            % Returns the total number of defined time monitors in the current project.
            long = obj.hTimeMonitor.invoke('GetNumberOfMonitors');
        end
        function name = GetMonitorNameFromIndex(obj, index)
            % Returns the name of the monitor with regard to the index in the internal monitor list .
            name = obj.hTimeMonitor.invoke('GetMonitorNameFromIndex', index);
        end
        function enum = GetMonitorTypeFromIndex(obj, index)
            % Returns the type of the monitor with regard to the index in the internal monitor list.
            %
            % monType can have one of the following values:
            % "B-Field"       The magnetic flux density has been monitored.
            % "Temperature"   The temperature has been monitored.
            enum = obj.hTimeMonitor.invoke('GetMonitorTypeFromIndex', index);
        end
        function double = GetMonitorTstartFromIndex(obj, index)
            % Returns the start time  with regard to the index in the internal monitor list.
            double = obj.hTimeMonitor.invoke('GetMonitorTstartFromIndex', index);
        end
        function double = GetMonitorTstepFromIndex(obj, index)
            % Returns the time increment value with regard to the index in the internal monitor list.
            double = obj.hTimeMonitor.invoke('GetMonitorTstepFromIndex', index);
        end
        function double = GetMonitorTendFromIndex(obj, index)
            % Returns the end time  with regard to the index in the internal monitor list.
            double = obj.hTimeMonitor.invoke('GetMonitorTendFromIndex', index);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTimeMonitor
        history

        name
    end
end

%% Default Settings
% Tstart(0.0)
% Tstep(0.0)
% Tend(0.0)
% UseTend(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% % creates a time domain magnetic field monitor for the entire calculation domain
% timemonitor = project.TimeMonitor();
%     timemonitor.Reset
%     timemonitor.Name('time monitor');
%     timemonitor.FieldType('B-Field');
%     timemonitor.Create
%
