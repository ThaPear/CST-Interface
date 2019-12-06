%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object is used to create a new polygon3D curve item.
classdef Polygon3D < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Polygon3D object.
        function obj = Polygon3D(project, hProject)
            obj.project = project;
            obj.hPolygon3D = hProject.invoke('Polygon3D');
            obj.history = [];
        end
    end
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function Name(obj, polygon3Dname)
            % Sets the name of the polygon3D.
            obj.AddToHistory(['.Name "', num2str(polygon3Dname, '%.15g'), '"']);
            obj.name = polygon3Dname;
        end
        function Curve(obj, curvename)
            % Sets the name of the curve for the new polygon3D curve item. The curve must already exist.
            obj.AddToHistory(['.Curve "', num2str(curvename, '%.15g'), '"']);
            obj.curve = curvename;
        end
        function Point(obj, xCoord, yCoord, zCoord)
            % Sets the coordinates for a point the polygon3D exist of.
            obj.AddToHistory(['.Point "', num2str(xCoord, '%.15g'), '", '...
                                     '"', num2str(yCoord, '%.15g'), '", '...
                                     '"', num2str(zCoord, '%.15g'), '"']);
            obj.point.xCoord = xCoord;
            obj.point.yCoord = yCoord;
            obj.point.zCoord = zCoord;
        end
        function Create(obj)
            % Creates a new polygon3D curve item. All necessary settings for this polygon3D have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Polygon3D and append End With
            obj.history = [ 'With Polygon3D', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define polygon3d: ', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPolygon3D
        history

        name
        curve
        point
    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% polygon3d = project.Polygon3D();
%     polygon3d.Reset
%     polygon3d.Name('3dpolygon1');
%     polygon3d.Curve('curve1');
%     polygon3d.Point('2', 'a+2', '2');
%     polygon3d.Point('4.5', '-5', '2');
%     polygon3d.Point('8.78', '-6.6', '0');
%     polygon3d.Create
% End With  
