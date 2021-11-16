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

% Extrudes a Profile or a selected face into a three dimensional solid.
classdef Extrude < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Extrude object.
        function obj = Extrude(project, hProject)
            obj.project = project;
            obj.hExtrude = hProject.invoke('Extrude');
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

            obj.name = [];
            obj.component = [];
        end
        function Name(obj, objectname)
            % Sets the name of the extrude Object.
            obj.AddToHistory(['.Name "', num2str(objectname, '%.15g'), '"']);
            obj.name = objectname;
        end
        function Component(obj, componentname)
            % Sets the component for the new Solid. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
            obj.component = componentname;
        end
        function Material(obj, materialname)
            % Sets the material for the new Solid. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function Mode(obj, extrMode)
            % Selects whether a profile or a surface is to be extruded.
            % extrMode may have the following settings:
            % "pointlist"       - A profile defined by points is to be extruded
            % "picks"           - A picked face is to be extruded
            % "multiplepicks"   - multpile picked faces are to be extruded
            obj.AddToHistory(['.Mode "', num2str(extrMode, '%.15g'), '"']);
        end
        function Height(obj, heightval)
            % Defines the height of the extruded solid.
            obj.AddToHistory(['.Height "', num2str(heightval, '%.15g'), '"']);
        end
        function Origin(obj, x, y, z)
            % Defines the location of the origin.
            obj.AddToHistory(['.Origin "', num2str(x, '%.15g'), '", '...
                                      '"', num2str(y, '%.15g'), '", '...
                                      '"', num2str(z, '%.15g'), '"']);
        end
        function Uvector(obj, u, v, w)
            % Vvector ( double u , double v, double w )
            % These settings define the plane on which the profile will be defined. u, v, w are related on the current working coordinate system.
            obj.AddToHistory(['.Uvector "', num2str(u, '%.15g'), '", '...
                                       '"', num2str(v, '%.15g'), '", '...
                                       '"', num2str(w, '%.15g'), '"']);
        end
        function Vvector(obj, u, v, w)
            % These settings define the plane on which the profile will be defined. u, v, w are related on the current working coordinate system.
            obj.AddToHistory(['.Vvector "', num2str(u, '%.15g'), '", '...
                                       '"', num2str(v, '%.15g'), '", '...
                                       '"', num2str(w, '%.15g'), '"']);
        end
        function Point(obj, uPt, vPt)
            % Sets the first point of the to be defined profile. This setting has an effect only if Mode is set to "pointlist".
            obj.AddToHistory(['.Point "', num2str(uPt, '%.15g'), '", '...
                                     '"', num2str(vPt, '%.15g'), '"']);
        end
        function LineTo(obj, u, v)
            % Sets a line from the point previously defined to the point defined by u, v here. u and v specify a location in absolute coordinates in the actual working coordinate system. This line will be a part of the profile to be rotated/extruded. To finisch a profile, the last line has to end on the values defined by the Point Method. This setting has an effect only, if Mode  is set to "pointlist".
            obj.AddToHistory(['.LineTo "', num2str(u, '%.15g'), '", '...
                                      '"', num2str(v, '%.15g'), '"']);
        end
        function RLine(obj, u, v)
            % Sets a line from the point previously defined to the point defined by u, v here. u and v specify a location relative to the previous point in the current working coordinate sytem. This line will be a part of the profile to be rotated/extruded. To finisch a profile, the last line has to end on the values defined by the Point Method. This setting has an effect only, if Mode is set to "pointlist".
            obj.AddToHistory(['.RLine "', num2str(u, '%.15g'), '", '...
                                     '"', num2str(v, '%.15g'), '"']);
        end
        function Taper(obj, tp)
            % Defines a value of how much the to be extruded face is enlarged during extrusion.
            obj.AddToHistory(['.Taper "', num2str(tp, '%.15g'), '"']);
        end
        function Twist(obj, tw)
            % Twists the solid around the direction of extrusion. The parameter tw defines the angle in degree of how much the solid will be twisted.
            obj.AddToHistory(['.Twist "', num2str(tw, '%.15g'), '"']);
        end
        function UsePicksForHeight(obj, flag)
            % Use a previously picked point for the height of the extrusion.
            obj.AddToHistory(['.UsePicksForHeight "', num2str(flag, '%.15g'), '"']);
        end
        function PickHeightDeterminedByFirstFace(obj, flag)
            % For multiple picked faces and a picked point that is used for calculating the height: If true, the height that is calculated for the first picked face will be applied to all created shapes. If false, for each picked face, the height will be calculated to meet the picked point.
            obj.AddToHistory(['.PickHeightDeterminedByFirstFace "', num2str(flag, '%.15g'), '"']);
        end
        function NumberOfPickedFaces(obj, nCount)
            % If the mode is "multiplepicks", the number of picked faces is set here.
            obj.AddToHistory(['.NumberOfPickedFaces "', num2str(nCount, '%.15g'), '"']);
        end
        function DeleteBaseFaceSolid(obj, flag)
            % Deletes the face used for the extrusion.
            obj.AddToHistory(['.DeleteBaseFaceSolid "', num2str(flag, '%.15g'), '"']);
        end
        function ClearPickedFace(obj, flag)
            % Cleares the picked face after the extrude command.
            obj.AddToHistory(['.ClearPickedFace "', num2str(flag, '%.15g'), '"']);
        end
        function ModifyHeight(obj)
            % Changes the solid to the previously specified settings.
            obj.AddToHistory(['.ModifyHeight']);
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
            % Creates a new extruded solid. All necessary settings for this element have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With Extrude and append End With
            obj.history = [ 'With Extrude', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define extrude: ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hExtrude
        history

        name
        component
    end
end

%% Default Settings
% Mode('pointlist');
% UsePicksForHeight(0)
% PickHeightDeterminedByFirstFace(1)
% DeleteBaseFaceSolid(0)
% ClearPickedFace(0)
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
% extrude = project.Extrude();
%     extrude.Reset
%     extrude.Name('solid2');
%     extrude.Component('component1');
%     extrude.Material('Vacuum');
%     extrude.Mode('Picks');
%     extrude.Height('2+b');
%     extrude.Twist(0.0)
%     extrude.Taper(5)
%     extrude.UsePicksForHeight(0)
%     extrude.DeleteBaseFaceSolid(0)
%     extrude.ClearPickedFace(1)
%     extrude.Create
