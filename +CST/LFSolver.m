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

% This object is used to define the LF Frequency Domain (MQS or Fullwave) solver settings.
classdef LFSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.LFSolver object.
        function obj = LFSolver(project, hProject)
            obj.project = project;
            obj.hLFSolver = hProject.invoke('LFSolver');
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
            % Prepend With LFSolver and append End With
            obj.history = [ 'With LFSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define LFSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['LFSolver', command]);
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
        function EquationType(obj, equationtype)
            % Specifies the used equation type.
            % enum equationtype       meaning
            % "Electroquasistatic"    The change of magnetic flux is neglected in Faraday's law of induction. This option is currently only available for the Tetrahedal mesh type.
            % "Magnetoquasistatic"    The electric displacement current will be neglected in ampere's law.
            % "Fullwave"              No time dependencies are neglected, but this option is usually the most time consuming one.
            obj.AddToHistory(['.EquationType "', num2str(equationtype, '%.15g'), '"']);
        end
        function LSESolverType(obj, solvertype)
            % Specifies which solver is used to solve linear systems of equations.
            % enum solvertype meaning
            % "Auto"          choose direct or iterative solver automatically depending on the problem size
            % "Iterative"     use the iterative solver
            % "Direct"        use the direct solver
            % "Accelerated"   use the accelerated solver
            obj.AddToHistory(['.LSESolverType "', num2str(solvertype, '%.15g'), '"']);
        end
        function default = The(obj)
            default = obj.hLFSolver.invoke('The');
        end
        function MaxLinIter(obj, value)
            % The number of iterations performed by the linear solver is automatically limited by a number depending on the desired solver accuracy. This is equivalent to setting the value to "0". If you would like to prescribe a fixed upper limit for number of linear iterations, then specify the corresponding value here.
            obj.AddToHistory(['.MaxLinIter "', num2str(value, '%.15g'), '"']);
        end
        function MeshAdaption(obj, enableAdaption)
            % Enables or disables the adaptive mesh refinement for the hexahedral mesh method.
            obj.AddToHistory(['.MeshAdaption "', num2str(enableAdaption, '%.15g'), '"']);
        end
        function Method(obj, solvermethod)
            % Specifies the method used by the LF frequency domain solver for discretization and solution.
            % enum solvermethod   meaning
            % "Hexahedral Mesh"   structured grid consisting of hexahedral elements.
            % "Tetrahedral Mesh"  unstructured grid consisting of tetrahedral elements.
            obj.AddToHistory(['.Method "', num2str(solvermethod, '%.15g'), '"']);
        end
        function PECDefault(obj, pectype)
            % Specifies how pec domains without source definition and electric boundary behave:
            % enum pectype    meaning
            % "Grounded"      treat all PEC domains as fixed potentials (default)
            % "Floating"      treat all PEC domains as floating potentialsr (Supported only by electroquasistatic solver.)
            obj.AddToHistory(['.PECDefault "', num2str(pectype, '%.15g'), '"']);
        end
        function ResetFrequencySettings(obj)
            % Resets all frequency settings.
            obj.AddToHistory(['.ResetFrequencySettings']);
        end
        function StoreResultsInCache(obj, storeResults)
            % Activate to store calculation results in the result data cache.
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
        function SetTreeCotreeGauging(obj, lfstabilization)
            % This settings is relevant for the EquationType "Magnetoquasistatic" only. If activated a special reduction scheme is used, which reduces the number of unknowns and leads to a better convergence of the solving process. Since the linear solver is very memory consuming in conjunction with this option, it is advisable to use it only for small- and medium-sized problems (in terms of degrees of freedom).
            obj.AddToHistory(['.SetTreeCotreeGauging "', num2str(lfstabilization, '%.15g'), '"']);
        end
        function UseDistributedComputing(obj, useDC)
            % Enables or disables distributed computing.
            obj.AddToHistory(['.UseDistributedComputing "', num2str(useDC, '%.15g'), '"']);
        end
        function UseFullWaveCalculation(obj, useFullWave)
            % Activates the fullwave matrix setup instead of the vectorpotential matrix setup. This setting is necessary in order to simulate problems where displacement currents are present.
            obj.AddToHistory(['.UseFullWaveCalculation "', num2str(useFullWave, '%.15g'), '"']);
        end
        function UseMaxNumberOfThreads(obj, useMaxThreads)
            % By default (useMaxThreads = False), the solver is forced to employ a particular number of threads that is defined on the basis of the current processor’s architecture and the number of the available parallel licenses. If activated (useMaxThreads = True), the solver can be forced to use less than all available threads (see MaxNumberOfThreads).
            obj.AddToHistory(['.UseMaxNumberOfThreads "', num2str(useMaxThreads, '%.15g'), '"']);
        end
        function MaxNumberOfThreads(obj, nThreads)
            % If the solver is to use less than all available threads (cf. UseMaxNumberOfThreads), the desired number can be specified here. The default value "r;8" reflects the possibility of the modern processors architecture.
            obj.AddToHistory(['.MaxNumberOfThreads "', num2str(nThreads, '%.15g'), '"']);
        end
        function ValueScaling(obj, scaling)
            % This method allows to define the way in which low-frequency harmonic current or field sources are specified. If RMS is chosen, then all input values are considered to be the root-mean-square values. The Peak option can be used to specify the amplitude of sources directly.
            % scaling: 'RMS'
            %          'Peak'
            obj.AddToHistory(['.ValueScaling "', num2str(scaling, '%.15g'), '"']);
        end
        function long = Start(obj)
            % Starts the LF frequency domain solver with the prescribed settings and the currently active mesh. If no mesh is available, a new mesh will be generated. Returns 0 if the solver run was successful, an error code >0 otherwise.
            long = obj.hLFSolver.invoke('Start');
        end
        function long = ContinueAdaption(obj)
            % Starts the LF frequency domain solver with the prescribed settings and the currently active mesh. In case of the tetrahedral solver with adaptive mesh refinement, this command will continue the previous adaption run if the corresponding results are available. Otherwise this command is similar to the Start command. Returns 0 if the solver run was successful, an error code >0 otherwise.
            long = obj.hLFSolver.invoke('ContinueAdaption');
        end
        %% Functions
        function double = GetCalculationFrequency(obj, number)
            % Returns the calculation frequency at the given index number (0,1,2....NumberOfFrequencies-1).
            double = obj.hLFSolver.invoke('GetCalculationFrequency', number);
        end
        function double = GetCoilVoltageRe(obj, frequency, coilname)
            % Get the real part of the voltage value in Volt being measured at the frequency frequency on the coil with the name coilname .
            double = obj.hLFSolver.invoke('GetCoilVoltageRe', frequency, coilname);
        end
        function double = GetCoilVoltageIm(obj, frequency, coilname)
            % Get the imaginary part of the voltage value in Volt being measured at the frequency frequency on the coil with the name coilname .
            double = obj.hLFSolver.invoke('GetCoilVoltageIm', frequency, coilname);
        end
        function filename = GetDatabaseResultDirName(obj, frequency)
            % Get the result database directory for a certain run, which is accessed by its frequency (given as string or double value).
            filename = obj.hLFSolver.invoke('GetDatabaseResultDirName', frequency);
        end
        function str = GetFirstFrequencyWithResult(obj, result_key)
            % Returns the first frequency from a list (sorted by double value) for which a result with the specified result_key exists. For example, result_key can be "Accuracy" or "Total Losses" or any other key which exists in the result data base. If result_key is empty, i.e. result_key="", this routine returns the first frequency for which any results are available.
            % If no such frequency is found, the return value will be "0.0".
            % The data type of the returned value is a string, because it may contain the name of a parameter. To get the corresponding double value of the returned frequency, use Eval(return_value).
            str = obj.hLFSolver.invoke('GetFirstFrequencyWithResult', result_key);
        end
        function str = GetNextFrequencyWithResult(obj)
            % Requires an initialized list (sorted by double value) of frequencies for which certain results exist. This list is initialized by calling GetFirstFrequencyWithResult(...).
            % This function increases the "frequency counter" by one and returns the next frequency from this sorted list. The data type of the returned value is a string, because it may contain the name of a parameter. To get the corresponding double value of the returned frequency, use Eval(return_value).
            % If no further frequency with appropriate results is found, the return value will be "0.0".
            str = obj.hLFSolver.invoke('GetNextFrequencyWithResult');
        end
        function int = GetNumberOfFrequenciesWithResult(obj, result_key)
            % Returns the number of frequencies for which a result with the specified result_key exists. For example, result_key can be "Accuracy" or "Total Losses" or any other key which exists in the result data base. If result_key is empty, i.e. result_key="", this routine returns the number of frequencies for which any results are available.
            int = obj.hLFSolver.invoke('GetNumberOfFrequenciesWithResult', result_key);
        end
        function int = GetNumberOfFrequencies(obj)
            % Returns the total number of defined frequencies in the LF Calculation Frequency dialog box.
            int = obj.hLFSolver.invoke('GetNumberOfFrequencies');
        end
        function double = GetEnergy(obj, frequency)
            % Returns the total electromagnetic energy at the frequency frequency.
            double = obj.hLFSolver.invoke('GetEnergy', frequency);
        end
        function GetFrequencyIDFromString(obj, frequency)
            % If the frequency passed as string to this routine has ever been used in this project, it has automatically been assigned to a unique number, a so-called id. This number will be returned and can be used as input for further functions. The frequency string can also be a parameter of the project. If the frequency string is unknown, the value -1 will be returned.
            obj.AddToHistory(['.GetFrequencyIDFromString "', num2str(frequency, '%.15g'), '"']);
        end
        function double = GetTotalLosses(obj, frequency)
            % Returns the total loss power in Watt at the frequency frequency.
            double = obj.hLFSolver.invoke('GetTotalLosses', frequency);
        end
        function double = GetTotalSurfaceLosses(obj, frequency)
            % Returns the total surface loss power in Watt at the frequency frequency. This value is calculated from all solids of type lossy metal.
            double = obj.hLFSolver.invoke('GetTotalSurfaceLosses', frequency);
        end
        function double = GetVoltageSourceCurrentRe(obj, frequency, voltagesourcename)
            % Get the real part of the current on a voltage source named voltagesourcename in Ampere at the frequency frequency.
            double = obj.hLFSolver.invoke('GetVoltageSourceCurrentRe', frequency, voltagesourcename);
        end
        function double = GetVoltageSourceCurrentIm(obj, frequency, voltagesourcename)
            % Get the imaginary part of the current on a voltage source named  voltagesourcename in Ampere at the frequency frequency.
            double = obj.hLFSolver.invoke('GetVoltageSourceCurrentIm', frequency, voltagesourcename);
        end
        function double = GetVoltageSourceImpedanceRe(obj, frequency, voltagesourcename)
            % Get the real part of the impedance on a voltage source named voltagesourcename in Ohm at the frequency frequency.
            double = obj.hLFSolver.invoke('GetVoltageSourceImpedanceRe', frequency, voltagesourcename);
        end
        function double = GetVoltageSourceImpedanceIm(obj, frequency, voltagesourcename)
            % Get the imaginary part of the impedance on a voltage source named voltagesourcename in Ohm at the frequency frequency.
            double = obj.hLFSolver.invoke('GetVoltageSourceImpedanceIm', frequency, voltagesourcename);
        end
        %% CST 2014 Functions.
        function SetLFPreconditionerAcceleration(obj, precondtype)
            % Specifies the preconditioner used to solve linear systems of equations. Available options are:
            % precondtype (enum ) meaning
            % "Auto"              The preconditioner type is chosen automatically. Currently the Low Memory type will be used by default, but this might change with future versions.
            % "Accelerated"       A preconditioner which is suited well for structures with high mesh- and material-ratios. This method is more memory consuming, but might converge in situations where the Low Memory type does not converge.
            % "Low Memory"        This preconditioner type is very memory efficient and converges if mesh- and material- ratios are not very high.
            obj.AddToHistory(['.SetLFPreconditionerAcceleration "', num2str(precondtype, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hLFSolver
        history
        bulkmode

    end
end

%% Default Settings
% Accuracy('1e-6');
% Preconditioner('ILU');
% UseFullWaveCalculation('0');
% LSESolverType('Auto');
% MeshAdaption('0');
% StoreResultsInCache('0');
% ValueScaling('Peak');
% UseMaxNumberOfThreads('0');
% MaxNumberOfThreads('8');

%% Example - Taken from CST documentation and translated to MATLAB.
% lfsolver = project.LFSolver();
%     lfsolver.Reset();
%     lfsolver.Accuracy('1e-6');
%     lfsolver.StoreResultsInCache('0');
%     lfsolver.Preconditioner('ILU');
%     lfsolver.MeshAdaption('0');
%     lfsolver.UseFullWaveCalculation('0');
%     lfsolver.LSESolverType('Auto');
