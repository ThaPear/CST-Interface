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

% This command offers GDSII stream file import. With this feature you can import data from any IC package system providing the GDSII stream format.
% The GDSII data is imported relative to the current coordinate system and extruded with a profile height to a 3D solid. Use this import option to import printed circuits or complex microstrip lines.
classdef GDSII < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.GDSII object.
        function obj = GDSII(project, hProject)
            obj.project = project;
            obj.hGDSII = hProject.invoke('GDSII');
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
            % Sets the name of the imported file.
            obj.AddToHistory(['.FileName "', num2str(filename, '%.15g'), '"']);
            obj.filename = filename;
        end
        function Version(obj, version)
            % Sets the version of the import filter, since the behavior of the import may slightly change from version to version. This setting is available for backward compatibility reasons and should ensure that later versions of the import can exactly reproduce the behavior of earlier versions. The most recent version of the import is 11.3.
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
        function UseModelTolerance(obj, boolean)
            % If set to True, then the vertices of the imported model are merged to one vertex if they are inside the defined Model Tolerance.
            obj.AddToHistory(['.UseModelTolerance "', num2str(boolean, '%.15g'), '"']);
        end
        function ModelTolerance(obj, tolerance)
            % Sets the model tolerance which is used to define whether vertices are equal. The model tolerance has to be defined when UseModelTolerance is activated.
            obj.AddToHistory(['.ModelTolerance "', num2str(tolerance, '%.15g'), '"']);
        end
        function Height(obj, height)
            % This value specifies the extrusion height applied to the 2D profiles to create a 3D solid. The default value 0.0 leads to a very thin (not exact zero) profile.
            obj.AddToHistory(['.Height "', num2str(height, '%.15g'), '"']);
        end
        function Offset(obj, offset)
            % This value specifies the distance of the imported 2D profiles relative to the active coordinate system.
            obj.AddToHistory(['.Offset "', num2str(offset, '%.15g'), '"']);
        end
        function AddAllShapes(obj, boolean)
            % Set this parameter to "True" in order to create one single shape for each layer of the imported data.
            % switch: 'True'
            %         'False'
            obj.AddToHistory(['.AddAllShapes "', num2str(boolean, '%.15g'), '"']);
        end
        function PreserveHoles(obj, boolean)
            % If set to True, then the holes of the shape are preserved. This option is only considered when AddAllShapes is activated.
            % switch: 'True'
            %         'False'
            obj.AddToHistory(['.PreserveHoles "', num2str(boolean, '%.15g'), '"']);
        end
        function CloseShapes(obj, boolean)
            % Profiles which have a different start and end point are automatically closed, if this parameter is "True".
            % switch: 'True'
            %         'False'
            obj.AddToHistory(['.CloseShapes "', num2str(boolean, '%.15g'), '"']);
        end
        function Id(obj, id)
            % A CAD file may be imported more than once into the same project with different settings of import options or layer selections. In order to improve the performance of structure rebuilds, an intermediate file is stored during the import process which allows to quickly re-read the data during rebuilds in case that the original CAD file has not been modified. The naming convention of the intermediate file follows the name of the original file, but is marked with a tilde at the end of the file name. However, these names have to be unique for each individual import step. Therefore, in case that the same file is imported more than once into the project, the Id setting needs to be increased. The Id will then be incorporated into the file name which ensures unique file names for every import.
            obj.AddToHistory(['.Id "', num2str(id, '%.15g'), '"']);
        end
        function Healing(obj, boolean)
            % If set to "True" vertices or edges which are not aligned are healed during the import.
            % switch: 'True'
            %         'False'
            obj.AddToHistory(['.Healing "', num2str(boolean, '%.15g'), '"']);
        end
        function HealSelfIntersections(obj, boolean)
            % If set to "True" self intersecting profiles are automatically repaired during import. Use this option only when there are actually self intersections. Without this option set the import is much faster.
            % switch: 'True'
            %         'False'
            obj.AddToHistory(['.HealSelfIntersections "', num2str(boolean, '%.15g'), '"']);
        end
        function AsCurves(obj, boolean)
            % Reads the geometric structure of the corresponding data file as curves (switch = "True") or as solids (switch = "False"). The import as curves offers a fast possibility to get a sufficient impression of the complete structure.
            % switch: 'True'
            %         'False'
            obj.AddToHistory(['.AsCurves "', num2str(boolean, '%.15g'), '"']);
        end
        function LayerSelection(obj, boolean)
            % Enables/disables the layer selection.
            obj.AddToHistory(['.LayerSelection "', num2str(boolean, '%.15g'), '"']);
        end
        function Layer(obj, importlayer, targetlayer, elevation, thickness)
            % Specifies the name, elevation and thickness for each imported layer.
            obj.AddToHistory(['.Layer "', num2str(importlayer, '%.15g'), '", '...
                                     '"', num2str(targetlayer, '%.15g'), '", '...
                                     '"', num2str(elevation, '%.15g'), '", '...
                                     '"', num2str(thickness, '%.15g'), '"']);
        end
        function AddLayer(obj, importlayer, targetlayer, elevation, thickness, etch_factor)
            % Specifies the name, elevation, thickness and etch factor for each imported layer.
            obj.AddToHistory(['.AddLayer "', num2str(importlayer, '%.15g'), '", '...
                                        '"', num2str(targetlayer, '%.15g'), '", '...
                                        '"', num2str(elevation, '%.15g'), '", '...
                                        '"', num2str(thickness, '%.15g'), '", '...
                                        '"', num2str(etch_factor, '%.15g'), '"']);
        end
        function AllowZeroHeight(obj, boolean)
            % Set this option to allow shapes of zero height.
            obj.AddToHistory(['.AllowZeroHeight "', num2str(boolean, '%.15g'), '"']);
        end
        function SelectedStructure(obj, structurename)
            % Set the name of the selected GDSII structure.
            obj.AddToHistory(['.SelectedStructure "', num2str(structurename, '%.15g'), '"']);
        end
        function SetSimplifyActive(obj, boolean)
            % Set this option to enable the polygon simplification.
            obj.AddToHistory(['.SetSimplifyActive "', num2str(boolean, '%.15g'), '"']);
        end
        function SetSimplifyMinPointsArc(obj, nCount)
            % Minimum number of segments needed to recognize an arc. Must be >= 3.
            obj.AddToHistory(['.SetSimplifyMinPointsArc "', num2str(nCount, '%.15g'), '"']);
        end
        function SetSimplifyMinPointsCircle(obj, nCount)
            % Minimum number of segments needed for complete circles. Must be > 'SetSimplifyMinPointsArc' and at least 5.
            obj.AddToHistory(['.SetSimplifyMinPointsCircle "', num2str(nCount, '%.15g'), '"']);
        end
        function SetSimplifyAngle(obj, angle)
            % The maximum angle in degrees between two adjacent segments. All smaller angles will be considered to be simplified. The angle is only used for arcs and not for circles.
            obj.AddToHistory(['.SetSimplifyAngle "', num2str(angle, '%.15g'), '"']);
        end
        function SetSimplifyAdjacentTol(obj, angle)
            % Is only used by the simplification algorithm to find a good starting point for arcs. It means the maximum angular difference in the angle of adjacent segments. A good value for this parameter will be 1.0.
            obj.AddToHistory(['.SetSimplifyAdjacentTol "', num2str(angle, '%.15g'), '"']);
        end
        function SetSimplifyRadiusTol(obj, deviation)
            % This means the maximum deviation in percent the distance a segment end point can have to the current definition of the simplification circle center point. The tolerance is used for circles and arcs.
            obj.AddToHistory(['.SetSimplifyRadiusTol "', num2str(deviation, '%.15g'), '"']);
        end
        function SetSimplifyAngleTang(obj, angle)
            % Maximum angular tolerance in radians used when deciding to create the arc tangential or not to its adjacent line segments. If an angle is beneath the specified value, the arc is build tangential to the neighbor edge.
            obj.AddToHistory(['.SetSimplifyAngleTang "', num2str(angle, '%.15g'), '"']);
        end
        function SetSimplifyEdgeLength(obj, length)
            % Edges smaller than the defined length will be removed. Can be used to remove tiny fragments.
            obj.AddToHistory(['.SetSimplifyEdgeLength "', num2str(length, '%.15g'), '"']);
        end
        function Read(obj)
            % Starts the actual import of the file.
            obj.AddToHistory(['.Read']);
            
            % Prepend With GDSII and append End With
            obj.history = [ 'With GDSII', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['import GDSII: ', obj.filename], obj.history);
            obj.history = [];
        end
        function MoreThan200Points(obj, boolean)
            % If you set this option to "False", the export complies more to the standard, but only 200 points per polygon are possible.
            obj.AddToHistory(['.MoreThan200Points "', num2str(boolean, '%.15g'), '"']);
        end
        function Write(obj)
            % Starts the export of the file. Only MoreThan200Points is used for exporting.
            obj.AddToHistory(['.Write']);
            
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
        hGDSII
        history

        filename
    end
