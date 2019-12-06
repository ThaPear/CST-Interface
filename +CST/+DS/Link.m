%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  
classdef Link < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.DS.Project)
        % Only CST.DS.Project can create a Link object.
        function obj = Link(dsproject, hDSProject)
            obj.dsproject = dsproject;
            obj.hLink = hDSProject.invoke('Link');
        end
    end
    %% CST Object functions.
    methods
        function Create(obj)
            % Creates a new link. All necessary settings for this connection have to be made previously, i.e. source port and target port must be set by some of the methods above. A new node is created for each link end that connects to an already connected pin. If the link has more than two ends, as many new nodes as needed to connect each end are created. They are positioned automatically.
            obj.hLink.invoke('Create');
        end
        function Delete(obj)
            % Deletes a link. All necessary settings for this connection have to be made previously, i.e. source port and target port must be set by some of the methods above.
            obj.hLink.invoke('Delete');
        end
        function bool = DoesExist(obj)
            % Checks if a link with the currently selected settings already exists.
            bool = obj.hLink.invoke('DoesExist');
        end
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.hLink.invoke('Reset');
        end
        %% Getter
        function int = GetBusSize(obj)
            % Returns the bus size of the link. Bus size is the number of electrical connection that the link carries. Non bus links have the bus size 1.
            int = obj.hLink.invoke('GetBusSize');
        end
        function GetSourceComponent(obj, linkendtype)
            % Returns the 3 strings to identify the source component of the link. See SetConnection for a description of the strings.
            obj.hLink.invoke('GetSourceComponent', linkendtype);
        end
        function GetTargetComponent(obj, linkendtype)
            % Returns the 3 strings to identify the target component of the link. See SetConnection for a description of the strings.
            obj.hLink.invoke('GetTargetComponent', linkendtype);
        end
        function bool = HasOrthogonalPath(obj)
            % Checks whether the link has an orthogonal or polygonal path.
            bool = obj.hLink.invoke('HasOrthogonalPath');
        end
        function bool = IsManuallyRouted(obj)
            % Checks if the link was manually routed.
            bool = obj.hLink.invoke('IsManuallyRouted');
        end
        function bool = IsOrthogonalMode(obj)
            % Checks whether new links will be created with an orthogonal or polygonal path.
            bool = obj.hLink.invoke('IsOrthogonalMode');
        end
        %% Setter
        function SetManualRoute(obj, array)
            % Set a specific route for the link. points is an array containing the x and y coordinates of each route point, so the dimension of the array is twice the number of points. The start and end point cannot be set and are always added to the specified points. Additional intermediate points are added if the specified points do not result in an orthogonal route. This method may only be called for a link with exactly two ends.
            obj.hLink.invoke('SetManualRoute', array);
        end
        function SetOrthogonalMode(obj, orthogonal)
            % Specify whether new links should be routed with an orthogonal or polygonal path. This does not change existing links.
            obj.hLink.invoke('SetOrthogonalMode', orthogonal);
        end
        function SetOrthogonalPath(obj, orthogonal)
            % Specify whether the link should be routed with an orthogonal or polygonal path. If this method is not called before creating a link, the default as returned by IsOrthogonalMode is used.
            obj.hLink.invoke('SetOrthogonalPath', orthogonal);
        end
        function SetConnection(obj, endnumber, type, componentname, pinname)
            % Sets a port of a block, an external port or a connection label as port endnumber of
            % the link. componentname is the name of the component as displayed in the Navigation
            % Tree or the properties dialog. For connection labels this is not to be confused with
            % the label that is diplayed on the schematic (this would not be unique). The smallest
            % possible endnumber is 1. All ends of a link need to be connected with an external
            % port, a block port or a connection label. The chosen pin of the component must not be
            % connected already if endnumber is higher than 2.
            %
            % The following component types are supported:
            % Component Type        type    pinname
            % --------------------------------------------------------------------------------------
            % Block                 "B"     Name of the pin as displayed in the schematic. For blocks without visible pin names (e.g. resistors or transistors) use the names that are displayed near the block icon in the online help of the corresponding block, or numbers starting with 1 if the icon does not contain pin names.
            % External Port         "P"     "" to choose the main pin or "ref" to choose the reference pin (only valid for differential external ports).
            % Connection Label      "L"     Not used
            % MATLAB NOTE: If pinname is to be empty, use "" instead of ''
            obj.hLink.invoke('SetConnection', endnumber, type, componentname, pinname);
        end
        %% Positioning
        function Reroute(obj)
            % Recalculates the route of the link. If the link was manually routed before, it will now be automatically routed.
            obj.hLink.invoke('Reroute');
        end
        function SetSourceNodePosition(obj, x, y)
            % Sets the position of the node created at the source end of the link. This has only an effect if the chosen source port is already connected with a link. Possible values are 0 < x, y <100000, i.e. (50000, 50000) is the center of the schematic. It is always ensured that the created node is aligned with the grid, therefore the specified position might get adjusted slightly.
            obj.hLink.invoke('SetSourceNodePosition', x, y);
        end
        function SetTargetNodePosition(obj, x, y)
            % Sets the position of the node created at the target end of the link. This has only an effect if the chosen target port is already connected with a link. Possible values are 0 < x, y <100000, i.e. (50000, 50000) is the center of the schematic. It is always ensured that the created node is aligned with the grid, therefore the specified position might get adjusted slightly.
            obj.hLink.invoke('SetTargetNodePosition', x, y);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hLink

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% %Connect two blocks with an external port
% 
% link = dsproject.Link();
% .Reset
% .SetConnection(1, 'B', 'R1', '2');
% .SetConnection(2, 'B', 'L1', '1');
% .SetConnection(3, 'P', '1', '');
% .Create
% 
% %Set a manual route with five points in total
% 
% Dim points(0 To 5) As String
% points(0) =('50670'); % x(1)
% points(1) =('50200'); % y(1)
% points(2) =('50700'); % x(2)
% points(3) =('50200'); % y(2)
% points(4) =('50700'); % x(3)
% points(5) =('50250'); % y(3)
% .Reset
% .SetConnection(1, 'B', 'R1', '1');
% .SetConnection(2, 'B', 'R2', '1');
% .SetManualRoute(points)
% .Create
