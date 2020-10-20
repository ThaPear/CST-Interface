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

% Can be used to create and change dimensions.
classdef Dimension < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Dimension object.
        function obj = Dimension(project, hProject)
            obj.project = project;
            obj.hDimension = hProject.invoke('Dimension');
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
            % Resets the default values.
            obj.AddToHistory(['.Reset']);
        end
        function UsePicks(obj, use)
            % Deprecated and will not be used anymore
            obj.AddToHistory(['.UsePicks "', num2str(use, '%.15g'), '"']);
        end
        function CreationType(obj, type)
            % Indicates the type of the components involved to create the dimension. Can currently only contain "cbls" (Cable Studio) and "picks".
            obj.AddToHistory(['.CreationType "', num2str(type, '%.15g'), '"']);
        end
        function SetID(obj, id)
            % The id of the next dimension to be created. Creation for duplicated entries will fail. The ID need to be a positive integer value but can contain a valid expression.
            obj.AddToHistory(['.SetID "', num2str(id, '%.15g'), '"']);
        end
        function SetType(obj, type)
            % Must be either "Distance" or "Angular". No other values are allowed.
            obj.AddToHistory(['.SetType "', num2str(type, '%.15g'), '"']);
        end
        function SetOrientation(obj, orientation)
            % Only available for distance dimensions. Must be one of the following: Smart Mode, Face, X-Axis, Y-Axis, Z-Axis, Force-X, Force-Y, Force-Z, View.
            obj.AddToHistory(['.SetOrientation "', num2str(orientation, '%.15g'), '"']);
        end
        function SetOrientationFace(obj, faceID)
            % Only needed if the orientation is "Face". Need to be a valid pick-id for a solid the dimension is attached to..
            obj.AddToHistory(['.SetOrientationFace "', num2str(faceID, '%.15g'), '"']);
        end
        function SetDistance(obj, distance)
            % Set the distance from the dimension orthogonal to its origin (vector from start to end of the picked edge or between the two picked points) for the next dimension to be created. The distance need to be a double value but can contain a valid expression.
            obj.AddToHistory(['.SetDistance "', num2str(distance, '%.15g'), '"']);
        end
        function SetViewVector(obj, xvalue, yvalue, zvalue)
            % Set the view vector for the next dimension to be created. The view vector is used to compute the orientation of the dimension. If no faces attached to the current picks the orientation is the cross-product of the view vector and the vector between the picks. Otherwise the direction is orthogonal to the normal of the face that is next to the viewing vector. All parameters need to be double values but can contain a valid expression.
            obj.AddToHistory(['.SetViewVector "', num2str(xvalue, '%.15g'), '", '...
                                             '"', num2str(yvalue, '%.15g'), '", '...
                                             '"', num2str(zvalue, '%.15g'), '"']);
        end
        function SetLabelPattern(obj, label)
            % Defines a pattern for the dimension to be created/modified. "%v" is here a placeholder for the dimension value, "%e" for the dimension unit and expressions can be enclosed in the smaller "<" and bigger ">" symbol.
            obj.AddToHistory(['.SetLabelPattern "', num2str(label, '%.15g'), '"']);
        end
        function SetConnectedElement1(obj, name)
            % Global Name for the element the first point is connected to. Can be empty.
            obj.AddToHistory(['.SetConnectedElement1 "', num2str(name, '%.15g'), '"']);
        end
        function SetConnectedElement2(obj, name)
            % Global Name for the element the second point is connected to. Can be empty and will be ignored for Annotations.
            obj.AddToHistory(['.SetConnectedElement2 "', num2str(name, '%.15g'), '"']);
        end
        function SetConnectedElement3(obj, name)
            % Global Name for the element the third point is connected to. Can be empty and will be ignored for Distance Dimensions and Annotations.
            obj.AddToHistory(['.SetConnectedElement3 "', num2str(name, '%.15g'), '"']);
        end
        function SetPointRotation(obj, rotation)
            % Indicator for Angular dimensions which picked point should be used as center point.
            obj.AddToHistory(['.SetPointRotation "', num2str(rotation, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the dimension with the previously made settings.
            obj.AddToHistory(['.Create']);

            % Prepend With Dimension and append End With
            obj.history = [ 'With Dimension', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Dimension'], obj.history);
            obj.history = [];
        end
        function RemoveDimension(obj, id)
            % Deletes the specified dimension. The ID need to be a positive integer value but can contain a valid expression.
            obj.project.AddToHistory(['Dimension.RemoveDimension "', num2str(id, '%.15g'), '"']);
        end
        function ChangeDimensionDistance(obj, id, distance)
            % Changes the distance of the specified dimension. The id need to be an integer value and the distance a double value but both can contain a valid expression.
            obj.project.AddToHistory(['Dimension.ChangeDimensionDistance "', num2str(id, '%.15g'), '", '...
                                                                        '"', num2str(distance, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hDimension
        history

    end
end

%% Default Settings
% UsePicks(true)
% SetID('0');
% SetDistance('1.0');
% SetViewVector('0.0', '1.0', '0.0');

%% Example - Taken from CST documentation and translated to MATLAB.
% dimension = project.Dimension();
%     dimension.UsePicks 1
%     dimension.SetID('1');
%     dimension.SetDistance('2.0');
%     dimension.SetViewVector('-1.0', '0', '0');
%     dimension.SetLabelPattern('%v%e');
%     dimension.Create
