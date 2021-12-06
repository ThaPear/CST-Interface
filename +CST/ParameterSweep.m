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
            % type can have one of  the following values:
            % "E-Static" - Electrostatic simulation
            % "Electroquasistatic" - Electroquasistatic simulation
            % "Transient Electroquasistatic" - Transient electroquasistatic simulation
            % "M-Static" - Magnetostatic simulation
            % "Transient Magnetoquasistatic" - Transient magnetoquasistatic simulation
            % "J-Static" - Stationary current simulation
            % "Low Frequency" - Low frequency simulation in frequency domain
            % type can have one of  the following values:
            % "Thermal" - Stationary thermal simulation
            % "Transient Thermal" - Transient  thermal simulation
            % "Structural Mechanics" - Structural mechanics simulation
            % type can have one of  the following values:
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
        %% CST 2014 Functions.
        function long = GetNumberOfVaryingParameters(obj)
            % Get the number of varying parameters.
            long = obj.hParameterSweep.invoke('GetNumberOfVaryingParameters');
        end
        function str = GetNameOfVaryingParameter(obj, index)
            % Returns the name of the specified parameter.
            str = obj.hParameterSweep.invoke('GetNameOfVaryingParameter', index);
        end
        function double = GetValueOfVaryingParameter(obj, index)
            % Returns the value of the specified parameter.
            double = obj.hParameterSweep.invoke('GetValueOfVaryingParameter', index);
        end
        function AddVolumeWatch(obj, name)
            % This method adds the volume of a previously defined solid to the watch list, i.e. the volume of the selected solid is stored for every simulation of the parameter sweep. After the sweep has finished, the results are collected under a "Tables" Folder in the tree view.
            obj.AddToHistory(['.AddVolumeWatch "', num2str(name, '%.15g'), '"']);
        end
        function AddUserdefinedWatch(obj)
            % This method offers the possibility to define a userdefined watch. Only one user defined goal can be added and its results are collected under a "Tables" Folder in the tree view.
            obj.AddToHistory(['.AddUserdefinedWatch']);
        end
        function AddCapacitanceWatch(obj)
            % Adds a capacitance watch.
            obj.AddToHistory(['.AddCapacitanceWatch']);
        end
        function AddInductanceWatch(obj)
            % Adds an inductance watch.
            obj.AddToHistory(['.AddInductanceWatch']);
        end
        function AddEnergyWatch(obj)
            % Adds an energy watch.
            obj.AddToHistory(['.AddEnergyWatch']);
        end
        function AddFieldWatch(obj, x, y, z, key, type)
            % Adds a field watch, specifying the position, the component key and the type of the field to be watched.
            % key can have one of the following values:
            % "X" - X-component of the defined field.
            % "Y" - Y-component of the defined field.
            % "Z" - Z-component of the defined field.
            % "Abs" - Absolut value of the define field.
            % "Scalar" - Setting for scalar field types (e.g. potentials in electrostatic calculations).
            % type can have one of the following values:
            % "E-Field" - Electric field strength in case of an electrostatic calculation.
            % "D-Field" - Electric flux density in case of an electrostatic calculation.
            % "H-Field" - Magnetic field strength in case of a magnetostatic calculation.
            % "B-Field" - Magnetic flux density in case of a magnetostatic calculation.
            % "Potential" - Potential field in case of an electrostatic calculation.
            obj.AddToHistory(['.AddFieldWatch "', num2str(x, '%.15g'), '", '...
                                             '"', num2str(y, '%.15g'), '", '...
                                             '"', num2str(z, '%.15g'), '", '...
                                             '"', num2str(key, '%.15g'), '", '...
                                             '"', num2str(type, '%.15g'), '"']);
        end
        function AddForceWatchEx(obj, solidname, key, x, y, z, xaxis, yaxis, zaxis, bAutoExtend)
            % Adds a force watch, specifying the corresponding solid, the force component ant in case of a torque component, the torque's origin and axis normal.
            % key can have one of the following values:
            % "X" - X-component of the force.
            % "Y" - Y-component of the force.
            % "Z" - Z-component of the force.
            % "Abs" - Absolut value of the force.
            % "Torque" - Torque value.
            % The setting bAutoExtend concerns only the force computation with tetrahedral solvers and will be ignored otherwise.
            % The force computation method requires objects which are surrounded completely by the background or by objects that are equivalent to the background. If bAutoExtend is True, all shapes connected to a specified solid or coil will be collected into one group and the force on this group will be computed. If bAutoExtend is False, the force will be computed on the specified object only, and a warning will be printed if this object is not entirely embedded in background or equivalent material.
            % Please see Force and Torque Calculation for further information.
            obj.AddToHistory(['.AddForceWatchEx "', num2str(solidname, '%.15g'), '", '...
                                               '"', num2str(key, '%.15g'), '", '...
                                               '"', num2str(x, '%.15g'), '", '...
                                               '"', num2str(y, '%.15g'), '", '...
                                               '"', num2str(z, '%.15g'), '", '...
                                               '"', num2str(xaxis, '%.15g'), '", '...
                                               '"', num2str(yaxis, '%.15g'), '", '...
                                               '"', num2str(zaxis, '%.15g'), '", '...
                                               '"', num2str(bAutoExtend, '%.15g'), '"']);
        end
        function AddFrqEnergyWatch(obj, frequency)
            % Adds an energy watch associated with a frequency. SetSimulationType must be set to "Low Frequency".
            obj.AddToHistory(['.AddFrqEnergyWatch "', num2str(frequency, '%.15g'), '"']);
        end
        function AddFrqFieldWatch(obj, x, y, z, key, type, frequency)
            % Adds a field watch associated with a frequency, specifying the position, the component key and the type of the field to be watched. SetSimulationType must be set to "Low Frequency".
            % key can have one of the following values:
            % "X" - X-component of the defined field.
            % "Y" - Y-component of the defined field.
            % "Z" - Z-component of the defined field.
            % "Abs" - Absolut value of the define field.
            % "Scalar" - Setting for scalar field types (e.g. potentials in electrostatic calculations).
            % type can have one of the following values:
            % "E-Field" - Electric field strength in case of an electrostatic calculation.
            % "D-Field" - Electric flux density in case of an electrostatic calculation.
            % "H-Field" - Magnetic field strength in case of a magnetostatic calculation.
            % "B-Field" - Magnetic flux density in case of a magnetostatic calculation.
            % "Potential" - Potential field in case of an electrostatic calculation.
            obj.AddToHistory(['.AddFrqFieldWatch "', num2str(x, '%.15g'), '", '...
                                                '"', num2str(y, '%.15g'), '", '...
                                                '"', num2str(z, '%.15g'), '", '...
                                                '"', num2str(key, '%.15g'), '", '...
                                                '"', num2str(type, '%.15g'), '", '...
                                                '"', num2str(frequency, '%.15g'), '"']);
        end
        function DeleteWatch(obj, name)
            % Deletes a previously defined watch.
            obj.AddToHistory(['.DeleteWatch "', num2str(name, '%.15g'), '"']);
        end
        %% Undocumented functions.
        % Found in history list.
        % Definition below is copied from CST.ResultTree.
        function EnableTreeUpdate(obj, boolean)
            % Enable or disable the update of the tree. After enabling the tree update, this method does actually update the tree also.
            obj.hParameterSweep.invoke('EnableTreeUpdate', boolean);
        end
        % Found in 'Library\Result Templates\Particles\- Export 3D Trajectory Plot as Bitmap^+PS.rtp'
        function index = GetCurrentParameterIndex(obj)
            index = obj.hParameterSweep.invoke('GetCurrentParameterIndex');
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
