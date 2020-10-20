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

% Defines a new coil or a coil segment.
classdef Coil < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Coil object.
        function obj = Coil(project, hProject)
            obj.project = project;
            obj.hCoil = hProject.invoke('Coil');
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
            % Resets the default values.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Name(obj, name)
            % Sets the name of the new charge source.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function ProjectProfileToPathAdvanced(obj, value)
            % If activated the profile curve is projected onto the path curve by aligning the profile curve with  the face normal defined by the path curve.
            obj.AddToHistory(['.ProjectProfileToPathAdvanced "', num2str(value, '%.15g'), '"']);
        end
        function CoilType(obj, type)
            % Specifies the type of the coil or the coil segment. Generally you can select between stranded and solid conductors with current or voltage excitation. Valid types are:
            % "Stranded Current" or "Solid Current"                       for a current coil
            % "Stranded Voltage" or "Solid Voltage"                       for a voltage coil
            % "Stranded Current Segment" or "Solid Current Segment"       for a coil segment
            % A stranded conductor creates a homogeneous current density in the coil's cross section whereas a solid conductor has a constant voltage drop for all turns.
            % Note: Currently not all conductor- / value-type combinations are supported. The following table shows which coil types can be defined:
            %                         Stranded    Solid
            % Current Coil            yes         no
            % Voltage Coil            yes         yes
            % Current Coil Segment    yes         no
            obj.AddToHistory(['.CoilType "', num2str(type, '%.15g'), '"']);
        end
        function ToolType(obj, type)
            % Coils and coil segments can be created in various ways. Usually, a profile and a path or height have to be specified. The ToolType specifies which items where used for the construction. Valid types are:
            % "CurveCurve"        if a profile curve (ProfileName) and a path curve (PathName) is specified.
            %                     The path curve must be closed for coils, whereas it must not be closed for coil segments.
            %                     The profile curve has to be closed in either case.
            % "FaceCurve"         if a face pick is used to define the profile and a curve is used to define the path.
            %                     The face needs to be picked beforehand via the Pick command.
            %                     The path curve must be closed for coils, whereas it must not be closed for coil segments.
            % "CurveHeight"       if the profile is defined via a curve (ProfileName) and an extrusion height (Height) is specified in addition.
            %                     This type can be used only for the construction of coil segments.
            % "FaceHeight"        if a face pick is used to define the profile and the extrusion height (Height) is specified in addition.
            %                     The face needs to be picked beforehand via the Pick command.
            %                     This type can be used only for the construction of coil segments.
            % "CurvePointPick"    if the profile is defined via a curve (ProfileName) and the extrusion height is specified via a point pick.
            %                     The point needs to be picked beforehand via the Pick command.
            %                     This type can be used only for the construction of coil segments.
            % "FacePointPick"     if a face pick is used to define the profile and the extrusion height is specified via a point pick.
            %                     The face as well as the point need to be picked beforehand via the Pick command.
            %                     This type can be used only for the construction of coil segments.
            obj.AddToHistory(['.ToolType "', num2str(type, '%.15g'), '"']);
        end
        function ProfileName(obj, curvename)
            % If the profile of the coil or the coil segment is defined via a curve (ToolType "CurveCurve", "CurveHeight" or "CurvePointPick"), the name of the curve has to be specified here. The profile curve has to be closed for a proper definition.
            obj.AddToHistory(['.ProfileName "', num2str(curvename, '%.15g'), '"']);
        end
        function PathName(obj, curvename)
            % If the path along which along which the profile is swept is defined via a curve (ToolType "CurveCurve", or "FaceCurve"), the name of the curve has to be specified here. The path curve must be closed for coils, whereas it must not be closed for coil segments.
            obj.AddToHistory(['.PathName "', num2str(curvename, '%.15g'), '"']);
        end
        function Height(obj, height)
            % If a coil segment is created without point pick or path curve, the Height needs to be specified. This value is used to extrude the profile along its plane normal.
            obj.AddToHistory(['.Height "', num2str(height, '%.15g'), '"']);
        end
        function Value(obj, value)
            % Sets the current or voltage value for the source. For frequency domain calculations it can be specified in the LF Frequency Domain Solver Settings, whether the source value is to be interpreted as peak- or RMS-value. With the default settings, the prescribed current or voltage is interpreted as RMS value, i.e. as the root-mean-square values.
            % The voltage is prescribed in Volt. The current is given in Ampere for one winding. The total current inside a profile is determined by: Value * Nturns.
            obj.AddToHistory(['.Value "', num2str(value, '%.15g'), '"']);
        end
        function Phase(obj, phase)
            % Sets the phase of the source value in degrees. This setting affects only the simulation for frequency domain problems.
            obj.AddToHistory(['.Phase "', num2str(phase, '%.15g'), '"']);
        end
        function Nturns(obj, nturns)
            % Sets  the number of windings for the coil.
            obj.AddToHistory(['.Nturns "', num2str(nturns, '%.15g'), '"']);
        end
        function Resistance(obj, resistance)
            % Specifies the Ohmic resistance for the coil.
            % Note: If voltage driven coils are used for magnetostatic calculations, the Resistance value must not be zero.
            obj.AddToHistory(['.Resistance "', num2str(resistance, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the coil source with the previously made settings.
            obj.AddToHistory(['.Create']);

            % Prepend With Coil and append End With
            obj.history = [ 'With Coil', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Coil: ', obj.name], obj.history);
            obj.history = [];
        end
        function Import(obj)
            % This command is used if a coil was created by a subproject import - it should not be used in a macro.
            obj.AddToHistory(['.Import']);

            % Prepend With Coil and append End With
            obj.history = [ 'With Coil', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['import Coil: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the specified coil.
            obj.project.AddToHistory(['Coil.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Change(obj)
            % Changes the settings for a name specified coil.
            obj.AddToHistory(['.Change']);

            % Prepend With Coil and append End With
            obj.history = [ 'With Coil', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['change Coil: ', obj.name], obj.history);
            obj.history = [];
        end
        function Rename(obj, oldname, newname)
            % Renames the specified coil.
            obj.AddToHistory(['.Rename "', num2str(oldname, '%.15g'), '", '...
                                      '"', num2str(newname, '%.15g'), '"']);
        end
        function SetAutomeshFixpoints(obj, name, flag)
            % This method determines if the specified coil should be considered by the automatic mesh generation or not. If the coil is unimportant for the mesh generation the setting flag =False makes sure that the coil does not have any influence on the mesh. No fix- or density points will be created for this coil.
            obj.project.AddToHistory(['Coil.SetAutomeshFixpoints "', num2str(name, '%.15g'), '", '...
                                                                '"', num2str(flag, '%.15g'), '"']);
        end
        function SetPriority(obj, name, priority, flag)
            % This method specifies how the specified coil should be treated by the automatic mesh generation. The priority factor (0 is neutral) can be increased to assign a higher importance value to the coil. In the case that two fixpoints are so close to each other that the ratiolimit prohibits a mesh line for each point, the mesh lines will be merged. However if one of the fixpoints has been created by a coil of higher priority the mesh lines will be placed on this fixpoint.
            obj.project.AddToHistory(['Coil.SetPriority "', num2str(name, '%.15g'), '", '...
                                                       '"', num2str(priority, '%.15g'), '", '...
                                                       '"', num2str(flag, '%.15g'), '"']);
        end
        function SetMeshRefinement(obj, name, edge_ref, edgefactor, vo_lref, volfactor)
            % This command sets  the refinement values for a coil specified by its name.
            % edge_ref    This flag determines whether to use a edge refinement or not.
            % edgefactor  The mesh on the edge is refined by this value.
            % vol_ref     This flag determines whether to use a volume refinement or not.
            % volfactor   The mesh inside the coil volume is refined by this value.
            obj.project.AddToHistory(['Coil.SetMeshRefinement "', num2str(name, '%.15g'), '", '...
                                                             '"', num2str(edge_ref, '%.15g'), '", '...
                                                             '"', num2str(edgefactor, '%.15g'), '", '...
                                                             '"', num2str(vo_lref, '%.15g'), '", '...
                                                             '"', num2str(volfactor, '%.15g'), '"']);
        end
        function SetMeshStepwidth(obj, name, dx, dy, dz)
            % Instead of defining volume or edge refinement factors, one can also
            obj.project.AddToHistory(['Coil.SetMeshStepwidth "', num2str(name, '%.15g'), '", '...
                                                            '"', num2str(dx, '%.15g'), '", '...
                                                            '"', num2str(dy, '%.15g'), '", '...
                                                            '"', num2str(dz, '%.15g'), '"']);
        end
        function SeMeshStepwidthTet(obj, name, stepwidth)
            % The prescribed step width is an absolute value. The automatic mesh generator will not exceed this step width for this structure element. If a zero value is specified (default), it  will be ignored and the mesh size will be controlled by the global setting.
            obj.project.AddToHistory(['Coil.SeMeshStepwidthTet "', num2str(name, '%.15g'), '", '...
                                                              '"', num2str(stepwidth, '%.15g'), '"']);
        end
        function SetMeshStepwidthSrf(obj, name, stepwidth)
            % The prescribed step width is an absolute value. The automatic mesh generator will not exceed this step width for this structure element. If a zero value is specified (default), it  will be ignored and the mesh size will be controlled by the global setting.
            obj.project.AddToHistory(['Coil.SetMeshStepwidthSrf "', num2str(name, '%.15g'), '", '...
                                                               '"', num2str(stepwidth, '%.15g'), '"']);
        end
        function SetMeshExtendwidth(obj, name, xextend, yextend, zextend)
            % This command defines additional space around a coil, where the refinement settings should be applied.
            obj.project.AddToHistory(['Coil.SetMeshExtendwidth "', num2str(name, '%.15g'), '", '...
                                                              '"', num2str(xextend, '%.15g'), '", '...
                                                              '"', num2str(yextend, '%.15g'), '", '...
                                                              '"', num2str(zextend, '%.15g'), '"']);
        end
        function SetUseForSimulation(obj, name, flag)
            % Specifies whether or not the coil should be considered by the calculation.
            obj.project.AddToHistory(['Coil.SetUseForSimulation "', num2str(name, '%.15g'), '", '...
                                                               '"', num2str(flag, '%.15g'), '"']);
        end
        function SetUseBoundingBox(obj, name, flag)
            % Specifies whether or not the coil should be considered by the bounding box calculation.
            obj.project.AddToHistory(['Coil.SetUseBoundingBox "', num2str(name, '%.15g'), '", '...
                                                             '"', num2str(flag, '%.15g'), '"']);
        end
        function bool = DoesItemExist(obj, name)
            % Returns whether a coil with the specified name exists.
            bool = obj.hCoil.invoke('DoesItemExist', name);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCoil
        history

        name
    end
end

%% Default Settings
% Current('0');
% Phase('0');
% Type('ProfilePath');
% NTurns('0');

%% Example - Taken from CST documentation and translated to MATLAB.
% coil = project.Coil();
%     coil.Reset
%     coil.Name('coil1');
%     coil.Type('ProfilePath');
%     coil.ProfileName('curve1:rectangle1');
%     coil.PathName('curve1:circle1');
%     coil.Current('1');
%     coil.Phase('45');
%     coil.NTurns('100');
%     coil.Create
%
