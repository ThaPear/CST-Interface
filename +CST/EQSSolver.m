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

% This object is used to define the LF Frequency Domain (EQS) solver settings.
classdef EQSSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.EQSSolver object.
        function obj = EQSSolver(project, hProject)
            obj.project = project;
            obj.hEQSSolver = hProject.invoke('EQSSolver');
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
            % Prepend With EQSSolver and append End With
            obj.history = [ 'With EQSSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define EQSSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['EQSSolver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function Accuracy(obj, accuracy)
            % Specifies the  accuracy of the solver.
            obj.AddToHistory(['.Accuracy "', num2str(accuracy, '%.15g'), '"']);
        end
        function AddFrequency(obj, frequency)
            % Defines a calculation frequency for the LF frequency domain solver.
            obj.AddToHistory(['.AddFrequency "', num2str(frequency, '%.15g'), '"']);
        end
        function LSESolverType(obj, solvertype)
            % Specifies which solver is used to solve linear systems of equations.
            % enum solvertype     meaning
            % "Auto"              choose direct or iterative solver automatically depending on the problem size
            % "Iterative"         use the iterative solver
            % "Direct"            use the direct solver
            % The default setting is "Auto". Since the problem is usually singular for the magnetoquasistatic equation type, the solvertype setting will be ignored in this case and the iterative solver will be used instead.
            obj.AddToHistory(['.LSESolverType "', num2str(solvertype, '%.15g'), '"']);
        end
        function Method(obj, solvermethod)
            % Specifies the method used by the LF frequency domain (EQS) solver for discretization and solution. Currently only "Tetrahedral Mesh" is available meaning that an unstructured grid consisting of tetrahedral elements will be used.
            obj.AddToHistory(['.Method "', num2str(solvermethod, '%.15g'), '"']);
        end
        function PECDefault(obj, pectype)
            % (Supported only by electroquasistatic solver.)
            % Specifies how pec domains without source definition and electric boundary behave:
            % enum pectype    meaning
            % "Grounded"      treat all PEC domains as fixed potentials (default)
            % "Floating"      treat all PEC domains as floating potentialsr
            obj.AddToHistory(['.PECDefault "', num2str(pectype, '%.15g'), '"']);
        end
        function Preconditioner(obj, precondtype)
            % The preconditioner for the matrix equation solver.
            % enum precondtype    meaning
            % "ILU"               Incomplete LU preconditioner
            % "Jacobi"            Jacobi-type preconditioner
            % "None"              no preconditioning
            obj.AddToHistory(['.Preconditioner "', num2str(precondtype, '%.15g'), '"']);
        end
        function TetAdaption(obj, enableAdaption)
            % Enables or diables the adaptive mesh refinement for the tetrahedral mesh method.
            obj.AddToHistory(['.TetAdaption "', num2str(enableAdaption, '%.15g'), '"']);
        end
        function TetAdaptionAccuracy(obj, accuracy)
            % If the relative deviation of the energy between two passes is smaller than this error limit the mesh adaptation will terminate.
            obj.AddToHistory(['.TetAdaptionAccuracy "', num2str(accuracy, '%.15g'), '"']);
        end
        function TetAdaptionMaxCycles(obj, maxcycles)
            % Specifies the maximum number of passes to be performed for the mesh adaption, even if the results have not sufficiently converged so far. This setting is useful to limit the total calculation time to reasonable amounts.
            % This setting is considered only for the tetrahedral mesh method and ignored otherwise. For specification of hexahedral mesh adaption properties see MeshAdaption3D.
            obj.AddToHistory(['.TetAdaptionMaxCycles "', num2str(maxcycles, '%.15g'), '"']);
        end
        function TetAdaptionMinCycles(obj, mincycles)
            % Sets the minimum number of passes which will be performed during the mesh adaption, even if the results do not change significantly. Sometimes the adaptive mesh refinement needs a couple of passes to figure out the location of the most important regions. Thus it might happen that the results change only marginally during the first few passes but afterwards change in order to converge to the final solution.
            % This setting is considered only for the tetrahedral mesh method and ignored otherwise. For specification of hexahedral mesh adaption properties see MeshAdaption3D.
            obj.AddToHistory(['.TetAdaptionMinCycles "', num2str(mincycles, '%.15g'), '"']);
        end
        function TetAdaptionRefinementPercentage(obj, percent)
            % Sets the maximum percentage of mesh elements to be refined during a tetrahedral adaptation pass. The higher the specified percentage is, the stronger will the number of elements and therefore the numerical effort increase.
            obj.AddToHistory(['.TetAdaptionRefinementPercentage "', num2str(percent, '%.15g'), '"']);
        end
        function SnapToGeometry(obj, snapping)
            % When snapping is True, new nodes that are generated on the surface mesh during the mesh adaption will be projected to the original geometry, so that the approximation of curved surfaces is improved after each adaptation step.
            % If this option is disabled, the geometry will be approximated by the initial mesh. The geometric discretization error produced by this approximation will therefore not decrease, but the adaptation process might be faster.
            obj.AddToHistory(['.SnapToGeometry "', num2str(snapping, '%.15g'), '"']);
        end
        function TetSolverOrder(obj, tetorder)
            % This option allows to specify whether the tetrahedral solver uses first- or second-order accuracy. Second-order (tetorder = "2") is the default due to its higher accuracy. However, if the structure is geometrically complex and therefore comes along with huge memory requirements, first-order (tetorder = "1") is an adequate alternative.
            % This setting is considered only for the tetrahedral mesh method and ignored otherwise. For specification of hexahedral mesh adaption properties see MeshAdaption3D.
            obj.AddToHistory(['.TetSolverOrder "', num2str(tetorder, '%.15g'), '"']);
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
        function ValueScaling(obj, val)
            % This method allows to define the way in which low-frequency harmonic current or field sources are specified. If RMS is chosen, then all input values are considered to be the root-mean-square values. The Peak option can be used to specify the amplitude of sources directly.
            % val: 'RMS'
            %      'Peak'
            obj.AddToHistory(['.ValueScaling "', num2str(val, '%.15g'), '"']);
        end
        function long = Start(obj)
            % Starts the LF frequency domain solver with the prescribed settings and the currently active mesh. If no mesh is available, a new mesh will be generated. Returns 0 if the solver run was successful, an error code >0 otherwise.
            long = obj.hEQSSolver.invoke('Start');
        end
        function long = ContinueAdaption(obj)
            % Starts the LF frequency domain solver with the prescribed settings and the currently active mesh. In case of the tetrahedral solver with adaptive mesh refinement, this command will continue the previous adaption run if the corresponding results are available. Otherwise this command is similar to the Start command. Returns 0 if the solver run was successful, an error code >0 otherwise.
            long = obj.hEQSSolver.invoke('ContinueAdaption');
        end
        %% Functions
        % Please note that the appropriate Functions of the LFSolver object can be used to evaluate, for instance, the calculation frequency at a given index or the total number of define frequencies.
        function filename = GetDatabaseResultDirName(obj, frequency)
            % Get the result database directory for a certain run, which is accessed by its frequency value.
            filename = obj.hEQSSolver.invoke('GetDatabaseResultDirName', frequency);
        end
        function double = GetEnergy(obj, frequency)
            % Returns the total electromagnetic energy at the frequency frequency.
            double = obj.hEQSSolver.invoke('GetEnergy', frequency);
        end
        function double = GetTotalLosses(obj, frequency)
            % Returns the total loss power in Watt at the frequency frequency.
            double = obj.hEQSSolver.invoke('GetTotalLosses', frequency);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hEQSSolver
        history
        bulkmode

    end
end

%% Default Settings
% Accuracy('1e-6');
% Preconditioner('ILU');
% UseFullWaveCalculation('0');
% LSESolverType('Auto');
% ValueScaling('Peak');
% UseMaxNumberOfThreads('0');
% MaxNumberOfThreads('8');
% TetAdaption('1');
% TetSolverOrder('2');

%% Example - Taken from CST documentation and translated to MATLAB.
% eqssolver = project.EQSSolver();
%     eqssolver.Reset
%     eqssolver.Accuracy('1e-6');
%     eqssolver.Preconditioner('ILU');
%     eqssolver.UseFullWaveCalculation('0');
%     eqssolver.LSESolverType('Auto');
