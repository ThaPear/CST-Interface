%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Authors: Alexander van Katwijk, Cyrus Tirband                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Port < handle
    properties(SetAccess = protected)
        project
        hPort
        history
        
        label
        portnumber
        numberofmodes
        adjustpolarization
        polarizationangle
        referenceplanedistance
        textsize
        coordinates
        orientation
        portonbound
        clippickedporttobound
        x1, x2
        y1, y2
        z1, z2
        
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Port object.
        function obj = Port(project, hProject)
            obj.project = project;
            obj.hPort = hProject.invoke('Port');
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = ['With Port', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define port: ', num2str(obj.portnumber)], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            obj.label = '';
            obj.portnumber = '';
            obj.numberofmodes = '1';
            obj.adjustpolarization = 0;
            obj.polarizationangle = '0';
            obj.referenceplanedistance = '0';
            obj.textsize = '50';
            obj.coordinates = 'Free';
            obj.orientation = 'zmin';
            obj.portonbound = 0;
            obj.clippickedporttobound = 0;
            obj.x1 = 0; obj.x2 = 0;
            obj.y1 = 0; obj.y2 = 0;
            obj.z1 = 0; obj.z2 = 0;
        end
        
        function Delete(obj, portnumber)
%             obj.project.AddToHistory(['delete port: port', num2str(obj.portnumber)], ['Port.Delete "', num2str(portnumber), '"']);
            obj.project.AddToHistory(['Port.Delete "', num2str(portnumber), '"']);
        end
        
        function numberOfPorts = StartPortNumberIteration(obj)
            numberOfPorts = obj.hPort.invoke('StartPortNumberIteration');
        end
        
        function number = GetNextPortNumber(obj)
            
            number = obj.hPort.invoke('GetNextPortNumber');
        end
        function label = GetLabel(obj, portnumber)
            
            label = obj.hPort.invoke('GetLabel', portnumber);
        end
        
        function PortNumber(obj, portnumber)
            obj.portnumber = portnumber;
            obj.AddToHistory(['.PortNumber "', num2str(portnumber), '"']);     
        end
        

        function NumberOfModes(obj, numberofmodes)
            obj.numberofmodes = numberofmodes;
            
            obj.AddToHistory(['.NumberOfModes "', num2str(numberofmodes), '"']);
        end
        
        function AdjustPolarization(obj, boolean)
            obj.adjustpolarization = boolean;
            
            obj.AddToHistory(['.AdjustPolarization "', num2str(boolean), '"']);
        end
        function ReferencePlaneDistance(obj, referenceplanedistance)
            obj.referenceplanedistance = referenceplanedistance;
            
            obj.AddToHistory(['.ReferencePlaneDistance "', num2str(referenceplanedistance), '"']);
        end
        function PolarizationAngle(obj, polarizationangle)
            obj.polarizationangle = polarizationangle;
            
            obj.AddToHistory(['.PolarizationAngle "', num2str(polarizationangle), '"']);
        end
        function TextSize(obj, textsize)
            obj.TextSize = textsize;
            
            obj.AddToHistory(['.TextSize "', num2str(textsize), '"']);
        end
        function Coordinates(obj, coordinates)
            %'Free','Full' or 'Picks'
            %free is defined by Xrange, Yrange, Zrange,
            %full is entire bounding box
            %picks uses picks
            obj.coordinates = coordinates;
            
            obj.AddToHistory(['.Coordinates "', coordinates, '"']);
        end
        function Orientation(obj, orientation)
            %'xmin', 'xmax', 'ymin', 'ymax', 'zmin', or 'zmax'
            obj.orientation = orientation;
            
            obj.AddToHistory(['.Orientation "', orientation, '"']);
        end
        function PortOnBound(obj, boolean)
            obj.portonbound = boolean;
            
            obj.AddToHistory(['.PortOnBound "', num2str(boolean), '"']);
        end
        function ClipPickedPortToBound(obj, boolean)
            obj.clippickedporttobound = boolean;
            
            obj.AddToHistory(['.ClipPickedPortToBound "', num2str(boolean), '"']);
        end
        function Xrange(obj, x1, x2)
            obj.x1 = x1;
            obj.x2 = x2;
            
            obj.AddToHistory(['.Xrange "', num2str(x1), '", '...
                '"', num2str(x2), '"']);
        end
        function Yrange(obj, y1, y2)
            obj.y1 = y1;
            obj.y2 = y2;
            
            obj.AddToHistory(['.Yrange "', num2str(y1), '", '...
                '"', num2str(y2), '"']);
        end
        function Zrange(obj, z1, z2)
            obj.z1 = z1;
            obj.z2 = z2;
            
            obj.AddToHistory(['.Zrange "', num2str(z1), '", '...
                '"', num2str(z2), '"']);
        end
    end
end

