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

% The current port object defines a current port as a source of a stationary current calculation.
classdef CurrentPort < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.CurrentPort object.
        function obj = CurrentPort(project, hProject)
            obj.project = project;
            obj.hCurrentPort = hProject.invoke('CurrentPort');
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
            % The name of the current port element.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Face(obj, name)
            % The name of the face (solidname:faceid) used for the definition.
            obj.AddToHistory(['.Face "', num2str(name, '%.15g'), '"']);
        end
        function Value(obj, value)
            % Sets  the potential or the current value of a current port - depending if the ValueType was set to "Potential" or "Current".
            obj.AddToHistory(['.Value "', num2str(value, '%.15g'), '"']);
        end
        function ValueType(obj, type)
            % Specify if the current port value represents a potential or a current .
            % type: 'Potential'
            %       'Current'
            obj.AddToHistory(['.ValueType "', num2str(type, '%.15g'), '"']);
        end
        function Create(obj)
            % Adds the current port definition to the source definitions.
            obj.AddToHistory(['.Create']);

            % Prepend With CurrentPort and append End With
            obj.history = [ 'With CurrentPort', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define CurrentPort: ', obj.name], obj.history);
            obj.history = [];
        end
        function Rename(obj, oldname, newname)
            % Changes the name of an existing current port.
            obj.project.AddToHistory(['CurrentPort.Rename "', num2str(oldname, '%.15g'), '", '...
                                                         '"', num2str(newname, '%.15g'), '"']);
        end
        function Delete(obj, name)
            % Deletes the current port  with the given name .
            obj.project.AddToHistory(['CurrentPort.Delete "', num2str(name, '%.15g'), '"']);
        end
        function GetValueType(obj, name)
            % Returns the value type ("Potential" or "Current") of a current port source with a given name.
            obj.project.AddToHistory(['CurrentPort.GetValueType "', num2str(name, '%.15g'), '"']);
        end
        function GetValue(obj, name)
            % Returns the value of a current port source with a given name.
            obj.project.AddToHistory(['CurrentPort.GetValue "', num2str(name, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCurrentPort
        history

        name
    end
end

%% Default Settings
% Value('0');

%% Example - Taken from CST documentation and translated to MATLAB.
% currentport = project.CurrentPort();
%     currentport.Reset
%     currentport.Name('currentport1');
%     currentport.Value('0');
%     currentport.Face('component1:yoke', '12');
%     currentport.Create
%
