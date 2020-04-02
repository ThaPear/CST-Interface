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

% This object is used to calculate conjugated heat transfer problems. The corresponding models can be excited by different source types: fan, heat or  temperature sources or as well by special thermal boundary settings. Thermal surface properties enable the definition of radiation or convection of certain shape faces.
classdef CHTSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.CHTSolver object.
        function obj = CHTSolver(project, hProject)
            obj.project = project;
            obj.hCHTSolver = hProject.invoke('CHTSolver');
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
            % Prepend With CHTSolver and append End With
            obj.history = [ 'With CHTSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define CHTSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['CHTSolver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings of the conjugated heat transfer solver to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function Accuracy(obj, value)
            % Specifies the desired accuracy value for the CHT solver run equation residuals. This setting is considered only, it the UseGlobalAccuracy parameter is True, which is the default. In this case, the detailed accuracy settings for pressure (ContinuityResidual), momentum (MomentumResidual) and heat transfer (HeatTransferResidual) will be ignored.
            % default: value = 0.001
            obj.AddToHistory(['.Accuracy "', num2str(value, '%.15g'), '"']);
        end
        function UseGlobalAccuracy(obj, flag)
            % Specifies if the overall Accuracy value is to be taken into account (flag=True, default), of if the detailed prescriptions of single accuracy values (ContinuityResidual, MomentumResidual, HeatTransferResidual) shall be used instead (flag=False).
            % default: flag = True
            obj.AddToHistory(['.UseGlobalAccuracy "', num2str(flag, '%.15g'), '"']);
        end
        function ContinuityResidual(obj, value)
            % Specifies if the desired equation residual value for the pressure. This setting will be considered only, it the UseGlobalAccuracy flag is False.
            % default: value = 0.001
            obj.AddToHistory(['.ContinuityResidual "', num2str(value, '%.15g'), '"']);
        end
        function MomentumResidual(obj, value)
            % Specifies if the desired equation residual for the momentum. This setting will be considered only, it the UseGlobalAccuracy flag is False.
            % default: value = 0.001
            obj.AddToHistory(['.MomentumResidual "', num2str(value, '%.15g'), '"']);
        end
        function HeatTransferResidual(obj, value)
            % Specifies if the desired equation residual for the heat transfer. This setting will be considered only, it the UseGlobalAccuracy flag is False.
            % default: value = 0.001
            obj.AddToHistory(['.HeatTransferResidual "', num2str(value, '%.15g'), '"']);
        end
        function GlobalEquationBalance(obj, value)
            % Specifies the desired accuracy value for the CHT solver run equation balances. This setting is considered only, it the UseGlobalEquationBalance parameter is True, which is the default. In this case, the detailed settings for mass flow (MassFlowResidual), fluid heat flux (FluidHeatFluxResidual) and solid heat flux (SolidHeatFluxResidual) will be ignored.
            % default: value = 0.01
            obj.AddToHistory(['.GlobalEquationBalance "', num2str(value, '%.15g'), '"']);
        end
        function UseGlobalEquationBalance(obj, flag)
            % Specifies if the overall Accuracy value is to be taken into account (flag=True, default), of if the detailed prescriptions of single accuracy values (MassFlowResidual, FluidHeatFluxResidual, SolidHeatFluxResidual) shall be used instead (flag=False).
            % default: flag = True
            obj.AddToHistory(['.UseGlobalEquationBalance "', num2str(flag, '%.15g'), '"']);
        end
        function MassFlowResidual(obj, value)
            % Specifies if the desired equation balance for the mass flow. This setting will be considered only, it the UseGlobalEquationBalance flag is False.
            % default: value = 0.01
            obj.AddToHistory(['.MassFlowResidual "', num2str(value, '%.15g'), '"']);
        end
        function FluidHeatFluxResidual(obj, value)
            % Specifies if the desired equation balance for the fluid heat flux. This setting will be considered only, it the UseGlobalEquationBalance flag is False.
            % default: value = 0.01
            obj.AddToHistory(['.FluidHeatFluxResidual "', num2str(value, '%.15g'), '"']);
        end
        function SolidHeatFluxResidual(obj, value)
            % Specifies if the desired equation balance for the solid heat flux. This setting will be considered only, it the UseGlobalEquationBalance flag is False.
            % default: value = 0.01
            obj.AddToHistory(['.SolidHeatFluxResidual "', num2str(value, '%.15g'), '"']);
        end
        function MaximumNumberOfIterations(obj, value)
            % The number of iterations performed by the linear solver is automatically limited by a number depending on the desired solver accuracy. This is equivalent to setting the value to "0". If you would like to prescribe a fixed upper limit for number of linear iterations, then specify the corresponding value here.
            % default: value = 0
            obj.AddToHistory(['.MaximumNumberOfIterations "', num2str(value, '%.15g'), '"']);
        end
        function MinimumNumberOfIterations(obj, value)
            % A calculation will perform at least one iteration of the linear solver. To set a lower limit for the number of iterations, specify the corresponding value here. By default, the lower limit is set to four iterations.
            % default: value = 4
            obj.AddToHistory(['.MinimumNumberOfIterations "', num2str(value, '%.15g'), '"']);
        end
        function UseRelativeVelocityUpdate(obj, flag)
            % Specifies if the relative velocity update is to be taken into account as a convergence criterion. Note that all conditions including equation balances, residuals, and custom stop criteria have to be fulfilled to stop the solver.
            % default: flag = True
            obj.AddToHistory(['.UseRelativeVelocityUpdate "', num2str(flag, '%.15g'), '"']);
        end
        function RelativeVelocityUpdate(obj, value)
            % Sets the maximum relative change in the velocity vector field allowed to reach convergence. Note that this value will be taken into account only, if the UseRelativeVelocityUpdate flag is False.
            % default: value = 0.01
            obj.AddToHistory(['.RelativeVelocityUpdate "', num2str(value, '%.15g'), '"']);
        end
        function AddConvergenceCriterion(obj, name, dim, threshold, numchecks, active)
            % In addition to the residual and equation balance settings, goal oriented convergence criteria can be defined. Such a custom stop criterion is based on a point monitor (dim=0) or on a face monitor (dim=2). With the parameters name and dim the monitor is selected, where dim = 0 stands for monitors at points and dim = 2 stands for monitors on faces. If no appropriate monitor with the given name has been defined before, an error message will be printed.
            % The parameter threshold sets the criterion for the maximum relative change between two iterations. This number must be given in percent, i.e. a value between 0 and 100.
            % The parameter numchecks specifies, in how many successive iterations the convergence criterion must be fulfilled.
            % The last argument active is optional and True by default. The convergence criterion can be deactivated for the solver run by setting this flag to False.
            % Note that all conditions including relative update (if turned on) , equation balances, residuals, and custom stop criteria have to be fulfilled to stop the solver.
            if(nargin < 6)
                obj.AddToHistory(['.AddConvergenceCriterion "', num2str(name, '%.15g'), '", '...
                                                           '"', num2str(dim, '%.15g'), '", '...
                                                           '"', num2str(threshold, '%.15g'), '", '...
                                                           '"', num2str(numchecks, '%.15g'), '"']);
            else
                obj.AddToHistory(['.AddConvergenceCriterion "', num2str(name, '%.15g'), '", '...
                                                           '"', num2str(dim, '%.15g'), '", '...
                                                           '"', num2str(threshold, '%.15g'), '", '...
                                                           '"', num2str(numchecks, '%.15g'), '", '...
                                                           '"', num2str(active, '%.15g'), '"']);
            end
        end
        function SetSolutionLimit(obj, type, stop_solver, lower_bound, upper_bound, unit)
            % When the simulation seems to diverge, it can be aborted, before the maximum number of iterations is reached. The range in which a quantity (given by type) may vary for intermediate solutions during the simulation can be set by the values lower_bound and upper_bound. Supported quantities are
            % enum type               meaning                                     Default lower bound     Default upper bound     Default unit    Default stop solver
            % "Velocity"              Velocity                                    -200                    200                     m/s             True
            % "PressureDensityRatio"  Ratio pressure / background density         -5000                   5000                    m²/s²           True
            % "Temperature"           Temperature                                 0                       5000                    Kelvin          True
            % "Viscosity"             Turbulence viscosity ratio 
            %                         (turbulence viscosity / laminar viscosity)  0                       1e5                                     False
            if(nargin < 6)
                obj.AddToHistory(['.SetSolutionLimit "', num2str(type, '%.15g'), '", '...
                                                    '"', num2str(stop_solver, '%.15g'), '", '...
                                                    '"', num2str(lower_bound, '%.15g'), '", '...
                                                    '"', num2str(upper_bound, '%.15g'), '"']);
            else
                obj.AddToHistory(['.SetSolutionLimit "', num2str(type, '%.15g'), '", '...
                                                    '"', num2str(stop_solver, '%.15g'), '", '...
                                                    '"', num2str(lower_bound, '%.15g'), '", '...
                                                    '"', num2str(upper_bound, '%.15g'), '", '...
                                                    '"', num2str(unit, '%.15g'), '"']);
            end
        end
        function the = It(obj)
            % The optional parameter unit specifies the unit in which the "Velocity" or "Temperature" limits are given. By default, "m/s" or "Kelvin" are assumed, respectively. This setting will be ignored for the "PressureDensityRatio" and "Viscosity" types. Available velocity units are "m/s" and "km/h". Available temperature units are "Celsius", "Fahrenheit" and "Kelvin".
            the = obj.hCHTSolver.invoke('It');
        end
        function AmbientTemperatureUnit(obj, value, unit)
            % Sets the background temperature value and the corresponding temperature unit. Available units are "Celsius", "Fahrenheit" and "Kelvin".
            % default: value = 293.15, unit = Kelvin
            obj.AddToHistory(['.AmbientTemperatureUnit "', num2str(value, '%.15g'), '", '...
                                                      '"', num2str(unit, '%.15g'), '"']);
        end
        function AmbientRadiationTemperatureUnit(obj, value, unit)
            % Sets the solar temperature value and the corresponding temperature unit. Available units are "Celsius", "Fahrenheit" and "Kelvin".
            % default: value = 293.15, unit = Kelvin
            obj.AddToHistory(['.AmbientRadiationTemperatureUnit "', num2str(value, '%.15g'), '", '...
                                                               '"', num2str(unit, '%.15g'), '"']);
        end
        function Gravity(obj, X, Y)
            % Specifies the gravitation vector in global X, Y, Z coordinates in m/s². This setting is taken into account only, if the UseGravity flag is set to True. By default, the gravity is ignored in a CHT calculation.
            % default: X = 0, Y = 0, Z = -9.81
            obj.AddToHistory(['.Gravity "', num2str(X, '%.15g'), '", '...
                                       '"', num2str(Y, '%.15g'), '"']);
        end
        function UseGravity(obj, flag)
            % Specifies if the Gravity setting shall be taken into account (flag=True) by the solver. By default, the gravity setting is ignored.
            % default: flag = False
            obj.AddToHistory(['.UseGravity "', num2str(flag, '%.15g'), '"']);
        end
        function FlowOnly(obj, flag)
            % If this setting is activated (flag=True), only the flow will be simulated and all heat transfers will be ignored. In this case, the FreezeFlow, ThermalConductionOnly, Radiation and SolarRadiation flags will be set to False, internally.
            % Please note that a later command wins over previous settings.
            % default: flag = False
            obj.AddToHistory(['.FlowOnly "', num2str(flag, '%.15g'), '"']);
        end
        function FreezeFlow(obj, flag)
            % If this setting is activated (flag=True), flow and thermal conduction will not be simulated. In this case, the FlowOnly and ThermalConductionOnly flags will be set to False, internally.
            % Please note that, this setting is not yet supported by the CHT solver.
            % Please note that a later command wins over previous settings.
            % default: flag = False
            obj.AddToHistory(['.FreezeFlow "', num2str(flag, '%.15g'), '"']);
        end
        function ThermalConductionOnly(obj, flag)
            % If this setting is activated (flag=True), only heat conduction/diffusion in fluids and solids will be simulated, but no heat and flow advection. In this case, the FlowOnly and FreezeFlow flags will be set to False, internally. Radiation can be defined in addition.  
            % Please note that a later command wins over previous settings.
            % default: flag = False
            obj.AddToHistory(['.ThermalConductionOnly "', num2str(flag, '%.15g'), '"']);
        end
        function Radiation(obj, flag)
            % If this setting is activated (flag=True), the contribution of heat radiation will be added to the heat transfers. Only thermal surface properties, isothermal walls and the surfaces of solids with a non-zero emissivity are taken into account. In this case, the FlowOnly flag will be set to False, internally.
            % Please note that a later command wins over previous settings.
            % default: flag = False
            obj.AddToHistory(['.Radiation "', num2str(flag, '%.15g'), '"']);
        end
        function SolarRadiation(obj, flag)
            % If this setting is activated (flag=True), solar radiation will be taken into account. In this case, the FlowOnly flag will be set to False, internally.
            % Please note that, this setting is not yet supported by the CHT solver.
            % Please note that a later command wins over previous settings.
            % default: flag = False
            obj.AddToHistory(['.SolarRadiation "', num2str(flag, '%.15g'), '"']);
        end
        function TurbulenceModel(obj, model)
            % Specifies how turbulence is defined in the solver. The following models are supported:
            % enum model          meaning
            % "Automatic"         The model will be selected by the solver, either laminar or zero-equation turbulent, depending on the model and further solver setup.
            % "Laminar"           No turbulence will be taken into account.
            % "Zero-Equation"     The zero-equation turbulence model will be used.
            % "Two-Equation"      The two-equation turbulence model will be used. Further parameters can be specified, see TurbulenceDefault and TurbulenceProperties.
            % default: model = "Automatic"
            obj.AddToHistory(['.TurbulenceModel "', num2str(model, '%.15g'), '"']);
        end
        function ResetTurbulenceProperties(obj)
            % For the "Two-Equation" Turbulence Model, further parameters can be defined. It is recommended to reset all previous turbulence parameter definitions before providing a new set of turbulence properties. This can be done by calling this command. For other turbulence models this call is irrelevant.
            obj.AddToHistory(['.ResetTurbulenceProperties']);
        end
        function TurbulenceDefault(obj, coeff1_type, coeff1_value, coeff2_value)
            % For the "Two-Equation" Turbulence Model, the equation coefficients can be specified for inlets. An inlet is an opening which allows flow entering the calculation domain, see also TurbulenceProperties.
            % Inlets without any specification inherit default settings, usually an intensity value of 1% and an eddy length scale value of 10%. These default settings can be modified here. Available coefficient types are:
            % enum coeffN_type    meaning
            % "Intensity"         The following coeff_value will specify the turbulent intensity I in %.
            %                     A positive number between 0 and 100 is expected for coeff_value.
            % "Length"            The following coeff_value  will specify the eddy length L in % as a percentage of the 
            %                     characteristic dimension of the inlet, which depends on the geometry and computes from 
            %                     the ratio of inlet area and inlet perimeter multiplied by a factor 4.
            %                     A positive number between 0 and 100 is expected for coeff_value.
            % "Energy"            The following coeff_value will specify .the turbulent kinetic energy K in J/kg.
            %                     A positive number is expected for coeff_value.
            % "Dissipation"       The following coeff_value will specify the turbulent kinetic dissipation rate Eps in J/kg.
            %                     A positive number is expected for coeff_value.
            obj.AddToHistory(['.TurbulenceDefault "', num2str(coeff1_type, '%.15g'), '", '...
                                                 '"', num2str(coeff1_value, '%.15g'), '", '...
                                                 '"', num2str(coeff2_value, '%.15g'), '"']);
        end
        function note = Please(obj)
            % Please note that this setting is not relevant for other turbulence models than the "Two-Equation" model.
            % default: coeff1_type = "Intensity", coeff1_value = 1.0, coeff2_type = "Length", coeff2_value = 10
            note = obj.hCHTSolver.invoke('Please');
        end
        function TurbulenceProperties(obj, inlet_type, inlet_name, coeff1_type, coeff1_value, coeff2_value)
            % For the "Two-Equation" Turbulence Model, the equation coefficients can be specified for inlets. An inlet is an opening which allows flow entering the calculation domain, as characterized in the following table:
            % enum inlet_type     considered for turbulence setup if...
            % "Fan"               - entry face is planar and aligned with a boundary of the calculation domain
            %                     - the flow enters the computational domain
            % "Boundary"          - flow quantity is "Velocity" and the velocity vector points into the calculation domain
            %                     or
            %                     - no velocity-based boundary is defined and
            %                     - boundary has the highest gauge pressure value
            %                     - but not all pressure-based boundaries have the same value
            %   
            % If the inlet_type is "Fan",  the inlet_name is the fan name. If the inlet_type is "Boundary", the inlet_name should be "Xmin", "Xmax", "Ymin", "YMax", "Zmin" or "Zmax" depending on the position of the boundary in the calculation domain.
            % Please note that depending on the geometry and setup of the model, the validity of an inlet can change. It is possible to define parameters for all boundaries and fans. Only the settings for the valid ones (according to the above table) will be taken into account for the calculation.
            % For each inlet, the default setting can be overwritten by specifying a pair of coefficient types (coeff1_type, coeff2_type) each followed by the corresponding value (coeff1_value, coeff2_value). Valid coefficient types and values are explained for the TurbulenceDefault command.
            % Please note that only "Intensity" and "Length" can be combined for coeff1_type and coeff2_type or "Energy" and "Dissipation", respectively; no mixed combinations.
            % Please note that this setting is not relevant for other turbulence models than the "Two-Equation" model.
            obj.AddToHistory(['.TurbulenceProperties "', num2str(inlet_type, '%.15g'), '", '...
                                                    '"', num2str(inlet_name, '%.15g'), '", '...
                                                    '"', num2str(coeff1_type, '%.15g'), '", '...
                                                    '"', num2str(coeff1_value, '%.15g'), '", '...
                                                    '"', num2str(coeff2_value, '%.15g'), '"']);
        end
        function AdaptiveSteadyStateCFL(obj, value)
            % A stability factor (Courant-Friedrichs-Lewy number) can be defined, which influences the stability limit of internal numerical calculations. If the calculation process shows slight effects of instability, a small reduction of the stability factor might recover a stable state. Note: Choosing a factor greater than one is not advisable and will likely produce instability. By default, the stability factor is determined automatically which is equivalent to the value=0.
            % default: value = 0
            obj.AddToHistory(['.AdaptiveSteadyStateCFL "', num2str(value, '%.15g'), '"']);
        end
        function OverwriteBackgroundMaterial(obj, flag)
            % The background is usually defined by the background properties and ambient conditions. Usually the background is air at mean sea level. To simulate air at a higher altitude, this flag must be set to True. Please mind that the density setting of the background material will be overwritten in this case. Please avoid activating this flag for non-air background material.
            % default: flag = False
            obj.AddToHistory(['.OverwriteBackgroundMaterial "', num2str(flag, '%.15g'), '"']);
        end
        function Altitude(obj, value)
            % This value specifies the geometric altitude above mean see level for background simulated as air. The atmospheric pressure as well as the atmospheric density will be calculated automatically.
            % Please not that this setting will be ignored, if the OverwriteBackgroundMaterial flag is False.
            % default: value = 0
            obj.AddToHistory(['.Altitude "', num2str(value, '%.15g'), '"']);
        end
        function ApplyAltitudeCorrectionToFans(obj, flag)
            % If the background material is overwritten, i.e. the OverwriteBackgroundMaterial flag is True, the altitude correction can be taken into account also for the fan curves. The given fan curve settings will then be corrected automatically in the solver with respect to the given altitude value. If the fan curve data is already provided in the corrected form, the ApplyAltitudeCorrectionToFans flag must be set to False.
            % Please note: This setting will be ignored, if the OverwriteBackgroundMaterial flag is False.
            % default: flag = True
            obj.AddToHistory(['.ApplyAltitudeCorrectionToFans "', num2str(flag, '%.15g'), '"']);
        end
        function UseDistributedComputing(obj, flag)
            % If flag is set to True, this method enables the distributed calculation of different solver runs across the network.
            % default: flag = False
            obj.AddToHistory(['.UseDistributedComputing "', num2str(flag, '%.15g'), '"']);
        end
        function UseMaxNumberOfThreads(obj, flag)
            % This flag should be set to True to activate take advantage of the functionality of a multi-socket, multi-CPU device machine. The calculation will be split into corresponding parts and will run parallel on the different devices and different threads to save simulation time. The desired number of CPU devices and number of threads can provided in the MaxNumberOfThreads and MaximumNumberOfCPUDevices commands.
            % default: flag = True
            obj.AddToHistory(['.UseMaxNumberOfThreads "', num2str(flag, '%.15g'), '"']);
        end
        function MaximumNumberOfCPUDevices(obj, number)
            % Defines the maximum number of devices to which the calculation will be split. This setting will be taken into account only if the UseMaxNumberOfThreads flag is True.
            % default: number = 2
            obj.AddToHistory(['.MaximumNumberOfCPUDevices "', num2str(number, '%.15g'), '"']);
        end
        function MaxNumberOfThreads(obj, number)
            % Defines the maximum number of parallel threads to be used for the conjugated heat transfer solver run. This setting will be taken into account only if the UseMaxNumberOfThreads flag is True.
            % default: number = 4
            obj.AddToHistory(['.MaxNumberOfThreads "', num2str(number, '%.15g'), '"']);
        end
        function HardwareAcceleration(obj, flag)
            % If flag is set to True, hardware acceleration for the conjugated heat transfer solver is activated. Please note, that a hardware acceleration card has to be inserted into your computer in order to profit from this setting.
            % default: flag = False
            obj.AddToHistory(['.HardwareAcceleration "', num2str(flag, '%.15g'), '"']);
        end
        function MaximumNumberOfGPUs(obj, number)
            % Defines the maximum number of GPUs to be used for the conjugated heat transfer solver run. Please not that this setting takes effect only, if a hardware acceleration card has to be inserted into your computer and if the HardwareAcceleration flag is True.
            % default: number = 4
            obj.AddToHistory(['.MaximumNumberOfGPUs "', num2str(number, '%.15g'), '"']);
        end
        function int = Start(obj)
            % Starts the conjugated heat transfer simulation with the current settings and returns 0 if the calculation is successfully finished and an error code >0 otherwise.
            int = obj.hCHTSolver.invoke('Start');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCHTSolver
        history
        bulkmode

    end
end

%% Default Settings
% Accuracy(1e-3)
% AdaptiveSteadyStateCFL(0)
% Altitude(0)
% AmbientRadiationTemperatureUnit(293.15, Kelvin)
% AmbientTemperatureUnit(293.15, Kelvin)
% ContinuityResidual(1e-3)
% FlowOnly(0)
% FluidHeatFluxResidual(1e-2)
% FreezeFlow(0)
% GlobalEquationBalance(1e-2)
% Gravity(0, 0, -9.81)
% HardwareAcceleration(0)
% HeatTransferResidual(1e-3)
% MassFlowResidual(1e-2)
% MaximumNumberOfCPUDevices(2)
% MaximumNumberOfGPUs(1)
% MaxNumberOfThreads(4)
% MomentumResidual(1e-3)
% NumberOfIterations(0)
% OverWriteBackgroundMaterial(0)
% Radiation(0)
% SolarRadiation(0)
% SolidHeatFluxResidual(1e-2)
% ThermalConductionOnly(0)
% TurbulenceDefault('Intensity', 1.0, 'Length', 10.0)
% TurbulenceModel('Automatic');
% UseDistributedComputing(0)
% UseGlobalAccuracy(1)
% UseGlobalEquationBalance(1)
% UseGravity(0)
% UseMaxNumberOfThreads(1)

%% Example - Taken from CST documentation and translated to MATLAB.
% chtsolver = project.CHTSolver();
%     chtsolver.FlowOnly('0');
%     chtsolver.FreezeFlow('0');
%     chtsolver.ThermalConductionOnly('0');
%     chtsolver.Radiation('0');
%     chtsolver.SolarRadiation('0');
%     chtsolver.TurbulenceModel('Two-Equation');
%     chtsolver.AdaptiveSteadyStateCFL('0');
%     chtsolver.OverwriteBackgroundMaterial('0');
%     chtsolver.Altitude('0', 'm');
%     chtsolver.VTKOutput('0');
%     chtsolver.HandleThinVolumes('0');
%     chtsolver.InitialSteadyStateRelax('0');
%     chtsolver.TurbulenceLVELMaxViscosity('0');
%     chtsolver.TurbulenceRelaxation('0');
%     chtsolver.TurbulenceKEpsMaxViscosity('0');
%     chtsolver.ResetTurbulenceProperties
%     chtsolver.TurbulenceDefault('Energy',('1e-6',('Dissipation',('1e-6');
%     chtsolver.TurbulenceProperties('boundary',('Xmax',('Intensity',('2.0',('Length',('12');
%     chtsolver.TurbulenceProperties('boundary',('Ymin',('Energy',('1e-4',('Dissipation',('1e-5');
%     chtsolver.AmbientTemperatureUnit('293.15', 'Kelvin');
%     chtsolver.AmbientRadiationTemperatureUnit('20', 'Celsius');
%     chtsolver.UseGravity('0');
%     chtsolver.Gravity('0', '0', '-9.81');
%     chtsolver.Accuracy('0.001');
%     chtsolver.UseGlobalAccuracy('0');
%     chtsolver.ContinuityResidual('0.05');
%     chtsolver.MomentumResidual('0.04');
%     chtsolver.HeatTransferResidual('0.03');
%     chtsolver.UseGlobalEquationBalance('1');
%     chtsolver.GlobalEquationBalance('0.01');
%     chtsolver.MassFlowResidual('0.01');
%     chtsolver.FluidHeatFluxResidual('0.01');
%     chtsolver.SolidHeatFluxResidual('0.01');
%     chtsolver.NaturalConvectionSpeed('0.3');
%     chtsolver.NumberOfIterations('2000');
%     chtsolver.UseMaxNumberOfThreads('1');
%     chtsolver.MaxNumberOfThreads('4');
%     chtsolver.MaximumNumberOfCPUDevices('2');
%     chtsolver.UseDistributedComputing('0');
%     chtsolver.HardwareAcceleration('0');
%     chtsolver.MaximumNumberOfGPUs('1');
% 
