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

% Use this object to define discrete ports. Beside waveguide ports or plane waves the discrete ports offers another possibility to feed the calculation domain with power. Three different types of discrete ports are available, considering the excitation as a voltage or current source or as an impedance element which also absorb some power and enables S-parameter calculation.
classdef DiscretePort < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.DiscretePort object.
        function obj = DiscretePort(project, hProject)
            obj.project = project;
            obj.hDiscretePort = hProject.invoke('DiscretePort');
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
        end
        function Create(obj)
            % Creates a new discrete port. All necessary settings have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With DiscretePort and append End With
            obj.history = [ 'With DiscretePort', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define DiscretePort: ', num2str(obj.portnumber, '%.15g')], obj.history);
            obj.history = [];
        end
        function Modify(obj)
            % Modifies an existing discrete port. Only none geometrical settings which were made previously are changed.
            obj.AddToHistory(['.Modify']);
            
            % Prepend With DiscretePort and append End With
            obj.history = [ 'With DiscretePort', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['modify DiscretePort: ', num2str(obj.portnumber, '%.15g')], obj.history);
            obj.history = [];
        end
        function PortNumber(obj, portnumber)
            % Chooses the discrete port by its number.
            obj.AddToHistory(['.PortNumber "', num2str(portnumber, '%.15g'), '"']);
            obj.portnumber = portnumber;
        end
        function Label(obj, label)
            % Sets the label of the discrete port.
            obj.AddToHistory(['.Label "', num2str(label, '%.15g'), '"']);
            obj.label = label;
        end
        function Type(obj, porttype)
            % Defines the type of the discrete port.
            % porttype: 'Sparameter'
            %           'Voltage'
            %           'Current'
            obj.AddToHistory(['.Type "', num2str(porttype, '%.15g'), '"']);
            obj.type = porttype;
        end
        function Impedance(obj, value)
            % Specifies the input impedance of the discrete port, if it is of type "Sparameter".
            obj.AddToHistory(['.Impedance "', num2str(value, '%.15g'), '"']);
            obj.impedance = value;
        end
        function VoltagePortImpedance(obj, value)
            % Specifies the input impedance of the discrete port, if it is of type "Voltage".
            obj.AddToHistory(['.VoltagePortImpedance "', num2str(value, '%.15g'), '"']);
            obj.voltageportimpedance = value;
        end
        function Voltage(obj, value)
            % Specifies the voltage amplitude of the discrete port, if it is of type "Voltage".
            obj.AddToHistory(['.Voltage "', num2str(value, '%.15g'), '"']);
            obj.voltage = value;
        end
        function Current(obj, value)
            % Specifies the current amplitude of the discrete port, if it is of type "Current".
            obj.AddToHistory(['.Current "', num2str(value, '%.15g'), '"']);
            obj.current = value;
        end
        function Radius(obj, value)
            % Specifies a radius for the discrete edge port.
            obj.AddToHistory(['.Radius "', num2str(value, '%.15g'), '"']);
            obj.radius = value;
        end
        function SetP1(obj, picked, x, y, z)
            % Define the starting / end point of the discrete port. If picked is True, the last or second-to-last picked point will be used for the coordinates of the start / end point. Otherwise the point will be defined by x / y / z.
            obj.AddToHistory(['.SetP1 "', num2str(picked, '%.15g'), '", '...
                                     '"', num2str(x, '%.15g'), '", '...
                                     '"', num2str(y, '%.15g'), '", '...
                                     '"', num2str(z, '%.15g'), '"']);
            obj.setp1.picked = picked;
            obj.setp1.x = x;
            obj.setp1.y = y;
            obj.setp1.z = z;
        end
        function SetP2(obj, picked, x, y, z)
            % Define the starting / end point of the discrete port. If picked is True, the last or second-to-last picked point will be used for the coordinates of the start / end point. Otherwise the point will be defined by x / y / z.
            obj.AddToHistory(['.SetP2 "', num2str(picked, '%.15g'), '", '...
                                     '"', num2str(x, '%.15g'), '", '...
                                     '"', num2str(y, '%.15g'), '", '...
                                     '"', num2str(z, '%.15g'), '"']);
            obj.setp2.picked = picked;
            obj.setp2.x = x;
            obj.setp2.y = y;
            obj.setp2.z = z;
        end
        function InvertDirection(obj, boolean)
            % Set switch to True to reverse the orientation of the discrete port. This swaps the definitions of SetP1 and SetP2.
            obj.AddToHistory(['.InvertDirection "', num2str(boolean, '%.15g'), '"']);
            obj.invertdirection = boolean;
        end
        function LocalCoordinates(obj, flag)
            % This method decides whether local (flag = True) or global (flag = False) coordinates will be used for determining the location of the discrete port.
            obj.AddToHistory(['.LocalCoordinates "', num2str(flag, '%.15g'), '"']);
            obj.localcoordinates = flag;
        end
        function Monitor(obj, flag)
            % This method decides whether voltage and current of the discrete port should be monitored or not.
            obj.AddToHistory(['.Monitor "', num2str(flag, '%.15g'), '"']);
            obj.monitor = flag;
        end
        function Wire(obj, wirename)
            % Defines the name of the wire, on which the discrete port is attached to.
            obj.AddToHistory(['.Wire "', num2str(wirename, '%.15g'), '"']);
            obj.wire = wirename;
        end
        function Position(obj, name)
            % Defines the end of the wire, on which the discrete port is attached to. Possible values are 'end1' or 'end2'.
            obj.AddToHistory(['.Position "', num2str(name, '%.15g'), '"']);
            obj.position = name;
        end
        function [dir, index] = GetElementDirIndex(obj, portnumber)
            % Gets the orientation and mesh index of a discrete port, specified by its portnumber. Please note, that in case that the discrete port is not located inside the mesh e.g. due to a defined symmetry plane, then the return values are given as -1.
            functionString = [...
                'Dim dir As Long, index As Long', newline, ...
                'DiscretePort.GetElementDirIndex(', num2str(portnumber, '%.15g'), ', dir, index)', newline, ...
            ];
            returnvalues = {'dir', 'index'};
            [dir, index] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            dir = str2double(dir);
            index = str2double(index);
        end
        function [index] = GetElement2ndIndex(obj, portnumber)
            % A discrete port is defined between two mesh points. This function returns the index of the second mesh point of the discrete port portnumber. Please note, that in case that the discrete port is not located inside the mesh e.g. due to a defined symmetry plane, then the return value is given as -1.
            functionString = [...
                'Dim index As Long', newline, ...
                'DiscretePort.GetElementDirIndex(', num2str(portnumber, '%.15g'), ', index)', newline, ...
            ];
            returnvalues = {'index'};
            [index] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            index = str2double(index);
        end
        function double = GetLength(obj, portnumber)
            % Returns the exact length of the discrete port, specified by its portnumber.
            double = obj.hDiscretePort.invoke('GetLength', portnumber);
            obj.getlength = portnumber;
        end
        function double = GetGridLength(obj, portnumber)
            % Returns the length in mesh representation of the discrete port, specified by its portnumber.
            double = obj.hDiscretePort.invoke('GetGridLength', portnumber);
            obj.getgridlength = portnumber;
        end
        function [x0, y0, z0, x1, y1, z1] = GetCoordinates(obj, portnumber)
            % Queries the start and end point coordinates of a discrete port specified by its portnumber.
            functionString = [...
                'Dim x0 As Double, y0 As Double, z0 As Double', newline, ...
                'Dim x1 As Double, y1 As Double, z1 As Double', newline, ...
                'DiscretePort.GetCoordinates(', num2str(portnumber, '%.15g'), ', x0, y0, z0, x1, y1, z1)', newline, ...
            ];
            returnvalues = {'x0', 'y0', 'z0', 'x1', 'y1', 'z1'};
            [x0, y0, z0, x1, y1, z1] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            x0 = str2double(x0);
            y0 = str2double(y0);
            z0 = str2double(z0);
            x1 = str2double(x1);
            y1 = str2double(y1);
            z1 = str2double(z1);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hDiscretePort
        history

        portnumber
        label
        type
        impedance
        voltageportimpedance
        voltage
        current
        radius
        setp1
        setp2
        invertdirection
        localcoordinates
        monitor
        wire
        position
        getlength
        getgridlength
        getcoordinates
    end
end

%% Default Settings
% PortNumber(1)
% Label('');
% Type('SParameter');
% Impedance(50.0)
% Voltage(1.0)
% Current(1.0)
% SetP1(0, 0.0, 0.0, 0.0)
% SetP2(0, 0.0, 0.0, 0.0)
% InverDirection(0)
% LocalCoordinates(0)
% Monitor(0)
% Radius(0.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% % Define a discrete port
% discreteport = project.DiscretePort();
%     discreteport.Reset
%     discreteport.PortNumber('6');
%     discreteport.Type('Current');
%     discreteport.Impedance('50.0');
%     discreteport.Voltage('1.0');
%     discreteport.Current('2.0');
%     discreteport.SetP1('1', '4.7', '-0.7', '0');
%     discreteport.SetP2('1', '-3.9', '-1.8', '0');
%     discreteport.InvertDirection('0');
%     discreteport.LocalCoordinates('0');
%     discreteport.Monitor('1');
%     discreteport.Radius('0.01');
%     discreteport.Create
% 
% %Delete the discrete port
% Port.Delete(1)
