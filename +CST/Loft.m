%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Creates a solid that connects two surfaces.
classdef Loft < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Loft object.
        function obj = Loft(project, hProject)
            obj.project = project;
            obj.hLoft = hProject.invoke('Loft');
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
            % Resets all internal settings.
            obj.AddToHistory(['.Reset']);
        end
        function Name(obj, objectname)
            % Sets the name of the new Object.
            obj.AddToHistory(['.Name "', num2str(objectname, '%.15g'), '"']);
            obj.name = objectname;
        end
        function Component(obj, componentname)
            % Sets the component for the new Solid. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
            obj.component = componentname;
        end
        function Material(obj, materialname)
            % Sets the material for the new Solid. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
            obj.material = materialname;
        end
        function Tangency(obj, tang)
            % Defines the shape of the connection.
            obj.AddToHistory(['.Tangency "', num2str(tang, '%.15g'), '"']);
            obj.tangency = tang;
        end
        function Create(obj)
            % Creates a new solid. All necessary settings for this element have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Loft and append End With
            obj.history = [ 'With Loft', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define loft: ', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hLoft
        history

        name
        component
        material
        tangency
    end
end

%% Default Settings
% Material('default');
% Component('default');

%% Example - Taken from CST documentation and translated to MATLAB.
% loft = project.Loft();
%     loft.Reset
%     loft.Name('solid3');
%     loft.Component('component1');
%     loft.Material('Vacuum');
%     loft.Tangency('0.250000');
%     loft.CreateNew
