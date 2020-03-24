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

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK> 

classdef MeshSettings < handle
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.MeshSettings object.
        function obj = MeshSettings(project, hProject)
            obj.project = project;
            obj.hMeshSettings = hProject.invoke('MeshSettings');
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
            obj.history = [ 'With MeshSettings', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define MeshSettings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['MeshSettings', command]);
            end
        end
        % Special function to set the settings set during bulkmode to the mesh group of choice.
        % Enables settings of local mesh options.
        function ApplyToMeshGroup(obj, itemname)
            % itemname: group$groupname
            if(~obj.bulkmode)
                error('ApplyToMeshGroup requires settings to be set during bulkmode.');
            end
            
            % Prepend With and append End With
            obj.history = ['With MeshSettings', newline, ...
                           '     With .ItemMeshSettings ("', itemname, '")', newline, ...
                                    obj.history, ...
                           '     End With', newline, ...
                           'End With'];
            obj.project.AddToHistory(['set local mesh properties for: ', itemname], obj.history);
            obj.history = [];
            obj.bulkmode = 0;
        end
    end
    %% CST Object functions.
    methods
        % Found in history list when setting local mesh settings.
        % Found in template: 'Planar Coupler & Divider.cfg'
        function Set(obj, param, varargin)
            % param                         | # of args | Known values, exactly as found
            % Found in template: 'Planar Coupler & Divider.cfg' with .SetMeshType "Hex"
            % RatioLimitGeometry            | 1         | "20"
            % EdgeRefinementOn              | 1         | "1"
            % EdgeRefinementRatio           | 1         | "6"
            % Found in template: 'Planar Coupler & Divider.cfg' with .SetMeshType "Tet"
            % VolMeshGradation              | 1         | "1.5"
            % SrfMeshGradation              | 1         | "1.5"
            % Version                       | 1         | 1%
            % Found in template: 'Planar Coupler & Divider.cfg' with .SetMeshType "HexTLM"
            % StepsPerWaveNear              | 1         | "20"
            % StepsPerBoxNear               | 1         | "10"
            % StepsPerWaveFar               | 1         | "20"
            % StepsPerBoxFar                | 1         | "10"
            % Found in history list when setting local mesh settings in .ItemMeshSettings with .SetMeshType "Tet"
            % LayerStackup                  | 1         | "Automatic"
            % MaterialIndependent           | 1         | 0
            % OctreeSizeFaces	            | 1         | "0"
            % PatchIndependent              | 1         | 0
            % Size                          | 1         | "1"
            % Found in history list when setting local mesh settings in .ItemMeshSettings with .SetMeshType "Hex"
            % EdgeRefinement                | 1         | "1"
            % Extend                        | 3         | "0", "0", "0"
            % Fixpoints                     | 1         | 1
            % MeshType                      | 1         | "Default"
            % NumSteps                      | 3         | "0", "0", "0"
            % Priority                      | 1         | "0"
            % RefinementPolicy              | 1         | "ABS_VALUE"
            % SnappingIntervals             | 3         | 0, 0, 0
            % SnappingPriority              | 1         | 0
            % SnapTo                        | 3         | "1", "1", "1"
            % Step                          | 3         | "0", "0", "0"
            % StepRatio                     | 3         | "0", "0", "0"
            % StepRefinementCollectPolicy   | 1         | "REFINE_ALL"
            % StepRefinementExtentPolicy    | 1         | "EXTENT_ABS_VALUE"
            % UseDielectrics                | 1         | 1
            % UseEdgeRefinement             | 1         | 1
            % UseForRefinement              | 1         | 1
            % UseForSnapping                | 1         | 1
            % UseSameExtendXYZ              | 1         | 1
            % UseSameStepWidthXYZ           | 1         | 1
            % UseSnappingPriority           | 1         | 0
            % UseStepAndExtend              | 1         | 1
            % UseVolumeRefinement           | 1         | 0
            % VolumeRefinement              | 1         | "1"
            % Found in ModelCache\Model.mif in .ItemMeshSettings with .SetMeshType "All"
            % Found in ModelCache\Model.smp in .ItemMeshSettings with .SetMeshType "All"
            % Transform                     | 9         | "0", "-1", "0", "1", "0", "0", "0", "0", "1" 
            command = ['.Set "', param, '"'];
            for(i = 1:nargin-2)
                command = [command, ', "', num2str(varargin{i}, '%.15g'), '"']; %#ok<AGROW>
            end
            obj.AddToHistory(command);
        end
        
        function SetMeshType(obj, type)
            % type: 'All'
            %       'Tet'
            %       'Hex'
            %       'HexTLM'
            obj.AddToHistory(['.SetMeshType "', type, '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hMeshSettings
        history
        bulkmode
        
    end
end

%% Example:
%{
With MeshSettings
     With .ItemMeshSettings ("group$meshgroup1")
          .SetMeshType "Tet"
            %        .Set "LayerStackup", "Automatic"
            %        .Set "MaterialIndependent", 0
            %        .Set "OctreeSizeFaces", "0"
            %        .Set "PatchIndependent", 0
            %        .Set "Size", "1"
     End With
End With
%}
%% Local mesh example
% group = project.Group();
% group.Add('localmeshgroup', 'mesh');
% % Add microstrip conductor to local mesh group.
% group.AddItem(['solid$Microstrip:Conductor'], 'localmeshgroup');
% meshsettings = project.MeshSettings();
% meshsettings.StartBulkmode();
% meshsettings.SetMeshType('Tet');
% meshsettings.Set('Size', 1);
% meshsettings.ApplyToMeshGroup('group$localmeshgroup');