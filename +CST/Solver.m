%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
