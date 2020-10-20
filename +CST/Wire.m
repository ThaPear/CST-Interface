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
     %#ok<*NBRAK> s

% This object is used to create a new wire. This wire may either specified by its start / end points and its height above the working plane or by a previously defined curve.
classdef Wire < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Wire object.
        function obj = Wire(project, hProject)
            obj.project = project;
            obj.hWire = hProject.invoke('Wire');
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
            obj.folder = [];
            obj.solidname = [];
        end
        function Name(obj, wirename)
            % Sets the name of the wire. (Complete global names are also allowed here, the folder name can be skipped in this case.)
            obj.AddToHistory(['.Name "', num2str(wirename, '%.15g'), '"']);
            obj.name = wirename;
        end
        function Folder(obj, foldername)
            % Sets the name of the folder for the new wire. If the name is empty, then the wire does not belong to a folder.
            obj.AddToHistory(['.Folder "', num2str(foldername, '%.15g'), '"']);
            obj.folder = foldername;
        end
        function Type(obj, wiretype)
            % Specifies the type of the wire:
            % "Bondwire"      The shape of a bondwire is specified by its start / endpoints and its height above the working plane
            % "Curvewire"     The shape of a curvewire is specified by a previously defined curve which needs to be a single connected path
            obj.AddToHistory(['.Type "', num2str(wiretype, '%.15g'), '"']);
        end
        function BondWireType(obj, bondWiretype)
            % Specifies the bond wire type. Type must be of type "Bondwire"
            % "Spline"    The shape of the bondwire is specified by its start / endpoints (Point1/Point2) its height above the working plane and the position of its maximum height.
            % "JEDEC4"    The shape of the bondwire is defined by the JEDEC4 norm. The shape is defined by the start/end points (Point1/Point2) and its height above the working plane.
            % "JEDEC5"    The shape of the bondwire is defined by the JEDEC5 norm. The shape is defined by the start/end points (Point1/Point2), the angles Alpha and Beta and its height above the working plane.
            obj.AddToHistory(['.BondWireType "', num2str(bondWiretype, '%.15g'), '"']);
        end
        function Height(obj, value)
            % Specifies the height of the bondwire's midpoint above the currently active workplane (either the x/y plane or the u/v plane, depending on whether a local coordinate system is active or not). This setting is only used for bondwires.
            obj.AddToHistory(['.Height "', num2str(value, '%.15g'), '"']);
        end
        function RelativeCenterPosition(obj, center)
            % Defines the relative position of the maximum height of the bond wire. Center must be a value between 0 - 1,
            obj.AddToHistory(['.RelativeCenterPosition "', num2str(center, '%.15g'), '"']);
        end
        function Point1(obj, x, y, z, pick)
            % Specifies the start point of the wire. The start point can either be specified numerically by the x/y/z coordinate settings or automatically be set to the first pickpoint in the list of picked points. If the pick flag is set to True, the picked point is used, otherwise the numerical coordinates specify the point's location. This setting is only used for bondwires.
            obj.AddToHistory(['.Point1 "', num2str(x, '%.15g'), '", '...
                                      '"', num2str(y, '%.15g'), '", '...
                                      '"', num2str(z, '%.15g'), '", '...
                                      '"', num2str(pick, '%.15g'), '"']);
        end
        function Point2(obj, x, y, z, pick)
            % Specifies the end point of the wire. The end point can either be specified numerically by the x/y/z coordinate settings or automatically be set to the first pickpoint in the list of picked points. If the pick flag is set to True, the picked point is used, otherwise the numerical coordinates specify the point's location. This setting is only used for bondwires.
            obj.AddToHistory(['.Point2 "', num2str(x, '%.15g'), '", '...
                                      '"', num2str(y, '%.15g'), '", '...
                                      '"', num2str(z, '%.15g'), '", '...
                                      '"', num2str(pick, '%.15g'), '"']);
        end
        function Alpha(obj, angle)
            % Parameter needed to define a JEDEC5 bondwire.
            obj.AddToHistory(['.Alpha "', num2str(angle, '%.15g'), '"']);
        end
        function Beta(obj, angle)
            % Parameter needed to define a JEDEC5 bondwire.
            obj.AddToHistory(['.Beta "', num2str(angle, '%.15g'), '"']);
        end
        function Curve(obj, curvename)
            % Specifies the name of the previously defined curve which should be converted into a wire. This setting is only used for curvewires.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
        end
        function Radius(obj, value)
            % Specifies the radius of the wire.
            obj.AddToHistory(['.Radius "', num2str(value, '%.15g'), '"']);
        end
        function SolidWireModel(obj, bSolidWireModel)
            % If set to true the bond wire is created as a solid model.
            obj.AddToHistory(['.SolidWireModel "', num2str(bSolidWireModel, '%.15g'), '"']);
        end
        function Material(obj, materialname)
            % Specifies a material. If the bond wire is created by a SolidWireModel any material can be selected. Otherwise only PEC or Lossy metal materials can be selected. Lossy metal will only be supported by the Integral equation solver.
            % For ConvertToSolidShape the meaning is as follows: If left out or set to an empty name, the material of the solid wire is copied, if given this material is used for the new solid.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function ChangeMaterial(obj, wirename)
            % Changes the material for the bond wire. Please see Method Material for supported materials.
            obj.AddToHistory(['.ChangeMaterial "', num2str(wirename, '%.15g'), '"']);
        end
        function Termination(obj, termination)
            % Selects the shape of the bond wire's ends.
            % termination: 'natural'
            %              'rounded'
            %              'extended'
            obj.AddToHistory(['.Termination "', num2str(termination, '%.15g'), '"']);
        end
        function AdvancedChainSelection(obj, bFlag)
            % Flag to activate the new chain selection algorithm, a new way to find adjacent curve items for curve wire creation. The initial value for this flag is false to be backward compatible to old project files.
            obj.AddToHistory(['.AdvancedChainSelection "', num2str(bFlag, '%.15g'), '"']);
        end
        function Add(obj)
            % Creates the wire. All necessary settings for this wire have to be made previously.
            obj.AddToHistory(['.Add']);

            % Prepend With Wire and append End With
            obj.history = [ 'With Wire', newline, ...
                                obj.history, ...
                            'End With'];
            if(~isempty(obj.folder))
                obj.project.AddToHistory(['define Wire: ', obj.folder, '/', obj.name], obj.history);
            else
                obj.project.AddToHistory(['define Wire: ', obj.name], obj.history);
            end
            obj.history = [];
        end
        function SolidName(obj, newsolidname)
            % Used for ConvertToSolidShape. Specifies the name (including its component name) for the new solid shape.
            obj.AddToHistory(['.SolidName "', num2str(newsolidname, '%.15g'), '"']);
            obj.solidname = newsolidname;
        end
        function KeepWire(obj, bFlag)
            % Used for ConvertToSolidShape. Specifies, whether the wire should be deleted after solid creation or coexist with the new solid.
            obj.AddToHistory(['.KeepWire "', num2str(bFlag, '%.15g'), '"']);
        end
        function ConvertToSolidShape(obj)
            % Creates a new solid based on a wire given by Name and Folder. If no Material has been defined, the material will also be copied from the wire. The original wire may be deleted or kept.
            obj.AddToHistory(['.ConvertToSolidShape']);

            % Prepend With Wire and append End With
            obj.history = [ 'With Wire', newline, ...
                                obj.history, ...
                            'End With'];
            if(~isempty(obj.folder))
                obj.project.AddToHistory(['convert Wire ', obj.folder, '/', obj.name, ' to solid shape: ', obj.solidname], obj.history);
            else
                obj.project.AddToHistory(['convert Wire ', obj.name, ' to solid shape: ', obj.solidname], obj.history);
            end
            obj.history = [];
        end
        function Delete(obj, wirename)
            % Deletes the specified wire.
            obj.project.AddToHistory(['Wire.Delete "', num2str(wirename, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the existing wire name to the new name.
            % SetAutomeshFixpoints ( string wirename, bool flag )
            % This method determines if the specified wire should be considered by the automatic mesh generation or not. If the wire is unimportant for the mesh generation the setting flag =False makes sure that the wire does not have any influence on the mesh. No fix- or density points will be created for this wire.
            obj.project.AddToHistory(['Wire.Rename "', num2str(oldname, '%.15g'), '", '...
                                                  '"', num2str(newname, '%.15g'), '"']);
        end
        function SetPriority(obj, wirename, priority)
            % This method specifies how the specified wire should be treated by the automatic mesh generation. If the wire is more important than others, a priority can be given for it. Generally the priority for all objects (apart from wires, lumped elements, discrete ports) equals to zero. In the case that two fixpoints are so close to each other that the ratiolimit prohibits a mesh line for each point, the mesh lines will be merged. However if one of the fixpoints has been created by an object of higher priority the mesh lines will be placed on this fixpoint.
            % Because wires, lumped elements and discrete ports are very sensitive to their start and endpoints, they have a priority of 1000, to ensure the connection of the wire.
            obj.project.AddToHistory(['Wire.SetPriority "', num2str(wirename, '%.15g'), '", '...
                                                       '"', num2str(priority, '%.15g'), '"']);
        end
        function SetMaterialBasedRefinement(obj, wirename, flag)
            % Use this method to activate the material based refinement to be considered by the mesh generation of the selected wire.
            obj.project.AddToHistory(['Wire.SetMaterialBasedRefinement "', num2str(wirename, '%.15g'), '", '...
                                                                      '"', num2str(flag, '%.15g'), '"']);
        end
        function SetMeshStepwidth(obj, wirename, xstep, ystep, zstep)
            % For some structures it might be necessary to increase the mesh density for individual wires. To do this a maximum step width for all three directions can be given. The automatic mesh generator tries to realize these values within the bounding box of the specified wire. However, this is not an exclusive setting, it competes with other automesh settings. It might not be fulfilled exactly.
            % If zero is specified for one coordinate direction, no further influence to the mesh generation in this direction is made.
            obj.project.AddToHistory(['Wire.SetMeshStepwidth "', num2str(wirename, '%.15g'), '", '...
                                                            '"', num2str(xstep, '%.15g'), '", '...
                                                            '"', num2str(ystep, '%.15g'), '", '...
                                                            '"', num2str(zstep, '%.15g'), '"']);
        end
        function SetMeshStepwidthTet(obj, wirename, stepwidth)
            % The prescribed step width is an absolute value. The automatic mesh generator will not exceed this step width for this structure element. If a zero value is specified (default), it  will be ignored and the mesh size will be controlled by the global setting.
            obj.project.AddToHistory(['Wire.SetMeshStepwidthTet "', num2str(wirename, '%.15g'), '", '...
                                                               '"', num2str(stepwidth, '%.15g'), '"']);
        end
        function SetMeshStepwidthSrf(obj, wirename, stepwidth)
            % The prescribed step width is an absolute value. The automatic mesh generator will not exceed this step width for this structure element. If a zero value is specified (default), it  will be ignored and the mesh size will be controlled by the global setting.
            obj.project.AddToHistory(['Wire.SetMeshStepwidthSrf "', num2str(wirename, '%.15g'), '", '...
                                                               '"', num2str(stepwidth, '%.15g'), '"']);
        end
        function SetMeshExtendwidth(obj, wirename, xextend, yextend, zextend)
            % Extends the mesh refinement .
            obj.project.AddToHistory(['Wire.SetMeshExtendwidth "', num2str(wirename, '%.15g'), '", '...
                                                              '"', num2str(xextend, '%.15g'), '", '...
                                                              '"', num2str(yextend, '%.15g'), '", '...
                                                              '"', num2str(zextend, '%.15g'), '"']);
        end
        function SetMeshRefinement(obj, wirename, specialedgerefinement, edgerefinementfactor)
            % Refines the mesh around wirename by edgerefinementfactor if specialedgerefinement is set to true.
            obj.project.AddToHistory(['Wire.SetMeshRefinement "', num2str(wirename, '%.15g'), '", '...
                                                             '"', num2str(specialedgerefinement, '%.15g'), '", '...
                                                             '"', num2str(edgerefinementfactor, '%.15g'), '"']);
        end
        function SetMeshVolumeRefinement(obj, wirename, specialvolumerefinement, volumerefinementfactor)
            % Refines the mesh within the bounding box around wirename by volumerefinementfactor if specialvolumerefinement is set to true.
            obj.project.AddToHistory(['Wire.SetMeshVolumeRefinement "', num2str(wirename, '%.15g'), '", '...
                                                                   '"', num2str(specialvolumerefinement, '%.15g'), '", '...
                                                                   '"', num2str(volumerefinementfactor, '%.15g'), '"']);
        end
        function SetUseForSimulation(obj, wirename, useForSimulation)
            % Inserts or removes the bondwire wirename into or from the simulation.
            obj.project.AddToHistory(['Wire.SetUseForSimulation "', num2str(wirename, '%.15g'), '", '...
                                                               '"', num2str(useForSimulation, '%.15g'), '"']);
        end
        function double = GetLength(obj, wirename)
            % Get the exact length of the named wire.
            double = obj.hWire.invoke('GetLength', wirename);
        end
        function double = GetGridLength(obj, wirename)
            % Get the length of the named wire in mesh representation.
            double = obj.hWire.invoke('GetGridLength', wirename);
        end
        function NewFolder(obj, foldername)
            % Creates a new folder with the given name.
            obj.project.AddToHistory(['Wire.NewFolder "', num2str(foldername, '%.15g'), '"']);
        end
        function DeleteFolder(obj, foldername)
            % Deletes an existing folder and all the containing elements.
            obj.project.AddToHistory(['Wire.DeleteFolder "', num2str(foldername, '%.15g'), '"']);
        end
        function RenameFolder(obj, oldFoldername, newFoldername)
            % Changes the name of an existing folder.
            obj.project.AddToHistory(['Wire.RenameFolder "', num2str(oldFoldername, '%.15g'), '", '...
                                                        '"', num2str(newFoldername, '%.15g'), '"']);
        end
        function bool = DoesFolderExist(obj, name)
            % Returnes true if the name is an existing folder.
            bool = obj.hWire.invoke('DoesFolderExist', name);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hWire
        history

        name
        folder
        solidname
    end
end

%% Default Settings
% Height(0)
% Radius(0)
% BondWireType('Spline');
% RelativeCenterPosition(0.5)
% Termination('natural');
% SolidWireModel(0)
% AdvancedChainSelection(1)
% Material('');

%% Example - Taken from CST documentation and translated to MATLAB.
% wire = project.Wire();
%     wire.Reset
%     wire.Name('bondwire1');
%     wire.Type('Bondwire');
%     wire.Point1(0, 0, 0, 0)
%     wire.Point2(1, 1, 0, 0)
%     wire.Height(1)
%     wire.Radius(0.01)
%     wire.Add
%
%     wire.Reset
%     wire.SolidName('component1:wire1');
%     wire.Name('wire1');
%     wire.Folder('Folder1');
%     wire.Material('Copper(annealed)');
%     wire.KeepWire('0');
%     wire.ConvertToSolidShape
