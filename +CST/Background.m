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
% Warning: Untested

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK>

% The background object defines the kind of material that surrounds your structure. And defines its volume. By default the volume is defined by the maximum distances of your structure.
classdef Background < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Background object.
        function obj = Background(project, hProject)
            obj.project = project;
            obj.hBackground = hProject.invoke('Background');
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
            % Prepend With Background and append End With
            obj.history = [ 'With Background', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Background settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['Background', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal values to their default settings.
            obj.AddToHistory(['.Reset']);
        end
        function Type(obj, materialType)
            % Sets the material type used for the background.
            % materialType can have one of the following values:
            % normal
            % Not  conducting, with relative permittivity epsilon and relative permeability mu.
            % pec
            % Perfect electric conducting material
            obj.AddToHistory(['.Type "', num2str(materialType, '%.15g'), '"']);
        end
        function Epsilon(obj, value)
            % Defines the electric permittivity of the background material.
            obj.AddToHistory(['.Epsilon "', num2str(value, '%.15g'), '"']);
        end
        function Mu(obj, value)
            % Defines the permeability of the background material.
            obj.AddToHistory(['.Mu "', num2str(value, '%.15g'), '"']);
        end
        function ElConductivity(obj, value)
            % Defines the electric conductivity of the background material. This value is considered only for Low Frequency simulations.
            obj.AddToHistory(['.ElConductivity "', num2str(value, '%.15g'), '"']);
        end
        function XminSpace(obj, value)
            % Adds space to the lower or upper x, y or z boundary of the current calculation volume respectively.
            obj.AddToHistory(['.XminSpace "', num2str(value, '%.15g'), '"']);
        end
        function XmaxSpace(obj, value)
            % Adds space to the lower or upper x, y or z boundary of the current calculation volume respectively.
            obj.AddToHistory(['.XmaxSpace "', num2str(value, '%.15g'), '"']);
        end
        function YminSpace(obj, value)
            % Adds space to the lower or upper x, y or z boundary of the current calculation volume respectively.
            obj.AddToHistory(['.YminSpace "', num2str(value, '%.15g'), '"']);
        end
        function YmaxSpace(obj, value)
            % Adds space to the lower or upper x, y or z boundary of the current calculation volume respectively.
            obj.AddToHistory(['.YmaxSpace "', num2str(value, '%.15g'), '"']);
        end
        function ZminSpace(obj, value)
            % Adds space to the lower or upper x, y or z boundary of the current calculation volume respectively.
            obj.AddToHistory(['.ZminSpace "', num2str(value, '%.15g'), '"']);
        end
        function ZmaxSpace(obj, value)
            % Adds space to the lower or upper x, y or z boundary of the current calculation volume respectively.
            obj.AddToHistory(['.ZmaxSpace "', num2str(value, '%.15g'), '"']);
        end
        function ThermalType(obj, thermalMaterialType)
            % Sets the material type used for the background.
            % thermalMaterialType can have one of the following values:
            % normal
            % Not thermal conducting, with relative permittivity epsilon and relative permeability mu.
            % ptc
            % Perfect thermal conducting material
            obj.AddToHistory(['.ThermalType "', num2str(thermalMaterialType, '%.15g'), '"']);
        end
        function ThermalConductivity(obj, value)
            % Thermal conductivity is a property of materials that expresses the heat flux f (W/m2) that will flow through the material if a certain temperature gradient DT (K/m) exists over the material. The unit for value is W/K/m.
            obj.AddToHistory(['.ThermalConductivity "', num2str(value, '%.15g'), '"']);
        end
        function ApplyInAllDirections(obj, flag)
            % Is at the moment used for the background dialog to identify if the xmin value should be applied in all directions.
            obj.AddToHistory(['.ApplyInAllDirections "', num2str(flag, '%.15g'), '"']);
        end
        %% CST 2014 Functions.
        function Mue(obj, value)
            % Defines the permeability of the background material.
            obj.AddToHistory(['.Mue "', num2str(value, '%.15g'), '"']);
        end
        %% Undocumented functions.
        % Found in template: 'Planar Coupler & Divider.cfg'
        % Definition below is copied from CST.Material.
        function HeatCapacity(obj, dValue)
            % (*) property shared among all available material sets
            % This parameter defines the specific heat capacity in [kJ / (K kg)]. This setting is relevant only for transient thermal simulations.
            obj.AddToHistory(['.HeatCapacity "', num2str(dValue, '%.15g'), '"']);
        end
        % Found in template: 'Planar Coupler & Divider.cfg'
        % Definition below is copied from CST.Material.
        function Rho(obj, dValue)
            % (*) property shared among all available material sets property shared among all available material sets
            % Sets the material density value of the material in kg/m^2, i.e. used for SAR calculations.
            % This setting is important for transient thermal simulations.
            obj.AddToHistory(['.Rho "', num2str(dValue, '%.15g'), '"']);
        end
        % Found in history list when defining background
        function ResetBackground(obj)
            obj.AddToHistory(['.ResetBackground']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hBackground
        history
        bulkmode

    end
end

%% Default Settings
% Type('pec');
% Epsilon(1.0)
% Mu(1.0)
% XminSpace(0.0)
% XmaxSpace(0.0)
% YminSpace(0.0)
% YmaxSpace(0.0)
% ZminSpace(0.0)
% ZmaxSpace(0.0)
% ThermalType('normal');
% ThermalConductivity(0.0)
% ApplyInAllDirections(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% background = project.Background();
% .Reset
% .Type('normal');
% .Epsilon('eps');
% .Mu(1.0)
% .XminSpace(50.0)
% .XmaxSpace(50.0)
% .YminSpace(25.0)
% .YmaxSpace(25.0)
% .ZminSpace(50.0)
% .ZmaxSpace(50.0)
% .ThermalType('normal');
% .ThermalConductivity(0.0)
% .ApplyInAllDirections(0)
%
