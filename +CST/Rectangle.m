% CST Interface - Interface with CST from MATLAB.
% Copyright (C) 2020 Alexander van Katwijk
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK> 

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