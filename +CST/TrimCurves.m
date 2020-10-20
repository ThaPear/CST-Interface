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

% This object enables a trim operation on two intersecting curve items. The points of intersection create new segments respectively edges which afterwards can be deleted separately.
classdef TrimCurves < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TrimCurves object.
        function obj = TrimCurves(project, hProject)
            obj.project = project;
            obj.hTrimCurves = hProject.invoke('TrimCurves');
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
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function Curve(obj, curvename)
            % Specifies the curve to which both of the selected curve items are belonging to
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
        end
        function CurveItem1(obj, curveitemname)
            % Selects a specified curve item which has to belong to the same curve object as curve item No.2.
            obj.AddToHistory(['.CurveItem1 "', num2str(curveitemname, '%.15g'), '"']);
        end
        function CurveItem2(obj, curveitemname)
            % Selects a specified curve item which has to belong to the same curve object as curve item No.1.
            obj.AddToHistory(['.CurveItem2 "', num2str(curveitemname, '%.15g'), '"']);
        end
        function DeleteEdges1(obj, edgeids)
            % Defines the list of edges associated with curve item No.1, which will be deleted applying the Trim method. More than one indices must be separated by ", ".
            obj.AddToHistory(['.DeleteEdges1 "', num2str(edgeids, '%.15g'), '"']);
        end
        function DeleteEdges2(obj, edgeids)
            % Defines the list of edges associated with curve item No.2, which will be deleted applying the Trim method. More than one indices must be separated by ", ".
            obj.AddToHistory(['.DeleteEdges2 "', num2str(edgeids, '%.15g'), '"']);
        end
        function Trim(obj)
            % Executes the trim operation due to the previously made settings.
            obj.AddToHistory(['.Trim']);

            % Prepend With TrimCurves and append End With
            obj.history = [ 'With TrimCurves', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define TrimCurves'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTrimCurves
        history

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% trimcurves = project.TrimCurves();
%   .Reset
%   .Curve('curve1');
%   .CurveItem1('rectangle1');
%   .CurveItem2('polygon1');
%   .DeleteEdges1('2');
%   .DeleteEdges2('5,2');
%   .Trim
