%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Warning: Untested                                                   %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Evaluate a field, previously selected in the Navigation Tree, on a specified face.
classdef EvaluateFieldOnFace < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a EvaluateFieldOnFace object.
        function obj = EvaluateFieldOnFace(project, hProject)
            obj.project = project;
            obj.hEvaluateFieldOnFace = hProject.invoke('EvaluateFieldOnFace');
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
            % Prepend With EvaluateFieldOnFace and append End With
            obj.history = [ 'With EvaluateFieldOnFace', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define EvaluateFieldOnFace settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['EvaluateFieldOnFace', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function IntegrateField(obj, sFaceName, component, dIntReal, dIntImag, dArea)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''IntegrateField''.');
            return;
            % Integrates the real and imaginary part of the selected field component / absolute value over the face named by sFaceName. The integrals and the area of the face are returned in the double variables dIntReal, dIntImag and dArea.
            % component,: 'x'
            %             'y'
            %             'z'
            %             'abs'
            %             'normal'
            obj.AddToHistory(['.IntegrateField "', num2str(sFaceName, '%.15g'), '", '...
                                              '"', num2str(component, '%.15g'), '", '...
                                              '"', num2str(dIntReal, '%.15g'), '", '...
                                              '"', num2str(dIntImag, '%.15g'), '", '...
                                              '"', num2str(dArea, '%.15g'), '"']);
            obj.integratefield.sFaceName = sFaceName;
            obj.integratefield.component = component;
            obj.integratefield.dIntReal = dIntReal;
            obj.integratefield.dIntImag = dIntImag;
            obj.integratefield.dArea = dArea;
        end
        function double = GetValue(obj, key)
            % Returns the double value of max/min and their position depending on the key "max", "min", "max x", "max y", "max z", "min x", "min y", "min z".
            double = obj.hEvaluateFieldOnFace.invoke('GetValue', key);
            obj.getvalue = key;
        end
        function EvaluateOnSurface(obj, boolean)
            % If switch is set to True, the field is evaluated on the nearest surface to the curve path, disregarding volume results. This can be used to avoid zero result values, if the curve path is defined on a surface bordering a volume without field results (e.g. PEC).
            obj.AddToHistory(['.EvaluateOnSurface "', num2str(boolean, '%.15g'), '"']);
            obj.evaluateonsurface = boolean;
        end
        function FitToGrid(obj, boolean)
            % If switch is set to True, the face is mapped on the underlying grid. All field components on this staircase surface are taken into account then. Be aware that this also might increase the area returned. This feature is only available for hexahedral meshes, but is active by default then.
            obj.AddToHistory(['.FitToGrid "', num2str(boolean, '%.15g'), '"']);
            obj.fittogrid = boolean;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hEvaluateFieldOnFace
        history
        bulkmode

        integratefield
        getvalue
        evaluateonsurface
        fittogrid
    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% Dim dIntReal as Double, dIntImag as Double
% Dim dArea, dMax As Double
% evaluatefieldonface = project.EvaluateFieldOnFace();
%     evaluatefieldonface.IntegrateField('face1', 'normal', dIntReal, dIntImag, dArea)
% dMax = EvaluateFieldOnFace.GetValue('max');
% MsgBox Str$(dIntReal)+');+i('+Str$(dIntImag)+'); A=');+Str$(dArea)+'); max=');+Str$(dMax)
% 
