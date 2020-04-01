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

% This object is used to perform local modifications on faces of shapes and to work with face constraints for the sensitivity analysis.
% Local Modifications can be very useful when parameterizing an imported structure. No information about the history of the solid creation is needed.
classdef LocalModification < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.LocalModification object.
        function obj = LocalModification(project, hProject)
            obj.project = project;
            obj.hLocalModification = hProject.invoke('LocalModification');
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
        end
        function Name(obj, solidname)
            % Sets the (first) name of involved shapes.
            obj.AddToHistory(['.Name "', num2str(solidname, '%.15g'), '"']);
            obj.name = solidname;
        end
        function AddName(obj, solidname)
            % Adds an additional name to the list of shapes that should be involved in the operation.
            obj.AddToHistory(['.AddName "', num2str(solidname, '%.15g'), '"']);
        end
        function SetBasePoint(obj, posx, posy, posz)
            % Defines the base point to which the distance is defined to for DefineConstraintSelectedFacePointDistance.
            obj.AddToHistory(['.SetBasePoint "', num2str(posx, '%.15g'), '", '...
                                            '"', num2str(posy, '%.15g'), '", '...
                                            '"', num2str(posz, '%.15g'), '"']);
        end
        function SetReferencePoint(obj, posx, posy, posz)
            % Defines the reference point for all picked faces from where the distance is measured to a principal plane for DefineConstraintSelectedFacePlaneDistance.
            obj.AddToHistory(['.SetReferencePoint "', num2str(posx, '%.15g'), '", '...
                                                 '"', num2str(posy, '%.15g'), '", '...
                                                 '"', num2str(posz, '%.15g'), '"']);
        end
        function SetPlaneDirection(obj, direction)
            % Defines the principal plane to which the distance is measured for DefineConstraintSelectedFacePlaneDistance. The value of direction has to be one of the following letters: X,U,Y,V,Z,W. It does not matter if e.g. X or U is given, if the WCS is activated, the U plane is taken, if not the X plane.
            obj.AddToHistory(['.SetPlaneDirection "', num2str(direction, '%.15g'), '"']);
        end
        function SetFaceID(obj, id)
            % This method sets the face ID for one of the delete commands. It is not used for any other operations.
            obj.AddToHistory(['.SetFaceID "', num2str(id, '%.15g'), '"']);
        end
        function EnableInvertedFaceRemoval(obj, boolean)
            % If enabled, faces that are inverted after performing a local operation will be removed. If false, they are inverted to be valid again and used in the changed shape.
            obj.AddToHistory(['.EnableInvertedFaceRemoval "', num2str(boolean, '%.15g'), '"']);
        end
        function SetConsiderBlends(obj, boolean)
            % If enabled, adjacent blends to the selected face are considered during local operations. Technically the blends are removed prior to the local operation and reapplied afterwards at their new position.
            obj.AddToHistory(['.SetConsiderBlends "', num2str(boolean, '%.15g'), '"']);
        end
        function SetRepalceAttribute(obj, boolean)
            % Note: This function is actually named this way, SetReplaceAttribute does not work.
            % You can define multiple FacePlaneDistance constraints. If the switch is set, the first attached attribute is replaced, if existing. In default, this flag is false, and an additional attribute is attached on the face, each time a face plane distance constraint is defined.
            obj.AddToHistory(['.SetRepalceAttribute "', num2str(boolean, '%.15g'), '"']);
        end
        %% 
        function OffsetSelectedFaces(obj, amount)
            % This method moves the picked faces of the listed shapes in direction of their face normals. For instance if the offset method is applied to a cylindrical face of a cylinder, it simply changes its radius.
            % All adjoining faces to the changed faces will be changed as well such that the solid retains a closed surface.
            obj.AddToHistory(['.OffsetSelectedFaces "', num2str(amount, '%.15g'), '"']);
            
            % Prepend With LocalModification and append End With
            obj.history = [ 'With LocalModification', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['localmodification OffsetSelectedFaces(', num2str(amount, '%.15g'), '): ', obj.name], obj.history);
            obj.history = [];
        end
        function MoveSelectedFaces(obj, dx, dy, dz)
            % This method translates the picked faces of the listed shapes by the given vector. Note that translating a picked planar face in a direction parallel to the surface will have no effect.
            obj.AddToHistory(['.MoveSelectedFaces "', num2str(dx, '%.15g'), '", '...
                                                 '"', num2str(dy, '%.15g'), '", '...
                                                 '"', num2str(dz, '%.15g'), '"']);
            
            % Prepend With LocalModification and append End With
            obj.history = [ 'With LocalModification', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['localmodification MoveSelectedFaces(', num2str(dx, '%.15g'), ', ', num2str(dy, '%.15g'), ', ', num2str(dz, '%.15g'), '): ', obj.name], obj.history);
            obj.history = [];
        end
        function RemoveSelectedFaces(obj)
            % Tries to remove all previously picked faces on the listed shapes. When a face has to be removed the modeler tries to enlarge the adjoining faces according to their shapes to close the structure again. If the solid can not be closed in this way, the operation will not be executed.
            obj.AddToHistory(['.RemoveSelectedFaces']);
            
            % Prepend With LocalModification and append End With
            obj.history = [ 'With LocalModification', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['localmodification RemoveSelectedFaces: ', obj.name], obj.history);
            obj.history = [];
        end
        function DefineConstraintSelectedFaceRadius(obj, newradius)
            % This method sets the radius of all picked cylindrical faces of involved shapes to the new given radius. A constraint is attached to the face and usable for the sensitivity analysis if the new radius is given as a plain parameter.
            obj.AddToHistory(['.DefineConstraintSelectedFaceRadius "', num2str(newradius, '%.15g'), '"']);
            
            % Prepend With LocalModification and append End With
            obj.history = [ 'With LocalModification', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['localmodification DefineConstraintSelectedFaceRadius(', num2str(newradius, '%.15g'), '): ', obj.name], obj.history);
            obj.history = [];
        end
        function DefineConstraintSelectedFacePlaneDistance(obj, newdistance)
            % This method sets the distance of all picked faces to a chosen principal plane to the new given distance. To define the previous distance between face and plane, the reference point has to be given.
            obj.AddToHistory(['.DefineConstraintSelectedFacePlaneDistance "', num2str(newdistance, '%.15g'), '"']);
            
            % Prepend With LocalModification and append End With
            obj.history = [ 'With LocalModification', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['localmodification DefineConstraintSelectedFacePlaneDistance(', num2str(newdistance, '%.15g'), '): ', obj.name], obj.history);
            obj.history = [];
        end
        function DefineConstraintSelectedFacePointDistance(obj, newdistance)
            % This method sets the distance of all picked planar faces to a given base point. For each face, the distance is calculated as the distance between the point and the projection of the point onto the plane in which the face is placed.
            obj.AddToHistory(['.DefineConstraintSelectedFacePointDistance "', num2str(newdistance, '%.15g'), '"']);
            
            % Prepend With LocalModification and append End With
            obj.history = [ 'With LocalModification', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['localmodification DefineConstraintSelectedFacePointDistance(', num2str(newdistance, '%.15g'), '): ', obj.name], obj.history);
            obj.history = [];
        end
        function DeleteFacePlaneDistanceConstraint(obj, number)
            % This method removes a face plane constraint from the given face (See SetFaceID). Because multiple constraints may be attached to one face, the given number specifies, which one to delete. If there is only one face plane constraint attached, number should be 0.
            obj.AddToHistory(['.DeleteFacePlaneDistanceConstraint "', num2str(number, '%.15g'), '"']);
            
            % Prepend With LocalModification and append End With
            obj.history = [ 'With LocalModification', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['localmodification DeleteFacePlaneDistanceConstraint(', num2str(number, '%.15g'), '): ', obj.name], obj.history);
            obj.history = [];
        end
        function DeleteFacePointDistanceConstraint(obj)
            % This method removes the face point distance constraint from the given face. (It is not considered for sensitivity analysis anymore.)
            obj.AddToHistory(['.DeleteFacePointDistanceConstraint']);
            
            % Prepend With LocalModification and append End With
            obj.history = [ 'With LocalModification', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['localmodification DeleteFacePointDistanceConstraint: ', obj.name], obj.history);
            obj.history = [];
        end
        function DeleteFaceRadiusConstraint(obj)
            % This method removes the radius constraint from the given face. It is not considered for sensitivity analysis anymore.)
            obj.AddToHistory(['.DeleteFaceRadiusConstraint']);
            
            % Prepend With LocalModification and append End With
            obj.history = [ 'With LocalModification', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['localmodification DeleteFaceRadiusConstraint: ', obj.name], obj.history);
            obj.history = [];
        end
        function DeleteFacePlaneDistanceBlendConstraint(obj, number)
            % Those methods do remove constraints from blends that have been considered while defining face constraints on an adjacent face. The syntax is the same for all deletion commands: .Name and .SetFaceID are required (see example below).
            obj.AddToHistory(['.DeleteFacePlaneDistanceBlendConstraint "', num2str(number, '%.15g'), '"']);
            
            % Prepend With LocalModification and append End With
            obj.history = [ 'With LocalModification', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['localmodification DeleteFacePlaneDistanceBlendConstraint(', num2str(number, '%.15g'), '): ', obj.name], obj.history);
            obj.history = [];
        end
        function DeleteFaceRadiusBlendConstraint(obj)
            % Those methods do remove constraints from blends that have been considered while defining face constraints on an adjacent face. The syntax is the same for all deletion commands: .Name and .SetFaceID are required (see example below).
            obj.AddToHistory(['.DeleteFaceRadiusBlendConstraint']);
            
            % Prepend With LocalModification and append End With
            obj.history = [ 'With LocalModification', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['localmodification DeleteFaceRadiusBlendConstraint: ', obj.name], obj.history);
            obj.history = [];
        end
        function DeleteFacePointDistanceBlendConstraint(obj)
            % Those methods do remove constraints from blends that have been considered while defining face constraints on an adjacent face. The syntax is the same for all deletion commands: .Name and .SetFaceID are required (see example below).
            obj.AddToHistory(['.DeleteFacePointDistanceBlendConstraint']);
            
            % Prepend With LocalModification and append End With
            obj.history = [ 'With LocalModification', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['localmodification DeleteFacePointDistanceBlendConstraint: ', obj.name], obj.history);
            obj.history = [];

        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hLocalModification
        history

        name
    end
end

%% Default Settings
% SetRepalceAttribute(0)
% EnableInvertedFaceRemoval(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% local modifications = project.LocalModification();
%     local modifications.Reset
%     local modifications.Name('component1:solid3');
%     local modifications.AddName('component1:solid4');
%     local modifications.SetReferencePoint('-10.2', '3.25', '0.5');
%     local modifications.SetPlaneDirection('X');
%     local modifications.EnableInvertedFaceRemoval('0');
%     local modifications.DefineConstraintSelectedFacePlaneDistance('facedistance_1');
% 
%     local modifications.Reset
%     local modifications.Name('component1:solid1');
%     local modifications.EnableInvertedFaceRemoval('0');
%     local modifications.MoveSelectedFaces('-5.5', '0', '0');
% 
%     local modifications.Reset
%     local modifications.Name('component1:solid3');
%     local modifications.SetFaceID('1');
%     local modifications.DeleteFacePlaneDistanceConstraint('0');
% 
