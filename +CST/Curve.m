%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object is used to apply operations on curves and curve items.
classdef Curve < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Curve object.
        function obj = Curve(project, hProject)
            obj.project = project;
            obj.hCurve = hProject.invoke('Curve');
        end
    end
    %% CST Object functions.
    methods
        function NewCurve(obj, curvename)
            % Defines and names a new curve object.
            obj.hCurve.invoke(['NewCurve "', num2str(curvename, '%.15g'), '"']);
        end
        function DeleteCurve(obj, curvename)
            % Deletes a specified curve object.
            obj.hCurve.invoke(['DeleteCurve "', num2str(curvename, '%.15g'), '"']);
        end
        function RenameCurve(obj, oldname, newname)
            % Renames a specified curve object.
            obj.hCurve.invoke(['RenameCurve "', num2str(oldname, '%.15g'), '", '...
                                           '"', num2str(newname, '%.15g'), '"']);
        end
        function DeleteCurveItem(obj, curvename, curveitemname)
            % Deletes a specified item object associated to a curve object.
            obj.hCurve.invoke(['DeleteCurveItem "', num2str(curvename, '%.15g'), '", '...
                                               '"', num2str(curveitemname, '%.15g'), '"']);
        end
        function RenameCurveItem(obj, curvename, oldcurveitemname, newcurveitemname)
            % Renames a specified item object associated to a curve object.
            obj.hCurve.invoke(['RenameCurveItem "', num2str(curvename, '%.15g'), '", '...
                                               '"', num2str(oldcurveitemname, '%.15g'), '", '...
                                               '"', num2str(newcurveitemname, '%.15g'), '"']);
        end
        function DeleteCurveItemSegment(obj, curvename, curveitemname, edgeid)
            % Deletes a segment of an item object associated to a curve object. The segment is specified by the name of the curve and the item that it belongs as well as an identity number.
            obj.hCurve.invoke(['DeleteCurveItemSegment "', num2str(curvename, '%.15g'), '", '...
                                                      '"', num2str(curveitemname, '%.15g'), '", '...
                                                      '"', num2str(edgeid, '%.15g'), '"']);
        end
        function MoveCurveItem(obj, curveitemname, oldcurvename, newcurvename)
            % Moves a specified item from the curve it belongs to another curve object.
            obj.hCurve.invoke(['MoveCurveItem "', num2str(curveitemname, '%.15g'), '", '...
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
            long = obj.hCurve.invoke(['StartCurveNameIteration "', num2str(type, '%.15g'), '"']);
        end
        function name = GetNextCurveName(obj)
            % Returns the next curve name. Use StartCurveNameIteration to start the iteration.
            name = obj.hCurve.invoke(['GetNextCurveName']);
        end
        function [bool, x, y, z] = GetPointCoordinates(obj, curveitemname, pid)
            % Retrieves the coordinates of the point with the given pid. Returns false if there is no such point.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim x As Double, y As Double, z As Double', newline, ...
                'bool = Curve.GetPointCoordinates(', curveitemname, ', ', pid, ', x, y, z)', newline, ...
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
            int = obj.hCurve.invoke(['GetNumberOfPoints "', num2str(curveitemname, '%.15g'), '"']);
        end
        function bool = IsClosed(obj, curveitemname)
            % Returns whether it is a closed curve or not.
            bool = obj.hCurve.invoke(['IsClosed "', num2str(curveitemname, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCurve
        history

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% curve = project.Curve()
%     curve.RenameCurve('curve1', 'MyCurves');
%     curve.DeleteCurveItemSegment('curve1', 'rectangle1', '1');
