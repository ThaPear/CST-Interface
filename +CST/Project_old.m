%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Project < handle
    properties(SetAccess = protected)
        hProject
    end
    properties(Access = protected)
        analyticalcurve         CST.AnalyticalCurve
        arc                     CST.Arc
        asciiexport             CST.ASCIIExport
        blendcurve              CST.BlendCurve
        boundary                CST.Boundary
        brick                   CST.Brick
        component               CST.Component
        curve                   CST.Curve
        cylinder                CST.Cylinder
        discretefaceport        CST.DiscreteFacePort
        evaluatefieldalongcurve CST.EvaluateFieldAlongCurve
        extrude                 CST.Extrude
        extrudecurve            CST.ExtrudeCurve
        fdsolver                CST.FDSolver
        floquetport             CST.FloquetPort
        group                   CST.Group
        line                    CST.Line
        loft                    CST.Material
        material                CST.Material
        meshadaption3d          CST.MeshAdaption3D
        meshsettings            CST.MeshSettings
        monitor                 CST.Monitor
        pick                    CST.Pick
        plot                    CST.Plot
        plot1d                  CST.Plot1D
        polygon                 CST.Polygon
        polygon3d               CST.Polygon3D
        port                    CST.Port
        postprocess1d           CST.PostProcess1D
        rectangle               CST.Rectangle
        solid                   CST.Solid
        solver                  CST.Solver
        touchstone              CST.Touchstone
        tracefromcurve          CST.TraceFromCurve
        transform               CST.Transform_
        units                   CST.Units
        wcs                     CST.WCS
    end
    
    methods(Access = ?CST.Application)
        function obj = Project(hProject)
            switch(nargin)
                case 1
                    obj.hProject = hProject;
                otherwise
                    cst = CST.Application.GetHandle();
                    obj.hProject = cst.invoke('NewMWS');
            end
        end
    end
    
    methods
        function Backup(obj, backupfilename)
            % Creates a backup of the current project under the given
            % filename. Current project is unaffected.
            obj.hProject.invoke('Backup', backupfilename);
        end
        
        function Quit(obj)
            obj.hProject.invoke('Quit');
        end
        
        function Save(obj)
            obj.hProject.invoke('Save');
        end
        
        function SaveAs(obj, filename, includeresults)
            % includeresults: boolean
            obj.hProject.invoke('SaveAs', filename, includeresults);
        end
        
        function StoreParameter(obj, parametername, value)
            obj.hProject.invoke('StoreParameter', parametername, value);
        end
        
        function DeleteParameter(obj, parametername)
            obj.hProject.invoke('DeleteParameter', parametername);
        end
        
        function value = RestoreParameter(obj, parametername)
            % Returns the value of the specified parameter.
            value = obj.hProject.invoke('RestoreParameter', parametername);
        end
        
        function MakeSureParameterExists(obj, parametername, value)
            obj.hProject.invoke('MakeSureParameterExists', parametername, value);
        end
        
        function RunMacro(obj, macroname)
            obj.AddToHistory(['Project.RunMacro "', macroname, '"']);
        end
        
        function success = SelectTreeItem(obj, itemname)
            success = obj.hProject.invoke('SelectTreeItem', itemname);
        end
        
        function DeleteResults(obj)
            obj.hProject.invoke('DeleteResults');
        end
        
        function success = Rebuild(obj)
            % Rebuilds the project from the history list.
            success = obj.hProject.invoke('Rebuild');
        end
        
        function success = RebuildOnParametricChange(obj, fullrebuild, showerrormsgbox)
            % If bfullRebuild is True the complete history list is
            % processed instead of only those blocks which are affected by
            % the parametric change.
            % If bShowErrorMsgBox is set False no message box is shown in
            % case of an error.
            % Returns True if the rebuild was successful.
            success = obj.hProject.invoke('RebuildOnParametricChange', fullrebuild, showerrormsgbox);
        end
        
        function ret = AddToHistory(obj, name, command)
            if(nargin == 2)
                command = name;
            end
            ret = obj.hProject.invoke('AddToHistory', name, command);
            if(~ret)
                breakpoint;
                error(['Could not execute command ', newline, '''', name, ''', ', newline, '''', command, '''']);
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% All components.
        function analyticalcurve = AnalyticalCurve(obj)
            if(isempty(obj.analyticalcurve))
                obj.analyticalcurve = CST.AnalyticalCurve(obj, obj.hProject);
            end
            analyticalcurve = obj.analyticalcurve;
        end
        
        function arc = Arc(obj)
            if(isempty(obj.arc))
                obj.arc = CST.Arc(obj, obj.hProject);
            end
            arc = obj.arc;
        end
        
        function asciiexport = ASCIIExport(obj)
            if(isempty(obj.asciiexport))
                obj.asciiexport = CST.ASCIIExport(obj, obj.hProject);
            end
            asciiexport = obj.asciiexport;
        end
        
        function blendcurve = BlendCurve(obj)
            if(isempty(obj.blendcurve))
                obj.blendcurve = CST.BlendCurve(obj, obj.hProject);
            end
            blendcurve = obj.blendcurve;
        end
        
        function boundary = Boundary(obj)
            if(isempty(obj.boundary))
                obj.boundary = CST.Boundary(obj, obj.hProject);
            end
            boundary = obj.boundary;
        end
        
        function brick = Brick(obj)
            if(isempty(obj.brick))
                obj.brick = CST.Brick(obj, obj.hProject);
            end
            brick = obj.brick;
        end
        
        function component = Component(obj)
            if(isempty(obj.component))
                obj.component = CST.Component(obj, obj.hProject);
            end
            component = obj.component;
        end
        
        function curve = Curve(obj)
            if(isempty(obj.curve))
                obj.curve = CST.Curve(obj, obj.hProject);
            end
            curve = obj.curve;
        end
        
        function cylinder = Cylinder(obj)
            if(isempty(obj.cylinder))
                obj.cylinder = CST.Cylinder(obj, obj.hProject);
            end
            cylinder = obj.cylinder;
        end
        
        function discretefaceport = DiscreteFacePort(obj)
            if(isempty(obj.discretefaceport))
                obj.discretefaceport = CST.DiscreteFacePort(obj, obj.hProject);
            end
            discretefaceport = obj.discretefaceport;
        end
        function evaluatefieldalongcurve = EvaluateFieldAlongCurve(obj)
            if(isempty(obj.evaluatefieldalongcurve))
                obj.evaluatefieldalongcurve = CST.EvaluateFieldAlongCurve(obj, obj.hProject);
            end
            evaluatefieldalongcurve = obj.evaluatefieldalongcurve;
        end
        
        function extrude = Extrude(obj)
            if(isempty(obj.extrude))
                obj.extrude = CST.Extrude(obj, obj.hProject);
            end
            extrude = obj.extrude;
        end
        
        function extrudecurve = ExtrudeCurve(obj)
            if(isempty(obj.extrudecurve))
                obj.extrudecurve = CST.ExtrudeCurve(obj, obj.hProject);
            end
            extrudecurve = obj.extrudecurve;
        end
        
        function fdsolver = FDSolver(obj)
            if(isempty(obj.fdsolver))
                obj.fdsolver = CST.FDSolver(obj, obj.hProject);
            end
            fdsolver = obj.fdsolver;
        end
        
        function floquetport = FloquetPort(obj)
            if(isempty(obj.floquetport))
                obj.floquetport = CST.FloquetPort(obj, obj.hProject);
            end
            floquetport = obj.floquetport;
        end
        
        function group = Group(obj)
            if(isempty(obj.group))
                obj.group = CST.Group(obj, obj.hProject);
            end
            group = obj.group;
        end
        
        function line = Line(obj)
            if(isempty(obj.line))
                obj.line = CST.Line(obj, obj.hProject);
            end
            line = obj.line;
        end
        function loft = Loft(obj)
            if(isempty(obj.loft))
                obj.loft = CST.Loft(obj, obj.hProject);
            end
            loft = obj.loft;
        end
        
        function material = Material(obj)
            if(isempty(obj.material))
                obj.material = CST.Material(obj, obj.hProject);
            end
            material = obj.material;
        end
        
        function meshadaption3d = MeshAdaption3D(obj)
            if(isempty(obj.meshadaption3d))
                obj.meshadaption3d = CST.MeshAdaption3D(obj, obj.hProject);
            end
            meshadaption3d = obj.meshadaption3d;
        end
        
        function meshsettings = MeshSettings(obj)
            if(isempty(obj.meshsettings))
                obj.meshsettings = CST.MeshSettings(obj, obj.hProject);
            end
            meshsettings = obj.meshsettings;
        end
        
        function monitor = Monitor(obj)
            if(isempty(obj.monitor))
                obj.monitor = CST.Monitor(obj, obj.hProject);
            end
            monitor = obj.monitor;
        end
        
        function pick = Pick(obj)
            if(isempty(obj.pick))
                obj.pick = CST.Pick(obj, obj.hProject);
            end
            pick = obj.pick;
        end
        
        function plot = Plot(obj)
            if(isempty(obj.plot))
                obj.plot = CST.Plot(obj, obj.hProject);
            end
            plot = obj.plot;
        end
        
        function plot1d = Plot1D(obj)
            if(isempty(obj.plot1d))
                obj.plot1d = CST.Plot1D(obj, obj.hProject);
            end
            plot1d = obj.plot1d;
        end
        
        function polygon = Polygon(obj)
            if(isempty(obj.polygon))
                obj.polygon = CST.Polygon(obj, obj.hProject);
            end
            polygon = obj.polygon;
        end
        
        function polygon3d = Polygon3D(obj)
            if(isempty(obj.polygon3d))
                obj.polygon3d = CST.Polygon3D(obj, obj.hProject);
            end
            polygon3d = obj.polygon3d;
        end
        
        function port = Port(obj)
            if(isempty(obj.port))
                obj.port = CST.Port(obj, obj.hProject);
            end
            port = obj.port;
        end
        
        function postprocess1d = PostProcess1D(obj)
            if(isempty(obj.postprocess1d))
                obj.postprocess1d = CST.PostProcess1D(obj, obj.hProject);
            end
            postprocess1d = obj.postprocess1d;
        end
        
        function rectangle = Rectangle(obj)
            if(isempty(obj.rectangle))
                obj.rectangle = CST.Rectangle(obj, obj.hProject);
            end
            rectangle = obj.rectangle;
        end
        
        function solid = Solid(obj)
            if(isempty(obj.solid))
                obj.solid = CST.Solid(obj, obj.hProject);
            end
            solid = obj.solid;
        end
        
        function solver = Solver(obj)
            if(isempty(obj.solver))
                obj.solver = CST.Solver(obj, obj.hProject);
            end
            solver = obj.solver;
        end
        
        function touchstone = Touchstone(obj)
            if(isempty(obj.touchstone))
                obj.touchstone = CST.Touchstone(obj, obj.hProject);
            end
            touchstone = obj.touchstone;
        end
        
        function tracefromcurve = TraceFromCurve(obj)
            if(isempty(obj.tracefromcurve))
                obj.tracefromcurve = CST.TraceFromCurve(obj, obj.hProject);
            end
            tracefromcurve = obj.tracefromcurve;
        end
        
        function transform = Transform(obj)
            if(isempty(obj.transform))
                obj.transform = CST.Transform_(obj, obj.hProject);
            end
            transform = obj.transform;
        end
        
        function units = Units(obj)
            if(isempty(obj.units))
                obj.units = CST.Units(obj, obj.hProject);
            end
            units = obj.units;
        end
        
        function wcs = WCS(obj)
            if(isempty(obj.wcs))
                obj.wcs = CST.WCS(obj, obj.hProject);
            end
            wcs = obj.wcs;
        end
    end
end