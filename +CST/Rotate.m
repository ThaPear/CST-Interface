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

% Creates a three dimensional solid by rotating  a Profile or a selected face.
classdef Rotate < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Rotate object.
        function obj = Rotate(project, hProject)
            obj.project = project;
            obj.hRotate = hProject.invoke('Rotate');
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
            % Resets all internal settings.
            obj.AddToHistory(['.Reset']);
        end
        function Name(obj, objectname)
            % Sets the name of the extrude Object.
            obj.AddToHistory(['.Name "', num2str(objectname, '%.15g'), '"']);
        end
        function Component(obj, componentname)
            % Sets the component for the new Solid. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
        end
        function Material(obj, materialname)
            % Sets the material for the new Solid. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function Mode(obj, rotMode)
            % Selects whether a profile or a surface is to be rotated.
            % rotMode may have the following settings:
            % ”pointlist”
            % A profile defined by points is to be rotated
            % ”picks”
            % A picked face is to be rotated
            obj.AddToHistory(['.Mode "', num2str(rotMode, '%.15g'), '"']);
        end
        function StartAngle(obj, startA)
            %  If the  Mode is "pointlist", specify the start angle for the rotation.
            obj.AddToHistory(['.StartAngle "', num2str(startA, '%.15g'), '"']);
        end
        function Angle(obj, angleVal)
            % Sets the angle of rotation. If  the Mode is ”pointlist” this value will be counted from the StartAngle.
            obj.AddToHistory(['.Angle "', num2str(angleVal, '%.15g'), '"']);
        end
        function Height(obj, heightVal)
            % Bends the rotated solid along the rotation axis such that a helix is created. The argument heightVal specifies the distance between the starting profile and the ending profile along the axis of rotation.
            obj.AddToHistory(['.Height "', num2str(heightVal, '%.15g'), '"']);
        end
        function Origin(obj, x, y, z)
            % Defines the origin for the rotation.
            obj.AddToHistory(['.Origin "', num2str(x, '%.15g'), '", '...
                                      '"', num2str(y, '%.15g'), '", '...
                                      '"', num2str(z, '%.15g'), '"']);
        end
        function Rvector(obj, u, v, w)
            % These settings define the plane on which the profile will be defined. u, v, w are related on the current working coordinate system.
            obj.AddToHistory(['.Rvector "', num2str(u, '%.15g'), '", '...
                                       '"', num2str(v, '%.15g'), '", '...
                                       '"', num2str(w, '%.15g'), '"']);
        end
        function Zvector(obj, u, v, w)
            % These settings define the plane on which the profile will be defined. u, v, w are related on the current working coordinate system.
            obj.AddToHistory(['.Zvector "', num2str(u, '%.15g'), '", '...
                                       '"', num2str(v, '%.15g'), '", '...
                                       '"', num2str(w, '%.15g'), '"']);
        end
        function Point(obj, uPt, vPt)
            % Sets the first point of the to be defined profile. This setting has an effect only if Mode is set to ”pointlist”.
            obj.AddToHistory(['.Point "', num2str(uPt, '%.15g'), '", '...
                                     '"', num2str(vPt, '%.15g'), '"']);
        end
        function LineTo(obj, u, v)
            % Sets a line from the point previously defined to the point defined by u, v here. u and v specify a location in absolute coordinates in the actual working coordinate system. This line will be a part of the profile to be rotated/extruded. To finisch a profile, the last line has to end on the values defined by the Point Method. This setting has an effect only, if Mode  is set to ”pointlist”.
            obj.AddToHistory(['.LineTo "', num2str(u, '%.15g'), '", '...
                                      '"', num2str(v, '%.15g'), '"']);
        end
        function RLine(obj, u, v)
            % Sets a line from the point previously defined to the point defined by u, v here. u and v specify a location relative to the previous point in the current working coordinate sytem. This line will be a part of the profile to be rotated/extruded. To finisch a profile, the last line has to end on the values defined by the Point Method. This setting has an effect only, if Mode is set to ”pointlist”.
            obj.AddToHistory(['.RLine "', num2str(u, '%.15g'), '", '...
                                     '"', num2str(v, '%.15g'), '"']);
        end
        function RadiusRatio(obj, radRat)
            % A value different to one will cause a linear change to the radius of rotation depending on the angle. The radRat value defines the ratio between the radius after a 360 degree rotation and the starting radius. The radius is the distance from the axis of rotation and the center of gravity of the to be rotated profile.
            obj.AddToHistory(['.RadiusRatio "', num2str(radRat, '%.15g'), '"']);
        end
        function ModifyAngle(obj)
            % Changes the angle of the rotation to the previously set solid and value.
            obj.AddToHistory(['.ModifyAngle']);
        end
        function NSteps(obj, nSteps)
            % The parameter nSteps defines the number of segments (elements) the rotated solid will be made of. If NStep is zero, an analytical shape is created. This is the most accurate way to model the structure, but its creation might also be very time consuming in some cases. Therefore this method allows to approximate the rotated shape with NStep extruded elements.
            obj.AddToHistory(['.NSteps "', num2str(nSteps, '%.15g'), '"']);
        end
        function SplitClosedEdges(obj, flag)
            % This command is used for backward compatibility only. It is strongly recommended to set this flag to 'True' for newly created solids. In case that the newly created faces would become complex splines, this setting splits the edges of the rotated base face first such that the complexity of the resulting spline faces is reduced. This setting is especially important for helical types of structures with many turns.
            obj.AddToHistory(['.SplitClosedEdges "', num2str(flag, '%.15g'), '"']);
        end
        function SegmentedProfile(obj, flag)
            % The rotation will be done by the defined number of segments.
            obj.AddToHistory(['.SegmentedProfile "', num2str(flag, '%.15g'), '"']);
        end
        function DeleteBaseFaceSolid(obj, flag)
            % Deletes the face used for rotation.
            obj.AddToHistory(['.DeleteBaseFaceSolid "', num2str(flag, '%.15g'), '"']);
        end
        function ClearPickedFace(obj, flag)
            % Clears the picked face after the rotation.
            obj.AddToHistory(['.ClearPickedFace "', num2str(flag, '%.15g'), '"']);
        end
        function SimplifySolid(obj, flag)
            % This command is used for backward compatibility only. Setting this flag to 'True' is strongly recommended for automatically reducing the number of spline faces in the newly created solid as much as possible.
            obj.AddToHistory(['.SimplifySolid "', num2str(flag, '%.15g'), '"']);
        end
        function UseAdvancedSegmentedRotation(obj, flag)
            % This command is used for backward compatibility only. It is strongly recommended to set this flag to 'True' for newly created solids.
            obj.AddToHistory(['.UseAdvancedSegmentedRotation "', num2str(flag, '%.15g'), '"']);
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
        function Create(obj)
            % Creates a new rotated solid. All necessary settings for this element have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Rotate and append End With
            obj.history = [ 'With Rotate', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Rotate'], obj.history);
            obj.history = [];
        end
        %% Undocumented functions.
        % Found in history list of migrated CST 2014 file in 'define rotate'.
        function NumberOfPickedFaces(obj, value)
            obj.AddToHistory(['.NumberOfPickedFaces "', num2str(value, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define rotate'.
        function TaperAngle(obj, value)
            obj.AddToHistory(['.TaperAngle "', num2str(value, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define rotate'.
        function CutEndOff(obj, boolean)
            obj.AddToHistory(['.CutEndOff "', num2str(boolean, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hRotate
        history

    end
end

%% Default Settings
% Mode('pointlist');
% StartAngle(0)
% Height(0)
% Rvector(0, 0, 0)
% Zvector(0, 0, 0)
% RadiusRatio(1.0)
% SplitClosedEdges(0)
% SegmentedProfile(0)
% DeleteBaseFaceSolid(0)
% ClearPickedFAce(0)
% SimplifySolid(0)
% UseAdvancedSegmentedRotation(0)
% Material('default');
% Component('default');
% SetSimplifyActive(0)
% SetSimplifyMinPointsArc(3)
% SetSimplifyMinPointsCircle(5)
% SetSimplifyAngle(0.0)
% SetSimplifyAdjacentTol(1.0)
% SetSimplifyRadiusTol(0.0)
% SetSimplifyAngleTang(1.0)
% SetSimplifyEdgeLength(0.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% rotate = project.Rotate();
%     rotate.Reset
%     rotate.Name('solid2');
%     rotate.Component('component1');
%     rotate.Material('Vacuum');
%     rotate.Mode('Picks');
%     rotate.Angle(180)
%     rotate.Height(20)
%     rotate.RadiusRatio(2)
%     rotate.NSteps(20)
%     rotate.SplitClosedEdges(0)
%     rotate.SegmentedProfile(1)
%     rotate.DeleteBaseFaceSolid(0)
%     rotate.ClearPickedFace(1)
%     rotate.SimplifySolid(1)
%     rotate.UseAdvancedSegmentedRotation(1)
%     rotate.Create
