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

% This object enables a chamfer operation on a curve item. The edge produced by two segments of the item will be cut to the specified width. If the width is chosen in a way that the structure would change significantly, the operation might not be possible. The chamfer operation will then modify the curve items connected to the selected point and create a new item which actually represents the chamfer. The chamfer item can be identified by an unique name, e.g. for subsequent editing operations.
classdef ChamferCurve < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ChamferCurve object.
        function obj = ChamferCurve(project, hProject)
            obj.project = project;
            obj.hChamferCurve = hProject.invoke('ChamferCurve');
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

            obj.name = [];
            obj.curve = [];
        end
        function Name(obj, chamfername)
            % Sets the name of the new chamfer item.
            obj.AddToHistory(['.Name "', num2str(chamfername, '%.15g'), '"']);
            obj.name = chamfername;
        end
        function Width(obj, widthvalue)
            % Specify a valid expression for the width of the chamfer.
            obj.AddToHistory(['.Width "', num2str(widthvalue, '%.15g'), '"']);
        end
        function Curve(obj, curvename)
            % Specifies the curve the new created chamfer item object will belong to.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
            obj.curve = curvename;
        end
        function CurveItem1(obj, curveitemname)
            % Selects a specified curve item which has to belong to the same curve object as curve item No.2.
            obj.AddToHistory(['.CurveItem1 "', num2str(curveitemname, '%.15g'), '"']);
        end
        function CurveItem2(obj, curveitemname)
            % Selects a specified curve item which has to belong to the same curve object as curve item No.1.
            obj.AddToHistory(['.CurveItem2 "', num2str(curveitemname, '%.15g'), '"']);
        end
        function EdgeId1(obj, edgeid1)
            % Defines a specified edge of a curve item by its identity number.
            obj.AddToHistory(['.EdgeId1 "', num2str(edgeid1, '%.15g'), '"']);
        end
        function EdgeId2(obj, edgeid2)
            % Defines a specified edge of a curve item by its identity number.
            obj.AddToHistory(['.EdgeId2 "', num2str(edgeid2, '%.15g'), '"']);
        end
        function VertexId1(obj, vertexid1)
            % Defines a specified vertex of a curve item by its identity number.
            obj.AddToHistory(['.VertexId1 "', num2str(vertexid1, '%.15g'), '"']);
        end
        function VertexId2(obj, vertexid2)
            % Defines a specified vertex of a curve item by its identity number.
            obj.AddToHistory(['.VertexId2 "', num2str(vertexid2, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new curve item. All necessary settings for it have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With ChamferCurve and append End With
            obj.history = [ 'With ChamferCurve', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ChamferCurve: ', obj.curve, ':', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hChamferCurve
        history

        name
        curve
    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% chamfercurve = project.ChamferCurve();
%   .Reset
%   .Name('chamfer1');
%   .Width('2');
%   .Curve('curve1');
%   .CurveItem1('rectangle1');
%   .CurveItem2('rectangle1');
%   .EdgeId1('2');
%   .EdgeId2('3');
%   .VertexId1('3');
%   .VertexId2('3');
%   .Create
