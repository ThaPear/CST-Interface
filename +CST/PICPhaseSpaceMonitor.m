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

% Defines a phase space monitor for the PIC solver.
classdef PICPhaseSpaceMonitor < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.PICPhaseSpaceMonitor object.
        function obj = PICPhaseSpaceMonitor(project, hProject)
            obj.project = project;
            obj.hPICPhaseSpaceMonitor = hProject.invoke('PICPhaseSpaceMonitor');
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
        function Direction(obj, dir)
            % This method defines the abscissa of the phase space plot. Possible values are X, Y and Z.
            obj.AddToHistory(['.Direction "', num2str(dir, '%.15g'), '"']);
        end
        function KineticType(obj, typeName)
            % This method defines the ordinate of the phase space plot. Possible values are:
            % - Normed Momentum
            % - Gamma
            % - Beta
            % - Velocity
            % - Energy
            obj.AddToHistory(['.KineticType "', num2str(typeName, '%.15g'), '"']);
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
            % If bFlag is TRUE, the time domain monitor will stop storing the results when the end time set with Tend is reached. Otherwise the monitor will continue until the simulation stops.
            obj.AddToHistory(['.UseTend "', num2str(bFlag, '%.15g'), '"']);
        end
        function Delete(obj, monitorName)
            % Deletes the monitor named monitorName.
            obj.project.AddToHistory(['PICPhaseSpaceMonitor.Delete "', num2str(monitorName, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the monitor named oldname to newname.
            obj.project.AddToHistory(['PICPhaseSpaceMonitor.Rename "', num2str(oldname, '%.15g'), '", '...
                                      '"', num2str(newname, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the monitor with the previously applied settings.
            obj.AddToHistory(['.Create']);
            
            % Prepend With PICPhaseSpaceMonitor and append End With
            obj.history = [ 'With PICPhaseSpaceMonitor', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define PICPhaseSpaceMonitor; ', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPICPhaseSpaceMonitor
        history

        name
    end
end

%% Default Settings
% Direction('Z');
% Tstart(0.0)
% Tstep (0.0)
% Tend  (0.0)
% UseTend(FALSE)

%% Example - Taken from CST documentation and translated to MATLAB.
% % creates a PIC Phase Space Monitor
% picphasespacemonitor = project.PICPhaseSpaceMonitor();
%     picphasespacemonitor.Reset
%     picphasespacemonitor.Name('pic phase space monitor 1');
%     picphasespacemonitor.Direction('Z');
%     picphasespacemonitor.KineticType('Energy');
%     picphasespacemonitor.Tstart('0.0');
%     picphasespacemonitor.Tstep('0.01');
%     picphasespacemonitor.Tend('0.0');
%     picphasespacemonitor.UseTend('0');
%     picphasespacemonitor.Create
% 
