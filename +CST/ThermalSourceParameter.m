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

% This object offers the possibility to define a thermal source based on a given field monitor of a previously performed calculation. These fields are used as a thermal source by the Thermal Solver and can be calculated by stationary current solvers as well as low or high frequency solvers. Moreover this VBA object allows to compute all or selected loss distributions of the current project in order to import them in another project.
classdef ThermalSourceParameter < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ThermalSourceParameter object.
        function obj = ThermalSourceParameter(project, hProject)
            obj.project = project;
            obj.hThermalSourceParameter = hProject.invoke('ThermalSourceParameter');
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
        function CreateThermalDistributions(obj)
            % This command creates all or the previously selected loss distributions for the current project. These loss distribution files can be imported into another project.
            obj.project.AddToHistory(['ThermalSourceParameter.CreateThermalDistributions']);
        end
        function ExportSelectedLosses(obj, flag)
            % Activates or deactivates the selective calculation of thermal loss distributions. This setting is helpful if a project contains many result files and only a a few loss distributions are of interest.
            obj.AddToHistory(['.ExportSelectedLosses "', num2str(flag, '%.15g'), '"']);
        end
        function AddLossForExport(obj, name, parameter, value)
            % Adds a loss distribution or field to the thermal loss computation. The name represents the source name.
            % Available enum values for the parameter are { "Frequency" or "Description" }. If "Frequency" is chosen, than value corresponds to the frequency of the source to be exported. If  "Description" is chosen, than value corresponds to the name of the loss source. This latter option is specifically designed for the losses computed with a time averaging method, for which the frequency value is otherwise meaningless.
            obj.AddToHistory(['.AddLossForExport "', num2str(name, '%.15g'), '", '...
                                                '"', num2str(parameter, '%.15g'), '", '...
                                                '"', num2str(value, '%.15g'), '"']);
        end
        function AddLossForExportInSubVolumeCoords(obj, name, parameter, value, xmin, xmax, ymin, ymax, zmin, zmax)
            % This command has the same functionality as the previous one, but the losses will be computed from the e- and h-fields saved by monitors in the corresponding subvolume.
            obj.AddToHistory(['.AddLossForExportInSubVolumeCoords "', num2str(name, '%.15g'), '", '...
                                                                 '"', num2str(parameter, '%.15g'), '", '...
                                                                 '"', num2str(value, '%.15g'), '", '...
                                                                 '"', num2str(xmin, '%.15g'), '", '...
                                                                 '"', num2str(xmax, '%.15g'), '", '...
                                                                 '"', num2str(ymin, '%.15g'), '", '...
                                                                 '"', num2str(ymax, '%.15g'), '", '...
                                                                 '"', num2str(zmin, '%.15g'), '", '...
                                                                 '"', num2str(zmax, '%.15g'), '"']);
        end
        function UseTriangularSurfaceLossCalc(obj, flag)
            % For simulation results based on hexahedral grids, this setting can be used to switch between two different computation methods for surface losses. Especially if the EM- and the thermal simulation mesh are different this setting should be activated.
            obj.AddToHistory(['.UseTriangularSurfaceLossCalc "', num2str(flag, '%.15g'), '"']);
        end
        function int = GetNumberOfCreatedThermalDistributions(obj)
            % If a loss computation was don this function returns the number of computed loss distributions.
            int = obj.hThermalSourceParameter.invoke('GetNumberOfCreatedThermalDistributions');
        end
        function ResetExportLossSettings(obj)
            % Resets all settings for the thermal loss computation.
            obj.AddToHistory(['.ResetExportLossSettings']);
        end
        function ResetLossFieldSettings(obj)
            % Resets all parameter of the thermal loss field definition.
            obj.AddToHistory(['.ResetLossFieldSettings']);
        end
        function ResetTemperatureSettings(obj)
            % Resets the thermal background temperature definition and the blood temperature.
            obj.AddToHistory(['.ResetTemperatureSettings']);
        end
        function ResetGlobalSurfaceLossSettings(obj)
            % Resets all settings for the surface loss calculation.
            obj.AddToHistory(['.ResetGlobalSurfaceLossSettings']);
        end
        function LossDistDefActive(obj, flag)
            % Activate or deactivate the thermal source field.
            obj.AddToHistory(['.LossDistDefActive "', num2str(flag, '%.15g'), '"']);
        end
        function ExternalProjectPath(obj, name)
            % Define the project path if thermal losses should be imported from an external project.
            obj.AddToHistory(['.ExternalProjectPath "', num2str(name, '%.15g'), '"']);
        end
        function ExternalProjectUseCopy(obj, flag)
            % Define if the local copy should always be used form imported losses, or if losses are updated before the solver is started.
            obj.AddToHistory(['.ExternalProjectUseCopy "', num2str(flag, '%.15g'), '"']);
        end
        function ExternalProjectUseRelativePath(obj, flag)
            % Define if the path-name to an external project is relative or absolute.
            obj.AddToHistory(['.ExternalProjectUseRelativePath "', num2str(flag, '%.15g'), '"']);
        end
        function SourceSetup(obj, name)
            % Specifies the name of the source setup where the losses should be imported from.
            obj.AddToHistory(['.SourceSetup "', num2str(name, '%.15g'), '"']);
        end
        function FrequencyParameter(obj, value)
            % Specifies the frequency to determine the correspondent loss fields.
            obj.AddToHistory(['.FrequencyParameter "', num2str(value, '%.15g'), '"']);
        end
        function Factor(obj, value)
            % Specifies a factor value which is multiplied on the selected current field.
            obj.AddToHistory(['.Factor "', num2str(value, '%.15g'), '"']);
        end
        function SurfaceLossDefaultConductivity(obj, conductivity)
            % Specifies the surface conductivity which is used to compute thermal losses on PEC solids.
            obj.AddToHistory(['.SurfaceLossDefaultConductivity "', num2str(conductivity, '%.15g'), '"']);
        end
        function UseXminForSurfaceLossCalc(obj, flag)
            % Specify if the boundary at Xmin should be taken into account for the surface loss calculation.
            obj.AddToHistory(['.UseXminForSurfaceLossCalc "', num2str(flag, '%.15g'), '"']);
        end
        function UseXmaxForSurfaceLossCalc(obj, flag)
            % Specify if the boundary at Xmax should be taken into account for the surface loss calculation.
            obj.AddToHistory(['.UseXmaxForSurfaceLossCalc "', num2str(flag, '%.15g'), '"']);
        end
        function UseYminForSurfaceLossCalc(obj, flag)
            % Specify if the boundary at Ymin should be taken into account for the surface loss calculation.
            obj.AddToHistory(['.UseYminForSurfaceLossCalc "', num2str(flag, '%.15g'), '"']);
        end
        function UseYmaxForSurfaceLossCalc(obj, flag)
            % Specify if the boundary at Ymax should be taken into account for the surface loss calculation.
            obj.AddToHistory(['.UseYmaxForSurfaceLossCalc "', num2str(flag, '%.15g'), '"']);
        end
        function UseZminForSurfaceLossCalc(obj, flag)
            % Specify if the boundary at Zmin should be taken into account for the surface loss calculation.
            obj.AddToHistory(['.UseZminForSurfaceLossCalc "', num2str(flag, '%.15g'), '"']);
        end
        function UseZmaxForSurfaceLossCalc(obj, flag)
            % Specify if the boundary at Zmax should be taken into account for the surface loss calculation.
            obj.AddToHistory(['.UseZmaxForSurfaceLossCalc "', num2str(flag, '%.15g'), '"']);
        end
        function UseElVolumeLosses(obj, flag)
            % Specify if ohmic volume losses are taken into account for the thermal simulation.
            obj.AddToHistory(['.UseElVolumeLosses "', num2str(flag, '%.15g'), '"']);
        end
        function UseMagVolumeLosses(obj, flag)
            % Specify if magnetic dispersive volume losses are taken into account for the thermal simulation.
            obj.AddToHistory(['.UseMagVolumeLosses "', num2str(flag, '%.15g'), '"']);
        end
        function UseSurfaceLosses(obj, flag)
            % Specify if surface based losses are taken into account for the thermal simulation.
            obj.AddToHistory(['.UseSurfaceLosses "', num2str(flag, '%.15g'), '"']);
        end
        function AddSource(obj)
            % Adds the previously determined current field as a source to the thermal source definition.
            % Please note, that momentarily only one current field can be used as thermal source.
            obj.AddToHistory(['.AddSource']);
            
            % Prepend With ThermalSourceParameter and append End With
            obj.history = [ 'With ThermalSourceParameter', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ThermalSourceParameter settings'], obj.history);
            obj.history = [];
        end
        function MinimumRelativeThermalConductanceForSurfaceLosses(obj, value)
            % This settings defines the relative minimum thermal conductivity of a region where surface loss distributions are taken into account. The minimum conductance value is calculated by multiplying the entered relative value (between 0 and 1) with the maximum conductance value used for a certain example.
            obj.AddToHistory(['.MinimumRelativeThermalConductanceForSurfaceLosses "', num2str(value, '%.15g'), '"']);
        end
        function MinimumRelativeThermalConductanceForVolumeLosses(obj, value)
            % This settings defines the relative minimum thermal conductivity of a region where volume based loss distributions are taken into account. The minimum conductance value is calculated by multiplying the entered relative value (between 0 and 1) with the maximum conductance value used for a certain example.
            obj.AddToHistory(['.MinimumRelativeThermalConductanceForVolumeLosses "', num2str(value, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hThermalSourceParameter
        history

    end
end

%% Default Settings
% Factor(0.0)
% FrequencyParameter(0.0)
% MinimumRelativeThermalConductance(1e-2)

%% Example - Taken from CST documentation and translated to MATLAB.
% Create all loss distributions for an export to another .cst project.
% 
% thermalsourceparameter = project.ThermalSourceParameter();
%     thermalsourceparameter.CreateThermalDistributions
% 
% Applying the field of a stationary current solver run as thermal source:
% 
%     thermalsourceparameter.ResetLossFieldSettings
%     thermalsourceparameter.LossDistDefActive('1');
%     thermalsourceparameter.ExternalProjectPath('J-Statics.cst');
%     thermalsourceparameter.ExternalProjectUseCopy('0');
%     thermalsourceparameter.ExternalProjectUseRelativePath('1');
%     thermalsourceparameter.SourceSetup('Stationary Current Solver');
%     thermalsourceparameter.FrequencyParameter('0');
%     thermalsourceparameter.UseElVolumeLosses('1');
%     thermalsourceparameter.UseMagVolumeLosses('0');
%     thermalsourceparameter.UseSurfaceLosses('0');
%     thermalsourceparameter.Factor('1e6');
%     thermalsourceparameter.MinRelThermConductanceForSurfaceLosses('0.01');
%     thermalsourceparameter.MinRelThermConductanceForVolumeLosses('0.0');
%     thermalsourceparameter.AddSource
% 
% Applying the losses of a transient solver run as thermal source:
% 
%     thermalsourceparameter.ResetLossFieldSettings
%     thermalsourceparameter.LossDistDefActive('1');
%     thermalsourceparameter.ExternalProjectPath('HFTD Seq.cst');
%     thermalsourceparameter.ExternalProjectUseCopy('0');
%     thermalsourceparameter.ExternalProjectUseRelativePath('1');
%     thermalsourceparameter.SourceSetup('Time Domain: S-Parameter [1,1]');
%     thermalsourceparameter.FrequencyParameter('82');
%     thermalsourceparameter.UseElVolumeLosses('1');
%     thermalsourceparameter.UseMagVolumeLosses('1');
%     thermalsourceparameter.UseSurfaceLosses('1');
%     thermalsourceparameter.Factor('100');
%     thermalsourceparameter.MinRelThermConductanceForSurfaceLosses('0.01');
%     thermalsourceparameter.MinRelThermConductanceForVolumeLosses('0.0');
%     thermalsourceparameter.AddSource
% 
