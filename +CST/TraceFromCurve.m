%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef TraceFromCurve < handle
    properties(SetAccess = protected)
        project
        hTraceFromCurve
        history
        
        name
        component
        material
        curvename
        thickness
        width
        roundstart, roundend
        deletecurve
        gaptype
        create
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TraceFromCurve object.
        function obj = TraceFromCurve(project, hProject)
            obj.project = project;
            obj.hTraceFromCurve = hProject.invoke('TraceFromCurve');
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = ['With TraceFromCurve', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define tracefromcurve: ', obj.component, ':', obj.name, ''], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.component = '';
            obj.curvename = '';
            obj.material = 'Vacuum';
            obj.thickness = 0;
            obj.width = 0;
            obj.roundstart = 0;
            obj.roundend = 0;
            obj.deletecurve = 1;
            obj.gaptype = 2;
        end
        
        function Name(obj, name)
            obj.name = name;
            
            obj.AddToHistory(['.Name "', name, '"']);
        end
        function Component(obj, component)
            obj.component = component;
            
            obj.AddToHistory(['.Component "', component, '"']);
        end
        function Material(obj, materialname)
            obj.material = materialname;
            
            obj.AddToHistory(['.Material "', materialname, '"']);
        end
        function Curve(obj, curvename)
            obj.curvename = curvename;
            
            obj.AddToHistory(['.Curve "', curvename, '"']);
        end
        function Thickness(obj, thickness)
            obj.thickness = thickness;
            
            obj.AddToHistory(['.Thickness "', num2str(thickness), '"']);
        end
        function Width(obj, width)
            obj.width = width;
            
            obj.AddToHistory(['.Width "', num2str(width), '"']);
        end
        function RoundStart(obj, boolean)
            obj.roundstart = boolean;
            
            obj.AddToHistory(['.RoundStart "', num2str(boolean), '"']);
        end
        function RoundEnd(obj, boolean)
            obj.roundend = boolean;
            
            obj.AddToHistory(['.RoundEnd "', num2str(boolean), '"']);
        end
        function DeleteCurve(obj, boolean)
            obj.deletecurve = boolean;
            
            obj.AddToHistory(['.DeleteCurve "', num2str(boolean), '"']);
        end
        function GapType(obj, gaptype)
            % Specifies the behavior of the creating solid on inflexion points of the curve.
            % type: 0 = rounded like arcs, 1 = extended like lines and 2 = natural like curve extensions
            obj.gaptype = gaptype;
            
            obj.AddToHistory(['.GapType "', num2str(gaptype), '"']);
        end
    end
end

% Default Settings
% Material ("Vacuum")
% Thickness (0.0)
% Width (0.0)
% RoundStart (False)
% RoundEnd (False)
% GapType(2)