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

% Offers the import of IGES files written by many of today’s CAD systems. Because  the ACIS kernel uses the SAT data format, IGES data need to be converted to ACIS data and checked for consistency (so-called healing).
classdef IGES < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.IGES object.
        function obj = IGES(project, hProject)
            obj.project = project;
            obj.hIGES = hProject.invoke('IGES');
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
        function Name(obj, name)
            % Sets a name.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
        end
        function Layer(obj, layername)
            % Sets the layer for the new solid. The component and the material are chosen according to the specified layer.
            obj.AddToHistory(['.Layer "', num2str(layername, '%.15g'), '"']);
        end
        function Healing(obj, boolean)
            % If set to True structure will be healed after it is imported. Healing checks the imported structure and tries to repair it, if necessary.
            obj.AddToHistory(['.Healing "', num2str(boolean, '%.15g'), '"']);
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
        function IncludeTopologyInformation(obj, boolean)
            % This option controls whether ACIS body entities are written out as Manifold Solid B-rep Objects (MSBOs) that contain topology (connectivity) information.
            obj.AddToHistory(['.IncludeTopologyInformation "', num2str(boolean, '%.15g'), '"']);
        end
        function ExportAsNurbsOnly(obj, boolean)
            % Export Nurbs faces instead of analytical faces.
            obj.AddToHistory(['.ExportAsNurbsOnly "', num2str(boolean, '%.15g'), '"']);
        end
        function Use2dParametricCurves(obj, boolean)
            % This option specifies the trimming curves preference in the output IGES file. Some systems prefer 2D parametric curves for the trimming curves. Using this option ensures that the 2D parametric curves are written out and the trimming curve preference is set to 2D data. In such a case, IGES converts all the surfaces to NURBS and outputs them as IGES NURBS surfaces.
            obj.AddToHistory(['.Use2dParametricCurves "', num2str(boolean, '%.15g'), '"']);
        end
        function Curves(obj, boolean)
            % If set to True curves will be imported from the import file.
            obj.AddToHistory(['.Curves "', num2str(boolean, '%.15g'), '"']);
        end
        function Read(obj)
            % Starts the actual import of the file.
            obj.AddToHistory(['.Read']);
            
            % Prepend With IGES and append End With
            obj.history = [ 'With IGES', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define IGES'], obj.history);
            obj.history = [];
        end
        function Write(obj, shapeOrComponentName)
            % Warning: Untested, might not work as expected.
            % Performs the export. Depending on what is specified in the name, it will export a folder or shape. Example write("Name") will export all shapes, curves, wires present in any folder "Name". To export a single item in a folder  use write("FolderName:ItemName").
            obj.AddToHistory(['.Write "', num2str(shapeOrComponentName, '%.15g'), '"']);
            
            % Prepend With IGES and append End With
            obj.history = [ 'With IGES', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.RunVBACode(obj.history);
            obj.history = [];
        end
        function WriteAll(obj)
            % Warning: Untested, might not work as expected.
            % Exports all shapes, curves and  wires.
            obj.AddToHistory(['.WriteAll']);
            
            % Prepend With IGES and append End With
            obj.history = [ 'With IGES', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.RunVBACode(obj.history);
            obj.history = [];
        end
        %% Undocumented functions.
        function Version(obj, version)
            % version: '10.2'
            obj.AddToHistory(['.Version "', num2str(version, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hIGES
        history

        filename
    end
end

%% Default Settings
% FileName('');
% Name('');
% Layer('default');
% ImportToActiveCoordinateSystem(0)
% ExportFromActiveCoordinateSystem(0)
% IncludeTopologyInformation(0)
% ExportAsNurbsOnly(0)
% Use2dParametricCurves(0)
% Healing(1)
% ImportCurves(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% iges = project.IGES();
%     iges.Reset
%     iges.FileName('.\example.igs');
%     iges.Name('test');
%     iges.Layer('default');
%     iges.Healing(1)
%     iges.ImportToActiveCoordinateSystem(0)
%     iges.IncludeTopologyInformation(0)
%     iges.ExportAsNurbsOnly(0)
%     iges.Use2dParametricCurves(0)
%     iges.ImportCurves(1)
%     iges.Read
