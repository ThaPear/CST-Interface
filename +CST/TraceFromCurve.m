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

% This object is used to create a new shape from a curve item. You can cover a previously defined curve item (closed or open) with arbitrary thickness and width. After that operation the curve item will not exist any longer.
classdef TraceFromCurve < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TraceFromCurve object.
        function obj = TraceFromCurve(project, hProject)
            obj.project = project;
            obj.hTraceFromCurve = hProject.invoke('TraceFromCurve');
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
            obj.component = [];
        end
        function Name(obj, solidname)
            % Sets the name of the new solid.
            obj.AddToHistory(['.Name "', num2str(solidname, '%.15g'), '"']);
            obj.name = solidname;
        end
        function Component(obj, componentname)
            % Sets the name of the component for the new solid. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
            obj.component = componentname;
        end
        function Material(obj, materialname)
            % Sets the material name for the new solid. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function Curve(obj, curvename)
            % The name of the curve item the new solid should be created. The correct format for the name should be 'curvename:curveitemname' (see the example below). If the curve item (e.g. a line) is connected with an other curve item (e.g. a polygon) both curve items will be transformed into the new solid.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
        end
        function Thickness(obj, thicknessvalue)
            % Sets the thickness of the trace. The thickness is along the z-axis in the global coordinate system and along the w-axis in the local coordinate system. Negative thickness settings will result in an extrusion into the opposite direction.
            obj.AddToHistory(['.Thickness "', num2str(thicknessvalue, '%.15g'), '"']);
        end
        function Width(obj, widthvalue)
            % Sets the width of the trace. The width is perpendicular to the thickness.
            obj.AddToHistory(['.Width "', num2str(widthvalue, '%.15g'), '"']);
        end
        function RoundStart(obj, makestartround)
            % Specifies if the first end of the new solid should be drawn rounded or not. Constraint: the curve must be open, otherwise this flag will be ignored.
            obj.AddToHistory(['.RoundStart "', num2str(makestartround, '%.15g'), '"']);
        end
        function RoundEnd(obj, makeendround)
            % Specifies if the second end of the new solid should be drawn rounded or not. Constraint: the curve must be open, otherwise this flag will be ignored.
            obj.AddToHistory(['.RoundEnd "', num2str(makeendround, '%.15g'), '"']);
        end
        function GapType(obj, type)
            % Specifies the behavior of the creating solid on inflexion points of the curve. Possible values: 0 = rounded like arcs, 1 = extended like lines and 2 = natural like curve extensions.
            obj.AddToHistory(['.GapType "', num2str(type, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new solid. All necessary settings for this solid have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With TraceFromCurve and append End With
            obj.history = [ 'With TraceFromCurve', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define TraceFromCurve: ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end
        %% Undocumented functions.
        function DeleteCurve(obj, boolean)
            % Delete the curve after the trace is formed.
            obj.AddToHistory(['.DeleteCurve "', num2str(boolean, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTraceFromCurve
        history

        name
        component
    end
end

%% Default Settings
% Material('Vacuum');
% Thickness(0.0)
% Width(0.0)
% RoundStart(0)
% RoundEnd(0)
% GapType(2)

%% Example - Taken from CST documentation and translated to MATLAB.
% tracefromcurve = project.TraceFromCurve();
%     tracefromcurve.Reset
%     tracefromcurve.Name('solid1');
%     tracefromcurve.Component('component1');
%     tracefromcurve.Material('Vacuum');
%     tracefromcurve.Curve('curve1:polygon1');
%     tracefromcurve.Thickness('1.5');
%     tracefromcurve.Width('4');
%     tracefromcurve.RoundStart('1');
%     tracefromcurve.RoundEnd('0');
%     tracefromcurve.GapType('2');
%     tracefromcurve.Create
