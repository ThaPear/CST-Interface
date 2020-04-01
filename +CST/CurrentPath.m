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

% The current path object defines a current path as a source of a magnetic field.
classdef CurrentPath < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.CurrentPath object.
        function obj = CurrentPath(project, hProject)
            obj.project = project;
            obj.hCurrentPath = hProject.invoke('CurrentPath');
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
            % The name of the current path element.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function ToolType(obj, type)
            % The type of the tool which was used to construct a current path
            % enum type       meaning
            % "SingleCurve"   construct a current path by picking a previously defined curve
            obj.AddToHistory(['.ToolType "', num2str(type, '%.15g'), '"']);
        end
        function Type(obj, type)
            % The type of the geometric object from which a current path is constructed.
            % enum type       meaning
            % "CurvePath"     construct a current path from a curve
            obj.AddToHistory(['.Type "', num2str(type, '%.15g'), '"']);
        end
        function PathCurve(obj, name)
            % The name of the curve used for the definition.
            obj.AddToHistory(['.PathCurve "', num2str(name, '%.15g'), '"']);
        end
        function Add(obj)
            % Adds the current path definition to the source definitions.
            obj.AddToHistory(['.Add']);
            
            % Prepend With CurrentPath and append End With
            obj.history = [ 'With CurrentPath', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define CurrentPath: ', obj.name], obj.history);
            obj.history = [];
        end
        function Change(obj)
            % Changes the settings for a name specified current path.
            obj.AddToHistory(['.Change']);
            
            % Prepend With CurrentPath and append End With
            obj.history = [ 'With CurrentPath', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['change CurrentPath: ', obj.name], obj.history);
            obj.history = [];
        end
        function Import(obj)
            % This command is used if a current path created by a subproject import - it should not be used in a macro.
            obj.AddToHistory(['.Import']);
            
            % Prepend With CurrentPath and append End With
            obj.history = [ 'With CurrentPath', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['import CurrentPath: ', obj.name], obj.history);
            obj.history = [];
        end
        function Current(obj, current)
            % Specifies the  current value which flows through the current path.
            obj.AddToHistory(['.Current "', num2str(current, '%.15g'), '"']);
        end
        function Phase(obj, phase)
            % Specifies the  phase shift of the current.
            obj.AddToHistory(['.Phase "', num2str(phase, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Changes the name of an existing current port.
            obj.project.AddToHistory(['CurrentPath.Rename "', num2str(oldname, '%.15g'), '", '...
                                                         '"', num2str(newname, '%.15g'), '"']);
        end
        function Delete(obj, name)
            % Deletes the current port  with the given name .
            obj.project.AddToHistory(['CurrentPath.Delete "', num2str(name, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCurrentPath
        history

        name
    end
end

%% Default Settings
% Type('CurvePath');
% Current('1');
% Phase('0.0');

%% Example - Taken from CST documentation and translated to MATLAB.
% currentpath = project.CurrentPath();
%     currentpath.Reset
%     currentpath.Name('path1');
%     currentpath.Type('CurvePath');
%     currentpath.Current('1');
%     currentpath.Phase('0.0');
%     currentpath.Curve('curve2:circle1');
%     currentpath.Add
