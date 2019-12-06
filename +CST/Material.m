%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Suppress warnings:
% "Use of backets [] is unnecessary. Use parentheses to group, if needed."
%#ok<*NBRAK>
classdef Material < handle
    properties(SetAccess = protected)
        project
        hMaterial
        history
        
        materials
        
        name
        folder
        type
        r, g, b
        transparency
        epsilon
        epsilonx, epsilony, epsilonz
        mu
        mux, muy, muz
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Material object.
        function obj = Material(project, hProject)
            obj.project = project;
            obj.hMaterial = hProject.invoke('Material');
            
            obj.Reset();
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = ['With Material', newline, obj.history, 'End With'];
            if(~isempty(obj.folder))
                obj.project.AddToHistory(['define material: ', obj.folder, '/', obj.name, ''], obj.history);
            else
                obj.project.AddToHistory(['define material: ', obj.name], obj.history);
            end
            obj.history = [];
        end
        function CreateConditional(obj, condition)
            % Creates a new material. All necessary settings for this material have to be made previously.
            %
            % condition: A string of a VBA expression that evaluates to True or False
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = [ 'If ', condition, ' Then', newline, ...
                                'With Material', newline, ...
                                    obj.history, ...
                                'End With', newline, ...
                            'End If'];
            if(~isempty(obj.folder))
                obj.project.AddToHistory(['define conditional material: ', obj.folder, '/', obj.name, ''], obj.history);
            else
                obj.project.AddToHistory(['define conditional material: ', obj.name], obj.history);
            end
            obj.history = [];
        end
        function ChangeBackgroundMaterial(obj)
            obj.AddToHistory(['.ChangeBackgroundMaterial']);
            
            % Prepend With and append End With
            obj.history = ['With Material', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define background'], obj.history);
            obj.history = [];
        end 
        
        function Reset(obj)
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.folder = '';
            obj.type = 'Normal';
            obj.r = 0; obj.g = 1; obj.b = 1;
            obj.transparency = 0;
            obj.epsilon = 1;
            obj.epsilonx = 1; obj.epsilony = 1; obj.epsilonz = 1;
            obj.mu = 1;
            obj.mux = 1; obj.muy = 1; obj.muz = 1;
        end
        function Rename(obj, oldname, newname)
            obj.project.AddToHistory(['rename material: ', oldname, ' to: ', newname], ...
                                     ['Material.Rename "', oldname, '", "', newname, '"']);
        end
        function NewFolder(obj, name)
            obj.project.AddToHistory(['new material folder: ', name], ...
                                     ['Material.NewFolder "', name, '"']);
        end
        function DeleteFolder(obj, name)
            obj.project.AddToHistory(['delete material folder: ', name], ...
                                     ['Material.DeleteFolder "', name, '"']);
        end
        function RenameFolder(obj, oldname, newname)
            obj.project.AddToHistory(['rename material folder: ', oldname, ' to: ', newname], ...
                                     ['Material.RenameFolder "', oldname, '", "', newname, '"']);
        end
        function number = GetNumberOfMaterials(obj)
            number = obj.hMaterial.invoke('GetNumberOfMaterials');
        end
        function Name(obj, name)
            obj.name = name;
            
            obj.AddToHistory(['.Name "', name, '"']);
        end
        function Folder(obj, folder)
            obj.folder = folder;
            
            obj.AddToHistory(['.Folder "', folder, '"']);
        end
        function Type(obj, type)
            obj.type = type;
            
            obj.AddToHistory(['.Type "', type, '"']);
        end
        function Delete(obj, name)
            obj.project.AddToHistory(['.Delete "', name, '"']);
        end
        function Colour(obj, r, g, b)
            if(isnumeric(r) && (r > 1 || g > 1 || b > 1))
                r = r / 255;
                g = g / 255;
                b = b / 255;
            end
            obj.r = r;
            obj.g = g;
            obj.b = b;
            
            obj.AddToHistory(['.Colour "', num2str(r, '%.15g'), '", '...
                                      '"', num2str(g, '%.15g'), '", '...
                                      '"', num2str(b, '%.15g'), '"']);
        end
        function Transparency(obj, transparency)
            obj.transparency = transparency;
            if(transparency < 1)
                % It's either 0 or it is a ratio, so convert to %.
                transparency = transparency * 100;
            end
            
            obj.AddToHistory(['.Transparency "', num2str(transparency), '"']);
        end
        function Epsilon(obj, epsilon)
            obj.epsilon = epsilon;
            
            obj.AddToHistory(['.Epsilon "', num2str(epsilon, '%.15g'), '"']);
        end
        function Mue(obj, mu)
            obj.mu = mu;
            
            obj.AddToHistory(['.Mue "', num2str(mu, '%.15g'), '"']);
        end
        function boolean = Exists(obj, name)
            % Name should include folder, e.g. 'folder1/mat1'
            boolean = obj.hMaterial.invoke('Exists', name);
        end
        function AddDispersionFittingValueEps(obj, f, realeps, imageps_or_tangent, weight)
            obj.AddToHistory(['.AddDispersionFittingValueEps "', num2str(f, '%.15g'), '", '...
                                                            '"', num2str(realeps, '%.15g'), '", '...
                                                            '"', num2str(imageps_or_tangent, '%.15g'), '", '...
                                                            '"', num2str(weight, '%.15g'), '"']);
        end
        function AddDispersionFittingValueMu(obj, f, realmu, imagmu_or_tangent, weight)
            obj.AddToHistory(['.AddDispersionFittingValueMu "', num2str(f, '%.15g'), '", '...
                                                            '"', num2str(realmu, '%.15g'), '", '...
                                                            '"', num2str(imagmu_or_tangent, '%.15g'), '", '...
                                                            '"', num2str(weight, '%.15g'), '"']);
        end
        function AddDispersionFittingValueXYZEps(obj, f, realx, imx, realy, imy, realz, imz, weight)
            obj.AddToHistory(['.AddDispersionFittingValueXYZEps "', num2str(f, '%.15g'), '", '...
                                                               '"', num2str(realx, '%.15g'), '", '...
                                                               '"', num2str(imx, '%.15g'), '", '...
                                                               '"', num2str(realy, '%.15g'), '", '...
                                                               '"', num2str(imy, '%.15g'), '", '...
                                                               '"', num2str(realz, '%.15g'), '", '...
                                                               '"', num2str(imz, '%.15g'), '", '...
                                                               '"', num2str(weight, '%.15g'), '"']);
        end
        function AddDispersionFittingValueXYZMu(obj, f, realx, imx, realy, imy, realz, imz, weight)
            obj.AddToHistory(['.AddDispersionFittingValueXYZMu "', num2str(f, '%.15g'), '", '...
                                                              '"', num2str(realx, '%.15g'), '", '...
                                                              '"', num2str(imx, '%.15g'), '", '...
                                                              '"', num2str(realy, '%.15g'), '", '...
                                                              '"', num2str(imy, '%.15g'), '", '...
                                                              '"', num2str(realz, '%.15g'), '", '...
                                                              '"', num2str(imz, '%.15g'), '", '...
                                                              '"', num2str(weight, '%.15g'), '"']);
        end
        function DispersiveFittingFormatEps(obj, format)
            % format: Real_Imag, Real_Tand
            obj.AddToHistory(['.DispersiveFittingFormatEps "', format, '"']);
        end
        function DispersiveFittingFormatMu(obj, format)
            % format: Real_Imag, Real_Tand
            obj.AddToHistory(['.DispersiveFittingFormatEps "', format, '"']);
        end
        function DispersiveFittingSchemeEps(obj, scheme)
            % scheme: 'Conductivity', '1st Order', '2nd Order', 'Nth Order'
            obj.AddToHistory(['.DispersiveFittingSchemeEps "', scheme, '"']);
        end
        function DispersiveFittingSchemeMu(obj, scheme)
            % scheme: 'Conductivity', '1st Order', '2nd Order', 'Nth Order'
            obj.AddToHistory(['.DispersiveFittingSchemeMu "', scheme, '"']);
        end
        function UseGeneralDispersionEps(obj, boolean)
            obj.AddToHistory(['.UseGeneralDispersionEps "', num2str(boolean), '"']);
        end
        function UseGeneralDispersionMu(obj, boolean)
            obj.AddToHistory(['.UseGeneralDispersionMu "', num2str(boolean), '"']);
        end
    end
end

% Default settings.
% .Type ("Normal")
% .Colour ("0", "1", "1")
% .Wireframe ("False")
% .Transparency ("0")
% .Epsilon ("1.0")
% .Mue ("1.0")
% .Rho ("0.0")
% .Sigma ("0.0")
% .TanD ("0.0")
% .TanDFreq ("0.0")
% .TanDGiven ("False")
% .TanDModel ("ConstTanD")
% .SigmaM ("0.0")
% .TanDM ("0.0")
% .TanDMFreq ("0.0")
% .TanDMGiven ("False")
% .DispModelEps ("None")
% .DispModelMue ("None")
% .MueInfinity ("1.0")
% .EpsInfinity ("1.0")
% .DispCoeff1Eps ("0.0")
% .DispCoeff2Eps ("0.0")
% .DispCoeff3Eps ("0.0")
% .DispCoeff4Eps ("0.0")
% .DispCoeff1Mue ("0.0")
% .DispCoeff2Mue ("0.0")
% .DispCoeff3Mue ("0.0")
% .DispCoeff4Mue ("0.0")
% .AddDispEpsPole1stOrder ("0.0", "0.0")
% .AddDispEpsPole2ndOrder ("0.0", "0.0", "0.0", "0.0")
