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

% Defines a functional monitor which evaluates a field at a specified point.
classdef TimeMonitor0D < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TimeMonitor0D object.
        function obj = TimeMonitor0D(project, hProject)
            obj.project = project;
            obj.hTimeMonitor0D = hProject.invoke('TimeMonitor0D');
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

            obj.name = [];
        end
        function Name(obj, monitorName)
            % Sets the name of the monitor.
            obj.AddToHistory(['.Name "', num2str(monitorName, '%.15g'), '"']);
            obj.name = monitorName;
        end
        function Rename(obj, oldName, newName)
            % Renames the monitor named oldName to newName.
            obj.project.AddToHistory(['TimeMonitor0D.Rename "', num2str(oldName, '%.15g'), '", '...
                                                           '"', num2str(newName, '%.15g'), '"']);
        end
        function Delete(obj, monitorName)
            % Deletes the monitor named monitorName.
            obj.project.AddToHistory(['TimeMonitor0D.Delete "', num2str(monitorName, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the monitor with the previously applied settings.
            obj.AddToHistory(['.Create']);

            % Prepend With TimeMonitor0D and append End With
            obj.history = [ 'With TimeMonitor0D', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define TimeMonitor0D: ', obj.name], obj.history);
            obj.history = [];
        end
        function FieldType(obj, fType)
            % Sets what field is to be monitored.
            obj.AddToHistory(['.FieldType "', num2str(fType, '%.15g'), '"']);
        end
        function can = fType(obj)
            % ”B-Field”               The magnetic flux density will be monitored.
            % "H-Field"               The magnetic field strength will be monitored.
            % "E-Field"               The electric field will be monitored.
            % "Cond. Current Dens."   The conduction current density will be monitored.
            % "Material"              The the relative permeability of the material at the given position will be monitored.
            % ”Temperature”           The temperature will be monitored.
            can = obj.hTimeMonitor0D.invoke('fType');
        end
        function Component(obj, comp)
            % Sets the component of the specified field to be monitored.
            % comp can have one of the following values: X, Y, Z, Abs.
            obj.AddToHistory(['.Component "', num2str(comp, '%.15g'), '"']);
        end
        function UsePickedPoint(obj, bFlag)
            % If bFlag is True the previously picked point will be used for monitoring, and CoordinateSystem and Position settings will be ignored.
            obj.AddToHistory(['.UsePickedPoint "', num2str(bFlag, '%.15g'), '"']);
        end
        function Position(obj, posX, posY, posZ)
            % Sets the position of the point in which the specified field is to be monitored.
            obj.AddToHistory(['.Position "', num2str(posX, '%.15g'), '", '...
                                        '"', num2str(posY, '%.15g'), '", '...
                                        '"', num2str(posZ, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTimeMonitor0D
        history

        name
    end
end

%% Default Settings
% Component(X)
% UsePickedPoint(0)
% CoordinateSystem(Cartesian)
% Position(0.0, 0.0, 0.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% % creates a time domain magnetic field monitor at the origin
% timemonitor0d = project.TimeMonitor0D();
%     timemonitor0d.Reset
%     timemonitor0d.Name('monitor at origin');
%     timemonitor0d.FieldType('H-Field');
%     timemonitor0d.CoordinateSystem('Cartesian');
%     timemonitor0d.Position('0.0', '0.0', '0.0');
%     timemonitor0d.Create
%
