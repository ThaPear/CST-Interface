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

% Changes Solids in several ways and offers tools for the reparation of imported solids.
classdef Solid < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Solid object.
        function obj = Solid(project, hProject)
            obj.project = project;
            obj.hSolid = hProject.invoke('Solid');
            obj.history = [];
			obj.bulkmode = 0;
        end
    end
    methods
        function StartBulkMode(obj)
            % Buffers all commands instead of sending them to CST
            % immediately.
            obj.bulkmode = 1;
        end
        function EndBulkMode(obj)
            % Flushes all commands since StartBulkMode to CST.
            obj.bulkmode = 0;
            % Prepend With Solid and append End With
            obj.history = [ 'With Solid', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Solid settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['Solid', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Delete(obj, SolidName)
            % Deletes the Solid with the given name.
            obj.AddToHistory(['.Delete "', num2str(SolidName, '%.15g'), '"']);
        end
        function Rename(obj, oldName, newName)
            % Changes the name of an already named Solid.
            obj.AddToHistory(['.Rename "', num2str(oldName, '%.15g'), '", '...
                                      '"', num2str(newName, '%.15g'), '"']);
        end
        function ChangeComponent(obj, solidName, newName)
            % Changes the component of a solid. The compontent to be changed to must already exist.
            obj.AddToHistory(['.ChangeComponent "', num2str(solidName, '%.15g'), '", '...
                                               '"', num2str(newName, '%.15g'), '"']);
        end
        function ChangeMaterial(obj, solidName, newName)
            % Changes the material of a solid. The material to change to must already exist.
            obj.AddToHistory(['.ChangeMaterial "', num2str(solidName, '%.15g'), '", '...
                                              '"', num2str(newName, '%.15g'), '"']);
        end
        function SetUseIndividualColor(obj, SolidName, flag)
            % Enables the use of the individual color for a solid. The RGB values of the material will be ignored if enabled and replaced by the one from the solid.
            obj.AddToHistory(['.SetUseIndividualColor "', num2str(SolidName, '%.15g'), '", '...
                                                     '"', num2str(flag, '%.15g'), '"']);
        end
        function ChangeIndividualColor(obj, SolidName, r, g, b)
            % Changes the RGB values of the individual color of the given solid. "SetUseIndividualColor" need to be set to "1" before to make sure the change will be visible.
            obj.AddToHistory(['.ChangeIndividualColor "', num2str(SolidName, '%.15g'), '", '...
                                                     '"', num2str(r, '%.15g'), '", '...
                                                     '"', num2str(g, '%.15g'), '", '...
                                                     '"', num2str(b, '%.15g'), '"']);
        end
        function FastModelUpdate(obj, flag)
            % For setting the edit behavior of project elements and parameters. If the fast model update is deactivated, editing most of the project elements will lead to a complete rebuild of the projects history. If activated, only the relevant history entries are executed to save time.
            obj.AddToHistory(['.FastModelUpdate "', num2str(flag, '%.15g'), '"']);
        end
        %% Boolean
        function Add(obj, solid1, solid2)
            % This method adds two solids. The added solid will be stored under solid1 and the second solid will be deleted.
            obj.AddToHistory(['.Add "', num2str(solid1, '%.15g'), '", '...
                                   '"', num2str(solid2, '%.15g'), '"']);
        end
        function Insert(obj, solid1, solid2)
            % Performs an subtraction between the solids solid1 and solid2 (solid1 solid2) but does not delete solid2.
            obj.AddToHistory(['.Insert "', num2str(solid1, '%.15g'), '", '...
                                      '"', num2str(solid2, '%.15g'), '"']);
        end
        function Intersect(obj, solid1, solid2)
            % Performs an intersection on the two solids. The overlapping parts between the two solids remains while the rest will be deleted. The result will be stored in solid1 while solid2 will be deleted.
            obj.AddToHistory(['.Intersect "', num2str(solid1, '%.15g'), '", '...
                                         '"', num2str(solid2, '%.15g'), '"']);
        end
        function Subtract(obj, solid1, solid2)
            % Performs the operation solid1 solid2. The result will be stored in solid1 while solid2 will be deleted.
            obj.AddToHistory(['.Subtract "', num2str(solid1, '%.15g'), '", '...
                                        '"', num2str(solid2, '%.15g'), '"']);
        end
        function MergeMaterialsOfComponent(obj, name)
            % The parameter name can be a componentname or a solidname.
            % If it is a componentname the function will merge all shapes from one component with the same material like the boolean operation add.
            % If name is a solidname all shapes of a component with the same material like the solid name will be merged together. The resulting shape is called like name.
            obj.AddToHistory(['.MergeMaterialsOfComponent "', num2str(name, '%.15g'), '"']);
        end
        %% Appearance
        function ShapeVisualizationAccuracy(obj, acc)
            % Specifies the accuracy of the triangulation of the shapes used for visualization. This setting only changes the display information, it does not change any internal description of a solid (Modeler, mesh module, solver, etc.). The parameter acc may have values between 0 - 100.
            obj.AddToHistory(['.ShapeVisualizationAccuracy "', num2str(acc, '%.15g'), '"']);
        end
        function ShapeVisualizationOffset(obj, offset)
            % Specifies the distance between the triangulation of adjacent shapes. This setting only changes the display information, it does not change any internal description of a solid (Modeler, mesh module, solver, etc.); The parameter offset may have values between 0 - 100.
            % (2020) This method is deprecated and should not be used anymore.
            obj.AddToHistory(['.ShapeVisualizationOffset "', num2str(offset, '%.15g'), '"']);
        end
        %% Advanced Modelling
        function AttachActiveWCS(obj, sName)
            % Attaches the currently active coordinate system (global or local WCS) to the solid specified by sName. This solid will then own a Local Solid Coordinate System (SCS) which transforms with solid transformation and which will be copied when the solid is copied within a transformation. The SCS feature is useful for all applications which depend on an orientation (like anisotropic materials or radial magnets). A solid coordinate system can be changed by attaching a new WCS to the solid.
            obj.AddToHistory(['.AttachActiveWCS "', num2str(sName, '%.15g'), '"']);
        end
        function BlendEdge(obj, rad)
            % This method changes the transition between two faces. If two faces join each other at a straight edge this edge can be picked and replaced by a cylindrical shape of radius rad. This shape is inserted into the structure such that a smooth transition between the two original faces arises.
            % If radius is chosen in a way that the structure would change significantly, the operation might not be possible.
            % If no edge is picked this method performs no action.
            obj.AddToHistory(['.BlendEdge "', num2str(rad, '%.15g'), '"']);
        end
        function ChamferEdge(obj, depth, angle, boolean, faceID)
            % This option cuts all previously picked edges to the specified depth. The parameter angle defines the angle of the chamfer in degrees (default is 45.0�). There are two possibilities the chamfer width and the angle can be applied to the selected edge. Once is to the right and once is to the left of the selected edges. The parameter switch is to apply the specified settings to the other direction. The faceID will determine from which face we measure the angle (if switch is true, it is the opposite)
            % If depth is chosen in a way that the structure would change significantly, the operation might not be possible.
            % If no edge is picked this method performs no action.
            obj.AddToHistory(['.ChamferEdge "', num2str(depth, '%.15g'), '", '...
                                           '"', num2str(angle, '%.15g'), '", '...
                                           '"', num2str(boolean, '%.15g'), '", '...
                                           '"', num2str(faceID, '%.15g'), '"']);
        end
        function SliceShape(obj, sName, componentName)
            % Cuts the solid sName of component componentName into two half while the currently active working plane defines the cutting plane.
            obj.AddToHistory(['.SliceShape "', num2str(sName, '%.15g'), '", '...
                                          '"', num2str(componentName, '%.15g'), '"']);
        end
        function SplitShape(obj, sName, componentName)
            % A solid may consist out of several parts that are not connected to each other. An example for such a solid can be created by subtracting one solid from a second one, in a way that the first one cuts the second one into two parts.
            % This method converts the different parts of the solid sName  of component componentName into independent, new solids. The new solids will be named automatically.
            % If the solid has only one part this method has no effect.
            obj.AddToHistory(['.SplitShape "', num2str(sName, '%.15g'), '", '...
                                          '"', num2str(componentName, '%.15g'), '"']);
        end
        function ThickenSheetAdvanced(obj, solid1, key, thickness, clearpicks)
            % This method thickens an existing sheet body with the given thickness thickness. Thus, the original sheet body is transformed to a solid body.
            % The parameter clearpicks indicates if the actual picks are deleted after the operation. This is needed for multiple solid operation, because several entries are written into the history and only the last one should delete the picks. So all clearpicks values in the history entries of the multiple solid operation should be false and the last one should be true.
            % The parameter key may have one of the following values:
            % "Inside"
            % The sheet is thickened in antiparallel direction of the normal of the sheet's face.
            % "Outside"
            % The sheet is thickened in direction of the normal of the sheet's face.
            % "Centered"
            % The sheet is thickened around both sides of the original sheet.
            obj.AddToHistory(['.ThickenSheetAdvanced "', num2str(solid1, '%.15g'), '", '...
                                                    '"', num2str(key, '%.15g'), '", '...
                                                    '"', num2str(thickness, '%.15g'), '", '...
                                                    '"', num2str(clearpicks, '%.15g'), '"']);
        end
        function ShellAdvanced(obj, solid1, key, thickness, clearpicks)
            % This method hollows out the existing solid solid1. The original solid is transformed to a new solid that is made out of the surface of the old one with a defined thickness.
            % The parameter clearpicks indicates if the actual picks are deleted after the operation. This is needed for multiple solid operation, because several entries are written into the history and only the last one should delete the picks. So all clearpicks values in the history entries of the multiple solid operation should be false and the last one should be true.
            % The parameter key may have one of the following values:
            % "Inside"
            % The wall will be created from the original solids surface to its inside.
            % "Outside"
            % The wall will be created from the original solids surface to its outside
            % "Centered"
            % The wall will be created around the original solids surface.
            obj.AddToHistory(['.ShellAdvanced "', num2str(solid1, '%.15g'), '", '...
                                             '"', num2str(key, '%.15g'), '", '...
                                             '"', num2str(thickness, '%.15g'), '", '...
                                             '"', num2str(clearpicks, '%.15g'), '"']);
        end
        function FillupSpaceAdvanced(obj, sName, componentName, materialName)
            % Creates a brick with the size of the entire calculation domain and inserts all solids that have been defined so far into it. The new solid will have the name sName of component componentName and will have the material materialName. Both the given material and the given component must already exist.
            obj.AddToHistory(['.FillupSpaceAdvanced "', num2str(sName, '%.15g'), '", '...
                                                   '"', num2str(componentName, '%.15g'), '", '...
                                                   '"', num2str(materialName, '%.15g'), '"']);
        end
        %% Local Modifications (deprecated, use the Local Modifications Object instead)
        function MoveSelectedFace(obj, dx, dy, dz)
            % Moves the selected face to the specified direction. Depending on the face a movement might not be possible in every directions. For planar faces MoveSelectedPlanarFace should be used.
            obj.AddToHistory(['.MoveSelectedFace "', num2str(dx, '%.15g'), '", '...
                                                '"', num2str(dy, '%.15g'), '", '...
                                                '"', num2str(dz, '%.15g'), '"']);
        end
        function MoveSelectedPlanarFace(obj, offset)
            % Moves a previously picked face toward its normal direction. When a face shall be moved, the modeler tries to enlarge the adjoining faces according to their shapes such that the surface of the solid remains closed. If the solid can not be varied in this way, the operation will not be executed.
            % In simple cases, this method can be used as a fast method to parameterize a structure. Normally a structure is parameterized by defining parameters for the basic solids the structure consists of. Then, changing parameters means rebuilding the entire structure. With this method small changes can be made only by local operations.
            obj.AddToHistory(['.MoveSelectedPlanarFace "', num2str(offset, '%.15g'), '"']);
        end
        function OffsetSelectedFace(obj, offset)
            % This method moves the selected face in direction of its face normal. For instance if the offset method is applied to a cylindrical face of a cylinder, it simply changes its radius.
            % All adjoining faces to the changed face will be changed as well such that the solid retains a closed surface.
            % OffsetSelectedFaces can be very useful when parameterizing an imported structure. No information about the history of the solid creation is needed.
            obj.AddToHistory(['.OffsetSelectedFace "', num2str(offset, '%.15g'), '"']);
        end
        function RemoveSelectedFaces(obj)
            % Tries to remove all previously picked faces. When a face has to be removed the modeler tries to enlarge the adjoining faces according to their shapes to close the structure again. If the solid can not be closed in this way, the operation will not be executed.
            obj.AddToHistory(['.RemoveSelectedFaces']);
        end
        function SelectedFaceRadius(obj, radius)
            % For changing the radius of a selected cylindrical face within the model. When changing the radius, all connected faces will be extended to fill up the appearing gaps in the corresponding solid.
            % This operation is especially useful when an imported part with no further construction history information shall be parameterized for later optimization runs.
            % The operation may fail when the topology of the model changes too much.
            obj.AddToHistory(['.SelectedFaceRadius "', num2str(radius, '%.15g'), '"']);
        end
        %% Mesh Settings
        function SetMeshStepWidth(obj, solid1, dx, dy, dz)
            % For some structures it might be necessary to increase the mesh density for individual solids. To do this a maximum step width for all three directions can be given. The automatic mesh generator tries to realize these values for the volume of the solid specified. However, this is not an exclusive setting, it competes with other automesh settings. It might not be fulfilled exactly.
            % If zero is specified for one coordinate direction, no further influence to the mesh generation in this direction is made.
            obj.AddToHistory(['.SetMeshStepWidth "', num2str(solid1, '%.15g'), '", '...
                                                '"', num2str(dx, '%.15g'), '", '...
                                                '"', num2str(dy, '%.15g'), '", '...
                                                '"', num2str(dz, '%.15g'), '"']);
        end
        function SetMeshExtendwidth(obj, solid1, dx, dy, dz)
            % Extends the volume for mesh refinements defined by  SetAutomeshStepWidth for solid1.
            obj.AddToHistory(['.SetMeshExtendwidth "', num2str(solid1, '%.15g'), '", '...
                                                  '"', num2str(dx, '%.15g'), '", '...
                                                  '"', num2str(dy, '%.15g'), '", '...
                                                  '"', num2str(dz, '%.15g'), '"']);
        end
        function SetAutomeshFixpoints(obj, solid1, flag)
            % This method specifies if the specified solid should be considered by the automatic mesh generation or not. If the solid is unimportant for the mesh generation the setting flag =False makes sure that the solid does not have any influence on the mesh. No fix- or density points will be created for this solid.
            obj.AddToHistory(['.SetAutomeshFixpoints "', num2str(solid1, '%.15g'), '", '...
                                                    '"', num2str(flag, '%.15g'), '"']);
        end
        function SetAutomeshPriority(obj, solid1, priority)
            % This method specifies how the specified solid should be treated by the automatic mesh generation. If the solid is more important than others, a priority can be given for it. Generally the priority for all objects (apart from wires, lumped elements, discrete ports) equals to zero. In the case that two fixpoints are so close to each other that the ratiolimit prohibits a mesh line for each point, the mesh lines will be merged. However if one of the fixpoints has been created by an object of higher priority the mesh lines will be placed on this fixpoint.
            % Because wires, lumped elements and discrete ports are very sensitive to their start and endpoints, they have a priority of 1000. Otherwise it would be possible that they get disconnected during the mesh generation.
            obj.AddToHistory(['.SetAutomeshPriority "', num2str(solid1, '%.15g'), '", '...
                                                   '"', num2str(priority, '%.15g'), '"']);
        end
        function SetMaterialBasedRefinement(obj, solid1, flag)
            % Use this method to activate the material based refinement to be considered by the mesh generation of the selected solid.
            obj.AddToHistory(['.SetMaterialBasedRefinement "', num2str(solid1, '%.15g'), '", '...
                                                          '"', num2str(flag, '%.15g'), '"']);
        end
        function SetMeshProperties(obj, solid1, type, defaultType)
            % Set the approximation type during the matrix calculation process of a given shape.
            % The parameter type may have one of the following values:
            % "PBA "
            % Use this setting to obtain the best approximation of the structure during simulation.
            %  "Staircase"
            % With this setting the structure will be approximated by a staircase mesh.
            obj.AddToHistory(['.SetMeshProperties "', num2str(solid1, '%.15g'), '", '...
                                                 '"', num2str(type, '%.15g'), '", '...
                                                 '"', num2str(defaultType, '%.15g'), '"']);
        end
        function SetUseForSimulation(obj, solid1, flag)
            % Indicates if a specific solid should be included in the calculation. If the solid is unimportant for the simulation the setting flag =False makes sure that it does not have any influence.
            obj.AddToHistory(['.SetUseForSimulation "', num2str(solid1, '%.15g'), '", '...
                                                   '"', num2str(flag, '%.15g'), '"']);
        end
        function SetUseThinSheetMeshForShape(obj, solid1, flag)
            % Activates thin sheets (TST) for the shape solid1.
            obj.AddToHistory(['.SetUseThinSheetMeshForShape "', num2str(solid1, '%.15g'), '", '...
                                                           '"', num2str(flag, '%.15g'), '"']);
        end
        function SetMeshRefinement(obj, solid1, edgeRefine, edgeRefineFact, volumeRefine, volumeRefineFact)
            % Use this method to increase the mesh density for solid1.
            % If edgeRefine is set to True, a higher mesh density  for all edges of solid1 that run parallel to a mesh line is used (the mesh density will be increased by a factor of edgeRefineFact ). The mesh will be increased only in the perpendicular directions of the edges.
            % If volumeRefine is set to True, the mesh within the bounding box of solid1 will be volumeRefineFact more dense as it would be if edgeRefineFact is set to False.
            obj.AddToHistory(['.SetMeshRefinement "', num2str(solid1, '%.15g'), '", '...
                                                 '"', num2str(edgeRefine, '%.15g'), '", '...
                                                 '"', num2str(edgeRefineFact, '%.15g'), '", '...
                                                 '"', num2str(volumeRefine, '%.15g'), '", '...
                                                 '"', num2str(volumeRefineFact, '%.15g'), '"']);
        end
        function SetSolidLocalMeshProperties(obj, solid1, type, defaultType, priority, flagAutomeshFixpoints, flagMaterialBaseRefinement, dxStepwidth, dyStepwidth, dzStepwidth, dxExtendwidth, dyExtendwidth, dzExtendwidth, edgeRefine, edgeRefineFact, volumeRefine, volumeRefineFact, flagThinSheetMeshForShape, flagUseForSimulation, flagUseForBoundingBox, flagLimitStepWidth)
            % This function combines the functions SetMeshProperties, SetPriority, SetAutomeshFixpoints, SetMaterialBasedRefinement, SetMeshStepwidth, SetMeshExtendwidth, SetMeshRefinement, SetUseThinSheetMeshForShape, SetUseForSimulation, SetUseForBoundingBox for a faster internal evaluation.
            obj.AddToHistory(['.SetSolidLocalMeshProperties "', num2str(solid1, '%.15g'), '", '...
                                                           '"', num2str(type, '%.15g'), '", '...
                                                           '"', num2str(defaultType, '%.15g'), '", '...
                                                           '"', num2str(priority, '%.15g'), '", '...
                                                           '"', num2str(flagAutomeshFixpoints, '%.15g'), '", '...
                                                           '"', num2str(flagMaterialBaseRefinement, '%.15g'), '", '...
                                                           '"', num2str(dxStepwidth, '%.15g'), '", '...
                                                           '"', num2str(dyStepwidth, '%.15g'), '", '...
                                                           '"', num2str(dzStepwidth, '%.15g'), '", '...
                                                           '"', num2str(dxExtendwidth, '%.15g'), '", '...
                                                           '"', num2str(dyExtendwidth, '%.15g'), '", '...
                                                           '"', num2str(dzExtendwidth, '%.15g'), '", '...
                                                           '"', num2str(edgeRefine, '%.15g'), '", '...
                                                           '"', num2str(edgeRefineFact, '%.15g'), '", '...
                                                           '"', num2str(volumeRefine, '%.15g'), '", '...
                                                           '"', num2str(volumeRefineFact, '%.15g'), '", '...
                                                           '"', num2str(flagThinSheetMeshForShape, '%.15g'), '", '...
                                                           '"', num2str(flagUseForSimulation, '%.15g'), '", '...
                                                           '"', num2str(flagUseForBoundingBox, '%.15g'), '", '...
                                                           '"', num2str(flagLimitStepWidth, '%.15g'), '"']);
        end
        function AdjustSolidMeshPropertiesStart(obj)
            % Are used for the features sub project import and copy & paste. They are wrapped around the function SetSolidLocalMeshProperties because some settings have to be adjusted to the global unit settings.
            obj.AddToHistory(['.AdjustSolidMeshPropertiesStart']);
        end
        function AdjustSolidMeshPropertiesEnd(obj)
            % Are used for the features sub project import and copy & paste. They are wrapped around the function SetSolidLocalMeshProperties because some settings have to be adjusted to the global unit settings.
            obj.AddToHistory(['.AdjustSolidMeshPropertiesEnd']);
        end
        function SetMeshStepwidthTet(obj, solid1, dmax)
            % Sets the maximum edge length of any tetrahedral created for solid1.
            obj.AddToHistory(['.SetMeshStepwidthTet "', num2str(solid1, '%.15g'), '", '...
                                                   '"', num2str(dmax, '%.15g'), '"']);
        end
        function SetMeshStepwidthSrf(obj, solid1, dmax)
            % Sets the maximum edge length of any surface created for solid1.
            obj.AddToHistory(['.SetMeshStepwidthSrf "', num2str(solid1, '%.15g'), '", '...
                                                   '"', num2str(dmax, '%.15g'), '"']);
        end
        %% Healing
        function HealAllShapesAdvanced(obj)
            % This method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.HealAllShapesAdvanced']);
        end
        function HealShapeAdvanced(obj, solid1)
            % This method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.HealShapeAdvanced "', num2str(solid1, '%.15g'), '"']);
        end
        function HealSelfIntersectingShape(obj, solid1)
            % This method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.HealSelfIntersectingShape "', num2str(solid1, '%.15g'), '"']);
        end
        function HealFacesOfShape(obj, solid1)
            % This method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.HealFacesOfShape "', num2str(solid1, '%.15g'), '"']);
        end
        function UndoLastShapeHealing(obj)
            % This method undoes a previously performed healing operation. However, it should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.UndoLastShapeHealing']);
        end
        function ManualShapeHealing(obj, solid1, simplify, stitch, geombuild, simplify_tol, stitch_tol, geombuild_tol)
            % This method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.ManualShapeHealing "', num2str(solid1, '%.15g'), '", '...
                                                  '"', num2str(simplify, '%.15g'), '", '...
                                                  '"', num2str(stitch, '%.15g'), '", '...
                                                  '"', num2str(geombuild, '%.15g'), '", '...
                                                  '"', num2str(simplify_tol, '%.15g'), '", '...
                                                  '"', num2str(stitch_tol, '%.15g'), '", '...
                                                  '"', num2str(geombuild_tol, '%.15g'), '"']);
            obj.manualshapehealing.simplify_tol = simplify_tol;
            obj.manualshapehealing.stitch_tol = stitch_tol;
            obj.manualshapehealing.geombuild_tol = geombuild_tol;
        end
        function MakeBadElementsTolerant(obj, solid1)
            % If possible this method fits a tolerance range to the specified shape so that the bad elements will be associated to it properly.
            obj.AddToHistory(['.MakeBadElementsTolerant "', num2str(solid1, '%.15g'), '"']);
        end
        function CleanShape(obj, solid1)
            % This method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.CleanShape "', num2str(solid1, '%.15g'), '"']);
        end
        %% Show Problems
        function CheckSolid(obj, solid1, CheckLevel)
            % Opens a window displaying all interesting information about the specified shape concerning existing bad edges, vertices or faces. A smaller value  for CheckLevel causes a faster, but less detailed check of the solid. Valid values are 20, 30, 40, 50.
            obj.AddToHistory(['.CheckSolid "', num2str(solid1, '%.15g'), '", '...
                                          '"', num2str(CheckLevel, '%.15g'), '"']);
        end
        function PickDanglingEdges(obj, solid1)
            % Highlights all dangling edges belonging to the specified solid shape. A dangling edge is associated to a shape but has only one adjacent face.
            obj.AddToHistory(['.PickDanglingEdges "', num2str(solid1, '%.15g'), '"']);
        end
        function PickJunctionEdges(obj, solid1)
            % Highlights all junction edges belonging to the specified solid shape. A junction edge is associated to a shape but has more than two adjacent faces.
            obj.AddToHistory(['.PickJunctionEdges "', num2str(solid1, '%.15g'), '"']);
        end
        function ShowBadEdges(obj, solid1)
            % Highlights all bad edges belonging to the specified solid shape. A bad edge has no correct association to the shape.
            obj.AddToHistory(['.ShowBadEdges "', num2str(solid1, '%.15g'), '"']);
        end
        function ShowBadVertices(obj, solid1)
            % Highlights all bad vertices belonging to the specified solid shape. A bad vertex has no correct association to the shape.
            obj.AddToHistory(['.ShowBadVertices "', num2str(solid1, '%.15g'), '"']);
        end
        function ShowBoundingBoxProblems(obj, solid1)
            % A popup window informs if there are any bounding box problems concerning the specified shape.
            obj.AddToHistory(['.ShowBoundingBoxProblems "', num2str(solid1, '%.15g'), '"']);
        end
        function ShowDanglingEdges(obj, solid1)
            % deprecated use PickDanglingEdges instead.
            % Highlights all dangling edges belonging to the specified solid shape. A dangling edge is associated to a shape but has only one adjacent face.
            obj.AddToHistory(['.ShowDanglingEdges "', num2str(solid1, '%.15g'), '"']);
        end
        function ShowMaximumTolerance(obj, solid1)
            % A popup window displays the maximum tolerance if the specified shape is tolerant.
            obj.AddToHistory(['.ShowMaximumTolerance "', num2str(solid1, '%.15g'), '"']);
        end
        function ShowSplineEdges(obj, solid1)
            % Highlights all spline edges belonging to the specified solid shape.
            obj.AddToHistory(['.ShowSplineEdges "', num2str(solid1, '%.15g'), '"']);
        end
        function ShowSplineFaces(obj, solid1)
            % Highlights all spline faces belonging to the specified solid shape.
            obj.AddToHistory(['.ShowSplineFaces "', num2str(solid1, '%.15g'), '"']);
        end
        function ShowTolerantEdges(obj, solid1)
            % Highlights all tolerant edges belonging to the specified solid shape. A tolerant edge indicates a tolerant region concerning the shapes dimensions.
            obj.AddToHistory(['.ShowTolerantEdges "', num2str(solid1, '%.15g'), '"']);
        end
        function ShowTolerantVertices(obj, solid1)
            % Highlights all tolerant vertices belonging to the specified solid shape. A tolerant vertex indicates a tolerant region concerning the shapes dimensions.
            obj.AddToHistory(['.ShowTolerantVertices "', num2str(solid1, '%.15g'), '"']);
        end
        function ShowShortestEdge(obj)
            % Shows the shortest edge of all solids in the project and also the center point of the shortest edge.
            obj.AddToHistory(['.ShowShortestEdge']);
        end
        function ShowEdgeRange(obj, min, max)
            % For all within the specified length range picks the edges and their mid-points.
            obj.AddToHistory(['.ShowEdgeRange "', num2str(min, '%.15g'), '", '...
                                             '"', num2str(max, '%.15g'), '"']);
        end
        function ShowEdgeLengthDistribution(obj)
            % Creates histogram describing edge length distribution. The histogram is created in 1D Results\Model Info folder of the Navigation Tree.
            obj.AddToHistory(['.ShowEdgeLengthDistribution']);
        end
        %% Face Healing
        function CoverSelectedEdges(obj)
            % Tries to create a face according to previously selected edges. If two edges are selected the face connects these two. If a closed loop of edges is selected, a minimal area face is tried to create. If the edges already belong to an existing face, the operation has no effect.
            % Generally, this method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.CoverSelectedEdges']);
        end
        function DeleteFacesForSelectedEdge(obj, solid1)
            % This method deletes all faces adjacent to the picked edges of the specified solid shape.
            obj.AddToHistory(['.DeleteFacesForSelectedEdge "', num2str(solid1, '%.15g'), '"']);
        end
        function DeleteZeroFaces(obj, solid1)
            % This method deletes all zero faces belonging to the specified solid shape. A zero face is not associated properly to the shape.
            obj.AddToHistory(['.DeleteZeroFaces "', num2str(solid1, '%.15g'), '"']);
        end
        function ReverseSelectedFaces(obj)
            % Reverses the orientation of a selected face. This method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.ReverseSelectedFaces']);
        end
        function ReverseShape(obj, solid1)
            % Reverses the orientation of all faces of a selected solid.
            % This method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.ReverseShape "', num2str(solid1, '%.15g'), '"']);
        end
        function UnhookSelectedFace(obj)
            % Physically deletes a face. If a face of an existing solid will be deleted, the remaining solid will be converted into a surface. The information of inside and outside will be lost.
            % This method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.UnhookSelectedFace']);
        end
        function AddLinearCurveFromPoints(obj, solid1)
            % Adds a straight line (a linear curve) to the solid between two previously picked points. However, this method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.AddLinearCurveFromPoints "', num2str(solid1, '%.15g'), '"']);
        end
        function AddTangentCurveFromPoints(obj, solid1, key1, key2, flag1, flag2)
            % This method should only be used for repair purposes of imported structures.
            % key1, key2  =  { none, tangent, normalface, normalboth }
            % flag1, flag2 = Inverted or not.
            obj.AddToHistory(['.AddTangentCurveFromPoints "', num2str(solid1, '%.15g'), '", '...
                                                         '"', num2str(key1, '%.15g'), '", '...
                                                         '"', num2str(key2, '%.15g'), '", '...
                                                         '"', num2str(flag1, '%.15g'), '", '...
                                                         '"', num2str(flag2, '%.15g'), '"']);
        end
        function LoftSelectedEdges(obj, constraint1, strength1, invert1, constraint2, strength2, invert2)
            % This method should be used only for repair purposes of imported structures. You may create a face by lofting two edges. Note: The face is only non-ambiguous in case of a dangling edge (an edge belonging to only one face). '1' marked the settings for the first selected edge and '2' for the second one.
            % 'constraint1 / constraint2' can have one of  the following values:
            % "none"
            % Creates a connecting face without any restriction.
            % "tangent"
            % Creates a face which is tangential to the face belonging to the selected edge.
            % "perpendicular"
            % Creates a face which is normal to the face belonging to the selected edge.
            % 'strength1 / strength2' defines the strength of constraint considering the selected face orientation described above.
            % 'invert1 / invert2' can have one of  the following values:
            % False
            % Creates a face with a normal starting direction.
            % True
            % Creates a face with an inverse starting direction.
            obj.AddToHistory(['.LoftSelectedEdges "', num2str(constraint1, '%.15g'), '", '...
                                                 '"', num2str(strength1, '%.15g'), '", '...
                                                 '"', num2str(invert1, '%.15g'), '", '...
                                                 '"', num2str(constraint2, '%.15g'), '", '...
                                                 '"', num2str(strength2, '%.15g'), '", '...
                                                 '"', num2str(invert2, '%.15g'), '"']);
        end
        function SkinSelectedEdges(obj)
            % This method should only be used for repair purposes of imported structures. A solid face will be created between two selected edges in order to fill a gap.
            obj.AddToHistory(['.SkinSelectedEdges']);
        end
        function SweepSelectedConnectedEdges(obj)
            % This method should only be used for repair purposes of imported structures. The first selected edge will be swept along the second selected edge. Constraint: The two edges must be connected.
            obj.AddToHistory(['.SweepSelectedConnectedEdges']);
        end
        function SplitSelectedEdgeAtPickedPoint(obj, solid1)
            % This method should only be used for repair purposes of imported structures. The selected edge will be split at the selected point. The selected point have to be positioned on the selected edge.
            obj.AddToHistory(['.SplitSelectedEdgeAtPickedPoint "', num2str(solid1, '%.15g'), '"']);
        end
        function RenameCurve(obj, curve1, curve2)
            % Renames a single curve belonging to a solid shape. The curve is specified by the name of the component, the solid and the curve itself.
            obj.AddToHistory(['.RenameCurve "', num2str(curve1, '%.15g'), '", '...
                                           '"', num2str(curve2, '%.15g'), '"']);
        end
        function DeleteCurve(obj, curve1)
            % Deletes curve1. However, this method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.DeleteCurve "', num2str(curve1, '%.15g'), '"']);
        end
        function CreateShapeFromFaces(obj, sName, componentName, materialName)
            % Creates a new shape form one or more picked faces.
            obj.AddToHistory(['.CreateShapeFromFaces "', num2str(sName, '%.15g'), '", '...
                                                    '"', num2str(componentName, '%.15g'), '", '...
                                                    '"', num2str(materialName, '%.15g'), '"']);
        end
        %% Advanced Repair Operations
        function FacettedRepresentationOfShape(obj, solid1, surftol, normaltol, maxEdlen, minPtDist)
            % Converts the analytical description of a shape into an approximated one. After this operation the shape consists out of several planar faces. However, this method should only be used for repair purposes of imported structures.
            obj.AddToHistory(['.FacettedRepresentationOfShape "', num2str(solid1, '%.15g'), '", '...
                                                             '"', num2str(surftol, '%.15g'), '", '...
                                                             '"', num2str(normaltol, '%.15g'), '", '...
                                                             '"', num2str(maxEdlen, '%.15g'), '", '...
                                                             '"', num2str(minPtDist, '%.15g'), '"']);
        end
        function SimplifyFigureOfRotation(obj, solid1, value, key)
            % A method for performing some special kind of rotation to create a desired figure.
            % key  =  { None, Inside, Outside }
            obj.AddToHistory(['.SimplifyFigureOfRotation "', num2str(solid1, '%.15g'), '", '...
                                                        '"', num2str(value, '%.15g'), '", '...
                                                        '"', num2str(key, '%.15g'), '"']);
        end
        %% Queries
        function bool = DoesExist(obj, name)
            % Returns whether a solid with the given name does exist. This can be useful if your script tries to find a new telling name that does not exist yet - try your name first with this method.
            bool = obj.hSolid.invoke('DoesExist', name);
        end
        function name = GetNextFreeName(obj)
            % Returns an unused solid name.
            name = obj.hSolid.invoke('GetNextFreeName');
        end
        function int = GetNumberOfShapes(obj)
            % Returns the total number of currently defined shapes.
            int = obj.hSolid.invoke('GetNumberOfShapes');
        end
        function name = GetNameOfShapeFromIndex(obj, index)
            % Returns the name of the shape that is identified by index. If there is no shape of index, an empty string is returned.
            name = obj.hSolid.invoke('GetNameOfShapeFromIndex', index);
        end
        function name = GetMaterialNameForShape(obj, solid1)
            % Returns the name of the material for solid1.
            name = obj.hSolid.invoke('GetMaterialNameForShape', solid1);
        end
        function bool = IsPointInsideShape(obj, x, y, z, solid1)
            % Returns True, if the point of given coordinates is inside shape solid1, otherwise False.
            bool = obj.hSolid.invoke('IsPointInsideShape', x, y, z, solid1);
        end
        function bool = IsPointOnAnyEdgeOfShape(obj, x, y, z, solid1)
            % Returns True, if the point of given coordinates is on any edge of shape solid1, otherwise False.
            bool = obj.hSolid.invoke('IsPointOnAnyEdgeOfShape', x, y, z, solid1);
        end
        function double = GetVolume(obj, solid1)
            % Returns the volume of the given shape.
            double = obj.hSolid.invoke('GetVolume', solid1);
        end
        function double = GetMass(obj, solid1)
            % Returns the mass of the given shape.
            double = obj.hSolid.invoke('GetMass', solid1);
        end
        function double = GetArea(obj, solid1)
            % Returns the surface area of the given shape.
            double = obj.hSolid.invoke('GetArea', solid1);
        end
        function [bool, x, y, z] = GetPointCoordinates(obj, solid1, pid)
            % Returns the coordinates of the point with the given pid.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim x As Double, y As Double, z As Double', newline, ...
                'bool = Solid.GetPointCoordinates("', solid1, '", "', num2str(pid, '%.15g'), '", x, y, z)', newline, ...
            ];
            returnvalues = {'bool', 'x', 'y', 'z'};
            [bool, x, y, z] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            x = str2double(x);
            y = str2double(y);
            z = str2double(z);
        end
        function int = GetNumberOfPoints(obj, solid1)
            % Returns the maximum number of points.
            int = obj.hSolid.invoke('GetNumberOfPoints', solid1);
        end
        function int = GetAnyFaceIdFromSolid(obj, solid1)
            % Returns the id of the first face found for the specified solid. Returns -1 if the solid identification failed (e.g. does not exist) or if no faces were found.
            int = obj.hSolid.invoke('GetAnyFaceIdFromSolid', solid1);
        end
        function [bool, xmin, xmax, ymin, ymax, zmin, zmax] = GetLooseBoundingBoxOfShape(obj, solid1)
            % Returns false, if the solid does not exist, throws error, if a solid without geometry was given. This returns a non-tight bounding box of solid1 in global coordinates. It is only guaranteed, that the complete volume of the solid is inside of the bounding box defined by the two extreme vertices. This query cannot be executed during history rebuilds or structural macro execution. Designed for post-processing.
            % The solidname can also be given in global name format, but so far, only real solids are allowed anyway.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim xmin As Double, ymin As Double, zmin As Double', newline, ...
                'Dim xmax As Double, ymax As Double, zmax As Double', newline, ...
                'bool = DiscretePort.GetCoordinates("', solid1, '", xmin, xmax, ymin, ymax, zmin, zmax)', newline, ...
            ];
            returnvalues = {'bool', 'xmin', 'xmax', 'ymin', 'ymax', 'zmin', 'zmax'};
            [bool, xmin, xmax, ymin, ymax, zmin, zmax] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            xmin = str2double(xmin);
            ymin = str2double(ymin);
            zmin = str2double(zmin);
            xmax = str2double(xmax);
            ymax = str2double(ymax);
            zmax = str2double(zmax);
        end
        %% CST 2013 functions.
        function FillUpSpaceAdvanced(obj, sName, componentName, materialName)
            % Creates a brick with the size of the entire calculation domain and inserts all solids that have been defined so far into it. The new solid will have the name sName of component componentName and will have the material materialName. Both the given material and the given component must already exist.
            obj.AddToHistory(['.FillUpSpaceAdvanced "', num2str(sName, '%.15g'), '", '...
                                                   '"', num2str(componentName, '%.15g'), '", '...
                                                   '"', num2str(materialName, '%.15g'), '"']);
        end
        %% CST 2020 Functions.
        function ShapeVisualizationAccuracy2(obj, acc)
            % Specifies the accuracy of the triangulation of the shapes used for visualization. This setting only changes the display information, it does not change any internal description of a solid (Modeler, mesh module, solver, etc.). The parameter acc may ordinarily have values between 0 - 100, can be set interactively up to 120 and may also have arbitrary high values. However, due to performance reasons it is not recommended using values above 100. .
            obj.AddToHistory(['.ShapeVisualizationAccuracy2 "', num2str(acc, '%.15g'), '"']);
        end
        %% Undocumented functions.
        % Found in history list of migrated CST 2014 file around boolean operations.
        function Version(obj, version)
            obj.AddToHistory(['.Version "', num2str(version, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hSolid
        history
        bulkmode

    end
end

%% Default Settings
% SetAutomeshExtendwidth(0.0, 0.0, 0.0)
% SetAutomeshStepwidth(0.0, 0.0, 0.0)
% ShapeVisualiziationAccuracy(30)
% ShapeVisualiziationOffset(25)

%% Example - Taken from CST documentation and translated to MATLAB.
% % performs the boolean operation solid1 = solid1 - solid2
% solid = project.Solid();
%     solid.Subtract('component1:solid1', 'component1:solid2');
%
% % Renames solid1 to struct1
%     solid.Rename('component1:solid1', 'struct1');
%
% % Creates the new component('part1');
% Component.New('part1');
%
% % Moves struct1 into part1
%     solid.ChangeComponent('component1:struct1', 'part1');
%
% % Creates a new material of name('diel');
%     solid.Reset
%     solid.Name('diel');
%     solid.FrqType('hf');
%     solid.Type('Normal');
%     solid.Epsilon('2.7');
%     solid.Mu('1.0');
%     solid.Colour('0', '0.501961', '0.501961');
%     solid.Create
%
% % Changes the material for struct1
%     solid.ChangeMaterial('part1:struct1', 'diel');
