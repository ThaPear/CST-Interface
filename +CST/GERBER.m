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

% This command offers GERBER file import (RS274-D, RS274-X). With this feature you can import data from any IC package system providing the GERBER format.
classdef GERBER < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.GERBER object.
        function obj = GERBER(project, hProject)
            obj.project = project;
            obj.hGERBER = hProject.invoke('GERBER');
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
        function GerberType(obj, type)
            % Specifies the imported GERBER Type. The standard GERBER type (RS274-D) needs an aperture file, while the extended GERBER format (RS274-X) has the aperture data included.
            % type can have one of  the following values:
            % type: 'RS274D' - RS274-D GERBER
            %       'RS274X' - RS274-X Extended GERBER
            obj.AddToHistory(['.GerberType "', num2str(type, '%.15g'), '"']);
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
            % Profiles which have a different start and end point are automatically closed, if this parameter is "True".
            % switch: 'True'
            %         'False'
            obj.AddToHistory(['.AddAllShapes "', num2str(boolean, '%.15g'), '"']);
        end
        function Id(obj, id)
            % A CAD file may be imported more than once into the same project with different settings of import options or layer selections. In order to improve the performance of structure rebuilds, an intermediate file is stored during the import process which allows to quickly re-read the data during rebuilds in case that the original CAD file has not been modified. The naming convention of the intermediate file follows the name of the original file, but is marked with a tilde at the end of the file name. However, these names have to be unique for each individual import step. Therefore, in case that the same file is imported more than once into the project, the Id setting needs to be increased. The Id will then be incorporated into the file name which ensures unique file names for every import.
            obj.AddToHistory(['.Id "', num2str(id, '%.15g'), '"']);
        end
        function AsCurves(obj, boolean)
            % Reads the geometric structure of the corresponding data file as curves (switch = "True") or as solids (switch = "False"). The import as curves offers a fast possibility to get a sufficient impression of the complete structure.
            % switch: 'True'
            %         'False'
            obj.AddToHistory(['.AsCurves "', num2str(boolean, '%.15g'), '"']);
        end
        function ApertureFileName(obj, filename)
            % Sets a name of the aperture file for the standard GERBER format.
            obj.AddToHistory(['.ApertureFileName "', num2str(filename, '%.15g'), '"']);
        end
        function AllowZeroHeight(obj, boolean)
            % Set this option to allow shapes of zero height.
            obj.AddToHistory(['.AllowZeroHeight "', num2str(boolean, '%.15g'), '"']);
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
        function Stackup(obj, boolean)
            % If set to "True" the multilayer GERBER import is used.
            % switch: 'True'
            %         'False'
            obj.AddToHistory(['.Stackup "', num2str(boolean, '%.15g'), '"']);
        end
        function Read(obj)
            % Starts the actual import of the file.
            obj.AddToHistory(['.Read']);

            % Prepend With GERBER and append End With
            obj.history = [ 'With GERBER', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['import GERBER: ', obj.filename], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hGERBER
        history

        filename
    end
end

%% Default Settings
% FileName('');
% Version(5.1)
% GerberType('RS274D');
% Height(0.0)
% Offset(0.0)
% CloseShapes('1');
% AddAllShapes('0');
% Id(0)
% AsCurves('0');
% ApertureFileName('');
% AllowZeroHeight(0)
% SetSimplifyActive(1)
% SetSimplifyMinPointsArc(3)
% SetSimplifyMinPointsCircle(5)
% SetSimplifyAngle(10.0)  //Single layer
% SetSimplifyAngle(24.0)  //Multiple layer
% SetSimplifyAdjacentTol(1.0)
% SetSimplifyRadiusTol(5.0)
% SetSimplifyAngleTang(1.0)
% SetSimplifyEdgeLength(0.0001)
% Stackup(FALSE)

%% Example - Taken from CST documentation and translated to MATLAB.
% gerber = project.GERBER();
%     gerber.Reset
%     gerber.FileName('.\example.gbr');
%     gerber.CloseShapes('1');
%     gerber.AddAllShapes('0');
%     gerber.AsCurves('0');
%     gerber.ApertureFileName('.\example.apt');
%     gerber.SetSimplifyActive('1');
%     gerber.SetSimplifyAngle('10');
%     gerber.SetSimplifyRadiusTol('5.0');
%     gerber.SetSimplifyEdgeLength('0.0001');
%     gerber.Read
