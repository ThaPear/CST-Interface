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

% This is the object that controls the time-harmonic high frequency solver and its methods, as well as the integral equation solver (see also IESolver Object). Every setting concerning a frequency domain or integral equation solver simulation run may be defined with this object. Mesh and solver method can be chosen by calling SetMethod. Use the Start command to run the solver.
classdef FDSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.FDSolver object.
        function obj = FDSolver(project, hProject)
            obj.project = project;
            obj.hFDSolver = hProject.invoke('FDSolver');
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
            % Prepend With FDSolver and append End With
            obj.history = [ 'With FDSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define FDSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['FDSolver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        %% Frequency Domain Solver General
        function Reset(obj)
            % Resets all previously made settings concerning the solver to the default values.
            obj.AddToHistory(['.Reset']);
        end
        function int = Start(obj)
            % Starts the solver with the current settings and returns 1 if the calculation is successfully finished and 0 if it failed.
            int = obj.hFDSolver.invoke('Start');
        end
        function AcceleratedRestart(obj, flag)
            % If activated, the frequency domain solver with hexahedral or tetrahedral mesh stores a subset of the results from frequency samples calculated so far in order to reuse this information for an accelerated recalculation of additional frequency samples in subsequent solver runs. Since a direct equation system solver does not profit from a good initial guess to the solution, this mainly applies to the iterative solver. However, you may try to calculate some frequency samples using the direct solver, and continue with the iterative solver, thereby taking into account solutions from the direct solver to speed up the simulation.
            obj.AddToHistory(['.AcceleratedRestart "', num2str(flag, '%.15g'), '"']);
        end
        function AccuracyTet(obj, value)
            % Specifies the desired accuracy for the tetrahedral frequency domain solver in terms of the relative residual norm of the linear equation system solver. The accuracy value may be chosen from the range 1e-3 down to 1e-12, where 1e-12 correspond to the highest accuracy level.
            obj.AddToHistory(['.AccuracyTet "', num2str(value, '%.15g'), '"']);
        end
        function AccuracySrf(obj, value)
            % Specifies the desired accuracy for the tetrahedral frequency domain solver in terms of the relative residual norm of the linear equation system solver. The accuracy value may be chosen from the range 1e-3 down to 1e-12, where 1e-12 correspond to the highest accuracy level.
            obj.AddToHistory(['.AccuracySrf "', num2str(value, '%.15g'), '"']);
        end
        function AccuracyHex(obj, value)
            % Specifies the desired accuracy for the hexahedral frequency domain solver in terms of the relative residual norm of the linear equation system solver. The accuracy value may be chosen from the range 1e-3 down to 1e-12, where 1e-12 correspond to the highest accuracy level.
            obj.AddToHistory(['.AccuracyHex "', num2str(value, '%.15g'), '"']);
        end
        function AccuracyROM(obj, value)
            % Specifies the desired accuracy of the reduced order model (ROM) for the tetrahedral frequency domain solver with fast reduced order model sweep. The accuracy value may be chosen from the range 1e-3 down to 1e-12, where 1e-12 correspond to the highest accuracy level.
            obj.AddToHistory(['.AccuracyROM "', num2str(value, '%.15g'), '"']);
        end
        function StoreAllResults(obj, flag)
            % If this method is activated (flag = True), field results are stored at each frequency sample. This comprises electric and magnetic fields, as well as electric and magnetic flux densities.
            obj.AddToHistory(['.StoreAllResults "', num2str(flag, '%.15g'), '"']);
        end
        function StoreSolutionCoefficients(obj, flag)
            % If this method is activated (flag = True), solution coefficients are stored on disk at each frequency sample and at each excitation.
            obj.AddToHistory(['.StoreSolutionCoefficients "', num2str(flag, '%.15g'), '"']);
        end
        function CreateLegacy1DSignals(obj, flag)
            % Call this method with (flag = True) only if required: some result templates from previous versions do not operate on the complex 1D results directly, but expect results for amplitude, phase, and dB signals. This option is off by default for new projects due to performance reasons.
            obj.AddToHistory(['.CreateLegacy1DSignals "', num2str(flag, '%.15g'), '"']);
        end
        function SetOpenBCTypeHex(obj, type)
            % Chooses how the open boundary is realized in the frequency domain solver with hexahedral mesh. The default is PML. For electrically relatively small models with the open boundaries defined next to vacuum, the first order freespace open boundary condition (type = "FreespaceSIBC") might be an alternative to save memory and to speed up the iterative solver's convergence.
            % type: 'Default'
            %       'PML'
            %       'FreespaceSIBC'
            obj.AddToHistory(['.SetOpenBCTypeHex "', num2str(type, '%.15g'), '"']);
        end
        function SetOpenBCTypeTet(obj, type)
            % Chooses how the open boundary is realized in the frequency domain solver with tetrahedral mesh, unless the problem has unit cell boundary conditions, for which the open boundary is realized by a Floquet mode "port."
            % The default is the standard impedance boundary condition (SIBC), which shows low artificial reflection for plane waves that impinge on the open boundary perpendicularly (the field solution of course is not necessarily a plane wave, but might be considered as the superposition of various plane waves at different angles.) For "plane wave" angles closer to grazing incidence, the PML provides lower artificial reflection, but at the cost of higher memory usage and more demanding linear equation systems, which require more time to solve.
            % type: 'Default'
            %       'PML'
            %       'SIBC'
            obj.AddToHistory(['.SetOpenBCTypeTet "', num2str(type, '%.15g'), '"']);
        end
        function AddMonitorSamples(obj, flag)
            % If this method is activated (flag = True), a solver run is performed for all monitor frequencies defined, independently of the number of other (non-monitor) frequency samples, which are specified using the FrequencySamples and AddSampleInterval methods. Please note that the total number of samples will be increased automatically in order to take into account the monitor definitions, if necessary. Otherwise (flag = False), monitors will not be calculated.
            obj.AddToHistory(['.AddMonitorSamples "', num2str(flag, '%.15g'), '"']);
        end
        function FrequencySamples(obj, nFSamples)
            % Specifies the (maximum) number of frequency samples that should be calculated in a S-parameter frequency sweep. The samples are placed adaptively in the current global frequency interval. The method AddSampleInterval allows to specify the sampling strategy more precisely.
            obj.AddToHistory(['.FrequencySamples "', num2str(nFSamples, '%.15g'), '"']);
        end
        function MeshAdaptionHex(obj, flag)
            % Activate the broadband, expert-system based adaptive mesh refinement for the hexahedral frequency domain solver.
            obj.AddToHistory(['.MeshAdaptionHex "', num2str(flag, '%.15g'), '"']);
        end
        function MeshAdaptionTet(obj, flag)
            % Activate the adaptive mesh refinement for the tetrahedral frequency domain solver. The adaptation frequency samples are defined by using the AddSampleInterval method with adaptation set to True.
            obj.AddToHistory(['.MeshAdaptionTet "', num2str(flag, '%.15g'), '"']);
        end
        function ResetSampleIntervals(obj, key)
            % Removes sampling interval definitions according to the key . If used together with AddSampleInterval, a set of sampling intervals can be re-defined, for instance all adaptation frequencies.
            % (2019) The key "infinite" describes automatic sampling interval definitions with an unspecified number of samples.
            % key: 'all'
            %      'adaptation'
            %      'single'
            %      'inactive'
            %      (2019) 'infinite'
            obj.AddToHistory(['.ResetSampleIntervals "', num2str(key, '%.15g'), '"']);
        end
        function UseHelmholtzEquation(obj, flag)
            % If activated the Helmholtz equation is used when running the frequency domain solver with hexahedral mesh. This might lead to a faster convergence of the solver, especially for low frequency problems.
            obj.AddToHistory(['.UseHelmholtzEquation "', num2str(flag, '%.15g'), '"']);
        end
        function AddSampleInterval(obj, min, max, samples, key, adaptation)
            % Specifies a customized frequency interval (min to max) as well as the corresponding number of frequency samples for which calculations will be performed.
            % Depending on the key value, the samples will either be placed adaptively, or equidistantly, or with logarithmic spacing into the interval. A "Single" frequency point is defined by setting lower and upper frequency limit to the same value, or by omitting either the lower or the upper frequency. The number of samples is One for single samples, of course.
            % The parameters min and max may be values as well as strings. You may pass an empty string "" as an argument. For equidistant, automatic and logarithmic sampling, if min = "" or max = "" this will be replaced by the corresponding global limit of the frequency range.
            % When the number of Samples is not defined (empty string "") for an "Automatic" sampling interval, the solver stops calculating additional samples as soon as the S-parameter sweep convergence criterion is satisfied.
            % The adaptation indicates whether or not the frequency samples should be used for the sequential adaptive tetrahedral mesh refinement.
            % If the lower limit of the frequency interval evaluates to Zero, the samples at frequency zero will be ignored for "Equidistant" sampling intervals, and the lower limit will be replaced with some suitable value for "Automatic" and "Logarithmic" sampling interval definitions.
            % key,: 'Automatic'
            %       'Single'
            %       'Equidistant'
            %       'Logarithmic'
            obj.AddToHistory(['.AddSampleInterval "', num2str(min, '%.15g'), '", '...
                                                 '"', num2str(max, '%.15g'), '", '...
                                                 '"', num2str(samples, '%.15g'), '", '...
                                                 '"', num2str(key, '%.15g'), '", '...
                                                 '"', num2str(adaptation, '%.15g'), '"']);
        end
        function AddInactiveSampleInterval(obj, min, max, samples, key, adaptation)
            % Specifies an inactive customized frequency interval. The parameter are the same as for AddSampleInterval.
            % key,: 'Automatic'
            %       'Equidistant'
            obj.AddToHistory(['.AddInactiveSampleInterval "', num2str(min, '%.15g'), '", '...
                                                         '"', num2str(max, '%.15g'), '", '...
                                                         '"', num2str(samples, '%.15g'), '", '...
                                                         '"', num2str(key, '%.15g'), '", '...
                                                         '"', num2str(adaptation, '%.15g'), '"']);
        end
        function MaxIterations(obj, nIter)
            % Specifies the maximum number of linear equation system solver iterations the solver will use for calculating the electromagnetic field at a single frequency sample. This applies only if LimitIterations has been activated and if the iterative solver is used.
            obj.AddToHistory(['.MaxIterations "', num2str(nIter, '%.15g'), '"']);
        end
        function LimitIterations(obj, flag)
            % If flag = True the solver stops if the maximum number of iterations given by the MaxIterations method is reached.
            obj.AddToHistory(['.LimitIterations "', num2str(flag, '%.15g'), '"']);
        end
        function ModesOnly(obj, flag)
            % Calculate only the port modes when using the frequency domain solver.
            obj.AddToHistory(['.ModesOnly "', num2str(flag, '%.15g'), '"']);
        end
        function SetShieldAllPorts(obj, flag)
            % The boundary of all waveguide ports is treated as a perfectly shielding (PEC) wire frame when calling this method with flag = True.
            obj.AddToHistory(['.SetShieldAllPorts "', num2str(flag, '%.15g'), '"']);
        end
        function SetPortMeshMatches3DMeshTet(obj, flag)
            % The option SetPortMeshMatches3DMeshTet only applies to the tetrahedral mesh and is disabled by default. The waveguide port mode solver operates on the planar mesh of the waveguide port and applies an adaptive port mesh refinement for this mesh. By default, the port mesh is separated from the volumetric mesh, and an overlap calculation is used to map the port mode solution onto the boundary of the volumetric mesh. However, if you call SetPortMeshMatches3DMeshTet with flag = True, the port mode solver's mesh adaptation directly refines the surface mesh of the volumetric mesh, so that no overlap calculation is required. It is recommended to let the port mesh match the 3D mesh whenever the overlap calculation fails due to geometric tolerance problems.
            obj.AddToHistory(['.SetPortMeshMatches3DMeshTet "', num2str(flag, '%.15g'), '"']);
        end
        function SetAllowROMPortModeSolver(obj, flag)
            % Presently may affect the frequency domain solver with tetrahedral mesh and fast reduced order model sweep only. The broadband reduced order model calculates port mode data for the complete frequency range and applies a technique to track modes (the sorting of waveguide port modes by propagation constant may lead to port modes changing order at some point in the frequency range.) The fast reduced order model sweep requires a broadband representation of the port modes for inhomogeneously filled waveguide ports (mode types other than TEM, TE, or TM.) Losses will be ignored if the frequency domain solver with tetrahedral mesh and fast reduced order model sweep chooses to use the broadband reduced order model for port modes. Deactivate this option only if you want the waveguide port modes of any type other than TEM, TE or TM to be approximated by the modes at some fixed frequency throughout the whole frequency range.
            obj.AddToHistory(['.SetAllowROMPortModeSolver "', num2str(flag, '%.15g'), '"']);
        end
        function SetAllowDiscretePortSolver(obj, flag)
            % Presently may affect the frequency domain solver with tetrahedral mesh and general purpose sweep only. With the option enabled, a numerical solution will be calculated for discrete face ports. This allows to handle discrete face ports with arbitrary shape with improved accuracy, very similar to the approach taken for rectangular, cylinder barrel, and coaxial face ports. Please note that discrete ports need to be defined in between two good conductors, like PEC and lossy metal materials.
            obj.AddToHistory(['.SetAllowDiscretePortSolver "', num2str(flag, '%.15g'), '"']);
        end
        function SetUseROMPortModeSolverTet(obj, general, fast)
            % Similar to SetAllowROMPortModeSolver, but forcing the usage of the port ROM for either the general purpose sweep or the fast reduced order model sweep.
            obj.AddToHistory(['.SetUseROMPortModeSolverTet "', num2str(general, '%.15g'), '", '...
                                                          '"', num2str(fast, '%.15g'), '"']);
        end
        function EnableNativeSingleEnded(obj, flag)
            % This setting affects the frequency domain solver with tetrahedral mesh and general purpose frequency sweep. With this option the "single-ended port" yields S-parameters and fields by directly exciting the single-ended modes. Under these circumstances the phase deembedding is not supported. The fast reduced order model broadband sweep with tetrahedral mesh always uses this approach.
            obj.AddToHistory(['.EnableNativeSingleEnded "', num2str(flag, '%.15g'), '"']);
        end
        function UseDeembeddedFields(obj, flag)
            % This setting affects the frequency domain solver with tetrahedral mesh and general purpose frequency sweep. With this option enabled, the deembedded ports will be excited with the already shifted modes. Otherwise, the deembedding operation is performed on the S-parameter matrix only.
            obj.AddToHistory(['.UseDeembeddedFields "', num2str(flag, '%.15g'), '"']);
        end
        function FreqDistAdaptMode(obj, key)
            % This option is considered by the frequency domain solver with tetrahedral mesh only. It allows selecting which strategy will be followed when the option "Distribute excitation calculation up to" is enabled in the "Distributed computing (DC) frame". Selecting "Local" adaptation frequencies will be calculated locally, selecting "As_A_Whole" all adaptation frequencies will be transferred to a single remote computer and selecting "Distributed" adaptation frequencies will be distributed separately over the remote computers. In the first iteration over the broadband mesh adaptation, the adaptation frequencies are transferred as a whole even if "Distributed" has been selected.
            % key: 'Local'
            %      'As_A_Whole'
            %      'Distributed'
            obj.AddToHistory(['.FreqDistAdaptMode "', num2str(key, '%.15g'), '"']);
        end
        function SetPreferLeanOutput(obj, flag)
            % This option is considered by the frequency domain solver with tetrahedral mesh only. It allows to save some disc space and simulation time, especially in case of simulation runs with many excitations. Call with flag = True to disable the output of the linear equation system solver's relative residual curves.
            obj.AddToHistory(['.SetPreferLeanOutput "', num2str(flag, '%.15g'), '"']);
        end
        function SetUseImpLineImpedanceAsReference(obj, flag)
            % Call this method with flag = True to define impedances calculated by impedance lines as the post-processing reference impedance for all port modes to which they are applied. Must be called before the solver run. The impedance lines' impedances will replace the usual line impedance for TEM and QTEM modes, and replace the wave impedances of other modes. The port mode information which is displayed when viewing a port mode is not affected.
            obj.AddToHistory(['.SetUseImpLineImpedanceAsReference "', num2str(flag, '%.15g'), '"']);
        end
        function SetUseOrientPortWithMask(obj, flag)
            % Call this method with flag = True to switch to an alternative algorithm for the mode orientation in waveguide ports. Caution: this algorithm is not compatible with the standard one and the corresponding algorithm for hex-based solvers.
            obj.AddToHistory(['.SetUseOrientPortWithMask "', num2str(flag, '%.15g'), '"']);
        end
        function ConsiderPortLossesTet(obj, flag)
            % Allows to define whether the port mode solver for the frequency domain solver with tetrahedral mesh considers lossy dielectrics and lossy metal or not. If flag = False, the imaginary part of both the complex permeability and the complex permittivity will be set to zero, and lossy metal will be treated as PEC in the port mode solver.
            obj.AddToHistory(['.ConsiderPortLossesTet "', num2str(flag, '%.15g'), '"']);
        end
        function SetStopSweepIfCriterionMet(obj, flag)
            % Activates (flag = "True") or deactivates (flag = "False") the broadband 1D result frequency sweep convergence check. This setting applies when using the general purpose broadband frequency sweep, and 1D results such as S-parameters, or field probes.  The number of frequency samples needed for a broadband simulation by the solver usually decreases if the check is activated, since the solver stops calculating additional frequency samples as soon as the convergence criterion is reached, which, in addition, can be influenced by the SweepErrorChecks and SweepMinimumSamples methods.
            obj.AddToHistory(['.SetStopSweepIfCriterionMet "', num2str(flag, '%.15g'), '"']);
        end
        function SetSweepThreshold(obj, type, threshold)
            % Sets the threshold for the estimated interpolation error of the S-parameters or field probes. This setting applies when using the general purpose broadband frequency sweep.
            % type,: 'S-Parameters'
            %        'Probes'
            obj.AddToHistory(['.SetSweepThreshold "', num2str(type, '%.15g'), '", '...
                                                 '"', num2str(threshold, '%.15g'), '"']);
        end
        function UseSweepThreshold(obj, type, flag)
            % If the flag is False, the estimated interpolation error of the S-parameters or field probes is ignored for the convergence check. This setting applies when using the general purpose broadband frequency sweep, and allows for instance to stop the broadband sweep when the S-parameters are converged, no matter how accurate the probe results are.
            % type,: 'S-Parameters'
            %        'Probes'
            obj.AddToHistory(['.UseSweepThreshold "', num2str(type, '%.15g'), '", '...
                                                 '"', num2str(flag, '%.15g'), '"']);
        end
        function Type(obj, key)
            % Chooses the linear equation system solver type to be used. For the integral equation solver the matrix approximation is chosen and in addition  "IterativeMoM" (ACA) and "IterativeEnhanced" are available.
            % key: 'Auto'
            %      'Iterative'
            %      'Direct'
            obj.AddToHistory(['.Type "', num2str(key, '%.15g'), '"']);
        end
        function StoreResultsInCache(obj, flag)
            % Stores results of the solver in the result cache. For each parameter combination in a parameter sweep, for instance, a full backup of the results is stored in a sub folder like {Projectname}/Result/Cache/run000001.
            obj.AddToHistory(['.StoreResultsInCache "', num2str(flag, '%.15g'), '"']);
        end
        function SetMethod(obj, mesh, sweep)
            % Allows to change the method used in the frequency domain solver as in the solver's dialog box. The type of mesh will be changed to "Hexahedral", "Tetrahedral", with either the "General purpose" or the "Fast reduced order model" broadband sweep, or "Discrete samples only" to disable the calculation of broadband results. Confer the frequency domain and integral equation solver overview in the online manual for details.
            % You may pass empty strings "" for either mesh or sweep to retain the values from a previous call to this method.
            % Use "Surface Mesh" with "General purpose" sweep to activate the integral equation solver.
            % mesh ,: 'Hexahedral'
            %         'Tetrahedral'
            %         'Surface'
            % sweep: 'General purpose'
            %        'Fast reduced order model'
            %        'Discrete samples only'
            obj.AddToHistory(['.SetMethod "', num2str(mesh, '%.15g'), '", '...
                                         '"', num2str(sweep, '%.15g'), '"']);
        end
        function AutoNormImpedance(obj, flag)
            % S-Parameters are always normalized to a reference impedance. You may either select to norm them to the calculated impedance of the stimulation port or you may specify a number of your choice.  If flag is False the reference impedance will be the calculated impedance of the input port.
            obj.AddToHistory(['.AutoNormImpedance "', num2str(flag, '%.15g'), '"']);
        end
        function NormingImpedance(obj, value)
            % Specifies the impedance to be used as reference impedance for the scattering parameters. This setting will only be considered if AutoNormImpedance is set to True.
            obj.AddToHistory(['.NormingImpedance "', num2str(value, '%.15g'), '"']);
        end
        function Stimulation(obj, port, mode)
            % Selects the source type to be used for excitation, such as port and mode for waveguide ports.
            % The parameter port and mode may have one of the following values:
            % "All"
            % All ports and modes will be excited, one at a time. This eventually excludes Floquet ports for unit cell calculations.
            % "All+Floquet"
            % All ports and modes will be excited, one at a time. This includes Floquet ports for unit cell calculations.
            % "Plane Wave"
            % A plane wave will be excited. mode needs to be set to "1".
            % "List"
            % A list of excitations is specified. port and mode then need to be set to "List".
            % int port/mode
            % The port and mode number to be used for excitation.
            % "CMA"
            % Supported by integral equation solver and multilayer solver. Performs a characteristic mode analysis.
            obj.AddToHistory(['.Stimulation "', num2str(port, '%.15g'), '", '...
                                           '"', num2str(mode, '%.15g'), '"']);
        end
        function SweepErrorChecks(obj, nChecks)
            % Determines how many consecutive times the estimated S-parameter or probe interpolation error has to meet the given threshold (see SetSweepThreshold) during a broadband frequency sweep before the result is accepted to be converged.
            obj.AddToHistory(['.SweepErrorChecks "', num2str(nChecks, '%.15g'), '"']);
        end
        function SweepMinimumSamples(obj, nSamples)
            % Determines the minimum number of frequency samples to be calculated during a broadband S-parameter frequency sweep before the convergence of the latter is checked.
            obj.AddToHistory(['.SweepMinimumSamples "', num2str(nSamples, '%.15g'), '"']);
        end
        function SweepConsiderAll(obj, flag)
            % Defines wheter all S-parameters (flag = True) or selected S-parameters (flag = False, see SweepConsiderSPar) should be considered to calculate the error during the broadband frequency sweep. The option flag = False may be useful if the S-parameters of higher order modes are not of interest.
            obj.AddToHistory(['.SweepConsiderAll "', num2str(flag, '%.15g'), '"']);
        end
        function SweepConsiderReset(obj)
            % Empties the list of selected S-parameters (see SweepConsiderSPar) to be considered to calculate the error during the broadband frequency sweep.
            obj.AddToHistory(['.SweepConsiderReset']);
        end
        function SweepConsiderSPar(obj, port_out, mode_out, port_in, mode_in)
            % Adds an S-parameter to the list of S-parameters to be considered to calculate the error during the broadband frequency sweep. This option may be useful if the S-parameters of higher order modes are not of interest. The list of samples is deleted by SweepConsiderReset. All definitions are ignored if SweepConsiderAll has been set to True.
            obj.AddToHistory(['.SweepConsiderSPar "', num2str(port_out, '%.15g'), '", '...
                                                 '"', num2str(mode_out, '%.15g'), '", '...
                                                 '"', num2str(port_in, '%.15g'), '", '...
                                                 '"', num2str(mode_in, '%.15g'), '"']);
        end
        function SetNumberOfResultDataSamples(obj, nSamples)
            % Specifies the resolution of the interpolated S-parameters during a broadband S-parameter frequency sweep. Increase the number of samples if a higher resolution is required, for instance due to poles which are very close.
            obj.AddToHistory(['.SetNumberOfResultDataSamples "', num2str(nSamples, '%.15g'), '"']);
        end
        function SetResultDataSamplingMode(obj, mode)
            % Call to select the mode of evaluating the frequency axis in the general purpose broadband sweep. This affects the adaptive frequency sampling as well as for instance the S-parameter results when exported as a text file.
            % The parameter mode may have one of the following values:
            % "Automatic"
            % One of the remaining modes will be chosen automatically, depending on the solver settings, usually "Frequency (linear)" unless some logarithmic frequency samples have been definded by calling AddSampleInterval with the corresponding argument.
            % "Frequency (linear)"
            % Data will be sampled equidistantly on the linear frequency axis.
            % "Frequency (logarithmic)"
            % Data will be sampled equidistantly on the logarithmic frequency axis, possibly including a data point at 0 Hz.
            obj.AddToHistory(['.SetResultDataSamplingMode "', num2str(mode, '%.15g'), '"']);
        end
        function ExtrudeOpenBC(obj, flag)
            % Affects the frequency domain solver with tetrahedral mesh. If activated (flag = True), additional layers of mesh cells are added outside the open boundary walls, and the boundary condition is applied further away from the structure.
            obj.AddToHistory(['.ExtrudeOpenBC "', num2str(flag, '%.15g'), '"']);
        end
        function TDCompatibleMaterials(obj, flag)
            % Defines whether constant tangent delta materials should be treated as in the time domain solver, that is by using a dispersive Debye model fit (flag = True), or by a constant imaginary part of the permittivity (flag = False).
            % The setting affects also the treatment of broadband surface impedance materials, i.e. ohmic sheet, tabulated surface impedance and corrugated wall. With the option flag = True the simulated surface impedance will be computed accordingly to the same fitting scheme used for the time domain solver. Otherwise a linear interpolation scheme of the data will be applied.
            % The option flag = True should be used when comparing time domain and frequency domain solver results.
            obj.AddToHistory(['.TDCompatibleMaterials "', num2str(flag, '%.15g'), '"']);
        end
        function CalcStatBField(obj, flag)
            % Set the flag to true if you want the frequency domain solver with tetrahedral mesh to use an inhomogeneous static biasing B-field for ferrites. The static field is then calculated automatically by the magnetostatic solver before the frequency domain solver run.
            obj.AddToHistory(['.CalcStatBField "', num2str(flag, '%.15g'), '"']);
        end
        function CalcPowerLoss(obj, flag)
            % Set the flag to true if you want the frequency domain solver with tetrahedral mesh to calculate power losses over materials. Results will be added into the tree.
            obj.AddToHistory(['.CalcPowerLoss "', num2str(flag, '%.15g'), '"']);
        end
        function CalcPowerLossPerComponent(obj, flag)
            % Set the flag to true if you want the frequency domain solver with tetrahedral mesh to include into the tree the material losses associated to components.
            obj.AddToHistory(['.CalcPowerLossPerComponent "', num2str(flag, '%.15g'), '"']);
        end
        function SetUseGreenSandyFerriteModel(obj, flag)
            % Set the flag to true if you want the frequency domain solver with tetrahedral mesh to use Green-Sandy model for partial magnetized ferrites.
            obj.AddToHistory(['.SetUseGreenSandyFerriteModel "', num2str(flag, '%.15g'), '"']);
        end
        function SetGreenSandyThresholdH(obj, value)
            % The threshold for the H field is by default automatically derived from the saturation magnetization specified in the material properties of the ferrite. Pass an empty string to enable this automatism, or a threshold for the static magnetic field strength in A/m above which the ferrite will be assumed to be fully magnetized. Above that threshold, the Polder tensor is used only.
            obj.AddToHistory(['.SetGreenSandyThresholdH "', num2str(value, '%.15g'), '"']);
        end
        function ResetExcitationList(obj)
            % Resets the current excitation list.
            obj.AddToHistory(['.ResetExcitationList']);
        end
        function AddToExcitationList(obj, port, mode)
            % Adds ports and modes to the exciation list.
            % The parameter port may have one of the following values:
            % int port
            % The number of the port to be excited.
            % "zmin" / "zmax"
            % The boundary position of a Floquet port.
            % The parameter mode defines one or more modes of the chosen port, separated by semicolon.
            % "1"
            % Setting for a discrete port.
            %  "1" or "1;3;4"
            % Mode numbers of a waveguide port.
            % "TE(0,0);TM(0,0)" or "LCP;RCP"
            % Mode type of a Floquet port.
            obj.AddToHistory(['.AddToExcitationList "', num2str(port, '%.15g'), '", '...
                                                   '"', num2str(mode, '%.15g'), '"']);
        end
        function UseParallelization(obj, flag)
            % Call this method to enable or disable CPU parallelization using multiple threads on the CPU cores and sockets as defined by MaxCPUs and MaximumNumberOfCPUDevices methods.
            obj.AddToHistory(['.UseParallelization "', num2str(flag, '%.15g'), '"']);
        end
        function MaxCPUs(obj, nCPUs)
            % Sets the number of CPU threads to be used.
            obj.AddToHistory(['.MaxCPUs "', num2str(nCPUs, '%.15g'), '"']);
        end
        function MaximumNumberOfCPUDevices(obj, MaximumNumberOfCPUDevices)
            % Sets the number of CPU devices (such as CPU sockets) to be used.
            obj.AddToHistory(['.MaximumNumberOfCPUDevices "', num2str(MaximumNumberOfCPUDevices, '%.15g'), '"']);
        end
        function SweepWeightEvanescent(obj, dWeight)
            % Defines a special weight factor for the S-parameter sweep calculation, which is applied to frequency ranges belonging to evanescent modes.
            obj.AddToHistory(['.SweepWeightEvanescent "', num2str(dWeight, '%.15g'), '"']);
        end
        function LowFrequencyStabilization(obj, flag)
            % Applies a stabilization procedure for frequencies close to zero, which might improve the convergence behavior.
            % Please note, that this effects only the general purpose tetrahedral frequency domain solver.
            obj.AddToHistory(['.LowFrequencyStabilization "', num2str(flag, '%.15g'), '"']);
        end
        function OrderTet(obj, sOrder)
            % Select here the order of the general purpose tetrahedral frequency domain solver, with the choice between low memory or highly accurate results for a given number of mesh cells. Higher order also allows to achieve accurate results with less mesh cells and eventually less memory consumption than lower order, if the structure contains electrically large voids rather than many geometric details.
            % If the method MixedOrderTet is called with flag = True, then OrderTet determines the maximum solver order to be used.
            % The parameter sOrder may have one of the following values:
            % "First"
            % Calculation is done with first order accuracy providing solutions with low memory effort. Especially well suited for structures with many electrically small details.
            % "Second"
            % Calculation is done with second order accuracy providing highly accurate results. Well suited for most applications, and therefore the default.
            % "Third"
            % Calculation is done with third order accuracy providing highest accuracy. Allows to reduce the number of mesh steps per wavelength for structures with large voids, or to even further improve the accuracy for a given mesh resolution.
            obj.AddToHistory(['.OrderTet "', num2str(sOrder, '%.15g'), '"']);
        end
        function MixedOrderTet(obj, flag)
            % If this method is activated (flag = True), the frequency domain solver with tetrahedral mesh will automatically use variable order up to the maximum solver order, which is specified by calling OrderTet. This allows the solver to decide in which regions lowest order should be used to save memory and computational time, as well as to use higher order where required.
            obj.AddToHistory(['.MixedOrderTet "', num2str(flag, '%.15g'), '"']);
        end
        function OrderSrf(obj, sOrder)
            % Select here the order of the integral equation solver. If the method MixedOrderSrf is activated (flag = True), OrderSrf determines the maximum used solver order.
            % The parameter sOrder allows to choose between low memory and highly accurate results, and may have one of the following values:
            % "First"
            % Calculation is done with first order accuracy providing solutions with low memory effort.
            % "Second"
            % Calculation is done with second order accuracy providing highly accurate results.
            % "Third"
            % Calculation is done with third order accuracy providing highest accuracy.
            obj.AddToHistory(['.OrderSrf "', num2str(sOrder, '%.15g'), '"']);
        end
        function MixedOrderSrf(obj, flag)
            % If this method is activated (flag = True), mixed solver order will be used in the integral equation solver. Use OrderSrf to determine the maximum used solver order.
            obj.AddToHistory(['.MixedOrderSrf "', num2str(flag, '%.15g'), '"']);
        end
        function UseDistributedComputing(obj, flag)
            % This method allows to switch between local and remote solver runs. When enabled, a Frequency domain solver run is submitted to the network. The setting does not influence parameter sweeps and optimizer runs with distributed computing.
            obj.AddToHistory(['.UseDistributedComputing "', num2str(flag, '%.15g'), '"']);
        end
        function NetworkComputingStrategy(obj, key)
            % A single remote calculation ("RunRemote") and a distribution of frequency samples ("Samples") are currently supported.
            % key: 'RunRemote'
            %      'Samples'
            obj.AddToHistory(['.NetworkComputingStrategy "', num2str(key, '%.15g'), '"']);
        end
        function NetworkComputingJobCount(obj, value)
            % Specifies the number of jobs which may be submitted at once to the network computing job queue in case of an automatic frequency sampling. Increase this number to use more computers in parallel. It does not affect equidistant frequency samples, monitor frequencies and other fix points, which are submitted to the job queue at once.
            obj.AddToHistory(['.NetworkComputingJobCount "', num2str(value, '%.15g'), '"']);
        end
        function UseSensitivityAnalysis(obj, flag)
            % If activated the sensitivity analysis is calculated when running the frequency domain solver with tetrahedral mesh.
            obj.AddToHistory(['.UseSensitivityAnalysis "', num2str(flag, '%.15g'), '"']);
        end
        function UseDoublePrecision(obj, flag)
            % Supported by integral equation solver. If activated the solver uses double-precision (64-bit)  for representing floating-point values. Otherwise the solver uses single-precision (32-bit). The single-precision representation saves memory whereas the double-precision representation speeds up the convergence of the iterative equation system solver. Double-precision is necessary to obtain highly accurate results.
            obj.AddToHistory(['.UseDoublePrecision "', num2str(flag, '%.15g'), '"']);
        end
        function PreconditionerAccuracyIntEq(obj, value)
            % Supported by integral equation solver.  Sets the tolerance for the preconditioner.
            obj.AddToHistory(['.PreconditionerAccuracyIntEq "', num2str(value, '%.15g'), '"']);
        end
        function MinMLFMMBoxSize(obj, value)
            % Supported by integral equation solver. This command allows you to specify the minimum box size the MLFMM uses.
            obj.AddToHistory(['.MinMLFMMBoxSize "', num2str(value, '%.15g'), '"']);
        end
        function MLFMMAccuracy(obj, value)
            % Supported by integral equation solver. This accuracy determines the accuracy of the coupling between the MLFMM boxes. The value must be one of the following:  "VeryLowMem",  "LowMem", "Default" or "HighAcc".
            obj.AddToHistory(['.MLFMMAccuracy "', num2str(value, '%.15g'), '"']);
        end
        function UseCFIEForCPECIntEq(obj, flag)
            % Supported by integral equation solver. If for closed PEC bodies the Combined Field Integral Equation shall be used enable this option. The faster convergence of the linear equation system solver is an advantage of this option. For electrically small or complex PEC solids it is recommended to disable this option. The accuracy for rather coarse mesh will be improved.
            % If you enable this option and set the CFIE alpha to 1 (using the VBA command SetCFIEAlpha) the Electric Field Integral Equation will be used. This is an option if you are sure there will be no spurious resonances inside the PEC solids e.g. for electrically small PEC solids.
            obj.AddToHistory(['.UseCFIEForCPECIntEq "', num2str(flag, '%.15g'), '"']);
        end
        function UseFastRCSSweepIntEq(obj, flag)
            % Supported by integral equation solver. A fast calculation of monostatic RCS for different angles is available if a plane wave is used as excitation. To enable and disable the fast RCS calculation check and uncheck this option respectively. Please use the Command SetRCSSweepProperties to define the RCS sweep properties.
            obj.AddToHistory(['.UseFastRCSSweepIntEq "', num2str(flag, '%.15g'), '"']);
        end
        function SetMRCSSweepProperties(obj, Phi_Start, Phi_End, Num_Phi_Steps, Theta_Start, Theta_End, Num_Theta_Steps, E_inc_Theta, E_inc_Phi)
            % Supported by integral equation solver. For a fast monostatic RCS calculation the angles for the incoming direction (Phi, Theta) of the plane wave can be defined as equidistant samples.  For only varying Phi  please set the Theta_Start equal to Theta_End and accordingly if you only want to vary Phi.
            obj.AddToHistory(['.SetMRCSSweepProperties "', num2str(Phi_Start, '%.15g'), '", '...
                                                      '"', num2str(Phi_End, '%.15g'), '", '...
                                                      '"', num2str(Num_Phi_Steps, '%.15g'), '", '...
                                                      '"', num2str(Theta_Start, '%.15g'), '", '...
                                                      '"', num2str(Theta_End, '%.15g'), '", '...
                                                      '"', num2str(Num_Theta_Steps, '%.15g'), '", '...
                                                      '"', num2str(E_inc_Theta, '%.15g'), '", '...
                                                      '"', num2str(E_inc_Phi, '%.15g'), '"']);
        end
        function [Phi_Start, Phi_End, Num_Phi_Steps, Theta_Start, Theta_End, Num_Theta_Steps, E_inc_Theta, E_inc_Phi, Activation] = GetRCSSweepProperties(obj)
            % Supported by integral equation solver. Returns the settings set by SetRCSSweepProperties and UseFastRCSSweepIntEq.
            functionString = [...
                'Dim Phi_Start As Double, Phi_End As Double, Num_Phi_Steps As Integer', newline, ...
                'Dim Theta_Start As Double, Theta_End As Double, Num_Theta_Steps As Integer', newline, ...
                'Dim E_inc_Theta As Double, E_inc_Phi As Double', newline, ...
                'Dim Activation As Boolean', newline, ...
                'FDSolver.GetRCSSweepProperties(Phi_Start, Phi_End, Num_Phi_Steps, Theta_Start, Theta_End, Num_Theta_Steps, E_inc_Theta, E_inc_Phi, Activation)', newline, ...
            ];
            returnvalues = {'Phi_Start', 'Phi_End', 'Num_Phi_Steps', 'Theta_Start, Theta_End', ...
                            'Num_Theta_Steps', 'E_inc_Theta', 'E_inc_Phi', 'Activation'};
            [Phi_Start, Phi_End, Num_Phi_Steps, Theta_Start, Theta_End, Num_Theta_Steps, E_inc_Theta, E_inc_Phi, Activation] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            Phi_Start = str2double(Phi_Start);
            Phi_End = str2double(Phi_End);
            Num_Phi_Steps = str2double(Num_Phi_Steps);
            Theta_Start = str2double(Theta_Start);
            Theta_End = str2double(Theta_End);
            Num_Theta_Steps = str2double(Num_Theta_Steps);
            E_inc_Theta = str2double(E_inc_Theta);
            E_inc_Phi = str2double(E_inc_Phi);
            Activation = str2double(Activation);
        end
        function SetCalcBlockExcitationsInParallel(obj, enable, useblock, maxparallel)
            % This method toggles whether or not and how excitations will be solved in parallel if the iterative solver is used. Only applies to the Frequency Domain solver with tetrahedral mesh. The legacy version is available by setting useblock to false. It is however recommended to leave the default useblock=True as the block version usually provides better performance for simulations with a large number of tetrahedrons or many excitations. Leave maxparallel blank (pass "") to let the solver decide how many excitations to calculate in parallel. Note that hardware and license restrictions may apply and overwrite some of those settings.
            obj.AddToHistory(['.SetCalcBlockExcitationsInParallel "', num2str(enable, '%.15g'), '", '...
                                                                 '"', num2str(useblock, '%.15g'), '", '...
                                                                 '"', num2str(maxparallel, '%.15g'), '"']);
        end
        function SetWrite3DFieldsForFarfieldCalc(obj, flag)
            % If activated, the frequency domain solver with tetrahedral mesh stores volumetric electric and magnetic field results for the farfield calculation. Call with flag = False to use an alternative calculation method which saves disk space by just recording surface field data on open boundary conditions of the bounding box.
            obj.AddToHistory(['.SetWrite3DFieldsForFarfieldCalc "', num2str(flag, '%.15g'), '"']);
        end
        function SetRecordUnitCellScanFarfield(obj, key)
            % This option is considered by the frequency domain solver with tetrahedral mesh in case of unit cell boundary conditions only. It modifies the way farfield monitor data is calculated. With "on" chosen, the Floquet ports' S-parameters will be collected in a farfield representation for each scan angle theta and phi. Choose "off" to perform a farfield calculation using the fields on the boundaries of the single unit cell. The default mode "auto" uses "on" for parameter sweeps over the scan angle theta and phi, and "off" without parameter sweep, that is for single solver runs.
            % key: 'auto'
            %      'on'
            %      'off'
            obj.AddToHistory(['.SetRecordUnitCellScanFarfield "', num2str(key, '%.15g'), '"']);
        end
        function SetConsiderUnitCellScanFarfieldSymmetry(obj, theta, phi)
            % This option is considered by the frequency domain solver with tetrahedral mesh in case of unit cell boundary conditions only, and if the method SetRecordUnitCellScanFarfield is configured such that a unit cell scan farfield is collected during a parameter sweep. The two flags for symmetry in "theta" and "phi" will cause the farfield data to be mirrored, such that only a quarter or half of the scan angle space need to be considered in the parameter sweep. This of course requires the structure to exhibit corresponding symmetries.
            obj.AddToHistory(['.SetConsiderUnitCellScanFarfieldSymmetry "', num2str(theta, '%.15g'), '", '...
                                                                       '"', num2str(phi, '%.15g'), '"']);
        end
        function SetDisableResultTemplatesDuringUnitCellScanAngleSweep(obj, disable)
            % This option is considered by the frequency domain solver with tetrahedral mesh in case of unit cell boundary conditions only, and if the method SetRecordUnitCellScanFarfield is configured such that a unit cell scan farfield is collected during a parameter sweep.
            % Template based post-processing result templates usually are evaluated after each solver run for a given parameter combination. However, farfield results and S-parameter color map plots are generated after the unit cell scan angle parameter sweep is completed. Thus, evaluating result templates which reference those results during the parameter sweep normally produces error messages, as the results do not yet exist. To prevent these error messages, which might cause the optimizer to stop, please call SetDisableResultTemplatesDuringUnitCellScanAngleSweep True before starting the simulation. This is done automatically if you use the unit cell simulation project creation.
            obj.AddToHistory(['.SetDisableResultTemplatesDuringUnitCellScanAngleSweep "', num2str(disable, '%.15g'), '"']);
        end
        function ExtractUnitCellScanFarfield(obj, frequencies, names, anchor)
            % This post-processing calculation is available for the frequency domain solver with tetrahedral mesh in case of unit cell boundary conditions only, and produces results if the method SetRecordUnitCellScanFarfield was configured such that a unit cell scan farfield is collected during a parameter sweep. It extracts farfield results at some frequencies given in Hz, and adds Navigation Tree entries with the corresponding names provided for the results. Multiple frequencies and names are separated by semicolon, and a name must be provided for each frequency. The anchor usually is 1. It defines which parametric data set is used as a reference, in case the parameter sweep had sequences changing parameters other than those used to parameterize the scan angle.
            obj.AddToHistory(['.ExtractUnitCellScanFarfield "', num2str(frequencies, '%.15g'), '", '...
                                                           '"', num2str(names, '%.15g'), '", '...
                                                           '"', num2str(anchor, '%.15g'), '"']);
        end
        function string = UpdateInterpolationSettings(obj, navigationtreepath)
            % This method is available as a post-processing step for the general purpose sweep. It updates the interpolation settings of results below the given path in the Navigation Tree. navigationtreepath has slash or backslash characters as separators and is case-insensitive, for instance "1D Results/Probes". The solver's interpolation settings are then applied to some 1D results. See SetNumberOfResultDataSamples and SetResultDataSamplingMode for details. The interpolation will be removed again if SetMethod was called with "Discrete samples only". UpdateInterpolationSettings returns a string with a summary.
            string = obj.hFDSolver.invoke('UpdateInterpolationSettings', navigationtreepath);
        end
        function ExportMORSolution(obj, frequency)
            % This method exports available 3D solutions at the chosen frequency to CST PARTICLE Studio. Afterwards the exported fields can be imported in CST PARTICLE Studio with the Predefined Field feature. Applies to the fast reduced order model sweep method only.
            obj.AddToHistory(['.ExportMORSolution "', num2str(frequency, '%.15g'), '"']);
        end
        %% From 2013 documentation.
        function InterpolationSamples(obj, nSamples)
            % Specifies the resolution of the interpolated S-parameters during a broadband S-parameter frequency sweep. Increase the number of samples if a higher resolution is required, for instance due to poles which are very close.
            obj.AddToHistory(['.InterpolationSamples "', num2str(nSamples, '%.15g'), '"']);
        end
        function SetCalculateExcitationsInParallel(obj, enable, useblock, maxparallel)
            % This method toggles whether or not and how excitations will be solved in parallel if the iterative solver is used. Only applies to the Frequency Domain solver with tetrahedral mesh. A new version is available by setting useblock to true. It usually provides better performance for simulations with a large number of tetrahedrons or many excitations. Leave maxparallel blank (pass "") to let the solver decide how many excitations to calculate in parallel. Note that hardware and license restrictions may apply and overwrite some of those settings.
            obj.AddToHistory(['.SetCalculateExcitationsInParallel "', num2str(enable, '%.15g'), '", '...
                                                                 '"', num2str(useblock, '%.15g'), '", '...
                                                                 '"', num2str(maxparallel, '%.15g'), '"']);
        end
        function SweepErrorThreshold(obj, flag, threshold)
            % Activates (switch = "True") or deactivates (switch = "False") the broadband S-parameter frequency sweep convergence check, and sets the corresponding error threshold thres for the interpolation of the S-parameters when using the broadband frequency sweep feature (SParameterSweep).  The number of frequency samples needed for a S-parameter simulation by  the solver usually decreases if the check is activated, since the solver stops calculating additional frequency samples as soon as the convergence criterion is reached, which, in addition, can be influenced by the SweepErrorChecks and SweepMinimumSamples methods.
            obj.AddToHistory(['.SweepErrorThreshold "', num2str(flag, '%.15g'), '", '...
                                                   '"', num2str(threshold, '%.15g'), '"']);
        end
        function LimitCPUs(obj, flag)
            % Enabling this method offers the possibility to define a maximum number of CPUs using the MaxCPUs method.
            obj.AddToHistory(['.LimitCPUs "', num2str(flag, '%.15g'), '"']);
        end
        %% Undocumented functions.
        % Found in history list when setting frequency domain solver settings.
        function NewIterativeSolver(obj, bool)
            obj.AddToHistory(['.NewIterativeSolver "', num2str(bool, '%.15g'), '"']);
        end
        % Found in history list when setting frequency domain solver settings.
        function UseDoublePrecision_ML(obj, bool)
            obj.AddToHistory(['.UseDoublePrecision_ML "', num2str(bool, '%.15g'), '"']);
        end
        % Found in history list when setting frequency domain solver settings.
        function RemoveAllStopCriteria(obj, type)
            % type: 'Hex'
            %       'Tet'
            %       'Srf'
            obj.AddToHistory(['.RemoveAllStopCriteria "', num2str(type, '%.15g'), '"']);
        end
        % Found in history list when setting frequency domain solver settings.
        % fdsolver.AddStopCriterion('All S-Parameters', '0.01', '2', 'Hex', 'True');
        % fdsolver.AddStopCriterion('Reflection S-Parameters', '0.01', '2', 'Hex', 'False');
        % fdsolver.AddStopCriterion('Transmission S-Parameters', '0.01', '2', 'Hex', 'False');
        function AddStopCriterion(obj, sparams, threshold, numchecks, type, active_bool)
            % sparams: 'All S-Parameters'
            %          'Reflection S-Parameters'
            %          'Transmission S-Parameters'
            obj.AddToHistory(['.AddStopCriterion "', num2str(sparams, '%.15g'), '", '...
                                                '"', num2str(threshold, '%.15g'), '", '...
                                                '"', num2str(numchecks, '%.15g'), '", '...
                                                '"', num2str(type, '%.15g'), '", '...
                                                '"', num2str(active_bool, '%.15g'), '"']);
        end
        % Found in history list when setting frequency domain solver settings.
        % Definition below is copied from CST.Solver.
        function MPIParallelization(obj, flag)
            % Enable or disable MPI computation for solver.
            obj.AddToHistory(['.MPIParallelization "', num2str(flag, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hFDSolver
        history
        bulkmode

    end
end

%% Default Settings
% AcceleratedRestart(1)
% AccuracyTet(1e-4)
% AccuracyHex(1e-6)
% AccuracySrf(1e-3)
% AccuracyROM(1e-4)
% AddMonitorSamples(1)
% FrequencySamples(20)
% UseHelmholtzEquation(1)
% UserFrequency(0)
% MaxIterations(0)
% LimitIterations(0)
% ModesOnly(0)
% SetShieldAllPorts(0)
% SetPortMeshMatches3DMeshTet(0)
% SetAllowROMPortModeSolver(1)
% SetAllowDiscretePortSolver(0)
% SetUseROMPortModeSolverTet(0, 0)
% EnableNativeSingleEnded(1)
% UseDeembeddedFields(0)
% SetPreferLeanOutput(1)
% SetUseImpLineImpedanceAsReference(0)
% ConsiderPortLossesTet(1)
% SetUseOrientPortWithMask(0)
% FreqDistAdaptMode(');Distributed');
% SetStopSweepIfCriterionMet(1)
% SetSweepThreshold('S-Parameters', 0.01)
% UetSweepThreshold('S-Parameters', 1)
% SetSweepThreshold('Probes', 0.05)
% UetSweepThreshold('Probes', 1)
% Type('Auto');
% StoreResultsInCache(0)
% SetMethod('Tetrahedral', 'General Purpose');
% AutoNormImpedance(0)
% NormingImpedance(50.0)
% Stimulation('All', 'All');
% SweepErrorChecks(2)
% SweepMinimumSamples(3)
% SweepConsiderAll(1)
% SetNumberOfResultDataSamples(1001)
% SetResultDataSamplingMode('Automatic');
% ExtrudeOpenBC(0)
% TDCompatibleMaterials(1)
% CalcStatBField(0)
% CalcPowerLoss(1)
% CalcPowerLossPerComponent(0)
% SetUseGreenSandyFerriteModel(0)
% SetGreenSandyThresholdH('');
% StoreSolutionCoefficients(1)
% CreateLegacy1DSignals(0)
% MeshAdaptionHex(0)
% MeshAdaptionTet(1)
% SetOpenBCTypeHex('Default');
% SetOpenBCTypeTet('Default');
% ResetExcitationList(1)
% AddToExcitationList('All', 'All');
% UseParallelization(1)
% MaxCPUs(72)
% MaximumNumberOfCPUDevices(2)
% SweepWeightEvanescent(1.0)
% LowFrequencyStabilization(0)
% OrderTet('Second');
% OrderSrf('Second');
% UseDistributedComputing(0)
% NetworkComputingStrategy('RunRemote');
% NetworkComputingJobCount(3)
% UseDoublePrecision(1)
% MixedOrderSrf(0)
% MixedOrderTet(0)
% UsePreconditionerIntEq('0');
% PreconditionerAccuracyIntEq('0.15');
% MLFMMAccuracy('Default');
% MinMLFMMBoxSize('0.2');
% UseCFIEForCPECIntEq(1)
% UseFastRCSSweepIntEq(1)
% SetCalcBlockExcitationsInParallel(1, 1, '');
% SetWrite3DFieldsForFarfieldCalc(1)
% SetRecordUnitCellScanFarfield('auto');
% SetConsiderUnitCellScanFarfieldSymmetry(0, 0)
% SetDisableResultTemplatesDuringUnitCellScanAngleSweep(0)
