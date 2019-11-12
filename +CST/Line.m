%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Authors: Alexander van Katwijk, Cyrus Tirband                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Line < handle
    properties
        project
        hLine
        history
        
        name
        curvename
        x1, x2
        y1, y2

    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Line object.
        function obj = Line(project, hProject)
            obj.project = project;
            obj.hLine = hProject.invoke('Line');
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
            obj.history = ['With Line', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define curve line: ', obj.curvename, ':', obj.name], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.curvename ='';
            obj.x1 = '0';  obj.x2 = '0';
            obj.y1 = '0';  obj.y2 = '0';
        end
        function Name(obj, name)
            obj.name = name;
            
            obj.AddToHistory(['.Name "', name, '"']);
        end
        function Curve(obj, curvename)
            obj.curvename = curvename;
            
            obj.AddToHistory(['.Curve "', curvename, '"']);
        end
        function X1(obj, x1)
            obj.x1 = x1;
            obj.AddToHistory(['.X1 "', num2str(x1), '"']);
        end
        
        function X2(obj, x2)
            obj.x2 = x2;
            obj.AddToHistory(['.X2 "', num2str(x2), '"']);
        end
        function Y1(obj, y1)
            obj.y1 = y1;
            obj.AddToHistory(['.Y1 "', num2str(y1), '"']);
        end
        
        function Y2(obj, y2)
            obj.y2 = y2;
            obj.AddToHistory(['.Y2 "', num2str(y2), '"']);
        end

    end
end