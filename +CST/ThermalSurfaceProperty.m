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

% This object offers the possibility to create a thermal surface with its radiation and convection properties. A thermal surface can consist of several different shape faces and is used by the Thermal Solver.
classdef ThermalSurfaceProperty < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ThermalSurfaceProperty object.
        function obj = ThermalSurfaceProperty(project, hProject)
            obj.project = project;
            obj.hThermalSurfaceProperty = hProject.invoke('ThermalSurfaceProperty');
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
            % Resets all internal settings of the thermal surface to its default values.
            obj.AddToHistory(['.Reset']);
            
            obj.name = [];
        end
        function Name(obj, name)
            % Specifies the name of the thermal surface.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function AddFace(obj, solidname, faceid)
            % The thermal surface can consists of several different faces. This method adds a face (indicated by its faceid) of a certain solid (indicated by its solidname) to the face list for the thermal surface.
            obj.AddToHistory(['.AddFace "', num2str(solidname, '%.15g'), '", '...
                                       '"', num2str(faceid, '%.15g'), '"']);
        end
        function UseEmissivityValue(obj, useEmissivity)
            % This setting is taken into account only by conjugated heat transfer simulations. For other thermal simulations, this setting is ignored and the specified emissivity value is always used. For conjugated heat transfer simulations, it is possible to define emissivity as a material property. When this value is to be overwritten on the specified surface, the flag useEmissivity should be set True.  Otherwise (default: useEmissivity = False) the material setting will be used.
            % Please note that settings concerning the emissivity are completely ignored in combination with the conjugated heat transfer solver, if the corresponding radiation flag (CHTSolver.Radiation) is set False.
            obj.AddToHistory(['.UseEmissivityValue "', num2str(useEmissivity, '%.15g'), '"']);
        end
        function Emissivity(obj, expression)
            % Specifies the emissivity value for the radiation of the thermal surface.
            % This setting is ignored completely in combination with the conjugated heat transfer solver, if one of the corresponding radiation flags (UseEmissivityValue or CHTSolver.Radiation) is set False.
            obj.AddToHistory(['.Emissivity "', num2str(expression, '%.15g'), '"']);
        end
        function ConvectiveHeatTransferCoefficient(obj, expression, unit)
            % This setting is considered by the steady-state and transient thermal solvers only.
            % It specifies the convective heat transfer coefficient value for the convection of the thermal surface. The second parameter defines the unit of the heat transfer coefficient. The following units are available:
            % unit            relation
            % "W/m^2/K"       = 0.85984 kcal / (h m² °C) = 0.1761 Btu / (ft² h °F)
            % "Btu/ft^2/h/F"  = 5.678 W / m² / K = 4.882 kcal / (h m² °C)
            % "kcal/h/m^2/C"  = 1.163 W / m² / K = 0.205 Btu / (ft² h °F)
            obj.AddToHistory(['.ConvectiveHeatTransferCoefficient "', num2str(expression, '%.15g'), '", '...
                                                                 '"', num2str(unit, '%.15g'), '"']);
        end
        function UseSurrogateHeatTransfer(obj, overwriteHeatTransfer)
            % This setting is used by the conjugated heat transfer solver only.
            % By default (overwriteHeatTransfer=False), convection and conduction are calculated automatically by the conjugated heat transfer solver. It is possible, to prescribe the heat transfer (convection and conduction) on the given surface. To this end, the flag overwriteHeatTransfer should be set True.
            obj.AddToHistory(['.UseSurrogateHeatTransfer "', num2str(overwriteHeatTransfer, '%.15g'), '"']);
        end
        function SurrogateHeatTransferCoefficient(obj, expression, unit)
            % This setting is used by the conjugated heat transfer solver only.
            % It prescribes the heat transfer (convection/conduction) on the thermal surface. The second parameter defines the unit of the heat transfer coefficient. The following units are available:
            % unit            relation
            % "W/m^2/K"       = 0.85984 kcal / (h m² °C) = 0.1761 Btu / (ft² h °F)
            % "Btu/ft^2/h/F"  = 5.678 W / m² / K = 4.882 kcal / (h m² °C)
            % "kcal/h/m^2/C"  = 1.163 W / m² / K = 0.205 Btu / (ft² h °F)
            obj.AddToHistory(['.SurrogateHeatTransferCoefficient "', num2str(expression, '%.15g'), '", '...
                                                                '"', num2str(unit, '%.15g'), '"']);
        end
        function ReferenceTemperatureType(obj, type)
            % Specifies if the reference temperature is identical to the ambient temperature or if it is defined by a value.
            % enum type       meaning
            % "Ambient"       uses the ambient temperature (defined in the solver settings) as the reference temperature
            % "Userdefined"   allows to define a reference temperature value with the command ReferenceTemperatureValue
            obj.AddToHistory(['.ReferenceTemperatureType "', num2str(type, '%.15g'), '"']);
        end
        function ReferenceTemperatureValue(obj, expression, unit)
            % Specifies the reference temperature value for the convection and/or the emission of the thermal surface. The second parameter is optional, but recommended. It defines the unit of the temperature value. By default, the global user unit is used. Available units are Kelvin, Celsius and Fahrenheit.
            obj.AddToHistory(['.ReferenceTemperatureValue "', num2str(expression, '%.15g'), '", '...
                                                         '"', num2str(unit, '%.15g'), '"']);
        end
        function UsePickedFaces(obj, usePickedFaces)
            % Defines if faces which were picked before the tool activation are used for the definition instead of faces selected by the AddFace command.
            obj.AddToHistory(['.UsePickedFaces "', num2str(usePickedFaces, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the thermal surface with its previously made settings.
            obj.AddToHistory(['.Create']);
            
            % Prepend With ThermalSurfaceProperty and append End With
            obj.history = [ 'With ThermalSurfaceProperty', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ThermalSurfaceProperty: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the thermal surface with the given name.
            obj.project.AddToHistory(['ThermalSurfaceProperty.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the thermal surface with the given oldname to the defined newname.
            obj.project.AddToHistory(['ThermalSurfaceProperty.Rename "', num2str(oldname, '%.15g'), '", '...
                                                                    '"', num2str(newname, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hThermalSurfaceProperty
        history

        name
    end
end

%% Default Settings
% AddFace('', 0)
% UseEmissivityValue('1');
% Emissivity(0.0)
% ConvectiveHeatTransferCoefficient(0.0, 'W/m^2/K');
% ReferenceTemperatureType('Ambient');

%% Example - Taken from CST documentation and translated to MATLAB.
% thermalsurfaceproperty = project.ThermalSurfaceProperty();
%     thermalsurfaceproperty.Reset
%     thermalsurfaceproperty.Name('surfaceprops1');
%     thermalsurfaceproperty.AddFace('component1:solid1', '5');
%     thermalsurfaceproperty.Emissivity('0.1');
%     thermalsurfaceproperty.ConvectiveHeatTransferCoefficient('2', 'W/m^2/K');  
%     thermalsurfaceproperty.ReferenceTemperatureType('UserDefined');  
%     thermalsurfaceproperty.ReferenceTemperatureValue('293.15', 'Kelvin');  
%     thermalsurfaceproperty.Create
