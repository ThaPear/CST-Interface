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

% This object is used to define the magnetostatic solver settings.
classdef MStaticSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.MStaticSolver object.
        function obj = MStaticSolver(project, hProject)
            obj.project = project;
            obj.hMStaticSolver = hProject.invoke('MStaticSolver');
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
            % Prepend With MStaticSolver and append End With
            obj.history = [ 'With MStaticSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define MStaticSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['MStaticSolver', command]);
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
            % During the solver run with a tetrahedral mesh, a relative residual norm is frequently checked against the specified accuracy. The solver stops when the desired accuracy or a maximum number of iteration steps has been reached.
            % In case of the hexahedral mesh type and nonlinear materials, the material accuracy (outer cycle) is determined automatically depending on this value.
            obj.AddToHistory(['.Accuracy "', num2str(accuracy, '%.15g'), '"']);
        end
        function ApparentInductanceMatrix(obj, calcInductance)
            % Switches the calculation of the inductance matrix  between all defined current coils and current paths on or off. Please note that each current sources definition increases the inductance matrix dimension N by one.
            % For the hexahedral solver, the number of solver runs necessary to compute the inductance matrix can be estimated in advance: If coils are defined the full inductance matrix requires at most  (0.5*N*(N-1)) additional solver runs. For the special case that no coils are defined at most N additional solver runs are sufficient. When only one current source has been defined, only one single run is necessary to compute the self inductance.
            % The apparent inductance matrix relates the currents to the flux linkages. The incremental inductance matrix (currently available only for the tetrahedral solver) relates the time derivative of the currents to the induced voltages.
            % Please note: Both, the apparent and the incremental inductance matrices are symmetric. In case of a pure linear computation (no nonlinear materials defined), they coincide with the inductance matrix.
            obj.AddToHistory(['.ApparentInductanceMatrix "', num2str(calcInductance, '%.15g'), '"']);
        end
        function IncrementalInductanceMatrix(obj, calcInductance)
            % Switches the calculation of the inductance matrix  between all defined current coils and current paths on or off. Please note that each current sources definition increases the inductance matrix dimension N by one.
            % For the hexahedral solver, the number of solver runs necessary to compute the inductance matrix can be estimated in advance: If coils are defined the full inductance matrix requires at most  (0.5*N*(N-1)) additional solver runs. For the special case that no coils are defined at most N additional solver runs are sufficient. When only one current source has been defined, only one single run is necessary to compute the self inductance.
            % The apparent inductance matrix relates the currents to the flux linkages. The incremental inductance matrix (currently available only for the tetrahedral solver) relates the time derivative of the currents to the induced voltages.
            % Please note: Both, the apparent and the incremental inductance matrices are symmetric. In case of a pure linear computation (no nonlinear materials defined), they coincide with the inductance matrix.
            obj.AddToHistory(['.IncrementalInductanceMatrix "', num2str(calcInductance, '%.15g'), '"']);
        end
        function EnableDivergenceCheck(obj, flag)
            % If current sources are defined, the magnetostatic solver requires them to form closed current loops or that they end at perfect electric conductors (PEC) or electric boundary conditions. The same condition has to be fulfilled if conductive domains are defined and a stationary current field is used as source for the magnetostatic solver. (This can be enabled with the PrecomputeStationaryCurrentSource command.)
            % Otherwise the problem is not solvable by the magnetostatic solver, since Ampere's Law is violated. If such a situation is detected by the solver, an error will be printed saying that the model is not divergence-free or that currents are appearing or disappearing within the calculation domain. The solver will abort in this case.
            % This detection method is called divergence check. A divergence check might fail even for valid model setups, if the source field could not be computed with sufficient accuracy. Typical reasons are low mesh quality, high ratios (jumps) in material coefficients or insufficient accuracy settings. In particular, when a stationary current field is used as source for the magnetostatic solver, it is recommended to use a high accuracy for the linear solver. Furthermore, you can consider to refine the mesh or to relax high ratios of the material coefficients by replacing materials with very high electric conductivities by PEC material or materials with very low conductivities by normal material.
            % If you do not want the solver to abort in case of a detected divergence error, you should relax the divergence check by setting the flag to False. Mind that this might lead to convergence problems or inaccurate results. Please check your results carefully in this case.
            % Please note: The divergence check will be performed anyway. But if you relax the check, only a warning will be printed informing you about potential problems.
            obj.AddToHistory(['.EnableDivergenceCheck "', num2str(flag, '%.15g'), '"']);
        end
        function GridLocation(obj, gridlocation)
            % Specifies whether the dual grid based (default) or the normal grid based magnetostatic solver is used for the field calculation.
            % enum gridlocation   meaning
            % "normal"            The magnetic field H is allocated on the edges of the normal grid.
            % "dual"              The magnetic field H is allocated on the edges of the dual grid.
            %
            % This setting is considered only for the hexahedral mesh type and will be ignored by the tetrahedral solver.
            obj.AddToHistory(['.GridLocation "', num2str(gridlocation, '%.15g'), '"']);
        end
        function IgnorePECMaterial(obj, ignorePEC)
            % Enables or disables the consideration of pec materials. Usually pec materials need not to be ignored (default). If set "True", all pec materials will be treated like normal material with a Mu value to be specified.
            % This setting is considered only for the hexahedral mesh type and will be ignored by the tetrahedral solver.
            obj.AddToHistory(['.IgnorePECMaterial "', num2str(ignorePEC, '%.15g'), '"']);
        end
        function LSESolverType(obj, solvertype)
            % Specifies which solver is used to solve linear systems of equations.
            % enum solvertype meaning
            % "Auto"          choose direct or iterative solver automatically depending on the problem size
            % "Iterative"     use the iterative solver
            % "Direct"        use the direct solver
            %
            % The default setting is "Auto". The solvertype setting is of interest only for the tetrahedral solver method and will be ignored otherwise.
            obj.AddToHistory(['.LSESolverType "', num2str(solvertype, '%.15g'), '"']);
        end
        function MaxNumIter(obj, value)
            % The number of iterations performed by the (linear or nonlinear) solver is automatically limited by a number depending on the desired solver accuracy. This is equivalent to setting the value to "0". If you would like to prescribe a fixed upper limit for number of iterations, then specify the corresponding value here.
            % In case that nonlinear materials are defined, i.e. the nonlinear solver is running, the maximum number of iterations allowed for the linear solver steps will be determined automatically depending on the value specified here.
            %
            % NOTE: This method is defined twice in the documentation. The other one has the following description:
            % Specifies the maximum number of nonlinear iteration cycles when nonlinear materials are defined.
            obj.AddToHistory(['.MaxNumIter "', num2str(value, '%.15g'), '"']);
        end
        function MeshAdaption(obj, enableAdaption)
            % Enables or disables the adaptive mesh refinement for the hexahedral mesh method.
            obj.AddToHistory(['.MeshAdaption "', num2str(enableAdaption, '%.15g'), '"']);
        end
        function Method(obj, solvermethod)
            % Specifies the method used by the magnetostatic solver for discretization and solution.
            % enum solvermethod   meaning
            % "Hexahedral Mesh"   structured grid consisting of hexahedral elements.
            % "Tetrahedral Mesh"  unstructured grid consisting of tetrahedral elements.
            % "Planar Mesh"       unstructured planar grid consisting of triangular elements.
            obj.AddToHistory(['.Method "', num2str(solvermethod, '%.15g'), '"']);
        end
%         function MaxNumIter(obj, value)
%             % Specifies the maximum number of nonlinear iteration cycles when nonlinear materials are defined.
%             obj.AddToHistory(['.MaxNumIter "', num2str(value, '%.15g'), '"']);
%         end
        function PrecomputeStationaryCurrentSource(obj, precomputeJfield)
            % Set precomputeJfield to True if the stationary current solver should run before the magnetostatic calculation. The current distribution inside conductive materials will be used as current source for the magnetostatic problem.
            % Please note: If the stationary current problem is not well defined the whole computation will fail.
            obj.AddToHistory(['.PrecomputeStationaryCurrentSource "', num2str(precomputeJfield, '%.15g'), '"']);
        end
        function StoreResultsInCache(obj, storeResults)
            % Activate to store calculation results in the result data cache.
            obj.AddToHistory(['.StoreResultsInCache "', num2str(storeResults, '%.15g'), '"']);
        end
        function TetAdaption(obj, enableAdaption)
            % Enables or disables the adaptive mesh refinement for the tetrahedral mesh method.
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
            % If the solver is to use less than all available threads (cf. UseMaxNumberOfThreads), the desired number can be specified here. The default value ”r;8” reflects the possibility of the modern processors architecture.
            obj.AddToHistory(['.MaxNumberOfThreads "', num2str(nThreads, '%.15g'), '"']);
        end
        function long = Start(obj)
            % Starts the magnetostatic solver with the prescribed settings and the currently active mesh. If no mesh is available, a new mesh will be generated. Returns 0 if the solver run was successful, an error code >0 otherwise.
            long = obj.hMStaticSolver.invoke('Start');
        end
        function long = ContinueAdaption(obj)
            % Starts the magnetostatic solver with the prescribed settings and the currently active mesh. In case of the tetrahedral solver with adaptive mesh refinement, this command will continue the previous adaption run if the corresponding results are available. Otherwise this command is similar to the Start command. Returns 0 if the solver run was successful, an error code >0 otherwise.
            % Functions
            % GetEnergy double
            % Returns  the total magnetostatic energy in the computational domain, computed with the differential energy density definition H*dB in Joule.
            long = obj.hMStaticSolver.invoke('ContinueAdaption');
        end
        function double = GetCoEnergy(obj)
            % Returns  the total magnetostatic co-energy in the computational domain, computed with the differential energy density definition B*dH in Joule.
            double = obj.hMStaticSolver.invoke('GetCoEnergy');
        end
        function double = GetInductanceValue(obj, source1, source2)
            % Retrieves the couple incuctance between given magnetostatic source definitions. The return value represents an element of the inductance matrix in Henry.
            double = obj.hMStaticSolver.invoke('GetInductanceValue', source1, source2);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hMStaticSolver
        history
        bulkmode

    end
end

%% Default Settings
% GridLocation('dual');
% Accuracy('1e-6');
% Preconditioner('ILU');
% MaxNumIter('0');
% CalcInductanceMatrix('0');
% MeshAdaption('0');
% SavePotentialChargeData('0');
% StoreResultsInCache('0');
% UseMaxNumberOfThreads('0');
% MaxNumberOfThreads('8');
% PrecomputeStationaryCurrentSource('0');
% EnableDivergenceCheck('1');

%% Example - Taken from CST documentation and translated to MATLAB.
% mstaticsolver = project.MStaticSolver();
%     mstaticsolver.Reset
%     mstaticsolver.Accuracy('1e-6');
%     mstaticsolver.Preconditioner('ILU');
%     mstaticsolver.CalcInductanceMatrix('0');
%     mstaticsolver.StoreResultsInCache('0');
%     mstaticsolver.MeshAdaption('0');
%     mstaticsolver.GridLocation('Dual');
%
