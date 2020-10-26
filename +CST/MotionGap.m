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

% Defines a new gap item for an existing rigid body motion object.
classdef MotionGap < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.MotionGap object.
        function obj = MotionGap(project, hProject)
            obj.project = project;
            obj.hMotionGap = hProject.invoke('MotionGap');
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
            % Resets all internal settings for a gap definition to their default values.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Name(obj, name)
            % Sets the name of the new gap item that will be edited or created. Each gap item within one rigid body motion object must have a unique name.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function MotionObject(obj, name)
            % Sets the name of the rigid body motion object to which the gap item belongs.
            obj.AddToHistory(['.MotionObject "', num2str(name, '%.15g'), '"']);
        end
        function Tool(obj, name)
            % Sets the type of the tool used for the gap definition to an extruded polygon (name="PolygonExtrude") or an extruded circle (name="CircleExtrude") .
            obj.AddToHistory(['.Tool "', num2str(name, '%.15g'), '"']);
        end
        function StartPointState(obj, state)
            % Specifies whether the start point coordinate is to be used as the first point (state = "coordinate") or its projection on the rotation axis (state = "axis").
            obj.AddToHistory(['.StartPointState "', num2str(state, '%.15g'), '"']);
        end
        function EndPointState(obj, state)
            % Specifies whether the end point coordinate is to be used as the last point (state = "coordinate") or its projection on the rotation axis (state = "axis").
            obj.AddToHistory(['.EndPointState "', num2str(state, '%.15g'), '"']);
        end
        function Point(obj, x, y)
            % Sets the first point in the local uv plane of the profile that will be rotated (for rotations) or extruded (for translations) to define the gap or the center of the circle which will be extruded (for tool="CircleExtrude").
            obj.AddToHistory(['.Point "', num2str(x, '%.15g'), '", '...
                                     '"', num2str(y, '%.15g'), '"']);
        end
        function LineTo(obj, x, y, z)
            % Sets further points in the local uv plane of the profile that will be rotated (for rotations) or extruded (for translations) to define the gap.
            obj.AddToHistory(['.LineTo "', num2str(x, '%.15g'), '", '...
                                      '"', num2str(y, '%.15g'), '", '...
                                      '"', num2str(z, '%.15g'), '"']);
        end
        function Radius(obj, radius)
            % Sets the radius of the extruded circle for tool = "CircleExtrude".
            obj.AddToHistory(['.Radius "', num2str(radius, '%.15g'), '"']);
        end
        function Create(obj)
            % For rotations: Creates a rotation gap by rotating the defined profile around the specified rotation axis.
            % For translations: Creates a translation gap by extruding the defined profile along the specified translation axis through the entire calculation domain.
            obj.AddToHistory(['.Create']);

            % Prepend With MotionGap and append End With
            obj.history = [ 'With MotionGap', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define MotionGap: ', obj.name], obj.history);
            obj.history = [];
        end
        %% CST 2014 Functions.
        function Active(obj, state)
            % Activates or deactivates the gap item for further calculations.
            obj.AddToHistory(['.Active "', num2str(state, '%.15g'), '"']);
        end
        function Orientation(obj, dir)
            % Specifies whether the rotor or mover elements are positioned inside the gap (dir = "inside") or outside the gap (dir = "outside").
            obj.AddToHistory(['.Orientation "', num2str(dir, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hMotionGap
        history

        name
    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% motiongap = project.MotionGap();
%     motiongap.Reset
%     motiongap.Name('Gap1');
%     motiongap.MotionObject('Rotation1');
%     motiongap.Active('1');
%     motiongap.Orientation('Inside');
%     motiongap.StartPointState('coordinate');
%     motiongap.EndPointState('coordinate');
%     motiongap.Point('0', '0');
%     motiongap.LineTo('0', '1');
%     motiongap.LineTo('1', '1');
%     motiongap.LineTo('1', '0');
%     motiongap.LineTo('0', '0');
%     motiongap.Create
%
