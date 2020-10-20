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

% Import a NASTRAN file.
classdef NASTRAN < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.NASTRAN object.
        function obj = NASTRAN(project, hProject)
            obj.project = project;
            obj.hNASTRAN = hProject.invoke('NASTRAN');
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

            obj.filename = [];
        end
        function FileName(obj, filename)
            % Sets the name of the imported file or the file to be exported to.
            obj.AddToHistory(['.FileName "', num2str(filename, '%.15g'), '"']);
            obj.filename = filename;
        end
        function Id(obj, id)
            % A CAD file may be imported more than once into the same project with different settings of import options. In order to improve the performance of structure rebuilds, an intermediate sat file is stored during the import process which allows to quickly re-read the data during rebuilds in case that the original CAD file has not been modified. The naming convention of the intermediate sat file has to be unique for each individual import step. Therefore, in case that the same file is imported more than once or a file with the same name is imported into the project, the Id setting needs to be increased. The Id will then be incorporated into the file name which ensures unique file names for every import.
            obj.AddToHistory(['.Id "', num2str(id, '%.15g'), '"']);
        end
        function Version(obj, version)
            % Sets the version of the import filter, since the behavior of the import may slightly change from version to version. This setting is available for backward compatibility reasons and should ensure that later versions of the import can exactly reproduce the behavior of earlier versions. The most recent version of the import is 8.5.
            obj.AddToHistory(['.Version "', num2str(version, '%.15g'), '"']);
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
        function ExportFromActiveCoordinateSystem(obj, boolean)
            % If an active coordinate system is enabled and this flag is set, the coordinate system is used to calculate a transformation that is applied to the geometry before exporting. Importing that file will position the geometry to the global coordinates in that way that it was positioned and oriented to the active coordinate system while exporting.
            obj.AddToHistory(['.ExportFromActiveCoordinateSystem "', num2str(boolean, '%.15g'), '"']);
        end
        function ImportAttributes(obj, boolean)
            % Identifies if attributes like solid names, wire names, material names and material color should be read from the import file.
            obj.AddToHistory(['.ImportAttributes "', num2str(boolean, '%.15g'), '"']);
        end
        function Curves(obj, boolean)
            % Identifies if curves should be imported as curves or as solids.
            obj.AddToHistory(['.Curves "', num2str(boolean, '%.15g'), '"']);
        end
        function ReadPointsOnly(obj, boolean)
            % Set this import option in order to read the points from the NASTRAN file. The points are written into a textfile which is added to the Navigation Tree.
            obj.AddToHistory(['.ReadPointsOnly "', num2str(boolean, '%.15g'), '"']);
        end
        function ReadTrianglInfoOnly(obj, boolean)
            % Set this import option in order to read the triangle info from the NASTRAN file. The triangle id, the center point coordinates and the normal vector of each triangle are written into a textfile which is added to the Navigation Tree.
            obj.AddToHistory(['.ReadTrianglInfoOnly "', num2str(boolean, '%.15g'), '"']);
        end
        function CreateWires(obj, boolean)
            % Set this parameter to "True" in order to create the curves of the imported data as wires.
            obj.AddToHistory(['.CreateWires "', num2str(boolean, '%.15g'), '"']);
        end
        function CreateSolidWires(obj, boolean)
            % Set this parameter to "True" in order to create the curves of the imported data as solid wires.
            obj.AddToHistory(['.CreateSolidWires "', num2str(boolean, '%.15g'), '"']);
        end
        function SetDecimationActive(obj, boolean)
            % Set this option to enable the triangle decimation.
            obj.AddToHistory(['.SetDecimationActive "', num2str(boolean, '%.15g'), '"']);
        end
        function SetDecimationLimit(obj, limit)
            % Set the decimation limit. Is used by the decimation algorithm to estimate the error which would result by deletion of a point. Must be > 0.
            obj.AddToHistory(['.SetDecimationLimit "', num2str(limit, '%.15g'), '"']);
        end
        function SetMaximalAngle(obj, maxangle)
            % Sets the maximal angle. Must be between 0 and 180 degree.
            % To preserve the shape and topology of the original geometry better, choose a maximal angle closer to 180 degree.
            obj.AddToHistory(['.SetMaximalAngle "', num2str(maxangle, '%.15g'), '"']);
        end
        function SetDecimationIterations(obj, iterations)
            % Sets the number of iterations for the decimation process. Must be > 0.
            obj.AddToHistory(['.SetDecimationIterations "', num2str(iterations, '%.15g'), '"']);
        end
        function Read(obj)
            % Starts the actual import of the file.
            obj.AddToHistory(['.Read']);

            % Prepend With NASTRAN and append End With
            obj.history = [ 'With NASTRAN', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['import NASTRAN: ', obj.filename], obj.history);
            obj.history = [];
        end
        function Write(obj, name)
            % Performs the export for the solid with the given name or for all solids of the given component name.
            obj.AddToHistory(['.Write "', num2str(name, '%.15g'), '"']);

            % Prepend With NASTRAN and append End With
            obj.history = [ 'With NASTRAN', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.RunVBACode(obj.history);
            obj.history = [];
        end
        function WriteAll(obj)
            % Exports all data.
            obj.AddToHistory(['.WriteAll']);

            % Prepend With NASTRAN and append End With
            obj.history = [ 'With NASTRAN', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.RunVBACode(obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hNASTRAN
        history

        filename
    end
end

%% Default Settings
% FileName('');
% ImportToActiveCoordinateSystem(1)
% ExportFromActiveCoordinateSystem(0)
% ImportCurves(1)
% ReadPointsOnly(0)
% CreateWires(1)
% SetDecimationActive(1)
% SetDecimationLimit(1.0)
% SetMaximalAngle(140)
% SetDecimationIterations(1)

%% Example - Taken from CST documentation and translated to MATLAB.
% nastran = project.NASTRAN();
%     nastran.Reset
%     nastran.FileName('.\example.nas');
%     nastran.Id('1');
%     nastran.Version('8.5');
%     nastran.ImportToActiveCoordinateSystem('1');
%     nastran.ImportCurves('1');
%     nastran.ReadPointsOnly('0');
%     nastran.CreateWires('1');
%     nastran.SetDecimationActive('1');
%     nastran.SetDecimationLimit('1.0');
%     nastran.SetMaximalAngle('140');
%     nastran.SetDecimationIterations('1');
%     nastran.ImportAttributes(1)
%     nastran.Read
