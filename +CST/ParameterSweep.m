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

% Allows to automatically perform several simulations with varying parameters.
classdef ParameterSweep < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a ParameterSweep object.
        function obj = ParameterSweep(project, hProject)
            obj.project = project;
            obj.hParameterSweep = hProject.invoke('ParameterSweep');
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
            % Prepend With ParameterSweep and append End With
            obj.history = [ 'With ParameterSweep', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ParameterSweep settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['ParameterSweep', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function SetSimulationType(obj, type)
            % Sets the simulation type to the given type.
            % type can have one of  the following values:
            % "Transient" - Transient simulation
            % "Calculate port modes only" - Port mode calculation only
            % "Eigenmode" - Eigenmode analysis
            % "Frequency" - Frequency domain simulation
            % "TLM" - Microstripes simulation
            % "Asymtotic" - Asymtotic simulation
            % "E-Static" - Electrostatic simulation
            % "Electroquasistatic" - Electroquasistatic simulation
            % "Transient Electroquasistatic" - Transient electroquasistatic simulation
            % "M-Static" - Magnetostatic simulation
            % "Transient Magnetoquasistatic" - Transient magnetoquasistatic simulation
            % "J-Static" - Stationary current simulation
            % "Low Frequency" - Low frequency simulation in frequency domain
            % "Thermal" - Stationary thermal simulation
            % "Transient Thermal" - Transient  thermal simulation
            % "Structural Mechanics" - Structural mechanics simulation
            % "E-Static" - Electrostatic simulation
            % "M-Static" - Magnetostatic simulation
            % "PIC" - Particle in cell simulation
            % "Particle Tracking" - Particle tracking
            obj.AddToHistory(['.SetSimulationType "', num2str(type, '%.15g'), '"']);
        end
        function AddSequence(obj, name)
            % Defines a new simulation sequence. In a sequence several different sets of parameters with different values can be defined. These sets are then taken by the parameter sweep to recreate the structure and automatically simulate it for each set.
            obj.AddToHistory(['.AddSequence "', num2str(name, '%.15g'), '"']);
        end
        function DeleteSequence(obj, name)
            % Deletes a sequence.
            obj.AddToHistory(['.DeleteSequence "', num2str(name, '%.15g'), '"']);
        end
        function DeleteAllSequences(obj)
            % Deletes all previously defined sequences.
            obj.AddToHistory(['.DeleteAllSequences']);
        end
        function RenameSequence(obj, oldname, newname)
            % Renames a sequence.
            obj.AddToHistory(['.RenameSequence "', num2str(oldname, '%.15g'), '", '...
                                              '"', num2str(newname, '%.15g'), '"']);
        end
        function AddParameter_Samples(obj, sequencename, parametername, from, to, steps, logarithmic_sweep)
            % Adds a parameter to a sequence.
            % from: Specify the lower bound of the parameter variation.
            % to: Specify  the upper bound of the parameter variation.
            % steps: Specify the number of samples for the parameter variation. There must be at least 2 samples to allow a simulation for the from and the to parameter values.
            % logarithmic_sweep: Specify if you need to perform a logarithmic sweep instead of a linear sweep.
            obj.AddToHistory(['.AddParameter_Samples "', num2str(sequencename, '%.15g'), '", '...
                                                    '"', num2str(parametername, '%.15g'), '", '...
                                                    '"', num2str(from, '%.15g'), '", '...
                                                    '"', num2str(to, '%.15g'), '", '...
                                                    '"', num2str(steps, '%.15g'), '", '...
                                                    '"', num2str(logarithmic_sweep, '%.15g'), '"']);
        end
        function AddParameter_Stepwidth(obj, sequencename, parametername, from, to, width)
            % Adds a parameter to a sequence.
            % from: Specify the lower bound of the parameter variation.
            % to: Specify  the upper bound of the parameter variation.
            % width: Specify the width between the samples for the parameter variation.
            obj.AddToHistory(['.AddParameter_Stepwidth "', num2str(sequencename, '%.15g'), '", '...
                                                      '"', num2str(parametername, '%.15g'), '", '...
                                                      '"', num2str(from, '%.15g'), '", '...
                                                      '"', num2str(to, '%.15g'), '", '...
                                                      '"', num2str(width, '%.15g'), '"']);
        end
        function AddParameter_ArbitraryPoints(obj, sequencename, parametername, points)
            % Adds a parameter to a sequence.
            % points:  Specify the value of the sample. Use semicolon as a separator to specify multiple values. e.g. 2 ; 3 ; 3.1 ; 3.2 ; 3.3
            obj.AddToHistory(['.AddParameter_ArbitraryPoints "', num2str(sequencename, '%.15g'), '", '...
                                                            '"', num2str(parametername, '%.15g'), '", '...
                                                            '"', num2str(points, '%.15g'), '"']);
        end
        function DeleteParameter(obj, sequencename, parametername)
            % Deletes a parameter from a sequence.
            obj.AddToHistory(['.DeleteParameter "', num2str(sequencename, '%.15g'), '", '...
                                               '"', num2str(parametername, '%.15g'), '"']);
        end
        function Start(obj)
            % Starts the parameter sweep.
%             obj.AddToHistory(['.Start']);

            % Removed history list item for this function.
            obj.hParameterSweep.invoke('Start');
        end
        function UseDistributedComputing(obj, boolean)
            % Enables/disables the distributed calculation of different solver runs across the network.
            obj.AddToHistory(['.UseDistributedComputing "', num2str(boolean, '%.15g'), '"']);
        end

        %% Undocumented functions.
        % Implemented from History List.
        % Definition below is copied from CST.ResultTree.
        function EnableTreeUpdate(obj, boolean)
            % Enable or disable the update of the tree. After enabling the tree update, this method does actually update the tree also.
            obj.hParameterSweep.invoke('EnableTreeUpdate', boolean);
        end
        % Found in 'Library/Result Templates/S-Parameters/- Touchstone Export^+MWS+DS.rtp'
        function nparams = GetNumberOfVaryingParameters(obj)
            nparams = obj.hParameterSweep.invoke('GetNumberOfVaryingParameters');
        end
        % Found in 'Library\Macros\Solver\E-Solver\Model.pfc'
        function value = GetValueOfVaryingParameter(obj, index)
            % Sounds like it'd get the value of the parameter denoted by the index.
            value = obj.hParameterSweep.invoke('GetValueOfVaryingParameter', index);
        end
        % Found in 'Library/Result Templates/Misc/- Send Outlook Notification E-Mail^-DS.rtp'
        function name = GetNameOfVaryingParameter(obj, index)
            % Sounds like it'd get the name of the parameter denoted by the index.
            name = obj.hParameterSweep.invoke('GetNameOfVaryingParameter', index);
        end
        % Found in 'Library\Result Templates\Particles\- Export 3D Trajectory Plot as Bitmap^+PS.rtp'
        function index = GetCurrentParameterIndex(obj)
            index = obj.hParameterSweep.invoke('GetCurrentParameterIndex');
        end
        % Found in 'Library/Macros/Solver/E-solver/Define Slow Wave userdefined Watch^+MWS.mcr'
        function AddUserdefinedWatch(obj)
            % 'Library\Macros\Solver\E-Solver\Model.pfc' contains a method named ParameterSweepWatch
            % That function might be related.
            obj.hParameterSweep.invoke('AddUserdefinedWatch');
        end
        % Found in history list.
        function AddParameter_Linear(obj, sequencename, parametername, from, to, steps)
            % Adds a parameter to a sequence.
            % from: Specify the lower bound of the parameter variation.
            % to: Specify  the upper bound of the parameter variation.
            % steps: Specify the number of steps.
            obj.AddToHistory(['.AddParameter_Linear "', num2str(sequencename, '%.15g'), '", '...
                                                   '"', num2str(parametername, '%.15g'), '", '...
                                                   '"', num2str(from, '%.15g'), '", '...
                                                   '"', num2str(to, '%.15g'), '", '...
                                                   '"', num2str(steps, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hParameterSweep
        history
        bulkmode

    end
end

%% Default Settings
% SetSimulationType('');
% UseDistributedComputing(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% parametersweep = project.ParameterSweep();
%     parametersweep.SetSimulationType('Transient');
%     parametersweep.SetSimulationType('E-Static');
%     parametersweep.AddSequence('Sweep');
%     parametersweep.AddParameter_Samples('Sweep', 'l', 2.6, 2.8, 5, 0);
%     parametersweep.Start();
%
% % Usable example.
% parametersweep = project.ParameterSweep();
%     parametersweep.StartBulkMode();
%     parametersweep.SetSimulationType('Frequency');
%     parametersweep.AddSequence('Sequence 1');
%     parametersweep.AddParameter_ArbitraryPoints('Sequence 1', 'aa_theta', '0;10');
%     parametersweep.AddParameter_ArbitraryPoints('Sequence 1', 'aa_phi', '0');
%     parametersweep.EndBulkMode();
%     parametersweep.Start();
