%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Authors: Alexander van Katwijk, Cyrus Tirband                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Pick < handle
    properties(SetAccess = protected)
        project
        hPick
        history
        id
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Pick object.
        function obj = Pick(project, hProject)
            obj.project = project;
            obj.hPick = hProject.invoke('Pick');
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, command, newline];
        end
        
        function PickEdgeFromId(obj, shapename, edge_id, vertex_id)
            obj.project.AddToHistory(['Pick.PickEdgeFromId "', shapename, '", '...
                '"', num2str(edge_id), '", '...
                '"', num2str(vertex_id), '"']);
        end
        function PickCurveEndpointFromId(obj, curvename, name, vertex_id)
            obj.AddToHistory(['Pick.PickCurveEndpointFromId "', curvename, ':', ...
                name, '", "', num2str(vertex_id), '"']);
            % Prepend With and append End With
            obj.project.AddToHistory(['define pick: ', num2str(obj.id)], obj.history);
            obj.history = [];
        end
        function PickEndpointFromId(obj, componentname, name, vertex_id)
            obj.AddToHistory(['Pick.PickEndpointFromId "', componentname, ':', ...
                name, '", "', num2str(vertex_id), '"']);
            obj.project.AddToHistory(['define pick: ', num2str(obj.id)], obj.history);
            obj.history = [];
        end
        function PickFaceFromId(obj, componentname, name, face_id)
            obj.project.AddToHistory(['Pick.PickFaceFromId "', componentname, ':', ...
                name, '", "', num2str(face_id), '"']);
        end
        
        function NextPickToDataBase(obj, id)
            obj.id = id;
            obj.AddToHistory(['Pick.NextPickToDataBase "', num2str(id),'"']);
        end
        
    end
end
