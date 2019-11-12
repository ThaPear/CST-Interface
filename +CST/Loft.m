%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Authors: Alexander van Katwijk, Cyrus Tirband                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Loft < handle
    properties
        project
        hLoft
        history
        
        name
        componentname
        material
        tangency
        minimizetwist
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Loft object.
        function obj = Loft(project, hProject)
            obj.project = project;
            obj.hLoft = hProject.invoke('Loft');
            obj.Reset();
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            obj.AddToHistory(['.CreateNew']);
            
            % Prepend With and append End With
            obj.history = ['With Loft', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define loft: ', obj.componentname, ':', obj.name], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.componentname = '';
            obj.material = 'Vacuum';
        
        end
        function Name(obj, name)
            obj.name = name;
            
            obj.AddToHistory(['.Name "', name, '"']);
        end
        function Component(obj, componentname)
            obj.componentname = componentname;
            
            obj.AddToHistory(['.Component "', componentname, '"']);
        end
        function Material(obj, material)
            obj.material = material;
            
            obj.AddToHistory(['.Material "', material, '"']);
        end
        function Tangency(obj, tangency)
            obj.tangency = tangency;
            
            obj.AddToHistory(['.Tangency "', num2str(tangency), '"']);
        end
        function Minimizetwist(obj, boolean)
            obj.minimizetwist = boolean;
            
            obj.AddToHistory(['.Minimizetwist "', num2str(boolean), '"']);
        end
    end
end