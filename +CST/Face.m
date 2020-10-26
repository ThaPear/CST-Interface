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

% Defines a Face object
classdef Face < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Face object.
        function obj = Face(project, hProject)
            obj.project = project;
            obj.hFace = hProject.invoke('Face');
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
        function Name(obj, objectName)
            % Sets the name of the face.
            obj.AddToHistory(['.Name "', num2str(objectName, '%.15g'), '"']);
        end
        function Curve(obj, curvName)
            % Specifies a curve that is taken to define the new face.
            obj.AddToHistory(['.Curve "', num2str(curvName, '%.15g'), '"']);
        end
        function Offset(obj, offs)
            % A face can be created by picking a face of a solid. The resulting face is placed with the given offs from the picked face.
            obj.AddToHistory(['.Offset "', num2str(offs, '%.15g'), '"']);
        end
        function Taperangle(obj, ta)
            % A face can be created by extruding a curve profile. The resulting face is the surface of the base solid body created when extruding the curve profile. This method determines the taper angle used for  the extrusion. It extends the profile along the direction of extrusion.
            obj.AddToHistory(['.Taperangle "', num2str(ta, '%.15g'), '"']);
        end
        function Thickness(obj, thick)
            % A face can be created by extruding a curve profile. The resulting face is the surface of the solid body created when extruding the curve profile. This method determines the height of the extrusion.
            obj.AddToHistory(['.Thickness "', num2str(thick, '%.15g'), '"']);
        end
        function Twistangle(obj, angle)
            % A face can be created by extruding a curve profile. The resulting face is the surface of the solid body created when extruding the curve profile. This method sets the twist angle used for  the extrusion. It twists the profile of about angle degrees along the direction of extrusion.
            obj.AddToHistory(['.Twistangle "', num2str(angle, '%.15g'), '"']);
        end
        function Type(obj, mode)
            % Selects whether a profile or a surface is to be extruded.
            obj.AddToHistory(['.Type "', num2str(mode, '%.15g'), '"']);
        end
        function may = mode(obj)
            % "PickFace"      The face is created by a picked face of a solid.
            % "ExtrudeCurve"  The face is created by extruding a curve profile.
            % "CoverCurve"    The face is created by covering a curve profile.
            may = obj.hFace.invoke('mode');
        end
        function Rename(obj, oldName, newName)
            % Changes the name of an already created face.
            obj.project.AddToHistory(['Face.Rename "', num2str(oldName, '%.15g'), '", '...
                                                  '"', num2str(newName, '%.15g'), '"']);
        end
        function Delete(obj, faceName)
            % Deletes the face with the given name.
            obj.project.AddToHistory(['Face.Delete "', num2str(faceName, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new extruded solid. All necessary settings for this element have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With Face and append End With
            obj.history = [ 'With Face', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Face'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hFace
        history

    end
end

%% Default Settings
% Thickness(0.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% face = project.Face();
%     face.Reset
%     face.Name('face1');
%     face.Type('PickFace');
%     face.Offset(0.5)
%     face.Create
%
