%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Plot < handle
    properties(SetAccess = protected)
        project
        hPlot
        
        drawbox
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Plot object.
        function obj = Plot(project, hProject)
            obj.project = project;
            obj.hPlot = hProject.invoke('Plot');
        end
    end
    
    methods
        function RestoreView(obj, viewname)
            % Default views: Left, Right, Front, Back, Bottom, Perspective,
            %                Nearest Axis
            obj.hPlot.invoke('RestoreView', viewname);
        end

        function StoreView2(obj, viewname, parameters)
            % parameters: String list of options separated by spaces:
            %             int drawplane, int axis, int cutplaneState, 
            %             int cutPlaneNormal, double cutplaneCoord, int bBox,
            %             int wireframe, int abovePlaneMode
            obj.hPlot.invoke('StoreView2', viewname, parameters);
        end
        
        function ZoomToStructure(obj)
            % Zooms to the structure, equivalent to pressing space.
            obj.hPlot.invoke('ZoomToStructure');
        end

        function RotationAngle(obj, angle)
            % Sets the angle to use in the Rotate function.
            % angle in degrees.
            obj.hPlot.invoke('RotationAngle', angle);
        end

        function Rotate(obj, direction)
            % direction: left, right, up, down, clockwise, counterclockwise
            obj.hPlot.invoke('Rotate', direction);
        end
        
        function Update(obj)
            obj.hPlot.invoke('Update');
        end
        
        function DrawBox(obj, boolean)
            obj.drawbox = boolean;
            
            obj.project.AddToHistory(['Plot.DrawBox "', num2str(boolean), '"']);
        end

        function DrawWorkplane(obj, boolean)
            % boolean MUST be "TRUE" or "FALSE"
            if(isnumeric(boolean))
                if(boolean); boolean = 'TRUE'; else; boolean = 'FALSE'; end
            elseif(~strcmpi(boolean, 'TRUE'))
                boolean = 'FALSE';
            end
            obj.project.AddToHistory(['Plot.DrawWorkplane "', boolean, '"']);
        end
    end
end
