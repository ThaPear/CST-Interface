%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object is used to create a new brick shape.
classdef Brick < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Brick object.
        function obj = Brick(project, hProject)
            obj.project = project;
            obj.hBrick = hProject.invoke('Brick');
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
        function Name(obj, brickname)
            % Sets the name of the brick.
            obj.AddToHistory(['.Name "', num2str(brickname, '%.15g'), '"']);
            obj.name = brickname;
        end
        function Component(obj, componentname)
            % Sets the name of the component for the new brick. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
            obj.component = componentname;
        end
        function Material(obj, materialname)
            % Sets the material name for the new brick. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
            obj.material = materialname;
        end
        function Xrange(obj, xmin, xmax)
            % Sets the bounds for the x- or u-coordinate for the new brick, depending if a local coordinate system is active or not.
            obj.AddToHistory(['.Xrange "', num2str(xmin, '%.15g'), '", '...
                                      '"', num2str(xmax, '%.15g'), '"']);
            obj.xrange.xmin = xmin;
            obj.xrange.xmax = xmax;
        end
        function Yrange(obj, ymin, ymax)
            % Sets the bounds for the y- or v-coordinate for the new brick, depending if a local coordinate system is active or not.
            obj.AddToHistory(['.Yrange "', num2str(ymin, '%.15g'), '", '...
                                      '"', num2str(ymax, '%.15g'), '"']);
            obj.yrange.ymin = ymin;
            obj.yrange.ymax = ymax;
        end
        function Zrange(obj, zmin, zmax)
            % Sets the bounds for the z- or w-coordinate for the new brick, depending if a local coordinate system is active or not.
            obj.AddToHistory(['.Zrange "', num2str(zmin, '%.15g'), '", '...
                                      '"', num2str(zmax, '%.15g'), '"']);
            obj.zrange.zmin = zmin;
            obj.zrange.zmax = zmax;
        end
        function Create(obj)
            % Creates a new brick. All necessary settings for this brick have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Brick and append End With
            obj.history = [ 'With Brick', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define brick: ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end
        function CreateConditional(obj, condition)
            % Creates a new brick. All necessary settings for this brick have to be made previously.
            %
            % condition: A string of a VBA expression that evaluates to True or False
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = [ 'If ', condition, ' Then', newline, ...
                                'With Brick', newline, ...
                                    obj.history, ...
                                'End With', newline, ...
                            'End If'];
            obj.project.AddToHistory(['define conditional brick ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hBrick
        history

        name
        component
        material
        xrange
        yrange
        zrange
    end
end

%% Default Settings
% Material('Vacuum');
% Xrange(0, 0)
% Yrange(0, 0)
% Zrange(0, 0)

%% Example - Taken from CST documentation and translated to MATLAB.
% brick = project.Brick();
%     brick.Reset
%     brick.Name('brick1');
%     brick.Component('component1');
%     brick.Material('PEC');
%     brick.Xrange(0, 2)
%     brick.Yrange(0, 3)
%     brick.Zrange(0, 'a+3');
%     brick.Create
