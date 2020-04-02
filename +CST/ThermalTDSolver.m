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

% This object is used to define the Thermal transient solver settings.
classdef ThermalTDSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ThermalTDSolver object.
        function obj = ThermalTDSolver(project, hProject)
            obj.project = project;
            obj.hThermalTDSolver = hProject.invoke('ThermalTDSolver');
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
            % Prepend With ThermalTDSolver and append End With
            obj.history = [ 'With ThermalTDSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ThermalTDSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['ThermalTDSolver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Start = int(obj)
            % Starts the Thermal transient solver. Returns 0 if the solver run was successful, an error code >0 otherwise.
            Start = obj.hThermalTDSolver.invoke('int');
        end
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function AmbientTemperature(obj, value)
            % Specifies the ambient temperature value.
            obj.AddToHistory(['.AmbientTemperature "', num2str(value, '%.15g'), '"']);
        end
        function StoreResultsInCache(obj, flag)
            % If the flag is set to True this method stores results of the thermal solver in the result cache.
            obj.AddToHistory(['.StoreResultsInCache "', num2str(flag, '%.15g'), '"']);
        end
        function UseDistributedComputing(obj, useDC)
            % Enables or disables distributed computing.
            obj.AddToHistory(['.UseDistributedComputing "', num2str(useDC, '%.15g'), '"']);
        end
        function Method(obj, solvermethod)
            % Specifies the method used by the Thermal transient solver for discretization and solution.
            % The following values are available: "Hexahedral Mesh", "Tetrahedral Mesh".
            obj.AddToHistory(['.Method "', num2str(solvermethod, '%.15g'), '"']);
        end
        function StartSolutionAccuracy(obj, accuracy)
            % Specifies the accuracy of the start solution at t=0.
            obj.AddToHistory(['.StartSolutionAccuracy "', num2str(accuracy, '%.15g'), '"']);
        end
        function TransientSolverAccuracy(obj, accuracy)
            % Specifies the accuracy of the transient solver process.
            obj.AddToHistory(['.TransientSolverAccuracy "', num2str(accuracy, '%.15g'), '"']);
        end
        function NonlinearSolverAccuracy(obj, value)
            % Specifies the desired accuracy value for nonlinear iteration cycles, used e.g. for radiation effects.
            obj.AddToHistory(['.NonlinearSolverAccuracy "', num2str(value, '%.15g'), '"']);
        end
        function SimulationDuration(obj, duration)
            % Specifies the duration of the simulation.
            obj.AddToHistory(['.SimulationDuration "', num2str(duration, '%.15g'), '"']);
        end
        function ResetExcitationList(obj)
            % Deletes all excitation setting for the transient solver.
            obj.AddToHistory(['.ResetExcitationList']);
        end
        function UseMaxNumberOfThreads(obj, useMaxThreads)
            % By default (useMaxThreads = True), the solver is run in the parallel mode, with the number of threads equal to the minimum of the following numbers:
            % - Number of available parallelization licenses,
            % - Parallelization capability of the processor's architecture,
            % - MaxNumberOfThreads setting.
            % If useMaxThreads=False, the solver parallelization is off.
            obj.AddToHistory(['.UseMaxNumberOfThreads "', num2str(useMaxThreads, '%.15g'), '"']);
        end
        function MaxNumberOfThreads(obj, nThreads)
            % If the solver is to use less than all available threads (cf. UseMaxNumberOfThreads), the desired number can be specified here. The default value ”96” is chosen in the way that it exceeds the possibility of the modern processors architecture.
            obj.AddToHistory(['.MaxNumberOfThreads "', num2str(nThreads, '%.15g'), '"']);
        end
        function MaximumNumberOfCPUDevices(obj, nCpus)
            % If (useMaxThreads = True), use this command to specify the maximal number of processors on your system to be utilized by the calculation. If this number is larger that the number of available processors, the actual number of processors is used instead.
            obj.AddToHistory(['.MaximumNumberOfCPUDevices "', num2str(nCpus, '%.15g'), '"']);
        end
        function PTCDefault(obj, ptctype)
            % Specifies how ptc domains without source definition and thermal boundary behave:
            % enum ptctype    meaning
            % "Floating"      treat all PTC domains as floating temperatures
            % "Ambient"       treat all PTC domains with the fixed ambient temperature
            obj.AddToHistory(['.PTCDefault "', num2str(ptctype, '%.15g'), '"']);
        end
        function Excitation(obj, sourcename, sourcetype, timeshift, signalname, active)
            % Adds a new transient source to the simulation process. This command allows to assign a time signal to a previously defined thermal source.
            obj.AddToHistory(['.Excitation "', num2str(sourcename, '%.15g'), '", '...
                                          '"', num2str(sourcetype, '%.15g'), '", '...
                                          '"', num2str(timeshift, '%.15g'), '", '...
                                          '"', num2str(signalname, '%.15g'), '", '...
                                          '"', num2str(active, '%.15g'), '"']);
        end
        function UseAdaptiveTimeStep(obj, adaptive)
            % Defines whether the time step width should be selected adaptively based on the solution change or a constant time step should be used.
            obj.AddToHistory(['.UseAdaptiveTimeStep "', num2str(adaptive, '%.15g'), '"']);
        end
        function AdaptiveTimeStepScheme(obj, scheme)
            % Two schemes of adaptive selection of time step width are currently available:
            % Automatic   Determines all necessary parameters for the time integration process automatically.
            % User        Allows to define the most important parameters of the adaptive time integration scheme by the user.
            obj.AddToHistory(['.AdaptiveTimeStepScheme "', num2str(scheme, '%.15g'), '"']);
        end
        function TimeStepInit(obj, value)
            % If the "User" scheme of adaptive time step selection is chosen, this command specifies the width of initial time step of transient simulation.
            obj.AddToHistory(['.TimeStepInit "', num2str(value, '%.15g'), '"']);
        end
        function TimeStepMin(obj, tmin)
            % Specifies lower bounds for the adaptive time step width. This setting is useful to prevent the time step width from becoming arbitrarily small. It will only be considered when time adaption scheme "User" is enabled.
            obj.AddToHistory(['.TimeStepMin "', num2str(tmin, '%.15g'), '"']);
        end
        function TimeStepMax(obj, tmax)
            % Specifies upper bounds for the adaptive time step width. This setting is useful to prevent the time step width from becoming inappropriately large. It will only be considered when time adaption scheme "User" is enabled.
            obj.AddToHistory(['.TimeStepMax "', num2str(tmax, '%.15g'), '"']);
        end
        function TimeStepSamples(obj, nsamples)
            % Defines the maximal number of time steps to be performed.It will only be considered when time adaption scheme "User" is enabled.
            obj.AddToHistory(['.TimeStepSamples "', num2str(nsamples, '%.15g'), '"']);
        end
        function ConstTimeStepParam(obj, param)
            % If the constant time step width has been selected, this command specifies which parameter to use for time step width selection:
            % NumSteps    Time step width is defined by the whole simulation duration divided by the number of constant steps specified in the command NumConstTimeSteps.
            % StepWidth   Time step width is specified explicitly in the command ConstTimeStepWidth.
            obj.AddToHistory(['.ConstTimeStepParam "', num2str(param, '%.15g'), '"']);
        end
        function NumConstTimeSteps(obj, nsteps)
            % Defines number of constant time steps to be done during transient co-simulation. This command can only be used with ConstTimeStepParam "NumSteps".
            obj.AddToHistory(['.NumConstTimeSteps "', num2str(nsteps, '%.15g'), '"']);
        end
        function ConstTimeStepWidth(obj, stepwidth)
            % Defines the constant width of time steps to be done during transient co-simulation. This command can only be used with ConstTimeStepParam "StepWidth".
            obj.AddToHistory(['.ConstTimeStepWidth "', num2str(stepwidth, '%.15g'), '"']);
        end
        function TetSolverOrder(obj, order)
            % Defines the finite element solution order for the tetrahedral solver.
            obj.AddToHistory(['.TetSolverOrder "', num2str(order, '%.15g'), '"']);
        end
        function InitialSolutionImported(obj, fieldname)
            % Use the imported temperature field fieldname as the initial temperature distribution. For PTC solids, no temperature distributions are imported, the initial temperature values are used instead.
            obj.AddToHistory(['.InitialSolutionImported "', num2str(fieldname, '%.15g'), '"']);
        end
        function InitialSolutionStationary(obj)
            % The stationary thermal solver is started in order to generate the initial temperature distributions. All the transient sources are taken with values for the time instant t=0.
            obj.AddToHistory(['.InitialSolutionStationary']);
        end
        function InitialSolutionCustom(obj)
            % The ambient temperature is assigned to the whole solution domain except for PTC solids with temperature sources assigned.
            obj.AddToHistory(['.InitialSolutionCustom']);
        end
        function ConsiderBioheat(obj, consider)
            % Specify whether bioheat properties of materials (bloodflow coefficient and basal metabolic rate) should be taken into account by the solver.
            obj.AddToHistory(['.ConsiderBioheat "', num2str(consider, '%.15g'), '"']);
        end
        function BloodTemperature(obj, tmax)
            % Specify the blood temperature in °C. This setting is ignored if bioheat materials are absent or ignored.
            obj.AddToHistory(['.BloodTemperature "', num2str(tmax, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hThermalTDSolver
        history
        bulkmode

    end
end

%% Default Settings
% Method('Tetrahedral Mesh');
% StartSolutionAccuracy('1e-6');
% TransientSolverAccuracy('1e-6');
% NonlinearSolverAccuracy('1e-6');
% TetSolverOrder('2');
% LSESolverType('Auto');
% StoreResultsInCache('0');
% SimulationDuration('1');
% AmbientTemperature('293.15', 'Kelvin');
% ConsiderBioheat('1');
% BloodTemperature('37.0');
% PTCDefault('Ambient');
% TimeStepScheme('Automatic');
% TimeStepInit('1e-3');
% TimeStepMin('1e-6');
% TimeStepMax('1e-1');
% TimeStepSamples('100000');
% TimeIntegratorType('Automatic');
% InitialSolutionCustom
% TryLoadResumeInfoFromCache('0');
% TimeIntegrationOrder('High');
% UseMaxNumberOfThreads('1');
% MaxNumberOfThreads('96');
% MaximumNumberOfCPUDevices('2');
% UseDistributedComputing('0');

%% Example - Taken from CST documentation and translated to MATLAB.
% thermaltdsolver = project.ThermalTDSolver();
%     thermaltdsolver.Reset
%     thermaltdsolver.Method('Hexahedral Mesh');
%     thermaltdsolver.StartSolutionAccuracy('1e-6');
%     thermaltdsolver.TransientSolverAccuracy('1e-6');
%     thermaltdsolver.StoreResultsInCache('0');
%     thermaltdsolver.SimulationDuration('10');
%     thermaltdsolver.AmbientTemperature('20');
%     thermaltdsolver.TimeStepScheme('AdaptiveUser');
%     thermaltdsolver.TimeStepInit('1e-3');
%     thermaltdsolver.TimeStepMin('1e-6');
%     thermaltdsolver.TimeStepMax('1e-1');
%     thermaltdsolver.TimeStepSamples('100000');
%     thermaltdsolver.ResetExcitationList
%     thermaltdsolver.Excitation('thermal loss distribution', 'thermallossdistr', '0.0', 'constant', '1');
%     thermaltdsolver.UseDistributedComputing('0');
