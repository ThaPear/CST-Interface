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
% Warning: Write and WriteAll might not work as expected.

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK>

% This command offers SAT file import. With this feature you can import data from any other ACIS based CAD system.
classdef SAT < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.SAT object.
        function obj = SAT(project, hProject)
            obj.project = project;
            obj.hSAT = hProject.invoke('SAT');
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
            % Sets the version of the import filter, since the behavior of the import may slightly change from version to version. This setting is available for backward compatibility reasons and should ensure that later versions of the import can exactly reproduce the behavior of earlier versions. The most recent version of the import is 9.0.
            obj.AddToHistory(['.Version "', num2str(version, '%.15g'), '"']);
        end
        function SubProjectName2D(obj, filename)
            % The SAT import is also used for the import of sub-projects. This function sets the name of the 2D sub-project including the path.
            obj.AddToHistory(['.SubProjectName2D "', num2str(filename, '%.15g'), '"']);
        end
        function SubProjectName3D(obj, filename)
            % The SAT import is also used for the import of sub-projects. This function sets the name of the 3D sub-project including the path.
            obj.AddToHistory(['.SubProjectName3D "', num2str(filename, '%.15g'), '"']);
        end
        function SubProjectScaleFactor(obj, factor)
            % Defines the scale factor of the sub-project. ( 1.0 means m, 0.1 means dm, 0.01 means cm, ... )
            obj.AddToHistory(['.SubProjectScaleFactor "', num2str(factor, '%.15g'), '"']);
        end
        function SubProjectLocalWCS(obj, x, y, z, nx, ny, nz, ux, uy, uz)
            % Defines the local coordinate system of the sub-project. x, y and z defines the origin. nx, ny and nz defines the normal. ux, uy and uz defines the u-vector.
            obj.AddToHistory(['.SubProjectLocalWCS "', num2str(x, '%.15g'), '", '...
                                                  '"', num2str(y, '%.15g'), '", '...
                                                  '"', num2str(z, '%.15g'), '", '...
                                                  '"', num2str(nx, '%.15g'), '", '...
                                                  '"', num2str(ny, '%.15g'), '", '...
                                                  '"', num2str(nz, '%.15g'), '", '...
                                                  '"', num2str(ux, '%.15g'), '", '...
                                                  '"', num2str(uy, '%.15g'), '", '...
                                                  '"', num2str(uz, '%.15g'), '"']);
        end
        function SaveVersion(obj, version)
            % Saves the current model as a SAT file correspondant to the specified version number. Valid versions are "1.0", "2.0", "3.0", ..., "12.0". You may also omit this setting.
            obj.AddToHistory(['.SaveVersion "', num2str(version, '%.15g'), '"']);
        end
        function ScaleToUnit(obj, boolean)
            % If set to True the imported model is scaled to the currently active unit. If not activated the import feature uses the source units. In such a case, no scaling occurs.
            obj.AddToHistory(['.ScaleToUnit "', num2str(boolean, '%.15g'), '"']);
        end
        function ImportToActiveCoordinateSystem(obj, boolean)
            % Import the CAD data relative to the active coordinate system.
            obj.AddToHistory(['.ImportToActiveCoordinateSystem "', num2str(boolean, '%.15g'), '"']);
        end
        function ExportFromActiveCoordinateSystem(obj, boolean)
            % If an active coordinate system is enabled and this flag is set, the coordinate system is used to calculate a transformation that is applied to the geometry before exporting. Importing that file will position the geometry to the global coordinates in that way that it was positioned and oriented to the active coordinate system while exporting.
            obj.AddToHistory(['.ExportFromActiveCoordinateSystem "', num2str(boolean, '%.15g'), '"']);
        end
        function Curves(obj, boolean)
            % Identifies if curves should be imported as curves or as solids.
            obj.AddToHistory(['.Curves "', num2str(boolean, '%.15g'), '"']);
        end
        function Wires(obj, boolean)
            % Identifies if thin and solid wires should be imported.  At the moment only used for sub-project import.
            obj.AddToHistory(['.Wires "', num2str(boolean, '%.15g'), '"']);
        end
        function SolidWiresAsSolids(obj, boolean)
            % Identifies if solid wires should be imported as wires or as solids. At the moment only used for sub-project import, to be backward compatible to older projects.
            obj.AddToHistory(['.SolidWiresAsSolids "', num2str(boolean, '%.15g'), '"']);
        end
        function Read(obj)
            % Starts the actual import of the file.
            obj.AddToHistory(['.Read']);

            % Prepend With SAT and append End With
            obj.history = [ 'With SAT', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['import SAT: ', obj.filename], obj.history);
            obj.history = [];
        end
        function Write(obj, shapeOrComponentName)
            % Warning: Untested, might not work as expected.
            % Performs the export for one shape or for all shapes of the specified component.
            obj.AddToHistory(['.Write "', num2str(shapeOrComponentName, '%.15g'), '"']);

            % Prepend With SAT and append End With
            obj.history = [ 'With SAT', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.RunVBACode(obj.history);
            obj.history = [];
        end
        function WriteAll(obj)
            % Warning: Untested, might not work as expected.
            % Exports all data.
            obj.AddToHistory(['.WriteAll']);

            % Prepend With SAT and append End With
            obj.history = [ 'With SAT', newline, ...
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
        hSAT
        history

        filename
    end
end

%% Default Settings
% FileName('');
% SaveVersion('');
% ImportToActiveCoordinateSystem(0)
% ExportFromActiveCoordinateSystem(0)
% ImportCurves(1)

%% Example - Taken from CST documentation and translated to MATLAB.
% sat = project.SAT();
%     sat.Reset
%     sat.FileName('.\example.sat');
%     sat.ImportToActiveCoordinateSystem(0)
%     sat.ImportCurves(1)
%     sat.Read
%
%     sat.Reset
%     sat.FileName('.\export.sat');
%     sat.ExportFromActiveCoordinateSystem(1)
%     sat.Write('component1/component2:solid1');
