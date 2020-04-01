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

% This object is used to create new heat sources for the Thermal Solver.
classdef HeatSource < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.HeatSource object.
        function obj = HeatSource(project, hProject)
            obj.project = project;
            obj.hHeatSource = hProject.invoke('HeatSource');
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
            % Resets all internal settings of the heat source to their default values.
            obj.AddToHistory(['.Reset']);
            
            obj.name = [];
        end
        function Name(obj, name)
            % Specifies the name of the heat source.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Value(obj, value)
            % Specifies the heat flow value for the heat source.
            obj.AddToHistory(['.Value "', num2str(value, '%.15g'), '"']);
        end
        function Type(obj, type)
            % Selects one of the following types:
            % "PTC"       Heat source on a perfect thermal conductor.
            % "Volume"    Homogeneous volume heat source on a solid with normal thermal conductivity
            obj.AddToHistory(['.Type "', num2str(type, '%.15g'), '"']);
        end
        function ValueType(obj, type)
            % Specify if the volume heat source value is defined as an integral type or a density type.
            % type: 'Integral'
            %       'Density'
            obj.AddToHistory(['.ValueType "', num2str(type, '%.15g'), '"']);
        end
        function Face(obj, solidname, faceid)
            % A heat source can be defined on several faces. This method adds a face (indicated by its faceid) of a certain solid (indicated by its solidname) to the face list for the heat source.
            obj.AddToHistory(['.Face "', num2str(solidname, '%.15g'), '", '...
                                    '"', num2str(faceid, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the heat source with its previously made settings.
            obj.AddToHistory(['.Create']);
            
            % Prepend With HeatSource and append End With
            obj.history = [ 'With HeatSource', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define HeatSource: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the heat source with the given name.
            obj.project.AddToHistory(['HeatSource.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the heat source with the given oldname to the defined newname.
            obj.project.AddToHistory(['HeatSource.Rename "', num2str(oldname, '%.15g'), '", '...
                                                        '"', num2str(newname, '%.15g'), '"']);
        end
        function value = GetValue(obj, name)
            % Returns the value of a heat source with a given name.
            value = obj.hHeatSource.invoke('GetValue', name);
        end
        function type = GetType(obj, name)
            % Returns the type ("PTC" or "Volume") of a heat source with a given name.
            type = obj.hHeatSource.invoke('GetType', name);
        end
        function type = GetValueType(obj, name)
            % Returns the value type ("Integral" or "Density") of a volume heat source source with a given name.
            type = obj.hHeatSource.invoke('GetValueType', name);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hHeatSource
        history

        name
    end
end

%% Default Settings
% Name('');
% Value('');
% Face('', 0)
% Type('PTC');

%% Example - Taken from CST documentation and translated to MATLAB.
% heatsource = project.HeatSource();
%     heatsource.Reset
%     heatsource.Name('heatcurrent1');
%     heatsource.Type('PTC');
%     heatsource.Value('100');
%     heatsource.Face('component1:solid1', '1');
%     heatsource.Create
