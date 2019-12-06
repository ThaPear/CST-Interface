%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Warning: Untested                                                   %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is the object that controls some of the eigenmode solver settings and provides access to basic eigenmode solver results. Currently most VBA settings for the eigenmode solvers are controled by the Solver Object.
classdef EigenmodeSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a EigenmodeSolver object.
        function obj = EigenmodeSolver(project, hProject)
            obj.project = project;
            obj.hEigenmodeSolver = hProject.invoke('EigenmodeSolver');
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
            % Prepend With EigenmodeSolver and append End With
            obj.history = [ 'With EigenmodeSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define EigenmodeSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['EigenmodeSolver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets the eigenmode solver settings to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function int = Start(obj)
            % Starts the eigenmode solver with the current settings and returns 1 if the calculation is successfully finished and 0 if it failed.
            int = obj.hEigenmodeSolver.invoke('Start');
        end
        function SetMeshAdaptationHex(obj, flag)
            % Enable automatic hexahedral mesh adaptation for the eigenmode solver.
            obj.AddToHistory(['.SetMeshAdaptationHex "', num2str(flag, '%.15g'), '"']);
            obj.setmeshadaptationhex = flag;
        end
        function SetMeshAdaptationTet(obj, flag)
            % Enable automatic tetrahedral mesh adaptation for the eigenmode solver.
            obj.AddToHistory(['.SetMeshAdaptationTet "', num2str(flag, '%.15g'), '"']);
            obj.setmeshadaptationtet = flag;
        end
        function SetNumberOfModes(obj, nModes)
            % Sets the number of modes which should be calculated by the eigenmode solver. Modes are sorted by ascending eigenmode frequency.
            obj.AddToHistory(['.SetNumberOfModes "', num2str(nModes, '%.15g'), '"']);
            obj.setnumberofmodes = nModes;
        end
        function SetModesInFrequencyRange(obj, flag)
            % Calculates all modes in the global frequency range. This is only available for the JDM eigenmode solver.
            obj.AddToHistory(['.SetModesInFrequencyRange "', num2str(flag, '%.15g'), '"']);
            obj.setmodesinfrequencyrange = flag;
        end
        function SetConsiderStaticModes(obj, flag)
            % If flag = True then the static modes are saved and can be accessed via the result tree. Otherwise the static modes are not saved.
            obj.AddToHistory(['.SetConsiderStaticModes "', num2str(flag, '%.15g'), '"']);
            obj.setconsiderstaticmodes = flag;
        end
        function SetRemoteCalculation(obj, flag)
            % This method allows to switch between local and remote solver runs. When enabled, an Eigenmode solver run is submitted to the network. The setting does not influence parameter sweeps and optimizer runs with distributed computing.
            obj.AddToHistory(['.SetRemoteCalculation "', num2str(flag, '%.15g'), '"']);
            obj.setremotecalculation = flag;
        end
        function SetMethod(obj, key)
            % This method affects the Eigenmode solver with hexahedral mesh. Two different eigenmode solver methods are provided for that mesh, namely AKS (Krylov Subspace method) and JDM (Jacobi-Davidson method). The JDM solver is capable to solve loss free as well as lossy problems with a frequency independent complex permittivity or reluctivity. The "JDM (low memory)" is a variant of "JDM" that is more efficient in terms of memory usage, but may be less robust in terms of the underlying iterative solver's convergence.
            % key: 'AKS'
            %      'JDM'
            %      'JDM (low memory)'
            obj.AddToHistory(['.SetMethod "', num2str(key, '%.15g'), '"']);
            obj.setmethod = key;
        end
        function SetMeshType(obj, key)
            % The eigenmode solver supports both hexahedral and tetrahedral meshes. Specify which mesh type should be used. Please note that there is no choice of the method for the "Tetrahedral Mesh".
            % key: 'Hexahedral Mesh'
            %      'Tetrahedral Mesh'
            obj.AddToHistory(['.SetMeshType "', num2str(key, '%.15g'), '"']);
            obj.setmeshtype = key;
        end
        function SetMaterialEvaluationFrequency(obj, flag, freq)
            % This setting applies to the lossy JD eigenmode solver method only. Electrically conductive materials and dispersive materials are evaluated either at the center frequency, or at another frequency. This yields a complex permittivity which is assumed to be frequency independent.
            obj.AddToHistory(['.SetMaterialEvaluationFrequency "', num2str(flag, '%.15g'), '", '...
                                                              '"', num2str(freq, '%.15g'), '"']);
            obj.setmaterialevaluationfrequency.flag = flag;
            obj.setmaterialevaluationfrequency.freq = freq;
        end
        function SetFrequencyTarget(obj, flag, freq)
            % This method allows to specify a lower limit to the modes' frequencies. Admissible values are zero to the maximum frequency of the frequency range. The eigenmodes above this frequency are then calculated in ascending order.
            obj.AddToHistory(['.SetFrequencyTarget "', num2str(flag, '%.15g'), '", '...
                                                  '"', num2str(freq, '%.15g'), '"']);
            obj.setfrequencytarget.flag = flag;
            obj.setfrequencytarget.freq = freq;
        end
        function SetLowerBoundForQ(obj, flag, value)
            % This method allows to specify a lower limit to the modes' Q factor. It affects those Eigenmode calculations with the tetrahedral mesh for which losses are considered. Pass an empty string "" as the value to disable or enable the lower bound without changing the value. The settings are not considered in case the hexahedral mesh is active.
            obj.AddToHistory(['.SetLowerBoundForQ "', num2str(flag, '%.15g'), '", '...
                                                 '"', num2str(value, '%.15g'), '"']);
            obj.setlowerboundforq.flag = flag;
            obj.setlowerboundforq.value = value;
        end
        function SetMaxNumberOfThreads(obj, nThreads)
            % Maximum number of threads to use for the eigenmode calculation. Whether or not the eigenmode solver can use that many threads depends not only on the hardware, but also on the mesh and method chosen.
            obj.AddToHistory(['.SetMaxNumberOfThreads "', num2str(nThreads, '%.15g'), '"']);
            obj.setmaxnumberofthreads = nThreads;
        end
        function SetUseParallelization(obj, flag)
            % Specifies whether or not parallelization with different threads may be used for the eigenmode calculation to speed up the simulation.
            obj.AddToHistory(['.SetUseParallelization "', num2str(flag, '%.15g'), '"']);
            obj.setuseparallelization = flag;
        end
        function SetConsiderLossesInPostprocessingOnly(obj, flag)
            % It is common practise for Eigenmode calculations to ignore the losses in a first step, namely for the calculation of the Eigenmode solutions themselves. An approximate consideration of the losses is still possible in the post-processing however, by assuming that the losses generated on the boundary can be calculated from the loss-free case. This approach, also referred to as perturbation method, speeds up the calculation.
            % The method SetConsiderLossesInPostprocessingOnly has an effect on the JDM solver (hexahedral mesh) and the Eigenmode solver with tetrahedral mesh. The lossfree AKS solver always ignores losses and only allows to use the pertubation method to calculate the Q-factor.
            obj.AddToHistory(['.SetConsiderLossesInPostprocessingOnly "', num2str(flag, '%.15g'), '"']);
            obj.setconsiderlossesinpostprocessingonly = flag;
        end
        function bool = GetConsiderLossesInPostprocessingOnly(obj)
            % Returns the last value passed to SetConsiderLossesInPostprocessingOnly or the corresponding default, if the method has not been called before.
            bool = obj.hEigenmodeSolver.invoke('GetConsiderLossesInPostprocessingOnly');
        end
        function SetCalculateExternalQFactor(obj, flag)
            % The solver calculates the external Q-factor of all modes if the flag is set to true, to account for the effect of waveguide port coupling with the modes.
            obj.AddToHistory(['.SetCalculateExternalQFactor "', num2str(flag, '%.15g'), '"']);
            obj.setcalculateexternalqfactor = flag;
        end
        function SetQExternalAccuracy(obj, acc)
            % Sets the desired linear equation system solver accuracy for calculating the external Q factor of the modes. Only applies if external Q factors are calculated, see SetCalculateExternalQFactor.
            obj.AddToHistory(['.SetQExternalAccuracy "', num2str(acc, '%.15g'), '"']);
            obj.setqexternalaccuracy = acc;
        end
        function SetOrderTet(obj, Value)
            % Specify a value between "1" and "3" for the solver order of the Eigenmode solver with tetrahedral mesh. The choice is between low memory (1), the default second order (2) for good accuracy, or highly accurate results (3) for a given number of mesh cells. Higher order also allows to achieve accurate results with less mesh cells and possibly less memory consumption than lower order, if the structure contains electrically large voids rather than many geometric details.
            obj.AddToHistory(['.SetOrderTet "', num2str(Value, '%.15g'), '"']);
            obj.setordertet = Value;
        end
        function SetStoreResultsInCache(obj, flag)
            % Stores results of the solver in the result cache. For each parameter combination in a parameter sweep, for instance, a full backup of the results is stored in a sub folder like {Projectname}/Result/Cache/run000001.
            obj.AddToHistory(['.SetStoreResultsInCache "', num2str(flag, '%.15g'), '"']);
            obj.setstoreresultsincache = flag;
        end
        function SetTDCompatibleMaterials(obj, flag)
            % Defines wheter constant tangent delta materials should be treated as in the time domain solver, that is by using a dispersive Debye model fit (flag = True), or by a constant imaginary part of the permittivity (flag = False).
            obj.AddToHistory(['.SetTDCompatibleMaterials "', num2str(flag, '%.15g'), '"']);
            obj.settdcompatiblematerials = flag;
        end
        function SetCalculateThermalLosses(obj, flag)
            % This setting allows to activate or deactivate the surface loss calculation for the thermal coupling.
            obj.AddToHistory(['.SetCalculateThermalLosses "', num2str(flag, '%.15g'), '"']);
            obj.setcalculatethermallosses = flag;
        end
        function SetAccuracy(obj, acc)
            % Sets the desired accuracy of the eigenmode solver in terms of the relative residual norm.
            obj.AddToHistory(['.SetAccuracy "', num2str(acc, '%.15g'), '"']);
            obj.setaccuracy = acc;
        end
        function int = GetNumberOfModesCalculated(obj)
            % Returns the number of modes which have been calculated by the eigenmode solver, as stored in the results. This value may differ from the solver setting if for any reason the solver has calculated less modes than requested, or if a frequency range was specified rather than the number of modes. In any case, the number of modes returned by this method should be retrieved for the following queries and before calling any of those queries.
            int = obj.hEigenmodeSolver.invoke('GetNumberOfModesCalculated');
        end
        function double = GetModeFrequencyInHz(obj, ModeNumber)
            % Returns the Eigenmode frequency f in Hertz of the mode specified by its One-based number.
            double = obj.hEigenmodeSolver.invoke('GetModeFrequencyInHz', ModeNumber);
            obj.getmodefrequencyinhz = ModeNumber;
        end
        function double = GetModeRelResidualNorm(obj, ModeNumber)
            % Returns the relative residual norm achieved when solver the linear equation system for a given mode. This value usually is lower than the accuracy threshold in the solver specials.
            double = obj.hEigenmodeSolver.invoke('GetModeRelResidualNorm', ModeNumber);
            obj.getmoderelresidualnorm = ModeNumber;
        end
        function double = GetModeQFactor(obj, ModeNumber)
            % For structures with lossy materials and solver methods which support considering those losses, the query returns the Q factor of the mode specified by its One-based number. If none was calculated, the method returns Zero. The Q factor is derived from the real and imaginary part of the complex Eigenfrequency.
            double = obj.hEigenmodeSolver.invoke('GetModeQFactor', ModeNumber);
            obj.getmodeqfactor = ModeNumber;
        end
        function double = GetModeExternalQFactor(obj, ModeNumber)
            % While the Eigenmode solver usually solves problems with closed boundaries, the external Q factor calculation allows to take into account the coupling effects of transmission lines being connected to the device, as described by waveguide ports. If the corresponding option was activated at the time the solver started, the method returns the external Q factor of the mode specified by its One-based number.
            double = obj.hEigenmodeSolver.invoke('GetModeExternalQFactor', ModeNumber);
            obj.getmodeexternalqfactor = ModeNumber;
        end
        function double = GetLoadedFrequencyInHz(obj, ModeNumber)
            % This results is only available with the external Q factor calculation. The Eigenfrequency of the device changes as couplers are connected to it. The query returns the loaded frequency of the mode in Hertz.
            double = obj.hEigenmodeSolver.invoke('GetLoadedFrequencyInHz', ModeNumber);
            obj.getloadedfrequencyinhz = ModeNumber;
        end
        function int = GetNumberOfSensitivityDesignParameters(obj)
            % Returns the number of Eigenmode sensitivity design parameters for which results are available.
            int = obj.hEigenmodeSolver.invoke('GetNumberOfSensitivityDesignParameters');
        end
        function name = GetSensitivityDesignParameter(obj, Number)
            % Returns the name of a sensitivity design parameter for which results had been calculated. Number is One-based.
            name = obj.hEigenmodeSolver.invoke('GetSensitivityDesignParameter', Number);
            obj.getsensitivitydesignparameter = Number;
        end
        function double = GetFrequencySensitivity(obj, DesignParameter, ModeNumber)
            % Returns the result stored for the derivative of the Eigenmode frequency with respect to the given design parameter. All units are SI base units, so that for a geometric sensitivity result, the value is in Hertz per meter, and just Hertz for material sensitivity. The mode number is One-based.
            double = obj.hEigenmodeSolver.invoke('GetFrequencySensitivity', DesignParameter, ModeNumber);
            obj.getfrequencysensitivity.DesignParameter = DesignParameter;
            obj.getfrequencysensitivity.ModeNumber = ModeNumber;
        end
        function double = GetQFactorSensitivity(obj, DesignParameter, ModeNumber)
            % Returns the result stored for the derivative of the Eigenmode Q factor with respect to the given design parameter. The units are SI base units, and depend on the design parameter. The mode number is again One-based.
            double = obj.hEigenmodeSolver.invoke('GetQFactorSensitivity', DesignParameter, ModeNumber);
            obj.getqfactorsensitivity.DesignParameter = DesignParameter;
            obj.getqfactorsensitivity.ModeNumber = ModeNumber;
        end
        function ResetForceCalculation(obj)
            % Clears the list of modes selected for Lorentz force computation.
            obj.AddToHistory(['.ResetForceCalculation']);
        end
        function CalculateLorentzForceForMode(obj, ModeIndex)
            % Adds the mode with index ModeIndex to the list of modes selected for Lorentz force calculation. Mode indices are 1-based.
            obj.AddToHistory(['.CalculateLorentzForceForMode "', num2str(ModeIndex, '%.15g'), '"']);
            obj.calculatelorentzforceformode = ModeIndex;
        end
        function CalculateLorentzForceForAllModes(obj)
            % Adds all the available modes to the list of modes selected for Lorentz force calculation.
            obj.AddToHistory(['.CalculateLorentzForceForAllModes']);
        end
        function IsModeSelectedForForceCalculation(obj, ModeIndex)
            % Checks whether the mode with index ModeIndex is selected for Lorentz force calculation. Mode indices are 1-based.
            obj.AddToHistory(['.IsModeSelectedForForceCalculation "', num2str(ModeIndex, '%.15g'), '"']);
            obj.ismodeselectedforforcecalculation = ModeIndex;
        end
        function IsAnyModeSelectedForForceCalculation(obj)
            % Checks whether any modes are selected for Lorentz force calculation.
            obj.AddToHistory(['.IsAnyModeSelectedForForceCalculation']);
        end
        function StartForceCalculation(obj)
            % Starts the calculation of Lorentz force density distributions for selected modes.
            % Defaults
            % SetMethod ("AKS")
            % SetMeshType ("Hexahedral Mesh")
            % SetMeshAdaptationHex (False)
            % SetMeshAdaptationTet (True)
            % SetNumberOfModes (10)
            % SetModesInFrequencyRange (False)
            % SetFrequencyTarget (False, 0.0)
            % SetLowerBoundForQ (False, 1000)
            % SetMaterialEvaluationFrequency (True, 0.0)
            % SetUseParallelization (True)
            % SetMaxNumberOfThreads (48)
            % SetConsiderLossesInPostprocessingOnly (True)
            % SetOrderTet (2)
            % SetStoreResultsInCache (False)
            % SetTDCompatibleMaterials (False)
            % SetCalculateThermalLosses (True)
            % CalculateLorentzForceForMode: the list of modes is empty.
            % SetConsiderStaticModes (True)
            % SetAccuracy (1e-6)
            % SetQExternalAccuracy (1e-4)
            % SetCalculateExternalQFactor (False)
            obj.AddToHistory(['.StartForceCalculation']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hEigenmodeSolver
        history
        bulkmode

        setmeshadaptationhex
        setmeshadaptationtet
        setnumberofmodes
        setmodesinfrequencyrange
        setconsiderstaticmodes
        setremotecalculation
        setmethod
        setmeshtype
        setmaterialevaluationfrequency
        setfrequencytarget
        setlowerboundforq
        setmaxnumberofthreads
        setuseparallelization
        setconsiderlossesinpostprocessingonly
        setcalculateexternalqfactor
        setqexternalaccuracy
        setordertet
        setstoreresultsincache
        settdcompatiblematerials
        setcalculatethermallosses
        setaccuracy
        getmodefrequencyinhz
        getmoderelresidualnorm
        getmodeqfactor
        getmodeexternalqfactor
        getloadedfrequencyinhz
        getsensitivitydesignparameter
        getfrequencysensitivity
        getqfactorsensitivity
        calculatelorentzforceformode
        ismodeselectedforforcecalculation
    end
end
