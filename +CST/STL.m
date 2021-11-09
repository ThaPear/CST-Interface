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

% Most of today’s CAD systems offer STL import/export options. In case your CAD system does not support SAT or IGES export you might import structure data via the STL interface. Though STL data export/import is very common, STL data import can take some time and might lead to a very slow meshing process, because every STL triangle will be converted to an ACIS FACE.
classdef STL < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.STL object.
        function obj = STL(project, hProject)
            obj.project = project;
            obj.hSTL = hProject.invoke('STL');
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
            % Sets the name of the imported file or the file to be exported to.
            obj.AddToHistory(['.FileName "', num2str(filename, '%.15g'), '"']);
        end
        function Name(obj, name)
            % Sets a name.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
        end
        function Component(obj, componentname)
            % Sets the component name for the solid.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
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
        function ExportFromActiveCoordinateSystem(obj, boolean)
            % If an active coordinate system is enabled and this flag is set, the coordinate system is used to calculate a transformation that is applied to the geometry before exporting. Importing that file will position the geometry to the global coordinates in that way that it was positioned and oriented to the active coordinate system while exporting.
            obj.AddToHistory(['.ExportFromActiveCoordinateSystem "', num2str(boolean, '%.15g'), '"']);
        end
        function ImportToActiveCoordinateSystem(obj, boolean)
            % Import the CAD data relative to the active coordinate system.
            obj.AddToHistory(['.ImportToActiveCoordinateSystem "', num2str(boolean, '%.15g'), '"']);
        end
        function ExportFileUnits(obj, units)
            % Set this option to scale the exported model, from currently active unit in the project to another desired unit.
            % units: 'm'
            %        'cm'
            %        'mm'
            %        'um'
            %        'nm'
            %        'ft'
            %        'mil'
            %        'in'
            obj.AddToHistory(['.ExportFileUnits "', num2str(units, '%.15g'), '"']);
        end
        function NormalTolerance(obj, tolerance)
            % Normal tolerance is the maximum angle between any two surface normals on a facet. Set this option to control accuracy of the exported model compared to the model in the project.
            obj.AddToHistory(['.NormalTolerance "', num2str(tolerance, '%.15g'), '"']);
        end
        function SurfaceTolerance(obj, surfacetolerance)
            % Surface tolerance is the maximum distance between the facet and the part of the surface it is representing. Set this option to control accuracy of the exported model compared to the model in the project.
            obj.AddToHistory(['.SurfaceTolerance "', num2str(surfacetolerance, '%.15g'), '"']);
        end
        function Read(obj)
            % Starts the actual import of the file.
            obj.AddToHistory(['.Read']);
            
            % Prepend With STL and append End With
            obj.history = [ 'With STL', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['read STL'], obj.history);
            obj.history = [];
        end
        function Write(obj)
            % Performs the export.
            obj.AddToHistory(['.Write']);
            
            % Prepend With STL and append End With
            obj.history = [ 'With STL', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.RunVBACode(['write STL'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hSTL
        history

    end
end

%% Default Settings
% FileName('');
% Name('');
% Component('default');
% ImportToActiveCoordinateSystem(0)
% ExportFromActiveCoordinateSystem(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% stl = project.STL();
%     stl.Reset
%     stl.FileName('.\example.stl');
%     stl.Name('test');
%     stl.Component('default');
%     stl.ImportToActiveCoordinateSystem(0)
%     stl.Read
% 
%     stl.Reset
%     stl.FileName('.\example.stl');
%     stl.Name('solid1');
%     stl.Component('component1/component1');
%     stl.ExportFromActiveCoordinateSystem(1)
%     stl.Write
% 
% CST Studio Suite 2020 | 3DS.COM/SIMULIA
% 
