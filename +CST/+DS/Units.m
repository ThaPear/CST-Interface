%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Offers functions concerning the units of the current project.
classdef Units < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.DS.Project)
        % Only CST.DS.Project can create a Units object.
        function obj = Units(dsproject, hDSProject)
            obj.dsproject = dsproject;
            obj.hUnits = hDSProject.invoke('Units');
        end
    end
    %% CST Object functions.
    methods
        %% Methods for Geometric Units
        function Geometry(obj, gUnit)
            % Sets the unit of lengths.
            % %
            % gUnit may have the following settings:
            % "m"
            % Meter
            % "cm"
            % Centimeter
            % "mm"
            % Millimeter
            % "um"
            % Micrometer
            % "ft"
            % Feet
            % "in"
            % Inch
            % "mil"
            % A Thousandth Inch
            obj.hUnits.invoke('Geometry', gUnit);
        end
        function enum = GetGeometryUnit(obj)
            % Returns the unit of length of the current project.
            enum = obj.hUnits.invoke('GetGeometryUnit');
        end
        function double = GetGeometryUnitToSI(obj)
            % Returns the factor to convert a geometry value measured in units of the current project into the units.
            % -> a(SI Unit) = factor * b(project Unit)
            double = obj.hUnits.invoke('GetGeometryUnitToSI');
        end
        function double = GetGeometrySIToUnit(obj)
            % Returns the factor to convert a geometry value in SI units into the units defined in the current project.
            % -> a(project Unit) = factor * b(SI Unit)
            double = obj.hUnits.invoke('GetGeometrySIToUnit');
        end
        %% Methods for Time Units
        function Time(obj, tUnit)
            % Sets the unit of time.
            % %
            % tUnit may have the following settings:
            % "fs"
            % Femtosecond
            % 10 -15s
            % "ps"
            % Picosecond
            % 10 -12s
            % "ns"
            % Nanosecond
            % 10 –9 s
            % "us"
            % Microsecond
            % 10 -6 s
            % "ms"
            % Millisecond
            % 10 -3 s
            % "s"
            % Second
            % 1 s 
            obj.hUnits.invoke('Time', tUnit);
        end
        function enum = GetTimeUnit(obj)
            % Returns the unit of time of the current project.
            enum = obj.hUnits.invoke('GetTimeUnit');
        end
        function double = GetTimeUnitToSI(obj)
            % Returns the factor to convert a time value measured in units of the current project into SI units.
            % -> a(SI Unit) = factor * b(project Unit)
            double = obj.hUnits.invoke('GetTimeUnitToSI');
        end
        function double = GetTimeSIToUnit(obj)
            % Returns the factor to convert a time value in SI units into the units defined in the current project.
            % -> a(project Unit) = factor * b(SI Unit)
            double = obj.hUnits.invoke('GetTimeSIToUnit');
        end
        %% Methods for Frequency Units
        function Frequency(obj, fUnit)
            % Sets the unit of frequency.
            % %
            % fUnit may have the following settings:
            % "Hz"
            % Hertz
            % 1 Hz 
            % "kHz"
            % Kilohertz
            % 10 3 Hz
            % "MHz"
            % Megahertz
            % 10 6 Hz
            % "GHz"
            % Gigahertz
            % 10 9 Hz
            % "THz"
            % Terahertz
            % 10 12 Hz
            % "PHz"
            % Petahertz
            % 10 15 Hz
            obj.hUnits.invoke('Frequency', fUnit);
        end
        function enum = GetFrequencyUnit(obj)
            % Returns the unit of frequency of the current project.
            enum = obj.hUnits.invoke('GetFrequencyUnit');
        end
        function double = GetFrequencyUnitToSI(obj)
            % Returns the factor to convert a frequency value measured in units of the current project into SI units.
            % -> a(SI Unit) = factor * b(project Unit)
            double = obj.hUnits.invoke('GetFrequencyUnitToSI');
        end
        function double = GetFrequencySIToUnit(obj)
            % Returns the factor to convert a frequency value in SI units into the units defined in the current project.
            % -> a(project Unit) = factor * b(SI Unit)
            double = obj.hUnits.invoke('GetFrequencySIToUnit');
        end
        %% Methods for Voltage Units
        function Voltage(obj, gUnit)
            % Sets the unit of lengths.
            % %
            % gUnit may have the following settings:
            % "MegaV"
            % Megavolt
            % "KiloV"
            % Kilovolt
            % "V"
            % Volt
            % "MilliV"
            % Millivolt
            % "MicroV"
            % Microvolt
            % "NanoV"
            % Nanovolt
            obj.hUnits.invoke('Voltage', gUnit);
        end
        function enum = GetVoltageUnit(obj)
            % Returns the unit of voltage of the current project.
            enum = obj.hUnits.invoke('GetVoltageUnit');
        end
        function double = GetVoltageUnitToSI(obj)
            % Returns the factor to convert a voltage value measured in units of the current project into the units.
            % -> a(SI Unit) = factor * b(project Unit)
            double = obj.hUnits.invoke('GetVoltageUnitToSI');
        end
        function double = GetVoltageSIToUnit(obj)
            % Returns the factor to convert a voltage value in SI units into the units defined in the current project.
            % -> a(project Unit) = factor * b(SI Unit)
            double = obj.hUnits.invoke('GetVoltageSIToUnit');
        end
        %% Methods for Current Units
        function Current(obj, gUnit)
            % Sets the unit of currents.
            % %
            % gUnit may have the following settings:
            % "MegaA"
            % Megaampere
            % "KiloA"
            % Kiloampere
            % "A"
            % Ampere
            % "MilliA"
            % Milliampere
            % "MicroA"
            % Microampere
            % "NanoA"
            % Nanoampere
            obj.hUnits.invoke('Current', gUnit);
        end
        function enum = GetCurrentUnit(obj)
            % Returns the unit of current of the current project.
            enum = obj.hUnits.invoke('GetCurrentUnit');
        end
        function double = GetCurrentUnitToSI(obj)
            % Returns the factor to convert a current value measured in units of the current project into the units.
            % -> a(SI Unit) = factor * b(project Unit)
            double = obj.hUnits.invoke('GetCurrentUnitToSI');
        end
        function double = GetCurrentSIToUnit(obj)
            % Returns the factor to convert a current value in SI units into the units defined in the current project.
            % -> a(project Unit) = factor * b(SI Unit)
            double = obj.hUnits.invoke('GetCurrentSIToUnit');
        end
        %% Methods for Resistance Units
        function Resistance(obj, gUnit)
            % Sets the unit of resistances.
            % %
            % gUnit may have the following settings:
            % "MicroOhm"
            % Microohm
            % "MilliOhm"
            % Milliohm
            % "Ohm"
            % Ohm
            % "KiloOhm"
            % Kiloohm
            % "MegaOhm"
            % Megaohm
            % "GOhm"
            % Gigaohm
            obj.hUnits.invoke('Resistance', gUnit);
        end
        function enum = GetResistanceUnit(obj)
            % Returns the unit of resistance of the current project.
            enum = obj.hUnits.invoke('GetResistanceUnit');
        end
        function double = GetResistanceUnitToSI(obj)
            % Returns the factor to convert a resistance value measured in units of the current project into the units.
            % -> a(SI Unit) = factor * b(project Unit)
            double = obj.hUnits.invoke('GetResistanceUnitToSI');
        end
        function double = GetResistanceSIToUnit(obj)
            % Returns the factor to convert a resistance value in SI units into the units defined in the current project.
            % -> a(project Unit) = factor * b(SI Unit)
            double = obj.hUnits.invoke('GetResistanceSIToUnit');
        end
        %% Methods for Conductance Units
        function Conductance(obj, gUnit)
            % Sets the unit of conductances.
            % %
            % gUnit may have the following settings:
            % "Siemens"
            % Siemens
            % "MilliS"
            % Millisiemens
            % "MicroS"
            % Microsiemens
            % "NanoS"
            % Nanosiemens
            obj.hUnits.invoke('Conductance', gUnit);
        end
        function enum = GetConductanceUnit(obj)
            % Returns the unit of conductance of the current project.
            enum = obj.hUnits.invoke('GetConductanceUnit');
        end
        function double = GetConductanceUnitToSI(obj)
            % Returns the factor to convert a conductance value measured in units of the current project into the units.
            % -> a(SI Unit) = factor * b(project Unit)
            double = obj.hUnits.invoke('GetConductanceUnitToSI');
        end
        function double = GetConductanceSIToUnit(obj)
            % Returns the factor to convert a conductance value in SI units into the units defined in the current project.
            % -> a(project Unit) = factor * b(SI Unit)
            double = obj.hUnits.invoke('GetConductanceSIToUnit');
        end
        %% Methods for Capacitance Units
        function Capacitance(obj, gUnit)
            % Sets the unit of capacitances.
            % %
            % gUnit may have the following settings:
            % "F"
            % Farad
            % "MilliF"
            % Millifarad
            % "MicroF"
            % Microfarad
            % "NanoF"
            % Nanofarad
            % "PikoF"
            % Picofarad
            % "FemtoF"
            % Femtofarad
            obj.hUnits.invoke('Capacitance', gUnit);
        end
        function enum = GetCapacitanceUnit(obj)
            % Returns the unit of capacitance of the current project.
            enum = obj.hUnits.invoke('GetCapacitanceUnit');
        end
        function double = GetCapacitanceUnitToSI(obj)
            % Returns the factor to convert a capacitance value measured in units of the current project into the units.
            % -> a(SI Unit) = factor * b(project Unit)
            double = obj.hUnits.invoke('GetCapacitanceUnitToSI');
        end
        function double = GetCapacitanceSIToUnit(obj)
            % Returns the factor to convert a capacitance value in SI units into the units defined in the current project.
            % -> a(project Unit) = factor * b(SI Unit)
            double = obj.hUnits.invoke('GetCapacitanceSIToUnit');
        end
        %% Methods for Inductance Units
        function Inductance(obj, gUnit)
            % Sets the unit of inductances.
            % %
            % gUnit may have the following settings:
            % "H"
            % Henry
            % "MilliH"
            % Millihenry
            % "MicroH"
            % Microhenry
            % "NanoH"
            % Nanohenry
            % "PicoH"
            % Picohenry
            obj.hUnits.invoke('Inductance', gUnit);
        end
        function enum = GetInductanceUnit(obj)
            % Returns the unit of inductance of the current project.
            enum = obj.hUnits.invoke('GetInductanceUnit');
        end
        function double = GetInductanceUnitToSI(obj)
            % Returns the factor to convert a inductance value measured in units of the current project into the units.
            % -> a(SI Unit) = factor * b(project Unit)
            double = obj.hUnits.invoke('GetInductanceUnitToSI');
        end
        function double = GetInductanceSIToUnit(obj)
            % Returns the factor to convert a inductance value in SI units into the units defined in the current project.
            % -> a(project Unit) = factor * b(SI Unit)
            double = obj.hUnits.invoke('GetInductanceSIToUnit');
        end
        %% Methods for Temperature Units
        function TemperatureUnit(obj, gUnit)
            % Sets the unit of temperatures.
            % %
            % gUnit may have the following settings:
            % "Celsius"
            % dito
            % "Kelvin"
            % dito
            % "Fahrenheit"
            % dito
            obj.hUnits.invoke('TemperatureUnit', gUnit);
        end
        function enum = GetTemperatureUnit(obj)
            % Returns the unit of temperature of the current project.
            enum = obj.hUnits.invoke('GetTemperatureUnit');
        end
        function double = GetTemperatureUnitToSI(obj)
            % Returns the factor to convert a temperature value measured in units of the current project into the units.
            % -> a(SI Unit) = factor * b(project Unit)
            double = obj.hUnits.invoke('GetTemperatureUnitToSI');
        end
        function double = GetTemperatureSIToUnit(obj)
            % Returns the factor to convert a temperature value in SI units into the units defined in the current project.
            % -> a(project Unit) = factor * b(SI Unit)
            double = obj.hUnits.invoke('GetTemperatureSIToUnit');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hUnits

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% units = dsproject.Units();
%     units.Geometry('mm');
%     units.Frequency('GHz');
%     units.Time('s');
%     units.Voltage('MilliV');
%     units.Current('MicroA');
%     units.Resistance('KiloOhm');
%     units.Conductance('MilliS');
%     units.Capacitance('PikoF');
%     units.Inductance('NanoH');
%     units.TemperatureUnit('Celsius');
