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
% Warning: This entire class is undocumented.
% If a function is missing, it is likely available in CST.Mesh.

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK>

classdef Discretizer < handle
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Discretizer object.
        function obj = Discretizer(project, hProject)
            obj.project = project;
            obj.hDiscretizer = hProject.invoke('Discretizer');
            obj.history = [];
            obj.bulkmode = 0;
        end
    end
    methods
        function StartBulkMode(obj)
            % Buffers all commands instead of sending them to CST
            % immediately.
            obj.bulkmode = 1;
        end
        function EndBulkMode(obj)
            % Flushes all commands since StartBulkMode to CST.
            obj.bulkmode = 0;
            % Prepend With MeshAdaption3D and append End With
            obj.history = [ 'With Discretizer', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Discretizer'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['Discretizer', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        %% From CST.Mesh
        function MeshType(obj, mType)
            % Sets the type of the mesh.
            % mType: 'PBA' -  Hexahedral mesh with Perfect Boundary Approximation
            %        'Staircase' - Hexahedral mesh with staircase cells
            %        'Tetrahedral' - Tetrahedral mesh
            %        'Surface' - Surface mesh
            %        'SurfaceML' - Surface multi layer mesh
            obj.AddToHistory(['.MeshType "', num2str(mType, '%.15g'), '"']);
        end
        function PBAType(obj, mType)
            % Disables or enables the PBA acceleration.
            % mType: 'PBA'
            %        'Fast PBA'
            obj.AddToHistory(['.PBAType "', num2str(mType, '%.15g'), '"']);
        end
        function AutomaticPBAType(obj, bFlag)
            % Disables or enables the automatic PBA mode. If enabled the expert system decides wether to use PBA or FPBA.
            obj.AddToHistory(['.AutomaticPBAType "', num2str(bFlag, '%.15g'), '"']);
        end
        function ConvertGeometryDataAfterMeshing(obj, bFlag)
            % If bFlag is True geometry data is prepared for accurate post-processing at the end of the matrix setup.
            obj.AddToHistory(['.ConvertGeometryDataAfterMeshing "', num2str(bFlag, '%.15g'), '"']);
        end
        function UsePecEdgeModel(obj, bFlag)
            % Activates (bFlag = True) or deactivates (bFlag = False) the corner correction for PEC edges. This correction uses an analytical model that takes into account that theoretically the fields at PEC edges are singular. By using this model the accuracy of the simulated fields near such edges is increased.
            obj.AddToHistory(['.UsePecEdgeModel "', num2str(bFlag, '%.15g'), '"']);
        end
        function FPBAGapTolerance(obj, value)
            % Sets a tolerance value to skip the accuracy enhancement for non-PEC gaps that are smaller than the given value.
            obj.AddToHistory(['.FPBAGapTolerance "', num2str(value, '%.15g'), '"']);
        end
        function SetMaxParallelMesherThreads(obj, type, value)
            % Set number of threads for a given mesher type if user-defined parallelization mode is specified.
            % Hex mesher type corresponds to FPBA mesher.
            % Tet  mesher type corresponds to Delaunay volume mesher.
            % type,: 'Hex'
            %        'Tet'
            obj.AddToHistory(['.SetMaxParallelMesherThreads "', num2str(type, '%.15g'), '", '...
                                                           '"', num2str(value, '%.15g'), '"']);
        end
        function SetParallelMesherMode(obj, type, mode)
            % Set parallelization mode for a given mesher type. The mesher can either use the maximum number of processors available (maximum), use only a single processor (none) or use the number of processors specified by user (user-defined).
            % Hex mesher type corresponds to FPBA mesher.
            % Tet  mesher type corresponds to Delaunay volume mesher.
            % If the FPBA mesher is used the number of processes used in parallel for parts of the matrix calculation is enabled or disabled or set to a user-defined value.
            % type: 'Hex'
            %       'Tet'
            % mode: 'maximum'
            %       'user-defined'
            %       'none'
            obj.AddToHistory(['.SetParallelMesherMode "', num2str(type, '%.15g'), '", '...
                                                     '"', num2str(mode, '%.15g'), '"']);
        end
        function PointAccEnhancement(obj, percentage)
            % Defines the accuracy level to distinguish between two points of the model. Use the default level of 0% for a fast and accurate matrix setup. When you are encountering problems during  the meshing process increase this level. An accuracy of 100% means using the highest possible accuracy of the build-in CAD kernel, but slows down the matrix generation.
            obj.AddToHistory(['.PointAccEnhancement "', num2str(percentage, '%.15g'), '"']);
        end
        %% Undocumented functions
        % Found in history list of migrated CST 2014 file in 'set mesh properties (Hexahedral)'
        function FPBAAccuracyEnhancement(obj, arg)
            % arg: 'enable'
            obj.AddToHistory(['.FPBAAccuracyEnhancement "', num2str(arg, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'set mesh properties (Hexahedral)'
        function ConnectivityCheck(obj, boolean)
            obj.AddToHistory(['.ConnectivityCheck "', num2str(boolean, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'set mesh properties (Hexahedral)'
        function GapDetection(obj, boolean)
            obj.AddToHistory(['.GapDetection "', num2str(boolean, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'set mesh properties (Hexahedral)'
        function UseSplitComponents(obj, boolean)
            obj.AddToHistory(['.UseSplitComponents "', num2str(boolean, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'set mesh properties (Hexahedral)'
        function EnableSubgridding(obj, boolean)
            obj.AddToHistory(['.EnableSubgridding "', num2str(boolean, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'set mesh properties (Hexahedral)'
        function PBAFillLimit(obj, arg)
            obj.AddToHistory(['.PBAFillLimit "', num2str(arg, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'set mesh properties (Hexahedral)'
        function AlwaysExcludePec(obj, boolean)
            obj.AddToHistory(['.AlwaysExcludePec "', num2str(boolean, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'set mesh properties (Hexahedral)'
        function UseTST2(obj, boolean)
            obj.AddToHistory(['.UseTST2 "', num2str(boolean, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'set mesh properties (Hexahedral)'
        function PBAVersion(obj, version)
            obj.AddToHistory(['.PBAVersion "', num2str(version, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hDiscretizer
        history
        bulkmode

    end
end