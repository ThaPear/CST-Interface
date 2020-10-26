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

% Offers a set of tools that change a solid by transformations.
classdef Transform_ < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Transform object.
        function obj = Transform_(project, hProject)
            obj.project = project;
            obj.hTransform = hProject.invoke('Transform');
            obj.history = [];

            obj.names = {};
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
            % Resets all internal values to their defaults.
            obj.AddToHistory(['.Reset']);

            obj.names = {};
        end
        function Name(obj, sObjectName)
            % Defines the name of the object, the transformation should be applied to.
            % Note: for some transforms ("mixed" in particular), a global name may be required.
            obj.AddToHistory(['.Name "', num2str(sObjectName, '%.15g'), '"']);
            obj.names = {sObjectName};
        end
        function AddName(obj, sObjectName)
            % Defines one more name of an additional object, in addition to the previously defined object. This is only used for transformations of solids with Origin set to CommonCenter, for TransformAlign and RotateAlign.
            % Note: for some transforms ("mixed" in particular), a global name may be required.
            obj.AddToHistory(['.AddName "', num2str(sObjectName, '%.15g'), '"']);
            obj.names = [obj.names, {sObjectName}];
        end
        function TranslateCurve(obj)
            % Translate / scale / rotate / mirror the selected object with all previously made settings.
            obj.AddToHistory(['.TranslateCurve']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: Translate ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: Translate ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function ScaleCurve(obj)
            % Translate / scale / rotate / mirror the selected object with all previously made settings.
            obj.AddToHistory(['.ScaleCurve']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: Scale ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: Scale ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function RotateCurve(obj)
            % Translate / scale / rotate / mirror the selected object with all previously made settings.
            obj.AddToHistory(['.RotateCurve']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: Rotate ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: Rotate ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function MirrorCurve(obj)
            % Translate / scale / rotate / mirror the selected object with all previously made settings.
            obj.AddToHistory(['.MirrorCurve']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: Mirror ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: Mirror ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function TranslateWire(obj)
            % Translate / scale / rotate / mirror the selected object with all previously made settings.
            obj.AddToHistory(['.TranslateWire']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: Translate ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: Translate ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function ScaleWire(obj)
            % Translate / scale / rotate / mirror the selected object with all previously made settings.
            obj.AddToHistory(['.ScaleWire']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: Scale ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: Scale ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function RotateWire(obj)
            % Translate / scale / rotate / mirror the selected object with all previously made settings.
            obj.AddToHistory(['.RotateWire']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: Rotate ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: Rotate ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function MirrorWire(obj)
            % Translate / scale / rotate / mirror the selected object with all previously made settings.
            obj.AddToHistory(['.MirrorWire']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: Mirror ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: Mirror ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function TranslateCoil(obj)
            % Translate / scale / rotate / mirror the selected object with all previously made settings.
            obj.AddToHistory(['.TranslateCoil']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: Translate ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: Translate ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function ScaleCoil(obj)
            % Translate / scale / rotate / mirror the selected object with all previously made settings.
            obj.AddToHistory(['.ScaleCoil']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: Scale ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: Scale ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function RotateCoil(obj)
            % Translate / scale / rotate / mirror the selected object with all previously made settings.
            obj.AddToHistory(['.RotateCoil']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: Rotate ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: Rotate ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function MirrorCoil(obj)
            % Translate / scale / rotate / mirror the selected object with all previously made settings.
            obj.AddToHistory(['.MirrorCoil']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: Mirror ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: Mirror ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function Transform(obj, what, how)
            % This execute a specified transform onto the given type of objects (named via Name and AddName). Note that not all transformations are applicable to all types of objects.
            % enum what               description
            % Shape                   this transforms solids
            % FFS                     this transforms farfield sources
            % Port                    this transforms all kinds of ports
            % Currentdistribution     this transforms nearfield sources
            % Part                    this transforms a complete block in the 3D Layout View
            % (2020) Anchorpoint, Face, Meshshape, Probe, Voxeldata
            %                         this transforms the named object
            % (2020) mixed            this transforms a mixed selection of objects. Those need to be added via Name and AddName global name syntax.
            % (2020) HF3DMonitor      this transforms high frequency field monitors. Currently only Field-Source-Monitors are transformable.
            % (2020) Lumpedelement    this transforms lumped element
            % (2020) Coil, currentmonitor, currentwire, voltagemonitor, voltagewire
            %                         this transforms the named object
            %
            % enum how        description                                                                 special methods
            % Translate       Moves the object along a given vector                                       Vector, UsePickedPoints, InvertPickedPoints
            % Rotate          Rotates the object around one main axis, given the angle and an offset
            %                 for the rotation axis (origin).                                             Angle, Center, Origin
            % Scale           scales the object. The scaling center can be specified as well. For some
            %                 types, only uniform scaling is allowed.                                     ScaleFactor, Center, Origin
            % Mirror          mirrors the object on a mirror plane whose normal and offset is given       PlaneNormal, Center, Origin
            % Matrix          this applies a general matrix transformation onto a given object. Input
            %                 is a 3 by 3 Matrix and an additional translation vector.                    Matrix, Vector
            % LocalToGlobal   After this transform that consists of translates and rotates internally, the position and orientation of the object  in
            %                 regard to the global coordinate system will match its position and rotation that it had to the local coordinate system before.
            % GlobalToLocal   This is the inverse operation to the one above. An object aligned to the x-y plane in the origin of the global coordinate
            %                 system will afterwards be aligned to the u-v plane and translated to be in the origin of the local coordinate system.
            %
            % Note: To align some object in a completely user specified manner onto something else, you can follow this workflow:
            % 1. Transform the local coordinate system to specify an anchor system for your object to be aligned.
            % 2. Transform "LocalToGlobal" this object.
            % 3. Align the local coordinate system to specify the target of your previously defined anchor coordinate system
            % 4. Transform "GlobalToLocal" your object of interest.
            % (There is a Macro for that. Contstruct/Miscellaneous/Transform selected objects to local WCS or to global coordinates")
            % what: 'Shape'
            %       'FFS'
            %       'Port'
            %       'Currentdistribution'
            %       'Part'
            %       (2020) 'Anchorpoint'
            %       (2020) 'Coil'
            %       (2020) 'CurrentMonitor'
            %       (2020) 'CurrentWire'
            %       (2020) 'Face'
            %       (2020) 'HF3DMonitor'
            %       (2020) 'Mixed'
            %       (2020) 'Probe'
            %       (2020) 'VoltageMonitor'
            %       (2020) 'VoltageWire'
            %       (2020) 'Voxeldata'

            % how: 'Translate'
            %      'Rotate'
            %      'Scale'
            %      'Mirror'
            %      'Matrix'
            %      'GlobalToLocal'
            %      'LocalToGlobal'
            obj.AddToHistory(['.Transform "', num2str(what, '%.15g'), '", '...
                                         '"', num2str(how, '%.15g'), '"']);

            % Prepend With Transform and append End With
            obj.history = [ 'With Transform', newline, ...
                                obj.history, ...
                            'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: ', how, ' ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: ', how, ' ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        function UsePickedPoints(obj, boolean)
            % This method is valid for the translation of a selected shape and decides if a translation vector is defined by the two recently picked points (switch = True) or if the vector is given numerically (switch = False).
            obj.AddToHistory(['.UsePickedPoints "', num2str(boolean, '%.15g'), '"']);
        end
        function InvertPickedPoints(obj, boolean)
            % This method is valid for the translation of a selected shape by use of picked points. The resulting translation vector will be inverted (switch = True) or remains unchanged (switch = False).
            obj.AddToHistory(['.InvertPickedPoints "', num2str(boolean, '%.15g'), '"']);
        end
        function MultipleObjects(obj, copy)
            % If switch is True, the new solid will be copied and the original will remain untouched. Else (copy = False), the original object will be deleted. In case of repeated execution by usage of the .Repetitions method, copy = True will result in number new objects plus the original object.
            obj.AddToHistory(['.MultipleObjects "', num2str(copy, '%.15g'), '"']);
        end
        function GroupObjects(obj, unite)
            % If new objects are created during the transformation (.MultipleObjects enabled), unite = True defines that every new object will be a united with the original object after the transformation. If unite = False all new objects will stay separately.
            obj.AddToHistory(['.GroupObjects "', num2str(unite, '%.15g'), '"']);
        end
        function Origin(obj, key)
            % For scale, rotate and mirror transformations, this method defines, whether the origin for the transformation should be the shape center, the center of all named shapes (see .AddName), or a free point defined by the .Center method.
            % key: 'ShapeCenter'
            %      'CommonCenter'
            %      'Free'
            obj.AddToHistory(['.Origin "', num2str(key, '%.15g'), '"']);
        end
        function Center(obj, u, v, w)
            % Sets the center for scale, rotate and mirror transformations. The working coordinate system will be used, if activated. Only applicable, if .Origin is set to "free".
            obj.AddToHistory(['.Center "', num2str(u, '%.15g'), '", '...
                                      '"', num2str(v, '%.15g'), '", '...
                                      '"', num2str(w, '%.15g'), '"']);
        end
        function Vector(obj, u, v, w)
            % Sets the translation vector. The working coordinate system will be used, if activated. Use in case of translate transformation only.
            obj.AddToHistory(['.Vector "', num2str(u, '%.15g'), '", '...
                                      '"', num2str(v, '%.15g'), '", '...
                                      '"', num2str(w, '%.15g'), '"']);
        end
        function ScaleFactor(obj, u, v, w)
            % Sets the scale factor for each coordinate direction. The working coordinate system will be used, if activated. Use in case of scale transformation only.
            obj.AddToHistory(['.ScaleFactor "', num2str(u, '%.15g'), '", '...
                                           '"', num2str(v, '%.15g'), '", '...
                                           '"', num2str(w, '%.15g'), '"']);
        end
        function Angle(obj, u, v, w)
            % Sets the rotation angle in degrees around the respective axis. The working coordinate system will be used, if activated. Use in case of rotate transformation only.
            obj.AddToHistory(['.Angle "', num2str(u, '%.15g'), '", '...
                                     '"', num2str(v, '%.15g'), '", '...
                                     '"', num2str(w, '%.15g'), '"']);
        end
        function PlaneNormal(obj, u, v, w)
            % Sets the mirror plane normal. The working coordinate system will be used, if activated. Use in case of mirror transformation only.
            obj.AddToHistory(['.PlaneNormal "', num2str(u, '%.15g'), '", '...
                                           '"', num2str(v, '%.15g'), '", '...
                                           '"', num2str(w, '%.15g'), '"']);
        end
        function Matrix(obj, c11, c12, c13, c21, c22, c23, c31, c32, c33)
            % Sets a 3 by 3 matrix for the matrix transformation column by column. c11 through c13 will define the transformation of the x vector.
            obj.AddToHistory(['.Matrix "', num2str(c11, '%.15g'), '", '...
                                      '"', num2str(c12, '%.15g'), '", '...
                                      '"', num2str(c13, '%.15g'), '", '...
                                      '"', num2str(c21, '%.15g'), '", '...
                                      '"', num2str(c22, '%.15g'), '", '...
                                      '"', num2str(c23, '%.15g'), '", '...
                                      '"', num2str(c31, '%.15g'), '", '...
                                      '"', num2str(c32, '%.15g'), '", '...
                                      '"', num2str(c33, '%.15g'), '"']);
        end
        function Repetitions(obj, number)
            % Defines the number of repetitions, the transformation will be applied to the selected object.
            obj.AddToHistory(['.Repetitions "', num2str(number, '%.15g'), '"']);
        end
        function Component(obj, name)
            % Sets the component for the new solid. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(name, '%.15g'), '"']);
        end
        function Material(obj, name)
            % Sets the material for the new solid. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(name, '%.15g'), '"']);
        end
        function MultipleSelection(obj, boolean)
            % This setting specifies whether the transformation should be performed only to one solid or to multiple selected objects. If you transform multiple objects history entries are created for every shape and if you transform by selected points the pickpoints will be deleted after an operation. This flag prevents the pickpoints from being deleted. If there are still solids to transform the flag is 'true' and in the last transform block it is 'false' so the pickpoints will be deleted.
            obj.AddToHistory(['.MultipleSelection "', num2str(boolean, '%.15g'), '"']);
        end
        %% CST 2014 Functions.
        function TransformAlign(obj, previouslyPasted, noMoreRotate)
            % This method expects two faces to be picked and transforms a subset of all objects by translation and rotation so that the selected faces touch afterwards. Which parts of the objects are transformed depends on the bool previouslyPasted: if true the information of a previous copy-paste operation or of a subproject import are used. If false, all solids set by .Name and .AddName are used.
            % If noMoreRotate is true, the picks are deleted and left for a following RotateAlign.
            obj.AddToHistory(['.TransformAlign "', num2str(previouslyPasted, '%.15g'), '", '...
                                              '"', num2str(noMoreRotate, '%.15g'), '"']);
        end
        function RotateAlign(obj, previouslyPasted)
            % This method expects two faces and two points to be picked and twists a subset of all objects around the center of the second face. The twist angle is calculated by defining two lines starting at the center of the second face to the two given points which should be parallel afterwards. The rotation axis is perpendicular to the second face.
            % The selection of the model is done in the same way as described for TransformAlign.
            % Please Note: This method expects to be called after a TransformAlign so that the picked faces are already touching. The picks are cleared afterwards.
            obj.AddToHistory(['.RotateAlign "', num2str(previouslyPasted, '%.15g'), '"']);
        end
        %% CST 2020 Functions.
        function Touch(obj, enable)
            % This enables parametric transform-touch. Whenever this transform is executed, the translation or rotation is continued until it hits another shape.
            obj.AddToHistory(['.Touch "', num2str(enable, '%.15g'), '"']);
        end
        function AddNameToActiveTouchSet(obj, name)
            % Adds a shape to the set of shapes that are used for touch calculation and actively moved against the set of passive shapes. If not specified, all shapes listed via Name and AddName are used for the touch calculations.
            obj.AddToHistory(['.AddNameToActiveTouchSet "', num2str(name, '%.15g'), '"']);
        end
        function AddNameToPassiveTouchSet(obj, name)
            % Adds a shape to the set of shapes that are used as opponents for the touch calculations. Against each of the shapes, all shapes of the "active set" (see above) are moved. If not specified, all shapes of the project that are not part of the "active set" are taken as "passive set".
            obj.AddToHistory(['.AddNameToPassiveTouchSet "', num2str(name, '%.15g'), '"']);
        end
        function TouchTolerance(obj, tolerance)
            % Specifies the maximum distance that the touch algorithm interprets as "touching". The smaller this value, the longer touch calculations will take but also the more accurate they will be.
            obj.AddToHistory(['.TouchTolerance "', num2str(tolerance, '%.15g'), '"']);
        end
        function TouchMaxIterations(obj, number)
            % Specifies the maximum number of iterations that the touch algorithm performs. If nothing is found until max iterations is reached, the shapes will not move at all.
            obj.AddToHistory(['.TouchMaxIterations "', num2str(number, '%.15g'), '"']);
        end
        function TouchHeuristic(obj, heuristic)
            % Usually, the heurstic mode is a lot faster, esp. for rotation cases. The default is "true". In very special corner cases, a collision may be missed. If switched off, a conservative approach in collision detection is used. This will take way more iterations but no collision will be missed.
            obj.AddToHistory(['.TouchHeuristic "', num2str(heuristic, '%.15g'), '"']);
        end
        function TouchOffset(obj, offset)
            % If above zero, the transformation is taken beyond the point of touching, approximately to penetrate the touching shape by a depth of offset.
            % If below zero, a collision is prevented and the final state should be approximately such that the minimum distance between the moving shapes and a close "passive" shape has the value of offset.
            obj.AddToHistory(['.TouchOffset "', num2str(offset, '%.15g'), '"']);
        end
        %% Undocumented functions.
        % Found in history list.
        function Destination(obj, destinationname)
            obj.AddToHistory(['.Destination "', destinationname, '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTransform
        history

        names
    end
end

%% Default Settings
% UsePickedPoints(0)
% InvertPickedPoints(0)
% MultipleObjects(0)
% GroupObjects(0)
% Origin('ShapeCenter');
%
