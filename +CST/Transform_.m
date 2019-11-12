%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Suppress warnings:
% "Use of backets [] is unnecessary. Use parentheses to group, if needed."
%#ok<*NBRAK>
classdef Transform_ < handle
    properties(SetAccess = protected)
        project
        hTransform
        history
        
        names
        usepickedpoints
        invertpickedpoints
        multipleobjects
        groupobjects
        origin
        xcenter, ycenter, zcenter
        xvector, yvector, zvector
        xscale, yscale, zscale
        xangle, yangle, zangle
        xplanenormal, yplanenormal, zplanenormal
        repetitions
        componentname
        materialname
        multipleselection
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Transform object.
        function obj = Transform_(project, hProject)
            obj.project = project;
            obj.hTransform = hProject.invoke('Transform');
            
            obj.Reset();
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function obj = Transform(obj, objecttype, transform)
            % objecttype: Curve, Shape, FFS, Port, CurrentDistribution,
            %             Part
            % transform: Translate, Rotate, Scale, Mirror
            % Executes the given transform.
            % Should be called last.
            
            obj.AddToHistory(['.Transform "', objecttype, '", "', transform, '"']);
            
            % Prepend With and append End With
            obj.history = ['With Transform', newline, obj.history, 'End With'];
            if(length(obj.names) == 1)
                obj.project.AddToHistory(['transform: ', transform, ' ', obj.names{1}], obj.history);
            else
                obj.project.AddToHistory(['transform: ', transform, ' ', obj.names{1}, ' and ', num2str(length(obj.names)-1), ' others'], obj.history);
            end
            obj.history = [];
        end
        
        function Reset(obj)
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.names = {};
            obj.usepickedpoints = 0;
            obj.invertpickedpoints = 0;
            obj.multipleobjects = 0;
            obj.groupobjects = 0;
            obj.origin = 'ShapeCenter';
            obj.xcenter = 0; obj.ycenter = 0; obj.zcenter = 0;
            obj.xvector = 0; obj.yvector = 0; obj.zvector = 0;
            obj.xscale  = 0; obj.yscale  = 0; obj.zscale  = 0;
            obj.xangle  = 0; obj.yangle  = 0; obj.zangle  = 0;
            obj.xplanenormal = 0; obj.yplanenormal = 0; obj.zplanenormal = 0;
            obj.repetitions = 1;
            obj.componentname = '';
            obj.materialname = '';
            obj.multipleselection = 0;
        end
        function Name(obj, name)
            % Removes all previous names specified using AddName
            obj.names = {name};
            
            obj.AddToHistory(['.Name "', name, '"']);
        end
        function AddName(obj, name)
            % Allows transformation of multiple shapes.
            obj.names = [obj.names, {name}];
            
            obj.AddToHistory(['.AddName "', name, '"']);
        end
        function UsePickedPoints(obj, boolean)
            obj.usepickedpoints = boolean;
            
            obj.AddToHistory(['.UsePickedPoints "', num2str(boolean), '"']);
        end
        function InvertPickedPoints(obj, boolean)
            obj.invertpickedpoints = boolean;
            
            obj.AddToHistory(['.InvertPickedPoints "', num2str(boolean), '"']);
        end
        function MultipleObjects(obj, boolean)
            % Copy shape, keeping original
            obj.multipleobjects = boolean;
            
            obj.AddToHistory(['.MultipleObjects "', num2str(boolean), '"']);
        end
        function GroupObjects(obj, boolean)
            obj.groupobjects = boolean;
            
            obj.AddToHistory(['.GroupObjects "', num2str(boolean), '"']);
        end
        function Origin(obj, origin)
            % ShapeCenter, CommonCenter, Free
            obj.origin = origin;
            
            obj.AddToHistory(['.Origin "', origin, '"']);
        end
        function Center(obj, xcenter, ycenter, zcenter)
            % Only works if Origin is set to 'Free'
            obj.xcenter = xcenter;
            obj.ycenter = ycenter;
            obj.zcenter = zcenter;
            
            obj.AddToHistory(['.Center "', num2str(xcenter, '%.15g'), '", '...
                                      '"', num2str(ycenter, '%.15g'), '", '...
                                      '"', num2str(zcenter, '%.15g'), '"']);
        end
        function Vector(obj, xvector, yvector, zvector)
            obj.xvector = xvector;
            obj.yvector = yvector;
            obj.zvector = zvector;
            
            obj.AddToHistory(['.Vector "', num2str(xvector, '%.15g'), '", '...
                                      '"', num2str(yvector, '%.15g'), '", '...
                                      '"', num2str(zvector, '%.15g'), '"']);
        end
        function ScaleFactor(obj, xscale, yscale, zscale)
            obj.xscale = xscale;
            obj.yscale = yscale;
            obj.zscale = zscale;
            
            obj.AddToHistory(['.ScaleFactor "', num2str(xscale, '%.15g'), '", '...
                                           '"', num2str(yscale, '%.15g'), '", '...
                                           '"', num2str(zscale, '%.15g'), '"']);
        end
        function Angle(obj, xangle, yangle, zangle)
            obj.xangle = xangle;
            obj.yangle = yangle;
            obj.zangle = zangle;
            
            obj.AddToHistory(['.Angle "', num2str(xangle, '%.15g'), '", '...
                                     '"', num2str(yangle, '%.15g'), '", '...
                                     '"', num2str(zangle, '%.15g'), '"']);
        end
        function PlaneNormal(obj, xplanenormal, yplanenormal, zplanenormal)
            obj.xplanenormal = xplanenormal;
            obj.yplanenormal = yplanenormal;
            obj.zplanenormal = zplanenormal;
            
            obj.AddToHistory(['.PlaneNormal "', num2str(xplanenormal, '%.15g'), '", '...
                                           '"', num2str(yplanenormal, '%.15g'), '", '...
                                           '"', num2str(zplanenormal, '%.15g'), '"']);
        end
        function Repetitions(obj, repetitions)
            obj.repetitions = repetitions;
            
            obj.AddToHistory(['.Repetitions "', num2str(repetitions), '"']);
        end
        function Component(obj, componentname)
            % Can be specified to move the translated object to another
            % component. Target component must already exist.
            obj.componentname = componentname;
            
            obj.AddToHistory(['.Component "', componentname, '"']);
        end
        function Material(obj, materialname)
            % Sets the material of the new object.
            obj.materialname = materialname;
            
            obj.AddToHistory(['.Material "', materialname, '"']);
        end
        function MultipleSelection(obj, boolean)
            obj.multipleselection = boolean;
            
            obj.AddToHistory(['.MultipleSelection "', num2str(boolean), '"']);
        end
    end
end

%      .PlaneNormal "1", "0", "0" 
% Example translate
% With Transform 
%      .Reset 
%      .Name "cmp" 
%      .Vector "2*p", "0", "0" 
%      .UsePickedPoints "False" 
%      .InvertPickedPoints "False" 
%      .MultipleObjects "True" 
%      .GroupObjects "True" 
%      .Repetitions "1" 
%      .MultipleSelection "False" 
%      .Destination "" 
%      .Material "" 
%      .Transform "Shape", "Translate" 
% End With 



% Default settings.
% UsePickedPoints (False)
% InvertPickedPoints (False)
% MultipleObjects (False)
% GroupObjects (False)
% Origin ("ShapeCenter")