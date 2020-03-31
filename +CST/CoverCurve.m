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

% This object is used to cover a planar curve with a sheet in order to create a shape from a curve. The created shape is a single face and thus not a valid solid. Constraint: The curve must be closed and planar.
classdef CoverCurve < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.CoverCurve object.
        function obj = CoverCurve(project, hProject)
            obj.project = project;
            obj.hCoverCurve = hProject.invoke('CoverCurve');
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
        function Name(obj, solidname)
            % Sets the name of the new sheet solid.
            obj.AddToHistory(['.Name "', num2str(solidname, '%.15g'), '"']);
            obj.name = solidname;
        end
        function Component(obj, componentname)
            % Sets the name of the component for the new sheet solid. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
            obj.component = componentname;
        end
        function Material(obj, materialname)
            % Sets the material name for the new sheet solid. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function Curve(obj, curvename)
            % The name of the curve item the new solid should be created. The correct format for the name should be 'curvename:curveitemname' (see the example below). If the curve item (e.g. a line) is connected with an other curve item (e.g. a polygon) both curve items will be transformed into the new sheet solid.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new sheet solid. All necessary settings for this sheet solid have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With CoverCurve and append End With
            obj.history = [ 'With CoverCurve', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define CoverCurve: ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCoverCurve
        history

        name
        component
    end
end

%% Default Settings
% Material('Vacuum');

%% Example - Taken from CST documentation and translated to MATLAB.
% covercurve = project.CoverCurve();
%     covercurve.Reset
%     covercurve.Name('solid1');
%     covercurve.Component('component1');
%     covercurve.Material('Vacuum');
%     covercurve.Curve('curve1:polygon1');
%     covercurve.Create
