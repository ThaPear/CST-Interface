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

% This object offers you the options for import object files (.obj). OBJ data import can take some time and might lead to a very slow meshing process, because every OBJ triangle will be converted to an ACIS FACE.
classdef OBJ < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.OBJ object.
        function obj = OBJ(project, hProject)
            obj.project = project;
            obj.hOBJ = hProject.invoke('OBJ');
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
            % Resets the import options to the default.
            obj.AddToHistory(['.Reset']);
        end
        function FileName(obj, filename)
            % Sets the name of the imported file.
            obj.AddToHistory(['.FileName "', num2str(filename, '%.15g'), '"']);
        end
        function Name(obj, name)
            % Sets a name.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
        end
        function Layer(obj, layername)
            % Sets the layer for the new solid. The component and the material are chosen according to the specified layer.
            obj.AddToHistory(['.Layer "', num2str(layername, '%.15g'), '"']);
        end
        function ScaleFactor(obj, scalefactor)
            % Set the scale factor to scale the coordinates of all vertices. Importing object files from the program package Poser then it seems that the scale factor has to be 2500. This scale factor is the default value. If you do not want the coordinates to be scaled then set the scale factor to 1.0.
            obj.AddToHistory(['.ScaleFactor "', num2str(scalefactor, '%.15g'), '"']);
        end
        function ScaleToUnit(obj, boolean)
            % If set to True the imported model is scaled to the currently active unit. The scale factor is determined by the unit of the import model and the currently active unit in the project. As the unit of the import model are not defined in the import file you have to specify the unit of the import model by using  ImportFileUnits. If not activated no scaling occurs.
            obj.AddToHistory(['.ScaleToUnit "', num2str(boolean, '%.15g'), '"']);
        end
        function ImportFileUnits(obj, units)
            % Sets the units of the imported model. The units have to be defined when ScaleToUnit is activated.
            % units: 'm'
            %        'cm'
            %        'mm'
            %        'um'
            %        'nm'
            %        'ft'
            %        'mil'
            %        'in'
            obj.AddToHistory(['.ImportFileUnits "', num2str(units, '%.15g'), '"']);
        end
        function ImportToActiveCoordinateSystem(obj, boolean)
            % Import the CAD data relative to the active coordinate system.
            obj.AddToHistory(['.ImportToActiveCoordinateSystem "', num2str(boolean, '%.15g'), '"']);
        end
        function Read(obj)
            % Starts the actual import of the file.
            obj.AddToHistory(['.Read']);
            
            % Prepend With OBJ and append End With
            obj.history = [ 'With OBJ', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define OBJ'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hOBJ
        history

    end
end

%% Default Settings
% FileName('');
% Name('');
% Layer('default');
% ScaleFactor('1.0');
% ImportToActiveCoordinateSystem(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% obj = project.OBJ();
%     obj.Reset
%     obj.FileName('.\example.obj');
%     obj.Name('test');
%     obj.Layer('default');
%     obj.ScaleFactor('1.0');
%     obj.ImportToActiveCoordinateSystem(0)
%     obj.Read
% 
