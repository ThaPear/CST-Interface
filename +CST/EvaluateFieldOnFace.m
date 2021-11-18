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
% Warning: Untested

% Evaluate a field, previously selected in the Navigation Tree, on a specified face.
classdef EvaluateFieldOnFace < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a EvaluateFieldOnFace object.
        function obj = EvaluateFieldOnFace(project, hProject)
            obj.project = project;
            obj.hEvaluateFieldOnFace = hProject.invoke('EvaluateFieldOnFace');
        end
    end
    %% CST Object functions.
    methods
        function [dIntReal, dIntImag, dArea] = IntegrateField(obj, facename, component)
            % Integrates the real and imaginary part of the selected field component / absolute value over the face named by sFaceName. The integrals and the area of the face are returned in the double variables dIntReal, dIntImag and dArea.
            % component,: 'x'
            %             'y'
            %             'z'
            %             'abs'
            %             'normal'
            functionString = [...
                'Dim dIntReal As Double, dIntImag As Double, dArea As Double', newline, ...
                'EvaluateFieldAlongCurve.IntegrateField("', facename, '", "', component, '", dIntReal, dIntImag, dArea)', newline, ...
            ];
            returnvalues = {'dIntReal', 'dIntImag', 'dArea'};
            [dIntReal, dIntImag, dArea] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            dIntReal = str2double(dIntReal);
            dIntImag = str2double(dIntImag);
            dArea = str2double(dArea);
        end
        function double = GetValue(obj, key)
            % Returns the double value of max/min and their position depending on the key "max", "min", "max x", "max y", "max z", "min x", "min y", "min z".
            double = obj.hEvaluateFieldOnFace.invoke('GetValue', key);
        end
        function EvaluateOnSurface(obj, boolean)
            % If switch is set to True, the field is evaluated on the nearest surface to the curve path, disregarding volume results. This can be used to avoid zero result values, if the curve path is defined on a surface bordering a volume without field results (e.g. PEC).
            obj.hEvaluateFieldOnFace.invoke('EvaluateOnSurface', boolean);
        end
        function FitToGrid(obj, boolean)
            % If switch is set to True, the face is mapped on the underlying grid. All field components on this staircase surface are taken into account then. Be aware that this also might increase the area returned. This feature is only available for hexahedral meshes, but is active by default then.
            obj.hEvaluateFieldOnFace.invoke('FitToGrid', boolean);
        end
        %% CST 2020 Functions.
        function [dIntReal, dIntImag, dArea] = CalculateIntegral(obj, facename, component, complexType)
            % Integrates the selected field component / absolute value depending on the chosen complex type over the face named by sFaceName. The integrals are returned in the double variables dIntReal and dIntImag. Scalar results returned in the dIntReal variable and dIntImag is set to zero. Alone for the complex type "complex", the dIntImag variable is set accordingly. The size of the face is returned in the dArea variable.
            % component,: 'x'
            %             'y'
            %             'z'
            %             'abs'
            %             'normal'
            % complexType,: 'real'
            %               'imaginary'
            %               'magnitude'
            %               'phase'
            %               'complex'
            functionString = [...
                'Dim dIntReal As Double, dIntImag As Double, dArea As Double', newline, ...
                'EvaluateFieldOnFace.CalculateIntegral("', facename, '", "', component, '", "', complexType, '", dIntReal, dIntImag, dArea)', newline, ...
            ];
            returnvalues = {'dIntReal', 'dIntImag', 'dArea'};
            [dIntReal, dIntImag, dArea] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            dIntReal = str2double(dIntReal);
            dIntImag = str2double(dIntImag);
            dArea = str2double(dArea);
        end
        %% Mislabeled functions in documentation.
        function CalulateIntegral(obj, facename, component, complexType)
            ric = matlab.lang.correction.ReplaceIdentifierCorrection('CalulateIntegral', 'CalculateIntegral');
            error(ric, 'This function is mislabeled in the CST documentation, please use the proper function ''CalculateIntegral''.');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hEvaluateFieldOnFace

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% % NOTE: This example does not work due to the fact that IntegrateField is not implemented.
% Dim dIntReal as Double, dIntImag as Double
% Dim dArea, dMax As Double
% evaluatefieldonface = project.EvaluateFieldOnFace();
%     evaluatefieldonface.IntegrateField('face1', 'normal', dIntReal, dIntImag, dArea)
% dMax = EvaluateFieldOnFace.GetValue('max');
% MsgBox Str$(dIntReal)+');+i('+Str$(dIntImag)+'); A=');+Str$(dArea)+'); max=');+Str$(dMax)
%
