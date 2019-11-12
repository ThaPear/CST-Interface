%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef FDSolver < handle
    properties(SetAccess = protected)
        project
        hFDSolver
        history
        bulkmode
        
        acceleratedrestart
        accuracytet
        accuracysrf
        accuracyhex
        accuracyrom
        storeallresults
        storesolutioncoefficients
        createlegacy1dsignals
        openbctypehex
        openbctypetet
        addmonitorsamples
        frequencysamples
        meshadaptionhex
        meshadaptiontet
        usehelmholtzequation
        maxiterations
        limititerations
        modesonly
        shieldallports
        portmeshmatches3dmeshtet
        allowromportmodesolver
        allowdiscreteportsolver
        useromportmodesolvertetgeneralpurpose, useromportmodesolvertetfastreducedordermodel
        enablenativesingleended
        usedeembeddedfields
        freqdistadaptmode
        preferleanoutput
        useimplineimpedanceasreference
        useorientportwithmask
        considerportlossestet
        stopsweepifcriterionmet
        sweepthresholdtype, sweepthresholdthreshold
        usesweepthreshold, usesweepthresholdtype
        type
        storeresultsincache
        methodmesh, methodsweep
        autonormimpedance
        normingimpedance
        stimulationport, stimulationmode
        sweeperrorchecks
        sweepminimumsamples
        sweepconsiderall
        sweepconsiderspars
        numberofresultdatasamples
        resultdatasamplingmode
        extrudeopenbc
        tdcompatiblematerials
        calcstatbfield
        calcpowerloss
        calcpowerlosspercomponent
        usegreensandyferritemodel
        greensandythresoldh
        excitationlist
        useparallelization
        maxcpus
        maximumnumberofcpudevices
        sweepweightevanescent
        lowfrequencystabilization
        ordertet
        mixedordertet
        ordersrf
        mixedordersrf
        usedistributedcomputing
        networkcomputingstrategy
        networkcomputingjobcount
        usesensitivityanalysis
        usedoubleprecision
        preconditioneraccuracyinteq
        minmlfmmboxsize
        mlfmmaccuracy
        usecfieforcpecinteq
        usefastrcssweepinteq
        mrcssweepproperties
        write3dfieldsforfarfieldcalc
        recordunitcellscanfarfield
        considerunitcellscanfarfield
        considerunitcellscanfarfieldsymmetry
        disableresulttemplatesduringunitcellanglesweep
        
        interpolationsamples
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Component object.
        function obj = FDSolver(project, hProject)
            obj.project = project;
            obj.hFDSolver = hProject.invoke('FDSolver');
            
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
            
            % Prepend With and append End With
            obj.history = [ 'With FDSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define frequency domain solver parameters'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['FDSolver', command]);
            end
        end
        
        function Reset(obj)
            % Resets all previously made settings concerning the solver to
            % the default values.
            obj.AddToHistory(['.Reset']);
            
            obj.numberofresultdatasamples = 1001;
            obj.openbctypetet = 'Default';
        end
        function success = Start(obj)
            % Starts the solver with the current settings and returns 1 if
            % the calculation is successfully finished and 0 if it failed.
            success = obj.hFDSolver.invoke('Start');
        end
        function AcceleratedRestart(obj, boolean)
            % If activated, the frequency domain solver with hexahedral or
            % tetrahedral mesh stores a subset of the results from
            % frequency samples calculated so far in order to reuse this
            % information for an accelerated recalculation of additional
            % frequency samples in subsequent solver runs. Since a direct
            % equation system solver does not profit from a good initial
            % guess to the solution, this mainly applies to the iterative
            % solver. However, you may try to calculate some frequency
            % samples using the direct solver, and continue with the
            % iterative solver, thereby taking into account solutions from
            % the direct solver to speed up the simulation.
            obj.AddToHistory(['.AcceleratedRestart "', num2str(boolean), '"']);
            obj.acceleratedrestart = boolean;
        end
        function AccuracyTet(obj, value)
            % Specifies the desired accuracy for the tetrahedral frequency
            % domain solver in terms of the relative residual norm of the
            % linear equation system solver. The accuracy value may be
            % chosen from the range 1e-3 down to 1e-12, where 1e-12
            % correspond to the highest accuracy level.
            obj.AddToHistory(['.AccuracyTet "', num2str(value), '"']);
            obj.accuracytet = value;
        end
        function AccuracySrf(obj, value)
            % Specifies the desired accuracy for the tetrahedral frequency
            % domain solver in terms of the relative residual norm of the
            % linear equation system solver. The accuracy value may be
            % chosen from the range 1e-3 down to 1e-12, where 1e-12
            % correspond to the highest accuracy level.
            obj.AddToHistory(['.AccuracySrf "', num2str(value), '"']);
            obj.accuracysrf = value;
        end
        function AccuracyHex(obj, value)
            % Specifies the desired accuracy for the hexahedral frequency
            % domain solver in terms of the relative residual norm of the
            % linear equation system solver. The accuracy value may be
            % chosen from the range 1e-3 down to 1e-12, where 1e-12
            % correspond to the highest accuracy level.
            obj.AddToHistory(['.AccuracyHex "', num2str(value), '"']);
            obj.accuracyhex = value;
        end
        function AccuracyROM(obj, value)
            % Specifies the desired accuracy of the reduced order model
            % (ROM) for the tetrahedral frequency domain solver with fast
            % reduced order model sweep. The accuracy value may be chosen
            % from the range 1e-3 down to 1e-12, where 1e-12 correspond to
            % the highest accuracy level.
            obj.AddToHistory(['.AccuracyROM "', num2str(value), '"']);
            obj.accuracyrom = value;
        end
        function StoreAllResults(obj, boolean)
            % If this method is activated (boolean = 1), field results are
            % stored at each frequency sample. This comprises electric and
            % magnetic fields, as well as electric and magnetic flux
            % densities.
            obj.AddToHistory(['.StoreAllResults "', num2str(boolean), '"']);
            obj.storeallresults = boolean;
        end
        function StoreSolutionCoefficients(obj, boolean)
            % If this method is activated (boolean = 1), solution
            % coefficients are stored on disk at each frequency sample and
            % at each excitation.
            obj.AddToHistory(['.StoreSolutionCoefficients "', num2str(boolean), '"']);
            obj.storesolutioncoefficients = boolean;
        end
        function CreateLegacy1DSignals(obj, boolean)
            % Call this method with (boolean = 1) only if required: some
            % result templates from previous versions do not operate on the
            % complex 1D results directly, but expect results for
            % amplitude, phase, and dB signals. This option is off by
            % default for new projects due to performance reasons.
            obj.AddToHistory(['.CreateLegacy1DSignals "', num2str(boolean), '"']);
            obj.createlegacy1dsignals = boolean;
        end
        function SetOpenBCTypeHex(obj, type)
            % Chooses how the open boundary is realized in the frequency
            % domain solver with hexahedral mesh. The default is PML. For
            % electrically relatively small models with the open boundaries
            % defined next to vacuum, the first order freespace open
            % boundary condition (type = 'FreespaceSIBC') might be an
            % alternative to save memory and to speed up the iterative
            % solver's convergence.
            %
            % type: 'Default'
            %       'PML'
            %       'FreespaceSIBC'
            obj.AddToHistory(['.SetOpenBCTypeHex "', type, '"']);
            obj.openbctypehex = type;
        end
        function SetOpenBCTypeTet(obj, type)
            % Chooses how the open boundary is realized in the frequency
            % domain solver with tetrahedral mesh, unless the problem has
            % unit cell boundary conditions, for which the open boundary is
            % realized by a Floquet mode 'port.'
            %
            % The default is the standard impedance boundary condition
            % (SIBC), which shows low artificial reflection for plane waves
            % that impinge on the open boundary perpendicularly (the field
            % solution of course is not necessarily a plane wave, but might
            % be considered as the superposition of various plane waves at
            % different angles.) For 'plane wave' angles closer to grazing
            % incidence, the PML provides lower artificial reflection, but
            % at the cost of higher memory usage and more demanding linear
            % equation systems, which require more time to solve.
            %
            % type: 'Default'
            %       'PML'
            %       'FreespaceSIBC'
            obj.AddToHistory(['.SetOpenBCTypeTet "', type, '"']);
            obj.openbctypetet = type;
        end
        function AddMonitorSamples(obj, boolean)
            % If this method is activated (boolean = 1), a solver run is
            % performed for all monitor frequencies defined, independently
            % of the number of other (non-monitor) frequency samples, which
            % are specified using the FrequencySamples and
            % AddSampleInterval methods. Please note that the total number
            % of samples will be increased automatically in order to take
            % into account the monitor definitions, if necessary. Otherwise
            % (boolean = 0), monitors will not be calculated.
            obj.AddToHistory(['.AddMonitorSamples "', num2str(boolean), '"']);
            obj.addmonitorsamples = boolean;
        end
        function FrequencySamples(obj, nsamples)
            % Specifies the (maximum) number of frequency samples that
            % should be calculated in a S-parameter frequency sweep. The
            % samples are placed adaptively in the current global frequency
            % interval. The method AddSampleInterval allows to specify the
            % sampling strategy more precisely.
            obj.AddToHistory(['.FrequencySamples "', num2str(nsamples), '"']);
            obj.frequencysamples = nsamples;
        end
        function MeshAdaptionHex(obj, boolean)
            % Activate the broadband, expert-system based adaptive mesh
            % refinement for the hexahedral frequency domain solver.
            obj.AddToHistory(['.MeshAdaptionHex "', num2str(boolean), '"']);
            obj.meshadaptionhex = boolean;
        end
        function MeshAdaptionTet(obj, boolean)
            % Activate the adaptive mesh refinement for the tetrahedral
            % frequency domain solver. The adaptation frequency samples are
            % defined by using the AddSampleInterval method with adaptation
            % set to True.
            obj.AddToHistory(['.MeshAdaptionTet "', num2str(boolean), '"']);
            obj.meshadaptiontet = boolean;
        end
        function ResetSampleIntervals(obj, key)
            % Removes sampling interval definitions according to the key .
            % If used together with AddSampleInterval, a set of sampling
            % intervals can be re-defined, for instance all adaptation
            % frequencies.
            %
            % key: 'all'
            %      'adaptation'
            %      'single'
            %      'inactive'
            obj.AddToHistory(['.ResetSampleIntervals "', key, '"']);
        end
        function UseHelmholtzEquation(obj, boolean)
            % If activated the Helmholtz equation is used when running the
            % frequency domain solver with hexahedral mesh. This might lead
            % to a faster convergence of the solver, especially for low
            % frequency problems.
            obj.AddToHistory(['.UseHelmholtzEquation "', num2str(boolean), '"']);
            obj.usehelmholtzequation = boolean;
        end
        function AddSampleInterval(obj, fmin, fmax, ncalcsamples, type, adaptation)
            % Specifies a customized frequency interval (min to max) as
            % well as the corresponding number of frequency samples for
            % which calculations will be performed.
            %
            % Depending on the key value, the samples will either be placed
            % adaptively, or equidistantly, or with logarithmic spacing
            % into the interval. A "Single" frequency point is defined by
            % setting lower and upper frequency limit to the same value, or
            % by omitting either the lower or the upper frequency. The
            % number of samples is One for single samples, of course.
            %
            % The parameters min and max may be values as well as strings.
            % You may pass an empty string "" as an argument. For
            % equidistant, automatic and logarithmic sampling, if min = ""
            % or max = "" this will be replaced by the corresponding global
            % limit of the frequency range.
            %
            % When the number of Samples is not defined (empty string "")
            % for an "Automatic" sampling interval, the solver stops
            % calculating additional samples as soon as the S-parameter
            % sweep convergence criterion is satisfied.
            %
            % The adaptation indicates whether or not the frequency samples
            % should be used for the sequential adaptive tetrahedral mesh
            % refinement.
            %
            % If the lower limit of the frequency interval evaluates to
            % Zero, the samples at frequency zero will be ignored for
            % "Equidistant" sampling intervals, and the lower limit will be
            % replaced with some suitable value for "Automatic" and
            % "Logarithmic" sampling interval definitions.
            %
            % type: 'Automatic'
            %       'Single'
            %       'Equidistant'
            %       'Logarithmic'
            obj.AddToHistory(['.AddSampleInterval "', num2str(fmin), '", '...
                                                 '"', num2str(fmax), '", '...
                                                 '"', num2str(ncalcsamples), '", '...
                                                 '"', type, '", '...
                                                 '"', num2str(adaptation), '"']);
        end
        function AddInactiveSampleInterval(obj, fmin, fmax, ncalcsamples, type, adaptation)
            % Specifies an inactive customized frequency interval. The
            % parameter are the same as for AddSampleInterval.
            obj.AddToHistory(['.AddInactiveSampleInterval "', num2str(fmin), '", '...
                                                         '"', num2str(fmax), '", '...
                                                         '"', num2str(ncalcsamples), '", '...
                                                         '"', type, '", '...
                                                         '"', num2str(adaptation), '"']);
        end
        function MaxIterations(obj, iterations)
            % Specifies the maximum number of linear equation system solver
            % iterations the solver will use for calculating the
            % electromagnetic field at a single frequency sample. This
            % applies only if LimitIterations has been activated and if the
            % iterative solver is used.
            obj.AddToHistory(['.MaxIterations "', num2str(iterations), '"']);
            obj.maxiterations = iterations;
        end
        function LimitIterations(obj, boolean)
            % If boolean = 1 the solver stops if the maximum number of
            % iterations given by the MaxIterations method is reached.
            obj.AddToHistory(['.LimitIterations "', num2str(boolean), '"']);
            obj.limititerations = boolean;
        end
        function ModesOnly(obj, boolean)
            % Calculate only the port modes when using the frequency domain
            % solver.
            obj.AddToHistory(['.LimitIterations "', num2str(boolean), '"']);
            obj.modesonly = boolean;
        end
        function SetShieldAllPorts(obj, boolean)
            % The boundary of all waveguide ports is treated as a perfectly
            % shielding (PEC) wire frame when calling this method with
            % boolean = 1.
            obj.AddToHistory(['.SetShieldAllPorts "', num2str(boolean), '"']);
            obj.shieldallports = boolean;
        end
        function SetPortMeshMatches3DMeshTet(obj, boolean)
            % The option SetPortMeshMatches3DMeshTet only applies to the
            % tetrahedral mesh and is disabled by default. The waveguide
            % port mode solver operates on the planar mesh of the waveguide
            % port and applies an adaptive port mesh refinement for this
            % mesh. By default, the port mesh is separated from the
            % volumetric mesh, and an overlap calculation is used to map
            % the port mode solution onto the boundary of the volumetric
            % mesh. However, if you call SetPortMeshMatches3DMeshTet with
            % flag = True, the port mode solver's mesh adaptation directly
            % refines the surface mesh of the volumetric mesh, so that no
            % overlap calculation is required. It is recommended to let the
            % port mesh match the 3D mesh whenever the overlap calculation
            % fails due to geometric tolerance problems.
            obj.AddToHistory(['.SetShieldAllPorts "', num2str(boolean), '"']);
            obj.portmeshmatches3dmeshtet = boolean;
        end
        function SetAllowROMPortModeSolver(obj, boolean)
            % Presently may affect the frequency domain solver with
            % tetrahedral mesh and fast reduced order model sweep only. The
            % broadband reduced order model calculates port mode data for
            % the complete frequency range and applies a technique to track
            % modes (the sorting of waveguide port modes by propagation
            % constant may lead to port modes changing order at some point
            % in the frequency range.) The fast reduced order model sweep
            % requires a broadband representation of the port modes for
            % inhomogeneously filled waveguide ports (mode types other than
            % TEM, TE, or TM.) Losses will be ignored if the frequency
            % domain solver with tetrahedral mesh and fast reduced order
            % model sweep chooses to use the broadband reduced order model
            % for port modes. Deactivate this option only if you want the
            % waveguide port modes of any type other than TEM, TE or TM to
            % be approximated by the modes at some fixed frequency
            % throughout the whole frequency range.
            obj.AddToHistory(['.SetAllowROMPortModeSolver "', num2str(boolean), '"']);
            obj.allowromportmodesolver = boolean;
        end
        function SetAllowDiscretePortSolver(obj, boolean)
            % Presently may affect the frequency domain solver with
            % tetrahedral mesh and general purpose sweep only. With the
            % option enabled, a numerical solution will be calculated for
            % discrete face ports. This allows to handle discrete face
            % ports with arbitrary shape with improved accuracy, very
            % similar to the approach taken for rectangular, cylinder
            % barrel, and coaxial face ports. Please note that discrete
            % ports need to be defined in between two good conductors, like
            % PEC and lossy metal materials.
            obj.AddToHistory(['.SetAllowDiscretePortSolver "', num2str(boolean), '"']);
            obj.allowdiscreteportsolver = boolean;
        end
        function SetUseROMPortModeSolverTet(obj, generalpurpose, fastreducedordermodel)
            % Similar to SetAllowROMPortModeSolver, but forcing the usage
            % of the port ROM for either the general purpose sweep or the
            % fast reduced order model sweep.
            obj.AddToHistory(['.SetUseROMPortModeSolverTet "', num2str(generalpurpose), '", '...
                                                          '"', num2str(fastreducedordermodel), '"']);
            obj.useromportmodesolvertetgeneralpurpose = generalpurpose;
            obj.useromportmodesolvertetfastreducedordermodel = fastreducedordermodel;
        end
        function EnableNativeSingleEnded(obj, boolean)
            % This setting affects the frequency domain solver with
            % tetrahedral mesh and general purpose frequency sweep. With
            % this option the "single-ended port" yields S-parameters and
            % fields by directly exciting the single-ended modes. Under
            % these circumstances the phase deembedding is not supported.
            % The fast reduced order model broadband sweep with tetrahedral
            % mesh always uses this approach.
            obj.AddToHistory(['.EnableNativeSingleEnded "', num2str(boolean), '"']);
            obj.enablenativesingleended = boolean;
        end
        function UseDeembeddedFields(obj, boolean)
            % This setting affects the frequency domain solver with
            % tetrahedral mesh and general purpose frequency sweep. With
            % this option enabled, the deembedded ports will be excited
            % with the already shifted modes. Otherwise, the deembedding
            % operation is performed on the S-parameter matrix only.
            obj.AddToHistory(['.UseDeembeddedFields "', num2str(boolean), '"']);
            obj.usedeembeddedfields = boolean;
        end
        function FreqDistAdaptMode(obj, mode)
            % This option is considered by the frequency domain solver with
            % tetrahedral mesh only. It allows selecting which strategy
            % will be followed when the option "Distribute excitation
            % calculation up to" is enabled in the "Distributed computing
            % (DC) frame". Selecting 'Local' adaptation frequencies will be
            % calculated locally, selecting 'As_A_Whole' all adaptation
            % frequencies will be transferred to a single remote computer
            % and selecting 'Distributed' adaptation frequencies will be
            % distributed separately over the remote computers. In the
            % first iteration over the broadband mesh adaptation, the
            % adaptation frequencies are transferred as a whole even if
            % "Distributed" has been selected.
            %
            % mode: 'Local'
            %       'As_A_Whole'
            %       'Distributed'
            obj.AddToHistory(['.FreqDistAdaptMode "', num2str(mode), '"']);
            obj.freqdistadaptmode = mode;
        end
        function SetPreferLeanOutput(obj, boolean)
            % This option is considered by the frequency domain solver with
            % tetrahedral mesh only. It allows to save some disc space and
            % simulation time, especially in case of simulation runs with
            % many excitations. Call with flag = True to disable the output
            % of the linear equation system solver's relative residual
            % curves.
            obj.AddToHistory(['.SetPreferLeanOutput "', num2str(boolean), '"']);
            obj.preferleanoutput = boolean;
        end
        function SetUseImpLineImpedanceAsReference(obj, boolean)
            % Call this method with flag = True to define impedances
            % calculated by impedance lines as the post-processing
            % reference impedance for all port modes to which they are
            % applied. Must be called before the solver run. The impedance
            % lines' impedances will replace the usual line impedance for
            % TEM and QTEM modes, and replace the wave impedances of other
            % modes. The port mode information which is displayed when
            % viewing a port mode is not affected.
            obj.AddToHistory(['.SetUseImpLineImpedanceAsReference "', num2str(boolean), '"']);
            obj.useimplineimpedanceasreference = boolean;
        end
        function SetUseOrientPortWithMask(obj, boolean)
            % Call this method with flag = True to switch to an alternative
            % algorithm for the mode orientation in waveguide ports.
            % Caution: this algorithm is not compatible with the standard
            % one and the corresponding algorithm for hex-based solvers.
            obj.AddToHistory(['.SetUseOrientPortWithMask "', num2str(boolean), '"']);
            obj.useorientportwithmask = boolean;
        end
        function ConsiderPortLossesTet(obj, boolean)
            % Allows to define whether the port mode solver for the
            % frequency domain solver with tetrahedral mesh considers lossy
            % dielectrics and lossy metal or not. If flag = False, the
            % imaginary part of both the complex permeability and the
            % complex permittivity will be set to zero, and lossy metal
            % will be treated as PEC in the port mode solver.
            obj.AddToHistory(['.ConsiderPortLossesTet "', num2str(boolean), '"']);
            obj.considerportlossestet = boolean;
        end
        function SetStopSweepIfCriterionMet(obj, boolean)
            % Activates (boolean = 1) or deactivates (boolean = 0) the
            % broadband 1D result frequency sweep convergence check. This
            % setting applies when using the general purpose broadband
            % frequency sweep, and 1D results such as S-parameters, or
            % field probes.  The number of frequency samples needed for a
            % broadband simulation by the solver usually decreases if the
            % check is activated, since the solver stops calculating
            % additional frequency samples as soon as the convergence
            % criterion is reached, which, in addition, can be influenced
            % by the SweepErrorChecks and SweepMinimumSamples methods.
            obj.AddToHistory(['.SetStopSweepIfCriterionMet "', num2str(boolean), '"']);
            obj.stopsweepifcriterionmet = boolean;
        end
        function SetSweepThreshold(obj, type, threshold)
            % Sets the threshold for the estimated interpolation error of
            % the S-parameters or field probes. This setting applies when
            % using the general purpose broadband frequency sweep.
            %
            % type: 'S-Parameters'
            %       'Probes'
            obj.AddToHistory(['.SetSweepThreshold "', type, '", '...
                                                 '"', num2str(threshold), '"']);
            obj.sweepthresholdtype = type;
            obj.sweepthresholdthreshold = threshold;
        end
        function UseSweepThreshold(obj, type, boolean)
            % If the flag is False, the estimated interpolation error of
            % the S-parameters or field probes is ignored for the
            % convergence check. This setting applies when using the
            % general purpose broadband frequency sweep, and allows for
            % instance to stop the broadband sweep when the S-parameters
            % are converged, no matter how accurate the probe results are.
            %
            % type: 'S-Parameters'
            %       'Probes'
            obj.AddToHistory(['.UseSweepThreshold "', type, '", '...
                                                 '"', num2str(boolean), '"']);
            obj.usesweepthresholdtype = type;
            obj.usesweepthreshold = boolean;
        end
        function Type(obj, type)
            % Chooses the linear equation system solver type to be used.
            % For the integral equation solver the matrix approximation is
            % chosen and in addition  "IterativeMoM" (ACA) and
            % "IterativeEnhanced" are available.
            %
            % type: 'Auto'
            %       'Iterative'
            %       'Direct'
            obj.AddToHistory(['.Type "', type, '"']);
            obj.type = type;
        end
        function StoreResultsInCache(obj, boolean)
            % Stores results of the solver in the result cache. For each
            % parameter combination in a parameter sweep, for instance, a
            % full backup of the results is stored in a sub folder like
            % {Projectname}/Result/Cache/run000001.
            obj.AddToHistory(['.StoreResultsInCache "', num2str(boolean), '"']);
            obj.storeresultsincache = boolean;
        end
        function SetMethod(obj, mesh, sweep)
            % Allows to change the method used in the frequency domain
            % solver as in the solver's dialog box. The type of mesh will
            % be changed to "Hexahedral", "Tetrahedral", with either the
            % "General purpose" or the "Fast reduced order model" broadband
            % sweep, or "Discrete samples only" to disable the calculation
            % of broadband results. Confer the frequency domain and
            % integral equation solver overview in the online manual for
            % details.
            %
            % You may pass empty strings "" for either mesh or sweep to
            % retain the values from a previous call to this method.
            %
            % Use "Surface Mesh" with "General purpose" sweep to activate
            % the integral equation solver.
            %
            % mesh: 'Hexahedral'
            %       'Tetrahedral'
            %       'Surface'
            % sweep: 'General purpose'
            %        'Fast reduced order model'
            %        'Discrete samples only'
            obj.AddToHistory(['.SetMethod "', mesh, '", '...
                                         '"', sweep, '"']);
            obj.methodmesh = mesh;
            obj.methodsweep = sweep;
        end
        function AutoNormImpedance(obj, boolean)
            % S-Parameters are always normalized to a reference impedance.
            % You may either select to norm them to the calculated
            % impedance of the stimulation port or you may specify a number
            % of your choice.  If flag is False the reference impedance
            % will be the calculated impedance of the input port.
            obj.AddToHistory(['.AutoNormImpedance "', num2str(boolean), '"']);
            obj.autonormimpedance = boolean;
        end
        function NormingImpedance(obj, value)
            % Specifies the impedance to be used as reference impedance for
            % the scattering parameters. This setting will only be
            % considered if AutoNormImpedance is set to True.
            obj.AddToHistory(['.NormingImpedance "', num2str(value), '"']);
            obj.normingimpedance = value;
        end
        function Stimulation(obj, port, mode)
            % Selects the source type to be used for excitation, such as
            % port and mode for waveguide ports.
            %
            % port/mode: 'All' - All ports and modes will be excited, one
            %                    at a time. This eventually excludes
            %                    Floquet ports for unit cell calculations.
            %            'All+Floquet' - All ports and modes will be
            %                            excited, one at a time. This
            %                            includes Floquet ports for unit
            %                            cell calculations.
            %            'Plane Wave' - A plane wave will be excited. mode
            %                           needs to be set to "1".
            %            'List' - A list of excitations is specified. port
            %                     and mode then need to be set to "List".
            %            integer - The port and mode number to be used for
            %                      excitation.
            %            'CMA' - Supported by integral equation solver and
            %                    multilayer solver. Performs a
            %                    characteristic mode analysis.
            obj.AddToHistory(['.Stimulation "', num2str(port), '", '...
                                           '"', num2str(mode), '"']);
            obj.stimulationport = port;
            obj.stimulationmode = mode;
        end
        function SweepErrorChecks(obj, n)
            % Determines how many consecutive times the estimated
            % S-parameter or probe interpolation error has to meet the
            % given threshold (see SetSweepThreshold) during a broadband
            % frequency sweep before the result is accepted to be
            % converged.
            obj.AddToHistory(['.SweepErrorChecks "', num2str(n), '"']);
            obj.sweeperrorchecks = n;
        end
        function SweepMinimumSamples(obj, n)
            % Determines the minimum number of frequency samples to be
            % calculated during a broadband S-parameter frequency sweep
            % before the convergence of the latter is checked.
            obj.AddToHistory(['.SweepMinimumSamples "', num2str(n), '"']);
            obj.sweepminimumsamples = n;
        end
        function SweepConsiderAll(obj, boolean)
            % Defines wheter all S-parameters (flag = True) or selected
            % S-parameters (flag = False, see SweepConsiderSPar) should be
            % considered to calculate the error during the broadband
            % frequency sweep. The option flag = False may be useful if the
            % S-parameters of higher order modes are not of interest.
            obj.AddToHistory(['.SweepConsiderAll "', num2str(boolean), '"']);
            obj.sweepconsiderall = boolean;
        end
        function SweepConsiderReset(obj)
            % Empties the list of selected S-parameters (see
            % SweepConsiderSPar) to be considered to calculate the error
            % during the broadband frequency sweep.
            obj.AddToHistory(['.SweepConsiderReset']);
            % NOTE: This might invalidate some MATLAB-side stored settings.
            obj.sweepconsiderspars = {};
        end
        function SweepConsiderSPar(obj, port_out, mode_out, port_in, mode_in)
            % Adds an S-parameter to the list of S-parameters to be
            % considered to calculate the error during the broadband
            % frequency sweep. This option may be useful if the
            % S-parameters of higher order modes are not of interest. The
            % list of samples is deleted by SweepConsiderReset. All
            % definitions are ignored if SweepConsiderAll has been set to
            % True.
            obj.AddToHistory(['.SweepConsiderSPar "', num2str(port_out), '", '...
                                                 '"', num2str(mode_out), '", '...
                                                 '"', num2str(port_in), '", '...
                                                 '"', num2str(mode_in), '"']);
            if(isempty(obj.sweepconsiderspar))
                obj.sweepconsiderspars = {};
            end
            obj.sweepconsiderspars = [obj.sweepconsiderspars, {port_out, mode_out, port_in, mode_in}];
        end
        function SetNumberOfResultDataSamples(obj, n)
            % Specifies the resolution of the interpolated S-parameters
            % during a broadband S-parameter frequency sweep. Increase the
            % number of samples if a higher resolution is required, for
            % instance due to poles which are very close.
            obj.AddToHistory(['.SetNumberOfResultDataSamples "', num2str(n), '"']);
            obj.numberofresultdatasamples = n;
        end
        function SetResultDataSamplingMode(obj, mode)
            % Call to select the mode of evaluating the frequency axis in
            % the general purpose broadband sweep. This affects the
            % adaptive frequency sampling as well as for instance the
            % S-parameter results when exported as a text file.
            %
            % mode: 'Automatic' - One of the remaining modes will be chosen
            %                     automatically, depending on the solver
            %                     settings, usually "Frequency (linear)"
            %                     unless some logarithmic frequency samples
            %                     have been definded by calling
            %                     AddSampleInterval with the corresponding
            %                     argument.
            %       'Frequency (linear)' - Data will be sampled
            %                              equidistantly on the linear
            %                              frequency axis.
            %       'Frequency (logarithmic)' - Data will be sampled
            %                                   equidistantly on the
            %                                   logarithmic frequency axis,
            %                                   possibly including a data
            %                                   point at 0 Hz.
            obj.AddToHistory(['.SetNumberOfResultDataSamples "', mode, '"']);
            obj.resultdatasamplingmode = mode;
        end
        function ExtrudeOpenBC(obj, boolean)
            % Affects the frequency domain solver with tetrahedral mesh. If
            % activated (flag = True), additional layers of mesh cells are
            % added outside the open boundary walls, and the boundary
            % condition is applied further away from the structure.
            obj.AddToHistory(['.ExtrudeOpenBC "', num2str(boolean), '"']);
            obj.extrudeopenbc = boolean;
        end
        function TDCompatibleMaterials(obj, boolean)
            % Defines whether constant tangent delta materials should be
            % treated as in the time domain solver, that is by using a
            % dispersive Debye model fit (flag = True), or by a constant
            % imaginary part of the permittivity (flag = False).
            %
            % The setting affects also the treatment of broadband surface
            % impedance materials, i.e. ohmic sheet, tabulated surface
            % impedance and corrugated wall. With the option flag = True
            % the simulated surface impedance will be computed accordingly
            % to the same fitting scheme used for the time domain solver.
            % Otherwise a linear interpolation scheme of the data will be
            % applied.
            %
            % The option flag = True should be used when comparing time
            % domain and frequency domain solver results.
            obj.AddToHistory(['.TDCompatibleMaterials "', num2str(boolean), '"']);
            obj.calcstatbfield = boolean;
        end
        function CalcStatBField(obj, boolean)
            % Set the flag to true if you want the frequency domain solver
            % with tetrahedral mesh to use an inhomogeneous static biasing
            % B-field for ferrites. The static field is then calculated
            % automatically by the magnetostatic solver before the
            % frequency domain solver run.
            obj.AddToHistory(['.CalcStatBField "', num2str(boolean), '"']);
            obj.tdcompatiblematerials = boolean;
        end
        function CalcPowerLoss(obj, boolean)
            % Set the flag to true if you want the frequency domain solver
            % with tetrahedral mesh to calculate power losses over
            % materials. Results will be added into the tree.
            obj.AddToHistory(['.CalcPowerLoss "', num2str(boolean), '"']);
            obj.calcpowerloss = boolean;
        end
        function CalcPowerLossPerComponent(obj, boolean)
            % Set the flag to true if you want the frequency domain solver
            % with tetrahedral mesh to include into the tree the material
            % losses associated to components.
            obj.AddToHistory(['.CalcPowerLossPerComponent "', num2str(boolean), '"']);
            obj.calcpowerlosspercomponent = boolean;
        end
        function SetUseGreenSandyFerriteModel(obj, boolean)
            % Set the flag to true if you want the frequency domain solver
            % with tetrahedral mesh to use Green-Sandy model for partial
            % magnetized ferrites.
            obj.AddToHistory(['.SetUseGreenSandyFerriteModel "', num2str(boolean), '"']);
            obj.usegreensandyferritemodel = boolean;
        end
        function SetGreenSandyThresholdH(obj, value)
            % The threshold for the H field is by default automatically
            % derived from the saturation magnetization specified in the
            % material properties of the ferrite. Pass an empty string to
            % enable this automatism, or a threshold for the static
            % magnetic field strength in A/m above which the ferrite will
            % be assumed to be fully magnetized. Above that threshold, the
            % Polder tensor is used only.
            obj.AddToHistory(['.SetGreenSandyThresholdH "', num2str(value), '"']);
            obj.greensandythresoldh = value;
        end
        function ResetExcitationList(obj)
            % Resets the current excitation list.
            obj.AddToHistory(['.ResetExcitationList']);
            % NOTE: This might invalidate some MATLAB-side stored settings.
            obj.excitationlist = {};
        end
        function AddToExcitationList(obj, port, mode)
            % Adds ports and modes to the exciation list.
            %
            % port: integer - The number of the port to be excited.
            %       'zmin'/'zmax' - The boundary position of a Floquet port.
            % mode: '1' - Setting for a discrete port.
            %        '1' or '1;3;4' - Mode numbers of a waveguide port.
            %        'TE(0,0);TM(0,0)' or 'LCP;RCP' - Mode type of a
            %                                         Floquet port.
            if(isempty(obj.excitationlist))
                obj.excitationlist = {};
            end
            obj.excitationlist = [obj.excitationlist, {port, mode}];
        end
        function UseParallelization(obj, boolean)
            % Call this method to enable or disable CPU parallelization
            % using multiple threads on the CPU cores and sockets as
            % defined by MaxCPUs and MaximumNumberOfCPUDevices methods.
            obj.AddToHistory(['.UseParallelization "', num2str(boolean), '"']);
            obj.useparallelization = boolean;
        end
        function MaxCPUs(obj, n)
            % Sets the number of CPU threads to be used.
            obj.AddToHistory(['.MaxCPUs "', num2str(n), '"']);
            obj.maxcpus = n;
        end
        function MaximumNumberOfCPUDevices(obj, n)
            % Sets the number of CPU devices (such as CPU sockets) to be
            % used.
            obj.AddToHistory(['.MaximumNumberOfCPUDevices "', num2str(n), '"']);
            obj.maximumnumberofcpudevices = n;
        end
        function SweepWeightEvanescent(obj, weight)
            % Defines a special weight factor for the S-parameter sweep
            % calculation, which is applied to frequency ranges belonging
            % to evanescent modes.
            obj.AddToHistory(['.MaximumNumberOfCPUDevices "', num2str(weight), '"']);
            obj.sweepweightevanescent = weight;
        end
        function LowFrequencyStabilization(obj, boolean)
            % Applies a stabilization procedure for frequencies close to
            % zero, which might improve the convergence behavior.
            %
            % Please note, that this effects only the general purpose
            % tetrahedral frequency domain solver.
            obj.AddToHistory(['.LowFrequencyStabilization "', num2str(boolean), '"']);
            obj.lowfrequencystabilization = boolean;
        end
        function OrderTet(obj, order)
            % Select here the order of the general purpose tetrahedral
            % frequency domain solver, with the choice between low memory
            % or highly accurate results for a given number of mesh cells.
            % Higher order also allows to achieve accurate results with
            % less mesh cells and eventually less memory consumption than
            % lower order, if the structure contains electrically large
            % voids rather than many geometric details.
            %
            % If the method MixedOrderTet is called with flag = True, then
            % OrderTet determines the maximum solver order to be used.
            %
            % order: 'First' - Calculation is done with first order
            %                  accuracy providing solutions with low memory
            %                  effort. Especially well suited for
            %                  structures with many electrically small
            %                  details.
            %        'Second' - Calculation is done with second order
            %                   accuracy providing highly accurate results.
            %                   Well suited for most applications, and
            %                   therefore the default.
            %        'Third' - Calculation is done with third order
            %                  accuracy providing highest accuracy. Allows
            %                  to reduce the number of mesh steps per
            %                  wavelength for structures with large voids,
            %                  or to even further improve the accuracy for
            %                  a given mesh resolution.
            obj.AddToHistory(['.OrderTet "', num2str(order), '"']);
            obj.ordertet = order;
        end
        function MixedOrderTet(obj, boolean)
            % If this method is activated (flag = True), the frequency
            % domain solver with tetrahedral mesh will automatically use
            % variable order up to the maximum solver order, which is
            % specified by calling OrderTet. This allows the solver to
            % decide in which regions lowest order should be used to save
            % memory and computational time, as well as to use higher order
            % where required.
            obj.AddToHistory(['.MixedOrderTet "', num2str(boolean), '"']);
            obj.mixedordertet = boolean;
        end
        function OrderSrf (obj, order)
            % Select here the order of the integral equation solver. If the
            % method MixedOrderSrf is activated (flag = True), OrderSrf
            % determines the maximum used solver order.
            %
            % The parameter order allows to choose between low memory and
            % highly accurate results
            %
            % order: 'First' - Calculation is done with first order
            %                  accuracy providing solutions with low memory
            %                  effort.
            %        'Second' - Calculation is done with second order
            %                   accuracy providing highly accurate results.
            %        'Third' - Calculation is done with third order
            %                  accuracy providing highest accuracy.
            obj.AddToHistory(['.OrderSrf "', num2str(order), '"']);
            obj.ordersrf = order;
        end
        function MixedOrderSrf(obj, boolean)
            % If this method is activated (flag = True), mixed solver order
            % will be used in the integral equation solver. Use OrderSrf to
            % determine the maximum used solver order.
            obj.AddToHistory(['.MixedOrderSrf "', num2str(boolean), '"']);
            obj.mixedordersrf = boolean;
        end
        function UseDistributedComputing(obj, boolean)
            % This method allows to switch between local and remote solver
            % runs. When enabled, a Frequency domain solver run is
            % submitted to the network. The setting does not influence
            % parameter sweeps and optimizer runs with distributed
            % computing.
            obj.AddToHistory(['.UseDistributedComputing "', num2str(boolean), '"']);
            obj.usedistributedcomputing = boolean;
        end
        function NetworkComputingStrategy(obj, strategy)
            % A single remote calculation ("RunRemote") and a distribution
            % of frequency samples ("Samples") are currently supported.
            %
            % strategy: 'RunRemote'
            %           'Samples'
            obj.AddToHistory(['.NetworkComputingStrategy "', strategy, '"']);
            obj.networkcomputingstrategy = strategy;
        end
        function NetworkComputingJobCount(obj, value)
            % Specifies the number of jobs which may be submitted at once
            % to the network computing job queue in case of an automatic
            % frequency sampling. Increase this number to use more
            % computers in parallel. It does not affect equidistant
            % frequency samples, monitor frequencies and other fix points,
            % which are submitted to the job queue at once.
            obj.AddToHistory(['.NetworkComputingJobCount "', num2str(value), '"']);
            obj.networkcomputingjobcount = value;
        end
        function UseSensitivityAnalysis(obj, boolean)
            % If activated the sensitivity analysis is calculated when
            % running the frequency domain solver with tetrahedral mesh.
            obj.AddToHistory(['.UseSensitivityAnalysis "', num2str(boolean), '"']);
            obj.usesensitivityanalysis = boolean;
        end
        function UseDoublePrecision(obj, boolean)
            % Supported by integral equation solver. If activated the
            % solver uses double-precision (64-bit)  for representing
            % floating-point values. Otherwise the solver uses
            % single-precision (32-bit). The single-precision
            % representation saves memory whereas the double-precision
            % representation speeds up the convergence of the iterative
            % equation system solver. Double-precision is necessary to
            % obtain highly accurate results.
            obj.AddToHistory(['.UseDoublePrecision "', num2str(boolean), '"']);
            obj.usedoubleprecision = boolean;
        end
        function PreconditionerAccuracyIntEq(obj, tolerance)
            % Supported by integral equation solver.  Sets the tolerance
            % for the preconditioner.
            obj.AddToHistory(['.PreconditionerAccuracyIntEq "', num2str(tolerance), '"']);
            obj.preconditioneraccuracyinteq = tolerance;
        end
        function MinMLFMMBoxSize(obj, value)
            % Supported by integral equation solver. This command allows
            % you to specify the minimum box size the MLFMM uses.
            obj.AddToHistory(['.MinMLFMMBoxSize "', num2str(value), '"']);
            obj.minmlfmmboxsize = value;
        end
        function MLFMMAccuracy(obj, value)
            % Supported by integral equation solver. This accuracy
            % determines the accuracy of the coupling between the MLFMM
            % boxes.
            %
            % value: 'VeryLowMem'
            %        'LowMem'
            %        'HighAcc'
            obj.AddToHistory(['.MLFMMAccuracy "', num2str(value), '"']);
            obj.mlfmmaccuracy = value;
        end
        function UseCFIEForCPECIntEq(obj, boolean)
            % Supported by integral equation solver. If for closed PEC
            % bodies the Combined Field Integral Equation shall be used
            % enable this option. The faster convergence of the linear
            % equation system solver is an advantage of this option. For
            % electrically small or complex PEC solids it is recommended to
            % disable this option. The accuracy for rather coarse mesh will
            % be improved.
            %
            % If you enable this option and set the CFIE alpha to 1 (using
            % the VBA command SetCFIEAlpha) the Electric Field Integral
            % Equation will be used. This is an option if you are sure
            % there will be no spurious resonances inside the PEC solids
            % e.g. for electrically small PEC solids.
            obj.AddToHistory(['.UseCFIEForCPECIntEq "', num2str(boolean), '"']);
            obj.usecfieforcpecinteq = boolean;
        end
        function UseFastRCSSweepIntEq(obj, boolean)
            % Supported by integral equation solver. A fast calculation of
            % monostatic RCS for different angles is available if a plane
            % wave is used as excitation. To enable and disable the fast
            % RCS calculation check and uncheck this option respectively.
            % Please use the Command SetRCSSweepProperties to define the
            % RCS sweep properties.
            obj.AddToHistory(['.UseFastRCSSweepIntEq "', num2str(boolean), '"']);
            obj.usefastrcssweepinteq = boolean;
        end
        function SetMRCSSweepProperties(obj, phistart, phiend, nphisteps, thetastart, thetaend, nthetasteps, einctheta, eincphi)
            % Supported by integral equation solver. For a fast monostatic
            % RCS calculation the angles for the incoming direction (Phi,
            % Theta) of the plane wave can be defined as equidistant
            % samples.  For only varying Phi  please set the Theta_Start
            % equal to Theta_End and accordingly if you only want to vary
            % Phi.
            obj.AddToHistory(['.SetMRCSSweepProperties "', num2str(phistart), '", '...
                                                      '"', num2str(phiend), '", '...
                                                      '"', num2str(nphisteps), '", '...
                                                      '"', num2str(thetastart), '", '...
                                                      '"', num2str(thetaend), '", '...
                                                      '"', num2str(nthetasteps), '", '...
                                                      '"', num2str(einctheta), '", '...
                                                      '"', num2str(eincphi), '"']);
            obj.mrcssweepproperties = [];
            obj.mrcssweepproperties.phistart = phistart;
            obj.mrcssweepproperties.phiend = phiend;
            obj.mrcssweepproperties.nphisteps = nphisteps;
            obj.mrcssweepproperties.thetastart = thetastart;
            obj.mrcssweepproperties.thetaend = thetaend;
            obj.mrcssweepproperties.nthetasteps = nthetasteps;
            obj.mrcssweepproperties.einctheta = einctheta;
            obj.mrcssweepproperties.eincphi = eincphi;
        end
        function [phistart, phiend, nphisteps, thetastart, thetaend, nthetasteps, einctheta, eincphi, activation] = GetRCSSweepProperties(obj)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetRCSSweepProperties''.');
            phistart = nan; phiend = nan; nphisteps = nan;
            thetastart = nan; thetaend = nan; nthetasteps = nan;
            einctheta = nan; eincphi = nan;
            activation = nan;
            
            % Supported by integral equation solver. Returns the settings
            % set by SetRCSSweepProperties and UseFastRCSSweepIntEq.
        end
        function SetCalcBlockExcitationsInParallel(obj, enable, useblock, maxparallel)
            % This method toggles whether or not and how excitations will
            % be solved in parallel if the iterative solver is used. Only
            % applies to the Frequency Domain solver with tetrahedral mesh.
            % The legacy version is available by setting useblock to false.
            % It is however recommended to leave the default useblock=True
            % as the block version usually provides better performance for
            % simulations with a large number of tetrahedrons or many
            % excitations. Leave maxparallel blank (pass "") to let the
            % solver decide how many excitations to calculate in parallel.
            % Note that hardware and license restrictions may apply and
            % overwrite some of those settings.
            obj.AddToHistory(['.SetCalcBlockExcitationsInParallel "', num2str(enable), '", '...
                                                                 '"', num2str(useblock), '", '...
                                                                 '"', num2str(maxparallel), '"']);
        end
        function SetWrite3DFieldsForFarfieldCalc(obj, boolean)
            % If activated, the frequency domain solver with tetrahedral
            % mesh stores volumetric electric and magnetic field results
            % for the farfield calculation. Call with flag = False to use
            % an alternative calculation method which saves disk space by
            % just recording surface field data on open boundary conditions
            % of the bounding box.
            obj.AddToHistory(['.SetWrite3DFieldsForFarfieldCalc "', num2str(boolean), '"']);
            obj.write3dfieldsforfarfieldcalc = boolean;
        end
        function SetRecordUnitCellScanFarfield(obj, key)
            % This option is considered by the frequency domain solver with
            % tetrahedral mesh in case of unit cell boundary conditions
            % only. It modifies the way farfield monitor data is
            % calculated. With "on" chosen, the Floquet ports' S-parameters
            % will be collected in a farfield representation for each scan
            % angle theta and phi. Choose "off" to perform a farfield
            % calculation using the fields on the boundaries of the single
            % unit cell. The default mode "auto" uses "on" for parameter
            % sweeps over the scan angle theta and phi, and "off" without
            % parameter sweep, that is for single solver runs.
            %
            % key: 'auto'
            %      'on'
            %      'off'
            obj.AddToHistory(['.SetWrite3DFieldsForFarfieldCalc "', num2str(key), '"']);
            obj.recordunitcellscanfarfield = key;
        end
        function SetConsiderUnitCellScanFarfieldSymmetry(obj, theta, phi)
            % This option is considered by the frequency domain solver with
            % tetrahedral mesh in case of unit cell boundary conditions
            % only, and if the method SetRecordUnitCellScanFarfield is
            % configured such that a unit cell scan farfield is collected
            % during a parameter sweep. The two flags for symmetry in
            % "theta" and "phi" will cause the farfield data to be
            % mirrored, such that only a quarter or half of the scan angle
            % space need to be considered in the parameter sweep. This of
            % course requires the structure to exhibit corresponding
            % symmetries.
            obj.AddToHistory(['.SetConsiderUnitCellScanFarfieldSymmetry "', num2str(theta), '", '...
                                                                       '"', num2str(phi), '"']);
            obj.considerunitcellscanfarfieldsymmetry = [];
            obj.considerunitcellscanfarfieldsymmetry.theta = theta;
            obj.considerunitcellscanfarfieldsymmetry.phi = phi;
        end
        function SetDisableResultTemplatesDuringUnitCellScanAngleSweep(obj, boolean)
            % This option is considered by the frequency domain solver with
            % tetrahedral mesh in case of unit cell boundary conditions
            % only, and if the method SetRecordUnitCellScanFarfield is
            % configured such that a unit cell scan farfield is collected
            % during a parameter sweep.
            %
            % Template based post-processing result templates usually are
            % evaluated after each solver run for a given parameter
            % combination. However, farfield results and S-parameter color
            % map plots are generated after the unit cell scan angle
            % parameter sweep is completed. Thus, evaluating result
            % templates which reference those results during the parameter
            % sweep normally produces error messages, as the results do not
            % yet exist. To prevent these error messages, which might cause
            % the optimizer to stop, please call
            % SetDisableResultTemplatesDuringUnitCellScanAngleSweep True
            % before starting the simulation. This is done automatically if
            % you use the unit cell simulation project creation.
            obj.AddToHistory(['.SetDisableResultTemplatesDuringUnitCellScanAngleSweep "', num2str(boolean), '"']);
            obj.disableresulttemplatesduringunitcellanglesweep = boolean;
        end
        function ExtractUnitCellScanFarfield(obj, frequencies, names, anchor)
            % This post-processing calculation is available for the
            % frequency domain solver with tetrahedral mesh in case of unit
            % cell boundary conditions only, and produces results if the
            % method SetRecordUnitCellScanFarfield was configured such that
            % a unit cell scan farfield is collected during a parameter
            % sweep. It extracts farfield results at some frequencies given
            % in Hz, and adds Navigation Tree entries with the
            % corresponding names provided for the results. Multiple
            % frequencies and names are separated by semicolon, and a name
            % must be provided for each frequency. The anchor usually is 1.
            % It defines which parametric data set is used as a reference,
            % in case the parameter sweep had sequences changing parameters
            % other than those used to parameterize the scan angle.
            obj.hFDSolver.invoke(['.ExtractUnitCellScanFarfield "', num2str(frequencies), '", '...
                                                                '"', num2str(names), '", '...
                                                                '"', num2str(anchor), '"']);
        end
        function [summary] = UpdateInterpolationSettings(obj, navigationtreepath)
            % This method is available as a post-processing step for the
            % general purpose sweep. It updates the interpolation settings
            % of results below the given path in the Navigation Tree.
            % navigationtreepath has slash or backslash characters as
            % separators and is case-insensitive, for instance "1D
            % Results/Probes". The solver's interpolation settings are then
            % applied to some 1D results. See SetNumberOfResultDataSamples
            % and SetResultDataSamplingMode for details. The interpolation
            % will be removed again if SetMethod was called with "Discrete
            % samples only". UpdateInterpolationSettings returns a string
            % with a summary.
            summary = obj.hFDSolver.invoke(['.UpdateInterpolationSettings "', navigationtreepath , '"']);
        end
        function ExportMORSolution(obj, frequency)
            % This method exports available 3D solutions at the chosen
            % frequency to CST PARTICLE Studio. Afterwards the exported
            % fields can be imported in CST PARTICLE Studio with the
            % Predefined Field feature. Applies to the fast reduced order
            % model sweep method only.
            obj.hFDSolver.invoke(['.ExportMORSolution "', frequency , '"']);
        end
        
        function InterpolationSamples(obj, interpolationsamples)
            % No information on this function is provided in the CST
            % documentation.
            obj.AddToHistory(['.InterpolationSamples "', num2str(interpolationsamples), '"']);
            obj.interpolationsamples = interpolationsamples;
        end
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
% FreqDistAdaptMode('Distributed')
% SetStopSweepIfCriterionMet(1)
% SetSweepThreshold('S-Parameters', 0.01)
% UetSweepThreshold('S-Parameters', 1)
% SetSweepThreshold('Probes', 0.05)
% UetSweepThreshold('Probes', 1)
% Type('Auto')
% StoreResultsInCache(0)
% SetMethod('Tetrahedral', 'General Purpose')
% AutoNormImpedance(0)
% NormingImpedance(50.0)
% Stimulation('All', 'All')
% SweepErrorChecks(2)
% SweepMinimumSamples(3)
% SweepConsiderAll(1)
% SetNumberOfResultDataSamples(1001)
% SetResultDataSamplingMode('Automatic')
% ExtrudeOpenBC(0)
% TDCompatibleMaterials(1)
% CalcStatBField(0)
% CalcPowerLoss(1)
% CalcPowerLossPerComponent(0)
% SetUseGreenSandyFerriteModel(0)
% SetGreenSandyThresholdH('')
% StoreSolutionCoefficients(1)
% CreateLegacy1DSignals(0)
% MeshAdaptionHex(0)
% MeshAdaptionTet(1)
% SetOpenBCTypeHex('Default')
% SetOpenBCTypeTet('Default')
% ResetExcitationList(1)
% AddToExcitationList('All', 'All')
% UseParallelization(1)
% MaxCPUs(72)
% MaximumNumberOfCPUDevices(2)
% SweepWeightEvanescent(1.0)
% LowFrequencyStabilization(0)
% OrderTet('Second')
% OrderSrf('Second')
% UseDistributedComputing(0)
% NetworkComputingStrategy('RunRemote')
% NetworkComputingJobCount(3)
% UseDoublePrecision(1)
% MixedOrderSrf(0)
% MixedOrderTet(0)
% UsePreconditionerIntEq('0')
% PreconditionerAccuracyIntEq('0.15')
% MLFMMAccuracy('Default')
% MinMLFMMBoxSize('0.2')
% UseCFIEForCPECIntEq(1)
% UseFastRCSSweepIntEq(1)
% SetCalcBlockExcitationsInParallel(1, 1, '')
% SetWrite3DFieldsForFarfieldCalc(1)
% SetRecordUnitCellScanFarfield('auto')
% SetConsiderUnitCellScanFarfieldSymmetry(0, 0)
% SetDisableResultTemplatesDuringUnitCellScanAngleSweep(0)