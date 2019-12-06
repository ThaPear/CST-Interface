%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Units < handle
    properties(SetAccess = protected)
        project
        hUnits
        
        geometry
        frequency
        voltage
        resistance
        inductance
        temperature
        time
        current
        conductance
        capacitance
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Units object.
        function obj = Units(project, hProject)
            obj.project = project;
            obj.hUnits = hProject.invoke('Units');
        end
    end
    
    methods
        function AllUnits(obj, geometry, frequency, voltage, resistance,...
                               inductance, temperature, time, current, ...
                               conductance, capacitance)
            history = ['With Units', newline];
            if(nargin > 1  && ~isempty(geometry   ));   obj.geometry = geometry;        history = [history, '     .Geometry "', geometry, '"', newline];        end
            if(nargin > 2  && ~isempty(frequency  ));	obj.frequency = frequency;      history = [history, '     .Frequency "', frequency, '"', newline];      end
            if(nargin > 3  && ~isempty(voltage    ));   obj.voltage = voltage;          history = [history, '     .Voltage "', voltage, '"', newline];          end
            if(nargin > 4  && ~isempty(resistance ));	obj.resistance = resistance;    history = [history, '     .Resistance "', resistance, '"', newline];    end
            if(nargin > 5  && ~isempty(inductance ));	obj.inductance = inductance;    history = [history, '     .Inductance "', inductance, '"', newline];    end
            if(nargin > 6  && ~isempty(temperature));	obj.temperature = temperature;  history = [history, '     .Temperature "', temperature, '"', newline];  end
            if(nargin > 7  && ~isempty(time       ));   obj.time = time;                history = [history, '     .Time "', time, '"', newline];                end
            if(nargin > 8  && ~isempty(current    ));   obj.current = current;          history = [history, '     .Current "', current, '"', newline];          end
            if(nargin > 9  && ~isempty(conductance));	obj.conductance = conductance;  history = [history, '     .Conductance "', conductance, '"', newline];  end
            if(nargin > 10 && ~isempty(capacitance));	obj.capacitance = capacitance;  history = [history, '     .Capacitance "', capacitance, '"', newline];  end
            history = [history, 'End With'];
            obj.project.AddToHistory('define units', history);
        end
        function Geometry(obj, unit)
            % m, cm, mm, um, nm, ft, in, mil
            % Default m.
            % cm: Centimeter
            % mm: Millimeter
            % um: Micrometer
            % nm: Nanometer
            % ft: Feet
            % in: Inch
            % mil: A Thousandth Inch
            obj.geometry = unit;
            
            obj.project.AddToHistory(['Units.Geometry "', unit, '"']);
        end
        function Frequency(obj, unit)
            % Default Hz.
            % Hz, KHz, MHz, GHz, THz, PHz
            obj.frequency = unit;
            
            obj.project.AddToHistory(['Units.Frequency "', unit, '"']);
        end
        function Voltage(obj, unit)
            % Default V.
            % V, ???
            obj.voltage = unit;
            
            obj.project.AddToHistory(['Units.Voltage "', unit, '"']);
        end
        function Resistance(obj, unit)
            % Default Ohm.
            % Ohm, ???
            obj.resistance = unit;
            
            obj.project.AddToHistory(['Units.Resistance "', unit, '"']);
        end
        function Inductance(obj, unit)
            % Default NanoH.
            % H, NanoH, ???
            obj.inductance = unit;
            
            obj.project.AddToHistory(['Units.Inductance "', unit, '"']);
        end
        function Temperature(obj, unit)
            % Default Kelvin.
            % Kelvin, Celcius, Fahrenheit
            obj.temperature = unit;
            
            obj.project.AddToHistory(['Units.TemperatureUnit "', unit, '"']);
        end
        function Time(obj, unit)
            % Default s.
            % s, ms, us, ns, ps, fs
            obj.time = unit;
            
            obj.project.AddToHistory(['Units.Time "', unit, '"']);
        end
        function Current(obj, unit)
            % Default A.
            % A, ???
            obj.current = unit;
            
            obj.project.AddToHistory(['Units.Current "', unit, '"']);
        end
        function Conductance(obj, unit)
            % Default Siemens.
            % Siemens, ???
            obj.conductance = unit;
            
            obj.project.AddToHistory(['Units.Conductance "', unit, '"']);
        end
        function Capacitance(obj, unit)
            % Default PikoF. (With a k)
            % F, PikoF, ???
            obj.capacitance = unit;
            
            obj.project.AddToHistory(['Units.Capacitance "', unit, '"']);
        end
    end
end