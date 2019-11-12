%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Rectangle < handle
    properties
        project
        hRectangle
        history
        
        name
        curve
        x1, x2
        y1, y2
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Rectangle object.
        function obj = Rectangle(project, hProject)
            obj.project = project;
            obj.hRectangle = hProject.invoke('Rectangle');
            obj.Reset();
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = ['With Rectangle', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define rectangle: ', obj.curve, ':', obj.name], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.curve = '';
            obj.x1 = 0; obj.x2 = 0;
            obj.y1 = 0; obj.y2 = 0;
        end
        function Name(obj, name)
            obj.name = name;
            
            obj.AddToHistory(['.Name "', name, '"']);
        end
        function Curve(obj, curve)
            obj.curve = curve;
            
            obj.AddToHistory(['.Curve "', curve, '"']);
        end
        function Xrange(obj, x1, x2)
            obj.x1 = x1;
            obj.x2 = x2;
            
            obj.AddToHistory(['.Xrange "', num2str(x1, '%.15g'), '", '...
                                      '"', num2str(x2, '%.15g'), '"']);
        end
        function Yrange(obj, y1, y2)
            obj.y1 = y1;
            obj.y2 = y2;
            
            obj.AddToHistory(['.Yrange "', num2str(y1, '%.15g'), '", '...
                                      '"', num2str(y2, '%.15g'), '"']);
        end
    end
end