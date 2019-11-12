%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Authors: Alexander van Katwijk, Cyrus Tirband                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef ExtrudeCurve < handle
    properties
        project
        hExtrudeCurve
        history
        
        name
        componentname
        material
        thickness
        twistangle
        taperangle
        curvename
        deleteprofile
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.AnalyticalCurve object.
        function obj = ExtrudeCurve(project, hProject)
            obj.project = project;
            obj.hExtrudeCurve = hProject.invoke('ExtrudeCurve');
            obj.Reset();
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            % Creates a new solid. All necessary settings for this solid
            % have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = ['With ExtrudeCurve', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['extrude curve: ', obj.curvename, ' from: ', obj.componentname, ':', obj.name], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.componentname = '';
            obj.material = 'Vacuum';
            obj.thickness = 0;
            obj.twistangle = 0;
            obj.taperangle = 0;
            obj.curvename = '';
        end
        function Name(obj, name)
            % Sets the name of the new solid.
            obj.AddToHistory(['.Name "', name, '"']);
            obj.name = name;
        end
        function Component(obj, componentname)
            % Sets the name of the component for the new solid. The
            % component must already exist.
            obj.AddToHistory(['.Component "', componentname, '"']);
            obj.componentname = componentname;
        end
        function Material(obj, material)
            % Sets the material name for the new solid. The material must
            % already exist.
            obj.AddToHistory(['.Material "', material, '"']);
            obj.material = material;
        end
        function Thickness(obj, thickness)
            % Sets the thickness which the extrude operation will take
            % place. Thus it determines the extension of the resulting
            % solid shape. Negative thickness settings will result in an
            % extrusion into the opposite direction.
            obj.AddToHistory(['.Thickness "', num2str(thickness), '"']);
            obj.thickness = thickness;
        end
        function Twistangle(obj, twistangle)
            % Sets the angle to twist the created shape around the
            % direction of the extrusion.
            obj.AddToHistory(['.Twistangle "', num2str(twistangle), '"']);
            obj.twistangle = twistangle;
        end
        function Taperangle(obj, taperangle)
            % Sets the angle to taper the created shape along the direction
            % of the extrusion. A negative angle will taper the shape, a
            % positive angle will flare the shape.
            obj.AddToHistory(['.Taperangle "', num2str(taperangle), '"']);
            obj.taperangle = taperangle;
        end
        
        function Curve(obj, curvename)
            % The name of the curve item the new solid should be created.
            % The correct format for the name should be
            % 'curvename:curveitemname' (see the example below). If the
            % curve item (e.g. a line) is connected with an other curve
            % item (e.g. a polygon) both curve items will be transformed
            % into the new solid.
            obj.AddToHistory(['.Curve "', curvename, '"']);
            obj.curvename = curvename;
        end
        
        function DeleteProfile(obj, boolean)
            % No information on this function is provided in the CST
            % documentation.
            obj.AddToHistory(['.DeleteProfile "', num2str(boolean), '"']);
            obj.deleteprofile = boolean;
        end
    end
end

%% Default Settings
% Material('Vacuum')
% Thickness(0.0)
% Twistangle(0.0)
% Taperangle(0.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% extrudecurve = project.ExtrudeCurve();
%      extrudecurve.Reset();
%      extrudecurve.Name('solid2');
%      extrudecurve.Component('component1');
%      extrudecurve.Material('Vacuum');
%      extrudecurve.Thickness(2);
%      extrudecurve.Twistangle(0.0);
%      extrudecurve.Taperangle(0.0);
%      extrudecurve.Curve('curve1:circle1');
%      extrudecurve.Create();