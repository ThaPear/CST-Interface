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

% This object is used to apply operations on curves and curve items.
classdef Curve < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Curve object.
        function obj = Curve(project, hProject)
            obj.project = project;
            obj.hCurve = hProject.invoke('Curve');
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
            % Prepend With Curve and append End With
            obj.history = [ 'With Curve', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Curve settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['Curve', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function NewCurve(obj, curvename)
            % Defines and names a new curve object.
            obj.AddToHistory(['.NewCurve "', num2str(curvename, '%.15g'), '"']);
        end
        function DeleteCurve(obj, curvename)
            % Deletes a specified curve object.
            obj.AddToHistory(['.DeleteCurve "', num2str(curvename, '%.15g'), '"']);
        end
        function RenameCurve(obj, oldname, newname)
            % Renames a specified curve object.
            obj.AddToHistory(['.RenameCurve "', num2str(oldname, '%.15g'), '", '...
                                           '"', num2str(newname, '%.15g'), '"']);
        end
        function DeleteCurveItem(obj, curvename, curveitemname)
            % Deletes a specified item object associated to a curve object.
            obj.AddToHistory(['.DeleteCurveItem "', num2str(curvename, '%.15g'), '", '...
                                               '"', num2str(curveitemname, '%.15g'), '"']);
        end
        function RenameCurveItem(obj, curvename, oldcurveitemname, newcurveitemname)
            % Renames a specified item object associated to a curve object.
            obj.AddToHistory(['.RenameCurveItem "', num2str(curvename, '%.15g'), '", '...
                                               '"', num2str(oldcurveitemname, '%.15g'), '", '...
                                               '"', num2str(newcurveitemname, '%.15g'), '"']);
        end
        function DeleteCurveItemSegment(obj, curvename, curveitemname, edgeid)
            % Deletes a segment of an item object associated to a curve object. The segment is specified by the name of the curve and the item that it belongs as well as an identity number.
            obj.AddToHistory(['.DeleteCurveItemSegment "', num2str(curvename, '%.15g'), '", '...
                                                      '"', num2str(curveitemname, '%.15g'), '", '...
                                                      '"', num2str(edgeid, '%.15g'), '"']);
        end
        function MoveCurveItem(obj, curveitemname, oldcurvename, newcurvename)
            % Moves a specified item from the curve it belongs to another curve object.
            obj.AddToHistory(['.MoveCurveItem "', num2str(curveitemname, '%.15g'), '", '...
                                             '"', num2str(oldcurvename, '%.15g'), '", '...
                                             '"', num2str(newcurvename, '%.15g'), '"']);
        end
        function long = StartCurveNameIteration(obj, type)
            % Start iterating over the curves:
            % "all"
            % All curves
            % "open"
            % Only the open curves
            % "closed"
            % Only the closed curves
            long = obj.hCurve.invoke('StartCurveNameIteration', type);
        end
        function name = GetNextCurveName(obj)
            % Returns the next curve name. Use StartCurveNameIteration to start the iteration.
            name = obj.hCurve.invoke('GetNextCurveName');
        end
        function [bool, x, y, z] = GetPointCoordinates(obj, curveitemname, pid)
            % Retrieves the coordinates of the point with the given pid. Returns false if there is no such point.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim x As Double, y As Double, z As Double', newline, ...
                'bool = Curve.GetPointCoordinates("', curveitemname, '", "', num2str(pid, '%.15g'), '", x, y, z)', newline, ...
            ];
            returnvalues = {'bool', 'x', 'y', 'z'};
            [bool, x, y, z] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            x = str2double(x);
            y = str2double(y);
            z = str2double(z);
        end
        function int = GetNumberOfPoints(obj, curveitemname)
            % Returns the maximum number of points.
            int = obj.hCurve.invoke('GetNumberOfPoints', curveitemname);
        end
        function bool = IsClosed(obj, curveitemname)
            % Returns whether it is a closed curve or not.
            bool = obj.hCurve.invoke('IsClosed', curveitemname);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCurve
        history
        bulkmode

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% curve = project.Curve();
%     curve.RenameCurve('curve1', 'MyCurves');
%     curve.DeleteCurveItemSegment('curve1', 'rectangle1', '1');
