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

% This object is used to specify the defaults settings to be used by the EDA import upon first import.
classdef EDAImportDefaults < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.EDAImportDefaults object.
        function obj = EDAImportDefaults(project, hProject)
            obj.project = project;
            obj.hEDAImportDefaults = hProject.invoke('EDAImportDefaults');
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.hEDAImportDefaults.invoke('Reset');
        end
        function EtchAs2D(obj, boolean)
            % Ignores the layer thicknesses for conducting layers and imports them as 2D sheets when activated.
            obj.hEDAImportDefaults.invoke('EtchAs2D', boolean);
        end
        function EtchFactorSignalNets(obj, boolean)
            % When True, limits the etch factor to signal nets only.
            obj.hEDAImportDefaults.invoke('EtchFactorSignalNets', boolean);
        end
        function ConformalSolderMask(obj, boolean)
            % Turns on or off a conformal solder mask.
            obj.hEDAImportDefaults.invoke('ConformalSolderMask', boolean);
        end
        function ConformalSolderMaskSignalNets(obj, boolean)
            % When True, limits the generation of conformal solder masks to signal nets only.
            obj.hEDAImportDefaults.invoke('ConformalSolderMaskSignalNets', boolean);
        end
        function ComponentElevation(obj, type)
            % Can be set to "Automatic" or "Explicit".
            obj.hEDAImportDefaults.invoke('ComponentElevation', type);
        end
        function ComponentElevationHeightMM(obj, height)
            % Sets the value of the explicit elevation height in mm.
            obj.hEDAImportDefaults.invoke('ComponentElevationHeightMM', height);
        end
        function ShortGroundsOnBGA(obj, boolean)
            % When True, shorts all grounds on the BGA side to a PEC sheet.
            obj.hEDAImportDefaults.invoke('ShortGroundsOnBGA', boolean);
        end
        function PortGeometry(obj, type)
            % Can be set to "Edge", "EdgeToPEC" or "FaceToPEC".
            obj.hEDAImportDefaults.invoke('PortGeometry', type);
        end
        function LumpedElementGeometry(obj, type)
            % Can be set to "Edge", "Face" or "EdgeToPEC".
            obj.hEDAImportDefaults.invoke('LumpedElementGeometry', type);
        end
        function LumpedElementMonitors(obj, boolean)
            % When True, adds voltage and current monitors to the lumped elements in the 3D model.
            obj.hEDAImportDefaults.invoke('LumpedElementMonitors', boolean);
        end
        function MeshDensityX(obj, type)
            % Can be set to "Medium", "Course" or "Fine" or a factor (double) relative to the lateral reference length. Applies to the HEX mesh generation in the X-direction.
            obj.hEDAImportDefaults.invoke('MeshDensityX', type);
        end
        function MeshDensityY(obj, type)
            % Can be set to "Medium", "Course" or "Fine" or a factor (double) relative to the lateral reference length. Applies to the HEX mesh generation in the Y-direction.
            obj.hEDAImportDefaults.invoke('MeshDensityY', type);
        end
        function MeshLinesSubstrate(obj, number)
            % Sets the number of mesh lines within the substrate layers.
            obj.hEDAImportDefaults.invoke('MeshLinesSubstrate', number);
        end
        function Create(obj)
            % Creates the defaults file.
            obj.hEDAImportDefaults.invoke('Create');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hEDAImportDefaults

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% edaimportdefaults = project.EDAImportDefaults();
% .Reset
% .EtchAs2D('1');
% .EtchFactorSignalNets 1
% .ConformalSolderMask 1
% .ConformalSolderMaskSignalNets 1
% .ComponentElevation('Automatic');
% .ComponentElevationHeightMM 0.1234
% .ShortGroundsOnBGA 1
% .PortGeometry('FaceToPEC');
% .LumpedElementGeometry('Face');
% .LumpedElementMonitors 1
% .MeshDensityX('medium');
% .MeshDensityY('coarse');
% .MeshLinesSubstrate 2
% .Create
