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

% This object is used to calculate thermal field problems. The corresponding models can be excited by different source types: heat or  temperature sources or as well by importing previously calculated current fields. Thermal surface properties enable the definition of radiation or convection of certain shape faces.
classdef ThermalSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ThermalSolver object.
        function obj = ThermalSolver(project, hProject)
            obj.project = project;
            obj.hThermalSolver = hProject.invoke('ThermalSolver');
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
            % Prepend With ThermalSolver and append End With
            obj.history = [ 'With ThermalSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ThermalSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['ThermalSolver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings of the thermal surface to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function Accuracy(obj, value)
            % Specifies the desired accuracy value for the thermal solver run.
            obj.AddToHistory(['.Accuracy "', num2str(value, '%.15g'), '"']);
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
            default = obj.hThermalSolver.invoke('The');
        end
        function Method(obj, solvermethod)
            % Specifies the method used by the thermal solver for discretization and solution.
            % enum solvermethod   meaning
            % "Hexahedral Mesh"   structured grid consisting of hexahedral elements.
            % "Tetrahedral Mesh"  unstructured grid consisting of tetrahedral elements.
            obj.AddToHistory(['.Method "', num2str(solvermethod, '%.15g'), '"']);
        end
        function StoreResultsInCache(obj, storeResults)
            % Specifies whether or not to store calculation results in the result data cache.
            %
            % NOTE: This method is defined twice in the documentation. The other one has the following description:
            % If the flag is set to True this method stores results of the thermal solver in the result cache.
            obj.AddToHistory(['.StoreResultsInCache "', num2str(storeResults, '%.15g'), '"']);
        end
        function MeshAdaption(obj, enableAdaption)
            % Enables or disables the adaptive mesh refinement for the hexahedral mesh method.
            obj.AddToHistory(['.MeshAdaption "', num2str(enableAdaption, '%.15g'), '"']);
        end
        function AmbientTemperature(obj, value)
            % Specifies the ambient temperature value.
            obj.AddToHistory(['.AmbientTemperature "', num2str(value, '%.15g'), '"']);
        end
        function ConsiderBioheat(obj, flag)
            % If the flag is set to True biological material properties are taken into account in a thermal simulation.
            obj.AddToHistory(['.ConsiderBioheat "', num2str(flag, '%.15g'), '"']);
        end
        function BloodTemperature(obj, value)
            % Specifies the temperature value of blood. This setting affects materials with metabolic heat or blood perfusion settings. It only affects the simulation, if ConsiderBioheat was set to true.
            obj.AddToHistory(['.BloodTemperature "', num2str(value, '%.15g'), '"']);
        end
        function NonlinearAccuracy(obj, value)
            % Specifies the desired accuracy value for nonlinear iteration cycles, used e.g. for radiation effects.
            obj.AddToHistory(['.NonlinearAccuracy "', num2str(value, '%.15g'), '"']);
        end
        function PTCDefault(obj, ptctype)
            % Specifies how ptc domains without source definition and thermal boundary behave:
            % enum ptctype    meaning
            % "Floating"      treat all PTC domains as floating temperatures
            % "Ambient"       treat all PTC domains with the fixed ambient temperature
            obj.AddToHistory(['.PTCDefault "', num2str(ptctype, '%.15g'), '"']);
        end
        function SetTimeMonitor0DAutoLabel(obj, bFlag)
            % This flag concerns only the behavior of the dialog box for monitors at points. It specifies whether or not the monitor name is adapted automatically to the settings made in the dialog box. This command will have no influence on the monitor name specified via the VBA command.
            obj.AddToHistory(['.SetTimeMonitor0DAutoLabel "', num2str(bFlag, '%.15g'), '"']);
        end
%         function StoreResultsInCache(obj, flag)
%             % If the flag is set to True this method stores results of the thermal solver in the result cache.
%             obj.AddToHistory(['.StoreResultsInCache "', num2str(flag, '%.15g'), '"']);
%         end
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
        function MaxLinIter(obj, value)
            % The number of iterations performed by the linear solver is automatically limited by a number depending on the desired solver accuracy. This is equivalent to setting the value to "0". If you would like to prescribe a fixed upper limit for number of linear iterations, then specify the corresponding value here.
            obj.AddToHistory(['.MaxLinIter "', num2str(value, '%.15g'), '"']);
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
        function int = Start(obj)
            % Starts the thermal simulation with the current settings and returns 0 if the calculation is successfully finished and an error code >0 otherwise.
            int = obj.hThermalSolver.invoke('Start');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hThermalSolver
        history
        bulkmode

    end
end

%% Default Settings
% Accuracy('1e-6');
% MaxLinIter('0');
% NonlinearAccuracy('1e-6');
% Preconditioner('ILU');
% StoreResultsInCache('0');
% AmbientTemperature('293.15', 'Kelvin');
% PTCDefault('Ambient');
% ConsiderBioheat('1');
% BloodTemperature('37.0');
% Method('Tetrahedral Mesh');
% MeshAdaption('1');
% LSESolverType('Auto');
% TetSolverOrder('2');
% CalcThermalConductanceMatrix('0');
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
% thermalsolver = project.ThermalSolver();
%     thermalsolver.Reset
%     thermalsolver.Accuracy('1e-4');
%     thermalsolver.NonlinearAccuracy('1e-3');
%     thermalsolver.Preconditioner('ILU');
%     thermalsolver.StoreResultsInCache('0');
%     thermalsolver.AmbientTemperature('273.1');
