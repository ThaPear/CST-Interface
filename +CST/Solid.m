%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Solid < handle
    properties(SetAccess = protected)
        project
        hSolid
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Solid object.
        function obj = Solid(project, hProject)
            obj.project = project;
            obj.hSolid = hProject.invoke('Solid');
        end
    end
    
    methods
        function Delete(obj, solidname)
            obj.project.AddToHistory(['Solid.Delete "', solidname, '"']);
        end
        function Rename(obj, oldname, newname)
            obj.project.AddToHistory(['Solid.Rename "', oldname, '", "', newname, '"']);
        end
        function ChangeMaterial(obj, solidname, materialname)
            obj.project.AddToHistory(['Solid.ChangeMaterial "', solidname, '", "', materialname, '"']);
        end
        function Add(obj, solidname1, solidname2)
            % Solid names are specified as 'component1:brick1'
            obj.project.AddToHistory(['Solid.Add "', solidname1, '", "', solidname2, '"']);
        end
        function Insert(obj, solidname1, solidname2)
            % Solid names are specified as 'component1:brick1'
            obj.project.AddToHistory(['Solid.Insert "', solidname1, '", "', solidname2, '"']);
        end
        function Intersect(obj, solidname1, solidname2)
            % Solid names are specified as 'component1:brick1'
            obj.project.AddToHistory(['Solid.Intersect "', solidname1, '", "', solidname2, '"']);
        end
        function Subtract(obj, solidname1, solidname2)
            % Solid names are specified as 'component1:brick1'
            % Subtracts solid 2 from solid 1.
            obj.project.AddToHistory(['Solid.Subtract "', solidname1, '", "', solidname2, '"']);
        end
        function MergeMaterialsOfComponent(obj, solidname)
            % Must specify the name of the solid to merge into.
            % e.g. 'component1:metal1'
            % Will merge all object in the same component with the same
            % material into the specified object.
            obj.project.AddToHistory(['Solid.MergeMaterialsOfComponent "', solidname, '"']);
        end
        function ShapeVisualizationAccuracy2(obj, accuracy)
            obj.project.AddToHistory(['Solid.ShapeVisualizationAccuracy2 "', num2str(accuracy), '"']);
        end
        function ShapeVisualizationOffset(obj, offset)
            obj.project.AddToHistory(['Solid.ShapeVisualizationOffset "', num2str(offset), '"']);
        end
    end
end
