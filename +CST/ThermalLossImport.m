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

% This object offers the possibility to import thermal loss distributions into a thermal projects. For each thermal loss import performed using the FieldSource object, an entry with the same name has to be created, containing the additional settings for this loss import.
classdef ThermalLossImport < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ThermalLossImport object.
        function obj = ThermalLossImport(project, hProject)
            obj.project = project;
            obj.hThermalLossImport = hProject.invoke('ThermalLossImport');
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
            % This command resets all the member variables of the ThermalLossImport object.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function ResetAll(obj)
            % Resets the member variables of the ThermalLossImport object and deletes all the items in it.
            obj.project.AddToHistory(['ThermalLossImport.ResetAll']);
        end
        function FieldName(obj, name)
            % Specifies the name of the loss field imported using the FieldSource object, for which the current ThermalLossImport entry is defined.
            obj.AddToHistory(['.FieldName "', num2str(name, '%.15g'), '"']);
            obj.name = monitorname;
        end
        function Active(obj, flag)
            % Activate or deactivate the thermal loss import.
            obj.AddToHistory(['.Active "', num2str(flag, '%.15g'), '"']);
        end
        function PowerFactor(obj, value)
            % Specifies a factor value, by which the thermal loss field has to be multiplied.
            obj.AddToHistory(['.PowerFactor "', num2str(value, '%.15g'), '"']);
        end
        function LossName(obj, name)
            % Specifies the name of the source setup where the losses should be imported from.
            obj.AddToHistory(['.LossName "', num2str(name, '%.15g'), '"']);
        end
        function AutoLossSelection(obj, flag)
            % If the flag is true, the source setup is selected automatically. In this case, the LossName setting is ignored.
            obj.AddToHistory(['.AutoLossSelection "', num2str(flag, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Assign a new FieldName to the existing ThermalLossImport entry. The corresponding FieldSource object must also be renamed.
            obj.project.AddToHistory(['ThermalLossImport.Rename "', num2str(oldname, '%.15g'), '", '...
                                                               '"', num2str(newname, '%.15g'), '"']);
        end
        function SelectionParameter(obj, parameter, value)
            % Specifies which thermal loss should be selected in the current loss import. The following parameters can be set:
            % Frequency       If the current loss import contains losses for several field frequencies, the loss with frequency value will be selected.
            % Description     In this case, value is interpreted as the name of the specific loss monitor.
            % Eigenmode       If the current loss import contains losses for several eigenmodes, the eigenmode with index equal to value will be selected.
            % Any             Value is interpreted automatically according to the contents of the loss import.
            %
            % For the first two parameter types, the value can be omitted and specified later using the corresponding command:
            obj.AddToHistory(['.SelectionParameter "', num2str(parameter, '%.15g'), '", '...
                                                  '"', num2str(value, '%.15g'), '"']);
        end
        function Frequency(obj, value)
            % If the current loss import contains losses for several field frequencies, the loss with frequency value will be selected.
            obj.AddToHistory(['.Frequency "', num2str(value, '%.15g'), '"']);
        end
        function Description(obj, value)
            % In this case, value is interpreted as the name of the specific loss monitor.
            obj.AddToHistory(['.Description "', num2str(value, '%.15g'), '"']);
        end
        function AutoSelectSubvolume(obj, flag)
            % If the loss import contains losses with given parameter type and value defined in several different subvolumes, the flag marks, whether the subvolume should be selected automatically, or it will be defined by the following call SelectSubvolume.
            obj.AddToHistory(['.AutoSelectSubvolume "', num2str(flag, '%.15g'), '"']);
        end
        function SelectSubvolume(obj, xmin, xmax, ymin, ymax, zmin, zmax)
            % If .AutoSelectSubvolume "True" has been specified, this call defines the subvolume, in which the loss distribution has been calculated. If the set of losses does not contain losses with given parameter type and value in this subvolume, no losses are imported.
            obj.AddToHistory(['.SelectSubvolume "', num2str(xmin, '%.15g'), '", '...
                                               '"', num2str(xmax, '%.15g'), '", '...
                                               '"', num2str(ymin, '%.15g'), '", '...
                                               '"', num2str(ymax, '%.15g'), '", '...
                                               '"', num2str(zmin, '%.15g'), '", '...
                                               '"', num2str(zmax, '%.15g'), '"']);
        end
        function SelectEntireVolume(obj)
            % This call is alternative to the previous one and allows to import the loss distribution defined in the whole solution domain.
            obj.AddToHistory(['.SelectEntireVolume']);
        end
        function SurfaceCond(obj, value)
            % Specifies the surface conductivity which is used to compute thermal losses on PEC solids.
            obj.AddToHistory(['.SurfaceCond "', num2str(value, '%.15g'), '"']);
        end
        function UseElVolLoss(obj, flag)
            % Specify if ohmic volume losses are taken into account for the thermal simulation.
            obj.AddToHistory(['.UseElVolLoss "', num2str(flag, '%.15g'), '"']);
        end
        function UseMagVolLoss(obj, flag)
            % Specify if magnetic dispersive volume losses are taken into account for the thermal simulation.
            obj.AddToHistory(['.UseMagVolLoss "', num2str(flag, '%.15g'), '"']);
        end
        function UseSurfaceLoss(obj, flag)
            % Specify if surface based losses are taken into account for the thermal simulation.
            obj.AddToHistory(['.UseSurfaceLoss "', num2str(flag, '%.15g'), '"']);
        end
        function Create(obj)
            % Adds the previously determined loss field settings set as a new entry to ThermalLossImport object. Please note that each thermal loss import performed by FieldSource object should have a counterpart in ThermalLossImport in order to be handled properly.
            obj.AddToHistory(['.Create']);

            % Prepend With ThermalLossImport and append End With
            obj.history = [ 'With ThermalLossImport', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ThermalLossImport: ', obj.name], obj.history);
            obj.history = [];
        end
        function MinRelThermalCondSrf(obj, value)
            % This settings defines the relative minimum thermal conductivity of a region where surface loss distributions are taken into account. The minimum conductance value is calculated by multiplying the entered relative value (between 0 and 1) with the maximum conductance value used for a certain example. This setting is applied to all the imported thermal surface losses.
            obj.project.AddToHistory(['ThermalLossImport.MinRelThermalCondSrf "', num2str(value, '%.15g'), '"']);
        end
        function MinRelThermalCondVol(obj, value)
            % This settings defines the relative minimum thermal conductivity of a region where volume based loss distributions are taken into account. The minimum conductance value is calculated by multiplying the entered relative value (between 0 and 1) with the maximum conductance value used for a certain example. This setting is applied to all the imported thermal volume losses.
            obj.project.AddToHistory(['ThermalLossImport.MinRelThermalCondVol "', num2str(value, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hThermalLossImport
        history

        name
    end
end

%% Default Settings
% PowerFactor(0.0)
% SelectionParameter('Frequency', '0.0');
% MinRelThermalCondSrf(1e-2)

%% Example - Taken from CST documentation and translated to MATLAB.
% Applying the field of a LF frequency domain solver run as thermal source:
%
% thermallossimport = project.ThermalLossImport();
%     thermallossimport.Reset
%     thermallossimport.Name('thermalloss0');
%     thermallossimport.Id('0');
%     thermallossimport.ProjectPath('LF.cst');
%     thermallossimport.UseRelativePath('1');
%     thermallossimport.SourceName('Thermal Losses');
%     thermallossimport.UseCopyOnly('0');
%     thermallossimport.CreateFieldImport
%     thermallossimport.Reset
%     thermallossimport.FieldName('thermalloss0');
%     thermallossimport.Active('1');
%     thermallossimport.PowerFactor('1');
%     thermallossimport.AutoLossSelection('0');
%     thermallossimport.LossName('LF Frequency Domain Solver');
%     thermallossimport.SelectionParameter('Frequency', '5');
%     thermallossimport.SurfaceCond('0');
%     thermallossimport.UseElVolLoss('1');
%     thermallossimport.UseMagVolLoss('1');
%     thermallossimport.UseSurfaceLoss('1');
%     thermallossimport.Create
%     thermallossimport.MinRelThermalCondSrf('0.01');
%     thermallossimport.MinRelThermalCondVol('0');
%
