%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Authors: Alexander van Katwijk, Cyrus Tirband                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Suppress warnings:
% "Use of brackets [] is unnecessary. Use parentheses to group, if needed."
%#ok<*NBRAK>
classdef Polygon < handle
    properties
        project
        hPolygon
        history
        
        name
        curvename
        point
        lineto
        rline
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Polygon3D object.
        function obj = Polygon(project, hProject)
            obj.project = project;
            obj.hPolygon = hProject.invoke('Polygon');
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
            obj.history = ['With Polygon', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define curve polygon: ', obj.curvename, ':', obj.name], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.curvename = '';
            obj.point = [];
            obj.lineto = [];
            obj.rline = [];
        end
        
        function Name(obj, name)
            obj.name = name;
            
            obj.AddToHistory(['.Name "', name, '"']);
        end
        function Curve(obj, curvename)
            obj.curvename = curvename;
            
            obj.AddToHistory(['.Curve "', curvename, '"']);
        end
        function Point(obj, x, y)
            obj.point = [obj.point, {x, y}];
            
            obj.AddToHistory(['.Point "', num2str(x, '%.15g'), '", '...
                '"', num2str(y, '%.15g'), '"']);
        end
        function LineTo(obj, x, y)
            %draw to absolute coordinate
            obj.lineto = [obj.lineto, {x, y}];
            obj.AddToHistory(['.LineTo "', num2str(x, '%.15g'), '", '...
                '"', num2str(y, '%.15g'), '"']);
        end
        function RLine(obj, x, y)
            %draw to relative coordinate
            obj.rline = [obj.rline, {x, y}]; 
            obj.AddToHistory(['.RLine "', num2str(x, '%.15g'), '", '...
                '"', num2str(y, '%.15g'), '"'])
        end
        
    end
end

