%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  
classdef SimulationTask < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.DS.Project)
        % Only CST.DS.Project can create a SimulationTask object.
        function obj = SimulationTask(dsproject, hDSProject)
            obj.dsproject = dsproject;
            obj.hSimulationTask = hDSProject.invoke('SimulationTask');
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.hSimulationTask.invoke('Reset');
        end
        function Type(obj, type)
            % Sets the type for a simulation task. This setting must be made before calling Create. The type can not be modified after the creation. Most task settings can be accessed by a simulation task object. In addition, specialized objects are available for some types of tasks. Valid task types and specialized objects are:
            % Type                  Object
            % "s-parameters"
            % "dc"
            % "ac"
            % "spectral lines"
            % "mixer"
            % "amplifier"
            % "transient"
            % "template"
            % "sequence"
            % "array"               Phased Array Antenna Task Object
            % "parameter sweep"     ParameterSweep Object
            % "optimization"        Optimizer Object
            obj.hSimulationTask.invoke('Type', type);
        end
        function Name(obj, taskname)
            % Sets the name of a simulation task before calling Create. Furthermore, this method can be used to select an existing task of your project. The task name needs to include all parent tasks for nested tasks, separated by backslashes, e.g. "Seq1\SPara1".
            obj.hSimulationTask.invoke('Name', taskname);
        end
        function Create(obj)
            % Creates a new simulation task.
            obj.hSimulationTask.invoke('Create');
        end
        function Delete(obj)
            % Deletes the task with the given name. Name needs to be called before this function can be evaluated.
            obj.hSimulationTask.invoke('Delete');
        end
        function Update(obj)
            % Executes the task with the given name, including all sub tasks. Name needs to be called before this function can be evaluated.
            % Note: To update all Tasks in the tree, the command  "UpdateResults" can be used. This command is not part of the object SimulationTask.
            obj.hSimulationTask.invoke('Update');
        end
        function SetName(obj, taskname)
            % Modifies the name of an existing simulation task. The name needs to include parent tasks, like for Name. By specifying a different parent part it is also possible to move a task from one parent to another.
            obj.hSimulationTask.invoke('SetName', taskname);
        end
        function MoveInTree(obj, newparent, nexttask)
            % Moves an existing simulation task to a different position in the tree. newparent specifies the new parent task (including parents of the parent like for Name). If newparent is empty the task will be moved to the top level. If nexttask is empty the task will be moved behind all tasks at the new level. If nexttask is not empty the task will be moved in front of nexttask. nexttask specifies the task name only (without parent tasks).
            obj.hSimulationTask.invoke('MoveInTree', newparent, nexttask);
        end
        %% Methods Concerning Properties
        function SetProperty(obj, propertyname, value)
            % Sets the given value for the specified property. The following properties are available for the different simulation task types:
            % All tasks
                % "parallelization " (possible values: "Maximum", "None" or any positive integer): specifies how much parallelization is applied, the maximum possible number of threads, no parallelization, or a custom number of threads, respectively.
                % "auto solver" (possible values: "True" or "False"): specifies whether the Nonlinear solver settings in the Solver Specials dialog of the task are calculated automatically and manual settings are ignored.
                % "error current": specifies tolerance on error current (=sum of all currents to/from a node) in simulation
                % "tolerance type" (possible values: "relative" or "absolute"): Type of tolerance on error current. Reference value is the impressed current.
                % "iterations": specifies the maximum number of iterations in the calculation of the initial operation point.
                % "auto condition" (possible values: "True" or "False"): specifies whether the Circuit condition settings in the Solver Specials dialog of the task are calculated automatically and manual settings are ignored.
                % "gmin": conductance to ground, attached to possibly floating nodes to achieve convergence in circuit simulation. The conductance is calculated automatically if the expression evaluates to a negative number.
                % "rmin": resistance value, below which resistors are treated as ideal shorts in circuit simulation.
            % S-Parameters
                % "fmin", "fmax": simulation frequency range. These settings are only used if "maximum frequency range" is off.
                % "maximum frequency range" (possible values: "True" or "False"): enables or disables the maximum frequency sweep range. If the maximum frequency range is disabled, the frequencies set by the properties "fmin" and "fmax" will be used. If the maximum frequency range is enabled, those properties are ignored. The maximum frequency range must be disabled if the model is not frequency limited.
                % "td block representation" (possible values: "True" or "False"): indicates whether a time domain representation, i.e., vector fitting, is used for frequency-dependent blocks.
                % "circuit simulator": the type of simulator to be used (possible values: "cst", "hspice" or "pspice"). For the latter, a SPICE netlist is exported and no simulation is carried out.
                % "broadband sweep accuracy": specifies the desired accuracy of S-Parameters for the broadband frequency sweep applied in the S-Parameter task.
            % Operating point (DC)
                % "circuit simulator": the type of simulator to be used (possible values: "cst", "hspice" or "pspice"). For the latter, a SPICE netlist is exported and no simulation is carried out.
            % Transient
                % "integration method" (possible values: "adams" or "gear")
                % "integration order" (possible values: 1, 2, 3, or 4)
                % "time stepping" (possible values: "automatic" ,"adaptive", and "fixed")
                % "time step": maximum/fixed time step for adaptive/fixed time stepping
                % "minimum time step": minimum time step for adaptive time stepping
                % "transient accuracy": the desired relative accuracy of the transient solution.
                % "circuit simulator": the type of simulator to be used (possible values: "cst", "cosimulation", "hspice" or "pspice"). For the latter two, a SPICE netlist is exported and no simulation is carried out.
                % "sampling method" (possible values: "Automatic", "Nyquist", and "Manual"). Note that the method SetSweepData() resets the sampling method to "Manual".
                % "fmax estimator": the type of estimation on the maximum excitation frequency (possible values: "automatic", "energy", "transitiontime", or "manual fmax").
                % "energy threshold": relative energy threshold for the estimation of the maximum excitation frequency. It only applies if the energy-based fmax estimator has been selected.
                % "manual fmax": maximum excitation frequency. It only applies if the manual fmax estimator has been selected.
                % "nfdsamples": The number of frequency sample points used for calculating spectral densities or FD voltages/currents.
                % "docombineresults": Starts the field combination in the 3D solver with respect to the calculated excitations in DS. Be sure to set the property "blocknameforcombineresults" to activate combine results correctly.
                % "blocknameforcombineresults": Selects the MWS - block for which the fields are to be combined.
            % AC
                % "fmin", "fmax": simulation frequency range. These settings are only used if "maximum frequency range" is off.
                % "maximum frequency range" (possible values: "True" or "False"): enables or disables the maximum frequency sweep range. If the maximum frequency range is disabled, the frequencies set by the properties "fmin" and "fmax" will be used. If the maximum frequency range is enabled, those properties are ignored. The maximum frequency range must be disabled if the model is not frequency limited.
                % "docombineresults": Starts the field combination in the 3D solver with respect to the calculated excitations in DS. Be sure to set the property "blocknameforcombineresults" to activate combine results correctly.
                % "blocknameforcombineresults": Selects the MWS - block for which the fields are to be combined.
                % "td block representation" (possible values: "True" or "False"): indicates whether a time domain representation, i.e., vector fitting, is used for frequency-dependent blocks.
                % "circuit simulator": the type of simulator to be used (possible values: "cst", "pspice" or "hspice"). For the latter, a SPICE netlist is exported and no simulation is carried out.
            % Spectral lines
                % no task type specific property
            % Mixer
                % "input frequency",
                % "lo frequency",
                % "input resistance",
                % "lo resistance",
                % "output resistance",
                % "input power",
                % "lo power"
            % Amplifier
                % "input frequency",
                % "input res",
                % "input pow",
                % "load res"
                % "logarithmic sweep" (possible values: "True" or "False"): switches between logarithmic and linear frequency or power sampling.
            obj.hSimulationTask.invoke('SetProperty', propertyname, value);
        end
        %% Methods Concerning Result Options
        function EnableResult(obj, resultname, enable)
            % Switches on/off the consideration of the result specified by name. The following results are available:
            % S-Parameters              "block"
            % Operating point (DC)      none
            % Transient                 "block", "block impulse response"
            % AC                        "block"
            % Spectral lines            none
            % Mixer                     "vswr", "spectrum", "isolation", "gain"
            % Amplifier                 "s-param", "group delay", "linear gain", "stability", 
            %                           "spectrum", "distortion", "power", "gain"
            obj.hSimulationTask.invoke('EnableResult', resultname, enable);
        end
        function bool = ResultEnabled(obj, resultname)
            % Tells whether the result specified by name is considered. The available result names are identical to those used by EnableResult.
            bool = obj.hSimulationTask.invoke('ResultEnabled', resultname);
        end
        function string = GetResultOption(obj, resultoptiondescription)
            % Returns the value of the named result option of  the selected task.
            % Parameter resultoptiondescription: (case sensitive as displayed in the 'Results Settings'-tab in the 'Simulation Task'-dialog). An error is thrown if the name couldn't be recognized as a result option name of the task .
            % An error is thrown if no task is selected or if the given name couldn't be recognized as a result option of the task .
            string = obj.hSimulationTask.invoke('GetResultOption', resultoptiondescription);
        end
        function SetResultOption(obj, resultoptiondescription, resultoptionvalue)
            % Sets the value of the named result option of  the selected task to the named value.
            % Parameter resultoptiondescription: (case sensitive as displayed in the 'Description'-column in the 'Results Settings'-tab in the 'Simulation Task'-dialog). An error is thrown if the name couldn't be recognized as a result option name of the task. An error is thrown if no task is selected or if the given name couldn't be recognized as a result option of the task .
            % Parameter resultoptionvalue: (case insensitive as displayed in the 'Value'-column in the 'Results Settings'-tab in the 'Simulation Task'-dialog). An error is thrown if the task couldn't set the value (e.g. because it doesn't pass to the option type). For example a boolean result option (displayed as checkbox) can be set using the values "true" "True" or even "tRuE" but setting it to "1" would throw an error.
            obj.hSimulationTask.invoke('SetResultOption', resultoptiondescription, resultoptionvalue);
        end
        %% Monitor
        function ResetCombineMonitorFilters(obj)
            % Clears all monitor selection filters.
            obj.hSimulationTask.invoke('ResetCombineMonitorFilters');
        end
        function int = GetNCombineMonitorFilters(obj)
            % Gets the number of defined monitor selections.
            int = obj.hSimulationTask.invoke('GetNCombineMonitorFilters');
        end
        function name = GetCombineMonitorFilter(obj, index)
            % Gets the filter string of index "index".
            name = obj.hSimulationTask.invoke('GetCombineMonitorFilter', index);
        end
        function AddCombineMonitorFilter(obj, filterName)
            % Adds a monitor selection filter to the internal filter set. The following expressions are allowed:
            % Filter            Action
            % *                 All monitors are added to the selection
            % <MonitorName>     This monitor is added to the selection
            % :farfield:        All farfield monitors are added to the selection
            % :fieldsource:     All Field source monitors are added to the selection
            % :efield:          All E-field monitors are added to the selection
            % :hfield:          All H-field monitors are added to the selection
            % :current:         All current monitors are added to the selection
            % :powerflow:       All power flow monitors are added to the selection
            % :eenergy:         All E-energy monitors are added to the selection
            % :henergy:         All H-energy monitors are added to the selection
            obj.hSimulationTask.invoke('AddCombineMonitorFilter', filterName);
        end
        %% Special Methods
        function SetSweepType(obj, sweeptype)
            % Specifies the property to sweep. Valid arguments are "no", "frequency" and "power" for amplifier tasks and "no", "frequency", "lo power" and "input power" for mixer tasks.
            obj.hSimulationTask.invoke('SetSweepType', sweeptype);
        end
        function SetSweepData(obj, min, max, samples)
            % Specifies the sweep range and the number of samples. The sweep range is Tmin and Tmax for transient tasks. For frequency domain tasks it is Fmin and Fmax, and for mixer and amplifier tasks it is either Fmin and Fmax or Pmin and Pmax (depending on the task settings). Note that for transient tasks the sampling method is reset to "Manual".
            obj.hSimulationTask.invoke('SetSweepData', min, max, samples);
        end
        function SetLocalUnit(obj, unittype, unit)
            % Sets the task to local units, i.e. values of all properties associated with the selected simulation task will not refer to the project's global units any more but to the tasks local units. Additionally, the unit of the specified type of unit is set to the given value.
            obj.hSimulationTask.invoke('SetLocalUnit', unittype, unit);
        end
        function SetGlobalUnit(obj, unittype)
            % Sets the task to global units. The local unit of the specified type is deleted. All other local units are preserved, but not active. They can be activated again by calling SetLocalUnit.
            obj.hSimulationTask.invoke('SetGlobalUnit', unittype);
        end
        function SetDiamondScheme(obj, diamond)
            % Switches on/off the consideration of the frequencies according to the diamond scheme for a spectral lines simulation task.
            obj.hSimulationTask.invoke('SetDiamondScheme', diamond);
        end
        function SetDiamondHarmonics(obj, harmonics)
            % Sets the number of harmonics for the diamond scheme for a spectral lines simulation task.
            obj.hSimulationTask.invoke('SetDiamondHarmonics', harmonics);
        end
        function AddFundamentalFrequency(obj, frequency, harmonics)
            % Adds a fundamental frequency to a spectral lines simulation task with a given number of harmonics that will be considered if the diamond scheme is switched off.
            obj.hSimulationTask.invoke('AddFundamentalFrequency', frequency, harmonics);
        end
        function ClearFundamentalFrequencies(obj)
            % Removes all entries from the list of fundamental frequencies for a spectral lines simulation task.
            obj.hSimulationTask.invoke('ClearFundamentalFrequencies');
        end
        function SetInputPort(obj, portname)
            % Sets the input port for an amplifier simulation task or a mixer simulation task. For a mixer simulation task, IF is the input port in case of a consideration of the up-converting mode, for the down-converting mode RF is the input port.
            obj.hSimulationTask.invoke('SetInputPort', portname);
        end
        function SetOutputPort(obj, portname)
            % Sets the output port for an amplifier simulation task or a mixer simulation task. For a mixer simulation task, RF is the input port in case of a consideration of the up-converting mode, for the down-converting mode IF is the input port.
            obj.hSimulationTask.invoke('SetOutputPort', portname);
        end
        function SetLOPort(obj, portname)
            % Sets the local oscillator port for a mixer simulation task by name.
            obj.hSimulationTask.invoke('SetLOPort', portname);
        end
        function SetUpconverting(obj, upconverting)
            % Switches on/off the consideration of the up-converting mode of the selected mixer simulation task.
            obj.hSimulationTask.invoke('SetUpconverting', upconverting);
        end
        function SetPortSignal(obj, portname, type, array)
            % Sets the signal type associated with the given port for the selected simulation task. The possible types are the same that are returned by GetPortSignalType. Values is an array of expressions that define the signal.
            % 
            % Type/Values pairs for Transient tasks:
            % Signal name                           Parameters to be given in the values array
            % "Gaussian"                            Fmin, Fmax, Vampl
            % "Pulse"                               Vinit, Vpulse, Tdelay, Trise, Tfall, Thold, Ttotal
            % "Sine"                                Voffset, Vampl, Freq, Tdelay
            % "Damped sine"                         Voffset, Vampl, Freq, Tdelay, Damp
            % "Exponential rising"                  Vinit, Vend, Tdelay, Crise
            % "Exponential rising and falling"      Vinit, Vpulse, Tdelayrise, Crise, Tdelayfall, Cfall
            % "PRBS"                                N, Vpulse, Trise, Tfall, TPulse
            % "PRBS random initialization"          N, Vpulse, Trise, Tfall, TPulse
            % "K285"                                Vpulse, Trise, Tfall, TPulse
            % "K285 inverted"                       Vpulse, Trise, Tfall, TPulse
            % "Random"                              N, Vpulse, Trise, Tfall, TPulse
            % "Pulse Sequence"                      Vinit, Vpulse, Trise, Tfall, TdelayR, TdelayF, Ttotal, Initbit, Bitsequence (e.g. "100110") , Periodic ("true" or "false")
            % "Import"                              Filename
            % 
            % Type/Values pairs for AC-tasks:
            % Signal name           Parameters to be given in the values array
            % "Constant"            Amplitude, Phase (in degree)
            % "Import_File"         Filename of an external file with frequency - amplitude pairs
            % "Import_DS_Result"    Result tree name of an existing DS-Result. These values will be used as excitation.
            obj.hSimulationTask.invoke('SetPortSignal', portname, type, array);
        end
        function SetComplexPortExcitation(obj, portname, amplitude, phase)
            % Sets the complex excitation amplitude of an AC-Tasks. The task needs to exist before this function can be called.
            obj.hSimulationTask.invoke('SetComplexPortExcitation', portname, amplitude, phase);
        end
        function SetRealPortExcitation(obj, portname, amplitude)
            % Sets the excitation amplitude of an DC-Tasks. The task needs to exist before this function can be called.
            obj.hSimulationTask.invoke('SetRealPortExcitation', portname, amplitude);
        end
        function SetPortSourceType(obj, portname, type)
            % Sets the source type associated with the given port for the selected simulation task.
            % Possible values are:
            % "None"
            % "Voltage"
            % "Current"
            %  "Signal"
            obj.hSimulationTask.invoke('SetPortSourceType', portname, type);
        end
        function value = The(obj)
            % The task needs to exist and "SetComplexPortExcitation" ("SetRealPortExcitation") has to be called before this function can be executed.
            value = obj.hSimulationTask.invoke('The');
        end
        function SetPortSignalName(obj, portname, signalname)
            % Sets a user defined name for an already existing excitation signal of port no. portname.
            obj.hSimulationTask.invoke('SetPortSignalName', portname, signalname);
        end
        function LoadLisFile(obj)
            % This method is only applicable for circuit simulation tasks that have the "HSPICE export" enabled in their "Circuit simulator" frame. Furthermore, it requires that the HSPICE simulator has been executed on the HSPICE netlist, generated by the circuit simulation task. The method reads the results from the lis-file that has been generated by the HSPICE simulator and puts them into the Design Studio result tree. .
            obj.hSimulationTask.invoke('LoadLisFile');
        end
        %% Queries
        function bool = ArePortsDependent(obj, portname1, portname2)
            % Checks if two external ports specified by their names are dependent. The method returns True if the two ports are connected through some components of the model.
            bool = obj.hSimulationTask.invoke('ArePortsDependent', portname1, portname2);
        end
        function string = GetUnit(obj, unittype)
            % Returns the unit for the given type specified for the selected task. This is either the task's local unit or the project's global unit.
            string = obj.hSimulationTask.invoke('GetUnit', unittype);
        end
        function double = GetUnitScale(obj, unittype)
            % Returns the unit scale for the given type specified for the selected task. This is either the task's local scale or the project's global scale.
            double = obj.hSimulationTask.invoke('GetUnitScale', unittype);
        end
        function name = GetNameOfCurrentTask(obj)
            % Returns the name of the currently running task while the simulation is performed.
            name = obj.hSimulationTask.invoke('GetNameOfCurrentTask');
        end
        function string = GetModelFolder(obj, absolute)
            % Returns the generic model folder of the selected task, or an empty string if no task is selected. If absolute is false, the path is returned relative to the project model folder that can be obtained with GetProjectPath("ModelDS"). Note that not all tasks store individual model files, so the returned folder might not contain any files or not exist.
            string = obj.hSimulationTask.invoke('GetModelFolder', absolute);
        end
        function string = GetResultFolder(obj, absolute)
            % Returns the generic result folder of the selected task, or an empty string if no task is selected. If absolute is false, the path is returned relative to the project result folder that can be obtained with GetProjectPath("ResultDS"). Note that the returned folder is only used for result files without tree item. 1D results and tables are stored in different locations. You can get those paths via the ResultTree Object from the corresponding tree names.
            string = obj.hSimulationTask.invoke('GetResultFolder', absolute);
        end
        function string = GetProperty(obj, propertyname)
            % Inverse method to SetProperty(). Returns the value of the specified property.  For details on valid properties, see SetProperty().
            string = obj.hSimulationTask.invoke('GetProperty', propertyname);
        end
        function bool = GetUpconverting(obj)
            % Returns if the selected mixer simulation task considers the up-converting mode.
            bool = obj.hSimulationTask.invoke('GetUpconverting');
        end
        function string = GetPortSignalType(obj, portname)
            % Returns the signal type associated with the given port for the selected simulation task. Possible return values are "None" (if no signal is assigned to the specified port, i.e. the port will be considered as impedance), "Gaussian", "Pulse", "Sine", "Damped sine", "Exponential rising", "Exponential rising and falling", "PRBS", "PRBS random initialization", "K285", "K285 inverted", "Random", "Pulse Sequence" and "Import".
            string = obj.hSimulationTask.invoke('GetPortSignalType', portname);
        end
        function string = GetPortSourceType(obj, portname)
            % Returns the source type associated with the given port for the selected simulation task. Possible return values are "None" (if no signal is assigned to the specified port, i.e. the port will be considered as impedance), "Voltage", "Current" and "Signal".
            string = obj.hSimulationTask.invoke('GetPortSourceType', portname);
        end
        function GetGaussProperties(obj, portname, amplitude, fmin, fmax)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetGaussProperties''.');
            return;
            % Retrieves the settings for a gaussian excitation signal at the given port.
            obj.hSimulationTask.invoke('GetGaussProperties', portname, amplitude, fmin, fmax);
        end
        function int = StartTaskNameIteration(obj)
            % Resets the iterator for the simulation tasks and returns the number of simulation tasks.
            int = obj.hSimulationTask.invoke('StartTaskNameIteration');
        end
        function name = GetNextTaskName(obj)
            % Returns the next simulation task's name. Call StartTaskNameIteration before the first call of this method.
            name = obj.hSimulationTask.invoke('GetNextTaskName');
        end
        function bool = DoesExist(obj)
            % Checks if a task with the given name does already exist.
            bool = obj.hSimulationTask.invoke('DoesExist');
        end
        function name = GetTypeForTask(obj, taskname)
            % Returns the type of the simulation task given by name.
            name = obj.hSimulationTask.invoke('GetTypeForTask', taskname);
        end
        function int = GetSequenceTaskLoopCurrentIteration(obj)
            % If a sequence task is currently performing a loop, this function returns the current iteration number. If no loop is currently running, -1 is returned.
            int = obj.hSimulationTask.invoke('GetSequenceTaskLoopCurrentIteration');
        end
        function int = GetSequenceTaskLoopMaxIteration(obj)
            % If a sequence task is currently performing a loop, this function returns the maximum number of iterations. If no loop is currently running, -1 is returned.
            int = obj.hSimulationTask.invoke('GetSequenceTaskLoopMaxIteration');
        end
        %% Undocumented functions.
        % Found in 'Library\Result Templates\Time Signals\TDR from S-Parameter^+DS.rtp'
        function f = GetFMinForTask(obj, taskname)
            f = obj.hSimulationTask.invoke('GetFMinForTask', taskname);
        end
        % Found in 'Library\Result Templates\Time Signals\TDR from S-Parameter^+DS.rtp'
        function f = GetFMaxForTask(obj, taskname)
            f = obj.hSimulationTask.invoke('GetFMaxForTask', taskname);
        end
        % Found in 'Library\Result Templates\Time Signals\TDR from Time Signals^+DS.rtp'
        function n = GetNumberOfSources(obj, taskname)
            n = obj.hSimulationTask.invoke('GetNumberOfSources', taskname);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject       CST.DS.Project
        hSimulationTask

    end
