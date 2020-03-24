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

% This object allows you to change the parameters used for the three dimensional adaptive mesh refinement. This procedure is an automatic scheme which uses the results of a performed calculation to estimate a mesh better suited for the given problem. With the refined mesh a new calculation pass will then be started. The whole procedure will be repeated until a convergence is met.
classdef MeshAdaption3D < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.MeshAdaption3D object.
        function obj = MeshAdaption3D(project, hProject)
            obj.project = project;
            obj.hMeshAdaption3D = hProject.invoke('MeshAdaption3D');
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
            % Prepend With MeshAdaption3D and append End With
            obj.history = [ 'With MeshAdaption3D', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define MeshAdaption3D settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['MeshAdaption3D', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Errorlimit(obj, value)
            % If the relative deviation of the energy between two passes is smaller than the errorlimit the mesh adaption will terminate.
            %     
            % AccuracyFactor ( double value )
            % Specifies an additional factor for the current accuracy setting made in the transient solver control dialog box. The change of the S-parameters between two subsequent passes must not differ by more than the given accuracy level multiplied with the defined accuracy factor.
            obj.AddToHistory(['.Errorlimit "', num2str(value, '%.15g'), '"']);
            obj.errorlimit = value;
        end
        function SetType(obj, type)
            % Sets the type.
            % type may have one of  the following values:
            % "EStatic"
            % "MStatic"
            % "JStatic"
            % "LowFrequency"
            % "HighFrequencyHex"
            % "HighFrequencyTet"
            % "Time"
            obj.AddToHistory(['.SetType "', num2str(type, '%.15g'), '"']);
            obj.settype = type;
        end
        function SetAdaptionStrategy(obj, key)
            % Specifies the type of mesh adaption strategy.
            % key may have one of  the following values:
            % "ExpertSystem"
            % Refines the mesh by increasing global mesh parameters.
            % "Energy"
            % Refines the mesh at locations with high field energy.
            obj.AddToHistory(['.SetAdaptionStrategy "', num2str(key, '%.15g'), '"']);
            obj.setadaptionstrategy = key;
        end
        function RefinementType(obj, type)
            % Specifies the method used to refine the tetrahedral mesh.
            % "Automatic" presently selects anisotropic edge refinement and is the default method for the adaptive tetrahedral mesh refinement. Edges of the tetrahedrons are split at a position in the direction of the maximum estimated error along that edge, for instance closer to the edges of the conductor. Afterwards, the quality of the refined mesh is improved. This strategy may lead to a faster convergence than the stable cell bisection which in general produces visually "nicer" meshes as it tries to keep the quality measure of the tetrahedrons above a certain threshold.
            % type: 'Automatic'
            %       'Bisection'
            obj.AddToHistory(['.RefinementType "', num2str(type, '%.15g'), '"']);
            obj.refinementtype = type;
        end
        function ErrorEstimatorType(obj, type)
            % Formally allowed to specify the error estimation method used to refine the tetrahedral mesh. "Automatic" is the default and recommended choice.
            % type: 'Automatic'
            obj.AddToHistory(['.ErrorEstimatorType "', num2str(type, '%.15g'), '"']);
            obj.errorestimatortype = type;
        end
        function MinPasses(obj, passes)
            % Specifies the minimum number of passes which will be performed for the adaptive mesh refinement, even if the results do not change significantly.
            obj.AddToHistory(['.MinPasses "', num2str(passes, '%.15g'), '"']);
            obj.minpasses = passes;
        end
        function MaxPasses(obj, passes)
            % Specifies the maximum number of passes to be performed for the adaptive mesh refinement, even if the results have not sufficiently converged so far. This setting is useful to limit the total calculation time to reasonable amounts.
            obj.AddToHistory(['.MaxPasses "', num2str(passes, '%.15g'), '"']);
            obj.maxpasses = passes;
        end
        function CellIncreaseFactor(obj, factor)
            % Determines how many new cells are introduced between two subsequent passes of the mesh refinement. A setting of 0.5 means that the number of mesh cells increases about 50 percent from pass to pass.
            obj.AddToHistory(['.CellIncreaseFactor "', num2str(factor, '%.15g'), '"']);
            obj.cellincreasefactor = factor;
        end
        function WeightE(obj, weight)
            % Specifies the weight of the electric energy compared to the part of the magnetic energy. Sometimes a structure’s behavior is more critically coupled to changes of the electric field than to changes of the magnetic field so that it is advisable for the refinement control to take this fact into account.
            obj.AddToHistory(['.WeightE "', num2str(weight, '%.15g'), '"']);
            obj.weighte = weight;
        end
        function WeightB(obj, weight)
            % Specifies the weight of the magnetic energy compared to the part of the electric energy. Sometimes a structure’s behavior is more critically coupled to changes of the magnetic field than to changes of the electric field so that it is advisable for the refinement control to take this fact into account.
            obj.AddToHistory(['.WeightB "', num2str(weight, '%.15g'), '"']);
            obj.weightb = weight;
        end
        function RefineX(obj, boolean)
            % Decides whether the adaptive mesh refinement will be performed in the x-direction (switch = True) or not (switch= False). This option is useful to avoid refining a mesh along coordinate directions in which the structure’s fields have no dependency.
            obj.AddToHistory(['.RefineX "', num2str(boolean, '%.15g'), '"']);
            obj.refinex = boolean;
        end
        function RefineY(obj, boolean)
            % Decides whether the adaptive mesh refinement will be performed in the y-direction (switch = True) or not (switch= False). This option is useful to avoid refining a mesh along coordinate directions in which the structure’s fields have no dependency.
            obj.AddToHistory(['.RefineY "', num2str(boolean, '%.15g'), '"']);
            obj.refiney = boolean;
        end
        function RefineZ(obj, boolean)
            % Decides whether the adaptive mesh refinement will be performed in the z-direction (switch = True) or not (switch= False). This option is useful to avoid refining a mesh along coordinate directions in which the structure’s fields have no dependency.
            obj.AddToHistory(['.RefineZ "', num2str(boolean, '%.15g'), '"']);
            obj.refinez = boolean;
        end
        function MaxDeltaS(obj, value)
            % The S-parameter error (Delta S) is determined as the maximal deviation of the absolute value of the complex difference of the S-parameters between two subsequent passes. Specify a value between 0.0 and 1.0. For the frequency domain solver with tetrahedral mesh, this criterion is used at discrete frequencies, while AddSParameterStopCriterion defines a criterion for the broadband S-parameters.
            obj.AddToHistory(['.MaxDeltaS "', num2str(value, '%.15g'), '"']);
            obj.maxdeltas = value;
        end
        function ClearStopCriteria(obj)
            % Deletes all broadband stopping criteria, which had been defined for instance by calling AddSParameterStopCriterion, Add0DResultStopCriterion, and Add1DResultStopCriterion.
            obj.AddToHistory(['.ClearStopCriteria']);
        end
        function AddSParameterStopCriterion(obj, autofreq, fmin, fmax, maxdelta, numchecks, active)
            % The S-parameter stopping criterion measures the deviation of the broadband S-parameters between two subsequent passes. Specify a value for the threshold maxdelta between 0.0 and 1.0.
            % The time domain solver allows to restrict the check to a frequency range from fmin to fmax (given in the currently active frequency unit) if autofreq is set to False. Otherwise, the full frequency range will be used.
            % For the frequency domain solver with tetrahedral mesh, AddSParameterStopCriterion defines a criterion for the broadband S-parameters in the full frequency range as calculated by the solver, while MaxDeltaS is used at discrete frequencies.
            % The threshold maxdelta needs to be met for numchecks subsequent passes until the convergence criterion is considered to be met. Setting active to False allows to deactivate the criterion while keeping its definition.
            obj.AddToHistory(['.AddSParameterStopCriterion "', num2str(autofreq, '%.15g'), '", '...
                                                          '"', num2str(fmin, '%.15g'), '", '...
                                                          '"', num2str(fmax, '%.15g'), '", '...
                                                          '"', num2str(maxdelta, '%.15g'), '", '...
                                                          '"', num2str(numchecks, '%.15g'), '", '...
                                                          '"', num2str(active, '%.15g'), '"']);
            obj.addsparameterstopcriterion.autofreq = autofreq;
            obj.addsparameterstopcriterion.fmin = fmin;
            obj.addsparameterstopcriterion.fmax = fmax;
            obj.addsparameterstopcriterion.maxdelta = maxdelta;
            obj.addsparameterstopcriterion.numchecks = numchecks;
            obj.addsparameterstopcriterion.active = active;
        end
        function Add0DResultStopCriterion(obj, result, maxdelta, numchecks, active)
            % Provide the name of a 0D result template, which then can be used to provide a stopping criterion for the adaptive mesh refinement in the time domain solver and the frequency domain solver with tetrahedral mesh.
            % The threshold maxdelta is relative to the 0D result template's values (relative to the average of the values from the current and the last adaptive mesh refinement pass). The remaining arguments have the same meaning as described in AddSParameterStopCriterion above.
            obj.AddToHistory(['.Add0DResultStopCriterion "', num2str(result, '%.15g'), '", '...
                                                        '"', num2str(maxdelta, '%.15g'), '", '...
                                                        '"', num2str(numchecks, '%.15g'), '", '...
                                                        '"', num2str(active, '%.15g'), '"']);
            obj.add0dresultstopcriterion.result = result;
            obj.add0dresultstopcriterion.maxdelta = maxdelta;
            obj.add0dresultstopcriterion.numchecks = numchecks;
            obj.add0dresultstopcriterion.active = active;
        end
        function Add1DResultStopCriterion(obj, result, maxdelta, numchecks, active, complex)
            % Provide the name of a 1D result template, which then can be used to provide a stopping criterion for the adaptive mesh refinement in the frequency domain solver with tetrahedral mesh.
            % The threshold maxdelta is global relative to the 1D result template's values (global relative to the average of the values from the current and the last adaptive mesh refinement pass). The argument complex should be True only if complex 1D result template is selected. The remaining arguments have the same meaning as described in AddSParameterStopCriterion above.
            obj.AddToHistory(['.Add1DResultStopCriterion "', num2str(result, '%.15g'), '", '...
                                                        '"', num2str(maxdelta, '%.15g'), '", '...
                                                        '"', num2str(numchecks, '%.15g'), '", '...
                                                        '"', num2str(active, '%.15g'), '", '...
                                                        '"', num2str(complex, '%.15g'), '"']);
            obj.add1dresultstopcriterion.result = result;
            obj.add1dresultstopcriterion.maxdelta = maxdelta;
            obj.add1dresultstopcriterion.numchecks = numchecks;
            obj.add1dresultstopcriterion.active = active;
            obj.add1dresultstopcriterion.complex = complex;
        end
        function AddStopCriterion(obj, groupname, threshold, numchecks, active)
            % Defines a stop criterion for the adaptive tetrahedral mesh refinement. The parameter groupname specifies the items to be checked within the stop criterion. Each group is declared and fully described in the Adaptive Tetrahedral Mesh Refinement (Frequency Domain) dialog. A number of predefined group names is given here:
            % All S-Parameters - the stop criterion is based on the convergence of all available S- and F-parameters.
            % Reflection S-Parameters - the stop criterion is based on the convergence of all available reflection S- and F-parameters.
            % Transmission S-Parameters - the stop criterion is based on the convergence of all available transmission S- and F-parameters.
            % Portmode kz/k0 - the stop criterion is based on the convergence of the maximum magnitude of the difference of the port modes' complex propagation constants kz divided by the free space propagation constant k0.
            % All Probes - the stop criterion is based on the convergence of all near and far field probe frequency spectra.
            % The threshold (in linear scale, a value between 0.0 and 1.0) needs to be met for numchecks (a value greater than 0) subsequent passes until the convergence criterion is considered to be met. Setting active to False allows to deactivate the criterion while keeping its definition.
            obj.AddToHistory(['.AddStopCriterion "', num2str(groupname, '%.15g'), '", '...
                                                '"', num2str(threshold, '%.15g'), '", '...
                                                '"', num2str(numchecks, '%.15g'), '", '...
                                                '"', num2str(active, '%.15g'), '"']);
            obj.addstopcriterion.groupname = groupname;
            obj.addstopcriterion.threshold = threshold;
            obj.addstopcriterion.numchecks = numchecks;
            obj.addstopcriterion.active = active;
        end
        function RemoveAllUserDefinedStopCriteria(obj)
            % This removes all stop criteria which were defined by the user. User defined stop criteria can be added with AddStopCriterion.
            obj.AddToHistory(['.RemoveAllUserDefinedStopCriteria']);
        end
        function MeshIncrement(obj, value)
            % Only for Expert system based strategy. Specifies the number of mesh lines to add to the Mesh. MinimumLineNumber setting after a pass has been completed.
            obj.AddToHistory(['.MeshIncrement "', num2str(value, '%.15g'), '"']);
            obj.meshincrement = value;
        end
        function SetFrequencyRange(obj, auto, min, max)
            % Limits the frequency range used for the adaptive mesh refinement.
            obj.AddToHistory(['.SetFrequencyRange "', num2str(auto, '%.15g'), '", '...
                                                 '"', num2str(min, '%.15g'), '", '...
                                                 '"', num2str(max, '%.15g'), '"']);
            obj.setfrequencyrange.auto = auto;
            obj.setfrequencyrange.min = min;
            obj.setfrequencyrange.max = max;
        end
        function SkipPulses(obj, value)
            % Specifies the number of pulse widths to be skipped in order to consider very narrow banded structures, where the greatest energy amount is reflected and thus would mislead the refinement procedure. This means that it is advisable to start the energy calculation not until the reflected energy parts have left the structure.
            obj.AddToHistory(['.SkipPulses "', num2str(value, '%.15g'), '"']);
            obj.skippulses = value;
        end
        function NumberOfDeltaSChecks(obj, value)
            % Defines the number of consecutive adaptive tetrahedral mesh refinement passes during which the S-parameter deviation has to meet the threshold value defined by MaxDeltaS before the results are accepted to be converged.
            obj.AddToHistory(['.NumberOfDeltaSChecks "', num2str(value, '%.15g'), '"']);
            obj.numberofdeltaschecks = value;
        end
        function NumberOfPropConstChecks(obj, value)
            % Defines the number of consecutive adaptive tetrahedral port mesh refinement passes during which the propagation constants have to meet the threshold value defined by PropagationConstantAccuracy before the results are accepted to be converged.
            obj.AddToHistory(['.NumberOfPropConstChecks "', num2str(value, '%.15g'), '"']);
            obj.numberofpropconstchecks = value;
        end
        function PropagationConstantAccuracy(obj, value)
            % Defines the desired accuracy of the propagation constants for the adaptive tetrahedral port mesh refinement in terms of kz/k0, where kz is the mode's propagation constant, and k0 is the freespace propagation constant of a plane wave.
            obj.AddToHistory(['.PropagationConstantAccuracy "', num2str(value, '%.15g'), '"']);
            obj.propagationconstantaccuracy = value;
        end
        function SubsequentChecksOnlyOnce(obj, flag)
            % This setting only applies to the frequency domain solver with tetrahedral mesh and multiple adaptation frequency samples. Usually, the S-parameter convergence of the adaptive mesh refinement is checked more than once (see NumberOfDeltaSChecks). The solver will apply this check only to the first mesh adaptation sample if the flag is set to True.
            obj.AddToHistory(['.SubsequentChecksOnlyOnce "', num2str(flag, '%.15g'), '"']);
            obj.subsequentchecksonlyonce = flag;
        end
        function WavelengthBasedRefinement(obj, flag)
            % This setting only applies to the frequency domain solver with tetrahedral mesh. Each edge of an element will be refined if its length is greater than the desired fraction of a media wavelength at the adaptation frequency, as defined in the mesh properties. In most cases, the initial mesh fulfills this criterion already. If the material properties are not known in advance, as is the case for inhomogeneously biased ferrites, then this option should be enabled.
            obj.AddToHistory(['.WavelengthBasedRefinement "', num2str(flag, '%.15g'), '"']);
            obj.wavelengthbasedrefinement = flag;
        end
        function MinimumAcceptedCellGrowth(obj, value)
            % This setting only applies to the frequency domain solver with tetrahedral mesh. It enforces an additional convergence criterion, which rejects a "small" delta S (below the desired threshold) if the number of mesh cells did grow less than value percent.
            obj.AddToHistory(['.MinimumAcceptedCellGrowth "', num2str(value, '%.15g'), '"']);
            obj.minimumacceptedcellgrowth = value;
        end
        function RefThetaFactor(obj, value)
            % Defines the refinement percentage.  The error estimator assigns a measure for the error to each edge. Edges with the highest error measures are selected for refinement until their contribution to the overall estimated error is a certain value, called refinement percentage. In addition, this setting is an approximated upper limit for the mesh cell increase.
            % Pass an empty string "" as the value to let the solvers choose this percentage automatically, depeding on the solver order, for instance.
            % Note: If the singular edge refinement is activated, the limit defined with the RefThetaFactor might not be preserved.
            obj.AddToHistory(['.RefThetaFactor "', num2str(value, '%.15g'), '"']);
            obj.refthetafactor = value;
        end
        function SetMinimumMeshCellGrowth(obj, value)
            % This setting only applies to the frequency domain solver with tetrahedral mesh. It defines a weak lower limit to the mesh growth in percent of the number of cells of the current mesh adaptation pass or some reference meshes' number of cells, whichever is higher.
            obj.AddToHistory(['.SetMinimumMeshCellGrowth "', num2str(value, '%.15g'), '"']);
            obj.setminimummeshcellgrowth = value;
        end
        function SetLinearGrowthLimitation(obj, value)
            % This setting only applies to the frequency domain solver with tetrahedral mesh. It defines a limitation of the mesh growth in percent of the initial or some reference meshes' number of cells.
            % Pass an empty string "" as the value to let the solvers choose this setting automatically, depeding on the solver order, for instance. See also EnableLinearGrowthLimitation below.
            % Note: If the singular edge refinement is activated, the limit defined with the SetLinearGrowthLimitation might not be preserved.
            obj.AddToHistory(['.SetLinearGrowthLimitation "', num2str(value, '%.15g'), '"']);
            obj.setlineargrowthlimitation = value;
        end
        function EnableLinearGrowthLimitation(obj, flag)
            % This setting only applies to the frequency domain solver with tetrahedral mesh. It defines whether the limitation of the mesh growth passed to SetLinearGrowthLimitation should apply or not.
            % If an empty string "" was passed to SetLinearGrowthLimitation, the value of the flag is chosen automatically.
            % Note: If the singular edge refinement is activated, the limit defined with the SetLinearGrowthLimitation might not be preserved.
            obj.AddToHistory(['.EnableLinearGrowthLimitation "', num2str(flag, '%.15g'), '"']);
            obj.enablelineargrowthlimitation = flag;
        end
        function SingularEdgeRefinement(obj, level)
            % This setting only applies to the frequency domain solver with tetrahedral mesh given that the refinement type is set to automatic (RefinementType ("Automatic")). The accuracy and the performance of the adaptive mesh refinement can be further improved by an appropriate refinement of mesh edges on conductors. Due to the potentially highly varying field strength and distribution, a special treatment for these areas during the adaptive mesh refinement passes often leads to faster over all convergence and is recommended especially for planar structures.
            % Different levels of the aforementioned strategy are selectable. By default, the singular edge refinement is enabled at level 2. Therewith, an estimated error of the field solution along the model edges is calculated at the adaptation frequency samples and the possible singular edges, which have a certain percentage of the total estimated model edge error, are automatically detected and refined locally. When the mesh in those areas has been refined sufficiently, the singular edge refinement might stop. With the selection reduced to level 1, another threshold for the error will be considered, leading to less number of edges to be refined. Certainly, level 0 switches off the additional singular edge refinement. Level 3 does not involve any threshold for the error and consequently, all possible singular edges will be considered for refinement. The maximum level is recommended for cases when the minimum input reflection of all S-parameters at the present adaptation frequencies seems to be too high and no suitable adaptation frequency can be found.
            % Note: As the singular edge refinement is an additional refinement, the limits defined with SetLinearGrowthLimitation or RefThetaFactor might not be preserved.
            obj.AddToHistory(['.SingularEdgeRefinement "', num2str(level, '%.15g'), '"']);
            obj.singularedgerefinement = level;
        end
        function SnapToGeometry(obj, flag)
            % This setting only applies to the frequency domain solver with tetrahedral mesh. When selected, new nodes that are generated on model interfaces during the mesh adaptation will be projected onto the original geometry, such that the approximation of curved surfaces is improved after each adaptation step.
            obj.AddToHistory(['.SnapToGeometry "', num2str(flag, '%.15g'), '"']);
            obj.snaptogeometry = flag;
        end
        function EnableInnerSParameterAdaptation(obj, flag)
            % This setting only applies to the frequency domain solver with tetrahedral mesh. It enables the S-parameter convergence criterion for the adaptive mesh refinement at discrete mesh adaptation samples.
            obj.AddToHistory(['.EnableInnerSParameterAdaptation "', num2str(flag, '%.15g'), '"']);
            obj.enableinnersparameteradaptation = flag;
        end
        function EnablePortPropagationConstantAdaptation(obj, flag)
            % This setting only applies to the frequency domain solver with tetrahedral mesh. It enables the propagation constant convergence criterion for the adaptive port mesh refinement for waveguide ports.
            obj.AddToHistory(['.EnablePortPropagationConstantAdaptation "', num2str(flag, '%.15g'), '"']);
            obj.enableportpropagationconstantadaptation = flag;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hMeshAdaption3D
        history
        bulkmode

        errorlimit
        settype
        setadaptionstrategy
        refinementtype
        errorestimatortype
        minpasses
        maxpasses
        cellincreasefactor
        weighte
        weightb
        refinex
        refiney
        refinez
        maxdeltas
        addsparameterstopcriterion
        add0dresultstopcriterion
        add1dresultstopcriterion
        addstopcriterion
        meshincrement
        setfrequencyrange
        skippulses
        numberofdeltaschecks
        numberofpropconstchecks
        propagationconstantaccuracy
        subsequentchecksonlyonce
        wavelengthbasedrefinement
        minimumacceptedcellgrowth
        refthetafactor
        setminimummeshcellgrowth
        setlineargrowthlimitation
        enablelineargrowthlimitation
        singularedgerefinement
        snaptogeometry
        enableinnersparameteradaptation
        enableportpropagationconstantadaptation
    end
end

%% Default Settings
%  
% Errorlimit(0.005)
% MinPasses(2)
% MaxPasses(6)
% CellIncreaseFactor(0.7)
% WeightE(1.0)
% WeightB(1.0)
% RefineX(1)
% RefineY(1)
% RefineZ(1)
% MaxDeltaS(0.02)
% MeshIncrement(5)
% SetFrequencyRange(1, 0.0, 0.0)
% SkipPulses(0.0)
% ErrorEstimatorType('Automatic');
% RefinementType('Automatic');
% %% Default Settings(frequency domain solver with hexahedral mesh)
% SetType('HighFrequencyHex');
% SetAdaptionStrategy('ExpertSystem');
% MinPasses(2)
% MaxPasses(6)
% MeshIncrement(5.0)
% %% Default Settings(frequency domain solver with tetrahedral mesh)
% SetType('HighFrequencyTet');
% SetAdaptionStrategy('ExpertSystem');
% MinPasses(3)
% MaxPasses(8)
% MaxDeltaS(0.02)
% NumberOfDeltaSChecks(1)
% EnableInnerSParameterAdaptation(1)
% PropagationConstantAccuracy(0.005)
% NumberOfPropConstChecks(2)
% EnablePortPropagationConstantAdaptation(1)
% MinimumAcceptedCellGrowth(0.5)
% RefThetaFactor('');
% SetMinimumMeshCellGrowth(5)
% ErrorEstimatorType('Automatic');
% RefinementType('Automatic');
% SnapToGeometry(1)
% SubsequentChecksOnlyOnce(0)
% WavelengthBasedRefinement(1)
% EnableLinearGrowthLimitation(1)
% SetLinearGrowthLimitation('');
% SingularEdgeRefinement(2)
%  

%% Example - Taken from CST documentation and translated to MATLAB.
% 
% meshadaption3d = project.MeshAdaption3D();
%     meshadaption3d.SetType('Time');
%     meshadaption3d.SetAdaptionStrategy('ExpertSystem');
%     meshadaption3d.MinPasses(2)
%     meshadaption3d.MaxPasses(6)
%     meshadaption3d.MeshIncrement(5)
%     meshadaption3d.MaxDeltaS(0.02)
%     meshadaption3d.SetFrequencyRange(1, 0.0, 0.0)