end

%% Default Settings
% FileName('');
% Version(4.0)
% Height(0.0)
% Offset(0.0)
% CloseShapes('1');
% AddAllShapes('0');
% PreserveHoles('1');
% Id(0)
% Healing('1');
% SelectedStructure('LAYOUT');
% HealSelfIntersections('0');
% AsCurves('0');
% LayerSelection(0)
% AllowZeroHeight(0)
% ScaleToUnit('0');
% ImportFileUnits('m');
% UseModelTolerance(0)
% ModelTolerance(0.0001)
% SetSimplifyActive(0)
% SetSimplifyMinPointsArc(3)
% SetSimplifyMinPointsCircle(5)
% SetSimplifyAngle(5.0)
% SetSimplifyAdjacentTol(1.0)
% SetSimplifyRadiusTol(5.0)
% SetSimplifyAngleTang(1.0)
% SetSimplifyEdgeLength(0.0)
% MoreThan200Points(1)

%% Example - Taken from CST documentation and translated to MATLAB.
% gdsii = project.GDSII();
%     gdsii.Reset
%     gdsii.FileName('.\example.gds');
%     gdsii.AddAllShapes('0');
%     gdsii.PreserveHoles('1');
%     gdsii.CloseShapes('1');
%     gdsii.HealSelfIntersections('1');
%     gdsii.AsCurves('0');
%     gdsii.Id('1');
%     gdsii.LayerSelection('1');
%     gdsii.AllowZeroHeight('1');
%     gdsii.SelectedStructure('LAYOUT');
%     gdsii.SetSimplifyActive('0');
%     gdsii.SetSimplifyAngle('5.0');
%     gdsii.SetSimplifyRadiusTol('5.0');
%     gdsii.SetSimplifyEdgeLength('0.0');
%     gdsii.ScaleToUnit('0');
%     gdsii.ImportFileUnits('m');
%     gdsii.UseModelTolerance('0');
%     gdsii.ModelTolerance('0.0001');
%     gdsii.AddLayer('2', '2', '0', '0', '0');
%     gdsii.Read
% 
%     gdsii.Reset
%     gdsii.FileName('.\example.gds');
%     gdsii.MoreThan200Points('0');
%     gdsii.Write
