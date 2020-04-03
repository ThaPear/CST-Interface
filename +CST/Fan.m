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

% This object is used to create new fan object for the Conjugated Heat Transfer Solver.
classdef Fan < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Fan object.
        function obj = Fan(project, hProject)
            obj.project = project;
            obj.hFan = hProject.invoke('Fan');
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
            % Resets all internal settings of the fan source to their default values.
            obj.AddToHistory(['.Reset']);
            
            obj.name = [];
        end
        function Name(obj, name)
            % Specifies the name of the fan.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function FlowType(obj, type)
            % Selects the type of the flow description for the fan. Currently only the type "Normal" is supported.
            obj.AddToHistory(['.FlowType "', num2str(type, '%.15g'), '"']);
        end
        function DeratingFactor(obj, value)
            % Sets the derating factor for the fan.
            % default: value = 1.0
            obj.AddToHistory(['.DeratingFactor "', num2str(value, '%.15g'), '"']);
        end
        function FlowSpecType(obj, type)
            % Specifies whether the temperature or dissipated heat will be prescribed for the fan. Available types are "Dissipated heat" and "Temperature".
            % default: type = "Dissipated heat"
            obj.AddToHistory(['.FlowSpecType "', num2str(type, '%.15g'), '"']);
        end
        function DissipatedHeat(obj, value)
            % Sets the dissipated heat value for the fan in Watt. This setting will be considered by the solver only, if the flow specification type is "Dissipated heat".
            % default: value = 0
            obj.AddToHistory(['.DissipatedHeat "', num2str(value, '%.15g'), '"']);
        end
        function Temperature(obj, value, unit)
            % Sets the temperature value for the fan in the given unit.  Available units are "Celsius", "Fahrenheit" and "Kelvin". This setting will be considered by the solver only, if the flow specification type is "Temperature".
            % default: value = 0, unit = <project temperature unit>
            obj.AddToHistory(['.Temperature "', num2str(value, '%.15g'), '", '...
                                           '"', num2str(unit, '%.15g'), '"']);
        end
        function FanCharacteristics(obj, type)
            % Specifies which parameters will be provided to define the fan characteristics. Available fan characteristic types are:
            % "FixedVolume"   The volume flow rate and the corresponding unit are taken into account.
            % "Linear"        The volume flow rate and the stagnation pressure with respective units are taken into account.
            % "Nonlinear"     The fan characteristics are described by a user-defined Flow rate / Pressure curve.
            %   
            % default: type = "FixedVolume"
            obj.AddToHistory(['.FanCharacteristics "', num2str(type, '%.15g'), '"']);
        end
        function VolumeFlowRate(obj, value)
            % Specifies the volume flow rate. This setting is ignored for the "nonlinear" fan characteristics type.
            % default: value = 0
            obj.AddToHistory(['.VolumeFlowRate "', num2str(value, '%.15g'), '"']);
        end
        function VolumeFlowUnit(obj, unit)
            % Specifies the unit in which the volume flow rate or the fan curve abscissa is given. Available units are "m3/h" and "CFM".
            % default: unit = "m3/h"
            obj.AddToHistory(['.VolumeFlowUnit "', num2str(unit, '%.15g'), '"']);
        end
        function StagnationPressure(obj, value)
            % Specifies the stagnation pressure for the fan. This setting is considered only for the "linear" fan characteristics type.
            % default: value = 0
            obj.AddToHistory(['.StagnationPressure "', num2str(value, '%.15g'), '"']);
        end
        function PressureUnit(obj, unit)
            % Specifies the unit in which the stagnation pressure or fan curve pressure is prescribed. Available units are "atm" and "bar", "Pa" and "psi". This setting is ignored for the "FixedVolume"" fan characteristics type.
            % default: unit = "Pascal"
            obj.AddToHistory(['.PressureUnit "', num2str(unit, '%.15g'), '"']);
        end
        function AddCurveValue(obj, flow_rate, pressure)
            % Adds a (flow_rate, pressure) pair to the user-defined nonlinear fan curve definition. At least two pair have to be defined to create a curve. This setting is considered only for the "nonlinear" fan characteristics type.
            obj.AddToHistory(['.AddCurveValue "', num2str(flow_rate, '%.15g'), '", '...
                                             '"', num2str(pressure, '%.15g'), '"']);
        end
        function AddEntryFace(obj, solidname, faceid)
            % Defines the face on which the flow enters the fan. This will be the face belonging to the specified faceid of the solid with name solidname.
            obj.AddToHistory(['.AddEntryFace "', num2str(solidname, '%.15g'), '", '...
                                            '"', num2str(faceid, '%.15g'), '"']);
        end
        function AddExitFace(obj, solidname, faceid)
            % Defines the face on which the flow leaves the fan. This will be the face belonging to the specified faceid of the solid with name solidname.
            obj.AddToHistory(['.AddExitFace "', num2str(solidname, '%.15g'), '", '...
                                           '"', num2str(faceid, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the fan with its previously made settings.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Fan and append End With
            obj.history = [ 'With Fan', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Fan: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the fan with the given name.
            obj.project.AddToHistory(['Fan.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the fan with the given oldname to the defined newname.
            obj.project.AddToHistory(['Fan.Rename "', num2str(oldname, '%.15g'), '", '...
                                                 '"', num2str(newname, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hFan
        history

        name
    end
end

%% Default Settings
% Name('');
% FlowType('Normal');
% DeratingFactor(1)
% FlowSpecType('Dissipated heat');
% DissipatedHeat(0)
% Temperature(0, <project temperature unit>)
% FanCharacteristics('FixedVolume');
% VolumeFlowRate(0)
% VolumeFlowUnit('m3/h');
% StagnationPressure(0)
% PressureUnit('Pa');

%% Example - Taken from CST documentation and translated to MATLAB.
% fan = project.Fan();
%     fan.Reset
%     fan.Name('myfan');
%     fan.FlowType('Normal');
%     fan.DeratingFactor('1');
%     fan.FlowSpecType('Temperature');
%     fan.Temperature('20', 'Celsius');
%     fan.FanCharacteristics('Linear');
%     fan.VolumeFlowUnit('m3/h');
%     fan.PressureUnit('Pa');
%     fan.VolumeFlowRate('0');
%     fan.StagnationPressure('0.2');
%     fan.AddEntryFace('component1:solid5', '4');
%     fan.AddExitFace('component1:solid5', '6');
%     fan.Create
% 
