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

% This object is used to define the electrostatic solver settings.
classdef EStaticSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.EStaticSolver object.
        function obj = EStaticSolver(project, hProject)
            obj.project = project;
            obj.hEStaticSolver = hProject.invoke('EStaticSolver');
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
            % Prepend With EStaticSolver and append End With
            obj.history = [ 'With EStaticSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define EStaticSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['EStaticSolver', command]);
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
        function CalcCapacitanceMatrix(obj, calcCapacitance)
            % Specifies whether or not to calculate the capacitance matrix between all defined fixed potentials. The dimension N of the capacitance matrix is equivalent to the number of defined fixed potentials and the calculation requires N solver runs.
            % Please note that charges have no influence on the capacitance matrix.
            obj.AddToHistory(['.CalcCapacitanceMatrix "', num2str(calcCapacitance, '%.15g'), '"']);
        end
        function LSESolverType(obj, solvertype)
            % Specifies which solver is used to solve linear systems of equations.
            % enum solvertype meaning
            % "Auto"          choose direct or iterative solver automatically depending on the problem size
            % "Iterative"     use the iterative solver
            % "Direct"        use the direct solver
            obj.AddToHistory(['.LSESolverType "', num2str(solvertype, '%.15g'), '"']);
        end
        function default = The(obj)
            default = obj.hEStaticSolver.invoke('The');
        end
        function MaxLinIter(obj, value)
            % The number of iterations performed by the linear solver is automatically limited by a number depending on the desired solver accuracy. This is equivalent to setting the value to "0". If you would like to prescribe a fixed upper limit for number of linear iterations, then specify the corresponding value here.
            obj.AddToHistory(['.MaxLinIter "', num2str(value, '%.15g'), '"']);
        end
        function Method(obj, solvermethod)
            % Specifies the method used by the electrostatic solver for discretization and solution.
            % enum solvermethod   meaning
            % "Hexahedral Mesh"   structured grid consisting of hexahedral elements.
            % "Tetrahedral Mesh"  unstructured grid consisting of tetrahedral elements.
            obj.AddToHistory(['.Method "', num2str(solvermethod, '%.15g'), '"']);
        end
        function MeshAdaption(obj, enableAdaption)
            % Enables or disables the adaptive mesh refinement for the hexahedral mesh method.
            obj.AddToHistory(['.MeshAdaption "', num2str(enableAdaption, '%.15g'), '"']);
        end
        function OpenBCChargeFree(obj, chargefree)
            % If open boundaries are set for the calculation domain you can choose between a charge free or fixed type. By default (chargefree=False), the potential value at infinity is fixed and should be specified with the OpenBCPotential command. Use this option if the ground conductor is not included in the simulation domain.
            % If chargefree is set True, the potential at infinity is floating and charge free. For configurations with multiple conductors including the ground this is probably the correct choice.
            obj.AddToHistory(['.OpenBCChargeFree "', num2str(chargefree, '%.15g'), '"']);
        end
        function OpenBCPotential(obj, potential)
            % Sets the potential value for open boundaries of type fixed, i.e. OpenBCChargeFree "False". The default value is "0".
            obj.AddToHistory(['.OpenBCPotential "', num2str(potential, '%.15g'), '"']);
        end
        function PECDefault(obj, pectype)
            % Specifies how pec domains without source definition and electric boundary behave:
            % enum pectype    meaning
            % "Grounded"      treat all PEC domains as fixed potentials (default)
            % "Floating"      treat all PEC domains as floating potentialsr
            obj.AddToHistory(['.PECDefault "', num2str(pectype, '%.15g'), '"']);
        end
        function SavePotentialChargeData(obj, saveData)
            % Specifies whether or not to store the potential and charge data to a file.
            obj.AddToHistory(['.SavePotentialChargeData "', num2str(saveData, '%.15g'), '"']);
        end
        function StoreResultsInCache(obj, storeResults)
            % Specifies whether or not to store calculation results in the result data cache.
            obj.AddToHistory(['.StoreResultsInCache "', num2str(storeResults, '%.15g'), '"']);
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
        function long = Start(obj)
            % Starts the electrostatic solver with the prescribed settings and the currently active mesh. If no mesh is available, a new mesh will be generated. Returns 0 if the solver run was successful, an error code >0 otherwise.
            long = obj.hEStaticSolver.invoke('Start');
        end
        function long = ContinueAdaption(obj)
            % Starts the electrostatic solver with the prescribed settings and the currently active mesh. In case of the tetrahedral solver with adaptive mesh refinement, this command will continue the previous adaption run if the corresponding results are available. Otherwise this command is similar to the Start command. Returns 0 if the solver run was successful, an error code >0 otherwise.
            long = obj.hEStaticSolver.invoke('ContinueAdaption');
        end
        %% Functions
        function double = GetCapacitanceValueGrounded(obj, source1, source2)
            % Retrieves the couple capacitance between given electrostatic source definitions. The return value represents an element of the grounded capacitance matrix in Farad. The grounded capacitance matrix describes the relation between the voltages to ground and the charges on the conductors.
            double = obj.hEStaticSolver.invoke('GetCapacitanceValueGrounded', source1, source2);
        end
        function double = GetCapacitanceValueLumped(obj, source1, source2)
            % Retrieves the couple capacitance between given electrostatic source definitions. The return value represents an element of the lumped capacitance matrix in Farad. The lumped capacitance values are based on voltages between conductors (instead of voltages to ground).
            double = obj.hEStaticSolver.invoke('GetCapacitanceValueLumped', source1, source2);
        end
        function double = GetEnergy(obj)
            % Returns the total electrostatic energy in the computational domain in Joule.
            double = obj.hEStaticSolver.invoke('GetEnergy');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hEStaticSolver
        history
        bulkmode

    end
end

%% Default Settings
% Method('Tetrahedral Mesh');
% Accuracy('1e-6');
% MaxLinIter('0');
% CalcCapacitanceMatrix('0');
% StoreResultsInCache('0');
% Preconditioner('ILU');
% MeshAdaption('0');
% LSESolverType('Auto');
% PECDefault('Grounded');
% OpenBCChargeFree('0');
% OpenBCPotential('0.0');
% TetSolverOrder('2');
% TetAdaption('1');
% TetAdaptionMinCycles('2');
% TetAdaptionMaxCycles('6');
% TetAdaptionAccuracy('0.01');
% TetAdaptionRefinementPercentage('10');
% SnapToGeometry('1');
% UseMaxNumberOfThreads('1');
% MaxNumberOfThreads('96');
% MaximumNumberOfCPUDevices('2');
% UseDistributedComputing('0');

%% Example - Taken from CST documentation and translated to MATLAB.
% estaticsolver = project.EStaticSolver();
%     estaticsolver.Reset
%     estaticsolver.Method('Hexahedral Mesh');
%     estaticsolver.Accuracy('1e-6');
%     estaticsolver.CalcCapacitanceMatrix('1');
%     estaticsolver.StoreResultsInCache('0');
%     estaticsolver.Preconditioner('ILU');
%     estaticsolver.MeshAdaption('0');
%     estaticsolver.SavePotentialChargeData('0');
