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

% Offers a set of tools to find or set specific points, edges or areas.
% Some methods/functions specify the objects that have to be picked by an id number. This id number is unique for every object. If not specified otherwise, the numbering starts with 0. Please note: If a solid changes such that new faces/edges/points are created, the id number might change!
% Some other methods/functions work on existing picks that can be listed by the pick lists (Modeling: Picks > Pick Lists   ). In this case, an index is passed to the function. This index is 0-based. The first element in the list (the pick that was performed the earliest) will be addressed by "0". It is also possible to use negative numbers, in that case the list is addressed in reverse order: "-1" is the latest picked object (the one with the greatest index in the list), "-2" the second to last pick and so on.
classdef Pick < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Pick object.
        function obj = Pick(project, hProject)
            obj.project = project;
            obj.hPick = hProject.invoke('Pick');
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
            % Prepend With Pick and append End With
            obj.history = [ 'With Pick', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Pick settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['Pick', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        %% Edge Modifications (index based)
        function AddEdge(obj, u1, v1, w1, u2, v2, w2)
            % Defines an edge with the starting point (u1,v1,w1) and the end point (u2,v2,w2). The points are taken as coordinates in the actual working coordinate system (WCS).
            obj.AddToHistory(['.AddEdge "', num2str(u1, '%.15g'), '", '...
                                       '"', num2str(v1, '%.15g'), '", '...
                                       '"', num2str(w1, '%.15g'), '", '...
                                       '"', num2str(u2, '%.15g'), '", '...
                                       '"', num2str(v2, '%.15g'), '", '...
                                       '"', num2str(w2, '%.15g'), '"']);
        end
        function DeleteEdge(obj, index)
            % Deletes a picked edge, specified by an index into the currently picked edge list (See: Modeling: Picks > Pick Lists    > Selected Edges...  ).
            obj.AddToHistory(['.DeleteEdge "', num2str(index, '%.15g'), '"']);
        end
        function MeanEdge(obj, indices)
            % Creates a mean edge out of the given ones (specified by the indices). Indices is a comma-separated list of numbers (either all positive and 0-indexed or all negative).
            obj.AddToHistory(['.MeanEdge "', num2str(indices, '%.15g'), '"']);
        end
        function MoveEdge(obj, index, deltax, deltay, deltaz, keep)
            % Moves the mid point of an edge (specified by index) in deltax, deltay and deltaz direction. The direction of the edge is kept, so it is only a collinear displacement.
            % Keep indicates weather the picked original edge will be kept (true) or deleted (false).
            % This method represents the macro implementation of the "modify action" from Modeling: Picks > Pick Lists   > Selected Edges... .
            obj.AddToHistory(['.MoveEdge "', num2str(index, '%.15g'), '", '...
                                        '"', num2str(deltax, '%.15g'), '", '...
                                        '"', num2str(deltay, '%.15g'), '", '...
                                        '"', num2str(deltaz, '%.15g'), '", '...
                                        '"', num2str(keep, '%.15g'), '"']);
        end
        function MoveEdgeInPlane(obj, index, offset, keep)
            % Moves the edge - defined from the latest picked face - tangential to the plane. Offset specifies how much the edge is moved from edge’s origin. Keep indicates weather the picked original edge will be kept (true) or deleted (false).
            obj.AddToHistory(['.MoveEdgeInPlane "', num2str(index, '%.15g'), '", '...
                                               '"', num2str(offset, '%.15g'), '", '...
                                               '"', num2str(keep, '%.15g'), '"']);
        end
        function PickEdgeFromPickedPoints(obj, index1, index2)
            % Picks a single edge which is specified by the indices of two previously picked points as listed in the Selected Point List: Modeling: Picks > Pick Lists   > Selected Points... .
            obj.AddToHistory(['.PickEdgeFromPickedPoints "', num2str(index1, '%.15g'), '", '...
                                                        '"', num2str(index2, '%.15g'), '"']);
        end
        %% General Methods
        function ClearAllPicks(obj)
            % Clears all previously chosen picks (edge, face, point).
            obj.AddToHistory(['.ClearAllPicks']);
        end
        function NextPickToDataBase(obj, id)
            % The next pick point will be written to an internal database. The id is the slot in the database. These points are referenced by the VBA functions xp, yp, zp, dist2d, dist3d, ldist2D.
            % (See also: Project VBA commands)
            obj.AddToHistory(['.NextPickToDataBase "', num2str(id, '%.15g'), '"']);
        end
        function SnapLastPointToDraplane(obj)
            % The last selected point will be projected to the drawing plane. In contrast to the Modeling: Picks > Picks  > Snap points to drawing plane  - which depends on the current view - the macro command is view independent.
            obj.AddToHistory(['.SnapLastPointToDraplane']);
        end
        %% Generic Picking on Lumped Elements, Ports and Coils
        % For some picking (e.g. on Lumped Elements, Port and Coils), generic Pick commands can be used. Those require a global name. If in doubt whether these methods can be used, please perform an interactive pick and then check the history entry... Face picking is only available for coils, via these generic commands.
        function PickPointFromIdOn(obj, name, picktype, id)
            % Picks the point with the given id from the element given by a global name. Currently the only supported value for picktype is "EndPoint".
            obj.AddToHistory(['.PickPointFromIdOn "', num2str(name, '%.15g'), '", '...
                                                 '"', num2str(picktype, '%.15g'), '", '...
                                                 '"', num2str(id, '%.15g'), '"']);
        end
        function PickPointFromPointOn(obj, name, picktype, x, y, z)
            % Picks the point next to (x, y, z) in the global coordinate system from the element given by a global name. Currently the only supported value for picktype is "AnyVertex".
            obj.AddToHistory(['.PickPointFromPointOn "', num2str(name, '%.15g'), '", '...
                                                    '"', num2str(picktype, '%.15g'), '", '...
                                                    '"', num2str(x, '%.15g'), '", '...
                                                    '"', num2str(y, '%.15g'), '", '...
                                                    '"', num2str(z, '%.15g'), '"']);
        end
        function PickEdgeFromIdOn(obj, name, edgeId, vertexId)
            % Picks the edge with the given edgeId from the element given by a global name. vertexId need to be the index of the starting vertex of the edge.
            obj.AddToHistory(['.PickEdgeFromIdOn "', num2str(name, '%.15g'), '", '...
                                                '"', num2str(edgeId, '%.15g'), '", '...
                                                '"', num2str(vertexId, '%.15g'), '"']);
        end
        function PickEdgeFromPointOn(obj, name, x, y, z)
            % Picks the edge next to (x, y, z) in the global coordinate system from the element given by a global name.
            obj.AddToHistory(['.PickEdgeFromPointOn "', num2str(name, '%.15g'), '", '...
                                                   '"', num2str(x, '%.15g'), '", '...
                                                   '"', num2str(y, '%.15g'), '", '...
                                                   '"', num2str(z, '%.15g'), '"']);
        end
        function PickFaceFromIdOn(obj, name, faceId)
            % Picks the face with the given faceId from the element given by a global name. vertexId need to be the index of the starting vertex of the edge.
            obj.AddToHistory(['.PickFaceFromIdOn "', num2str(name, '%.15g'), '", '...
                                                '"', num2str(faceId, '%.15g'), '"']);
        end
        function PickFaceFromPointOn(obj, name, x, y, z)
            % Picks the face next to (x, y, z) in the global coordinate system from the element given by a global name.
            obj.AddToHistory(['.PickFaceFromPointOn "', num2str(name, '%.15g'), '", '...
                                                   '"', num2str(x, '%.15g'), '", '...
                                                   '"', num2str(y, '%.15g'), '", '...
                                                   '"', num2str(z, '%.15g'), '"']);
        end
        %% Pick Edges from Solids (Id based)
        function PickDanglingEdgeChainFromId(obj, shapeName, id)
            % Picks a dangling edge chain (a set of connected edges) of a solid. The edge chain is specified by the solid that it belongs to and an identity number. A dangling edge has only one adjacent face.
            obj.AddToHistory(['.PickDanglingEdgeChainFromId "', num2str(shapeName, '%.15g'), '", '...
                                                           '"', num2str(id, '%.15g'), '"']);
        end
        function PickEdgeFromId(obj, shapeName, edge_id, vertex_id)
            % Picks an edge of a solid. The edge is specified by the solid that it belongs to and an identity number. 'vertex_id' is the index of the start point of this edge.
            obj.AddToHistory(['.PickEdgeFromId "', num2str(shapeName, '%.15g'), '", '...
                                              '"', num2str(edge_id, '%.15g'), '", '...
                                              '"', num2str(vertex_id, '%.15g'), '"']);
        end
        function PickEdgeFromPoint(obj, shapeName, xpoint, ypoint, zpoint)
            % Pick’s an edge of a solid - using a point on the edge - whereby the point is always defined
            % in global coordinates. The method so represents the Modeling: Picks > Picks  > Absolute Pick Positioning  mode
            obj.AddToHistory(['.PickEdgeFromPoint "', num2str(shapeName, '%.15g'), '", '...
                                                 '"', num2str(xpoint, '%.15g'), '", '...
                                                 '"', num2str(ypoint, '%.15g'), '", '...
                                                 '"', num2str(zpoint, '%.15g'), '"']);
        end
        function PickSolidEdgeChainFromId(obj, shapeName, edgeid, faceid)
            % Picks an edge chain (a set of connected edges) of a solid. The edge chain is specified by the solid that it belongs to and two identity numbers.
            obj.AddToHistory(['.PickSolidEdgeChainFromId "', num2str(shapeName, '%.15g'), '", '...
                                                        '"', num2str(edgeid, '%.15g'), '", '...
                                                        '"', num2str(faceid, '%.15g'), '"']);
        end
        %% Pick Faces
        function PickFaceChainFromId(obj, shapeName, faceId)
            % Picks a face chain (a set of connected faces) of a solid. The face chain is specified by the solid that it belongs to and an identity number.
            obj.AddToHistory(['.PickFaceChainFromId "', num2str(shapeName, '%.15g'), '", '...
                                                   '"', num2str(faceId, '%.15g'), '"']);
        end
        function PickFaceFromId(obj, shapeName, id)
            % Picks a face of a solid.  The face is specified by the solid that it belongs to and an identity number.
            obj.AddToHistory(['.PickFaceFromId "', num2str(shapeName, '%.15g'), '", '...
                                              '"', num2str(id, '%.15g'), '"']);
        end
        function PickFaceFromPoint(obj, shapeName, xpoint, ypoint, zpoint)
            % Pick’s a face - using a point on the face - whereby the point is always defined in global coordinates. The method so represents the Modeling: Picks > Picks  > Absolute Pick Positioning  mode.
            obj.AddToHistory(['.PickFaceFromPoint "', num2str(shapeName, '%.15g'), '", '...
                                                 '"', num2str(xpoint, '%.15g'), '", '...
                                                 '"', num2str(ypoint, '%.15g'), '", '...
                                                 '"', num2str(zpoint, '%.15g'), '"']);
        end
        %% Pick Modifications (partially index based)
        function ChangeFaceId(obj, shapeName, changestatement, versionnumber)
            % Used for backward compatibility of old projects that contain invalid pick id's. The pick id's of picked faces can be changed. ShapeName is the name of the picked solid. Changestatement indicates what id has to be replaced with which new id. Versionnumber indicates the design environment in which the replacement is valid.
            obj.AddToHistory(['.ChangeFaceId "', num2str(shapeName, '%.15g'), '", '...
                                            '"', num2str(changestatement, '%.15g'), '", '...
                                            '"', num2str(versionnumber, '%.15g'), '"']);
        end
        function ChangeEdgeId(obj, shapeName, changestatement, versionnumber)
            % Used for backward compatibility of old projects that contain invalid pick id's. The pick id's of picked edges can be changed. ShapeName is the name of the picked solid. Changestatement indicates what id has to be replaced with which new id. Versionnumber indicates the design environment in which the replacement is valid.
            obj.AddToHistory(['.ChangeEdgeId "', num2str(shapeName, '%.15g'), '", '...
                                            '"', num2str(changestatement, '%.15g'), '", '...
                                            '"', num2str(versionnumber, '%.15g'), '"']);
        end
        function ChangeVertexId(obj, shapeName, changestatement, versionnumber)
            % Used for backward compatibility of old projects that contain invalid pick id's. The pick id's of picked vertices can be changed. ShapeName is the name of the picked solid. Changestatement indicates what id has to be replaced with which new id. Versionnumber indicates the design environment in which the replacement is valid.
            obj.AddToHistory(['.ChangeVertexId "', num2str(shapeName, '%.15g'), '", '...
                                              '"', num2str(changestatement, '%.15g'), '", '...
                                              '"', num2str(versionnumber, '%.15g'), '"']);
        end
        function DeleteFace(obj, index)
            % Deletes a picked face, specified by an index into the corresponding pick list (see Modeling: Picks > Pick Lists   > Selected Faces...  ).
            obj.AddToHistory(['.DeleteFace "', num2str(index, '%.15g'), '"']);
        end
        function DeletePoint(obj, index)
            % Deletes a picked point, specified by an index into the corresponding pick list (see Modeling: Picks > Pick Lists  ).
            obj.AddToHistory(['.DeletePoint "', num2str(index, '%.15g'), '"']);
        end
        function MeanPoint(obj, indices)
            % Creates a mean point out of the given ones (specified by the indices). Indices is a comma-separated list of numbers (either all positive and 0-indexed or all negative).
            obj.AddToHistory(['.MeanPoint "', num2str(indices, '%.15g'), '"']);
        end
        function MeanLastTwoPoints(obj)
            % Creates the mean of  the latest  two picked points and replaces them with the newly created one. It represents the macro implementation of the command Modeling: Picks > Pick Point   > Mean Last two points
            obj.AddToHistory(['.MeanLastTwoPoints']);
        end
        function MovePoint(obj, index, deltax, deltay, deltaz, keep)
            % Moves a point (specified by index) in deltax, deltay and deltaz direction.
            % Keep indicates weather the picked original edge will be kept (true) or deleted (false).
            % This method represents the macro implementation of the "modify" action in Modeling: Picks > Pick Lists  .
            obj.AddToHistory(['.MovePoint "', num2str(index, '%.15g'), '", '...
                                         '"', num2str(deltax, '%.15g'), '", '...
                                         '"', num2str(deltay, '%.15g'), '", '...
                                         '"', num2str(deltaz, '%.15g'), '", '...
                                         '"', num2str(keep, '%.15g'), '"']);
        end
        function PickPointFromCoordinates(obj, x, y, z)
            % Picks a point. The point is specified by the desired position in space. If a local WCS is active the coordinates are relative to it, but stay absolute in the global system (so position will be the same after switching off the local WCS).
            obj.AddToHistory(['.PickPointFromCoordinates "', num2str(x, '%.15g'), '", '...
                                                        '"', num2str(y, '%.15g'), '", '...
                                                        '"', num2str(z, '%.15g'), '"']);
        end
        %% Pick Points from Curves (Coordinate based)
        function PickCurveCirclecenterFromPoint(obj, curveName, x, y, z)
            % Picks the center point of a circular curve. The point is specified by the curve that it belongs to and the desired position in space.
            obj.AddToHistory(['.PickCurveCirclecenterFromPoint "', num2str(curveName, '%.15g'), '", '...
                                                              '"', num2str(x, '%.15g'), '", '...
                                                              '"', num2str(y, '%.15g'), '", '...
                                                              '"', num2str(z, '%.15g'), '"']);
        end
        function PickCurveCirclepointFromPoint(obj, curveName, x, y, z, index)
            % Picks a point on a circular curve. The point is specified by the curve that it belongs to and the desired position in space. Furthermore there are four possible positions on the curve, defined by an index (0-3), each with a phase shift of 90 degree.
            obj.AddToHistory(['.PickCurveCirclepointFromPoint "', num2str(curveName, '%.15g'), '", '...
                                                             '"', num2str(x, '%.15g'), '", '...
                                                             '"', num2str(y, '%.15g'), '", '...
                                                             '"', num2str(z, '%.15g'), '", '...
                                                             '"', num2str(index, '%.15g'), '"']);
        end
        function PickCurveEndpointFromPoint(obj, curveName, x, y, z)
            % Picks the end point of a curve. The point is specified by the curve that it belongs to and the desired position in space.
            obj.AddToHistory(['.PickCurveEndpointFromPoint "', num2str(curveName, '%.15g'), '", '...
                                                          '"', num2str(x, '%.15g'), '", '...
                                                          '"', num2str(y, '%.15g'), '", '...
                                                          '"', num2str(z, '%.15g'), '"']);
        end
        function PickCurveMidpointFromPoint(obj, curveName, x, y, z)
            % Picks the middle point of a curve segment. The point is specified by the curve that it belongs to and the desired position in space.
            obj.AddToHistory(['.PickCurveMidpointFromPoint "', num2str(curveName, '%.15g'), '", '...
                                                          '"', num2str(x, '%.15g'), '", '...
                                                          '"', num2str(y, '%.15g'), '", '...
                                                          '"', num2str(z, '%.15g'), '"']);
        end
        %% Pick Points from Curves (Id based)
        function PickCurveCirclecenterFromId(obj, curveName, id)
            % Picks the center point of a circular curve. The point is specified by the curve that it belongs to and an identity number.
            obj.AddToHistory(['.PickCurveCirclecenterFromId "', num2str(curveName, '%.15g'), '", '...
                                                           '"', num2str(id, '%.15g'), '"']);
        end
        function PickCurveCirclepointFromId(obj, curveName, id, index)
            % Picks a point on a circular curve. The point is specified by the curve that it belongs to and an identity number. Furthermore there are four possible positions on the curve, defined by an index (0-3), each with a phase shift of 90 degree.
            obj.AddToHistory(['.PickCurveCirclepointFromId "', num2str(curveName, '%.15g'), '", '...
                                                          '"', num2str(id, '%.15g'), '", '...
                                                          '"', num2str(index, '%.15g'), '"']);
        end
        function PickCurveEndpointFromId(obj, curveName, id)
            % Picks the end point of a curve. The point is specified by the curve that it belongs to and an identity number.
            obj.AddToHistory(['.PickCurveEndpointFromId "', num2str(curveName, '%.15g'), '", '...
                                                       '"', num2str(id, '%.15g'), '"']);
        end
        function PickCurveMidpointFromId(obj, curveName, id)
            % Picks the middle point of a curve segment. The point is specified by the curve that it belongs to and an identity number.
            obj.AddToHistory(['.PickCurveMidpointFromId "', num2str(curveName, '%.15g'), '", '...
                                                       '"', num2str(id, '%.15g'), '"']);
        end
        %% Pick Points from Solids (Coordinate based)
        function PickCenterpointFromPoint(obj, shapeName, x, y, z)
            % Picks the center point of a face. The point is specified by the solid that it belongs to and the desired position in space.
            obj.AddToHistory(['.PickCenterpointFromPoint "', num2str(shapeName, '%.15g'), '", '...
                                                        '"', num2str(x, '%.15g'), '", '...
                                                        '"', num2str(y, '%.15g'), '", '...
                                                        '"', num2str(z, '%.15g'), '"']);
        end
        function PickCirclecenterFromPoint(obj, shapeName, x, y, z)
            % Picks the center point of a circular face. The point is specified by the solid that it belongs to and the desired position in space.
            obj.AddToHistory(['.PickCirclecenterFromPoint "', num2str(shapeName, '%.15g'), '", '...
                                                         '"', num2str(x, '%.15g'), '", '...
                                                         '"', num2str(y, '%.15g'), '", '...
                                                         '"', num2str(z, '%.15g'), '"']);
        end
        function PickCirclepointFromPoint(obj, shapeName, x, y, z)
            % Picks the edge point of a circular face. The point is specified by the solid that it belongs to and the desired position in space.
            obj.AddToHistory(['.PickCirclepointFromPoint "', num2str(shapeName, '%.15g'), '", '...
                                                        '"', num2str(x, '%.15g'), '", '...
                                                        '"', num2str(y, '%.15g'), '", '...
                                                        '"', num2str(z, '%.15g'), '"']);
        end
        function PickEndpointFromPoint(obj, shapeName, x, y, z)
            % Picks the end point of a edge. The point is specified by the solid that it belongs to and the desired position in space.
            obj.AddToHistory(['.PickEndpointFromPoint "', num2str(shapeName, '%.15g'), '", '...
                                                     '"', num2str(x, '%.15g'), '", '...
                                                     '"', num2str(y, '%.15g'), '", '...
                                                     '"', num2str(z, '%.15g'), '"']);
        end
        function PickMidpointFromPoint(obj, shapeName, x, y, z)
            % Picks the middle point of an edge. The point is specified by the solid that it belongs to and the desired position in space.
            obj.AddToHistory(['.PickMidpointFromPoint "', num2str(shapeName, '%.15g'), '", '...
                                                     '"', num2str(x, '%.15g'), '", '...
                                                     '"', num2str(y, '%.15g'), '", '...
                                                     '"', num2str(z, '%.15g'), '"']);
        end
        %% Pick Points from Solids (Id based)
        function PickCenterpointFromId(obj, shapeName, id)
            % Picks the center point of a face. The face is specified by the solid that it belongs to and an identity number.
            obj.AddToHistory(['.PickCenterpointFromId "', num2str(shapeName, '%.15g'), '", '...
                                                     '"', num2str(id, '%.15g'), '"']);
        end
        function PickCirclecenterFromId(obj, shapeName, id)
            % Picks the center point of a circular face. The face is specified by the solid that it belongs to and an identity number.
            obj.AddToHistory(['.PickCirclecenterFromId "', num2str(shapeName, '%.15g'), '", '...
                                                      '"', num2str(id, '%.15g'), '"']);
        end
        function PickCirclepointFromId(obj, shapeName, id)
            % Picks the edge point of a circular face. The face is specified by the solid that it belongs to and an identity number.
            obj.AddToHistory(['.PickCirclepointFromId "', num2str(shapeName, '%.15g'), '", '...
                                                     '"', num2str(id, '%.15g'), '"']);
        end
        function PickEndpointFromId(obj, shapeName, id)
            % Picks the end point of an edge. The edge is specified by the solid that it belongs to and an identity number.
            obj.AddToHistory(['.PickEndpointFromId "', num2str(shapeName, '%.15g'), '", '...
                                                  '"', num2str(id, '%.15g'), '"']);
        end
        function PickExtraCirclepointFromId(obj, shapeName, edgeid, faceid, index)
            % Picks an extra edge point of a circular face. The edge and face are specified by the solid that it belongs to and two identity numbers. Compared to PickCirclepointFromId there are three additional possible positions on the edge, defined by an index (0-2), each with a phase shift of 90 degree.
            obj.AddToHistory(['.PickExtraCirclepointFromId "', num2str(shapeName, '%.15g'), '", '...
                                                          '"', num2str(edgeid, '%.15g'), '", '...
                                                          '"', num2str(faceid, '%.15g'), '", '...
                                                          '"', num2str(index, '%.15g'), '"']);
        end
        function PickExtraSpherepointFromId(obj, shapeName, faceid, index)
            % Picks an extra point of a spherical face. The face is specified by the solid that it belongs to and an identity number. For a sphere there are six additional points positioned on the longitude and latitude lines of the sphere.
            obj.AddToHistory(['.PickExtraSpherepointFromId "', num2str(shapeName, '%.15g'), '", '...
                                                          '"', num2str(faceid, '%.15g'), '", '...
                                                          '"', num2str(index, '%.15g'), '"']);
        end
        function PickMidpointFromId(obj, shapeName, id)
            % Picks the middle point of an edge. The edge is specified by the solid that it belongs to and an identity number.
            obj.AddToHistory(['.PickMidpointFromId "', num2str(shapeName, '%.15g'), '", '...
                                                  '"', num2str(id, '%.15g'), '"']);
        end
        %% Pick Points from Wires
        function PickWireEndpointFromId(obj, wirename, id)
            % Picks one of the two wire end point. The end point  is specified by the wire that it belongs to and an identity number.
            obj.AddToHistory(['.PickWireEndpointFromId "', num2str(wirename, '%.15g'), '", '...
                                                      '"', num2str(id, '%.15g'), '"']);
        end
        function PickWireEndpointFromPoint(obj, wirename, x, y, z)
            % Picks the wire end point. The end point  is specified by the wire that it belongs to and the point coordinates.
            obj.AddToHistory(['.PickWireEndpointFromPoint "', num2str(wirename, '%.15g'), '", '...
                                                         '"', num2str(x, '%.15g'), '", '...
                                                         '"', num2str(y, '%.15g'), '", '...
                                                         '"', num2str(z, '%.15g'), '"']);
        end
        %% Queries
        function long = GetEdgeIdFromPoint(obj, shapename, x, y, z)
            % Returns the edge id at a given point for one shape.
            long = obj.hPick.invoke('GetEdgeIdFromPoint', shapename, x, y, z);
        end
        function long = GetFaceIdFromPoint(obj, shapename, x, y, z)
            % Returns the face id at a given point for one shape.
            long = obj.hPick.invoke('GetFaceIdFromPoint', shapename, x, y, z);
        end
        function int = GetNumberOfPickedPoints(obj)
            % Returns the total number of picked points.
            int = obj.hPick.invoke('GetNumberOfPickedPoints');
        end
        function int = GetNumberOfPickedEdges(obj)
            % Returns the total number of picked edges.
            int = obj.hPick.invoke('GetNumberOfPickedEdges');
        end
        function int = GetNumberOfPickedFaces(obj)
            % Returns the total number of picked faces.
            int = obj.hPick.invoke('GetNumberOfPickedFaces');
        end
        function [bool, x, y, z] = GetPickpointCoordinatesByIndex(obj, index)
            % Returns the coordinates of a picked point through the argument list. The picked point is specified by index starting with 0.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim x As Double, y As Double, z As Double', newline, ...
                'bool = Pick.GetPickpointCoordinatesByIndex("', num2str(index), '", x, y, z)', newline, ...
            ];
            returnvalues = {'bool', 'x', 'y', 'z'};
            [bool, x, y, z] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            x = str2double(x);
            y = str2double(y);
            z = str2double(z);
        end
        function [shapename, edgeid, vertexid] = GetPickedEdgeByIndex(obj, index)
            % Returns the shapename of a picked edge. The edge id  and the vertex id is returned through the argument list. The picked edge is specified by index starting with 0.
            functionString = [...
                'Dim shapename As String', newline, ...
                'Dim edgeid As Long, vertexid As Long', newline, ...
                'shapename = Pick.GetPickedEdgeByIndex("', num2str(index), '", edgeid, vertexid)', newline, ...
            ];
            returnvalues = {'shapename', 'edgeid', 'vertexid'};
            [shapename, edgeid, vertexid] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            edgeid = str2double(edgeid);
            vertexid = str2double(vertexid);
        end
        function [shapename, faceid] = GetPickedFaceByIndex(obj, index)
            % Returns the shapename of a picked face. The face id is returned through the argument list. The picked face is specified by index starting with 0.
            functionString = [...
                'Dim shapename As String', newline, ...
                'Dim faceid As Long', newline, ...
                'shapename = Pick.GetPickedFaceByIndex("', num2str(index), '", faceid)', newline, ...
            ];
            returnvalues = {'shapename', 'faceid'};
            [shapename, faceid] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            faceid = str2double(faceid);
        end
        function double = GetPickedFaceAreaByIndex(obj, index)
            % Returns the surface area of a picked face. The picked face is specified by index starting with 0.
            double = obj.hPick.invoke('GetPickedFaceAreaByIndex', index);
        end
        function long = GetVertexIdFromPoint(obj, shapename, x, y, z)
            % Returns the edge id at a given point for one shape.
            long = obj.hPick.invoke('GetVertexIdFromPoint', shapename, x, y, z);
        end
        function ExportFaceTriangles(obj, filename, maxlen, surftol)
            % Triangulates the picked faces using the given maximum edge length maxlen and surface tolerance surftol and writes the triangle points and normals to a file named filename.
            obj.AddToHistory(['.ExportFaceTriangles "', num2str(filename, '%.15g'), '", '...
                                                   '"', num2str(maxlen, '%.15g'), '", '...
                                                   '"', num2str(surftol, '%.15g'), '"']);
        end
        %% CST 2014 Functions.
        function PickCoilFaceFromId(obj, coilname, id)
            % Picks a face of the coil. The face is specified by the coil that it belongs to and an identity number.
            obj.AddToHistory(['.PickCoilFaceFromId "', num2str(coilname, '%.15g'), '", '...
                                                  '"', num2str(id, '%.15g'), '"']);
        end
        function PickCoilFaceFromPoint(obj, coilname, x, y, z)
            % Picks a face of the coil. The face is specified by the coil that it belongs to and the point coordinates.
            obj.AddToHistory(['.PickCoilFaceFromPoint "', num2str(coilname, '%.15g'), '", '...
                                                     '"', num2str(x, '%.15g'), '", '...
                                                     '"', num2str(y, '%.15g'), '", '...
                                                     '"', num2str(z, '%.15g'), '"']);
        end
        function MeanPointAll(obj)
            % Creates the mean of the latest two picked points and replaces them with the newly created one. It represents the macro implementation of the command Modeling: Picks  Pick Point   Mean Last two points
            obj.AddToHistory(['.MeanPointAll']);
        end
        function [bool, x, y, z] = GetPickpointCoordinates(obj, index)
            % Returns the coordinates of a picked point through the argument list. The picked point is specified by index starting with 0.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim x As Double, y As Double, z As Double', newline, ...
                'bool = Pick.GetPickpointCoordinates("', num2str(index), '", x, y, z)', newline, ...
            ];
            returnvalues = {'bool', 'x', 'y', 'z'};
            [bool, x, y, z] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            x = str2double(x);
            y = str2double(y);
            z = str2double(z);
        end
        function [shapename, edgeid, vertexid] = GetPickedEdgeFromIndex(obj, index)
            % Returns the shapename of a picked edge. The edge id  and the vertex id is returned through the argument list. The picked edge is specified by index starting with 0.
            functionString = [...
                'Dim shapename As String', newline, ...
                'Dim edgeid As Long, vertexid As Long', newline, ...
                'shapename = Pick.GetPickedEdgeFromIndex("', num2str(index), '", edgeid, vertexid)', newline, ...
            ];
            returnvalues = {'shapename', 'edgeid', 'vertexid'};
            [shapename, edgeid, vertexid] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            edgeid = str2double(edgeid);
            vertexid = str2double(vertexid);
        end
        function [shapename, faceid] = GetPickedFaceFromIndex(obj, index)
            % Returns the shapename of a picked face. The face id is returned through the argument list. The picked face is specified by index starting with 0.
            functionString = [...
                'Dim shapename As String', newline, ...
                'Dim faceid As Long', newline, ...
                'shapename = Pick.GetPickedFaceFromIndex("', num2str(index), '", faceid)', newline, ...
            ];
            returnvalues = {'shapename', 'faceid'};
            [shapename, faceid] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            faceid = str2double(faceid);
        end
        function double = GetPickedFaceAreaFromIndex(obj, index)
            % Returns the surface area of a picked face. The picked face is specified by index starting with 1.
            double = obj.hPick.invoke('GetPickedFaceAreaFromIndex', index);
        end
        %% Undocumented functions.
        % Found in history list of migrated CST 2014 file.
        % Possibly equivalent to NextPickToDataBase.
        function NextPickToDatabase(obj, id)
            obj.project.AddToHistory(['Pick.NextPickToDatabase "', num2str(id, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'unpick mid point'.
        % Possibly inverse of PickMidpointFromId.
        function UnpickMidpointFromId(obj, shapeName, id)
            obj.project.AddToHistory(['Pick.UnpickMidpointFromId "', num2str(shapeName, '%.15g'), '", '...
                                                                '"', num2str(id, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPick
        history
        bulkmode

    end
end
