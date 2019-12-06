%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  
classdef ConnectionLabel < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.DS.Project)
        % Only CST.DS.Project can create a ConnectionLabel object.
        function obj = ConnectionLabel(dsproject, hDSProject)
            obj.dsproject = dsproject;
            obj.hConnectionLabel = hDSProject.invoke('ConnectionLabel');
        end
    end
    %% CST Object functions.
    methods
        %% General Methods
        function Create(obj)
            % Creates a new connection label with the current settings. The new label will use the text of the last created connection label if the label text has not been set. If the name has not been set a new name will be generated automatically.
            obj.hConnectionLabel.invoke('Create');
        end
        function Delete(obj)
            % Deletes the currently selected connection label.
            obj.hConnectionLabel.invoke('Delete');
        end
        function bool = DoesExist(obj)
            % Checks if a connection label with the currently selected name already exists.
            bool = obj.hConnectionLabel.invoke('DoesExist');
        end
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.hConnectionLabel.invoke('Reset');
        end
        %% Identification
        function Name(obj, labelname)
            % Sets the name of a connection label before calling Create. Furthermore, this method can be used to select an existing connection label of your model prior of calling queries.
            obj.hConnectionLabel.invoke('Name', labelname);
        end
        %% Getter
        function string = GetLabel(obj)
            % Returns the label text of the currently selected connection label.
            string = obj.hConnectionLabel.invoke('GetLabel');
        end
        %% Setter
        function SetName(obj, labelname)
            % Modifies the name of the currently selected connection labe.
            obj.hConnectionLabel.invoke('SetName', labelname);
        end
        function SetLabel(obj, label)
            % Sets the label text of the currently selected connection label.
            obj.hConnectionLabel.invoke('SetLabel', label);
        end
        %% Iteration
        function int = StartConnectionLabelNameIteration(obj)
            % Resets the iterator for the connection labels and returns the number of connection labels.
            int = obj.hConnectionLabel.invoke('StartConnectionLabelNameIteration');
        end
        function name = GetNextConnectionLabelName(obj)
            % Returns the next connection label's name. Call StartConnectionLabelNameIteration before the first call of this method.
            name = obj.hConnectionLabel.invoke('GetNextConnectionLabelName');
        end
        %% Positioning
        function Position(obj, x, y)
            % Specifies the position of the connection label. This setting must be made before calling Create. Furthermore, it can be used to modify a connection label's position. Possible values are 0 < x, y <100000, i.e. (50000, 50000) is the center of the schematic. It is always ensured that the connection label is aligned with the grid, therefore the specified position might get adjusted slightly.
            obj.hConnectionLabel.invoke('Position', x, y);
        end
        function Move(obj, x, y)
            % Moves a connection label by the given offset. Note that the schematic size is given by 0 < x, y <100000. Use Position to specify a certain location. It is always ensured that the connection label is aligned with the grid, therefore the specified offset might get adjusted slightly. This setting must not be made before calling Create.
            obj.hConnectionLabel.invoke('Move', x, y);
        end
        function int = GetPositionX(obj)
            % Returns the horizontal position of the port of a connection label.
            int = obj.hConnectionLabel.invoke('GetPositionX');
        end
        function int = GetPositionY(obj)
            % Returns the vertical position of the port of a connection label.
            int = obj.hConnectionLabel.invoke('GetPositionY');
        end
        function Rotate(obj, angle)
            % Rotates the connection label by the given angle in degrees around its center point. If this setting is made before calling Create, the angle is only stored. The rotation will then be done in Create (after any horizontal or vertical flip was applied).
            obj.hConnectionLabel.invoke('Rotate', angle);
        end
        function FlipHorizontal(obj)
            % Horizontally flips a connection label. If this setting is made before calling Create, the flip is only stored. It will then be done in Create (before any rotation is applied).
            obj.hConnectionLabel.invoke('FlipHorizontal');
        end
        function FlipVertical(obj)
            % Vertically flips a connection label. If this setting is made before calling Create, the flip is only stored. It will then be done in Create (before any rotation is applied).
            obj.hConnectionLabel.invoke('FlipVertical');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hConnectionLabel

    end
end

%% Default Settings
% Position(50000, 50000)

%% Example - Taken from CST documentation and translated to MATLAB.
% %Create a new connection label
% 
% connectionlabel = dsproject.ConnectionLabel();
% .Reset
% .SetLabel('3.3V');
% .Position(52000, 51000)
% .Create
