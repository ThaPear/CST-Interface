%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Allows to automatically perform several simulations with varying parameters. Instead of  ParameterSweep you may also use  DSParameterSweep, especially recommended in the schematic of a 3D project to avoid ambiguities with the 3D vba interface.
classdef ParameterSweep < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.DS.Project)
        % Only CST.DS.Project can create a ParameterSweep object.
        function obj = ParameterSweep(dsproject, hDSProject)
            obj.dsproject = dsproject;
            obj.hParameterSweep = hDSProject.invoke('ParameterSweep');
        end
    end
    %% CST Object functions.
    methods
        function SetSimulationType(obj, task)
            % Chooses the parameter sweep task to be used. An empty argument selects the top level parameter sweep. This method must be called before any other method if a parameter sweep task should be queried or modified. If this method is not called then the top level parameter sweep is used, which will evaluate all active tasks of the current project.
            obj.hParameterSweep.invoke('SetSimulationType', task);
        end
        function AddSequence(obj, name)
            % Defines a new simulation sequence. In a sequence several different sets of parameters with different values can be defined. These sets are then taken by the parameter sweep to modify the model and automatically simulate it for each set.
            obj.hParameterSweep.invoke('AddSequence', name);
        end
        function DeleteSequence(obj, name)
            % Deletes a sequence.
            obj.hParameterSweep.invoke('DeleteSequence', name);
        end
        function DeleteAllSequences(obj)
            % Deletes all sequences.
            obj.hParameterSweep.invoke('DeleteAllSequences');
        end
        function RenameSequence(obj, oldname, newname)
            % Renames a sequence.
            obj.hParameterSweep.invoke('RenameSequence', oldname, newname);
        end
        function AddParameter_Samples(obj, sequencename, parametername, from, to, steps, logarithmic_sweep)
            % Adds a parameter to a sequence.
            % from: Specify the lower bound of the parameter variation.
            % to: Specify  the upper bound of the parameter variation.
            % steps: Specify the number of samples for the parameter variation. There must be at least 2 samples to allow a simulation for the from and the to parameter values.
            % logarithmic_sweep: Specify if you need to perform a logarithmic sweep instead of a linear sweep.
            obj.hParameterSweep.invoke('AddParameter_Samples', sequencename, parametername, from, to, steps, logarithmic_sweep);
        end
        function AddParameter_Stepwidth(obj, sequencename, parametername, from, to, width)
            % Adds a parameter to a sequence.
            % from: Specify the lower bound of the parameter variation.
            % to: Specify  the upper bound of the parameter variation.
            % width: Specify the width between the samples for the parameter variation.
            obj.hParameterSweep.invoke('AddParameter_Stepwidth', sequencename, parametername, from, to, width);
        end
        function AddParameter_ArbitraryPoints(obj, sequencename, parametername, points)
            % Adds a parameter to a sequence.
            % points:  Specify the value of the sample. Use semicolon as a separator to specify multiple values. e.g. 2 ; 3 ; 3.1 ; 3.2 ; 3.3
            obj.hParameterSweep.invoke('AddParameter_ArbitraryPoints', sequencename, parametername, points);
        end
        function DeleteParameter(obj, sequencename, parametername)
            % Deletes a parameter from a sequence.
            obj.hParameterSweep.invoke('DeleteParameter', sequencename, parametername);
        end
        function Start(obj)
            % Starts the parameter sweep.
            % Returns the value of the specified parameter.
            obj.hParameterSweep.invoke('Start');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hParameterSweep

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% parametersweep = dsproject.ParameterSweep();
%     parametersweep.SetSimulationType('Parameter Sweep1');
%     parametersweep.AddSequence('Sweep');
%     parametersweep.AddParameter_Samples('Sweep', 'l', 2.6, 2.8, 5, 0)
%     parametersweep.Start
% 
