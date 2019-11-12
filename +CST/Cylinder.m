%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Authors: Alexander van Katwijk                                      %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Authors: Alexander van Katwijk, Cyrus Tirband                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object is used to create a new cylinder shape.
classdef Cylinder < handle
    properties
        project
        hCylinder
        history
        
        name
        componentname
        materialname
        axis
        outerradius
        innerradius
        xcenter, ycenter, zcenter
        xmin, xmax
        ymin, ymax
        zmin, zmax
        segments
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Cylinder object.
        function obj = Cylinder(project, hProject)
            obj.project = project;
            obj.hCylinder = hProject.invoke('Cylinder');
            
            obj.Reset();
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            % Creates a new cylinder. All necessary settings for this
            % cylinder have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = [ 'With Cylinder', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define cylinder ', obj.componentname, ':', obj.name], obj.history);
            obj.history = [];
        end
        function CreateConditional(obj, condition)
            % Creates a new cylinder. All necessary settings for this
            % cylinder have to be made previously.
            %
            % condition: An string of an expression that evaluates to True 
            %            or False
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = [ 'If ', condition, ' Then', newline, ...
                                'With Cylinder', newline, ...
                                    obj.history, ...
                                'End With', newline, ...
                            'End If'];
            obj.project.AddToHistory(['define cylinder ', obj.componentname, ':', obj.name], obj.history);
            obj.history = [];
        end
        function CreateForLoop(obj, counter, startval, endval, step)
            % Creates a new cylinder. All necessary settings for this
            % cylinder have to be made previously.
            %
            % counter: String name of the counter variable
            % startval: Start value of the counter
            % endval: End value of the counter
            % step [optional]: Step of the counter
            obj.AddToHistory(['.Create']);
            
            % No step by default.
            stepString = '';
            if(nargin == 5)
                stepString = [' Step ', num2str(step)];
            end
            
            % Prepend With and append End With
            obj.history = [ 'Dim ', counter, newline, ...
                            'For ', counter, ' = ', num2str(startval), ' To ', num2str(endval), stepString, newline, ...
                                'With Cylinder', newline, ...
                                    obj.history, ...
                                'End With', newline, ...
                            'Next ', counter];
            obj.project.AddToHistory(['define cylinder ', obj.componentname, ':', obj.name], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.componentname = '';
            obj.materialname = 'Vacuum';
            obj.axis = 'z';
            obj.innerradius = 0;    obj.outerradius = 0;
            obj.xmin = 0; obj.xmax = 0;
            obj.ymin = 0; obj.ymax = 0;
            obj.zmin = 0; obj.zmax = 0;
            obj.xcenter = 0;
            obj.ycenter = 0;
            obj.zcenter = 0;
            obj.segments = 0;
        end
        function Name(obj, name)
            % Sets the name of the cylinder.
            obj.AddToHistory(['.Name "', name, '"']);
            obj.name = name;
        end
        function Component(obj, componentname)
            % Sets the name of the component for the new cylinder. The
            % component must already exist.
            obj.AddToHistory(['.Component "', componentname, '"']);
            obj.componentname = componentname;
        end
        function Material(obj, materialname)
            % Sets the material name for the new cylinder. The material
            % must already exist.
            obj.AddToHistory(['.Material "', materialname, '"']);
            obj.materialname = materialname;
        end
        function Axis(obj, axis)
            % Sets the axis of the cylinder. According to this setting,
            % either Xrange, Yrange or Zrange need to be set for the
            % extension of the cylinder along the axis.
            % axis: 'x'
            %       'y'
            %       'z'
            obj.AddToHistory(['.Axis "', axis, '"']);
            obj.axis = axis;
        end
        function Outerradius(obj, outerradius)
            % Sets the outer radius of the cylinder.
            obj.AddToHistory(['.Outerradius "', num2str(outerradius), '"']);
            obj.outerradius = outerradius;
        end
        function Innerradius(obj, innerradius)
            % Sets the inner radius of the cylinder. This setting may be
            % set to zero to define a solid cylinder.
            obj.AddToHistory(['.Innerradius "', num2str(innerradius), '"']);
            obj.innerradius = innerradius;
        end
        
        function Xcenter(obj, xcenter)
            % Sets the x- or u-coordinate of the center point of the bottom
            % face of the cylinder, depending on whether a local coordinate
            % system is active or not.
            obj.AddToHistory(['.Xcenter "', num2str(xcenter), '"']);
            obj.xcenter = xcenter;
        end
        
        function Ycenter(obj, ycenter)
            % Sets the y- or v-coordinate of the center point of the bottom
            % face of the cylinder, depending on whether a local coordinate
            % system is active or not.
            obj.AddToHistory(['.Ycenter "', num2str(ycenter), '"']);
            obj.ycenter = ycenter;
        end
        
        function Zcenter(obj, zcenter)
            % Sets the z- or w-coordinate of the center point of the bottom
            % face of the cylinder, depending on whether a local coordinate
            % system is active or not.
            obj.AddToHistory(['.Zcenter "', num2str(zcenter), '"']);
            obj.zcenter = zcenter;
        end
        function Xrange(obj, xmin, xmax)
            % Sets the bounds for the x- or u-coordinate extensions of the
            % new cylinder depending on whether a local coordinate system
            % is active or not. This setting is only used if the axis is
            % set to "x".
            obj.AddToHistory(['.Xrange "', num2str(xmin), '", '...
                                      '"', num2str(xmax), '"']);
            obj.xmin = xmin;
            obj.xmax = xmax;
        end
        function Yrange(obj, ymin, ymax)
            % Sets the bounds for the y- or v-coordinate extensions of the
            % new cylinder depending on whether a local coordinate system
            % is active or not. This setting is only used if the axis is
            % set to "y".
            obj.AddToHistory(['.Yrange "', num2str(ymin), '", '...
                                      '"', num2str(ymax), '"']);
            obj.ymin = ymin;
            obj.ymax = ymax;
        end
        function Zrange(obj, zmin, zmax)
            % Sets the bounds for the z- or w-coordinate extensions of the
            % new cylinder depending on whether a local coordinate system
            % is active or not. This setting is only used if the axis is
            % set to "z".
            obj.AddToHistory(['.Zrange "', num2str(zmin), '", '...
                                      '"', num2str(zmax), '"']);
            obj.zmin = zmin;
            obj.zmax = zmax;
        end
        function Segments(obj, segments)
            % This setting specifies how the cylinder's geometry is
            % modelled, either as a smooth surface of by a facetted
            % approximation. If this value is set to 0, an analytical
            % (smooth) representation of the cylinder will be created. If
            % this number is set to another value greater than 2, the
            % cylinder's face will be approximated by this number of planar
            % facets. The higher the number of segments, the better the
            % representation of the cylinder will be.
            obj.AddToHistory(['.Segments "', num2str(segments), '"']);
            obj.segments = segments;
        end
    end
end

%% Default Settings
% Material('Vacuum')
% Innerradius(0)
% Xcenter(0)
% Ycenter(0)
% Zcenter(0)
% Xrange(0, 0)
% Yrange(0, 0)
% Zrange(0, 0)
% Segments(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% cylinder = project.Cylinder();
%     cylinder.Reset();
%     cylinder.Name('cylinder1');
%     cylinder.Component('component1');
%     cylinder.Material('PEC');
%     cylinder.Axis('z');
%     cylinder.Outerradius (1.5)
%     cylinder.Innerradius (0.5)
%     cylinder.Xcenter(2)
%     cylinder.Ycenter(1)
%     cylinder.Zcenter(0)
%     cylinder.Zrange(0, 'a+3');
%     cylinder.Segments(0)
%     cylinder.Create();