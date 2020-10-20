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

% This object is used to define new contact properties for Thermal Solver and Stationary Current Solver.
classdef ContactProperties < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ContactProperties object.
        function obj = ContactProperties(project, hProject)
            obj.project = project;
            obj.hContactProperties = hProject.invoke('ContactProperties');
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
            % Resets all the internal settings to their default values.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Delete(obj, name)
            % Deletes the contact properties item with the given name.
            obj.project.AddToHistory(['ContactProperties.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new contact properties item. All necessary settings for this object have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With ContactProperties and append End With
            obj.history = [ 'With ContactProperties', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ContactProperties: ', obj.name], obj.history);
            obj.history = [];
        end
        function Name(obj, name)
            % Sets the name of the temperature source. Each source must have a unique name.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function AddFace(obj, solidname, faceid, sideid)
            % A contact properties is created on the surfaces separating solids with sideid = "1" and solids with sideid = 2. This function can be used to identify a solid by its name solidname and face faceid, and assign a sideid to it.
            obj.AddToHistory(['.AddFace "', num2str(solidname, '%.15g'), '", '...
                                       '"', num2str(faceid, '%.15g'), '", '...
                                       '"', num2str(sideid, '%.15g'), '"']);
        end
        function Thickness(obj, thickness)
            % For material-based contact properties, use this function to set the thickness of the contact layer in user units.
            obj.AddToHistory(['.Thickness "', num2str(thickness, '%.15g'), '"']);
        end
        function Material(obj, materialname)
            % For material-based contact properties, use this function to identify the material used for the contact layer. The properties of this material together with the layer thickness described above define the integral properties of the contact layer.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function ElResistance(obj, resistance)
            % Lumped contact properties are defined by the integral values. Use this function to define the electrical resistance (in Ohm) of the whole contact surface. If this value is zero, the stationary current solver will ignore the contact properties.
            obj.AddToHistory(['.ElResistance "', num2str(resistance, '%.15g'), '"']);
        end
        function ThermalResistance(obj, resistance)
            % For lumped contact properties, use this function to define the absolute thermal resistance of the contact layer (in K / W). If this value is zero, this Contact Properties item is ignored by the thermal solvers. Alternatively, the thermal resistance per unit area may be defined for the contact layer by using the function ThermalResistancePerUnitArea.
            obj.AddToHistory(['.ThermalResistance "', num2str(resistance, '%.15g'), '"']);
        end
        function ThermalResistancePerUnitArea(obj, resistance)
            % Alternatively to ThermalResistance, this function may be used to define the thermal resistance per unit area of the contact layer (in K m2 / W). If this value is zero, this Contact Properties item is ignored by the thermal solvers. Both of these functions determine the same property of the contact layer (namely the thermal conductivity of the layer material), so if both of them are specified, the setting of the last command in the list is really adopted.
            obj.AddToHistory(['.ThermalResistancePerUnitArea "', num2str(resistance, '%.15g'), '"']);
        end
        function ThermalCapacitance(obj, capacitance)
            % For lumped contact properties, use this function to define the thermal capacitance of the contact layer (in J / K).
            obj.AddToHistory(['.ThermalCapacitance "', num2str(capacitance, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hContactProperties
        history

        name
    end
end

%% Default Settings
% .Reset
% .Name('contactprops1');
% .ElResistance('0.0');
% .ThermalResistance('0.0');
% .ThermalCapacitance('0.0');

%% Example - Taken from CST documentation and translated to MATLAB.
% contactproperties = project.ContactProperties();
%     contactproperties.Reset
%     contactproperties.Name('contactprops1');
%     contactproperties.Thickness('1e-5');
%     contactproperties.Material('Air');
%     contactproperties.AddFace('component1:solid1', '1', '1');
%     contactproperties.AddFace('component1:solid2', '6', '2');
%     contactproperties.Create
%
