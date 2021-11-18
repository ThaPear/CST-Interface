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

% This object is used to create a new analytical face shape.
classdef AnalyticalFace < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.AnalyticalFace object.
        function obj = AnalyticalFace(project, hProject)
            obj.project = project;
            obj.hAnalyticalFace = hProject.invoke('AnalyticalFace');
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
        function Name(obj, analyticalfacename)
            % Sets the name of the analytical face.
            obj.AddToHistory(['.Name "', num2str(analyticalfacename, '%.15g'), '"']);
            obj.name = analyticalfacename;
        end
        function Component(obj, componentname)
            % Sets the name of the component for the new analytical. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
            obj.component = componentname;
        end
        function Material(obj, materialname)
            % Sets the material name for the new analytical face. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function LawX(obj, xlaw)
            % Sets the analytical function defining the x-coordinates for the analytical face dependent on the parameters u, and v.
            obj.AddToHistory(['.LawX "', num2str(xlaw, '%.15g'), '"']);
        end
        function LawY(obj, ylaw)
            % Sets the analytical function defining the y-coordinates for the analytical face dependent on the parameters u, and v.
            obj.AddToHistory(['.LawY "', num2str(ylaw, '%.15g'), '"']);
        end
        function LawZ(obj, zlaw)
            % Sets the analytical function defining the z-coordinates for the analytical face dependent on the parameters u, and v.
            obj.AddToHistory(['.LawZ "', num2str(zlaw, '%.15g'), '"']);
        end
        function ParameterRangeU(obj, umin, umax)
            % Sets the bounds for the parameter u.
            obj.AddToHistory(['.ParameterRangeU "', num2str(umin, '%.15g'), '", '...
                                               '"', num2str(umax, '%.15g'), '"']);
        end
        function ParameterRangeV(obj, vmin, vmax)
            % Sets the bounds for the parameter v.
            obj.AddToHistory(['.ParameterRangeV "', num2str(vmin, '%.15g'), '", '...
                                               '"', num2str(vmax, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new analytical face. All necessary settings for this analytical face have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With AnalyticalFace and append End With
            obj.history = [ 'With AnalyticalFace', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define AnalyticalFace: ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end
        %% Mislabeled functions in documentation.
        function ParamerRangeU(obj, umin, umax)
            ric = matlab.lang.correction.ReplaceIdentifierCorrection('ParamerRangeU', 'ParameterRangeU');
            error(ric, 'This function is mislabeled in the CST documentation, please use the proper function ''ParameterRangeU''.');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hAnalyticalFace
        history

        name
        component
    end
end

%% Default Settings
% Material('Vacuum');
% LawX(0)
% LawY(0)
% LawZ(0)
% ParameterRangeU(0, 1)
% ParameterRangeV(0, 1)

%% Example - Taken from CST documentation and translated to MATLAB.
% analyticalface = project.AnalyticalFace();
%     analyticalface.Reset
%     analyticalface.Name('solid1');
%     analyticalface.Component('component1');
%     analyticalface.Material('PEC');
%     analyticalface.LawX('cos(u) * sin(v)');
%     analyticalface.LawY('u');
%     analyticalface.LawZ('v');
%     analyticalface.ParameterRangeU('0', '2*pi');
%     analyticalface.ParameterRangeV('0', '2*pi');
%     analyticalface.Create
