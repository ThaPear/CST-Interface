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

% Still requires autogeneration.

classdef Solver < handle
    properties(SetAccess = protected)
        project
        hSolver
        
        fmin, fmax
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Solver object.
        function obj = Solver(project, hProject)
            obj.project = project;
            obj.hSolver = hProject.invoke('Solver');
        end
    end
    
    methods
        function FrequencyRange(obj, fmin, fmax)
            obj.fmin = fmin; obj.fmax = fmax;
            
%             obj.hSolver.invoke('FrequencyRange', fmin, fmax);
            obj.project.AddToHistory(['Solver.FrequencyRange "', num2str(fmin), '", "', num2str(fmax), '"']);
        end
    end
end
