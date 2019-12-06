%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef FloquetPort < handle
    properties(SetAccess = protected)
        project
        hFloquetPort
        
        port
        nmodes
        distancetoreferenceplane
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.FloquetPort object.
        function obj = FloquetPort(project, hProject)
            obj.project = project;
            obj.hFloquetPort = hProject.invoke('FloquetPort');
        end
    end
    
    methods
        function Port(obj, port)
            obj.port = port;
            
            obj.project.AddToHistory(['FloquetPort.Port "', port, '"']);
        end
        function SetNumberOfModesConsidered(obj, nmodes)
            obj.nmodes = nmodes;
            
            obj.project.AddToHistory(['FloquetPort.SetNumberOfModesConsidered "', num2str(nmodes), '"']);
        end
        function SetDistanceToReferencePlane(obj, distancetoreferenceplane)
            obj.distancetoreferenceplane = distancetoreferenceplane;
            
            obj.project.AddToHistory(['FloquetPort.SetDistanceToReferencePlane "', num2str(distancetoreferenceplane), '"']);
        end
    end
end

% With FloquetPort
%      .Reset
%      .SetDialogTheta "0" 
%      .SetDialogPhi "0" 
%      .SetPolarizationIndependentOfScanAnglePhi "0.0", "False"  
%      .SetSortCode "+beta/pw" 
%      .SetCustomizedListFlag "False" 
%      .Port "Zmin" 
%      .SetNumberOfModesConsidered "18" 
%      .SetDistanceToReferencePlane "0.0" 
%      .SetUseCircularPolarization "False" 
%      .Port "Zmax" 
%      .SetNumberOfModesConsidered "18" 
%      .SetDistanceToReferencePlane "-3e8/3e9/4*1e3" 
%      .SetUseCircularPolarization "False" 
% End With