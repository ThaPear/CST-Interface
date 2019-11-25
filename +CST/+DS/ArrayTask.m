%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Object referring to an array task. Use this object to create or to manipulate an array task.
classdef ArrayTask < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.DS.Project)
        % Only CST.DS.Project can create a ArrayTask object.
        function obj = ArrayTask(dsproject, hDSProject)
            obj.dsproject = dsproject;
            obj.hArrayTask = hDSProject.invoke('ArrayTask');
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.hArrayTask.invoke('Reset');
        end
        function Name(obj, taskname)
            % Sets the name of a phased array antenna task before calling Create.
            obj.hArrayTask.invoke('Name', taskname);
        end
        function SetExcitationPattern(obj, pattern)
            % Sets the excitation pattern for the phased array antenna. Valid choices are: Uniform, Cosine, Cosine-Sq., Taylor, Binomial and Chebyshev
            obj.hArrayTask.invoke('SetExcitationPattern', pattern);
        end
        function SetShapeCustom(obj, elements_in_x, elements_in_y, spacing_in_x, spacing_in_y, grid_angle)
            % Sets the settings for creating a custom shape phased array antenna
            % elements_in_x: Specify the number of elements in the X direction.
            % elements_in_y: Specify the number of elements in the Y direction.
            % spacing_in_x: Specify the spacing in the X direction. This is the distance from an element's center to the center of an adjacent element in the X direction.
            % spacing_in_y: Specify the spacing in the Y direction. This is the distance from an element's center to the center of an adjacent element in the Y direction.
            % grid_angle: Specify the grid angle of the array.
            obj.hArrayTask.invoke('SetShapeCustom', elements_in_x, elements_in_y, spacing_in_x, spacing_in_y, grid_angle);
        end
        function SetShapeDiamond(obj, elements_in_a_side, spacing_in_x, spacing_in_y)
            % Sets the settings for creating a diamond shape phased array antenna
            % elements_in_a_side: Specify the number of elements in one side of the diamond.
            % spacing_in_x: Specify the spacing in the X direction. This is the distance from an element's center to the center of an adjacent element in the X direction.
            % spacing_in_y: Specify the spacing in the Y direction. This is the distance from an element's center to the center of an adjacent element in the Y direction.
            obj.hArrayTask.invoke('SetShapeDiamond', elements_in_a_side, spacing_in_x, spacing_in_y);
        end
        function SetShapeHexagonal(obj, elements_in_a_side, spacing_in_x, spacing_in_y)
            % Sets the settings for creating a hexagonal shape phased array antenna
            % elements_in_a_side: Specify the number of elements in one side of the hexagon.
            % spacing_in_x: Specify the spacing in the X direction. This is the distance from an element's center to the center of an adjacent element in the X direction.
            % spacing_in_y: Specify the spacing in the Y direction. This is the distance from an element's center to the center of an adjacent element in the Y direction.
            obj.hArrayTask.invoke('SetShapeHexagonal', elements_in_a_side, spacing_in_x, spacing_in_y);
        end
        function SetShapeOctagonal(obj, elements_in_a_side, spacing_in_x, spacing_in_y)
            % Sets the settings for creating a octagonal shape phased array antenna
            % elements_in_a_side: Specify the number of elements in one side of the octagon.
            % spacing_in_x: Specify the spacing in the X direction. This is the distance from an element's center to the center of an adjacent element in the X direction.
            % spacing_in_y: Specify the spacing in the Y direction. This is the distance from an element's center to the center of an adjacent element in the Y direction.
            obj.hArrayTask.invoke('SetShapeOctagonal', elements_in_a_side, spacing_in_x, spacing_in_y);
        end
        function Create(obj)
            % Creates a new phased array antenna task.
            obj.hArrayTask.invoke('Create');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hArrayTask

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% %Delete the task if it exists
% 
% arraytask = dsproject.ArrayTask();
% .Reset
% .Name('Task1');
% If .doesexist Then .delete
% 
% %Create a new phased array antenna task
% 
% .Reset
% .Name('Task1');    
% .SetShapeCustom('5', '5', '10.0', '10.0', '63.43');
% .SetExcitationPattern('Cosine');
% .Create
