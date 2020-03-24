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