%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Controls the output of the main plot window.
classdef Plot < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Plot object.
        function obj = Plot(project, hProject)
            obj.project = project;
            obj.hPlot = hProject.invoke('Plot');
        end
    end
    %% CST Object functions.
    methods
        %% Cutplane
        function AbovePlaneMode(obj, type)
            % Sets the view above the cutplane.
            % type: 'hide'
            %       'wireframe'
            %       'transparent'
            %       'solid'
            obj.hPlot.invoke('AbovePlaneMode', type);
        end
        function DefinePlane(obj, nx, ny, nz, px, py, pz)
            % Defines the cutplane by the normal direction and point on the plane.
            obj.hPlot.invoke('DefinePlane', nx, ny, nz, px, py, pz);
        end
        function CutPlaneNormal(obj, key)
            % Defines the normal direction of the cutplane.
            % key: 'x'
            %      'y'
            %      'z'
            obj.hPlot.invoke('CutPlaneNormal', key);
        end
        function CutPlaneRatio(obj, ratio)
            % Defines where the cutplane will be located. A value of 0.0 for Ratio will position the cut plane at the lowest dimension of the structure in direction of CutPlaneNormal. A value of 1.0 will move the plane to the highest dimension.
            obj.hPlot.invoke('CutPlaneRatio', ratio);
        end
        function ShowCutplane(obj, boolean)
            % A cutplane can be defined to look inside a structure. This cutplane divides the structure into two parts, while only one of them will be plotted. The cutplane can be defined by the methods CutPlaneNormal and CutPlaneRatio.
            obj.hPlot.invoke('ShowCutplane', boolean);
        end
        function DrawSolidCutPlane(obj, boolean)
            % If this flag is set to true, the cutplane will be displayed as solid, otherwise it will not be drawn.
            obj.hPlot.invoke('DrawSolidCutPlane', boolean);
        end
        function DrawSolidCutPlaneMark(obj, boolean)
            % If this flag is set to true, the cutplane will be displayed as solid with a stipple pattern.
            obj.hPlot.invoke('DrawSolidCutPlaneMark', boolean);
        end
        function Draw2DWithCutPlane(obj, boolean)
            % Display the structure in a flat and true 2D style if the cutplane is active (Unavailable for field plot mode).
            obj.hPlot.invoke('Draw2DWithCutPlane', boolean);
        end
        %% Cross Section
        function DefineCrossSection(obj, id, nx, ny, nz, px, py, pz)
            % Defines position and orientation for one of four available Cross Sections by the normal direction and point on the plane.
            % id: 0
            %     1
            %     2
            %     3
            obj.hPlot.invoke('DefineCrossSection', id, nx, ny, nz, px, py, pz);
        end
        function ActivateCrossSection(obj, id, boolean)
            % Activates or deactivates one of four available Cross Sections. After activation, the given Cross Section will automatically be selected for manipulation.
            % id: 0
            %     1
            %     2
            %     3
            obj.hPlot.invoke('ActivateCrossSection', id, boolean);
        end
        function SelectCrossSection(obj, id)
            % Selects one of four available Cross Sections for manipulation.
            % id: 0
            %     1
            %     2
            %     3
            obj.hPlot.invoke('SelectCrossSection', id);
        end
        %% General Methods
        function RotationAngle(obj, angle)
            % Sets the angle of rotation.
            obj.hPlot.invoke('RotationAngle', angle);
        end
        function Rotate(obj, direction)
            % Rotates the plot in the main view. This method has no effect if 2D-Values are plotted.
        	% direction can have one of the following values:
            % ”left” - Rotates the figure to the left
            % ”right” - Rotates the figure to the right
            % ”up” - Rotates the figure upward
            % ”down” - Rotates the figure downward
            % ”clockwise” - Rotates the figure clockwise
            % ”counterclockwise” - Rotates the figure counterclockwise
            obj.hPlot.invoke('Rotate', direction);
        end
        function Update(obj)
            % Updates the plot.
            obj.hPlot.invoke('Update');
        end
        %% Views and Zoom
        function DeleteAllViews(obj)
            % For deletion of all stored views.
            obj.hPlot.invoke('DeleteAllViews');
        end
        function DeleteView(obj, name)
            % Deletes a predefined view.
            obj.hPlot.invoke('DeleteView', name);
        end
        function RestoreView(obj, name)
            % Restores a previously stored view. If one of the reserved view names "Left", "Right", "Front", "Back", "Top", "Bottom" or  "Perspective" or "Nearest Axis" is used, that particular predefined view is set.
            obj.hPlot.invoke('RestoreView', name);
        end
        function StoreView(obj, name, parameters)
            % Stores the view with the specified name and all its settings. 'parameters' contains several parameters that define the view. These parameters represent the internally used transformation and projection matrices. Therefore it is strongly recommended to use this command only by storing the view by using the graphical user interface and then copying this command from the resulting history list item.
            obj.hPlot.invoke('StoreView', name, parameters);
        end
        function StoreView2(obj, name, parameters)
            % Stores additional settings for the view. The parameters string is a list of options separated by spaces: int drawplane, int axis, int cutplaneState, int cutPlaneNormal, double cutplaneCoord, int bBox, int wireframe, int abovePlaneMode.
            obj.hPlot.invoke('StoreView2', name, parameters);
        end
        function ZoomToStructure(obj)
            % The camera zoom is adjusted to have the complete structure nicely fill the screen, as if the user would have pressed the Spacebar or selected View->Change View->Reset View.
            obj.hPlot.invoke('ZoomToStructure');
        end
        function ResetZoom(obj)
            % The camera zoom is reset. The structure, bounding box and the complete working plane (if enabled) is visible.
            obj.hPlot.invoke('ResetZoom');
        end
        %% Export image
        function StoreImage(obj, name, width, height)
            % Stores the contents of the main view into an image file defined by 'name'. Supported types are bmp, jpeg and png.
            obj.hPlot.invoke('StoreImage', name, width, height);
        end
        %% View Options
        function DrawBox(obj, boolean)
            % Shows or hides the bounding box of the whole structure.
            obj.hPlot.invoke('DrawBox', boolean);
        end
        function DrawWorkplane(obj, boolean)
            % Shows or hides the working plane.
            % switch: 'TRUE'
            %         'FALSE'
            obj.hPlot.invoke('DrawWorkplane', boolean);
        end
        function InnerSurfaces(obj, boolean)
            % This setting affects the scene only if a cutplane is defined such that the inside of the structure can be seen. If switch is True then the inner surfaces will be plotted in the same color as the solid. Otherwise they will be plotted in black.
            obj.hPlot.invoke('InnerSurfaces', boolean);
        end
        function SurfaceMesh(obj, boolean)
            % Displays the surface facets' outline of the plotted structure. This method only takes effect if the main view shows the structure. If a tetrahedral mesh is used the surface triangles of this mesh are displayed.
            obj.hPlot.invoke('SurfaceMesh', boolean);
        end
        function WireFrame(obj, boolean)
            % Toggles between two kinds of structure presentations. If switch is True the structure is plotted only by characteristic lines. Otherwise it is plotted as solid.
            obj.hPlot.invoke('WireFrame', boolean);
        end
        function SetGradientBackground(obj, boolean)
            % Activates the gradient background in the main view.
            obj.hPlot.invoke('SetGradientBackground', boolean);
        end
        function bool = GetGradientBackground(obj)
            % Queries whether the gradient background in the main view is active.
            bool = obj.hPlot.invoke('GetGradientBackground');
        end
        function SetBackgroundcolor(obj, r, g, b)
            % Set the background color in the main view.
            obj.hPlot.invoke('SetBackgroundcolor', r, g, b);
        end
        function string = GetBackgroundcolorR(obj)
            % Returns the red component of the background color in the main view.
            string = obj.hPlot.invoke('GetBackgroundcolorR');
        end
        function string = GetBackgroundcolorG(obj)
            % Returns the green component of the background color in the main view.
            string = obj.hPlot.invoke('GetBackgroundcolorG');
        end
        function string = GetBackgroundcolorB(obj)
            % Returns the blue component of the background color in the main view.
            string = obj.hPlot.invoke('GetBackgroundcolorB');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPlot

    end
end

%% Default Settings
% CutPlaneRatio(0.5)
% DrawBox(0)
% InnerSurfaces(1)
% RotationAngle(10.0)
% ShowCutplane(0)
% SurfaceMesh(0)
% WireFrame(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% plot = project.Plot();
%     plot.StoreImage('D:\image.bmp', 1024, 768)
%     plot.StoreImage('D:\image.png', 1024, 768)
%     plot.StoreImage('D:\image.jpeg', 800, 600)
% 
