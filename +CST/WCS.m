%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef WCS < handle
    properties(SetAccess = protected)
        project
        hWCS
        
        normalx, normaly, normalz
        x, y, z
        
        enabled
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.WCS object.
        function obj = WCS(project, hProject)
            obj.project = project;
            obj.hWCS = hProject.invoke('WCS');
            
            obj.normalx = 0;  obj.normaly = 0;  obj.normalz = 1;
            obj.x = 0;  obj.y = 0;  obj.z = 0;
            obj.enabled = 0;
        end
    end
    
    methods
        function SetNormal(obj, x, y, z)
            obj.normalx = x;
            obj.normaly = y;
            obj.normalz = z;
            
            obj.project.AddToHistory(['WCS.SetNormal "', num2str(x, '%.15g'), '", '...
                                                    '"', num2str(y, '%.15g'), '", '...
                                                    '"', num2str(z, '%.15g'), '"']);
        end
        function SetOrigin(obj, x, y, z)
            obj.x = x;
            obj.y = y;
            obj.z = z;
            
            obj.project.AddToHistory(['WCS.SetOrigin "', num2str(x, '%.15g'), '", '...
                                                    '"', num2str(y, '%.15g'), '", '...
                                                    '"', num2str(z, '%.15g'), '"']);
        end
        function Enable(obj)
%             if(~obj.enabled)
                obj.ActivateWCS('local');
%             end
        end
        function Disable(obj)
%             if(obj.enabled)
                obj.ActivateWCS('global');
%             end
        end
        function Reset(obj)
            obj.SetOrigin(0, 0, 0);
            obj.SetNormal(0, 0, 1);
        end
        function ActivateWCS(obj, type)
            % type: 'local', 'global'
            obj.enabled = strcmp(type, 'local');
            
            obj.project.AddToHistory(['WCS.ActivateWCS "', type, '"']);
        end
        
        function Store(obj, name)
            obj.project.AddToHistory(['WCS.Store "', name, '"']);
        end
        
        function Restore(obj, name)
            obj.project.AddToHistory(['WCS.Restore "', name, '"']);
        end
        
        function Delete(obj, name)
            obj.project.AddToHistory(['WCS.Delete "', name, '"']);
        end
            
        function RotateWCS(obj, axis, angle)
            % axis: 'u', 'v', 'w'
            % angle: Degrees.
            obj.project.AddToHistory(['WCS.RotateWCS "', axis, '", '...
                                                    '"', num2str(angle, '%.15g'), '"']);
        end
        
        function MoveWCS(obj, axis, du, dv, dw)
            % axis: 'local', 'global'
            obj.project.AddToHistory(['WCS.MoveWCS "', axis, '", '...
                                                  '"', num2str(du, '%.15g'), '", '...
                                                  '"', num2str(dv, '%.15g'), '", '...
                                                  '"', num2str(dw, '%.15g'), '"']);
        end
    end
end