%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%% Warning: Untested                                                   %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object controls the asymptotic high frequency solver. Use the 'Start' command to run the solver.
classdef AsymptoticSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a AsymptoticSolver object.
        function obj = AsymptoticSolver(project, hProject)
            obj.project = project;
            obj.hAsymptoticSolver = hProject.invoke('AsymptoticSolver');
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
            % Prepend With AsymptoticSolver and append End With
            obj.history = [ 'With AsymptoticSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define AsymptoticSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['AsymptoticSolver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function SetSolverType(obj, type)
            % This selection specifies whether the solver should use independent rays (SBR) or raytubes (SBR_RAYTUBES). Independent rays are generally more robust for complex geometries, but the performance of the raytube solver is better at higher frequencies for large and relatively smooth objects.
            % type: 'SBR'
            %       'SBR_RAYTUBES'
            obj.AddToHistory(['.SetSolverType "', num2str(type, '%.15g'), '"']);
            obj.setsolvertype = type;
        end
        function SetSolverMode(obj, type)
            % This selection specifies whether the solver should run in Monostatic or Bistatic Scattering, Field source or Range profile mode. For monostatic calculations, the observation angles are identical to the excitation angles. Therefore, for this mode the specification of an observation angle sweep is required only. For bistatic calculations, the excitation and observation angles do not need to be the same. As a consequence, an additional excitation angle sweep needs to be defined when the solver is used in bistatic mode. For field source calculations, no incident plane wave is required, therefore the definition of an observation angle sweep is sufficient. The range profile mode uses similar observation angle definitions as the monostatic mode, but only either single point or single angle sweeps are supported. In case of a single observation point definition, a one dimensional range profile is calculated whereas for two dimensional sweep definitions, a sinogram (range vs. angle) will be generated.
            % type: 'MONOSTATIC_SCATTERING'
            %       'BISTATIC_SCATTERING'
            %       'FIELD_SOURCES'
            %       'RANGE_PROFILES'
            obj.AddToHistory(['.SetSolverMode "', num2str(type, '%.15g'), '"']);
            obj.setsolvermode = type;
        end
        function SetAccuracyLevel(obj, type)
            % This setting allows you to choose from one of the predefined accuracy configurations such as Low,  Medium or High. Low accuracy means that the simulation settings will be optimized for fast simulations whereas High accuracy implies settings optimized for obtaining very accurate results. Typically the Medium accuracy default provides a good compromise between accuracy and simulation speed. In addition to these default configurations, you may also choose Custom which allows specifying more detailed solver options by using the detailed solver control options.
            % type: 'LOW'
            %       'MEDIUM'
            %       'HIGH'
            %       'CUSTOM'
            obj.AddToHistory(['.SetAccuracyLevel "', num2str(type, '%.15g'), '"']);
            obj.setaccuracylevel = type;
        end
        function SetSolverStoreResultsAsTablesOnly(obj, flag)
            % If this option is turned on, the farfield results for all angular points and frequency samples are stored together in an ASCII table rather than in individual graphs for each angle sweep definition. This option is useful if large quantities of results are to be computed, which will then be further processed in other tools. Typical applications include ISAR imaging, etc. Please note that one result table is written for each polarization setting. The result tables can be accessed from the corresponding Navigation Tree item located in 2D/3D Results > ASCII Data. The data files named farfield_<polarization>.txt are stored in the Result folder.
            obj.AddToHistory(['.SetSolverStoreResultsAsTablesOnly "', num2str(flag, '%.15g'), '"']);
            obj.setsolverstoreresultsastablesonly = flag;
        end
        function CalculateRCSMapFor1DSweeps(obj, flag)
            % This parameter is only available for Monostatic Scattering mode. It specifies how one-dimensional angular observation angle sweeps (either sweeping phi or theta) will store the computation results. If this option is turned off, individual farfield results will be computed for every computation frequency. If this option is activated, RCS maps will be calculated instead where each one-dimensional sweep definition will correspond to one set of RCS maps (magnitude, phase) regardless of the number of computation frequencies. The RCS maps therefore contain magnitude or phase information as a function of incident angle and frequency.
            obj.AddToHistory(['.CalculateRCSMapFor1DSweeps "', num2str(flag, '%.15g'), '"']);
            obj.calculatercsmapfor1dsweeps = flag;
        end
        function SetCalculateMonitors(obj, flag)
            % Activate calculation of monitors on 2D Planes (E-Field / H-Field).
            obj.AddToHistory(['.Set "CalculateMonitors", '...
                                   '"', num2str(flag, '%.15g'), '"']);
            obj.setcalculatemonitors = flag;
        end
        function ResetPolarizations(obj)
            % Resets the current excitation polarization list
            obj.AddToHistory(['.ResetPolarizations']);
        end
        function AddHorizontalPolarization(obj, value)
            % This method allows you to add a new horizontal plane wave polarization to the list of excitations. The amplitude of the plane wave electric field vector in V/m is given as an argument.
            obj.AddToHistory(['.AddHorizontalPolarization "', num2str(value, '%.15g'), '"']);
            obj.addhorizontalpolarization = value;
        end
        function AddVerticalPolarization(obj, value)
            % This method allows you to add a new vertical plane wave polarization to the list of excitations. The amplitude of the plane wave electric field vector in V/m is given as an argument.
            obj.AddToHistory(['.AddVerticalPolarization "', num2str(value, '%.15g'), '"']);
            obj.addverticalpolarization = value;
        end
        function AddLHCPolarization(obj, value)
            % This method allows you to add a new left hand side circular plane wave polarization to the list of excitations. The amplitude of the plane wave electric field vector in V/m is given as an argument.
            obj.AddToHistory(['.AddLHCPolarization "', num2str(value, '%.15g'), '"']);
            obj.addlhcpolarization = value;
        end
        function AddRHCPolarization(obj, value)
            % This method allows you to add a new right hand side circular plane wave polarization to the list of excitations. The amplitude of the plane wave electric field vector in V/m is given as an argument.
            obj.AddToHistory(['.AddRHCPolarization "', num2str(value, '%.15g'), '"']);
            obj.addrhcpolarization = value;
        end
        function AddCustomPolarization(obj, ethetare, ethetaim, ephire, ephiim)
            % This method allows you to add a new custom polarization to the list of excitations. The complex amplitudes of the plane wave electric field vector components in V/m are given as arguments.
            obj.AddToHistory(['.AddCustomPolarization "', num2str(ethetare, '%.15g'), '", '...
                                                     '"', num2str(ethetaim, '%.15g'), '", '...
                                                     '"', num2str(ephire, '%.15g'), '", '...
                                                     '"', num2str(ephiim, '%.15g'), '"']);
            obj.addcustompolarization.ethetare = ethetare;
            obj.addcustompolarization.ethetaim = ethetaim;
            obj.addcustompolarization.ephire = ephire;
            obj.addcustompolarization.ephiim = ephiim;
        end
        function SetSolverMaximumNumberOfReflections(obj, value)
            % This parameter specifies the maximum number of ray reflections which will be taken into account for the ray tracing computation.
            obj.AddToHistory(['.SetSolverMaximumNumberOfReflections "', num2str(value, '%.15g'), '"']);
            obj.setsolvermaximumnumberofreflections = value;
        end
        function SetSolverRangeProfilesCenterFrequency(obj, value)
            % This method allows you to specify the center frequency for the range profile and sinogram calculation. Please note that this setting is only effective for the Range profile computation mode.
            obj.AddToHistory(['.SetSolverRangeProfilesCenterFrequency "', num2str(value, '%.15g'), '"']);
            obj.setsolverrangeprofilescenterfrequency = value;
        end
        function SetSolverRangeProfilesAutomatic(obj, flag)
            % This method allows you to specify if the range extend or bandwidth settings will be determined automatically or whether the values set by the respective methods will be taken. Please note that this setting is only effective for the Range profile computation mode.
            obj.AddToHistory(['.SetSolverRangeProfilesAutomatic "', num2str(flag, '%.15g'), '"']);
            obj.setsolverrangeprofilesautomatic = flag;
        end
        function SetSolverRangeProfilesNumberOfSamples(obj, value)
            % This method allows you to specify the number of spectral samples for the range profile or sinogram computation. This value needs to be a power of two larger or equal 16. Please note that this setting is only effective for the Range profile computation mode.
            obj.AddToHistory(['.SetSolverRangeProfilesNumberOfSamples "', num2str(value, '%.15g'), '"']);
            obj.setsolverrangeprofilesnumberofsamples = value;
        end
        function SetSolverRangeProfilesWindowFunction(obj, type)
            % This method allows you to specify the spectral window function being used for calculating range profiles or sinograms. Please note that this setting is only effective for the Range profile computation mode.
            % type: 'RECTANGULAR'
            %       'HANNING'
            %       'HAMMING'
            %       'BLACKMAN'
            obj.AddToHistory(['.SetSolverRangeProfilesWindowFunction "', num2str(type, '%.15g'), '"']);
            obj.setsolverrangeprofileswindowfunction = type;
        end
        function SetSolverRangeProfilesSpecMode(obj, type)
            % This method allows you to specify whether the resolution of the range profile or sinogram calculation shall be specified by either specifying the maximum range extend or by setting the calculation bandwidth around the center frequency. Please note that this setting is only effective for the Range profile computation mode.
            % type: 'RANGE_EXTEND'
            %       'BANDWIDTH'
            obj.AddToHistory(['.SetSolverRangeProfilesSpecMode "', num2str(type, '%.15g'), '"']);
            obj.setsolverrangeprofilesspecmode = type;
        end
        function SetSolverRangeProfilesRangeExtend(obj, value)
            % This method allows you to specify the maximum range extend for the range profile and sinogram calculation if the specification mode is set to RANGE_EXTEND. Please note that this setting is only effective for the Range profile computation mode.
            obj.AddToHistory(['.SetSolverRangeProfilesRangeExtend "', num2str(value, '%.15g'), '"']);
            obj.setsolverrangeprofilesrangeextend = value;
        end
        function SetSolverRangeProfilesBandwidth(obj, value)
            % This method allows you to specify the bandwidth for the range profile and sinogram calculation if the specification mode is set to BANDWIDTH. Please note that this setting is only effective for the Range profile computation mode.
            obj.AddToHistory(['.SetSolverRangeProfilesBandwidth "', num2str(value, '%.15g'), '"']);
            obj.setsolverrangeprofilesbandwidth = value;
        end
        function ResetFrequencyList(obj)
            % Resets the current frequency sweep list.
            obj.AddToHistory(['.ResetFrequencyList']);
        end
        function AddFrequencySweep(obj, fmin, fmax, fstep)
            % This method allows you to add a new frequency sweep definition to the list of frequency sweeps. Each sweep is defined by its lower and upper bounds as well as a step width. You can specify a single frequency point by setting the lower and upper bounds to the same value. Please note that the step width must match with the frequency range such that an integer number of frequency points will be defined.
            obj.AddToHistory(['.AddFrequencySweep "', num2str(fmin, '%.15g'), '", '...
                                                 '"', num2str(fmax, '%.15g'), '", '...
                                                 '"', num2str(fstep, '%.15g'), '"']);
            obj.addfrequencysweep.fmin = fmin;
            obj.addfrequencysweep.fmax = fmax;
            obj.addfrequencysweep.fstep = fstep;
        end
        function ResetExcitationAngleList(obj)
            % Resets the current excitation angle sweep list.
            obj.AddToHistory(['.ResetExcitationAngleList']);
        end
        function AddExcitationAngleSweep(obj, type, thetamin, thetamax, thetastep, phimin, phimax, phistep)
            % This method allows you to add a new angular sweep definition to the list of excitation angle sweeps. The meaning of the angular parameters depends on the type setting:
            % "POINT"
            % Specify a single angular point for this sweep definition. In this case, thetamin must be set equal to thetamax and phimin must be set equal to phimax. The settings for thetastep and phistep have no effect.
            % "THETA"
            % Specify a one dimensional sweep for the theta angle while keeping the phi angle fixed. In this case, phimin must be set equal to phimax. The setting for phistep has no effect.
            % "PHI"
            % Specify a one dimensional sweep for the phi angle while keeping the theta angle fixed. In this case, thetamin must be set equal to thetamax. The setting for thetastep has no effect.
            % "BOTH"
            % Specify a two dimension sweep for both angles theta and phi. For each angle, lower and upper bounds need to be defined. The corresponding step widths must match with the range definition such that an integer number of angular sampling points will be defined.
            % type,: 'POINT'
            %        'THETA'
            %        'PHI'
            %        'BOTH'
            obj.AddToHistory(['.AddExcitationAngleSweep "', num2str(type, '%.15g'), '", '...
                                                       '"', num2str(thetamin, '%.15g'), '", '...
                                                       '"', num2str(thetamax, '%.15g'), '", '...
                                                       '"', num2str(thetastep, '%.15g'), '", '...
                                                       '"', num2str(phimin, '%.15g'), '", '...
                                                       '"', num2str(phimax, '%.15g'), '", '...
                                                       '"', num2str(phistep, '%.15g'), '"']);
            obj.addexcitationanglesweep.type = type;
            obj.addexcitationanglesweep.thetamin = thetamin;
            obj.addexcitationanglesweep.thetamax = thetamax;
            obj.addexcitationanglesweep.thetastep = thetastep;
            obj.addexcitationanglesweep.phimin = phimin;
            obj.addexcitationanglesweep.phimax = phimax;
            obj.addexcitationanglesweep.phistep = phistep;
        end
        function AddExcitationAngleSweepWithRays(obj, type, thetamin, thetamax, thetastep, phimin, phimax, phistep)
            % This method has the same effect as AddExcitationAngleSweep, but in addition the solver will store the rays for each excitation direction for visualization. Please refer to the description of the AddExcitationAngleSweep method for more information. For more information on ray storage, please refer to the asymptotic solver control dialog box description in the online documentation.
            % type,: 'POINT'
            %        'THETA'
            %        'PHI'
            %        'BOTH'
            obj.AddToHistory(['.AddExcitationAngleSweepWithRays "', num2str(type, '%.15g'), '", '...
                                                               '"', num2str(thetamin, '%.15g'), '", '...
                                                               '"', num2str(thetamax, '%.15g'), '", '...
                                                               '"', num2str(thetastep, '%.15g'), '", '...
                                                               '"', num2str(phimin, '%.15g'), '", '...
                                                               '"', num2str(phimax, '%.15g'), '", '...
                                                               '"', num2str(phistep, '%.15g'), '"']);
            obj.addexcitationanglesweepwithrays.type = type;
            obj.addexcitationanglesweepwithrays.thetamin = thetamin;
            obj.addexcitationanglesweepwithrays.thetamax = thetamax;
            obj.addexcitationanglesweepwithrays.thetastep = thetastep;
            obj.addexcitationanglesweepwithrays.phimin = phimin;
            obj.addexcitationanglesweepwithrays.phimax = phimax;
            obj.addexcitationanglesweepwithrays.phistep = phistep;
        end
        function ResetFieldSources(obj)
            % Resets the current field source excitation list.
            obj.AddToHistory(['.ResetFieldSources']);
        end
        function SetFieldSourceActive(obj, fieldsourcename, flag)
            % This method allows you to specify whether the field source should be used for calculation. If the flag is set to False, the field source will not take part in any computation.
            obj.AddToHistory(['.SetFieldSourceActive "', num2str(fieldsourcename, '%.15g'), '", '...
                                                    '"', num2str(flag, '%.15g'), '"']);
            obj.setfieldsourceactive.fieldsourcename = fieldsourcename;
            obj.setfieldsourceactive.flag = flag;
        end
        function SetFieldSourcePhasor(obj, fieldsourcename, amplitude, phase)
            % This method allows you to define the amplitude and phase shift which should be applied to a previously defined field source.
            obj.AddToHistory(['.SetFieldSourcePhasor "', num2str(fieldsourcename, '%.15g'), '", '...
                                                    '"', num2str(amplitude, '%.15g'), '", '...
                                                    '"', num2str(phase, '%.15g'), '"']);
            obj.setfieldsourcephasor.fieldsourcename = fieldsourcename;
            obj.setfieldsourcephasor.amplitude = amplitude;
            obj.setfieldsourcephasor.phase = phase;
        end
        function SetFieldSourceRays(obj, fieldsourcename, flag)
            % This method allows you to specify whether the rays should be stored for a previously defined field source. For more information on ray storage, please refer to the asymptotic solver control dialog box description in the online documentation.
            obj.AddToHistory(['.SetFieldSourceRays "', num2str(fieldsourcename, '%.15g'), '", '...
                                                  '"', num2str(flag, '%.15g'), '"']);
            obj.setfieldsourcerays.fieldsourcename = fieldsourcename;
            obj.setfieldsourcerays.flag = flag;
        end
        function SimultaneousFieldSourceExcitation(obj, flag)
            % If this flag is set to True, all field sources are excited simultaneously. In this case only one farfield result will be calculated which contains the superposition of all field sources. If this flag is set to False, a sequence of calculations will be performed where only one field source is active for each run. The default setting is to perform a simultaneous excitation.
            obj.AddToHistory(['.SimultaneousFieldSourceExcitation "', num2str(flag, '%.15g'), '"']);
            obj.simultaneousfieldsourceexcitation = flag;
        end
        function SetCalculateSParameters(obj, flag)
            % Check this option to calculate antenna coupling coefficients between activated nearfield or farfield sources. The results are calculated as F-Parameters as described in farfield source and nearfield source. Note that this option is only available for sequential field source excitation.
            obj.AddToHistory(['.Set "CalculateSParameters", '...
                                   '"', num2str(flag, '%.15g'), '"']);
            obj.setcalculatesparameters = flag;
        end
        function ResetObservationAngleList(obj)
            % Resets the current observation angle sweep list.
            obj.AddToHistory(['.ResetObservationAngleList']);
        end
        function AddObservationAngleSweep(obj, type, thetamin, thetamax, thetastep, phimin, phimax, phistep)
            % This method allows you to add a new angular sweep definition to the list of observation angle sweeps. The meaning of the angular parameters depends on the type setting:
            % "POINT"
            % Specify a single angular point for this sweep definition. In this case, thetamin must be set equal to thetamax and phimin must be set equal to phimax. The settings for thetastep and phistep have no effect.
            % "THETA"
            % Specify a one dimensional sweep for the theta angle while keeping the phi angle fixed. In this case, phimin must be set equal to phimax. The setting for phistep has no effect.
            % "PHI"
            % Specify a one dimensional sweep for the phi angle while keeping the theta angle fixed. In this case, thetamin must be set equal to thetamax. The setting for thetastep has no effect.
            % "BOTH"
            % Specify a two dimension sweep for both angles theta and phi. For each angle, lower and upper bounds need to be defined. The corresponding step widths must match with the range definition such that an integer number of angular sampling points will be defined.
            % type,: 'POINT'
            %        'THETA'
            %        'PHI'
            %        'BOTH'
            obj.AddToHistory(['.AddObservationAngleSweep "', num2str(type, '%.15g'), '", '...
                                                        '"', num2str(thetamin, '%.15g'), '", '...
                                                        '"', num2str(thetamax, '%.15g'), '", '...
                                                        '"', num2str(thetastep, '%.15g'), '", '...
                                                        '"', num2str(phimin, '%.15g'), '", '...
                                                        '"', num2str(phimax, '%.15g'), '", '...
                                                        '"', num2str(phistep, '%.15g'), '"']);
            obj.addobservationanglesweep.type = type;
            obj.addobservationanglesweep.thetamin = thetamin;
            obj.addobservationanglesweep.thetamax = thetamax;
            obj.addobservationanglesweep.thetastep = thetastep;
            obj.addobservationanglesweep.phimin = phimin;
            obj.addobservationanglesweep.phimax = phimax;
            obj.addobservationanglesweep.phistep = phistep;
        end
        function AddObservationAngleSweepWithRays(obj, type, thetamin, thetamax, thetastep, phimin, phimax, phistep)
            % This method has the same effect as AddObservationAngleSweep, but in addition the solver will store the rays for each excitation direction for visualization. Please refer to the description of the AddObservationAngleSweep method for more information. For more information on ray storage, please refer to the asymptotic solver control dialog box description in the online documentation.
            % type,: 'POINT'
            %        'THETA'
            %        'PHI'
            %        'BOTH'
            obj.AddToHistory(['.AddObservationAngleSweepWithRays "', num2str(type, '%.15g'), '", '...
                                                                '"', num2str(thetamin, '%.15g'), '", '...
                                                                '"', num2str(thetamax, '%.15g'), '", '...
                                                                '"', num2str(thetastep, '%.15g'), '", '...
                                                                '"', num2str(phimin, '%.15g'), '", '...
                                                                '"', num2str(phimax, '%.15g'), '", '...
                                                                '"', num2str(phistep, '%.15g'), '"']);
            obj.addobservationanglesweepwithrays.type = type;
            obj.addobservationanglesweepwithrays.thetamin = thetamin;
            obj.addobservationanglesweepwithrays.thetamax = thetamax;
            obj.addobservationanglesweepwithrays.thetastep = thetastep;
            obj.addobservationanglesweepwithrays.phimin = phimin;
            obj.addobservationanglesweepwithrays.phimax = phimax;
            obj.addobservationanglesweepwithrays.phistep = phistep;
        end
        function UseParallelization(obj, flag)
            % Enable or disable parallelization (multithreading) for the asymptotic solver.  
            obj.AddToHistory(['.UseParallelization "', num2str(flag, '%.15g'), '"']);
            obj.useparallelization = flag;
        end
        function MaximumNumberOfThreads(obj, number)
            % Define the maximum number of parallel threads to be used for the asymptotic solver run.
            obj.AddToHistory(['.MaximumNumberOfThreads "', num2str(number, '%.15g'), '"']);
            obj.maximumnumberofthreads = number;
        end
        function RemoteCalculation(obj, flag)
            % Enable or disable remote calculation for the asymptotic solver. When enabled, an asymptotic solver run is submitted to the network instead of performing the calculation locally. Please note that activating remote calculation turns off other distributed computing options. The setting does not influence parameter sweeps and optimizer runs with distributed computing.
            obj.AddToHistory(['.RemoteCalculation "', num2str(flag, '%.15g'), '"']);
            obj.remotecalculation = flag;
        end
        function DistributedComputing(obj, flag)
            % Enable or disable distributed computing for the asymptotic solver. When enabled, an asymptotic solver run will be subdivided into a number of distributed computing jobs as specified by the DistributedComputingNodes setting. Each job will then handle a certain subset of excitation directions.  Please note that activating distributed computing turns off other remote calculation options. The setting does not influence parameter sweeps and optimizer runs with distributed computing.
            obj.AddToHistory(['.DistributedComputing "', num2str(flag, '%.15g'), '"']);
            obj.distributedcomputing = flag;
        end
        function DistributedComputingNodes(obj, number)
            % Define the maximum number of computing nodes to be used for distributed computing of excitation directions. This setting will also determine the number of jobs to be submitted for a single asymptotic solver run.
            obj.AddToHistory(['.DistributedComputingNodes "', num2str(number, '%.15g'), '"']);
            obj.distributedcomputingnodes = number;
        end
        function int = Start(obj)
            % Starts the solver with the current settings and returns 1 if the calculation is successfully finished and 0 if it failed.
            int = obj.hAsymptoticSolver.invoke('Start');
        end
        %% Detailed Solver Control Options
        % Please note that these settings will only take effect if the AccuracyLevel is set to Custom. Otherwise these settings will be overridden by the values given by the predefined accuracy levels.
        function SetSolverIncludeMetallicEdgeDiffraction(obj, flag)
            % This option specifies whether diffraction at edges should be included in the simulation which will improve the accuracy at the expense of longer simulation times. It is generally recommended to turn this option on for more accurate results.
            obj.AddToHistory(['.SetSolverIncludeMetallicEdgeDiffraction "', num2str(flag, '%.15g'), '"']);
            obj.setsolverincludemetallicedgediffraction = flag;
        end
        function SetMeshMaxWedgeLengthPerLambda(obj, value)
            % This option controls the maximum length of the generated segments for edge diffraction. Smaller values increase the accuracy of the edge diffraction contributions but also lead to a longer runtime. This option is only available if the option SetSolverIncludeMetallicEdgeDiffraction is activated.
            obj.AddToHistory(['.Set "MeshMaxWedgeLengthPerLambda", '...
                                   '"', num2str(value, '%.15g'), '"']);
            obj.setmeshmaxwedgelengthperlambda = value;
        end
        function SetSolverExitBlockageCheck(obj, flag)
            % This option specifies whether the visibility of a reflection point for a particular ray from the current observation point will be checked or not. For better accuracy it is recommended to turn this option on. In some cases it may be useful to turn this option off in order to quickly obtain potentially less accurate results.
            obj.AddToHistory(['.SetSolverExitBlockageCheck "', num2str(flag, '%.15g'), '"']);
            obj.setsolverexitblockagecheck = flag;
        end
        function StoreResultsInCache(obj, flag)
            % Stores results of the asymptotic solver in the result cache.
            obj.AddToHistory(['.StoreResultsInCache "', num2str(flag, '%.15g'), '"']);
            obj.storeresultsincache = flag;
        end
        function StorePOResults(obj, flag)
            % This option controls whether the first order PO farfields are calculated in addition to the total farfields including all multiple reflection and diffraction effects. Comparing the two sets of results can be used for checking the influence of the higher order effects on the solution. This option is only available for the Monostatic and Bistatic scattering modes.
            obj.AddToHistory(['.StorePOResults "', num2str(flag, '%.15g'), '"']);
            obj.storeporesults = flag;
        end
        function SetMeshCurved(obj, flag)
            % This setting specifies whether the mesh triangles will be curved for a better representation of non-planar geometries. If this option is set to false, the mesh will be created such that it consists of planar triangles only. Using curved triangles will usually improve accuracy, at the expense of a little bit higher memory consumption and longer simulation times.
            obj.AddToHistory(['.SetMeshCurved "', num2str(flag, '%.15g'), '"']);
            obj.setmeshcurved = flag;
        end
        function SetMeshUseCurvatureExtraction(obj, flag)
            % This setting specifies whether the curvature information should be extracted out of the input data. This is especially helpful when the model has been imported from a file format that does not provide surface normal information like, e.g., NASTRAN or STL. This option is only available if the option SetMeshCurved is activated.
            obj.AddToHistory(['.Set "MeshUseCurvatureExtraction", '...
                                   '"', num2str(flag, '%.15g'), '"']);
            obj.setmeshusecurvatureextraction = flag;
        end
        function SetMeshNormalTolerance(obj, value)
            % This parameter specifies the maximum allowable tolerance of the (planar) triangle normals as compared to the true normals of the structure's geometry. Lower settings will lead to a more accurate geometrical representation at the expense of generating more triangles. If this parameter is set to zero, no constraint concerning the normal tolerance will be applied during the mesh generation.
            obj.AddToHistory(['.SetMeshNormalTolerance "', num2str(value, '%.15g'), '"']);
            obj.setmeshnormaltolerance = value;
        end
        function SetMeshSurfaceTolerance(obj, value)
            % This parameter specifies the maximum allowable deviation of the (planar) triangle from the actual geometry in model dimensions. Lower settings will lead to a more accurate geometrical representation at the expense of generating more triangles. If this parameter is set to zero, no constraint concerning the surface tolerance will be applied during the mesh generation.
            obj.AddToHistory(['.SetMeshSurfaceTolerance "', num2str(value, '%.15g'), '"']);
            obj.setmeshsurfacetolerance = value;
        end
        function SetMeshMaxEdgeLengthPerLambda(obj, value)
            % This setting specifies the maximum allowable length of the triangle edges as compared to the wave length of the upper frequency limit as it is specified globally. This parameter has a strong influence on the number of triangles generated for a particular mesh. The solver run time will suffer from drastically varying triangle sizes, so extreme settings should be avoided.
            obj.AddToHistory(['.SetMeshMaxEdgeLengthPerLambda "', num2str(value, '%.15g'), '"']);
            obj.setmeshmaxedgelengthperlambda = value;
        end
        function SetMeshMaxEdgeLengthPerDiagonal(obj, value)
            % This setting specifies the maximum allowable length of the triangle edges as compared to the size of the structure (bounding box diagonal). This parameter has a strong influence on the number of triangles generated for a particular mesh. The solver run time will suffer from drastically varying triangle sizes, so extreme settings should be avoided.
            obj.AddToHistory(['.SetMeshMaxEdgeLengthPerDiagonal "', num2str(value, '%.15g'), '"']);
            obj.setmeshmaxedgelengthperdiagonal = value;
        end
        function SetSolverAllowStorageOfIncidentRays(obj, flag)
            % This option controls whether the incident rays will be stored if the corresponding rays option is set for the excitation. If this option is turned off, ray storage will be suppressed for all incident rays.
            obj.AddToHistory(['.SetSolverAllowStorageOfIncidentRays "', num2str(flag, '%.15g'), '"']);
            obj.setsolverallowstorageofincidentrays = flag;
        end
        function SetSolverAllowStorageOfInitialHits(obj, flag)
            % This option controls whether the points where the incident rays hit the structure will be stored if the corresponding rays option is set for the excitation. If this option is turned off, the initial hit point storage will be suppressed for all incident rays.
            obj.AddToHistory(['.SetSolverAllowStorageOfInitialHits "', num2str(flag, '%.15g'), '"']);
            obj.setsolverallowstorageofinitialhits = flag;
        end
        function SetSolverAllowStorageOfObservedRays(obj, flag)
            % This option controls whether the scattered rays will be stored if the corresponding rays option is set for the excitation as well as the observation direction. If this option is turned off, scattered ray storage will be suppressed.
            obj.AddToHistory(['.SetSolverAllowStorageOfObservedRays "', num2str(flag, '%.15g'), '"']);
            obj.setsolverallowstorageofobservedrays = flag;
        end
        function SetSolverMaximumNumberOfIncidentRaysOutput(obj, value)
            % This option allows you to set an upper limit for the number of incident rays being stored per direction and per reflection level. This option is important in order to avoid storing huge files which may slow down the computation tremendously. Please note that this limit is set for each reflection level independently. Therefore, a limit of e.g. 1000 means that up to 1000 rays will be stored which do not intersect with the structure, another up to 1000 rays will be stored which are reflected once and so on.
            obj.AddToHistory(['.SetSolverMaximumNumberOfIncidentRaysOutput "', num2str(value, '%.15g'), '"']);
            obj.setsolvermaximumnumberofincidentraysoutput = value;
        end
        function SetSolverMaximumNumberOfInitialHitsOutput(obj, value)
            % This option allows you to set an upper limit for the number of points where the incident rays hit the structure being stored per excitation.
            obj.AddToHistory(['.SetSolverMaximumNumberOfInitialHitsOutput "', num2str(value, '%.15g'), '"']);
            obj.setsolvermaximumnumberofinitialhitsoutput = value;
        end
        function SetSolverMaximumNumberOfObservedRaysOutput(obj, value)
            % This option allows you to set an upper limit for the number of scattered rays being stored per incident direction and per reflection level. This option is important in order to avoid storing huge files which may slow down the computation tremendously. Please note that this limit is set for each incident direction and reflection level independently.
            obj.AddToHistory(['.SetSolverMaximumNumberOfObservedRaysOutput "', num2str(value, '%.15g'), '"']);
            obj.setsolvermaximumnumberofobservedraysoutput = value;
        end
        function SetSolverObservedRaysAngleTolerance(obj, value)
            % This option allows you to set an angular tolerance for the scattered rays which will be used for assigning these rays to a particular observation angle. This setting will only be considered when the AccuracyLevel is set to Custom.
            obj.AddToHistory(['.SetSolverObservedRaysAngleTolerance "', num2str(value, '%.15g'), '"']);
            obj.setsolverobservedraysangletolerance = value;
        end
        function SetSolverRayOutputAmplitude(obj, flag)
            % This option enables computation of ray amplitudes along the visualized ray paths. The ray amplitudes are computed at the intersection points between ray path and object according to the laws of geometrical optics. In the region between two intersection points the ray amplitude is linearly interpolated and thus incorrect - please note that the focus of the generated results is merely on giving an overview of a ray path's importance. Please use nearfield monitors or field probes to obtain proper field values in free space.
            obj.AddToHistory(['.Set "SolverRayOutputAmplitude", '...
                                   '"', num2str(flag, '%.15g'), '"']);
            obj.setsolverrayoutputamplitude = flag;
        end
        function SetSolverShowEntireRayPath(obj, flag)
            % This option enables storage of entire ray paths. If this option is deactivated, only the transmitted ray path is stored at transparent material boundaries, as it is usually the one that carries most of the ray's energy. If this option is activated, all reflected and transmitted ray paths will be stored.
            obj.AddToHistory(['.Set "SolverShowEntireRayPath", '...
                                   '"', num2str(flag, '%.15g'), '"']);
            obj.setsolvershowentireraypath = flag;
        end
        function SetSolverAllowHotspots(obj, flag)
            % This checkbox specifies whether contributions stemming from direct ray-reflections are considered for the hotspot calculation. Toghether with the next option, consider higher order contributions, this allows you to gain a detailed insight where hotspot contributions are coming from.
            obj.AddToHistory(['.SetSolverAllowHotspots "', num2str(flag, '%.15g'), '"']);
            obj.setsolverallowhotspots = flag;
        end
        function SetSolverAllowHOHotspots(obj, flag)
            % This checkbox specifies whether higher-order contributions, stemming from multiple ray-reflections, are considered for hotspot calculations.
            obj.AddToHistory(['.SetSolverAllowHOHotspots "', num2str(flag, '%.15g'), '"']);
            obj.setsolverallowhohotspots = flag;
        end
        function SetSolverHotspotNumberOfPixels(obj, value)
            % This value sets the resolution for the visualization image, i.e. the number of pixels in each spatial direction.
            obj.AddToHistory(['.SetSolverHotspotNumberOfPixels "', num2str(value, '%.15g'), '"']);
            obj.setsolverhotspotnumberofpixels = value;
        end
        function SetSolverHotspotAngularRange(obj, value)
            % This value sets the maximum angular range (angle between observation direction and reflected ray) for which specular contributions will be evaluated. This allows you to hide contributions that don't originate from reflections in the observers' direction. Its effect resembles that of an aperture. A small value (greater than 0�) only selects contributions going in the observer's direction. A setting of 180� includes all contributions, resembling an open aperture.
            obj.AddToHistory(['.SetSolverHotspotAngularRange "', num2str(value, '%.15g'), '"']);
            obj.setsolverhotspotangularrange = value;
        end
        function SetSolverHotspotWeightingExponent(obj, value)
            % This factor pronounces specular contributions that originate from reflections going in the observers' direction and diminishes those from reflections in other directions. This option allows you to fine-tune the image-contrast. When set to 0, no contrast enhancement is performed, higher values lead to a more pronounced contrast. To highlight hotspots in the observer's direction a value of 5 is a good choice.
            obj.AddToHistory(['.SetSolverHotspotWeightingExponent "', num2str(value, '%.15g'), '"']);
            obj.setsolverhotspotweightingexponent = value;
        end
        function SetSolverHotspotHOAngularRange(obj, value)
            % This value sets the maximum angular range (angle between observation direction and reflected ray) for which higher-order contributions will be evaluated. This allows you to hide contributions that don't originate from reflections in the observers' direction. Its effect resembles that of an aperture. A small value (greater than 0�) only selects contributions going in the observer's direction. A setting of 180� includes all contributions, resembling an open aperture.
            obj.AddToHistory(['.SetSolverHotspotHOAngularRange "', num2str(value, '%.15g'), '"']);
            obj.setsolverhotspothoangularrange = value;
        end
        function SetSolverHotspotHOWeightingExponent(obj, value)
            % This factor pronounces higher-order contributions that originate from reflections going in the observers' direction and diminishes those from reflections in other directions. This option allows you to fine-tune the image-contrast. When set to 0, no contrast enhancement is performed, higher values lead to a more pronounced contrast. To highlight hotspots in the observer's direction a value of 5 is a good choice.
            obj.AddToHistory(['.SetSolverHotspotHOWeightingExponent "', num2str(value, '%.15g'), '"']);
            obj.setsolverhotspothoweightingexponent = value;
        end
        function SetNearfieldPartitioningAccuracy(obj, value)
            % This setting specifies how sub sources are chosen for illumination of the scattering object: the size of the sub sources used to illuminate a particular part of the scattering object is adjusted to fulfil the farfield criterion R > accuracy*2*D�/?, where accuracy is the current setting. If this value is set to zero, sub sources are not used. Instead, the whole field distribution is modeled as a single point source.
            obj.AddToHistory(['.Set "NearfieldPartitioningAccuracy", '...
                                   '"', num2str(value, '%.15g'), '"']);
            obj.setnearfieldpartitioningaccuracy = value;
        end
        function SetNearfieldRadiatedPowerInaccuracy(obj, value)
            % To save computation time, a certain amount of sub sources can be neglected for scattered field calculation. This value specifies the tolerated error as a fraction of the power radiated by the nearfield source.
            obj.AddToHistory(['.Set "NearfieldRadiatedPowerInaccuracy", '...
                                   '"', num2str(value, '%.15g'), '"']);
            obj.setnearfieldradiatedpowerinaccuracy = value;
        end
        function SetNearfieldPartitionSize(obj, value)
            % This value sets the smallest possible diameter of the sub sources in terms of the smallest simulated wavelength. A smaller value results in a more accurate representation of the total nearfield distribution at the expense of increased runtime.
            obj.AddToHistory(['.Set "NearfieldPartitionSize", '...
                                   '"', num2str(value, '%.15g'), '"']);
            obj.setnearfieldpartitionsize = value;
        end
        function SetNearfieldDoNearfieldEvaluations(obj, flag)
            % With this option, portions of the field source very close to the scattering target (closer than ?) are not simply represented by their farfield pattern: the radial parts of the field impinging on the scatterer are also considered. This considerably increases accuracy in the shadow zones. Please note that this option may strongly increase simulation time.
            obj.AddToHistory(['.Set "NearfieldDoNearfieldEvaluations", '...
                                   '"', num2str(flag, '%.15g'), '"']);
            obj.setnearfielddonearfieldevaluations = flag;
        end
        function SetNearfieldExclusionBoundaries(obj, flag)
            % This value is useful to include blockage effects of the structure inside the NFS bounding box (internal structure). The internal structure is only illuminated by the field that is scattered back from the external structure. Please be aware that this option does only work as expected if the NFS bounding box does not touch or cross any materials.
            obj.AddToHistory(['.Set "NearfieldExclusionBoundaries", '...
                                   '"', num2str(flag, '%.15g'), '"']);
            obj.setnearfieldexclusionboundaries = flag;
        end
        %% Detailed Solver Control Options specific to SBR_RAYTUBES Solver
        % Please note that these settings will only take effect if the AccuracyLevel is set to Custom. Otherwise these settings will be overridden by the values given by the predefined accuracy levels.
        function SetSolverRaySpacingRT(obj, value)
            % This parameter specifies the distance in between the rays launched in wavelengths. This setting will only be considered when the AccuracyLevel is set to Custom. Please note that this setting is only valid for the SBR_RAYTUBES solver.
            obj.AddToHistory(['.SetSolverRaySpacingRT "', num2str(value, '%.15g'), '"']);
            obj.setsolverrayspacingrt = value;
        end
        function SetSolverAdaptiveRaySubdivisionRT(obj, flag)
            % This option specifies whether the ray tubes shall be automatically refined when needed. The actual refinement is controlled by the two parameters SetSolverMaximumRayDistanceRT and SetSolverMinimumRayDistanceRT. This setting will only be considered when the AccuracyLevel is set to Custom. Please note that this setting is only valid for the SBR_RAYTUBES solver.
            obj.AddToHistory(['.SetSolverAdaptiveRaySubdivisionRT "', num2str(flag, '%.15g'), '"']);
            obj.setsolveradaptiveraysubdivisionrt = flag;
        end
        function SetSolverMaximumRayDistanceRT(obj, value)
            % This parameter controls the maximum edge length of a ray tube before it gets automatically refined. This setting will only be considered when the AccuracyLevel is set to Custom and the SetSolverAdaptiveRaySubdivisionRT option is active. Please note that this setting is only valid for the SBR_RAYTUBES solver.
            obj.AddToHistory(['.SetSolverMaximumRayDistanceRT "', num2str(value, '%.15g'), '"']);
            obj.setsolvermaximumraydistancert = value;
        end
        function SetSolverMinimumRayDistanceRT(obj, value)
            % This parameter controls the minimum edge length of a ray tube which can be further refined automatically. This setting is needed in order to avoid excessive refinement of ray tubes at discontinuities. This setting will only be considered when the AccuracyLevel is set to Custom and the SetSolverAdaptiveRaySubdivisionRT option is active. Please note that this setting is only valid for the SBR_RAYTUBES solver.
            obj.AddToHistory(['.SetSolverMinimumRayDistanceRT "', num2str(value, '%.15g'), '"']);
            obj.setsolverminimumraydistancert = value;
        end
        function SetSolverMinimumNumberOfRaysRT(obj, value)
            % For electrically smaller structures, there may be too few rays launched due to the Ray density / wavelength setting. In order to ensure that a reasonable number of rays are launched to properly illuminate all regions of the structure, this parameter defines a lower bound for the number of rays. For more accurate simulations of electrically not very large structures you may need to increase this parameter. This setting will only be considered when the AccuracyLevel is set to Custom. Please note that this setting is only valid for the SBR_RAYTUBES solver.
            obj.AddToHistory(['.SetSolverMinimumNumberOfRaysRT "', num2str(value, '%.15g'), '"']);
            obj.setsolverminimumnumberofraysrt = value;
        end
        function Solver = Detailed(obj)
            % Please note that these settings will only take effect if the AccuracyLevel is set to Custom. Otherwise these settings will be overridden by the values given by the predefined accuracy levels.
            Solver = obj.hAsymptoticSolver.invoke('Detailed');
        end
        function SetSolverRayDensityPerLambda(obj, value)
            % This parameter specifies the number of rays which are launched per wavelength of the actual simulation frequency. For electrically smaller structures, this parameter may need to be increased in order to achieve a better accuracy. Typical values are in between 10 for electrically very large structures and 40 or more for electrically not very large structures. This parameter is the main parameter to vary for controlling solver accuracy and performance. This setting will only be considered when the AccuracyLevel is set to Custom. Please note that this setting is only valid for the SBR solver.
            obj.AddToHistory(['.SetSolverRayDensityPerLambda "', num2str(value, '%.15g'), '"']);
            obj.setsolverraydensityperlambda = value;
        end
        function SetSolverMaxAreaOfRayTube(obj, value)
            % This parameter controls the maximum ray tube cross section for consideration of a particular beam for the scattered field computation. The scattering results become inaccurate for beams with very large cross sections, therefore it makes sense not to consider these beams since their contribution will be very small anyway. This setting will only be considered when the AccuracyLevel is set to Custom. Please note that this setting is only valid for the SBR solver.
            obj.AddToHistory(['.SetSolverMaxAreaOfRayTube "', num2str(value, '%.15g'), '"']);
            obj.setsolvermaxareaofraytube = value;
        end
        function SetSolverMinimumNumberOfRays(obj, value)
            % For electrically smaller structures, there may be too few rays launched due to the Ray density / wavelength setting. In order to ensure that a reasonable number of rays are launched to properly illuminate all regions of the structure, this parameter defines a lower bound for the number of rays. For more accurate simulations of electrically not very large structures you may need to increase this parameter. This setting will only be considered when the AccuracyLevel is set to Custom. Please note that this setting is only valid for the SBR solver.
            obj.AddToHistory(['.SetSolverMinimumNumberOfRays "', num2str(value, '%.15g'), '"']);
            obj.setsolverminimumnumberofrays = value;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hAsymptoticSolver
        history
        bulkmode

        setsolvertype
        setsolvermode
        setaccuracylevel
        setsolverstoreresultsastablesonly
        calculatercsmapfor1dsweeps
        setcalculatemonitors
        addhorizontalpolarization
        addverticalpolarization
        addlhcpolarization
        addrhcpolarization
        addcustompolarization
        setsolvermaximumnumberofreflections
        setsolverrangeprofilescenterfrequency
        setsolverrangeprofilesautomatic
        setsolverrangeprofilesnumberofsamples
        setsolverrangeprofileswindowfunction
        setsolverrangeprofilesspecmode
        setsolverrangeprofilesrangeextend
        setsolverrangeprofilesbandwidth
        addfrequencysweep
        addexcitationanglesweep
        addexcitationanglesweepwithrays
        setfieldsourceactive
        setfieldsourcephasor
        setfieldsourcerays
        simultaneousfieldsourceexcitation
        setcalculatesparameters
        addobservationanglesweep
        addobservationanglesweepwithrays
        useparallelization
        maximumnumberofthreads
        remotecalculation
        distributedcomputing
        distributedcomputingnodes
        setsolverincludemetallicedgediffraction
        setmeshmaxwedgelengthperlambda
        setsolverexitblockagecheck
        storeresultsincache
        storeporesults
        setmeshcurved
        setmeshusecurvatureextraction
        setmeshnormaltolerance
        setmeshsurfacetolerance
        setmeshmaxedgelengthperlambda
        setmeshmaxedgelengthperdiagonal
        setsolverallowstorageofincidentrays
        setsolverallowstorageofinitialhits
        setsolverallowstorageofobservedrays
        setsolvermaximumnumberofincidentraysoutput
        setsolvermaximumnumberofinitialhitsoutput
        setsolvermaximumnumberofobservedraysoutput
        setsolverobservedraysangletolerance
        setsolverrayoutputamplitude
        setsolvershowentireraypath
        setsolverallowhotspots
        setsolverallowhohotspots
        setsolverhotspotnumberofpixels
        setsolverhotspotangularrange
        setsolverhotspotweightingexponent
        setsolverhotspothoangularrange
        setsolverhotspothoweightingexponent
        setnearfieldpartitioningaccuracy
        setnearfieldradiatedpowerinaccuracy
        setnearfieldpartitionsize
        setnearfielddonearfieldevaluations
        setnearfieldexclusionboundaries
        setsolverrayspacingrt
        setsolveradaptiveraysubdivisionrt
        setsolvermaximumraydistancert
        setsolverminimumraydistancert
        setsolverminimumnumberofraysrt
        setsolverraydensityperlambda
        setsolvermaxareaofraytube
        setsolverminimumnumberofrays
    end
end
