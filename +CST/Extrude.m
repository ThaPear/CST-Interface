%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Authors: Alexander van Katwijk                                      %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Authors: Alexander van Katwijk, Cyrus Tirband                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Extrude < handle
    properties
        project
        hExtrude
        history
        
        name
        componentname
        material
        mode
        height
        originx, originy, originz
        uvectoru, uvectorv, uvectorw
        vvectoru, vvectorv, vvectorw
        pointu, pointv
        linetou, linetov
        rlineu, rlinev
        taper
        twist
        usepicksforheight
        pickheightdeterminedbyfirstface
        numberofpickedfaces
        deletebasefacesolid
        clearpickedface
        simplifyactive
        simplifyminpointsarc
        simplifyminpointscircle
        simplifyangle
        simplifyadjacenttol
        simplifyradiustol
        simplifyangletang
        simplifyedgelength
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Extrude object.
        function obj = Extrude(project, hProject)
            obj.project = project;
            obj.hExtrude = hProject.invoke('Extrude');
            obj.Reset();
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            % Creates a new extruded solid. All necessary settings for this
            % element have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = ['With Extrude', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define extrude: ', obj.componentname, ':', obj.name], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            % Resets all internal settings.
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.componentname = '';
            obj.material = 'Vacuum';
            obj.mode = 'pointlist';
            obj.usepicksforheight = 0;
            obj.pickheightdeterminedbyfirstface = 1;
            obj.deletebasefacesolid = 0;
            obj.simplifyactive = 0;
            obj.simplifyminpointsarc = 3;
            obj.simplifyminpointscircle = 5;
            obj.simplifyangle = 0;
            obj.simplifyadjacenttol = 1;
            obj.simplifyradiustol = 0;
            obj.simplifyangletang = 1;
            obj.simplifyedgelength = 0;
        end
        function Name(obj, name)
            % Sets the name of the extrude Object.
            obj.AddToHistory(['.Name "', name, '"']);
            obj.name = name;
        end
        function Component(obj, componentname)
            % Sets the component for the new Solid. The component must
            % already exist.
            obj.AddToHistory(['.Component "', componentname, '"']);
            obj.componentname = componentname;
        end
        function Material(obj, material)
            % Sets the material for the new Solid. The material must
            % already exist.
            obj.AddToHistory(['.Material "', material, '"']);
            obj.material = material;
        end
        function Mode(obj, mode)
            % Selects whether a profile or a surface is to be extruded.
            % mode: 'pointlist' - A profile defined by points is to be
            %                     extruded.
            %       'picks' - A picked face is to be extruded.
            %       'multiplepicks' - Multiple picked faces are to be
            %                         extruded.
            obj.AddToHistory(['.Mode "', mode, '"']);
            obj.mode = mode;
        end
        function Height(obj, height)
            % Defines the height of the extruded solid.
            obj.AddToHistory(['.Height "', num2str(height), '"']);
            obj.height = height;
        end
        function Origin(obj, x, y, z)
            % Defines the location of the origin.
            obj.AddToHistory(['.Origin "', num2str(x), '", '...
                                      '"', num2str(y), '", '...
                                      '"', num2str(z), '"']);
            obj.originx = x;
            obj.originy = y;
            obj.originz = z;
        end
        function Uvector(obj, u, v, w)
            % These settings define the plane on which the profile will be
            % defined. u, v, w are related on the current working
            % coordinate system.
            obj.AddToHistory(['.Uvector "', num2str(u), '", '...
                                       '"', num2str(v), '", '...
                                       '"', num2str(w), '"']);
            obj.uvectoru = u;
            obj.uvectorv = v;
            obj.uvectorw = w;
        end
        function Vvector(obj, u, v, w)
            % These settings define the plane on which the profile will be
            % defined. u, v, w are related on the current working
            % coordinate system.
            obj.AddToHistory(['.Vvector "', num2str(u), '", '...
                                       '"', num2str(v), '", '...
                                       '"', num2str(w), '"']);
            obj.vvectoru = u;
            obj.vvectorv = v;
            obj.vvectorw = w;
        end
        function Point(obj, u, v)
            % Sets the first point of the to be defined profile. This
            % setting has an effect only if Mode is set to ”pointlist”.
            obj.AddToHistory(['.Vvector "', num2str(u), '", '...
                                       '"', num2str(v), '"']);
            obj.pointu = u;
            obj.pointv = v;
        end
        function LineTo(obj, u, v)
            % Sets a line from the point previously defined to the point
            % defined by u, v here. u and v specify a location in absolute
            % coordinates in the actual working coordinate system. This
            % line will be a part of the profile to be rotated/extruded. To
            % finisch a profile, the last line has to end on the values
            % defined by the Point Method. This setting has an effect only,
            % if Mode  is set to ”pointlist”.
            obj.AddToHistory(['.LineTo "', num2str(u), '", '...
                                      '"', num2str(v), '"']);
            obj.linetou = u;
            obj.linetov = v;
        end
        function RLine(obj, u, v)
            % Sets a line from the point previously defined to the point
            % defined by u, v here. u and v specify a location relative to
            % the previous point in the current working coordinate sytem.
            % This line will be a part of the profile to be
            % rotated/extruded. To finisch a profile, the last line has to
            % end on the values defined by the Point Method. This setting
            % has an effect only, if Mode is set to ”pointlist”.
            obj.AddToHistory(['.RLine "', num2str(u), '", '...
                                     '"', num2str(v), '"']);
            obj.rlineu = u;
            obj.rlinev = v;
        end
        function Taper(obj, taper)
            % Defines a value of how much the to be extruded face is
            % enlarged during extrusion.
            obj.AddToHistory(['.Taper "', num2str(taper), '"']);
            obj.taper = taper;
        end
        function Twist(obj, twist)
            % Twists the solid around the direction of extrusion. The
            % parameter tw defines the angle in degree of how much the
            % solid will be twisted.
            obj.AddToHistory(['.Twist "', num2str(twist), '"']);
            obj.twist = twist;
        end
        function UsePicksForHeight(obj, boolean)
            % Use a previously picked point for the height of the
            % extrusion.
            obj.AddToHistory(['.UsePicksForHeight "', num2str(boolean), '"']);
            obj.usepicksforheight = boolean;
        end
        function PickHeightDeterminedByFirstFace(obj, boolean)
            % For multiple picked faces and a picked point that is used for
            % calculating the height: If true, the height that is
            % calculated for the first picked face will be applied to all
            % created shapes. If false, for each picked face, the height
            % will be calculated to meet the picked point.
            obj.AddToHistory(['.PickHeightDeterminedByFirstFace "', num2str(boolean), '"']);
            obj.pickheightdeterminedbyfirstface = boolean;
        end
        function NumberOfPickedFaces(obj, number)
            % If the mode is "multiplepicks", the number of picked faces is
            % set here.
            obj.AddToHistory(['.NumberOfPickedFaces "', num2str(number), '"']);
            obj.numberofpickedfaces = number;
        end
        function DeleteBaseFaceSolid(obj, boolean)
            % Deletes the face used for the extrusion.
            obj.AddToHistory(['.DeleteBaseFaceSolid "', num2str(boolean), '"']);
            obj.deletebasefacesolid = boolean;
        end
        function ClearPickedFace(obj, boolean)
            % Cleares the picked face after the extrude command.
            obj.AddToHistory(['.ClearPickedFace "', num2str(boolean), '"']);
            obj.clearpickedface = boolean;
        end
        function ModifyHeight(obj)
            % Changes the solid to the previously specified settings.
            % NOTE: This might invalidate some MATLAB-side stored settings.
            obj.AddToHistory(['.ModifyHeight']);
        end
        function SetSimplifyActive(obj, boolean)
            % Set this option to enable the polygon simplification.
            obj.AddToHistory(['.SetSimplifyActive "', num2str(boolean), '"']);
            obj.simplifyactive = boolean;
        end
        function SetSimplifyMinPointsArc(obj, npoints)
            % Minimum number of segments needed to recognize an arc. Must
            % be >= 3.
            obj.AddToHistory(['.SetMinimumPointsArc "', num2str(npoints), '"']);
            obj.simplifyminpointsarc = npoints;
        end
        function SetSimplifyMinPointsCircle(obj, npoints)
            % Minimum number of segments needed for complete circles. Must
            % be > 'SetSimplifyMinPointsArc' and at least 5.
            obj.AddToHistory(['.SetSimplifyMinPointsCircle "', num2str(npoints), '"']);
            obj.simplifyminpointscircle = npoints;
        end
        function SetSimplifyAngle(obj, angle)
            % The maximum angle in degrees between two adjacent segments.
            % All smaller angles will be considered to be simplified. The
            % angle is only used for arcs and not for circles.
            obj.AddToHistory(['.SetSimplifyAngle "', num2str(angle), '"']);
            obj.simplifyangle = angle;
        end
        function SetSimplifyAdjacentTol(obj, angle)
            % Is only used by the simplification algorithm to find a good
            % starting point for arcs. It means the maximum angular
            % difference in the angle of adjacent segments. A good value
            % for this parameter will be 1.0.
            obj.AddToHistory(['.SetSimplifyAdjacentTol "', num2str(angle), '"']);
            obj.simplifyadjacenttol = angle;
        end
        function SetSimplifyRadiusTol(obj, deviation)
            % This means the maximum deviation in percent the distance a
            % segment end point can have to the current definition of the
            % simplification circle center point. The tolerance is used for
            % circles and arcs.
            obj.AddToHistory(['.SetSimplifyRadiusTol "', num2str(deviation), '"']);
            obj.simplifyradiustol = deviation;
        end
        function SetSimplifyAngleTang(obj, angle)
            % Maximum angular tolerance in radians used when deciding to
            % create the arc tangential or not to its adjacent line
            % segments. If an angle is beneath the specified value, the arc
            % is build tangential to the neighbor edge.
            obj.AddToHistory(['.SetSimplifyAngleTang "', num2str(angle), '"']);
            obj.simplifyangletang = angle;
        end
        function SetSimplifyEdgeLength(obj, length)
            % Edges smaller than the defined length will be removed. Can be
            % used to remove tiny fragments.
            obj.AddToHistory(['.SetSimplifyEdgeLength "', num2str(length), '"']);
            obj.simplifyedgelength = length;
        end
    end
end

%% Default Settings
% Mode('pointlist')
% UsePicksForHeight(0)
% PickHeightDeterminedByFirstFace(1)
% DeleteBaseFaceSolid(0)
% ClearPickedFace(0)
% Material('default')
% Component('default')
% SetSimplifyActive(0)
% SetSimplifyMinPointsArc(3)
% SetSimplifyMinPointsCircle(5)
% SetSimplifyAngle(0.0)
% SetSimplifyAdjacentTol(1.0)
% SetSimplifyRadiusTol(0.0)
% SetSimplifyAngleTang(1.0)
% SetSimplifyEdgeLength(0.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% extrude = project.Extrude();
%      extrude.Reset();
%      extrude.Name('solid2');
%      extrude.Component('component1');
%      extrude.Material('Vacuum');
%      extrude.Mode('Picks');
%      extrude.Height('2+b');
%      extrude.Twist(0.0);
%      extrude.Taper(5);
%      extrude.UsePicksForHeight(False);
%      extrude.DeleteBaseFaceSolid(False);
%      extrude.ClearPickedFace(True);
%      extrude.Create();