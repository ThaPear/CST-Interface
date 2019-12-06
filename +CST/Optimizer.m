%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Warning: Untested                                                   %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% With the optimizer object you may start an optimization run. For the optimization you have to define a set of parameters that will be changed by the optimizer and at least one goal function that is tried to be optimized.  The kind of goal function depends on the chosen solver type.
classdef Optimizer < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Optimizer object.
        function obj = Optimizer(project, hProject)
            obj.project = project;
            obj.hOptimizer = hProject.invoke('Optimizer');
            obj.history = [];
        end
    end
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
    end
    %% CST Object functions.
    methods
        function SetSimulationType(obj, simType)
            % Chooses the simulation type to be used for the optimization either a solver module or the template based post-processing.
            % simType can have one of the following values:
            % Transient Solver
            % Selects the time domain solver
            % Eigenmode Solver
            % Selects the eigenmode solver
            % Asymptotic Solver
            % Selects the asymtotic solver.
            % Multilayer Solver
            % Selects the multilayer solver..
            % Frequency Domain Solver
            % Selects the frequency domain solver.
            % Integral Equation Solver
            % Selects the integral equation solver.
            % E-Static Solver
            % Selects the electrostatics  solver.
            % M-Static Solver
            % Selects the magnetostatics solver.
            % Stationary Current Solver
            % Selects the stationary current solver.
            % LF Frequency Domain Solver
            % Selects the low frequency solver.
            % LF Time Domain Solver
            % Selects the lf-time domain solver.
            % Thermal Steady State Solver
            % Selects the thermal steady state solver.
            % Thermal Transient Solver
            % Selects the thermal transient solver.
            % Structural Mechanics Solver
            % Selects the stuctural mechanics solver.
            % PIC Solver
            % Selects the PIC solver.
            % Particle Tracking Solver
            % Selects the tracking solver.
            % Wakefield Solver
            % Selects the wakefield solver.
            % Template Based Post-Processing
            % Selects the template based post-processing.
            obj.AddToHistory(['.SetSimulationType "', num2str(simType, '%.15g'), '"']);
            obj.setsimulationtype = simType;
        end
        function Start(obj)
            % Starts the optimizer with the previously made settings.
            % Methods Concerning Parameters
            % InitParameterList
            % Initialize the optimizer's parameter list from the projects parameter list.
            obj.AddToHistory(['.Start']);
            
            % Prepend With Optimizer and append End With
            obj.history = [ 'With Optimizer', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Optimizer'], obj.history);
            obj.history = [];
        end
        function ResetParameterList(obj)
            % Deselect all parameters in the optimizer's parameter list. After calling this function no parameter is chosen to be optimized.
            obj.AddToHistory(['.ResetParameterList']);
        end
        function SelectParameter(obj, paraName, bFlag)
            % Select the parameter specified by its name paraName. If bFlag is True the parameter named paraName is chosen to be optimized.
            obj.AddToHistory(['.SelectParameter "', num2str(paraName, '%.15g'), '", '...
                                               '"', num2str(bFlag, '%.15g'), '"']);
            obj.selectparameter.paraName = paraName;
            obj.selectparameter.bFlag = bFlag;
        end
        function SetParameterInit(obj, value)
            % This method initializes a previously selected parameter with the given value. The parameter is selected using the SelectParameter method.
            obj.AddToHistory(['.SetParameterInit "', num2str(value, '%.15g'), '"']);
            obj.setparameterinit = value;
        end
        function SetParameterMin(obj, value)
            % Set the minimum value the currently selected parameter can reach. You must select a parameter using the SelectParameter  method before you can apply this method.
            obj.AddToHistory(['.SetParameterMin "', num2str(value, '%.15g'), '"']);
            obj.setparametermin = value;
        end
        function SetParameterMax(obj, value)
            % Set the maximum value the currently selected parameter can reach. You must select a parameter using the SelectParameter  method before you can apply this method.
            obj.AddToHistory(['.SetParameterMax "', num2str(value, '%.15g'), '"']);
            obj.setparametermax = value;
        end
        function SetParameterAnchors(obj, number)
            % If you use the interpolated Quasi-Newton optimizer (see also SetOptimizerType), it is necessary to specify the number of samples per parameter used while the optimization is running. Set the number of samples for a selected parameter using this method. You must select a parameter using the SelectParameter  method before you can apply this method.
            obj.AddToHistory(['.SetParameterAnchors "', num2str(number, '%.15g'), '"']);
            obj.setparameteranchors = number;
        end
        function SetMinMaxAuto(obj, percentage)
            % Sets the specified percentage for the calculation of the minimum and maximum values for all parameters.
            obj.AddToHistory(['.SetMinMaxAuto "', num2str(percentage, '%.15g'), '"']);
            obj.setminmaxauto = percentage;
        end
        function SetAndUpdateMinMaxAuto(obj, percentage)
            % Resets the minimum and maximum values for all parameters. The new minimum and maximum values are calculated by subtracting respectively adding the specified percentage of the current parameter values to the current parameter values. If a parameter is 0 (or very close to 0), the minimum and maximum values are set to the negative respectively positive percentage value.
            obj.AddToHistory(['.SetAndUpdateMinMaxAuto "', num2str(percentage, '%.15g'), '"']);
            obj.setandupdateminmaxauto = percentage;
        end
        function SetAlwaysStartFromCurrent(obj, bFlag)
            % Activate this method to initialize the optimizer with the current settings (bFlag = True), i.e. you can proceed optimizing your model starting each time from the previously optimized parameter results. However, if you want to restart the optimizer several times with the same initial parameter settings this method should be deactivated (bFlag = False).
            obj.AddToHistory(['.SetAlwaysStartFromCurrent "', num2str(bFlag, '%.15g'), '"']);
            obj.setalwaysstartfromcurrent = bFlag;
        end
        function SetUseDataOfPreviousCalculations(obj, bFlag)
            % Activate this method to trigger the import of previously calculated results for new optimizations to speed up the optimization process. If the result templates on which the optimizer goals are based were already evaluated before and the corresponding parameter combinations lie in the defined parameter space the results might be imported without the need for recalculation. For the local algorithms it's possible that the initial point is replaced if a more suitable point is found in advance. For the algorithms that use a set of initial points, multiple initial points will be replaced by points that lie close or have a better goal value than the points in the close neighborhood. This may disturb the selected distribution type but the algorithm will find a good compromise between finding points with good goal value and a well distributed set of starting points in the parameter space. Keep in mind that this feature will make the reproducibility of optimizations more difficult because after an optimization there will be more potential imports available than before.
            obj.AddToHistory(['.SetUseDataOfPreviousCalculations "', num2str(bFlag, '%.15g'), '"']);
            obj.setusedataofpreviouscalculations = bFlag;
        end
        function long = GetNumberOfVaryingParameters(obj)
            % Returns the number of varying parameters.
            long = obj.hOptimizer.invoke('GetNumberOfVaryingParameters');
        end
        function name = GetNameOfVaryingParameter(obj, index)
            % Returns the name of the parameter referenced by index between 0 and N-1, where N can be determined by GetNumberOfVaryingParameters.
            name = obj.hOptimizer.invoke('GetNameOfVaryingParameter', index);
            obj.getnameofvaryingparameter = index;
        end
        function double = GetValueOfVaryingParameter(obj, index)
            % Returns the value of the parameter referenced by index between 0 and N-1, where N can be determined by GetNumberOfVaryingParameters.
            double = obj.hOptimizer.invoke('GetValueOfVaryingParameter', index);
            obj.getvalueofvaryingparameter = index;
        end
        function double = GetParameterMinOfVaryingParameter(obj, index)
            % Returns the minimum value of the parameter referenced by index between 0 and N-1, where N can be determined by GetNumberOfVaryingParameters.
            double = obj.hOptimizer.invoke('GetParameterMinOfVaryingParameter', index);
            obj.getparameterminofvaryingparameter = index;
        end
        function double = GetParameterMaxOfVaryingParameter(obj, index)
            % Returns the maximum value of the parameter referenced by index between 0 and N-1, where N can be determined by GetNumberOfVaryingParameters.
            double = obj.hOptimizer.invoke('GetParameterMaxOfVaryingParameter', index);
            obj.getparametermaxofvaryingparameter = index;
        end
        function double = GetParameterInitOfVaryingParameter(obj, index)
            % Returns the intial value of the parameter referenced by index between 0 and N-1, where N can be determined by GetNumberOfVaryingParameters.
            double = obj.hOptimizer.invoke('GetParameterInitOfVaryingParameter', index);
            obj.getparameterinitofvaryingparameter = index;
        end
        function long = AddGoal(obj, goalType)
            % Creates a new goal and adds it to the internal list of goals. Upon creation an ID is created for each goal which is returned by this function. The newly defined goal is selected automatically for use with the currently selected optimizer. The newly defined goal is selected automatically for use with the currently selected optimizer.
            % goalType can have one of the following values:
            % "1D Primary Result"
            % Adds a goal for 1D result data
            % A goal specification can be done on some 1D result in the result tree, e.g. Time signal equal zero at t equal 3 Milliseconds.
            % "1DC Primary Result"
            % Adds a goal for complex valued 1D result data
            % A goal specification can be done on some complex valued 1D result in the result tree, e.g. S-Parameter "S11"  smaller -20 dB from 2-3 GHz.
            % "0D Result"
            % Adds a template based post-processing goal for 0D result data
            % A goal specification can be done on some template based post-processing result that creates a single value, e.g. the maximum gain of a farfield monitored at a certain frequency.
            % "1D Result"
            % Adds a template based post-processing goal for 1D result data
            % A goal specification can be done on some template based  post processing that creates1D result data.
            % "1DC Result"
            % Adds a template based post-processing goal for complex valued 1D result data
            % A goal specification can be done on some template based  post processing that creates1DC result data.
            long = obj.hOptimizer.invoke('AddGoal', goalType);
            obj.addgoal = goalType;
        end
        function SelectGoal(obj, id, bFlag)
            % Selects the goal specified by its ID id. The ID is returned when the goal is created using the AddGoal function. It is necessary to call this method before many other methods may be called because these other methods apply to a previously selected goal.
            %  If bFlag is True the selected goal is used for the optimization else it is ignored.
            obj.AddToHistory(['.SelectGoal "', num2str(id, '%.15g'), '", '...
                                          '"', num2str(bFlag, '%.15g'), '"']);
            obj.selectgoal.id = id;
            obj.selectgoal.bFlag = bFlag;
        end
        function DeleteGoal(obj, id)
            % Deletes the specified goal. To specify the goal use the ID that is returned by the AddGoal function when the goal is created.
            obj.AddToHistory(['.DeleteGoal "', num2str(id, '%.15g'), '"']);
            obj.deletegoal = id;
        end
        function DeleteAllGoals(obj)
            % Deletes all goals that were previously created.
            obj.AddToHistory(['.DeleteAllGoals']);
        end
        function SetGoalSummaryType(obj, summaryType)
            % Selects a summary type of all goals. The optimizer will minimize the sum or the maximum of all goals corresponding to what is selected.
            % summaryType: 'Sum_All_Goals'
            %              'Max_All_Goals'
            obj.AddToHistory(['.SetGoalSummaryType "', num2str(summaryType, '%.15g'), '"']);
            obj.setgoalsummarytype = summaryType;
        end
        function SetGoalUseFlag(obj, bFlag)
            % Marks a previously defined goal to be used or not to be used for the optimization. You must select a previously defined goal using the SelectGoal method before you can apply this method.
            obj.AddToHistory(['.SetGoalUseFlag "', num2str(bFlag, '%.15g'), '"']);
            obj.setgoaluseflag = bFlag;
        end
        function SetGoalOperator(obj, operatorType)
            % Almost every goal needs a goal operator that indicates how to evaluate the goal function value. The selectable operator types depend on the goal type of the currently selected goal. E.g. the operators "min", "max", "<", ">" or "="  indicate that a goal function should be minimized, maximized, lowered under or raised upon a certain value or that the goal function should reach a certain value respectively. You must select a previously defined goal using the SelectGoal method before you can apply this method.
            obj.AddToHistory(['.SetGoalOperator "', num2str(operatorType, '%.15g'), '"']);
            obj.setgoaloperator = operatorType;
        end
        function can = operatorType(obj)
            % <
            % lower goal function value under a given target value
            % 0D and 1D template based post-processing goals
            % >
            % raise goal function value upon a given target value
            % 0D and 1D template based post-processing goals
            % =
            % 0D and 1D template based post-processing goals
            % 0D and 1D template based post-processing goals
            % min
            % minimize goal function
            % 1D results based on the amplitude or dB entity of an S-Parameter template
            % max
            % maximize goal function
            % 1D results based on the amplitude or dB entity of an S-Parameter template
            % move min
            % minimize the abscissa distance of the minimum of the 1D result to the selected target. Keep in mind that sensitivities can't be exploited if this goal is used because the min operator is not differentiable
            % 1D template based post-processing goals
            % move max
            % minimize the distance of the maximum of the 1D result to the selected target. Keep in mind that sensitivities can't be exploited if this goal is used because the max operator is not differentiable
            % 1D template based post-processing goals
            can = obj.hOptimizer.invoke('operatorType');
        end
        function SetGoalTarget(obj, value)
            % Sets a target value for a previously defined goal. You must select a previously defined goal using the SelectGoal method before you can apply this method.
            obj.AddToHistory(['.SetGoalTarget "', num2str(value, '%.15g'), '"']);
            obj.setgoaltarget = value;
        end
        function SetGoalNormNew(obj, summaryType)
            % Sets the norm for a previously defined goal. For "MaxDiff" the goal value will be the maximal violation in the goal range. "MaxDiffSq" is the square of the maximal violation. "SumDiff" will take the sum of all goal violations to calculate the goal. "SumDiffSq" will take a sum of squares. "Diff" and "DiffSq" are only applicable to 0D goals and are calculated as the absolute value of the difference and the square of the violation respectively.
            % summaryType: 'MaxDiff'
            %              'MaxDiffSq'
            %              'SumDiff'
            %              'SumDiffSq'
            %              'Diff'
            %              'DiffSq'
            obj.AddToHistory(['.SetGoalNormNew "', num2str(summaryType, '%.15g'), '"']);
            obj.setgoalnormnew = summaryType;
        end
        function SetGoalWeight(obj, value)
            % Each goal can be weighted. Thus it is possible to distinguish between goals of greater or less importance. You must select a previously defined goal using the SelectGoal method before you can apply this method.
            obj.AddToHistory(['.SetGoalWeight "', num2str(value, '%.15g'), '"']);
            obj.setgoalweight = value;
        end
        function SetGoalScalarType(obj, scalarType)
            % Defines the real scalar type of the complex valued result on which the goal operator is evaluated.
            % scalarType: 'maglin'
            %             'magdb10'
            %             'magdb20'
            %             'real'
            %             'imag'
            %             'phase'
            obj.AddToHistory(['.SetGoalScalarType "', num2str(scalarType, '%.15g'), '"']);
            obj.setgoalscalartype = scalarType;
        end
        function SetGoal1DResultName(obj, resultName)
            % Set the tree name of a 1D result to the previously selected 1D goal.
            obj.AddToHistory(['.SetGoal1DResultName "', num2str(resultName, '%.15g'), '"']);
            obj.setgoal1dresultname = resultName;
        end
        function SetGoal1DCResultName(obj, resultName)
            % Set the tree name of a complex valued 1D result to the previously selected 1DC goal.
            obj.AddToHistory(['.SetGoal1DCResultName "', num2str(resultName, '%.15g'), '"']);
            obj.setgoal1dcresultname = resultName;
        end
        function SetGoalTemplateBased0DResultName(obj, resultName)
            % Set the name of a template based post-processing 0D result. The name needs to be an absolute path containing the template based post-processing path and the template name to the previously selected template based post-processing 0D goal.
            obj.AddToHistory(['.SetGoalTemplateBased0DResultName "', num2str(resultName, '%.15g'), '"']);
            obj.setgoaltemplatebased0dresultname = resultName;
        end
        function SetGoalTemplateBased1DResultName(obj, resultName)
            % Set the name of a template based post-processing 1D result. The name needs to be an absolute path containing the template based post-processing path and the template name to the previously selected template based post-processing 1D goal.
            obj.AddToHistory(['.SetGoalTemplateBased1DResultName "', num2str(resultName, '%.15g'), '"']);
            obj.setgoaltemplatebased1dresultname = resultName;
        end
        function SetGoalTemplateBased1DCResultName(obj, resultName)
            % Set the name of a complex valued template based post-processing 1D result. The name needs to be an absolute path containing the template based post-processing path and the template name to the previously selected template based post-processing 1DC goal.
            obj.AddToHistory(['.SetGoalTemplateBased1DCResultName "', num2str(resultName, '%.15g'), '"']);
            obj.setgoaltemplatebased1dcresultname = resultName;
        end
        function SetGoalRange(obj, Min, Max)
            %  Set a range for a previously selected 1D or 1DC result goal. You must select a previously defined 1D result goal using the SelectGoal method before you can apply this method.
            obj.AddToHistory(['.SetGoalRange "', num2str(Min, '%.15g'), '", '...
                                            '"', num2str(Max, '%.15g'), '"']);
            obj.setgoalrange.Min = Min;
            obj.setgoalrange.Max = Max;
        end
        function SetGoalRangeType(obj, rangeType)
            % For a defined template based post-processing 1D result goal, you can define the range that is being evaluated with this goal while the optimization is running. If the 1D result goal is based on an S-Parameter template then the range may cover the entire frequency range (total) of the simulation, only a part of the simulation's frequency range (range) or only one single frequency point (single). You must select a previously defined 1D result goal using the SelectGoal method before you can apply this method.
            % rangeType: 'total'
            %            'range'
            %            'single'
            obj.AddToHistory(['.SetGoalRangeType "', num2str(rangeType, '%.15g'), '"']);
            obj.setgoalrangetype = rangeType;
        end
        function UseSlope(obj, bFlag)
            % Sets a previously defined goal to use a slope for the goal operator. The selected goal needs to be defined on a range and the operators have to be "<", ">" or "=". The slope will be from the target at the minimum range to the maximum target at the maximum range.
            obj.AddToHistory(['.UseSlope "', num2str(bFlag, '%.15g'), '"']);
            obj.useslope = bFlag;
        end
        function SetGoalTargetMax(obj, target2)
            % Sets a previously defined goal to use target2 as maximum target. This setting has only an effect if the goal is set to use a slope operator, set by the method UseSlope.
            obj.AddToHistory(['.SetGoalTargetMax "', num2str(target2, '%.15g'), '"']);
            obj.setgoaltargetmax = target2;
        end
        function SetOptimizerType(obj, optimizerType)
            % You can choose between seven kinds of optimizer types here. If the runtime of the solver is long the Trust Region Framework is recommended, especially when the starting point of the optimization is already in the neighborhood of the expected optimum. If the solver evaluation is quick the Covariance Matrix Adaptation Evolutionary Strategy may be superior because of it's global optimization algorithm properties. The Nelder Mead Simplex algorithm is also know to work well on multiple problems.
            obj.AddToHistory(['.SetOptimizerType "', num2str(optimizerType, '%.15g'), '"']);
            obj.setoptimizertype = optimizerType;
        end
        function can = optimizerType(obj)
            % "Trust_Region"
            % Selects a local optimizing technique embedded in a trust region framework. The algorithm starts with building a linear model on primary data in a "trust" region around the starting point. For building this model sensitivity information of the primary data will be exploited if provided. Fast optimizations are done based on this local model to achieve a candidate for a new solver evaluation. The new point is accepted, if it is superior to the anchors of the model. If the model is not accurate enough the radius of the trust region will be decreased and a model on the new trust region will be created. The algorithm will be converged once the trust region radius or distance to the next predicted optimum becomes smaller than the specified domain accuracy.
            % "Nelder_Mead_Simplex"
            % Selects the local Simplex optimization algorithm by Nelder and Mead. This method is a local optimization technique. If N is the number of parameters, it starts with N+1 points distributed in the parameter space.
            % "CMAES"
            % Selects the global Covariance Matrix Adaptation Evolutionary Strategy. The method follows a global optimization approach in general. An internal step size parameter introduces a convergence property to the method.
            % "Genetic_Algorithm"
            % Selects the global genetic optimizer.
            % "Particle_Swarm"
            % Selects the global particle swarm optimizer.
            % "Interpolated_NR_VariableMetric"
            % Selects the local optimizer supporting interpolation of primary data. This optimizer is fast in comparison to the Classic Powell optimizer but may be less accurate. In addition, you can set the number N of optimizer passes (1 to 10) for this optimizer type. A number N greater than 1 forces the optimizer to start over (N-1) times. Within each optimizer pass the minimum and maximum settings of the parameters are changed approaching the optimal parameter setting. Increase the number of passes to values greater than 1 (e.g., 2 or 3)  to obtain more accurate results. It is recommended for the most common EM optimizations not to increase the number higher than 3 but to increase the number of samples in the parameter list, if the results are not suitable.
            % "Classic Powell"
            % Selects the local optimizer without interpolation of primary data. In addition, it is necessary to set the accuracy, which effects the accuracy of the optimal parameter settings and the time of termination of the optimization process. For optimizations with more than one parameter the Trust Region Framework, the Interpolated Quasi Newton or the Nelder Mead Simplex Algorithm should be preferred to this technique.
            can = obj.hOptimizer.invoke('optimizerType');
        end
        function SetUseInterpolation(obj, interpolationType, optimizerType)
            % This option is only available for the Genetic Algorithm or the Particle Swarm Optimization. Check this box to activate the interpolation, and disables the sample values in the parameter list.
            % For both global optimizers it is possible to switch on the Interpolation of Primary Data. If the interpolation is applied the only true solver runs that will be done are the ones for the evaluation of the specified anchors and a final solver run for the estimated  best parameters. All other goal function evaluations will be interpolated.
            % Please note that global optimization algorithms have the probability of exploring most of the parameter space. Thus it is most likely that all or nearly all anchor points will actually be evaluated. Keep in mind that the number of solver runs needed for interpolation is dependant of the number of parameters whereas the number of solver runs needed for the two global optimization algorithms are independent of the number of parameters. Because of this, the usage of the interpolation feature will only pay off if the parameter space is not too high dimensional or a large number of iterations is planned.
            % Since the possible goal functions that can be defined have always non negative values the optimization will automatically be stopped if one of the anchor evaluations yields a goal value equal zero.
            % interpolationType: 'Second_Order'
            % optimizerType: 'Genetic_Algorithm'
            %                'Particle_Swarm'
            obj.AddToHistory(['.SetUseInterpolation "', num2str(interpolationType, '%.15g'), '", '...
                                                   '"', num2str(optimizerType, '%.15g'), '"']);
            obj.setuseinterpolation.interpolationType = interpolationType;
            obj.setuseinterpolation.optimizerType = optimizerType;
        end
        function SetGenerationSize(obj, size, optimizerType)
            % It's possible to specify the population size for the Genetic Algorithm or the Particle Swarm Optimization. Keep in mind that choosing a small population size increases the risk that the genes can be depleted. If a large population size is chosen there will be more solver evaluations necessary for the calculation of each generation.
            % optimizerType: 'Genetic_Algorithm'
            %                'Particle_Swarm'
            obj.AddToHistory(['.SetGenerationSize "', num2str(size, '%.15g'), '", '...
                                                 '"', num2str(optimizerType, '%.15g'), '"']);
            obj.setgenerationsize.size = size;
            obj.setgenerationsize.optimizerType = optimizerType;
        end
        function SetMaxIt(obj, max_it, optimizerType)
            % Set the maximal number of iterations. The Genetic Algorithm or the Particle Swarm Optimization will stop after the maximal number of iterations have been done. Like this, it is possible to estimate the maximal optimization time a priori. If "n" is the population size and "m" is the maximal number of iterations "(m+1)*n/2 + 1" solver runs will be done. However this estimation is not valid if the Interpolation feature SetUseInterpolation is switched on, the optimization is aborted or the desired accuracy is reached
            % optimizerType: 'Genetic_Algorithm'
            %                'Particle_Swarm'
            %                'CMAES'
            obj.AddToHistory(['.SetMaxIt "', num2str(max_it, '%.15g'), '", '...
                                        '"', num2str(optimizerType, '%.15g'), '"']);
            obj.setmaxit.max_it = max_it;
            obj.setmaxit.optimizerType = optimizerType;
        end
        function SetInitialDistribution(obj, distributionType, optimizerType)
            % For the featured global optimization techniques and the  Nelder Mead Simplex Algorithm a set of initial points in the parameter space are necessary. These points will automatically be generated by a uniform random distribution generator or by the Latin Hypercube approach.
            % Uniform Random Numbers:  For each starting point a pseudo random number generator will choose uniformly distributed points in the parameter space.
            % Latin Hypercube:  Randomly chosen points sometimes have the disadvantage that they do not have optimal space filling properties in the parameter space. The Latin Hypercube sampling has the special property that a projection onto each parameter interval yields an equidistant sampling.
            % Noisy Latin Hypercube Distribution:  The initial points are distributed similar to the Latin Hypercube Distribution but a perturbation is added on each point. This distribution type has similar space filling properties as the Latin Hypercube Distribution but the generated point set will be less regular. This distribution type is only available for the Nelder Mead Simplex Algorithm.
            % distributionType: 'Uniform_Random_Numbers'
            %                   'Latin_Hyper_Cube'
            %                   'Noisy_Latin_Hyper_Cube'
            %                   'Cube_Distribution'
            % optimizerType: 'Genetic_Algorithm'
            %                'Particle_Swarm'
            %                'Nelder_Mead_Simplex'
            obj.AddToHistory(['.SetInitialDistribution "', num2str(distributionType, '%.15g'), '", '...
                                                      '"', num2str(optimizerType, '%.15g'), '"']);
            obj.setinitialdistribution.distributionType = distributionType;
            obj.setinitialdistribution.optimizerType = optimizerType;
        end
        function SetGoalFunctionLevel(obj, level, optimizerType)
            % A desired goal function level can be specified for the Genetic Algorithm or the Particle Swarm Optimization. The algorithm will be stopped if the goal function value is less than the specified level. However, if the optimization is done distributed this criterion will only be checked after the complete population was calculated. If the desired level is set to zero then the Maximal Number of Iterations is the only breaking condition. This setting is very convenient if the defined goals can't be satisfied per definition or are very unlikely to be reached exactly.
            % optimizerType: 'Genetic_Algorithm'
            %                'Particle_Swarm'
            %                'Nelder_Mead_Simplex'
            obj.AddToHistory(['.SetGoalFunctionLevel "', num2str(level, '%.15g'), '", '...
                                                    '"', num2str(optimizerType, '%.15g'), '"']);
            obj.setgoalfunctionlevel.level = level;
            obj.setgoalfunctionlevel.optimizerType = optimizerType;
        end
        function SetMutaionRate(obj, rate, optimizerType)
            % If the genes of  two parents are similar enough the mutation rate specifies the probability that a mutation occurs. This option is only available for the Genetic Algorithm and the Particle Swarm Optimization.
            % optimizerType: 'Genetic_Algorithm'
            %                'Particle_Swarm'
            obj.AddToHistory(['.SetMutaionRate "', num2str(rate, '%.15g'), '", '...
                                              '"', num2str(optimizerType, '%.15g'), '"']);
            obj.setmutaionrate.rate = rate;
            obj.setmutaionrate.optimizerType = optimizerType;
        end
        function SetMinSimplexSize(obj, size)
            % Sets the minimal simplex size for the Nelder Mead Simplex Algorithm. For optimization the parameter space is mapped onto the unit cube. The simplex is a geometrical figure that moves in this multidimensional space. The algorithm will stop as soon as the largest edge of the Simplex will be smaller than the specified size. If the optimization is defined over  just one parameter in the interval [0;1] then this setting corresponds with the desired accuracy in the parameter space.
            obj.AddToHistory(['.SetMinSimplexSize "', num2str(size, '%.15g'), '"']);
            obj.setminsimplexsize = size;
        end
        function SetUseMaxEval(obj, bFlag, optimizerType)
            % Set this option to enable the use of the maximal number of evaluations. This option is only available for the Nelder Mead Simplex Algorithm and CMAES.
            % optimizerType: 'Nelder_Mead_Simplex'
            %                'CMAES'
            obj.AddToHistory(['.SetUseMaxEval "', num2str(bFlag, '%.15g'), '", '...
                                             '"', num2str(optimizerType, '%.15g'), '"']);
            obj.setusemaxeval.bFlag = bFlag;
            obj.setusemaxeval.optimizerType = optimizerType;
        end
        function SetMaxEval(obj, number, optimizerType)
            % Sets the maximal number of evaluations for the Nelder Mead Simplex Algorithm or CMAES. Depending on the optimization problem definition it is possible that the specified goal function level can't be reached. In this case it is convenient to define a maximal number of function evaluations to restrict optimization time a priory. This number has to be greater than one.
            % optimizerType: 'Nelder_Mead_Simplex'
            %                'CMAES'
            obj.AddToHistory(['.SetMaxEval "', num2str(number, '%.15g'), '", '...
                                          '"', num2str(optimizerType, '%.15g'), '"']);
            obj.setmaxeval.number = number;
            obj.setmaxeval.optimizerType = optimizerType;
        end
        function SetUsePreDefPointInInitDistribution(obj, bFlag, optimizerType)
            % This option is only available for the Nelder Mead Simplex Algorithm and CMAES. If this feature is switched on then the point that is defined as anchor point in the parameter list will be included in the initial data set of the algorithm. If the current parameter settings are already quite good then it makes sense to include this point in the starting set. After the set of initial points is generated the closest point from the automatically generated set will be substituted with the predefined point. However if the current point was created by a previous optimization run of a local optimizer and a second optimization is planned on a reduced parameter space this setting should be turned off because it increases the risk that the second optimization will converge to the same local optimum as before. In this case the second optimization won't yield any improvement.
            % optimizerType: 'Nelder_Mead_Simplex'
            %                'CMAES'
            obj.AddToHistory(['.SetUsePreDefPointInInitDistribution "', num2str(bFlag, '%.15g'), '", '...
                                                                   '"', num2str(optimizerType, '%.15g'), '"']);
            obj.setusepredefpointininitdistribution.bFlag = bFlag;
            obj.setusepredefpointininitdistribution.optimizerType = optimizerType;
        end
        function SetNumRefinements(obj, number)
            % Sets the number of Quasi-Newton optimizer passes. With each Quasi-Newton optimizer pass past the first pass, the minimum and maximum parameter values are refined around the optimal parameter values found in the previous pass.
            obj.AddToHistory(['.SetNumRefinements "', num2str(number, '%.15g'), '"']);
            obj.setnumrefinements = number;
        end
        function SetDomainAccuracy(obj, accuracy, optimizerType)
            % Set the accuracy of the optimizer in the parameter space if all parameter ranges are mapped to the interval [0,1]. This option is only available for the Trust Region Framework.
            % optimizerType: 'Trust_Region'
            obj.AddToHistory(['.SetDomainAccuracy "', num2str(accuracy, '%.15g'), '", '...
                                                 '"', num2str(optimizerType, '%.15g'), '"']);
            obj.setdomainaccuracy.accuracy = accuracy;
            obj.setdomainaccuracy.optimizerType = optimizerType;
        end
        function SetSigma(obj, value, optimizerType)
            % This option is only available for CMAES. It sets the sigma of the normal distribution used in the algorithm to the defined value, which must be greater zero and less or equal one.
            % optimizerType: 'CMAES'
            obj.AddToHistory(['.SetSigma "', num2str(value, '%.15g'), '", '...
                                        '"', num2str(optimizerType, '%.15g'), '"']);
            obj.setsigma.value = value;
            obj.setsigma.optimizerType = optimizerType;
        end
        function SetAccuracy(obj, accuracy)
            % This value defines when the Classic Powell optimizer stops. It is a norm of the difference between the actual and the previous set of parameters.
            % So general speaking the Powell optimizer stops, if  the change of all the parameters used is smaller than the value given here.
            obj.AddToHistory(['.SetAccuracy "', num2str(accuracy, '%.15g'), '"']);
            obj.setaccuracy = accuracy;
        end
        function SetDataStorageStrategy(obj, storageType)
            % Sets the storage strategy for the 1D results produced during the optimization. For optimizations which generate much results on each evaluation or are expected to run for many evaluations it's possible to save time and disc space by avoiding the storage of the signals via the option "None". This setting doesn't apply to the template based post-processing results.
            % storageType: 'All'
            %              'Automatic'
            %              'None'
            obj.AddToHistory(['.SetDataStorageStrategy "', num2str(storageType, '%.15g'), '"']);
            obj.setdatastoragestrategy = storageType;
        end
        function SetOptionMoveMesh(obj, bFlag)
            % Set this option to make the optimizer attempt to move (or morph) the mesh on parameter changes instead of re-meshing the project for each parameter combination. If set, this option will overrule the tetrahedral mesh-setting for the course of the optimization.
            obj.AddToHistory(['.SetOptionMoveMesh "', num2str(bFlag, '%.15g'), '"']);
            obj.setoptionmovemesh = bFlag;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hOptimizer
        history

        setsimulationtype
        selectparameter
        setparameterinit
        setparametermin
        setparametermax
        setparameteranchors
        setminmaxauto
        setandupdateminmaxauto
        setalwaysstartfromcurrent
        setusedataofpreviouscalculations
        getnameofvaryingparameter
        getvalueofvaryingparameter
        getparameterminofvaryingparameter
        getparametermaxofvaryingparameter
        getparameterinitofvaryingparameter
        addgoal
        selectgoal
        deletegoal
        setgoalsummarytype
        setgoaluseflag
        setgoaloperator
        setgoaltarget
        setgoalnormnew
        setgoalweight
        setgoalscalartype
        setgoal1dresultname
        setgoal1dcresultname
        setgoaltemplatebased0dresultname
        setgoaltemplatebased1dresultname
        setgoaltemplatebased1dcresultname
        setgoalrange
        setgoalrangetype
        useslope
        setgoaltargetmax
        setoptimizertype
        setuseinterpolation
        setgenerationsize
        setmaxit
        setinitialdistribution
        setgoalfunctionlevel
        setmutaionrate
        setminsimplexsize
        setusemaxeval
        setmaxeval
        setusepredefpointininitdistribution
        setnumrefinements
        setdomainaccuracy
        setsigma
        setaccuracy
        setdatastoragestrategy
        setoptionmovemesh
    end
end

%% Default Settings
% SetMinMaxAuto(10.0)
% SetParameterAnchors(5)
% SetAlwaysStartFromCurrent(1)
% SetGoalUseFlag(1)
% SetGoalOperator('<');
% SetGoalTarget(0.0)
% SetGoalWeight(1.0)
% SetOptimizerType('Nelder_Mead_Simplex');
% SetAccuracy(0.01 )
% SetNumRefinements(1)

%% Example - Taken from CST documentation and translated to MATLAB.
% Dim goalID As Long
% 
% optimizer = project.Optimizer();
%   .SetOptimizerType('Interpolated_NR_VariableMetric');
%   .SetSimulationType('Transient');');Electrostatic');
%   .SetNumRefinements(1)
%   .SetMinMaxAuto(10)
%   .SetAlwaysStartFromCurrent(0)
%   .SelectParameter('r', 1)
%   .SetParameterInit(17)
%   .SetParameterMin(15.3)
%   .SetParameterMax(18.7)
%   .SetParameterAnchors(5)
%   .SelectParameter('ts', 0)
%   .SetParameterInit(0.05)
%   .SetParameterMin(0.045)
%   .SetParameterMax(0.055)
%   .SetParameterAnchors(5)
%   .SelectParameter('ws', 0)
%   .SetParameterInit(4)
%   .SetParameterMin(3.6)
%   .SetParameterMax(4.4)
%   .SetParameterAnchors(5)
%   .SetGoalSummaryType('Sum_All_Goals');
%   .SetUseDataOfPreviousCalculations(0)
%   goalID = .AddGoal('0D Result');
%   .SelectGoal(goalID, 1)
%   .SetGoalOperator('<');
%   .SetGoalTarget(0.0)
%   .SetGoalWeight(1.0)
%   .SetGoalTemplateBased0DResultName('S11_fctr');
%   .Start
% 
