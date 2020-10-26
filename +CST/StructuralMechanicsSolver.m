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

% This object is used to calculate mechanical problems. The corresponding models are deformed by different types of boundaries. Moreover it is possible to compute deformations and stresses caused by thermal expansion.
classdef StructuralMechanicsSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.StructuralMechanicsSolver object.
        function obj = StructuralMechanicsSolver(project, hProject)
            obj.project = project;
            obj.hStructuralMechanicsSolver = hProject.invoke('StructuralMechanicsSolver');
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
            % Prepend With StructuralMechanicsSolver and append End With
            obj.history = [ 'With StructuralMechanicsSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define StructuralMechanicsSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['StructuralMechanicsSolver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function Accuracy(obj, value)
            % Specifies the desired accuracy value for the mechanical simulation run.
            obj.AddToHistory(['.Accuracy "', num2str(value, '%.15g'), '"']);
        end
        function ReferenceTemperature(obj, temperature)
            % Allows to define the reference temperature value for the thermal expansion with an imported temperature field.
            obj.AddToHistory(['.ReferenceTemperature "', num2str(temperature, '%.15g'), '"']);
        end
        function LSESolverType(obj, solvertype)
            % Specifies which solver is used to solve linear systems of equations.
            % enum solvertyp  meaning
            % "Auto"          choose direct or iterative solver automatically depending on the problem size
            % "Iterative"     use the iterative solver
            % "Direct"        use the direct solver
            %
            % The default setting is "Auto". The solvertype setting is of interest only for the tetrahedral solver method and will be ignored otherwise.
            obj.AddToHistory(['.LSESolverType "', num2str(solvertype, '%.15g'), '"']);
        end
        function Preconditioner(obj, type)
            % Specifies the type of the preconditioner for the solver.
            % type: None
            %       Jacobi
            %       ILU
            obj.AddToHistory(['.Preconditioner "', num2str(type, '%.15g'), '"']);
        end
        function MaxLinIterations(obj, value)
            % The number of iterations performed by the linear solver is automatically limited by a number depending on the desired solver accuracy. This is equivalent to setting the value to "0". If you would like to prescribe a fixed upper limit for number of linear iterations, then specify the corresponding value here.
            obj.AddToHistory(['.MaxLinIterations "', num2str(value, '%.15g'), '"']);
        end
        function MaxLinIter(obj, value)
            % This command is deprecated. Please use MaxLinIterations or MaxNonLinIterations instead.
            obj.AddToHistory(['.MaxLinIter "', num2str(value, '%.15g'), '"']);
        end
        function Method(obj, solvermethod)
            % Specifies the method used by the mechanical solver for discretization and solution.
            % enum solvermethod   meaning
            % "Tetrahedral Mesh"  unstructured grid consisting of tetrahedral elements.
            obj.AddToHistory(['.Method "', num2str(solvermethod, '%.15g'), '"']);
        end
        function NonlinearAccuracy(obj, value)
            % Specifies the desired accuracy value for nonlinear iteration cycles, used e.g. for finite deformations.
            obj.AddToHistory(['.NonlinearAccuracy "', num2str(value, '%.15g'), '"']);
        end
        function MaxNonLinIterations(obj, value)
            % The number of iterations performed by the nonlinear solver is automatically limited by a number depending on the desired nonlinear solver accuracy. This is equivalent to setting the value to "0". If you would like to prescribe a fixed upper limit for number of nonlinear iterations, then specify the corresponding value here.
            obj.AddToHistory(['.MaxNonLinIterations "', num2str(value, '%.15g'), '"']);
        end
        function StoreResultsInCache(obj, flag)
            % If the flag is set to True this method stores results of the solver in the result cache.
            obj.AddToHistory(['.StoreResultsInCache "', num2str(flag, '%.15g'), '"']);
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
        function UseGravity(obj, flag)
            % If the flag is set to "True", the gravitation is taken into account.
            obj.AddToHistory(['.UseGravity "', num2str(flag, '%.15g'), '"']);
        end
        function SetGravityX(obj, component)
            % Sets the x component of the gravitation vector.
            obj.AddToHistory(['.SetGravityX "', num2str(component, '%.15g'), '"']);
        end
        function SetGravityY(obj, component)
            % Sets the y component of the gravitation vector.
            obj.AddToHistory(['.SetGravityY "', num2str(component, '%.15g'), '"']);
        end
        function SetGravityZ(obj, component)
            % Sets the z component of the gravitation vector.
            obj.AddToHistory(['.SetGravityZ "', num2str(component, '%.15g'), '"']);
        end
        function UseNonlinearSolver(obj, flag)
            % Enables or disables the nonlinear solver used for description of large deformations.
            obj.AddToHistory(['.UseNonlinearSolver "', num2str(flag, '%.15g'), '"']);
        end
        function UseRegularization(obj, flag)
            % Enables or disables the regularization used for stabilization of the solution if no fixed displacement conditions have been defined along any cartesian axis.
            obj.AddToHistory(['.UseRegularization "', num2str(flag, '%.15g'), '"']);
        end
        function long = Start(obj)
            % Starts the structural mechanics solver  with the prescribed settings and the currently active mesh. If no mesh is available, a new mesh will be generated. Returns 0 if the solver run was successful, an error code >0 otherwise.
            long = obj.hStructuralMechanicsSolver.invoke('Start');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hStructuralMechanicsSolver
        history
        bulkmode

    end
end

%% Default Settings
% Accuracy(1e-4)
% Preconditioner('Jacobi');
% StoreResultsInCache(0)
% ReferenceTemperature(293)
% TetAdaption(0)
% TetAdaptionAccuracy(0.02)
% TetAdaptionMinCycles(2)
% TetAdaptionMaxCycles(6)
% TetAdaptionRefinementPercentage(10)
% UseMaxNumberOfThreads('0');
% MaxNumberOfThreads('8');

%% Example - Taken from CST documentation and translated to MATLAB.
% structuralmechanicssolver = project.StructuralMechanicsSolver();
%     structuralmechanicssolver.Reset
%     structuralmechanicssolver.Accuracy('1e-4');
%     structuralmechanicssolver.Preconditioner('ILU');
%     structuralmechanicssolver.StoreResultsInCache('0');
%     structuralmechanicssolver.BackgroundTemperature('273.1');
