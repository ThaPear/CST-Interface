%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef MeshSettings < handle
    properties(SetAccess = protected)
        project
        hMeshSettings
        history
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.MeshSettings object.
        function obj = MeshSettings(project, hProject)
            obj.project = project;
            obj.hMeshSettings = hProject.invoke('MeshSettings');
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', '     ', command, newline];
        end
        function ApplyTo(obj, itemname)
            % itemname: group$groupname
            
            % Prepend With and append End With
            obj.history = ['With MeshSettings', newline, ...
                           '     With .ItemMeshSettings ("', itemname, '")', newline, ...
                                    obj.history, ...
                           '     End With', newline, ...
                           'End With'];
            obj.project.AddToHistory(['set local mesh properties for: ', itemname], obj.history);
            obj.history = [];
        end
        
        function Set(obj, param, value)
            % param: LayerStackup, MaterialIndependent, OctreeSizeFaces,
            %        PatchIndependent, Size
            obj.AddToHistory(['.Set "', param, '", "', num2str(value), '"']);
        end
        
        function SetMeshType(obj, type)
            % type: Tet
            obj.AddToHistory(['.SetMeshType "', type, '"']);
        end
    end
end

% Example:
%{
With MeshSettings
     With .ItemMeshSettings ("group$meshgroup1")
          .SetMeshType "Tet"
          .Set "LayerStackup", "Automatic"
          .Set "MaterialIndependent", 0
          .Set "OctreeSizeFaces", "0"
          .Set "PatchIndependent", 0
          .Set "Size", "1"
     End With
End With
%}
