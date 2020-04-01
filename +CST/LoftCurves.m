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

% This object enables a loft operation on a several number of curve items. A plane is fitted over the items comparable with some kind of stretched skin. The resulting structure can be created as a hollow or solid shape. As soon as the new shape is created it will appear in the main plot window and on the Navigation Tree. Note: All profile curves and the path curve must be located on different curves.
classdef LoftCurves < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.LoftCurves object.
        function obj = LoftCurves(project, hProject)
            obj.project = project;
            obj.hLoftCurves = hProject.invoke('LoftCurves');
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
        function Solid(obj, value)
            % Set this option to create a solid shape by covering the two ends of the lofted free form surface. Otherwise the resulting shape is a single free face only.
            obj.AddToHistory(['.Solid "', num2str(value, '%.15g'), '"']);
        end
        function MinimizeTwist(obj, value)
            % Set this option to automatically minimize the twisting of the resulting shape. If this option is true, the corresponding points on circles and ellipses will be adjusted such that the generated free form surface is not twisted at all. This option is only useful for lofts between circles and ellipses.
            obj.AddToHistory(['.MinimizeTwist "', num2str(value, '%.15g'), '"']);
        end
        function Path(obj, pathname)
            % Specifies a curve item which will serve as a path for the loft operation. The correct format for the name should be 'curvename:curveitemname' (see the example below). If the curve item (e.g. a line) is connected with an other curve item (e.g. a polygon) both curve items will be used as path.
            obj.AddToHistory(['.Path "', num2str(pathname, '%.15g'), '"']);
        end
        function AddCurve(obj, curvename)
            % Adds a curve item to the internal list for the later performed loft operation. The correct format for the name should be 'curvename:curveitemname' (see the example below). If the curve item (e.g. a line) is connected with an other curve item (e.g. a polygon) both curve items will be swept along the path.
            obj.AddToHistory(['.AddCurve "', num2str(curvename, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new solid. All necessary settings for this solid have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With LoftCurves and append End With
            obj.history = [ 'With LoftCurves', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define LoftCurves: ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hLoftCurves
        history

        name
        component
    end
end

%% Default Settings
% Material('Vacuum');
% Solid(0)
% MinimizeTwist(0);

%% Example - Taken from CST documentation and translated to MATLAB.
% loftcurves = project.LoftCurves();
%     loftcurves.Reset
%     loftcurves.Name('solid1');
%     loftcurves.Component('component1');
%     loftcurves.Material('Vacuum');
%     loftcurves.Solid('1');
%     loftcurves.MinimizeTwist('1');
%     loftcurves.Path('curve1:polygon1');
%     loftcurves.AddCurve('curve1:circle1');
%     loftcurves.AddCurve('curve1:rectangle1');
%     loftcurves.Create
