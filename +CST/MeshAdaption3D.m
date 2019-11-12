%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef MeshAdaption3D < handle
    properties(SetAccess = protected)
        project
        hMeshAdaption3D
        
        type
        minpasses
        maxpasses
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.MeshAdaption3D object.
        function obj = MeshAdaption3D(project, hProject)
            obj.project = project;
            obj.hMeshAdaption3D = hProject.invoke('MeshAdaption3D');
        end
    end
    
    methods
        function SetType(obj, type)
            % type: EStatic, MStatic, JStatic, LowFrequency,
            %       HighFrequencyHex, HighFrequencyTet, Time
            obj.type = type;
            
            obj.project.AddToHistory(['MeshAdaption3D.SetType "', type, '"']);
        end
            
        function MinPasses(obj, minpasses)
            % Note that SetType must be called before using MinPasses.
            obj.minpasses = minpasses;
            
            obj.project.AddToHistory(['MeshAdaption3D.MinPasses "', num2str(minpasses), '"']);
        end
        function MaxPasses(obj, maxpasses)
            % Note that SetType must be called before using MaxPasses.
            obj.maxpasses = maxpasses;
            
            obj.project.AddToHistory(['MeshAdaption3D.MaxPasses "', num2str(maxpasses), '"']);
        end
    end
end
