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

% This object is used to create new  temperature sources for the Thermal Solver.
classdef TemperatureSource < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TemperatureSource object.
        function obj = TemperatureSource(project, hProject)
            obj.project = project;
            obj.hTemperatureSource = hProject.invoke('TemperatureSource');
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
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);
            
            obj.name = [];
        end
        function Name(obj, name)
            % Sets the name of the temperature source. Each source must have a unique name.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Value(obj, value)
            % Specifies  temperature in Kelvins (K).
            obj.AddToHistory(['.Value "', num2str(value, '%.15g'), '"']);
        end
        function AddFace(obj, solidname, faceid)
            % A temperature source can be defined on several faces. This method adds a face (indicated by its faceid) of a certain solid (indicated by its solidname) to the face list for the temperature source.
            obj.AddToHistory(['.AddFace "', num2str(solidname, '%.15g'), '", '...
                                       '"', num2str(faceid, '%.15g'), '"']);
        end
        function Type(obj, type)
            % Specifies the type of the temperature  source.
            % type: 'Fixed'
            %       'Floating'
            %       'Initial'
            obj.AddToHistory(['.Type "', num2str(type, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new temperature source. All necessary settings for this object have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With TemperatureSource and append End With
            obj.history = [ 'With TemperatureSource', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define TemperatureSource: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the temperature source with the given name.
            obj.project.AddToHistory(['TemperatureSource.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the temperature source with the given oldname to the defined newname.
            obj.project.AddToHistory(['TemperatureSource.Rename "', num2str(oldname, '%.15g'), '", '...
                                                               '"', num2str(newname, '%.15g'), '"']);
        end
        function type = GetType(obj, name)
            % Returns the type ("Fixed", "Floating" or "Initial") of a temperature source with a given name.
            type = obj.hTemperatureSource.invoke('GetType', name);
        end
        function value = GetValue(obj, name)
            % Returns the value of a temperature source with a given name.
            value = obj.hTemperatureSource.invoke('GetValue', name);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTemperatureSource
        history

        name
    end
end

%% Default Settings
% Name('');
% Value('');
% Face('', 0)
% Type('Fixed');

%% Example - Taken from CST documentation and translated to MATLAB.
% temperaturesource = project.TemperatureSource();
%     temperaturesource.Reset
%     temperaturesource.Name('temperaturesource1');
%     temperaturesource.Value(300)
%     temperaturesource.Face('component1:solid1', '1');
%     temperaturesource.Type('Fixed');
%     temperaturesource.Create
