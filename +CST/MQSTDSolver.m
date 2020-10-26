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

% This object is used to define the LF Time Domain solver settings for the magnetoquasistatic equation type.
classdef MQSTDSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.MQSTDSolver object.
        function obj = MQSTDSolver(project, hProject)
            obj.project = project;
            obj.hMQSTDSolver = hProject.invoke('MQSTDSolver');
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
            % Prepend With MQSTDSolver and append End With
            obj.history = [ 'With MQSTDSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define MQSTDSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['MQSTDSolver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function Method(obj, solvermethod)
            % Specifies the method used by the LF time domain solver for discretization and solution.
            % Currently, only "Tetrahedral Mesh" is available for the magnetoquasistatic equation type.
            obj.AddToHistory(['.Method "', num2str(solvermethod, '%.15g'), '"']);
        end
        function TetSolverOrder(obj, tetorder)
            % This option allows to specify whether the tetrahedral solver uses first- or second-order accuracy. Second-order (tetorder = "2") is the default due to its higher accuracy. However, if the structure is geometrically complex and therefore comes along with huge memory requirements, first-order (tetorder = "1") is an adequate alternative.
            obj.AddToHistory(['.TetSolverOrder "', num2str(tetorder, '%.15g'), '"']);
        end
        function SystemSolverType(obj, solvertype)
            % Specifies which solver is used to solve the linear systems of equations.
            % enum solvertype meaning
            % "Auto"          choose direct or iterative solver automatically depending on the problem size
            % "Iterative"     use the iterative solver
            % "Direct"        use the direct solver
            %
            % The default setting is "Auto" which defaults to the type "r;Iterative". Currently other options are not supported yet.
            obj.AddToHistory(['.SystemSolverType "', num2str(solvertype, '%.15g'), '"']);
        end
        function TimeIntegrationMethod(obj, timeintmethod)
            % Specifies which time integration method to use.
            % enum timeintmethod  meaning
            % "High order"        Use a high order time integration scheme with optional adaptive selection of time step size.
            % "Low order"         Use a low order time integration scheme. Only constant time steps are supported.
            %
            % The default option is "Low order".
            obj.AddToHistory(['.TimeIntegrationMethod "', num2str(timeintmethod, '%.15g'), '"']);
        end
        function TimeHarmonicMethod(obj, timeharmonicmethod)
            % Specifies if a steady state special algorithm is to be used and the periodicity types of the excitation signals.
            % enum timeharmonicmethod     meaning
            % "Harmonic None"             A transient simulation is performed.
            % "Harmonic"                  The solver automatically detects the periodicity of the excitation signals and applies the steady state algorithm.
            % "Harmonic Periodic"         Periodic time signals are assumed and the steady state algorithm is applied.
            % "Harmonic Antiperiodic"     Anti-periodic time signals are assumed and the steady state algorithm is applied.
            %
            % The default option is "Harmonic None". The correct length of one period or half of a period needs to be set in the Simulation duration.
            obj.AddToHistory(['.TimeHarmonicMethod "', num2str(timeharmonicmethod, '%.15g'), '"']);
        end
        function Accuracy(obj, accuracy)
            % During the solver run, the relative residual norm is frequently checked against the specified accuracy. The solver stops when the desired accuracy or a maximum number of iteration steps has been reached.
            obj.AddToHistory(['.Accuracy "', num2str(accuracy, '%.15g'), '"']);
        end
        function MaxNumIter(obj, value)
            % The number of iterations performed by the (linear or nonlinear) solver is automatically limited by a number depending on the desired solver accuracy. This is equivalent to setting the value to "0". If you would like to prescribe a fixed upper limit for number of iterations, then specify the corresponding value here.
            % In case that nonlinear materials are defined, i.e. the nonlinear solver is running, the maximum number of iterations allowed for the linear solver steps will be determined automatically depending on the value specified here.
            obj.AddToHistory(['.MaxNumIter "', num2str(value, '%.15g'), '"']);
        end
        function SimulationDuration(obj, duration)
            % Specifies the duration of the simulation.
            obj.AddToHistory(['.SimulationDuration "', num2str(duration, '%.15g'), '"']);
        end
        function StoreResultsInCache(obj, storeresultsincache)
            % Indicates if all models and results during a  parameter sweep or optimization should be stored in subfolders or not.
            obj.AddToHistory(['.StoreResultsInCache "', num2str(storeresultsincache, '%.15g'), '"']);
        end
        function TimeAdaption(obj, enableAdaption)
            % Determines whether the time step width is constant during the entire simulation (enableAdaption = False) or whether it is to be adapted during the simulation process (default; enableAdaption = True) according to the respective calculation results. In general, the adaptive determination of the time step width is recommended. If you should encounter problems like lengthy calculations because of seemingly small or large adaptive steps, it might be useful to disable the time adaption.
            obj.AddToHistory(['.TimeAdaption "', num2str(enableAdaption, '%.15g'), '"']);
        end
        function TimeStepWidthActive(obj, enableStepwidth)
            % This option is considered only for simulations with constant time step width. It determines whether a specified number of samples or a specified constant step width is to be taken into account during the simulation process. The respective other setting will be ignored. By default, enableStepwidth is True, enabling a time step witdh specification.
            obj.AddToHistory(['.TimeStepWidthActive "', num2str(enableStepwidth, '%.15g'), '"']);
        end
        function TimeStepWidth(obj, stepwidth)
            % Specifies the constant step width to be used during the entire simulation process. This setting will be ignored when time adaption is enabled.
            obj.AddToHistory(['.TimeStepWidth "', num2str(stepwidth, '%.15g'), '"']);
        end
        function TimeStepSamples(obj, nsamples)
            % Defines the total number of time steps to be performed. This setting is ignored when time adaption is enabled.
            obj.AddToHistory(['.TimeStepSamples "', num2str(nsamples, '%.15g'), '"']);
        end
        function TimeStepMin(obj, tmin)
            % Specifies lower and upper bounds for the adaptive time step width. This setting is useful to prevent the time step width from becoming arbitrarily small or inappropriately large. It will be ignored when time adaption is disabled.
            obj.AddToHistory(['.TimeStepMin "', num2str(tmin, '%.15g'), '"']);
        end
        function TimeStepMax(obj, tmax)
            % Specifies lower and upper bounds for the adaptive time step width. This setting is useful to prevent the time step width from becoming arbitrarily small or inappropriately large. It will be ignored when time adaption is disabled.
            obj.AddToHistory(['.TimeStepMax "', num2str(tmax, '%.15g'), '"']);
        end
        function TimeStepInit(obj, tinit)
            % Suggests a first time step with to be used by the solver. However, if certain error criteria are not satisfied, the solver reduces this step width.
            obj.AddToHistory(['.TimeStepInit "', num2str(tinit, '%.15g'), '"']);
        end
        function TimeStepTolerance(obj, tol)
            % This is a user specified tolerance for the local error and allows to decide whether the current integration step is accepted or whether a new attempt with a smaller step size is necessary. This setting will be ignored when time adaption is disabled.
            obj.AddToHistory(['.TimeStepTolerance "', num2str(tol, '%.15g'), '"']);
        end
        function UseDistributedComputing(obj, useDC)
            % Enables or disables distributed computing.
            obj.AddToHistory(['.UseDistributedComputing "', num2str(useDC, '%.15g'), '"']);
        end
        function UseMaxNumberOfThreads(obj, useMaxThreads)
            % By default (useMaxThreads = False), the solver is forced to employ a particular number of threads that is defined on the basis of the current processor’s architecture and the number of the available parallel licenses. If activated (useMaxThreads = True), the solver can be forced to use less than all available threads (see MaxNumberOfThreads).
            obj.AddToHistory(['.UseMaxNumberOfThreads "', num2str(useMaxThreads, '%.15g'), '"']);
        end
        function MaxNumberOfThreads(obj, nThreads)
            % If the solver is to use less than all available threads (cf. UseMaxNumberOfThreads), the desired number can be specified here. The default value "r;8" reflects the possibility of the modern processors architecture.
            obj.AddToHistory(['.MaxNumberOfThreads "', num2str(nThreads, '%.15g'), '"']);
        end
        function long = Start(obj)
            % Starts the LF time domain solver (MQS) with the prescribed settings and the currently active mesh. Returns 0 if the solver run was successful, an error code >0 otherwise.
            long = obj.hMQSTDSolver.invoke('Start');
        end
        %% CST 2014 Functions.
        function LinAccuracy(obj, accuracy)
            % Specifies the accuracy of the linear solver.
            obj.AddToHistory(['.LinAccuracy "', num2str(accuracy, '%.15g'), '"']);
        end
        function NLinAccuracy(obj, accuracy)
            % Specifies the accuracy of the nonlinear solver.
            obj.AddToHistory(['.NLinAccuracy "', num2str(accuracy, '%.15g'), '"']);
        end
        function NlinCycles(obj, value)
            % Specifies the maximum number of nonlinear iterations when nonlinear materials are defined.
            obj.AddToHistory(['.NlinCycles "', num2str(value, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hMQSTDSolver
        history
        bulkmode

    end
end

%% Default Settings
% Accuracy('1e-6');
% MaxNumIter('0');
% SimulationDuration('0');
% TimeAdaption('1');
% TimeStepWidth('1e-2');
% TimeStepSamples('100');
% TimeStepMin('1e-6');
% TimeStepMax('1e-1');
% TimeStepInit('1e-2');
% TimeStepTolerance('1e-4');
% UseDistributedComputing('0');
% UseMaxNumberOfThreads('0');
% MaxNumberOfThreads('8');

%% Example - Taken from CST documentation and translated to MATLAB.
% mqstdsolver = project.MQSTDSolver();
%     mqstdsolver.Reset
%     mqstdsolver.Accuracy('1e-6');
%     mqstdsolver.SimulationDuration('10');
%     mqstdsolver.TimeStepAdaptive('1');
%     mqstdsolver.TimeStepMin('1e-6');
%     mqstdsolver.TimeStepMax('1e-1');
%     mqstdsolver.TimeStepTolerance('1e-4');
%     mqstdsolver.UseDistributedComputing('0');
%     mqstdsolver.Start
