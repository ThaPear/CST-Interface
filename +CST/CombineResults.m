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

% Combine calculation results of field monitors for arbitrary excitations.
classdef CombineResults < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.CombineResults object.
        function obj = CombineResults(project, hProject)
            obj.project = project;
            obj.hCombineResults = hProject.invoke('CombineResults');
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their initial values.
            obj.hCombineResults.invoke('Reset');
        end
        function SetMonitorType(obj, monitorType)
            % Selects between time domain or frequency domain monitors. To combine farfield monitors set the monitor type to "frequency".
            % monitorType: 'frequency'
            %              'time'
            obj.hCombineResults.invoke('SetMonitorType', monitorType);
        end
        function SetOffsetType(obj, offsetType)
            % Selects the offset type when combining time domain monitors. This offset may be either a time shift or a phase shift at a given reference frequency.
            % offsetType: 'time'
            %             'phase'
            obj.hCombineResults.invoke('SetOffsetType', offsetType);
        end
        function SetReferenceFrequency(obj, fRef)
            % Sets the reference frequency for the phase shift when combining time domain monitor results.
            obj.hCombineResults.invoke('SetReferenceFrequency', fRef);
        end
        function EnableAutomaticLabeling(obj, bFlag)
            % Activates or deactivates the automatic labeling when combining results.
            obj.hCombineResults.invoke('EnableAutomaticLabeling', bFlag);
        end
        function SetLabel(obj, labelName)
            % Sets the name for a result combination.
            obj.hCombineResults.invoke('SetLabel', labelName);
        end
        function SetExcitationValues(obj, Type, Source, Mode, amplitude, phase_or_timedelay)
            % Specifies the amplitude and phase (respectively  time shift value) for a selected excitation. Supported excitations are: 
            % 
            % Excitation source             Type    Source                  Mode 
            % Waveguide port                "port"  Port number             Mode number 
            % Discrete port                 "port"  Port number             not available 
            % Farfield source               "ffs"   Farfield source name    not available 
            % Nearfield source              "cd"    Nearfield source name   not available 
            % (2019) Characteristic mode    "mode"  Mode name               not available 
            % 
            % For the specified excitation the amplitude is set to amplitude and the  phase value (respectively  time shift values) is set to phase_or_timedelay. 
            obj.hCombineResults.invoke('SetExcitationValues', Type, Source, Mode, amplitude, phase_or_timedelay);
        end
        function the = For(obj, time)
            the = obj.hCombineResults.invoke('For', time);
        end
        function string = GetCombinationFromLabel(obj, labelName)
            % Returns the combination string for the given label.
            string = obj.hCombineResults.invoke('GetCombinationFromLabel', labelName);
        end
        function SetAllExcitations(obj, amplitude, phase_or_timedelay)
            % For all available excitations the amplitudes are set to amplitude and the phase values (respectively  time shift values) are set to phase_or_timedelay.
            obj.hCombineResults.invoke('SetAllExcitations', amplitude, phase_or_timedelay);
        end
        function SetSystemAmplitude(obj, amplitude)
            % The combine results feature may be used to simulate a network excitation. amplitude is the system stimulation amplitude which is equivalent to the excitation defined above.
            obj.hCombineResults.invoke('SetSystemAmplitude', amplitude);
        end
        function SetSystemBalance(obj, balance)
            % Sets the balance of the total system (i.e. model and exciting circuit).
            obj.hCombineResults.invoke('SetSystemBalance', balance);
        end
        function SetNone(obj)
            % Sets the amplitudes and phase values (or time shift values) for all excitations to 0 and resets the system settings. Therefore no combination will be done.
            obj.hCombineResults.invoke('SetNone');
        end
        function ClearFilters(obj)
            % Clears the monitor selection filters. Only native 1D results are combined.
            obj.hCombineResults.invoke('ClearFilters');
        end
        function AddFilter(obj, Filter)
            % Adds a monitor selection filter to the internal filter set. The following expressions are allowed:
            obj.hCombineResults.invoke('AddFilter', Filter);
        end
        function Filter(obj)
            % Adds a monitor selection filter to the internal filter set. The following expressions are allowed: 
            % 
            % Filter                Action 
            % <MonitorName>         This monitor is added to the selection 
            % :farfield:            All farfield monitors are added to the selection 
            % :fieldsource:         All Field source monitors are added to the selection 
            % :efield:              All E-field monitors are added to the selection 
            % :hfield:              All H-field monitors are added to the selection 
            % :current:             All current monitors are added to the selection 
            % :powerflow:           All power flow monitors are added to the selection 
            % :eenergy:             All E-energy monitors are added to the selection 
            % :henergy:             All H-energy monitors are added to the selection 
            obj.hCombineResults.invoke('Filter');
        end
        function OnlyAtFrequency(obj, freq)
            % Combines all monitors defined the frequency "freq".
            obj.hCombineResults.invoke('OnlyAtFrequency', freq);
        end
        function Run(obj)
            % Starts combining monitor results. The combined results are added to the result tree in the respective sub folders.
            obj.hCombineResults.invoke('Run');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCombineResults

    end
end

%% Default Settings
% SetMonitorType('frequency');
% SetOffsetType('time');
% SetReferenceFrequency(0.0)
% EnableAutomaticLabeling(1)
% ClearFilters
% AddFilter('*');
% SetNone

%% Example - Taken from CST documentation and translated to MATLAB.
% combineresults = project.CombineResults();
%     combineresults.Reset
%     combineresults.SetMonitorType('frequency');
%     combineresults.EnableAutomaticLabeling(0)
%     combineresults.SetLabel('My result combination');
%     combineresults.SetNone
%     combineresults.SetExcitationValues('port', '1', 1, 'Sqr(2.0)', 90.0)
%     combineresults.SetExcitationValues('port', '2', 1, 'Sqr(2.0)', -90.0)
%     combineresults.Run
% 
