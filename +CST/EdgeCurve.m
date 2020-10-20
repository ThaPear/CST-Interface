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

% This object enables the creation of a new curve item from previously picked edges. The newly created item will become a copy of the picked edges. A new item will be assigned to a previously defined curve. Thus the corresponding menu or toolbar items will only be active if at least one curve has been defined before (Modeling: Curves > Curves  ) and an edge has been previously picked from within the structure.
classdef EdgeCurve < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.EdgeCurve object.
        function obj = EdgeCurve(project, hProject)
            obj.project = project;
            obj.hEdgeCurve = hProject.invoke('EdgeCurve');
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
        function Name(obj, curveitemname)
            % Sets the name of the new curve item.
            obj.AddToHistory(['.Name "', num2str(curveitemname, '%.15g'), '"']);
            obj.name = curveitemname;
        end
        function Curve(obj, curvename)
            % Specifies the curve to which the new curve item will belong to.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
            obj.curve = curvename;
        end
        function AddEdge(obj, solidname, edgeid)
            % Specifies an edge which will be added to a certain curve item. The edge is determined by the solid shape it belongs and its identity number.
            obj.AddToHistory(['.AddEdge "', num2str(solidname, '%.15g'), '", '...
                                       '"', num2str(edgeid, '%.15g'), '"']);
        end
        function Create(obj)
            % Executes the EdgeCurve operation due to the previously made settings.
            obj.AddToHistory(['.Create']);

            % Prepend With EdgeCurve and append End With
            obj.history = [ 'With EdgeCurve', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define EdgeCurve: ', obj.curve, ':', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hEdgeCurve
        history

        name
        curve
    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% edgecurve = project.EdgeCurve();
%     edgecurve.Reset
%     edgecurve.Name('edges1');
%     edgecurve.Curve('curve1');
%     edgecurve.AddEdge('component1:solid2', '2');
%     edgecurve.AddEdge('component1:solid1', '2');
%     edgecurve.AddEdge('component1:solid1', '1');
%     edgecurve.Create
