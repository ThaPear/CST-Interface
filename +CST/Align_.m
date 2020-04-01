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
classdef Align_ < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Align object.
        function obj = Align_(project, hProject)
            obj.project = project;
            obj.hAlign = hProject.invoke('Align');
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
            % Resets all internal values to their defaults.
            obj.AddToHistory(['.Reset']);
            
            obj.name = [];
        end
        function Name(obj, sObjectName)
            % Defines the name of the object, the alignment should be applied to.
            % Note: for some alignments, a global name may be required (mixed alignment).
            obj.AddToHistory(['.Name "', num2str(sObjectName, '%.15g'), '"']);
            obj.name = sObjectName;
        end
        function AddName(obj, sObjectName)
            % Defines one more name of an additional object, in addition to the previously defined object.
            % Note: for some alignments, a global name may be required (mixed alignment).
            obj.AddToHistory(['.AddName "', num2str(sObjectName, '%.15g'), '"']);
        end
        function Align(obj, what, how)
            % This execute a specified alignment onto the given type of objects (named via Name and AddName).
            % 
            % enum what   description
            % Shape       this aligns solids
            % Subproject  this aligns a previously imported subproject or a previously pasted structure
            % Part        this aligns a complete block in the 3D Layout View
            % Mixed       if a multi selection encompasses different kind of objects (e.g. wires and solids), this type of alignment is used. In this case, global names need to be used for .Name and .AddName
            % 
            % enum how        description
            % Faces           This transforms the objects by rotation and translation so that two selected "faces" touch afterwards. One "face" is selected on the objects to be moved, another "face" is selected at some target object.
            % Rotate          This rotates the objects around a center of a picked "target" "face", having two picks that specify an angle, as input. For the angle, two directions need to be given: you can either pick a straight edge for a direction, or a point that will be pointed to from the center of rotation.
            % RotateByDegree  This rotates the objects around a center of a picked "target" "face. The angle needs to be specified using the command "SetNumericalValue" (see below).

            obj.AddToHistory(['.Align "', num2str(what, '%.15g'), '", '...
                                     '"', num2str(how, '%.15g'), '"']);
            
            % Prepend With Align and append End With
            obj.history = [ 'With Align', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['align: ', how, ' ', obj.name], obj.history);
            obj.history = [];
        end
        function SetKindOfPickFor(obj, what, kind)
            % This defines what is used to determine the information for calculating an alignment step. Different steps allow a different subset of kinds of information.
            % 
            % enum what   description                                                                         allowed kinds
            % SourcePlane This defines a normal and a center from where the object is going to be aligned.    Face        
            % TargetPlane This defines a normal and a center on which the object will be aligned.             Face
            % ZeroAngle   This is used to determine a direction that defines the angle zero for rotation.
            %             For the point, the direction is taken from TargetPlane center to the point.         Edge, Point
            % FinalAngle  This defines a direction to which the angle is measured to. (From ZeroAngle)        Edge, Point
            % 
            % enum kind   description
            % Face        A previously picked planar face is expected.
            % Edge        A picked linear edge is expected
            % Point       A picked point is expected
            obj.AddToHistory(['.SetKindOfPickFor "', num2str(what, '%.15g'), '", '...
                                                '"', num2str(kind, '%.15g'), '"']);
        end
        function SetNameToStep(obj, what, objectname)
            % Some steps may require a name attached to an alignment step. This methods uses global names for that. So far, only anchor points are allowed under certain circumstances.
            % what: 'SourcePlane'
            %       'TargetPlane'
            %       'ZeroAngle'
            %       'FinalAngle'
            obj.AddToHistory(['.SetNameToStep "', num2str(what, '%.15g'), '", '...
                                             '"', num2str(objectname, '%.15g'), '"']);
        end
        function SetNumericalValue(obj, what, value)
            % This sets a value for numerical operations, so far, only "RotateByDegree" supports this command.
            % enum what   description
            % Angle       This defines an angle in degree - used for the rotation by value.
            obj.AddToHistory(['.SetNumericalValue "', num2str(what, '%.15g'), '", '...
                                                 '"', num2str(value, '%.15g'), '"']);
        end
        function SetOppositeFaceOrientation(obj, flippedSwitch)
            % If flippedSwitch is true, instead of having z-axis (of faces or anchor points) opposing each other, the normal of the picked thing on the selected objects will point along the same direction as the normal on the previously picked remaining objects. This option is for the Face-Alignement step (see above). Interactively, pushing "TAB" at the right point in time during the alignment process will yield this flag to become set.
            obj.AddToHistory(['.SetOppositeFaceOrientation "', num2str(flippedSwitch, '%.15g'), '"']);
        end
        function ClearSubProjectImportInfo(obj, boolean)
            % This only concerns alignments of subproject imports. If the flag is set, the information of objects imported during the latest subproject will be cleared. This should be called be the last alignment step for a particular subproject alignment.
            obj.AddToHistory(['.ClearSubProjectImportInfo "', num2str(boolean, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hAlign
        history

        name
    end
end

%% Default Settings
% ClearSubProjectImportInfo(0)
% SetOppositeFaceOrientation(0)

%% Example - Taken from CST documentation and translated to MATLAB.
