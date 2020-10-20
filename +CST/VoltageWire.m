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

% Defines a new voltage path on a selected curve.
classdef VoltageWire < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.VoltageWire object.
        function obj = VoltageWire(project, hProject)
            obj.project = project;
            obj.hVoltageWire = hProject.invoke('VoltageWire');
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
            % Resets the default values.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Name(obj, name)
            % Sets the name of the new voltage wire.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Type(obj, curvetype)
            % Specifies the type of the voltage wire. Currently the is only one type available.
            % curvetype: 'curvepath'
            obj.AddToHistory(['.Type "', num2str(curvetype, '%.15g'), '"']);
        end
        function Voltage(obj, value)
            % Specifies the amplitude of the voltage.
            obj.AddToHistory(['.Voltage "', num2str(value, '%.15g'), '"']);
        end
        function Phase(obj, value)
            % Specifies the phase shift of the voltage.
            obj.AddToHistory(['.Phase "', num2str(value, '%.15g'), '"']);
        end
        function Curve(obj, curvename)
            % Specifies the name of a curve to be converted into a voltage wire.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
        end
        function Add(obj)
            % Creates a curve with the previously defined settings.
            obj.AddToHistory(['.Add']);

            % Prepend With VoltageWire and append End With
            obj.history = [ 'With VoltageWire', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define VoltageWire: ', obj.name], obj.history);
            obj.history = [];
        end
        function Change(obj)
            % Changes the settings for a name specified  voltage path.
            obj.AddToHistory(['.Change']);

            % Prepend With VoltageWire and append End With
            obj.history = [ 'With VoltageWire', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['change VoltageWire: ', obj.name], obj.history);
            obj.history = [];
        end
        function Import(obj)
            % This command is used if a voltage path created by a subproject import - it should not be used in a macro.
            obj.AddToHistory(['.Import']);

            % Prepend With VoltageWire and append End With
            obj.history = [ 'With VoltageWire', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['import VoltageWire: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the specified voltage wire.
            obj.project.AddToHistory(['VoltageWire.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the specified voltage wire.
            obj.project.AddToHistory(['VoltageWire.Rename "', num2str(oldname, '%.15g'), '", '...
                                                         '"', num2str(newname, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hVoltageWire
        history

        name
    end
end

%% Default Settings
% Name('Vacuum');
% Type('CurvePath');
% Voltage('0');
% Phase('0');

%% Example - Taken from CST documentation and translated to MATLAB.
% voltagewire = project.VoltageWire();
%     voltagewire.Reset
%     voltagewire.Name('path1');
%     voltagewire.Type('CurvePath');
%     voltagewire.Voltage('1.0');
%     voltagewire.Phase('0.0');
%     voltagewire.Curve('curve1:line1');
%     voltagewire.Add
%