end

%% Default Settings
% SetProperty('enabled', '1');
% SetProperty('logarithmic sweep', '0');
% SetProperty('maximum frequency range', '1');
% SetLocalUnit(<any>, 0)
% SetDiamondScheme(1)
% SetUpconverting(1)
% SetProperty('gmin', '-1');
% SetProperty('rmin', '1e-6');

%% Example - Taken from CST documentation and translated to MATLAB.
% %Creates a simulation task
% 
% simulationtask = dsproject.SimulationTask();
% .Reset
% .Type('S-Parameters');
% .Name('MyTask');
% .Create
% 
% .reset
% .name('AC1');
% .type('AC');
% .SetProperty('fmin', 0)
% .SetProperty('fmax', 1000)
% .SetProperty('maximum frequency range', '0');
% .create
% .SetComplexPortExcitation('1', '1', '45');
% .SetPortSourceType('1', 'CURRENT');
% 
% %Modifies an existing simulation task
% 
% .Reset
% .Name('MyTask');
% .SetProperty('maximum frequency range', '0');
% .SetLocalUnit('Frequency', 'GHz');
% .SetSweepData(1.0e-5, 10.0, 101)
% .SetProperty('logarithmic sweep', '1');
% 
% %Tests if a simulation task with a given name exists
% 
%     simulationtask.Name('Sweep1\SPara1');
% If SimulationTask.DoesExist Then
% ReportInformationToWindow('Task exists.');
% Else
% ReportInformationToWindow('Task doesn%t exist.');
% End If
% 
% % Update all tasks (UpdateAllTasks)
% 
% UpdateResults
% 
% 
