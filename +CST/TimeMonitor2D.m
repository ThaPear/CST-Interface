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

% Defines a functional monitor which evaluates a field on a specified set of connected faces.  
classdef TimeMonitor2D < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TimeMonitor2D object.
        function obj = TimeMonitor2D(project, hProject)
            obj.project = project;
            obj.hTimeMonitor2D = hProject.invoke('TimeMonitor2D');
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
            obj.project.AddToHistory(['TimeMonitor2D.Rename "', num2str(oldName, '%.15g'), '", '...
                                                           '"', num2str(newName, '%.15g'), '"']);
        end
        function Delete(obj, monitorName)
            % Deletes the monitor named monitorName.
            obj.project.AddToHistory(['TimeMonitor2D.Delete "', num2str(monitorName, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the monitor with the previously applied settings.
            obj.AddToHistory(['.Create']);
            
            % Prepend With TimeMonitor2D and append End With
            obj.history = [ 'With TimeMonitor2D', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define TimeMonitor2D: ', obj.name], obj.history);
            obj.history = [];
        end
        function FieldType(obj, fType)
            % Sets what field is to be monitored.
            obj.AddToHistory(['.FieldType "', num2str(fType, '%.15g'), '"']);
        end
        function can = fType(obj)
            % ”current”           The current flow through the prescribed faces will be monitored.
            % "magnetic flux"     The magnetix flux through the prescribed faces will be monitored.
            can = obj.hTimeMonitor2D.invoke('fType');
        end
        function UsePickedFaceFromId(obj, shapeName, face_id)
            % For consistency reasons you need to specify the faces to be used by a solid to which it belongs (shapeName), and identification number of the face (face_id). These values can be obtained from the Pick Object command PickFaceFromId.
            % To define a valid monitor, the chain of faces must be connected.
            obj.AddToHistory(['.UsePickedFaceFromId "', num2str(shapeName, '%.15g'), '", '...
                                                   '"', num2str(face_id, '%.15g'), '"']);
        end
        function InvertOrientation(obj, bFlag)
            % The orientation of the first edge or curve in a chain specifies a direction which influences the result when the monitor is evaluated along this chain. If bFlag is True, this orientation (direction) is inverted.
            obj.AddToHistory(['.InvertOrientation "', num2str(bFlag, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTimeMonitor2D
        history

        name
    end
end

%% Default Settings
% InvertOrientation(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% % creates a time domain magnetic field monitor at the origin
% timemonitor2d = project.TimeMonitor2D();
%     timemonitor2d.Reset
%     timemonitor2d.Name('current monitor');
%     timemonitor2d.FieldType('current');
%     timemonitor2d.UsePickedFaceFromId('component1:sold1', '1', '1');
%     timemonitor2d.UsePickedFaceFromId('component1:sold1', '2', '1');
%     timemonitor2d.UsePickedFaceFromId('component2:sheet', '1', '2');
%     timemonitor2d.InvertOrientation('1');
%     timemonitor2d.Create
% 
