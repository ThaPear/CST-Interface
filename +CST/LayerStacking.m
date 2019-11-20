%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%% Warning: Untested                                                   %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The layerstacking object can be used to define one or more background items to the project. The specified layers differ in thickness and material and are aligned at the borders of the bounding box.
classdef LayerStacking < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a LayerStacking object.
        function obj = LayerStacking(project, hProject)
            obj.project = project;
            obj.hLayerStacking = hProject.invoke('LayerStacking');
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
            % Resets all internal values to their default settings.
            obj.AddToHistory(['.Reset']);
        end
        function LayerStackingActive(obj, flag)
            % Identifies the activation state of the layer stacking feature.
            obj.AddToHistory(['.LayerStackingActive "', num2str(flag, '%.15g'), '"']);
            obj.layerstackingactive = flag;
        end
        function AlignValueBackgroundItems(obj, value)
            % Defines the value all layers are aligned on. Usually on the bottom line of the lowest layer. But also layers with negative thickness can be defined below the align value.
            obj.AddToHistory(['.AlignValueBackgroundItems "', num2str(value, '%.15g'), '"']);
            obj.alignvaluebackgrounditems = value;
        end
        function NormalBackgroundItems(obj, direction)
            % Sets the normal axis of the background items .
            % direction: 'x'
            %            'y'
            %            'z'
            obj.AddToHistory(['.NormalBackgroundItems "', num2str(direction, '%.15g'), '"']);
            obj.normalbackgrounditems = direction;
        end
        function InvertDirection(obj, flag)
            % Identifies if the layer stacking is aligned at positive or negative normal direction.
            obj.AddToHistory(['.InvertDirection "', num2str(flag, '%.15g'), '"']);
            obj.invertdirection = flag;
        end
        function FixTransversal(obj, flag)
            % Identifies if the layer stacking should be fixed with the actual transversal measurements.
            obj.AddToHistory(['.FixTransversal "', num2str(flag, '%.15g'), '"']);
            obj.fixtransversal = flag;
        end
        function AddItem(obj, index, thickness, materialname)
            % Adds a new background layer to the model. Index defines the order of the layer stacking items. Positive thickness is in positive direction of the normal beginning at the align value. Vice versa for negative thickness. Materialname defines the material the background item consist of. The material must already exist.
            obj.AddToHistory(['.AddItem "', num2str(index, '%.15g'), '", '...
                                       '"', num2str(thickness, '%.15g'), '", '...
                                       '"', num2str(materialname, '%.15g'), '"']);
            obj.additem.index = index;
            obj.additem.thickness = thickness;
            obj.additem.materialname = materialname;
        end
        function Create(obj)
            % Creates the background items. All necessary settings for the layers have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With LayerStacking and append End With
            obj.history = [ 'With LayerStacking', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define LayerStacking'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hLayerStacking
        history

        layerstackingactive
        alignvaluebackgrounditems
        normalbackgrounditems
        invertdirection
        fixtransversal
        additem
    end
end

%% Default Settings
% MinValueBackgroundItems(0.0)
% NormalBackgroundItems('z');

%% Example - Taken from CST documentation and translated to MATLAB.
% layerstacking = project.LayerStacking();
%     layerstacking.Reset
%     layerstacking.LayerStackingActive(1)
%     layerstacking.MinValueBackgroundItems(-2.0)
%     layerstacking.NormalBackgroundItems('y');
%     layerstacking.InvertDirection('1');
%     layerstacking.FixTransversal('0');
%     layerstacking.AddItem( 1, 1, 'Vacuum'); )
%     layerstacking.AddItem( 2, 0.5, 'PEC'); )
%     layerstacking.Create
