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

% The PICSolver object defines all the settings that control the simulations with the Particle-in-cell (PIC) solver.
classdef PICSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.PICSolver object.
        function obj = PICSolver(project, hProject)
            obj.project = project;
            obj.hPICSolver = hProject.invoke('PICSolver');
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
            % Prepend With PICSolver and append End With
            obj.history = [ 'With PICSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define PICSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['PICSolver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function FrequencyRange(obj, fmin, fmax)
            % Sets the frequency range for the simulation. Changing the frequency range has several side effects. The mesh will be changed and all previous simulation results will be deleted. However, before the frequency range is actually changed, a dialog window will appear that asks to save the old results to another file.
            obj.AddToHistory(['.FrequencyRange "', num2str(fmin, '%.15g'), '", '...
                                              '"', num2str(fmax, '%.15g'), '"']);
        end
        %% Mesh
        function PBAFillLimit(obj, percentage)
            % Defines when a cell should be treated as entirely filled with Perfectly Conducting Material (PEC). So if a cell is filled with more than percentage of the cell with PEC, the entire Cell will be filled with PEC. For other materials this setting has no effect. Generally, this setting should not be changed.
            obj.AddToHistory(['.PBAFillLimit "', num2str(percentage, '%.15g'), '"']);
        end
        function AlwaysExludePec(obj, flag)
            % This method offers the possibility to automatically exclude all PEC regions from the calculation. In case that large PEC regions exist this option may produce a significant speed-up of the simulation.
            obj.AddToHistory(['.AlwaysExludePec "', num2str(flag, '%.15g'), '"']);
        end
        %% Queries
        function double = GetFmin(obj)
            % Returns the minimum defined frequency.
            double = obj.hPICSolver.invoke('GetFmin');
        end
        function double = GetFmax(obj)
            % Returns the maximum defined frequency.
            double = obj.hPICSolver.invoke('GetFmax');
        end
        function int = GetNumberOfPorts(obj)
            % Returns the number of defined Ports.
            int = obj.hPICSolver.invoke('GetNumberOfPorts');
        end
        function bool = ArePortsSubsequentlyNamed(obj)
            % Inquires whether the ports are consecutively numbered or not. If they are, the total number of ports equals to the last port name. Otherwise the last name might be higher.
            bool = obj.hPICSolver.invoke('ArePortsSubsequentlyNamed');
        end
        function int = GetStimulationPort(obj)
            % Returns -1, if ports = All, 0 if ports = Selected Ports and -2, if plane wave excitation is active.
            int = obj.hPICSolver.invoke('GetStimulationPort');
        end
        function int = GetStimulationMode(obj)
            % Returns 0, if stimulation port is not a wave guide port, returns -1, if modes = All and if there is a wave guide port.
            int = obj.hPICSolver.invoke('GetStimulationMode');
        end
        %% PIC Solver General
        function int = Start(obj)
            % Starts the PIC Simulation with the current settings and returns 1 if the calculation is successfully finished and 0 if it failed.
            int = obj.hPICSolver.invoke('Start');
        end
        function SimulationTime(obj, value)
            % Sets the total simulation time for the particle in cell simulation.
            obj.AddToHistory(['.SimulationTime "', num2str(value, '%.15g'), '"']);
        end
        function AvoidSpaceChargeAtPEC(obj, flag)
            % If flag is true, possible non-physical space charge at PEC bodies due to emission and/or collision of particles is avoided.
            obj.AddToHistory(['.AvoidSpaceChargeAtPEC "', num2str(flag, '%.15g'), '"']);
        end
        function ThermalCoupling(obj, flag, bUseSimulationTime, starttime, endtime)
            % Calculates a time-averaged power due to particle collisions with solids and write the data to a file. The data can be used to drive a thermal calculation. One can select whether the simulation time or a user-defined interval should be used for the power averaging.
            obj.AddToHistory(['.ThermalCoupling "', num2str(flag, '%.15g'), '", '...
                                               '"', num2str(bUseSimulationTime, '%.15g'), '", '...
                                               '"', num2str(starttime, '%.15g'), '", '...
                                               '"', num2str(endtime, '%.15g'), '"']);
        end
        function ParticleSolidInteraction(obj, flag, nSamples)
            % Enables or disables the calculation of the collision information during the solver run. If it is enabled, the maximum number of time points that is displayed is specified by nSamples.
            obj.AddToHistory(['.ParticleSolidInteraction "', num2str(flag, '%.15g'), '", '...
                                                        '"', num2str(nSamples, '%.15g'), '"']);
        end
        function MultipactingSolverStop(obj, enable, intervals, width, base)
            % If the multipacting detection is enabled, the mean values of the number of generated secondary particles will be compared each time step. The mean values are calculated in time intervals of width width. The solver will stop if the mean values increase exponentially. The base of the exponential growth is given by base.
            obj.AddToHistory(['.MultipactingSolverStop "', num2str(enable, '%.15g'), '", '...
                                                      '"', num2str(intervals, '%.15g'), '", '...
                                                      '"', num2str(width, '%.15g'), '", '...
                                                      '"', num2str(base, '%.15g'), '"']);
        end
        function MeshAdaption(obj, flag)
            % If MeshAdaption is enabled (flag = True) several Simulation runs are started to automatically find the optimum mesh for the given problem.
            obj.AddToHistory(['.MeshAdaption "', num2str(flag, '%.15g'), '"']);
        end
        function UseDistributedComputing(obj, flag)
            % If flag is set to True this method enables the distributed calculation of different solver runs across the network.
            obj.AddToHistory(['.UseDistributedComputing "', num2str(flag, '%.15g'), '"']);
        end
        function StoreTDResultsInCache(obj, flag)
            % If flag is set to True this method stores results of the time domain solver in the result cache.
            obj.AddToHistory(['.StoreTDResultsInCache "', num2str(flag, '%.15g'), '"']);
        end
        function FrequencySamples(obj, nSamples)
            % Defines the resolution of all frequency domain signals for the next simulation. This setting has no significant influence on the total simulation time. It has only an effect on the Discrete Fourier Transform (DFT) that is used to transform the time domain signals into the frequency domain. nSamples will be the total number of frequency samples that the frequency domain signals will have.
            obj.AddToHistory(['.FrequencySamples "', num2str(nSamples, '%.15g'), '"']);
        end
        function TimeStepStabilityFactor(obj, value)
            % Specifies a stability factor that is multiplied to the current valid time step. Note: Normally the current time step is matched to the stability limit, hence values greater than 1 may make the time domain simulation unstable.
            obj.AddToHistory(['.TimeStepStabilityFactor "', num2str(value, '%.15g'), '"']);
        end
        function SetPMLType(obj, key)
            % Define the PML formulation type. The algorithms that can be set are the Convolution PML, which is set using key = "ConvPML",  or the Generalized PML theory, which is set using key = GTPML.
            obj.AddToHistory(['.SetPMLType "', num2str(key, '%.15g'), '"']);
        end
        function MatrixDump(obj, flag)
            % If flag = true, all solver relevant matrices are written into a file.
            obj.AddToHistory(['.MatrixDump "', num2str(flag, '%.15g'), '"']);
        end
        function RestartAfterInstabilityAbort(obj, flag)
            % If flag = true, the transient solver is automatically restarted twice with a reduced time step after an instability abort. In case that the occurred instability is due to the time discretization, this process helps to provide a stable simulation during the restarted run.
            obj.AddToHistory(['.RestartAfterInstabilityAbort "', num2str(flag, '%.15g'), '"']);
        end
        function HardwareAcceleration(obj, flag)
            % If flag = true, hardware acceleration for the pic solver is activated. Note that a hardware acceleration card must be installed in order to benefit from this setting.
            obj.AddToHistory(['.HardwareAcceleration "', num2str(flag, '%.15g'), '"']);
        end
        function SEEDeterministicRandom(obj, flag)
            % Enables or disables a nondeterministic random number generation process for the secondary electron generation. The default setting is True and enables a deterministic random process.
            obj.AddToHistory(['.SEEDeterministicRandom "', num2str(flag, '%.15g'), '"']);
        end
        function MinimumEmission(obj, type, current, charge)
            % Set minimum emission settings for all PIC emission models and secondary emission. The argument type can be "Current" or "Charge". Current and charge must be set in absolute values.
            obj.AddToHistory(['.MinimumEmission "', num2str(type, '%.15g'), '", '...
                                               '"', num2str(current, '%.15g'), '", '...
                                               '"', num2str(charge, '%.15g'), '"']);
        end
        function SetTransferBufferSizeMGPU(obj, particles)
            % Set the transfer buffer size for PIC on multi-GPU, by default it is set to 100,000. A transfer buffer handles the particle exchange between GPUs. The default size should be sufficient in most simulations. In case the buffer memory is exhausted, an error message is displayed.
            obj.AddToHistory(['.SetTransferBufferSizeMGPU "', num2str(particles, '%.15g'), '"']);
        end
        function Global(obj, property, flag)
            % Activates the specified property.
            obj.AddToHistory(['.Global "', num2str(property, '%.15g'), '", '...
                                      '"', num2str(flag, '%.15g'), '"']);
        end
        %% PIC Solver Transient Excitation
        function CalculateModesOnly(obj, flag)
            % If flag is True, the solver calculates only the port modes.
            obj.AddToHistory(['.CalculateModesOnly "', num2str(flag, '%.15g'), '"']);
        end
        function StimulationMode(obj, key)
            % Selects the mode to be used for excitation.
            %
            % The parameter key may have one of the following values:
            % All             All modes will be excited once.
            % int modeNumber  The mode number to be used for excitation.
            obj.AddToHistory(['.StimulationMode "', num2str(key, '%.15g'), '"']);
        end
        function StimulationPort(obj, key)
            % Selects the port(s)  to be used for excitation.
            %
            % The parameter key may have one of the following values:
            % All             All ports will be excited once.
            % Selected        Only those ports / modes are used for excitation that have been set by ExcitationPortMode.
            % "Plane Wave"    A plane wave will be used for excitation.
            % int portNumber  The port number (port name) to be used for excitation.
            obj.AddToHistory(['.StimulationPort "', num2str(key, '%.15g'), '"']);
        end
        function ResetExcitationModes(obj)
            % Resets the complete excitation list, which was previously defined by applying method ExcitationPortMode.
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
        function PhaseRefFrequency(obj, value)
            % The phase values defined in the excitation list are converted into corresponding time shifts for the time signals by use of this reference frequency. If the reference frequency is set to '0', time delay instead of phase shift is activated. (see ExcitationPortMode Method) )
            obj.AddToHistory(['.PhaseRefFrequency "', num2str(value, '%.15g'), '"']);
        end
        function SimultaneousExcitation(obj, flag)
            % Enables simultaneous excitation.
            obj.AddToHistory(['.SimultaneousExcitation "', num2str(flag, '%.15g'), '"']);
        end
        function SetSimultaneousExcitAutoLabel(obj, flag)
            % If a set of excitations has been defined for simultaneous excitation, an automatically generated label (as a prefix) is used to name the signals produced by the simulation. Use this method to activate this automatic labeling.
            obj.AddToHistory(['.SetSimultaneousExcitAutoLabel "', num2str(flag, '%.15g'), '"']);
        end
        function SetSimultaneousExcitationLabel(obj, label)
            % If the SetSimultaneousExcitAutoLabel method is disabled, it is possible to manually define a prefix name for the signals produced by simultaneous excitation run.
            obj.AddToHistory(['.SetSimultaneousExcitationLabel "', num2str(label, '%.15g'), '"']);
        end
        function SetSimultaneousExcitationOffset(obj, key)
            % This method determines the time shift definition between different time signals applied for simultaneous excitation.
            % The parameter key may have one of the following values:
            % "Timedelay"     The time delay defined with the ExcitationPortMode method is directly used to shift the signals in time.
            % "Phaseshift"    The phase shift defined with the ExcitationPortMode method is used to to calculate the time delay using the phase reference frequency (PhaseRefFrequency method). This delay value is then used to shift the signals in time.
            obj.AddToHistory(['.SetSimultaneousExcitationOffset "', num2str(key, '%.15g'), '"']);
        end
        %% PIC Solver Static Excitation
        function ConsiderEStaticField(obj, flag)
            % If flag is set to " true" an electrostatic field will be computed, which is considered for the particle simulation.
            obj.AddToHistory(['.ConsiderEStaticField "', num2str(flag, '%.15g'), '"']);
        end
        function EStaticFactor(obj, value)
            % Sets the scaling factor of an electrostatic field for the particle simulation.
            obj.AddToHistory(['.EStaticFactor "', num2str(value, '%.15g'), '"']);
        end
        function ConsiderMStaticField(obj, flag)
            % If flag is set to " true" a magnetostatic field will be computed, which is considered for the particle simulation.
            obj.AddToHistory(['.ConsiderMStaticField "', num2str(flag, '%.15g'), '"']);
        end
        function MStaticFactor(obj, value)
            % Sets the scaling factor of a magnetostatic field for the particle simulation.
            obj.AddToHistory(['.MStaticFactor "', num2str(value, '%.15g'), '"']);
        end
        function ConsiderPredefinedField(obj, flag)
            % If flag is set to " true", predefined fields are considered for the particle simulation.
            obj.AddToHistory(['.ConsiderPredefinedField "', num2str(flag, '%.15g'), '"']);
        end
        function PredefinedFactor(obj, value)
            % Sets the scaling factor of predefined fields for the particle simulation.
            obj.AddToHistory(['.PredefinedFactor "', num2str(value, '%.15g'), '"']);
        end
        %% PIC Solver Waveguide Ports
        function WaveguideBroadband(obj, flag)
            % Switches the broadband waveguide boundary condition (BBP) for inhomogeneous ports on/off.
            obj.AddToHistory(['.WaveguideBroadband "', num2str(flag, '%.15g'), '"']);
        end
        function SetBBPSamples(obj, nSamples)
            % Sets the number of frequency points used for a broadband port (BBP). Broadband ports are used for ports at inhomogeneous waveguides. The more points are used, the more accurate the port operator will be. However the simulation time will increase as well, as all selected modes are simulated for every frequency point.
            obj.AddToHistory(['.SetBBPSamples "', num2str(nSamples, '%.15g'), '"']);
        end
        function UseOpenBoundaryForHigherModes(obj, flag)
            % Determines whether unconsidered higher modes occurring at a waveguide port should be absorbed using a Mur open boundary (switch = True) or not (flag = False).
            obj.AddToHistory(['.UseOpenBoundaryForHigherModes "', num2str(flag, '%.15g'), '"']);
        end
        function SetModeFreqFactor(obj, value)
            % Specifies the frequency that is used for the waveguide port mode calculation. The factor is set relatively to the current frequency range. Therefore value may range between 0 and 1.
            obj.AddToHistory(['.SetModeFreqFactor "', num2str(value, '%.15g'), '"']);
        end
        function AdaptivePortMeshing(obj, flag)
            % Activates the adaptive port meshing feature to automatically calculate a more accurate line impedance and mode pattern. To this end, the port mode solver runs several passes while adaptively refining the port mesh.
            obj.AddToHistory(['.AdaptivePortMeshing "', num2str(flag, '%.15g'), '"']);
        end
        function AccuracyAdaptivePortMeshing(obj, nPercent)
            % Represents an accuracy limit for the relative error of the line impedance. The adaptive port meshing stops when the line impedance has not changed more than nPercent  for two following passes or when the maximum number of passes is reached.
            obj.AddToHistory(['.AccuracyAdaptivePortMeshing "', num2str(nPercent, '%.15g'), '"']);
        end
        function PassesAdaptivePortMeshing(obj, nPasses)
            % Restricts the number of passes in the adaptive port meshing if the port line impedance needs a long time to converge.
            obj.AddToHistory(['.PassesAdaptivePortMeshing "', num2str(nPasses, '%.15g'), '"']);
        end
        %% PIC Solver Lossy Metal
        function SurfaceImpedanceOrder(obj, order)
            % Specifies the order of the one-dimensional surface impedance model. Higher model order leads to enhanced simulation results at the expense of a higher calculation effort.
            obj.AddToHistory(['.SurfaceImpedanceOrder "', num2str(order, '%.15g'), '"']);
        end
        %% PIC Solver Mesh
        function TimestepReduction(obj, factor)
            % Reduces the time step by the factor factor. Generally it should not be necessary to change this value. A value that is too large might cause instabilities in the simulation and a value that is too low unnecessarily increases the simulation time.
            obj.AddToHistory(['.TimestepReduction "', num2str(factor, '%.15g'), '"']);
        end
        function UseTSTAtPort(obj, flag)
            % Specifies if TST is used in the port region of a waveguide port (flag = True) or not (flag = False).
            obj.AddToHistory(['.UseTSTAtPort "', num2str(flag, '%.15g'), '"']);
        end
        function SetSubcycleState(obj, key)
            % Specifies if the use of subcycles is activated in the time step calculation. By setting "Cycles", the possibility to use subcycles is always considered, whereas by setting "NoCycles"  the use of subcycles is never considered. By setting "Automatic" the use or not of subcycles is regulated internally.
            % key: 'Automatic'
            %      'Cycles'
            %      'NoCycles'
            obj.AddToHistory(['.SetSubcycleState "', num2str(key, '%.15g'), '"']);
        end
        function NumberOfSubcycles(obj, nCycles)
            % Specifies the number of extra time steps for cells with a very small local time step. Generally this value should not be changed.
            obj.AddToHistory(['.NumberOfSubcycles "', num2str(nCycles, '%.15g'), '"']);
        end
        function SubcycleFillLimit(obj, percentage)
            % Special setting for the PBA method. Generally this setting should not be changed.
            obj.AddToHistory(['.SubcycleFillLimit "', num2str(percentage, '%.15g'), '"']);
        end
        function SetSubgridCycleState(obj, key)
            % When the Multilevel Subgridding Scheme is activated, this command specifies if the use of subgrid specific cycling is considered in the time step calculation. When subgrid specific cycling is activated, the different grid levels are calculated with different time steps.
            % key: 'Automatic'
            %      'Cycles'
            %      'NoCycles'
            obj.AddToHistory(['.SetSubgridCycleState "', num2str(key, '%.15g'), '"']);
        end
        function SimplifiedPBAMethod(obj, flag)
            % This method activates a simplified PBA formulation for the transient simulation without any timestep reduction or usage of subcycled updates. This advantage is gained by a slight loss of accuracy and decrease of convergence.
            obj.AddToHistory(['.SimplifiedPBAMethod "', num2str(flag, '%.15g'), '"']);
        end
        %% PIC Solver Excitation Signals
        function ExcitationSignalGauss(obj, signalName, fmin, fmax)
            % Creates a new excitation signal with gaussian excitation function within the given frequency range. Please note that for proper broadband S-Parameter calculations the Gaussian pulse should always be used. To ensure accurate results the signal's frequency range must be consistent with the project's frequency range.
            obj.AddToHistory(['.ExcitationSignalGauss "', num2str(signalName, '%.15g'), '", '...
                                                     '"', num2str(fmin, '%.15g'), '", '...
                                                     '"', num2str(fmax, '%.15g'), '"']);
        end
        function ExcitationSignalRect(obj, signalName, ttotal, trise, thold, tfall)
            % Creates a new excitation signal with rectangular excitation function. Please note that for proper broadband S-Parameter calculations the Gaussian pulse should always be used. To ensure accurate results the signal's timing settings must be consistent with the project's frequency range.
            obj.AddToHistory(['.ExcitationSignalRect "', num2str(signalName, '%.15g'), '", '...
                                                    '"', num2str(ttotal, '%.15g'), '", '...
                                                    '"', num2str(trise, '%.15g'), '", '...
                                                    '"', num2str(thold, '%.15g'), '", '...
                                                    '"', num2str(tfall, '%.15g'), '"']);
        end
        function ExcitationSignalUser(obj, signalName, tTotal)
            % Creates a new excitation signal with a user-defined excitation function. A user-defined function can be created by writing a VBA-function with the name ExcitationFunction inside a file named Projectname^signal_name.usf for an arbitrary signal name or Projectname.usf for the reference signal name. This file has to be located in the same directory as the current project. Please note that for proper broadband S-Parameter calculations the Gaussian pulse should always be used. To ensure accurate results the signal's timing settings must be consistent with the project's frequency range.
            obj.AddToHistory(['.ExcitationSignalUser "', num2str(signalName, '%.15g'), '", '...
                                                    '"', num2str(tTotal, '%.15g'), '"']);
        end
        function ExcitationSignalAsReference(obj, signalName)
            % Selects the given excitation signal signalName as default / reference signal.
            obj.AddToHistory(['.ExcitationSignalAsReference "', num2str(signalName, '%.15g'), '"']);
        end
        function ExcitationSignalRename(obj, oldName, newName)
            % Renames an existing excitation signal.
            obj.AddToHistory(['.ExcitationSignalRename "', num2str(oldName, '%.15g'), '", '...
                                                      '"', num2str(newName, '%.15g'), '"']);
        end
        function ExcitationSignalDelete(obj, signalName)
            % Deletes an existing excitation signal.
            obj.AddToHistory(['.ExcitationSignalDelete "', num2str(signalName, '%.15g'), '"']);
        end
        function ExcitationSignalResample(obj, signalName, tmin, tmax, tstep)
            % Generates a signal file Projectname^signal_name.sig within the specified time interval [tmin, tmax], sampled with the timestep tstep.
            obj.AddToHistory(['.ExcitationSignalResample "', num2str(signalName, '%.15g'), '", '...
                                                        '"', num2str(tmin, '%.15g'), '", '...
                                                        '"', num2str(tmax, '%.15g'), '", '...
                                                        '"', num2str(tstep, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPICSolver
        history
        bulkmode

    end
end

%% Default Settings
% PIC Solver Defaults
% PBAFillLimit(99)
% SimulationTime(0.0)
% ConsiderEStaticField(0)
% EStaticFactor(1.0)
% ConsiderMStaticField(0)
% MStaticFactor(1.0)
% ConsiderPredefinedBField(0)
% PredefinedBFactor(1.0)
% MeshAdaption(0)
% UseDistributedComputing(0)
% StoreTDResultsInCache(0)
% TimeStepStabilityFactor(1.0)
% CalculateModesOnly(0)
% StimulationMode(1)
% SetBBPSamples(5)
% WaveguideBroadband(0)
% UseOpenBoundaryForHigherModes(0)
% SetModeFreqFactor(0.5)
% AdaptivePortMeshing(1)
% AccuracyAdaptivePortMeshing(1)
% PassesAdaptivePortMeshing(3)
% NumberOfPulseWidths(20)
% SurfaceImpedanceOrder(10)
% TimestepReduction(0.45)
% SetSubcycleState('Automatic');
% NumberOfSubcycles(4)
% SubcycleFillLimit(70)
% SetSubgridCycleState('Automatic');
% SimplifiedPBAMethod(0)
% SetSimultaneousExcitAutoLabel(1)
% SetSimultaneousExcitationOffset('Phaseshift');
% AlwaysExludePec(0)
% RestartAfterInstabilityAbort(1)
% HardwareAcceleration(0)
% SetPMLType('ConvPML');

%% Example - Taken from CST documentation and translated to MATLAB.
% % PIC Solver simulation with a predefined B-Field
% picsolver = project.PICSolver();
%     picsolver.ConsiderEStaticField('0');
%     picsolver.EStaticFactor('1.0');
%     picsolver.ConsiderMStaticField('0');
%     picsolver.MStaticFactor('1.0');
%     picsolver.ConsiderPredefinedBField('1');
%     picsolver.PredefinedBFactor('1.5');
%     picsolver.StimulationPort('Selected');
%     picsolver.StimulationMode('All');
%     picsolver.SimulationTime('2');
%     picsolver.CalculateModesOnly('0');
%     picsolver.StoreTDResultsInCache('0');
%     picsolver.UseDistributedComputing('0');
%
