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

% This is the object that controls the high frequency solvers. A corresponding FDSolver Object allows to manipulate the settings for the Frequency Domain and Integral Equation solvers. The EigenmodeSolver Object is the specialized object for the calculation of Eigenmodes. Please note that the AKS Eigenmode solver method is still configured by the Solver Object.
classdef Solver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Solver object.
        function obj = Solver(project, hProject)
            obj.project = project;
            obj.hSolver = hProject.invoke('Solver');
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
            % Prepend With Solver and append End With
            obj.history = [ 'With Solver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Solver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['Solver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function TimeBetweenUpdates(obj, value)
            % Defines the time range between the plot window is updated during a simulation run.
            obj.AddToHistory(['.TimeBetweenUpdates "', num2str(value, '%.15g'), '"']);
        end
        function FrequencyRange(obj, fmin, fmax)
            % Sets the frequency range for the simulation. Changing the frequency range has several side effects. The mesh will be changed and all previous simulation results will be deleted. However, before the frequency range is actually changed, a dialog window will appear that asks to save the old results to another file.
            obj.AddToHistory(['.FrequencyRange "', num2str(fmin, '%.15g'), '", '...
                                              '"', num2str(fmax, '%.15g'), '"']);
        end
        function CalculateZandYMatrices(obj)
            % Starts the calculation for Z and Y matrices. The results will be displayed in the Navigation Tree.
            obj.AddToHistory(['.CalculateZandYMatrices']);
        end
        function CalculateVSWR(obj)
            % Starts the calculation for VSWR. The results will be displayed in the Navigation Tree.
            obj.AddToHistory(['.CalculateVSWR']);
        end
        %% Mesh
        function PBAFillLimit(obj, percentage)
            % Defines when a cell should be treated as entirely filled with Perfectly Conducting Material (PEC). So if a cell is filled with more than percentage of the cell with PEC, the entire Cell will be filled with PEC. For other materials this setting has no effect. Generally, this setting should not be changed.
            obj.AddToHistory(['.PBAFillLimit "', num2str(percentage, '%.15g'), '"']);
        end
        function UseSplitComponents(obj, flag)
            % Specifies if the matrix calculation is performed using split components (flag = True) or not (flag = False).
            obj.AddToHistory(['.UseSplitComponents "', num2str(flag, '%.15g'), '"']);
        end
        function EnableSubgridding(obj, flag)
            % Enables the MSS" (Multilevel Subgridding Scheme).
            obj.AddToHistory(['.EnableSubgridding "', num2str(flag, '%.15g'), '"']);
        end
        function AlwaysExludePec(obj, flag)
            % This method offers the possibility to automatically exclude all PEC regions from the calculation. In case that large PEC regions exist this option may produce a significant speed-up of the simulation.
            obj.AddToHistory(['.AlwaysExludePec "', num2str(flag, '%.15g'), '"']);
        end
        %% MPI Computation
        function MPIParallelization(obj, flag)
            % Enable or disable MPI computation for solver.
            obj.AddToHistory(['.MPIParallelization "', num2str(flag, '%.15g'), '"']);
        end
        %% Queries
        function double = GetFmin(obj)
            % Returns the minimum defined frequency.
            double = obj.hSolver.invoke('GetFmin');
        end
        function double = GetFmax(obj)
            % Returns the maximum defined frequency.
            double = obj.hSolver.invoke('GetFmax');
        end
        function int = GetNFsamples(obj)
            % Returns the total number of frequency points that are used to represent the scattering parameters.
            int = obj.hSolver.invoke('GetNFsamples');
        end
        function int = GetNumberOfPorts(obj)
            % Returns the number of defined Ports.
            int = obj.hSolver.invoke('GetNumberOfPorts');
        end
        function bool = ArePortsSubsequentlyNamed(obj)
            % Inquires whether the ports are consecutively numbered or not. If they are, the total number of ports equals to the last port name. Otherwise the last name might be higher.
            bool = obj.hSolver.invoke('ArePortsSubsequentlyNamed');
        end
        function int = GetStimulationPort(obj)
            % Returns -1, if ports = All, 0 if ports = Selected Ports and -2, if plane wave excitation is active.
            int = obj.hSolver.invoke('GetStimulationPort');
        end
        function int = GetStimulationMode(obj)
            % Returns 0, if stimulation port is not a wave guide port, returns -1, if modes = All and if there is a wave guide port.
            int = obj.hSolver.invoke('GetStimulationMode');
        end
        function long = GetTotalSimulationTime(obj)
            % Returns the total simulation time of a complete transient solver start, as the case may be including several port excitations.
            long = obj.hSolver.invoke('GetTotalSimulationTime');
        end
        function long = GetMatrixCalculationTime(obj)
            % Returns the running time of the matrix calculator.
            long = obj.hSolver.invoke('GetMatrixCalculationTime');
        end
        function long = GetLastSolverTime(obj)
            % Returns the simulation time of the last performed solver run.
            long = obj.hSolver.invoke('GetLastSolverTime');
        end
        %% Time Domain Wakefield Solver General
        function int = Start(obj)
            % Starts the Time Domain Simulation with the current settings and returns 1 if the calculation is successfully finished and 0 if it failed.
            int = obj.hSolver.invoke('Start');
        end
        function AutoNormImpedance(obj, flag)
            % S-Parameters are always normalized to a reference impedance. You may either select to norm them to the calculated impedance of the stimulation port or you may specify a number of your choice.  If flag is False the reference impedance will be the calculated impedance of the input port.
            obj.AddToHistory(['.AutoNormImpedance "', num2str(flag, '%.15g'), '"']);
        end
        function NormingImpedance(obj, imped)
            % Specifies the impedance to be used as reference impedance for the scattering parameters. This setting will only be considered if AutoNormImpedance is set to True.
            obj.AddToHistory(['.NormingImpedance "', num2str(imped, '%.15g'), '"']);
        end
        function MeshAdaption(obj, flag)
            % If MeshAdaption is enabled (flag = True) several Simulation runs are started to automatically find the optimum mesh for the given Problem.
            obj.AddToHistory(['.MeshAdaption "', num2str(flag, '%.15g'), '"']);
        end
        function UseDistributedComputing(obj, flag)
            % If flag is set to True this method enables the distributed calculation of different solver runs across the network.
            obj.AddToHistory(['.UseDistributedComputing "', num2str(flag, '%.15g'), '"']);
        end
        function DistributeMatrixCalculation(obj, flag)
            % If flag is set to True the matrix calculation is performed separately for each distributed solver run on the remote machines. Otherwise the matrix calculation is done only once on the machine where the frontend is running.
            obj.AddToHistory(['.DistributeMatrixCalculation "', num2str(flag, '%.15g'), '"']);
        end
        function HardwareAcceleration(obj, flag)
            % If flag = true, hardware acceleration for the transient solver is activated. Please note, that a hardware acceleration card has to be inserted into your computer in order to profit from this setting.
            obj.AddToHistory(['.HardwareAcceleration "', num2str(flag, '%.15g'), '"']);
        end
        function StoreTDResultsInCache(obj, flag)
            % If flag is set to True this method stores results of the time domain solver in the result cache.
            obj.AddToHistory(['.StoreTDResultsInCache "', num2str(flag, '%.15g'), '"']);
        end
        function FrequencySamples(obj, nSamples)
            % Defines the resolution of all frequency domain signals for the next simulation. This setting has no significant influence on the total simulation time. It only influences the Discrete Fourier Transform (DFT) that is used to transform the time domain signals into the frequency domain. nSamples will be the total number of frequency samples that the frequency domain signals will have.
            obj.AddToHistory(['.FrequencySamples "', num2str(nSamples, '%.15g'), '"']);
        end
        function FrequencyLogSamples(obj, nSamples)
            % Defines the resolution of all frequency domain signals for the next simulation using a logarithmic sample distribution. This setting has no significant influence on the total simulation time. It only influences the Discrete Fourier Transform (DFT) that is used to transform the time domain signals into the frequency domain. nSamples will be the total number of logarithmically distributed frequency samples that the frequency domain signals will have.
            obj.AddToHistory(['.FrequencyLogSamples "', num2str(nSamples, '%.15g'), '"']);
        end
        function ConsiderTwoPortReciprocity(obj, flag)
            % If flag is set to False, a simulation for every port is performed in order to get the scattering parameter matrix. Otherwise, for reciprocal (loss free two port) systems only one simulation will be made.
            obj.AddToHistory(['.ConsiderTwoPortReciprocity "', num2str(flag, '%.15g'), '"']);
        end
        function EnergyBalanceLimit(obj, limit)
            % Method for the two-port-reciprocity functionality (ConsiderTwoPortReciprocity method) to determine whether or not the structure is loss free. This determination is done by checking the energy balance. For reciprocal and loss free structures the energy balance should be one. If the simulated balance differs to one for lower than the given limit over the whole frequency range the structure is assumed to be loss free.
            obj.AddToHistory(['.EnergyBalanceLimit "', num2str(limit, '%.15g'), '"']);
        end
        function TimeStepStabilityFactor(obj, value)
            % Specifies a stability factor that is multiplied to the current valid time step. Note: Normally the current time step is matched to the stability limit, thus factor values greater than 1 may make the time domain simulation unstable.
            obj.AddToHistory(['.TimeStepStabilityFactor "', num2str(value, '%.15g'), '"']);
        end
        function NormalizeToReferenceSignal(obj, flag)
            % In case of the default Gaussian excitation signal, which is predefined in CST MICROWAVE STUDIO, all frequency results of the transient solver are automatically normalized to the spectrum of this default signal in order to provide consistent broadband results, independent of the transient excitation signal. This allows convenient comparisons to e.g. frequency domain solver results.
            % However, selecting other signals for excitation, e.g. a rectangular pulse or an imported signal, this normalization step is not done by default. This means that in these cases all frequency results are purely represented by the unnormalized discrete Fourier transformation of the correspondent  transient data. In any case, you can still apply a normalization step to the selected reference signal in CST MICROWAVE STUDIO by enabling this check button, independent whether this signal is actually used or not. As mentioned above, changing this button has no influence when the default Gaussian excitation signal is used. The normalization to the default signal can be changed by using the command NormalizeToDefaultSignalWhenInUse.
            % In case of a transient co-simulation run, usually the excitation is driven from within CST DESIGN STUDIO. Consequently also the result normalization can be controlled here, either normalizing to a Gaussian reference signal or not. This can be defined for each task separately and consistently effects both, the frequency domain results in CST  MICROWAVE STUDIO as well as in CST DESIGN STUDIO.
            obj.AddToHistory(['.NormalizeToReferenceSignal "', num2str(flag, '%.15g'), '"']);
        end
        function NormalizeToDefaultSignalWhenInUse(obj, flag)
            % In case of the default gaussian excitation signal, which is always predefined in CST MICROWAVE STUDIO, all frequency results of the transient solver are automatically normalized to the spectrum of this default signal in order to provide consistent broadband results, independent of the transient excitation signal. This allows convenient comparisons to e.g. frequency domain solver results. This behavior can be changed by calling this command with flag = false, then all frequency results are purely represented by the unnormalized discrete Fourier transformation of the correspondent transient data. Please note that this command has no influence when the default signal is not in usage for excitation.
            obj.AddToHistory(['.NormalizeToDefaultSignalWhenInUse "', num2str(flag, '%.15g'), '"']);
        end
        function AutoDetectIdenticalPorts(obj, flag)
            % If flag = true, the geometry and settings of waveguide ports are compared. Identical ports are clustered in order to skip repeated line impedance adaptation runs. If identical ports are found, line impedance adaptation runs will be done for one reference port per cluster only.
            obj.AddToHistory(['.AutoDetectIdenticalPorts "', num2str(flag, '%.15g'), '"']);
        end
        function AutomaticTimeSignalSampling(obj, flag)
            % If flag = true, the transient solver automatically samples all time signals that are written to disk to reduce the data amount while still fulfilling the sampling theorem. By deactivating this automatic functionality the signals are written with highest possible sampling rate, i.e. every timestep.
            obj.AddToHistory(['.AutomaticTimeSignalSampling "', num2str(flag, '%.15g'), '"']);
        end
        function ConsiderExcitationForFreqSamplingRate(obj, flag)
            % The transient solver automatically determines a downsampling factor for the frequency domain result evaluation. This enables reducing the computation effort and data processing amount for all the computed results and active features. The downsampling factor will be determined to fulfill the sampling theorem.
            % If flag = false the considered maximum frequency for the sampling theorem is the one selected with the FrequencyRange method. If flag = true an estimation of the maximum frequency of the excitation signals is also used to improve the downsampling factor. This is particularly appropriate in correspondence of digital signals which produce high frequency components - possibly not completely resolved or affected by aliasing - even if at the cost of a higher sampling rate, up to every timestep.
            obj.AddToHistory(['.ConsiderExcitationForFreqSamplingRate "', num2str(flag, '%.15g'), '"']);
        end
        function TDRComputation(obj, flag)
            % If the flag is set to true, the transient solver performs an online TDR analysis for step or Gaussian excitation signals and adds the corresponding signal curve into the result tree. The TDR calculation is applied for single port excitations of discrete ports or waveguide ports with (Q)TEM modes.
            obj.AddToHistory(['.TDRComputation "', num2str(flag, '%.15g'), '"']);
        end
        function TDRShift50Percent(obj, flag)
            % This command allows  the shift of the online TDR response in time: The TDR plot then starts at t=0, when the input pulse for the TDR computation reached 50% of its maximum.
            obj.AddToHistory(['.TDRShift50Percent "', num2str(flag, '%.15g'), '"']);
        end
        function TDRReflection(obj, flag)
            % If the flag is set to true, the solver calculates the reflection factor over time instead of the time domain reflectometry (TDR). The reflection factor is bound between -1 and +1. Therefore even for an open transmission line, the reflection factor stays within these limits – in contrast to the TDR, which is infinite in this case. The reflection factor is also useful, if the structure needs to be optimized, hence the reflection minimized.
            obj.AddToHistory(['.TDRReflection "', num2str(flag, '%.15g'), '"']);
        end
        function UseBroadBandPhaseShift(obj, flag)
            % If the flag is set to true, the phase shift defined either for a simultaneous excitation or for a circular/elliptical plane wave excitation will be considered as a broadband behavior, respectively.
            obj.AddToHistory(['.UseBroadBandPhaseShift "', num2str(flag, '%.15g'), '"']);
        end
        function SetBroadBandPhaseShiftLowerBound(obj, value)
            % Method for the broadband phase shift functionality defined either for a simultaneous excitation or for a circular/elliptical plane wave excitation (UseBroadBandPhaseShift).
            % The broadband phase shift filter is computed by means of an Hilbert filter which guarantees accurate results in the frequency range [ lower bound factor * fMax, fMax ] where fMax is the upper simulation frequency range. Reducing the lower bound factor allows to enlarge the accuracy frequency range at the expense of higher complexity and computational costs for the filter evaluation.
            obj.AddToHistory(['.SetBroadBandPhaseShiftLowerBound "', num2str(value, '%.15g'), '"']);
        end
        function SParaAdjustment(obj, flag)
            % Disable this functionality to receive pure S-parameter results without any passivity adjustment.
            obj.AddToHistory(['.SParaAdjustment "', num2str(flag, '%.15g'), '"']);
        end
        function PrepareFarfields(obj, flag)
            % All farfield results are automatically precalculated to speed up the post-processing.
            obj.AddToHistory(['.PrepareFarfields "', num2str(flag, '%.15g'), '"']);
        end
        function MonitorFarFieldsNearToModel(obj, flag)
            % All farfield results are computed and evaluated on a box close to the structure instead of on the global simulation bounding box. This reduces the numerical dispersion due to the integration of the electric and magnetic field and increases the results accuracy. The command applies to the farfield (and RCS) probes and to all non-subvolume defined farfield monitors.
            obj.AddToHistory(['.MonitorFarFieldsNearToModel "', num2str(flag, '%.15g'), '"']);
        end
        function MatrixDump(obj, flag)
            % If flag = true, all solver relevant matrices are dumped to file.
            obj.AddToHistory(['.MatrixDump "', num2str(flag, '%.15g'), '"']);
        end
        function RestartAfterInstabilityAbort(obj, flag)
            % If flag = true, the transient solver is automatically restarted twice with a reduced timestep after an instability abort. In case that the occurred instability is due to the time discretization, this process helps to provide a stable simulation during the restarted run.
            obj.AddToHistory(['.RestartAfterInstabilityAbort "', num2str(flag, '%.15g'), '"']);
        end
        function MaximumNumberOfThreads(obj, number)
            % Define the maximum number of parallel threads to be used for the transient solver run.
            obj.AddToHistory(['.MaximumNumberOfThreads "', num2str(number, '%.15g'), '"']);
        end
        function SetPMLType(obj, key)
            % Define the PML formulation type. Allowed algorithms are ConvPML for the Convolution PML or GTPML for the Generalized PML theory.
            % key: 'ConvPML'
            %      'GTPML'
            obj.AddToHistory(['.SetPMLType "', num2str(key, '%.15g'), '"']);
        end
        function DiscreteItemUpdate(obj, key)
            % Define the update schema for the discrete items, i.e. discrete ports and lumped elements, to be used by the transient solver run.
            % Selecting the Gap schema (default choice) the discrete face element will be modeled as a PEC (perfectly electric conductor) sheet except for a small gap where the source excitation is imprinted and the load impedance is located. A similar modeling applies to the discrete edge element where the source/load is located in the middle of a PEC wire.
            % Selecting the Distributed schema (preview choice) models the source and load as distributed over the entire surface of the face (entire length of the wire, respectively) providing a more robust representation as well as supporting coaxial face elements and also discrete current face ports.
            % The method DiscreteItemUpdate applies the update schema both to the edge and to the face discrete ports and lumped elements. The method DiscreteItemEdgeUpdate and DiscreteItemFaceUpdate applies the update schema only to the edge and face discrete elements, respectively.
            % key: 'Gap'
            %      'Distributed'
            obj.AddToHistory(['.DiscreteItemUpdate "', num2str(key, '%.15g'), '"']);
        end
        function DiscreteItemEdgeUpdate(obj, key)
            % See DiscreteItemUpdate for details.
            % key: 'Gap'
            %      'Distributed'
            obj.AddToHistory(['.DiscreteItemEdgeUpdate "', num2str(key, '%.15g'), '"']);
        end
        function DiscreteItemFaceUpdate(obj, key)
            % See DiscreteItemUpdate for details.
            % key: 'Gap'
            %      'Distributed'
            obj.AddToHistory(['.DiscreteItemFaceUpdate "', num2str(key, '%.15g'), '"']);
        end
        function SuppressTimeSignalStorage(obj, key)
            % Selects the mode to be used for the suppression of writing time signals into the storage database. When a signal is not written into the storage database, no entry is added to the result Navigation Tree.
            % The parameter key may have one of the following values:
            % True / All              All signals will be suppressed, i.e. no signals are written to database.
            % False / None / Reset    No signals will be suppressed, i.e. all signals will be written to database. This is the default setting.
            % Ports                   All port signals are suppressed, i.e. all in- and outgoing signals for all port types as well as the monitored voltage and current of discrete ports.
            % LumpedElements          The monitored voltage and current of lumped elements will be suppressed.
            % Probes                  All probe signals will be suppressed. This holds for near- as well as for farfield probes.
            % UIMonitors              All 1D voltage and current monitors are suppressed.

            obj.AddToHistory(['.SuppressTimeSignalStorage "', num2str(key, '%.15g'), '"']);
        end
        %% Time Domain Solver Excitation
        function CalculateModesOnly(obj, flag)
            % If flag is True, the solver calculates only the port modes.
            obj.AddToHistory(['.CalculateModesOnly "', num2str(flag, '%.15g'), '"']);
        end
        function StimulationMode(obj, key)
            % Selects the mode to be used for excitation.
            obj.AddToHistory(['.StimulationMode "', num2str(key, '%.15g'), '"']);
        end
        function parameter = The(obj)
            % All             All modes will be excited once.
            % int modeNumber  The mode number to be used for excitation.
            parameter = obj.hSolver.invoke('The');
        end
        function StimulationPort(obj, key)
            % Selects the port(s)  to be used for excitation.
            % The parameter key may have one of the following values:
            % All             All ports will be excited once.
            % Selected        Only those ports / modes are used for excitation that have been set by ExcitationPortMode.
            % "Plane Wave"    A plane wave will be used for excitation.
            % int portNumber  The port number (port name) to be used for excitation.
            obj.AddToHistory(['.StimulationPort "', num2str(key, '%.15g'), '"']);
        end
        function ResetExcitationModes(obj)
            % Resets the complete excitation list, which was previously defined by applying methods ExcitationPortMode or ExcitationCurrentDistribution.
            obj.AddToHistory(['.ResetExcitationModes']);
        end
        function ExcitationPortMode(obj, port, mode, ampli, phase_or_time, signal, flag)
            % Defines the excitation signal signal that is used to excite the port mode mode at the port port. The excitation signal must be defined previously. The signal curve is modified due to the defined ampli and phase/time values, describing the amplitude and the time shift of the excitation. The latter can be defined as a time shift or a phase shift, using the SetSimultaneousExcitationOffset method. The boolean argument flag activates the time shift definition.
            % Note: If signal = "default", the chosen reference signal is used for excitation. MWS offers an Excitation Signal Library where different time signals can be chosen from. Time signals other than "default" can be chosen only if SimultaneousExcitation is set to True.
            obj.AddToHistory(['.ExcitationPortMode "', num2str(port, '%.15g'), '", '...
                                                  '"', num2str(mode, '%.15g'), '", '...
                                                  '"', num2str(ampli, '%.15g'), '", '...
                                                  '"', num2str(phase_or_time, '%.15g'), '", '...
                                                  '"', num2str(signal, '%.15g'), '", '...
                                                  '"', num2str(flag, '%.15g'), '"']);
        end
        function ExcitationCurrentDistribution(obj, name, ampli, phase_or_time, signal, flag)
            % Defines an excitation for simultaneous or selected simulation, either applied to a port mode or a current distribution. The parameters port/mode or name, respectively, define the excitation source (port/mode or current distribution) to be used.
            % The selected excitation will be modulated by a time signal of name signal., that has to be defined previously. This signal curve is modified due to the defined ampli and phase/time values, describing the amplitude and the time shift of the excitation. The latter is either based on a time shift or a phase shift definition, depending on the selection of the SetSimultaneousExcitationOffset method. The boolean argument flag activates this excitation definition for the next simulation.
            % Note: If signal = "default", the chosen reference signal is used for excitation.
            % MWS offers an Excitation Signal Library where different time signals can be chosen from.
            % Time signals other than "default" can be chosen only if SimultaneousExcitation is set to True.
            obj.AddToHistory(['.ExcitationCurrentDistribution "', num2str(name, '%.15g'), '", '...
                                                             '"', num2str(ampli, '%.15g'), '", '...
                                                             '"', num2str(phase_or_time, '%.15g'), '", '...
                                                             '"', num2str(signal, '%.15g'), '", '...
                                                             '"', num2str(flag, '%.15g'), '"']);
        end
        function DefineExcitationSettings(obj, key, name, mode, ampli, phase_or_time, signal, accuracy, fmin, fmax, flag)
            % Similar to the VBA methods above, this method also allows different specifications of excitation settings for different ports/fieldsources. In addition to the amplitude, the phase/time delay and the signal definition, here you have also the possibility to define accuracy as well as a frequency interval for field monitoring.
            % A specific accuracy value can be defined to overwrite the default value which is given on the solver dialog page. This option allows different solver runs (port excitations) with a different level of accuracy, what is useful for example to consider certain EMC standards.
            % In addition an individual frequency range can be entered per excitation (fmin and fmax), defining the valid interval for evaluating frequency based field monitors. This means that any defined field monitor is only evaluated and stored when its frequency is inside the mentioned interval, otherwise it is ignored. This helps saving time and disk space in case for example of multiband antenna setups. Using the default setting will again consider all monitors inside the global frequency interval.
            % Please note, that both settings are only available for sequential excitation, i.e. they will be ignored in case simultaneous excitation is selected.
            % key: 'portmode'
            %      'fieldsource'
            obj.AddToHistory(['.DefineExcitationSettings "', num2str(key, '%.15g'), '", '...
                                                        '"', num2str(name, '%.15g'), '", '...
                                                        '"', num2str(mode, '%.15g'), '", '...
                                                        '"', num2str(ampli, '%.15g'), '", '...
                                                        '"', num2str(phase_or_time, '%.15g'), '", '...
                                                        '"', num2str(signal, '%.15g'), '", '...
                                                        '"', num2str(accuracy, '%.15g'), '", '...
                                                        '"', num2str(fmin, '%.15g'), '", '...
                                                        '"', num2str(fmax, '%.15g'), '", '...
                                                        '"', num2str(flag, '%.15g'), '"']);
        end
        function PhaseRefFrequency(obj, value)
            % The phase values defined in the excitation list are converted into corresponding time shifts for the time signals by use of this reference frequency. If the reference frequency is set to '0', time shift instead of phase shift is activated. (see ExcitationPortMode Method)
            obj.AddToHistory(['.PhaseRefFrequency "', num2str(value, '%.15g'), '"']);
        end
        function SParameterPortExcitation(obj, flag)
            % If no simultaneous excitation is selected (see command SimultaneousExcitation), this options allows changing the behavior of the sequential excitation processing of the selected ports/sources (see command ExcitationPortMode). Enabling this option calculates standard S-Parameter results with fixed amplitude and signal settings, while disabling allows the simulation of each port/source independently with arbitrary amplitude and signal settings leading to so-called F-parameters.
            obj.AddToHistory(['.SParameterPortExcitation "', num2str(flag, '%.15g'), '"']);
        end
        function SimultaneousExcitation(obj, flag)
            % Enables simultaneaous excitation.
            obj.AddToHistory(['.SimultaneousExcitation "', num2str(flag, '%.15g'), '"']);
        end
        function SetSimultaneousExcitAutoLabel(obj, flag)
            % If a set of excitations has been defined for one simultaneous excitation run, an automatically generated label (as a prefix) is used to name the signals produced by the simulation. Use this method to activate this automatic labeling.
            obj.AddToHistory(['.SetSimultaneousExcitAutoLabel "', num2str(flag, '%.15g'), '"']);
        end
        function SetSimultaneousExcitationLabel(obj, label)
            % If the SetSimultaneousExcitAutoLabel method is disabled, it is possible to manually define a prefix name for the signals produced by simultaneous excitation run.
            obj.AddToHistory(['.SetSimultaneousExcitationLabel "', num2str(label, '%.15g'), '"']);
        end
        function SetSimultaneousExcitationOffset(obj, key)
            % This method determines the time shift definition between different time signals applied for simultaneous excitation.
            % The parameter key may have one of the following values:
            % "Timeshift"     The time shift value defined with the ExcitationPortMode method is directly used to shift the signals in time.
            % "Phaseshift"    The phase shift value defined with the ExcitationPortMode method is transferred in a time shift value using the phase reference frequency (PhaseRefFrequency method). This value is then used to shift the signals in time.
            obj.AddToHistory(['.SetSimultaneousExcitationOffset "', num2str(key, '%.15g'), '"']);
        end
        function ExcitationSelectionShowAdditionalSettings(obj, flag)
            % Setting the flag as active makes visible some more excitation settings in the Excitation Selection dialog.
            % These settings are only available for sequential excitation, i.e. they will be ignored in case simultaneous excitation is selected. A specific Accuracy value can be defined to overwrite the global default value. In addition an individual frequency range can be entered per excitation (by setting Min. and Max. Monitor Frequencies), defining the valid interval for evaluating frequency based field monitors.
            obj.AddToHistory(['.ExcitationSelectionShowAdditionalSettings "', num2str(flag, '%.15g'), '"']);
        end
        function SuperimposePLWExcitation(obj, flag)
            % This method enables the superimposed stimulation of a previously defined plane wave in addition to a usual S-Parameter calculation. As excitation source type one or more port modes are selected using the StimulationPort and StimulationMode methods and the plane wave excitation is then applied in addition without producing any plane wave specific output files. Consequently the energy contribution of the plane wave excited into the calculation domain influences the S-Parameter and balance results possibly showing some active behavior. Please note that the default reference signal is used for exciting the plane wave.
            obj.AddToHistory(['.SuperimposePLWExcitation "', num2str(flag, '%.15g'), '"']);
        end
        function ShowExcitationListAccuracy(obj, flag)
            % This method shows the correspondent entry fields for the definition of the solver accuracy in the solver excitation selection  dialog.
            obj.AddToHistory(['.ShowExcitationListAccuracy "', num2str(flag, '%.15g'), '"']);
        end
        function ShowExcitationListMonitorFreqInterval(obj, flag)
            % This method shows the correspondent entry fields for the definition of the monitor frequency range in the solver excitation selection  dialog.
            obj.AddToHistory(['.ShowExcitationListMonitorFreqInterval "', num2str(flag, '%.15g'), '"']);
        end
        %% Time Domain Solver S-Parameter Symmetries
        function SParaSymmetry(obj, flag)
            % Use s-parameter symmetries.
            obj.AddToHistory(['.SParaSymmetry "', num2str(flag, '%.15g'), '"']);
        end
        function ResetSParaSymm(obj)
            % Resets all previously defined s-parameter symmetries.
            obj.AddToHistory(['.ResetSParaSymm']);
        end
        function DefSParaSymm(obj)
            % Defines a new set of S-parameter symmetries. Each call to SPara adds S-parameters to the set of S-parameter symmetries defined using this method. For this set all S-parameters are considered to be equivalent. You have to call this method at least once before calling SPara. See also the example for S-parameter symmetry setup.
            obj.AddToHistory(['.DefSParaSymm']);
        end
        function SPara(obj, portNo1, portNo2)
            % Adds an S-parameter defined by a pair of ports to the symmetry set that was defined in advance by a call of DefSParaSymm. This S-parameter is equal to all S-parameters of the same symmetry set defined by previous calls to SPara . The definition of the two involved port numbers should be enclosed in quotation marks (" "). See also the example for S-parameter symmetry setup.
            obj.AddToHistory(['.SPara "', num2str(portNo1, '%.15g'), '", '...
                                     '"', num2str(portNo2, '%.15g'), '"']);
        end
        %% Time Domain Solver Waveguide Ports
        function WaveguidePortGeneralized(obj, flag)
            % Switches the port mode solver type between generalized (on) or standard (off).
            obj.AddToHistory(['.WaveguidePortGeneralized "', num2str(flag, '%.15g'), '"']);
        end
        function WaveguidePortModeTracking(obj, flag)
            % Activates the mode tracking. This is optional for the generalized port mode solver. If the standard port mode solver is selected this setting is ignored.
            obj.AddToHistory(['.WaveguidePortModeTracking "', num2str(flag, '%.15g'), '"']);
        end
        function AbsorbUnconsideredModeFields(obj, key)
            % This option indicates whether unconsidered mode fields occurring at the waveguide ports should be absorbed by a Mur open boundary. These fields can be given by slight field errors due to inhomogeneous ports (the non-broadband waveguide port operators work less accurately with increasing distance from the mode calculation frequency) or by higher order modes which are not considered by the port operator.
            % "Automatic"     When selecting this option the absorption is only active for inhomogeneous ports.
            % "Activate"      When selecting this option the absorption is always activated.
            % "Deactivate"    When selecting this option the absorption is always deactivated.
            obj.AddToHistory(['.AbsorbUnconsideredModeFields "', num2str(key, '%.15g'), '"']);
        end
        function FullDeembedding(obj, flag)
            % Set flag to True to perform a calculation with inhomogeneous port accuracy enhancement ("full deembedding"). This implies that the source type is set automatically to All ports / All modes. If some inhomogeneous ports occur in the structure the port modes will be calculated with broadband information which is added to the result tree. After all solver runs have finished the complete S-parameter matrix is generated considering the broadband behavior of the port modes. The number of frequency samples for this procedure can be defined in the special solver settings/waveguide. For more detailed information see the waveguide port overview.
            obj.AddToHistory(['.FullDeembedding "', num2str(flag, '%.15g'), '"']);
        end
        function SetSamplesFullDeembedding(obj, nSamples)
            % Sets the number of frequency samples for calculations with inhomogeneous port accuracy enhancement (FullDeembedding).
            obj.AddToHistory(['.SetSamplesFullDeembedding "', num2str(nSamples, '%.15g'), '"']);
        end
        function DispEpsFullDeembedding(obj, flag)
            % Consider the dispersive behavior of the permittivity in port materials (real and imaginary part) for calculations with inhomogeneous port accuracy enhancement. This setting is only considered for the standard port mode solver. The generalized port mode solver always considers the electric or magnetic dispersive materials in calculations with inhomogeneous port accuracy enhancement.
            obj.AddToHistory(['.DispEpsFullDeembedding "', num2str(flag, '%.15g'), '"']);
        end
        function SetModeFreqFactor(obj, value)
            % Specifies the frequency that is used for the waveguide port mode calculation. The factor is set relatively to the current frequency range. Therefore value may range between 0 and 1.
            obj.AddToHistory(['.SetModeFreqFactor "', num2str(value, '%.15g'), '"']);
        end
        function ScaleTETMModeToCenterFrequency(obj, flag)
            % Enabling this option will scale any TE/TM mode excitation to the center frequency of the globally defined frequency range. The mode pattern of a TE/TM mode is analytically known over the whole frequency band and the power normalization of the mode amplitude can either be done at the mode evaluation frequency or at the center frequency. The latter is activated by default to always ensure the same time signal imprint, independent of the selected mode evaluation frequency. Consequently, if this option is disabled, the port signals will change when adjusting the mode evaluation frequency.
            % Please note, that all frequency results (1D signals or field monitors) are in any case normalized to a constant value over the frequency band, i.e. the correct TE/TM scaling is considered for every evaluated frequency point.
            obj.AddToHistory(['.ScaleTETMModeToCenterFrequency "', num2str(flag, '%.15g'), '"']);
        end
        function SetVoltageWaveguidePort(obj, portname, value, flag)
            % This command applies a pure voltage excitation to the waveguide port with the name portname. The voltage value defines the amplitude of the excitation. Please note that this special excitation is only valid for the basic (Q)TEM mode of a two-conductor port. With the flag you can enable or disable again this special treatment.
            obj.AddToHistory(['.SetVoltageWaveguidePort "', num2str(portname, '%.15g'), '", '...
                                                       '"', num2str(value, '%.15g'), '", '...
                                                       '"', num2str(flag, '%.15g'), '"']);
        end
        function AdaptivePortMeshing(obj, flag)
            % Activates the adaptive port meshing feature to automatically calculate a more accurate line impedance and mode pattern. For this purpose the port mode solver runs several passes while adaptively refining the port mesh.
            obj.AddToHistory(['.AdaptivePortMeshing "', num2str(flag, '%.15g'), '"']);
        end
        function AccuracyAdaptivePortMeshing(obj, nPercent)
            % Represents an accuracy limit for the relative error of the line impedance. The adaptive port meshing is finished when the line impedance has not changed more than this percentage value for two following passes or the maximum number of passes is reached.
            obj.AddToHistory(['.AccuracyAdaptivePortMeshing "', num2str(nPercent, '%.15g'), '"']);
        end
        function PassesAdaptivePortMeshing(obj, nPasses)
            % Restricts the number of passes in the adaptive port meshing if the port line impedance takes too long to converge.
            obj.AddToHistory(['.PassesAdaptivePortMeshing "', num2str(nPasses, '%.15g'), '"']);
        end
        %% Time Domain Solver Steady State
        function NumberOfPulseWidths(obj, nPulses)
            % Limits the maximum simulation time. This setting should not be used to stop the simulation generally. By default the steady state monitor should stop it before the maximum simulation time is reached. If the simulation is stopped before the steady state monitors stop it, the calculated scattering parameters will be incorrect. The pulse width is directly related to the chosen frequency range. It is defined by the Gaussian pulse that is used for a default broadband time domain simulation.
            obj.AddToHistory(['.NumberOfPulseWidths "', num2str(nPulses, '%.15g'), '"']);
        end
        function SteadyStateLimit(obj, key)
            % This setting defines the steady state monitor. It influences the duration of the simulation. It is a value for the accuracy of the frequency domain signals that are calculated by Fourier Transformation of the time signals.
            % This setting has to be understood only in connection with the processing of the time signals. Errors made by discretising a structure can only be influenced by manipulating the mesh.
            % Every simulation stops at some time. This means, that the signals that are calculated are truncated at this point, regardless to their values. If these values are non zero the Fourier Transformation will produce an error, because only a part of the whole signal with all its non zero values has been used for the transformation. So the smaller the signals are, the more accurate the frequency domain values will be. To get a value for the accuracy not the signal amplitudes itself are used, but the total energy inside of the calculation domain. During the simulation the energy is frequently calculated and related to the maximum energy that has been monitored. This value in a logarithmic scale defines the accuracy.
            % The parameter key may have one of the following representation:
            % "accuracy_dB"   where accuracy_dB is an integer value (in dB unit) for the steady state monitor. It must belong to the interval [-80 , 0] dB.
            % "No Check"      The steady state monitor is disabled. If no additional stop criteria are defined by means of the method AddStopCriterion the simulation stops after the defined NumberOfPulseWidths.
            obj.AddToHistory(['.SteadyStateLimit "', num2str(key, '%.15g'), '"']);
        end
        %% With the following commands it is possible to define customized stop rules in addition to the energy criteria specified by the .SteadyStateLimit command. A combination of S-parameter, probe or radiated power convergence criteria is available. For more details on the error evaluation formula please refer to the Steady State help page.
        function RemoveAllStopCriteria(obj)
            % Resets all previously defined solver custom stop criteria, i.e. no custom stop rule will be active and in use.
            obj.AddToHistory('.RemoveAllStopCriteria');
        end
        function AddStopCriterion(obj, GroupName, Threshold, Checks, Active)
            % Adds a specific solver custom stop criterion measuring the deviation of the results (S-parameters, probes and radiated power) in subsequent time steps.
            % The parameter GroupName specifies the items to be checked for the stop rule. Each group is declared and fully described in the Steady State tab of the Special Time Domain Solver Parameters dialog. A number of predefined group names is available:
            % All S-Parameters - the stop criteria is based on the convergence of all available S- and F-parameters.
            % Transmission S-Parameters - the stop criteria is based on the convergence of all available transmission S- and F-parameters.
            % Reflection S-Parameters - the stop criteria is based on the convergence of all available reflection S- and F-parameters.
            % All Probes - the stop criteria is based on the convergence of all near and far field probe frequency spectra.
            % All Radiated Powers - the stop criteria is based on the convergence of the radiated power extracted from all farfield/RCS (Frequency and Transient Broadband) monitors.
            % The parameter Threshold sets the accuracy (in linear scale) to be used for the convergence test. A value between 0.0 and 1.0 is required.
            % The parameter Checks sets the number of consecutive error samples which should drop below the threshold to consider the convergence criterion as being met and stop the solver. A value greater than 0 is required.
            % The parameter Active enables or disables the stop criterion.
            obj.AddToHistory(['.AddStopCriterion "', num2str(GroupName, '%.15g'), '", '...
                                                '"', num2str(Threshold, '%.15g'), '", '...
                                                '"', num2str(Checks, '%.15g'), '", '...
                                                '"', num2str(Active, '%.15g'), '"']);
        end
        function StopCriteriaShowExcitation(obj, flag)
            % Controls if the generation of the custom stop criteria should take into account also the excitation information.
            % If the flag is active the available group items are shown in the Convergence Criteria Selection dialog in combination with the excitation information. This enables the test of the group items for the specified excitation only. If the flag is inactive the items are shown in the dialog simply by their name and they will be tested independently of the current excitation. This option applies to the definition of new probe or radiated power groups only.
            obj.AddToHistory(['.StopCriteriaShowExcitation "', num2str(flag, '%.15g'), '"']);
        end
        %% Time Domain Solver AR Filter / Time Window
        function UseArfilter(obj, flag)
            % The Auto Regressive (AR)-filter is a signal processing method to predict time signals to save simulation time. These predicted signals are then used to calculate the scattering matrices. AR-filtering should be used when simulating very resonant structures.
            % By this function the AR-filter analysis during the time domain calculation can be switched on or off.
            % If an AR-Filter is calculated during the simulation a energy balance from the extrapolated signals is calculated as well. If this energy balance reaches one within a specified limit faster than the EnergyBalanceLimit, it stops the simulation.
            obj.AddToHistory(['.UseArfilter "', num2str(flag, '%.15g'), '"']);
        end
        function ArMaxEnergyDeviation(obj, limit)
            % If the calculation of AR-Filters is switched on, for every Signal an AR-Filter is determined independently. As an indicator of how accurate these predictions have been, the energy balance depending on these AR-Filter signals is calculated. This balance is compared to the energy balance for normal scattering parameters for loss free, reciprocal structures, which is one. The difference between these two signal is taken as a value for the accuracy of the AR-Filter signals.
            % The value that can be set by ArMaxEnergyDeviation defines a limit for the accuracy of the AR-Filter signals. If the accuracy has been reached the simulation will be stopped.
            obj.AddToHistory(['.ArMaxEnergyDeviation "', num2str(limit, '%.15g'), '"']);
        end
        function ArPulseSkip(obj, nPulses)
            % Defines the number of impulses that will not be considered by the AR-filter. A pulse width is directly related to the Gaussian pulse used for excitation by default.
            obj.AddToHistory(['.ArPulseSkip "', num2str(nPulses, '%.15g'), '"']);
        end
        function StartArFilter(obj)
            % Starts the AR-filter.
            obj.AddToHistory(['.StartArFilter']);
        end
        function SetTimeWindow(obj, key, smoothness, flag)
            % Because every simulation should only take finite time the resulting time signals can be thought of a multiplication by the imaginary infinite time signal and a time windowing function. In the simplest case this is a rectangular window. However rectangular windows cause the resulting frequency domain signals to be quite rough. They become smoother if cosine shaped windows are used. However in cases of steep resonance peaks these functions may broaden these peaks. The parameter smoothness is the decay time in percent of the total signal time (0 % = rectangular window / 100 % = ideal cosine window). The flag switches the time window during a transient simulation on/off .
            % The parameter key may have one of the following values:
            % Rectangular Selects a rectangular time window.
            % Cosine      Selects a cosine shaped time window.
            obj.AddToHistory(['.SetTimeWindow "', num2str(key, '%.15g'), '", '...
                                             '"', num2str(smoothness, '%.15g'), '", '...
                                             '"', num2str(flag, '%.15g'), '"']);
        end
        %% Time Domain Solver Material Special Settings and Monitors
        function SurfaceImpedanceOrder(obj, order)
            % Specifies the order of the one dimensional surface impedance model. In case that the model order is increased the simulation result is enhanced at the expense of a higher calculation effort.
            obj.AddToHistory(['.SurfaceImpedanceOrder "', num2str(order, '%.15g'), '"']);
        end
        function ActivatePowerLoss1DMonitor(obj, flag)
            % Activates the computation of the power dissipated by the dispersive electric and magnetic materials and by the lossy metal, surface impedance (i.e. ohmic sheet, tabulated surface impedance and corrugated wall) and compact model elements (i.e. thin panel).
            % A 1D curve displaying the overall power dissipated by these elements as a function of frequency is computed and displayed in the "1D Results" tree subfolder.
            % The user can select  the frequencies where the dissipated power has to be computed and therefore control the source contribution, i.e. in correspondence of the defined 3D field frequency monitors, of the defined far field monitors or of additional selected frequencies. The commands Use3DFieldMonitorForPowerLoss1DMonitor, UseFarFieldMonitorForPowerLoss1DMonitor and UseExtraFreqForPowerLoss1DMonitor configure this choice.
            % The information provided by the dissipated power curve offers a better insight into the model power efficiency and allows an accurate energy balance evaluation.
            obj.AddToHistory(['.ActivatePowerLoss1DMonitor "', num2str(flag, '%.15g'), '"']);
        end
        function PowerLoss1DMonitorPerSolid(obj, flag)
            % Includes a subfolder containing the power dissipated by the dispersive electric and magnetic materials and the lossy metal, surface impedance and compact model elements sorted by solids.
            obj.AddToHistory(['.PowerLoss1DMonitorPerSolid "', num2str(flag, '%.15g'), '"']);
        end
        function Use3DFieldMonitorForPowerLoss1DMonitor(obj, flag)
            % Activates the computation of the power dissipated by the dispersive electric and magnetic materials and the lossy metal, surface impedance and compact model elements in correspondence of the defined 3D field frequency monitors.
            % The computation of the dispersive electric and magnetic material losses will be performed summing up the contribution of those fields monitor only. This is especially important when subvolume field monitors are defined as the losses are computed in the corresponding subvolume only.
            % The computation of the lossy metal, surface impedance and compact model losses will be anyway performed summing up the contributions in the entire simulation domain.
            obj.AddToHistory(['.Use3DFieldMonitorForPowerLoss1DMonitor "', num2str(flag, '%.15g'), '"']);
        end
        function UseFarFieldMonitorForPowerLoss1DMonitor(obj, flag)
            % Activates the computation of the power dissipated by the dispersive electric and magnetic materials and the lossy metal, surface impedance and compact model elements in correspondence of the defined far field monitor frequencies. The computation of the material losses will be performed summing up the contributions in the entire simulation domain. To this purpose internal monitors will be generated on the entire domain at the far field monitor frequencies. Take into account that this requires additional memory resulting in a significant effort in case of multiple far field monitor definition.
            obj.AddToHistory(['.UseFarFieldMonitorForPowerLoss1DMonitor "', num2str(flag, '%.15g'), '"']);
        end
        function UseExtraFreqForPowerLoss1DMonitor(obj, flag)
            % Activates the computation of the power dissipated by the dispersive electric and magnetic materials and the lossy metal, surface impedance and compact model elements in correspondence of the  frequencies defined by means of the AddPowerLoss1DMonitorExtraFreq command. The computation of the material losses will be performed summing up the contributions in the entire simulation domain. To this purpose internal monitors will be generated on the entire domain at the required frequencies. Take into account that this requires additional memory resulting in a significant effort in case of multiple frequency definition.
            obj.AddToHistory(['.UseExtraFreqForPowerLoss1DMonitor "', num2str(flag, '%.15g'), '"']);
        end
        function ResetPowerLoss1DMonitorExtraFreq(obj)
            % Reset the list of the additional frequency values where the monitors for the power dissipated by the dispersive electric and magnetic materials and the lossy metal, surface impedance and compact model elements are calculated.
            obj.AddToHistory(['.ResetPowerLoss1DMonitorExtraFreq']);
        end
        function AddPowerLoss1DMonitorExtraFreq(obj, freq)
            % Activates the computation of the power dissipated by the dispersive electric and magnetic materials, the lossy metal, surface impedance (i.e. ohmic sheet, tabulated surface impedance and corrugated wall) and compact model elements (i.e. thin panel) at the provided frequency value.
            obj.AddToHistory(['.AddPowerLoss1DMonitorExtraFreq "', num2str(freq, '%.15g'), '"']);
        end
        function SetTimePowerLossSIMaterialMonitor(obj, flag)
            % Activates the computation of the time domain 1D monitor for the power dissipated by the lossy metal and broadband surface impedance elements (i.e. ohmic sheet, tabulated surface impedance and corrugated wall). A 1D curve displaying the overall power dissipated by these elements as a function of time is computed and displayed in the "1D Results" tree subfolder.
            obj.AddToHistory(['.SetTimePowerLossSIMaterialMonitor "', num2str(flag, '%.15g'), '"']);
        end
        function ActivateTimePowerLossSIMaterialMonitor(obj, TStart, TStep, TEnd, UseTEnd)
            % Define the parameters for the powerloss time domain 1D monitor for the surface impedance material. In details TStart is the start time for the time monitoring. TStep is the desired step width for the time monitoring. Together with start and end time this value determines the full number of recorded time samples. If the flag UseTEnd is true then TEnd specifies the ending time for the recording, otherwise the recording will continue up to the end of the calculation.
            obj.AddToHistory(['.ActivateTimePowerLossSIMaterialMonitor "', num2str(TStart, '%.15g'), '", '...
                                                                      '"', num2str(TStep, '%.15g'), '", '...
                                                                      '"', num2str(TEnd, '%.15g'), '", '...
                                                                      '"', num2str(UseTEnd, '%.15g'), '"']);
        end
        function SetTimePowerLossSIMaterialMonitorAverage(obj, flag)
            % Setting flag to true allows the calculation of averaged values over time for a powerloss time domain 1D monitor for the surface impedance material. By default the monitor is integrated over time and averaged by its number of sample steps. The duration and sample step of the integration is defined by setting the values TStart, TStep, TEnd and UseTend. However, with the command SetTimePowerLossSIMaterialMonitorAverageRepPeriod it is possible to define a specific time interval to normalize the monitor result.
            obj.AddToHistory(['.SetTimePowerLossSIMaterialMonitorAverage "', num2str(flag, '%.15g'), '"']);
        end
        function SetTimePowerLossSIMaterialMonitorAverageRepPeriod(obj, TimePeriod)
            % The value TimePeriod defines the time interval which is used for normalization of the averaged powerloss time domain 1D monitor for the surface impedance material (activated by the command SetTimePowerLossSIMaterialMonitorAverage). In case this value is set to zero, the time interval of the monitor (defined by TStart, TStep, TEnd and UseTend) is used instead.
            obj.AddToHistory(['.SetTimePowerLossSIMaterialMonitorAverageRepPeriod "', num2str(TimePeriod, '%.15g'), '"']);
        end
        function TimePowerLossSIMaterialMonitorPerSolid(obj, flag)
            % Includes a subfolder sorting the powerloss time domain 1D monitor for the surface impedance material by solids.
            obj.AddToHistory(['.TimePowerLossSIMaterialMonitorPerSolid "', num2str(flag, '%.15g'), '"']);
        end
        function SetDispNonLinearMaterialMonitor(obj, flag)
            % Activates the computation of the plasma and nonlinear material monitor. In case of nonlinear plasma material the charge density will be recorded. In case of dispersive nonlinear material the instantaneous equivalent eps and mu variation due to the nonlinearity will be recorded.
            obj.AddToHistory(['.SetDispNonLinearMaterialMonitor "', num2str(flag, '%.15g'), '"']);
        end
        function ActivateDispNonLinearMaterialMonitor(obj, TStart, TStep, TEnd, UseTEnd)
            % Define the parameters for the time domain plasma and nonlinear material monitor. In details TStart is the start time for the time monitoring. TStep is the desired step width for the time monitoring. Together with start and end time this value determines the full number of recorded time samples. Note that time monitors possibly need a great amount of disk memory if the step width is chosen too small. If the flag UseTEnd is true then TEnd specifies the ending time for the recording, otherwise the recording will continue up to the end of the calculation.
            obj.AddToHistory(['.ActivateDispNonLinearMaterialMonitor "', num2str(TStart, '%.15g'), '", '...
                                                                    '"', num2str(TStep, '%.15g'), '", '...
                                                                    '"', num2str(TEnd, '%.15g'), '", '...
                                                                    '"', num2str(UseTEnd, '%.15g'), '"']);
        end
        function ActivateSpaceMaterial3DMonitor(obj, flag)
            % Activates the computation of the space material monitor (3D) recording information on the complex permeability and permittivity for the dispersive space map based materials at a given frequency.
            % The user can select  the frequencies where the monitor has to be computed and therefore control the source contribution, i.e. in correspondence of the defined 3D field frequency monitors or of additional selected frequencies. The commands Use3DFieldMonitorForSpaceMaterial3DMonitor and UseExtraFreqForSpaceMaterial3DMonitor configure this choice.
            obj.AddToHistory(['.ActivateSpaceMaterial3DMonitor "', num2str(flag, '%.15g'), '"']);
        end
        function Use3DFieldMonitorForSpaceMaterial3DMonitor(obj, flag)
            % Activates the computation of the space material monitor (3D) in correspondence of the frequencies of the defined 3D field frequency monitors.
            obj.AddToHistory(['.Use3DFieldMonitorForSpaceMaterial3DMonitor "', num2str(flag, '%.15g'), '"']);
        end
        function UseExtraFreqForSpaceMaterial3DMonitor(obj, flag)
            % Activates the computation of the space material monitor (3D) in correspondence of the frequencies defined by means of the AddSpaceMaterial3DMonitorExtraFreq command.
            obj.AddToHistory(['.UseExtraFreqForSpaceMaterial3DMonitor "', num2str(flag, '%.15g'), '"']);
        end
        function ResetSpaceMaterial3DMonitorExtraFreq(obj)
            % Reset the list of the additional frequency values where the space material monitors (3D) are calculated.
            obj.AddToHistory(['.ResetSpaceMaterial3DMonitorExtraFreq']);
        end
        function AddSpaceMaterial3DMonitorExtraFreq(obj, freq)
            % Activates the computation of the space material monitor (3D) at the provided frequency value.
            obj.AddToHistory(['.AddSpaceMaterial3DMonitorExtraFreq "', num2str(freq, '%.15g'), '"']);
        end
        function SetHFTDDispUpdateScheme(obj, key)
            % Controls how dispersive materials are discretized and simulated by the transient solver. A "Generalized" algorithm is available which provides, in case of highly resonant material models, increased accuracy, robustness and stability over the "Standard" algorithm.
            % : 'Standard'
            %   'Generalized'
            obj.AddToHistory(['.SetHFTDDispUpdateScheme "', num2str(key, '%.15g'), '"']);
        end
        %% Time Domain Solver Mesh
        function UseTSTAtPort(obj, flag)
            % Specifies if TST is used in the port region of a waveguide port (flag = True) or not (flag = False).
            obj.AddToHistory(['.UseTSTAtPort "', num2str(flag, '%.15g'), '"']);
        end
        function SetSubcycleState(obj, key)
            % Controls the allowance of subcycles concerning the time step calculation of the time domain algorithm.
            % key: 'Automatic'
            %      'Activate'
            %      'Deactivate'
            obj.AddToHistory(['.SetSubcycleState "', num2str(key, '%.15g'), '"']);
        end
        function SetSubgridCycleState(obj, key)
            % In case that the Multilevel Subgridding Scheme is activated this command controls the allowance of subgrid specific cycling concerning the time step calculation of the time domain algorithm. If selected automatically or by user the different grid levels are calculated with different time steps.
            % key: 'Automatic'
            %      'Activate'
            %      'Deactivate'
            obj.AddToHistory(['.SetSubgridCycleState "', num2str(key, '%.15g'), '"']);
        end
        function SimplifiedPBAMethod(obj, flag)
            % This method activates a simplified PBA formulation for the transient simulation without any timestep reduction or usage of subcycled updates. This advantage is gained by a slight loss of accuracy and decrease of convergence.
            obj.AddToHistory(['.SimplifiedPBAMethod "', num2str(flag, '%.15g'), '"']);
        end
        %% Eigenmode Solver General
        function AKSPenaltyFactor(obj, value)
            % Sets a scaling factor, in order to avoid static solutions within the calculated spectrum. Usually this parameter is set to 1.0. Increasing this number (up to 10.0) leads to a longer simulation time, because more matrix vector multiplications are necessary.
            obj.AddToHistory(['.AKSPenaltyFactor "', num2str(value, '%.15g'), '"']);
        end
        function AKSEstimation(obj, estim)
            % Sets the estimation for the (p+1)th resonance frequency, when p modes have to be calculated by the AKS solver. If the estimation factor is set to 0.0 the solver will do an automatic estimation, which is based on the bounding boxs dimensions.
            obj.AddToHistory(['.AKSEstimation "', num2str(estim, '%.15g'), '"']);
        end
        function AKSIterations(obj, nIter)
            % Sets the number of iterations for the eigenmode solver.
            obj.AddToHistory(['.AKSIterations "', num2str(nIter, '%.15g'), '"']);
        end
        function AKSAccuracy(obj, acc)
            % Sets the desired accuracy of modes, calculated by the eigenmode-solver.
            obj.AddToHistory(['.AKSAccuracy "', num2str(acc, '%.15g'), '"']);
        end
        function AKSReset(obj)
            % Resets the AKS solver settings to its default values.
            obj.AddToHistory(['.AKSReset']);
        end
        function AKSStart(obj)
            % Starts  the eigenmode calculation solver.
            obj.AddToHistory(['.AKSStart']);
        end
        function AKSEstimationCycles(obj, nIter)
            % In case that the given accuracy limit for the AKS calculation is not achieved, the iteration will be repeated. This method specifies the number of repetition cycles that will be performed during the calculation.
            obj.AddToHistory(['.AKSEstimationCycles "', num2str(nIter, '%.15g'), '"']);
        end
        function AKSAutomaticEstimation(obj, flag)
            % Enable automatic estimation for AKS.
            obj.AddToHistory(['.AKSAutomaticEstimation "', num2str(flag, '%.15g'), '"']);
        end
        function AKSCheckModes(obj, nModes)
            % The number of eigenmodes used for the frequency converge check.
            obj.AddToHistory(['.AKSCheckModes "', num2str(nModes, '%.15g'), '"']);
        end
        function AKSMaximumDF(obj, err)
            % The convergence error (Delta F) is determined as the maximum variation of the eigenmode frequencies between two subsequent passes.
            obj.AddToHistory(['.AKSMaximumDF "', num2str(err, '%.15g'), '"']);
        end
        function AKSMaximumPasses(obj, nModes)
            % This setting determines the maximum number of passes to be performed for the mesh adaption, even if the eigenmode frequencies have not sufficiently converged so far. This setting is useful to limit the total calculation time to reasonable amounts.
            obj.AddToHistory(['.AKSMaximumPasses "', num2str(nModes, '%.15g'), '"']);
        end
        function AKSMeshIncrement(obj, inc)
            % This parameter determines the changing of the mesh expert system by
            % increasing the settings of Lines per wavelength and Lower mesh limit in the Mesh Properties dialog box.
            obj.AddToHistory(['.AKSMeshIncrement "', num2str(inc, '%.15g'), '"']);
        end
        function AKSMinimumPasses(obj, minPass)
            % The minimum number of passes which will be performed, even if the eigenmode frequencies do not change significantly.
            obj.AddToHistory(['.AKSMinimumPasses "', num2str(minPass, '%.15g'), '"']);
        end
        %% Eigenmode Queries
        function int = AKSGetNumberOfModes(obj)
            % Returns the number of defined modes.
            int = obj.hSolver.invoke('AKSGetNumberOfModes');
        end
        %% CST 2013 functions.
        function SetBBPSamples(obj, nSamples)
            % Sets the number of frequency points used for a broad band port (BBP). Broad band ports are used for ports at inhomogeneous waveguides. The more points are used the more accurate the port operator will be. However the simulation time will increase as well (All chosen modes have to be simulated for each frequency point).
            obj.AddToHistory(['.SetBBPSamples "', num2str(nSamples, '%.15g'), '"']);
        end
        function UseOpenBoundaryForHigherModes(obj, flag)
            % Determines whether unconsidered higher modes occurring at a waveguide port should be absorbed using a Mur open boundary (switch = True) or not (flag = False).
            obj.AddToHistory(['.UseOpenBoundaryForHigherModes "', num2str(flag, '%.15g'), '"']);
        end
        %% Undocumented functions.
        % Found in history list of migrated CST 2014 file in 'define solver parameters'
        function CalculationType(obj, type)
            % type: 'TD-S'
            obj.AddToHistory(['.CalculationType "', num2str(type, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define solver parameters'
        % Definition below is copied from CST.FDSolver.
        function UseSensitivityAnalysis(obj, flag)
            % If activated the sensitivity analysis is calculated when running the frequency domain solver with tetrahedral mesh.
            obj.AddToHistory(['.UseSensitivityAnalysis "', num2str(flag, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define special solver parameters'
        function SteadyStateDurationType(obj, type)
            % type: 'Number of pulses'
            obj.AddToHistory(['.SteadyStateDurationType "', num2str(type, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define special solver parameters'
        function SteadyStateDurationTime(obj, time)
            obj.AddToHistory(['.SteadyStateDurationTime "', num2str(time, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define special solver parameters'
        function SteadyStateDurationTimeAsDistance(obj, distance)
            obj.AddToHistory(['.SteadyStateDurationTimeAsDistance "', num2str(distance, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define special solver parameters'
        % Definition below is copied from CST.PICSolver.
        function WaveguideBroadband(obj, flag)
            % Switches the broadband waveguide boundary condition (BBP) for inhomogeneous ports on/off.
            obj.AddToHistory(['.WaveguideBroadband "', num2str(flag, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define special solver parameters'
        function ActivateSIPowerLossyMonitor(obj, boolean)
            obj.AddToHistory(['.ActivateSIPowerLossyMonitor "', num2str(boolean, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define special solver parameters'
        function SetPortShielding(obj, boolean)
            obj.AddToHistory(['.SetPortShielding "', num2str(boolean, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define special solver parameters'
        function NormalizeToRefSignal(obj, boolean)
            obj.AddToHistory(['.NormalizeToRefSignal "', num2str(boolean, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define time domain solver parameters'
        function Method(obj, method)
            % method; 'Hexahedral'
            obj.AddToHistory(['.Method "', num2str(method, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define solver excitation modes'
        function ExcitationFieldSource(obj, arg1, arg2, arg3, arg4, boolean)
            % ExcitationFieldSource('fs1', '1.0', '0.0', 'default', 'True');
            obj.AddToHistory(['.ExcitationFieldSource "', num2str(arg1, '%.15g'), '", '...
                                                     '"', num2str(arg2, '%.15g'), '", '...
                                                     '"', num2str(arg3, '%.15g'), '", '...
                                                     '"', num2str(arg4, '%.15g'), '", '...
                                                     '"', num2str(boolean, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define special time domain solver
        % parameters' under 'GENERAL'.
        function SetBroadBandPhaseShiftLowerBoundFac(obj, value)
            obj.AddToHistory(['.SetBroadBandPhaseShiftLowerBoundFac "', num2str(value, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define special time domain solver
        % parameters' under 'GENERAL'.
        function SetPortShieldingType(obj, type)
            % type: 'NONE'
            obj.AddToHistory(['.SetPortShieldingType "', num2str(type, '%.15g'), '"']);
        end
        %% Undocumented functions for 'HEXAHEDRAL'.
        % Found in history list of migrated CST 2014 file in 'define special time domain solver
        % parameters' under 'HEXAHEDRAL'.
        function UseVariablePMLLayerSizeStandard(obj, boolean)
            obj.AddToHistory(['.UseVariablePMLLayerSizeStandard "', num2str(boolean, '%.15g'), '"']);
        end
        function KeepPMLDepthDuringMeshAdaptationWithVariablePMLLayerSize(obj, boolean)
            obj.AddToHistory(['.KeepPMLDepthDuringMeshAdaptationWithVariablePMLLayerSize "', num2str(boolean, '%.15g'), '"']);
        end
        function SetEnhancedPMLStabilization(obj, value)
            % value: 'Automatic'
            obj.AddToHistory(['.SetEnhancedPMLStabilization "', num2str(value, '%.15g'), '"']);
        end
        function WaveguidePortROM(obj, boolean)
            obj.AddToHistory(['.WaveguidePortROM "', num2str(boolean, '%.15g'), '"']);
        end
        %% Undocumented functions for 'HEXAHEDRAL TLM'.
        % Found in history list of migrated CST 2014 file in 'define special time domain solver
        % parameters' under 'HEXAHEDRAL TLM'.
        function AnisotropicSheetSurfaceType(obj, type)
            % type: '0'
            obj.AddToHistory(['.AnisotropicSheetSurfaceType "', num2str(type, '%.15g'), '"']);
        end
        function UseMeshType(obj, type)
            % type: '1'
            obj.AddToHistory(['.UseMeshType "', num2str(type, '%.15g'), '"']);
        end
        function UseAbsorbingBoundary(obj, boolean)
            obj.AddToHistory(['.UseAbsorbingBoundary "', num2str(boolean, '%.15g'), '"']);
        end
        function UseDoublePrecision(obj, boolean)
            obj.AddToHistory(['.UseDoublePrecision "', num2str(boolean, '%.15g'), '"']);
        end
        function AllowMaterialOverlap(obj, boolean)
            obj.AddToHistory(['.AllowMaterialOverlap "', num2str(boolean, '%.15g'), '"']);
        end
        function ExcitePlanewaveNearModel(obj, boolean)
            obj.AddToHistory(['.ExcitePlanewaveNearModel "', num2str(boolean, '%.15g'), '"']);
        end
        function SetGroundPlane(obj, boolean)
            obj.AddToHistory(['.SetGroundPlane "', num2str(boolean, '%.15g'), '"']);
        end
        function GroundPlane(obj, axis, value)
            % axis: 'x'
            obj.AddToHistory(['.GroundPlane "', num2str(axis, '%.15g'), '", '...
                                           '"', num2str(value, '%.15g'), '"']);
        end
        function NumberOfLayers(obj, value)
            obj.AddToHistory(['.NumberOfLayers "', num2str(value, '%.15g'), '"']);
        end
        function HealCheckAllObjects(obj, boolean)
            obj.AddToHistory(['.HealCheckAllObjects "', num2str(boolean, '%.15g'), '"']);
        end
        function NormalizeToGaussian(obj, boolean)
            obj.AddToHistory(['.NormalizeToGaussian "', num2str(boolean, '%.15g'), '"']);
        end
        function TimeSignalSamplingFactor(obj, factor)
            obj.AddToHistory(['.TimeSignalSamplingFactor "', num2str(factor, '%.15g'), '"']);
        end
        %% Undocumented functions for 'TLM POSTPROCESSING'.
        % Found in history list of migrated CST 2014 file in 'define special time domain solver
        % parameters' under 'TLM POSTPROCESSING'.
        function ResetSettings(obj)
            obj.AddToHistory(['.ResetSettings']);
        end
        function CalculateNearFieldOnCylindricalSurfaces(obj, boolean, value)
            % value: 'Coarse'
            obj.AddToHistory(['.CalculateNearFieldOnCylindricalSurfaces  "', num2str(boolean, '%.15g'), '", '...
                                                                        '"', num2str(value, '%.15g'), '"']);
        end
        function CylinderGridCustomStep(obj, value)
            obj.AddToHistory(['.CylinderGridCustomStep "', num2str(value, '%.15g'), '"']);
        end
        function CalculateNearFieldOnCircularCuts(obj, boolean)
            obj.AddToHistory(['.CalculateNearFieldOnCircularCuts "', num2str(boolean, '%.15g'), '"']);
        end
        function CylinderBaseCenter(obj, value1, value2, value3)
            obj.AddToHistory(['.CylinderBaseCenter "', num2str(value1, '%.15g'), '", '...
                                                  '"', num2str(value2, '%.15g'), '", '...
                                                  '"', num2str(value3, '%.15g'), '"']);
        end
        function CylinderRadius(obj, value)
            obj.AddToHistory(['.CylinderRadius "', num2str(value, '%.15g'), '"']);
        end
        function CylinderHeight(obj, value)
            obj.AddToHistory(['.CylinderHeight "', num2str(value, '%.15g'), '"']);
        end
        function CylinderSpacing(obj, value)
            obj.AddToHistory(['.CylinderSpacing "', num2str(value, '%.15g'), '"']);
        end
        function CylinderResolution(obj, value)
            obj.AddToHistory(['.CylinderResolution "', num2str(value, '%.15g'), '"']);
        end
        function CylinderAllPolarization(obj, boolean)
            obj.AddToHistory(['.CylinderAllPolarization "', num2str(boolean, '%.15g'), '"']);
        end
        function CylinderRadialAngularVerticalComponents(obj, boolean)
            obj.AddToHistory(['.CylinderRadialAngularVerticalComponents "', num2str(boolean, '%.15g'), '"']);
        end
        function CylinderMagnitudeOfTangentialConponent(obj, boolean)
            obj.AddToHistory(['.CylinderMagnitudeOfTangentialConponent "', num2str(boolean, '%.15g'), '"']);
        end
        function CylinderVm(obj, boolean)
            obj.AddToHistory(['.CylinderVm "', num2str(boolean, '%.15g'), '"']);
        end
        function CylinderDBVm(obj, boolean)
            obj.AddToHistory(['.CylinderDBVm "', num2str(boolean, '%.15g'), '"']);
        end
        function CylinderDBUVm(obj, boolean)
            obj.AddToHistory(['.CylinderDBUVm "', num2str(boolean, '%.15g'), '"']);
        end
        function CylinderAndFrontAxes(obj, value1, value2)
            % value1: '+y'
            % value2: '+z'
            obj.AddToHistory(['.CylinderAndFrontAxes "', num2str(value1, '%.15g'), '", '...
                                                    '"', num2str(value2, '%.15g'), '"']);
        end
        function ApplyLinearPrediction(obj, boolean)
            obj.AddToHistory(['.ApplyLinearPrediction "', num2str(boolean, '%.15g'), '"']);
        end
        function Windowing(obj, value)
            % value: 'None'
            obj.AddToHistory(['.Windowing "', num2str(value, '%.15g'), '"']);
        end
        function LogScaleFrequency(obj, boolean)
            obj.AddToHistory(['.LogScaleFrequency "', num2str(boolean, '%.15g'), '"']);
        end
        function AutoFreqStep(obj, boolean, value)
            obj.AddToHistory(['.AutoFreqStep "', num2str(boolean, '%.15g'), '", '...
                                            '"', num2str(value, '%.15g'), '"']);
        end
        function SetExcitationSignal(obj, value)
            % value: '' (empty)
            obj.AddToHistory(['.SetExcitationSignal "', num2str(value, '%.15g'), '"']);
        end
        function SaveSettings(obj)
            obj.AddToHistory(['.SaveSettings']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hSolver
        history
        bulkmode

    end
end

%% Default Settings
%% Solver Defaults
% PBAFillLimit(99)
% UseSplitComponents(1)
% TimeBetweenUpdates(20)
% SParaAdjustment(1)
% PrepareFarfields(1)
%% Time Domain Solver Defaults
% AutoNormImpedance(0)
% NormingImpedance(50.0)
% MeshAdaption(0)
% UseDistributedComputing(0)
% StoreTDResultsInCache(0)
% ConsiderTwoPortReciprocity(1)
% EnergyBalanceLimit(0.03)
% TimeStepStabilityFactor(1.0)
% AutomaticTimeSignalSampling(1)
% UseBroadBandPhaseShift(0)
% SParaAdjustment(1)
% PrepareFarfields(1)
% CalculateModesOnly(0)
% StimulationMode(1)
% SetBBPSamples(5) % CST 2013
% WaveguideBroadband(0) % CST 2013
% UseOpenBoundaryForHigherModes(0) % CST 2013
% WaveguidePortGeneralized(1)
% WaveguidePortModeTracking(0)
% AbsorbUnconsideredModeFields('Automatic');
% FullDeembedding(0)
% SetSamplesFullDeembedding(20)
% SetModeFreqFactor(0.5)
% ScaleTETMModeToCenterFrequency(1)
% AdaptivePortMeshing(1)
% AccuracyAdaptivePortMeshing(1)
% PassesAdaptivePortMeshing(4)
% NumberOfPulseWidths(20)
% SteadyStateLimit('-30')
% UseArfilter(0)
% ArMaxEnergyDeviation(0.1)
% ArPulseSkip(1)
% SetTimeWindow('Rectangular', 100, 0)
% SurfaceImpedanceOrder(10)
% ActivateSIPowerLossyMonitor(0)
% SetBurningPlasmaDensityMonitor(0)
% TimestepReduction(0.45)
% UseTSTAtPort(1)
% SetSubcycleState('Automatic');
% NumberOfSubcycles(4)
% SubcycleFillLimit(70)
% EnableSubgridding(0)
% SetSubgridCycleState('Automatic');
% SimplifiedPBAMethod(0)
% SetSimultaneousExcitAutoLabel(1)
% SetSimultaneousExcitationOffset('Phaseshift');
% AlwaysExludePec(0)
% RestartAfterInstabilityAbort(1)
% HardwareAcceleration(0)
% MPIParallelization(0)
% SetPMLType('ConvPML');
% NormalizeToReferenceSignal(0)
% NormalizeToDefaultSignalWhenInUse(1)
% TDRComputation(0)
% TDRShift50Percent(0)
% TDRReflection(0)
%% Eigenmode Solver Defaults
% AKSPenaltyFactor(1.0)
% AKSEstimation(0.0)
% AKSIterations(2)
% AKSAccuracy(1e-6)
% AKSNFsamples(1001)
% AKSEstimationCycles(2)
% AKSAutomaticEstimation(1)
% AKSSpecDensitySamples(1)
% AKSCheckModes(10)
% AKSMaximumDF(0.01)
% AKSMaximumPasses(6)
% AKSMeshIncrement(5)
% AKSMinimumPasses(2)

%% Example - Taken from CST documentation and translated to MATLAB.
% % Time Domain Solver
% % User defined function that produces a sine of 30 MHz as excitation signal.
% Option Explicit
% Function ExcitationFunction(dtime As Double) As Double
% ExcitationFunction = Sin(2*3.141*30*10^6*dtime)
% End Function
%
% % S-Parameter symmetry setup for a 3 port structure where all ports are symmetric to each other
% solver = project.Solver();
%     solver.ResetSParaSymm
%     solver.DefSParaSymm
%     solver.SPara('1, 1');
%     solver.SPara('2, 2');
%     solver.SPara('3, 3');
%     solver.DefSParaSymm
%     solver.SPara('2, 1');
%     solver.SPara('3, 1');
%     solver.SPara('3, 2');
