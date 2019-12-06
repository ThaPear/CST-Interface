%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Combine calculation results of field monitors for arbitrary excitations.
classdef CombineResults < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CombineResults object.
        function obj = CombineResults(project, hProject)
            obj.project = project;
            obj.hCombineResults = hProject.invoke('CombineResults');
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
            % Prepend With CombineResults and append End With
            obj.history = [ 'With CombineResults', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define CombineResults settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['CombineResults', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their initial values.
            obj.AddToHistory(['.Reset']);
        end
        function SetMonitorType(obj, monitorType)
            % Selects between time domain or frequency domain monitors. To combine farfield monitors set the monitor type to "frequency".
            % monitorType: 'frequency'
            %              'time'
            obj.AddToHistory(['.SetMonitorType "', num2str(monitorType, '%.15g'), '"']);
            obj.setmonitortype = monitorType;
        end
        function SetOffsetType(obj, offsetType)
            % Selects the offset type when combining time domain monitors. This offset may be either a time shift or a phase shift at a given reference frequency.
            % offsetType: 'time'
            %             'phase'
            obj.AddToHistory(['.SetOffsetType "', num2str(offsetType, '%.15g'), '"']);
            obj.setoffsettype = offsetType;
        end
        function SetReferenceFrequency(obj, fRef)
            % Sets the reference frequency for the phase shift when combining time domain monitor results.
            obj.AddToHistory(['.SetReferenceFrequency "', num2str(fRef, '%.15g'), '"']);
            obj.setreferencefrequency = fRef;
        end
        function EnableAutomaticLabeling(obj, bFlag)
            % Activates or deactivates the automatic labeling when combining results.
            obj.AddToHistory(['.EnableAutomaticLabeling "', num2str(bFlag, '%.15g'), '"']);
            obj.enableautomaticlabeling = bFlag;
        end
        function SetLabel(obj, labelName)
            % Sets the name for a result combination.
            obj.AddToHistory(['.SetLabel "', num2str(labelName, '%.15g'), '"']);
            obj.setlabel = labelName;
        end
        function SetExcitationValues(obj, Type, Source, Mode, amplitude, phase_or_timedelay)
            % Specifies the amplitude and phase (respectively  time shift value) for a selected excitation. Supported excitations are:
            %
            % Excitation source     Type    Source                  Mode
            % Waveguide port        "port"  Port number             Mode number
            % Discrete port         "port"  Port number             not available
            % Farfield source       "ffs"   Farfield source name    not available
            % Nearfield source      "cd"    Nearfield source name   not available
            %
            % For the specified excitation the amplitude is set to amplitude and the  phase value (respectively  time shift values) is set to phase_or_timedelay.
            obj.AddToHistory(['.SetExcitationValues "', num2str(Type, '%.15g'), '", '...
                                                   '"', num2str(Source, '%.15g'), '", '...
                                                   '"', num2str(Mode, '%.15g'), '", '...
                                                   '"', num2str(amplitude, '%.15g'), '", '...
                                                   '"', num2str(phase_or_timedelay, '%.15g'), '"']);
            obj.setexcitationvalues.Type = Type;
            obj.setexcitationvalues.Source = Source;
            obj.setexcitationvalues.Mode = Mode;
            obj.setexcitationvalues.amplitude = amplitude;
            obj.setexcitationvalues.phase_or_timedelay = phase_or_timedelay;
        end
        function string = GetCombinationFromLabel(obj, labelName)
            % Returns the combination string for the given label.
            string = obj.hCombineResults.invoke(['GetCombinationFromLabel "', num2str(labelName, '%.15g'), '"']);
        end
        function SetAllExcitations(obj, amplitude, phase_or_timedelay)
            % For all available excitations the amplitudes are set to amplitude and the phase values (respectively  time shift values) are set to phase_or_timedelay.
            obj.AddToHistory(['.SetAllExcitations "', num2str(amplitude, '%.15g'), '", '...
                                                 '"', num2str(phase_or_timedelay, '%.15g'), '"']);
            obj.setallexcitations.amplitude = amplitude;
            obj.setallexcitations.phase_or_timedelay = phase_or_timedelay;
        end
        function SetSystemAmplitude(obj, amplitude)
            % The combine results feature may be used to simulate a network excitation. amplitude is the system stimulation amplitude which is equivalent to the excitation defined above.
            obj.AddToHistory(['.SetSystemAmplitude "', num2str(amplitude, '%.15g'), '"']);
            obj.setsystemamplitude = amplitude;
        end
        function SetSystemBalance(obj, balance)
            % Sets the balance of the total system (i.e. model and exciting circuit).
            obj.AddToHistory(['.SetSystemBalance "', num2str(balance, '%.15g'), '"']);
            obj.setsystembalance = balance;
        end
        function SetNone(obj)
            % Sets the amplitudes and phase values (or time shift values) for all excitations to 0 and resets the system settings. Therefore no combination will be done.
            obj.AddToHistory(['.SetNone']);
        end
        function ClearFilters(obj)
            % Clears the monitor selection filters. Only native 1D results are combined.
            obj.AddToHistory(['.ClearFilters']);
        end
        function AddFilter(obj, Filter)
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
            obj.AddToHistory(['.AddFilter "', num2str(Filter, '%.15g'), '"']);
            obj.addfilter = Filter;
        end
        function OnlyAtFrequency(obj, freq)
            % Combines all monitors defined the frequency "freq".
            obj.AddToHistory(['.OnlyAtFrequency "', num2str(freq, '%.15g'), '"']);
            obj.onlyatfrequency = freq;
        end
        function Run(obj)
            % Starts combining monitor results. The combined results are added to the result tree in the respective sub folders.
            obj.AddToHistory(['.Run']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCombineResults
        history
        bulkmode

        setmonitortype
        setoffsettype
        setreferencefrequency
        enableautomaticlabeling
        setlabel
        setexcitationvalues
        setallexcitations
        setsystemamplitude
        setsystembalance
        addfilter
        onlyatfrequency
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
%     combineresults.SetExcitationValues('port', '1', 1, 'Sqr(2.0)', 90.0);
%     combineresults.SetExcitationValues('port', '2', 1, 'Sqr(2.0)', -90.0);
%     combineresults.Run
% 
