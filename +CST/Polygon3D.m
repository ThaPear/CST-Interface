%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Authors: Alexander van Katwijk, Cyrus Tirband                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Suppress warnings:
% "Use of backets [] is unnecessary. Use parentheses to group, if needed."
%#ok<*NBRAK>
classdef Polygon3D < handle
    properties
        project
        hPolygon3D
        history
    
        version
        name
        curvename
        points
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Polygon3D object.
        function obj = Polygon3D(project, hProject)
            obj.project = project;
            obj.hPolygon3D = hProject.invoke('Polygon3D');
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
            obj.history = ['With Polygon3D', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define curve 3dpolygon: ', obj.curvename, ':', obj.name], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.curvename = '';
            obj.points = [];
        end
        function Version(obj, version)
            if(nargin < 2); version = 10;   end
            obj.version = version;
            
            obj.AddToHistory(['.Version ', num2str(version), '']);
        end
        function Name(obj, name)
            obj.name = name;
            
            obj.AddToHistory(['.Name "', name, '"']);
        end
        function Curve(obj, curvename)
            obj.curvename = curvename;
            
            obj.AddToHistory(['.Curve "', curvename, '"']);
        end
        function Point(obj, x, y, z)
            obj.points = [obj.points, {x, y, z}];
            
            obj.AddToHistory(['.Point "', num2str(x, '%.15g'), '", '...
                                     '"', num2str(y, '%.15g'), '", '...
                                     '"', num2str(z, '%.15g'), '"']);
        end
    end
end

                
                
 

