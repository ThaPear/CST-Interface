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

% Defines a functional monitor which evaluates a function on a specified solid or volume.
classdef TimeMonitor3D < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TimeMonitor3D object.
        function obj = TimeMonitor3D(project, hProject)
            obj.project = project;
            obj.hTimeMonitor3D = hProject.invoke('TimeMonitor3D');
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
        function Reset(obj)
            % Resets all internal values to their default settings.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Name(obj, monitorName)
            % Sets the name of the monitor.
            obj.AddToHistory(['.Name "', num2str(monitorName, '%.15g'), '"']);
            obj.name = monitorName;
        end
        function Rename(obj, oldName, newName)
            % Renames the monitor named oldName to newName.
            obj.project.AddToHistory(['TimeMonitor3D.Rename "', num2str(oldName, '%.15g'), '", '...
                                                           '"', num2str(newName, '%.15g'), '"']);
        end
        function Delete(obj, monitorName)
            % Deletes the monitor named monitorName.
            obj.project.AddToHistory(['TimeMonitor3D.Delete "', num2str(monitorName, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the monitor with the previously applied settings.
            obj.AddToHistory(['.Create']);

            % Prepend With TimeMonitor3D and append End With
            obj.history = [ 'With TimeMonitor3D', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define TimeMonitor3D: ', obj.name], obj.history);
            obj.history = [];
        end
        function Extend2TouchingShapes(obj, bFlag)
            % The implemented force computation method requires that the shape, on which the force is to be computed, is completely surrounded by background. Otherwise the results will be influenced by the touching shapes and can therefore be distorted.
            % In order to ensure reasonable results, connected sets of shapes will be detected automatically, and the force on the entire set connected to the specified shape will be computed. This feature is default and corresponds to bFlag = True. If bFlag is set False, the feature will be disabled and a warning might be printed.
            obj.AddToHistory(['.Extend2TouchingShapes "', num2str(bFlag, '%.15g'), '"']);
        end
        function FieldType(obj, fType)
            % Sets what value is to be monitored.
            %
            % fType can have one of the following values:
            % ”Energy”            The energy will be monitored.
            % "Losses"            Ohmic losses will be monitored.
            % ”Force”             The force on a solid will be monitored.
            % "Coil Voltages"     Coil voltages will be monitored.
            % "I-loss"            Iron losses will be monitored.
            % "Mag.Mom."          Magnetic moment will be monitored.
            obj.AddToHistory(['.FieldType "', num2str(fType, '%.15g'), '"']);
        end
        function UseAllSolids(obj, bFlag)
            % If bFlag is True, the specified function will be evaluated in the entire computation domain, and SolidName and SolidType settings will be ignored.
            obj.AddToHistory(['.UseAllSolids "', num2str(bFlag, '%.15g'), '"']);
        end
        function SolidName(obj, solidName)
            % Sets the name of the solid or volume on which the specified function is to be monitored.
            % Please note that Coil Voltages can be evaluated only on coils and Forces can be evaluated only on non-sheet and non-hybrid solids as well as on coils and solid wires. The options "Background" or "UseAllSolids" are not available for these field types.
            obj.AddToHistory(['.SolidName "', num2str(solidName, '%.15g'), '"']);
        end
        function SolidType(obj, solidType)
            % Sets the type of the solid or volume on which the specified function is to be monitored. This will be "solid", "coil" or "wire" depending on whether SolidName specifies a solid, a coil or a solid wire.
            obj.AddToHistory(['.SolidType "', num2str(solidType, '%.15g'), '"']);
        end
        function ComputeForceDensity(obj, bFlag)
            % Enable the computation of the surface and volume force density fields for monitors of type "Force".
            obj.AddToHistory(['.ComputeForceDensity "', num2str(bFlag, '%.15g'), '"']);
        end
        function TorqueOrigin(obj, X, Y, Z)
            % The torque settings are relevant only, if the "Force" type of the monitor is chosen. The X, Y and Z components of the position and the orientation of the torque axis can be specified here, respectively.
            obj.AddToHistory(['.TorqueOrigin "', num2str(X, '%.15g'), '", '...
                                            '"', num2str(Y, '%.15g'), '", '...
                                            '"', num2str(Z, '%.15g'), '"']);
        end
        function TorqueNormal(obj, X, Y, Z)
            % The torque settings are relevant only, if the "Force" type of the monitor is chosen. The X, Y and Z components of the position and the orientation of the torque axis can be specified here, respectively.
            obj.AddToHistory(['.TorqueNormal "', num2str(X, '%.15g'), '", '...
                                            '"', num2str(Y, '%.15g'), '", '...
                                            '"', num2str(Z, '%.15g'), '"']);
        end
        function IronLossModel(obj, modeltype)
            % The name of the model to be considered. The name can be chosen among: "Steinmetz", "Generalized Steinmetz",  "Improved Generalized Steinmetz", "Bertotti", "Improved".
            obj.AddToHistory(['.IronLossModel "', num2str(modeltype, '%.15g'), '"']);
        end
        function IronLossPrecalculationMethod(obj, precalculatiomethod)
            % The name of the precalculation method to be considered. The name can be chosen among: "Remove DC", "No Action",  "Fourier Transform". The two precalculationmethods can be used together with the iron loss models: "Steinmetz", "Bertotti" and "Improved".
            obj.AddToHistory(['.IronLossPrecalculationMethod "', num2str(precalculatiomethod, '%.15g'), '"']);
        end
        function IronLossTimeAveraging(obj, method, value, period)
            % Uses a time range for the calculation of iron losses. The available methods for definition of the time range are "None", "Auto", "Start" and "End". The value defines for the methods "Start" and "End" the start and respectively the end time of the time range. The period is used for the methods "Auto", "Start" and "End" to determine the size of the time range. The method "None", which consider all calculated points for the computation of losses, cannot be used together with the precalculation methods "Remove DC" or "Fourier Transform".
            obj.AddToHistory(['.IronLossTimeAveraging "', num2str(method, '%.15g'), '", '...
                                                     '"', num2str(value, '%.15g'), '", '...
                                                     '"', num2str(period, '%.15g'), '"']);
        end
        function IronLossFrequencySamples(obj, numberfrequencies)
            % Number of frequencies to be considered.
            obj.AddToHistory(['.IronLossFrequencySamples "', num2str(numberfrequencies, '%.15g'), '"']);
        end
        function IronLossFrequencyRange(obj, start, stop)
            % Values of the bounds of the frequency range.
            obj.AddToHistory(['.IronLossFrequencyRange "', num2str(start, '%.15g'), '", '...
                                                      '"', num2str(stop, '%.15g'), '"']);
        end
        function SetIronLossModelParameter(obj, parametertype, value)
            % Assign a value to the parameter knowing the name of it. "parametertype" can have one of these values: "C", "x", "y", "Alpha", "Khys", "Kedd", "Kexc", "a1", "a2", "a3", "a4", "a5".
            obj.AddToHistory(['.SetIronLossModelParameter "', num2str(parametertype, '%.15g'), '", '...
                                                         '"', num2str(value, '%.15g'), '"']);
        end
        %% CST 2014 Functions.
        function SetTimeMonitor3DAutoLabel(obj, bFlag)
            % This flag concerns only the behavior of the dialog box for monitors at points. It specifies whether or not the monitor name is adapted automatically to the settings made in the dialog box. This command will have no influence on the monitor name specified via the VBA command.
            obj.AddToHistory(['.SetTimeMonitor3DAutoLabel "', num2str(bFlag, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTimeMonitor3D
        history

        name
    end
end

%% Default Settings
% UseAllSolids(0)
% Extend2TouchingShapes('1');

%% Example - Taken from CST documentation and translated to MATLAB.
% % creates a time domain energy monitor over the entire computation domain
% timemonitor3d = project.TimeMonitor3D();
%     timemonitor3d.Reset
%     timemonitor3d.Name('monitor on volume');
%     timemonitor3d.FieldType('Energy');
%     timemonitor3d.UseAllSolids('1');
%     timemonitor3d.Create
%
%
