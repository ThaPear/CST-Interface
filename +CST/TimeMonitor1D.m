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

% Defines a functional monitor which evaluates a field along a specified chain of edges or curves.
classdef TimeMonitor1D < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TimeMonitor1D object.
        function obj = TimeMonitor1D(project, hProject)
            obj.project = project;
            obj.hTimeMonitor1D = hProject.invoke('TimeMonitor1D');
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
            obj.project.AddToHistory(['TimeMonitor1D.Rename "', num2str(oldName, '%.15g'), '", '...
                                      '"', num2str(newName, '%.15g'), '"']);
        end
        function Delete(obj, monitorName)
            % Deletes the monitor named monitorName.
            obj.project.AddToHistory(['TimeMonitor1D.Delete "', num2str(monitorName, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the monitor with the previously applied settings.
            obj.AddToHistory(['.Create']);
            
            % Prepend With TimeMonitor1D and append End With
            obj.history = [ 'With TimeMonitor1D', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define TimeMonitor1D: ', obj.name], obj.history);
            obj.history = [];
        end
        function FieldType(obj, fType)
            % Sets what field is to be monitored.
            %   
            % fType can have one of the following values:
            % ”voltage”   The voltage along the prescribed path will be monitored.
            obj.AddToHistory(['.FieldType "', num2str(fType, '%.15g'), '"']);
        end
        function UsePickedEdges(obj, bFlag)
            % If bFlag is True the previously picked edges will be used for monitoring. To define a valid monitor, these edges have to be connected and must not be self-intersecting.
            obj.AddToHistory(['.UsePickedEdges "', num2str(bFlag, '%.15g'), '"']);
        end
        function UsePickedEdgeFromId(obj, shapeName, edge_id, vertex_id)
            % For consistency reasons you need to specify the edges to be used by a solid to which it belongs (shapeName), and identification number of the edge (edge_id) and the id of its start vertex (vertex_id). These values can be obtained from the Pick Object command PickEdgeFromId.
            obj.AddToHistory(['.UsePickedEdgeFromId "', num2str(shapeName, '%.15g'), '", '...
                                                   '"', num2str(edge_id, '%.15g'), '", '...
                                                   '"', num2str(vertex_id, '%.15g'), '"']);
        end
        function UseSelectedCurves(obj, bFlag)
            % If bFlag is True the specified curve items will be used for monitoring. To define a valid monitor, these curves have to be connected and must not be self-intersecting.
            obj.AddToHistory(['.UseSelectedCurves "', num2str(bFlag, '%.15g'), '"']);
        end
        function UseCurve(obj, curveitemName)
            % Defines a curve to be used by the monitor, where curveitemName is the name of a previously defined curve item.
            obj.AddToHistory(['.UseCurve "', num2str(curveitemName, '%.15g'), '"']);
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
        hTimeMonitor1D
        history

        name
    end
end

%% Default Settings
% UsePickedEdge(0)
% UseSelectedCurves(0)
% InvertOrientation(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% % creates a time domain magnetic field monitor at the origin
% timemonitor1d = project.TimeMonitor1D();
%     timemonitor1d.Reset
%     timemonitor1d.Name('voltage-monitor at curves');
%     timemonitor1d.FieldType('voltage');
%     timemonitor1d.UseSelectedCurves('1');
%     timemonitor1d.UseCurve('curve1:line1');
%     timemonitor1d.UseCurve('curve1:line2');
%     timemonitor1d.UseCurve('curve2:line1');
%     timemonitor1d.InvertOrientation('1');
%     timemonitor1d.Create
