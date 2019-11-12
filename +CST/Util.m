%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Util
    methods(Static)
        function project = InitializeProject()
            project = CST.Application.NewMWS();
            
            project.AddToHistory('ChangeSolverType "HF Frequency Domain"');
            
            %% Set up units.
            units = project.Units();
            units.AllUnits('mm', 'GHz');
            
            project.StoreParameter('c0', Constants.c0*1e3); % mm
            
            %% Set up solver.
            fmin = 11;
            fmax = 33;
            fmesh = 29;
            project.StoreParameter('fmin', fmin);
            project.StoreParameter('fmax', fmax);
            project.StoreParameter('fmesh', fmesh);
            project.StoreParameter('fqwextraspace', fmin);
            project.StoreParameter('nsamplesperGHz', 0);
            
            %% Frequency range and sampling
            solver = project.Solver();
            fdsolver = project.FDSolver();
            solver.FrequencyRange('fmin', 'fmax');
            fdsolver.StartBulkMode();
            fdsolver.ResetSampleIntervals('all');
            % Add a single mesh adaptation sample at fmesh.
            fdsolver.AddSampleInterval('fmesh', '', 1, 'Single', 1);
            fdsolver.AddSampleInterval('fmin', 'fmax', 'nsamplesperGHz * (fmax-fmin) + 1', 'Equidistant', 0);
            fdsolver.AddSampleInterval('', '', '', 'Automatic', 0);
            
            % PML on top.
            fdsolver.SetOpenBCTypeTet('PML');
            fdsolver.EndBulkMode();
            
            %% Set up mesh adaptation settings
            meshadaption3d = project.MeshAdaption3D();
            meshadaption3d.SetType('HighFrequencyTet');
            meshadaption3d.MinPasses(6);
            meshadaption3d.MaxPasses(50);
            
            %% Set up boundaries.
            boundary = project.Boundary();
            boundary.AllBoundaries('periodic', 'periodic', ...   % x
                                   'periodic', 'periodic', ...   % y
                                   'electric', 'expanded open'); % z
            
            boundary.MinimumDistanceType('Fraction');
            boundary.MinimumDistancePerWavelengthNewMeshEngine(4)
            boundary.MinimumDistanceReferenceFrequencyType('User');
            boundary.FrequencyForMinimumDistance('fqwextraspace');
%             boundary.SetAbsoluteDistance(25);

            project.StoreParameter('aa_theta', 0);
            project.StoreParameter('aa_phi', 0);
            boundary.PeriodicUseConstantAngles(1);
            boundary.SetPeriodicBoundaryAngles('aa_theta', 'aa_phi');
%             boundary.YPeriodicShift('phi');

            material = project.Material();
            material.Reset();
            material.Name('Transparent');
            material.Colour(1, 1, 1);
            material.Transparency(75);
            material.Create();

            % Set Background material to normal instead of PEC.
            material = project.Material();
            material.Reset();
            material.Type('Normal');
            material.ChangeBackgroundMaterial();

            %% Enable bounding box rendering.
            plot = project.Plot();
            plot.DrawBox(1);
            plot.DrawWorkplane(0);
            
            %% Rotate the view.
            plot.RestoreView('Bottom');
            plot.RotationAngle(30); plot.Rotate('Right');
            plot.RotationAngle(15); plot.Rotate('Down');
            plot.Update();
            
            %% Set shape accuracy
            solid = project.Solid();
            solid.ShapeVisualizationAccuracy2('120')
            
%             plot.ZoomToStructure();
            
            %% Enable Y and Z matrix calculation.
            postprocess1d = project.PostProcess1D();
            postprocess1d.ActivateOperation('YZ-matrices', 1);
            
        end
        
        function ExportResult(project, resultname, exportfilename)
            plot1d = project.Plot1D();
            asciiexport = project.ASCIIExport();
            
            project.SelectTreeItem(resultname);
            
            plot1d.PlotView('real');
            asciiexport.Reset();
            asciiexport.FileName([exportfilename, '.real']);
            asciiexport.Execute();
            plot1d.PlotView('imaginary');
            asciiexport.Reset();
            asciiexport.FileName([exportfilename, '.imag']);
            asciiexport.Execute();
        end
        
        function XPolCancellation(project, port1, port2, frequency, theta, phi)
            %%
            if(frequency >= 1e9)
                frequency = frequency / 1e9;
            end
            
            plot1d = project.Plot1D();
            
            plot1d.DeleteAllMarker();
            plot1d.XMarker(1);
            plot1d.XMarkerPos(60);
%             plot1d.ShowMarkerAtMax();
            plot1d.Plot();
            
            resultname = sprintf('Farfields\\farfield (f=%i) [%i]\\Ludwig 3 Horizontal', frequency, port1);
            project.SelectTreeItem(resultname);
            p1_hor = inputdlgex('Enter value shown in CST.');
            if(isempty(p1_hor)); return; end
            
            resultname = sprintf('Farfields\\farfield (f=%i) [%i]\\Ludwig 3 Hor. Phase', frequency, port1);
            project.SelectTreeItem(resultname);
            p1_horphase = inputdlgex('Enter value shown in CST.');
            if(isempty(p1_horphase)); return; end
            
            resultname = sprintf('Farfields\\farfield (f=%i) [%i]\\Ludwig 3 Horizontal', frequency, port2);
            project.SelectTreeItem(resultname);
            p2_hor = inputdlgex('Enter value shown in CST.');
            if(isempty(p2_hor)); return; end
            
            resultname = sprintf('Farfields\\farfield (f=%i) [%i]\\Ludwig 3 Hor. Phase', frequency, port2);
            project.SelectTreeItem(resultname);
            p2_horphase = inputdlgex('Enter value shown in CST.');
            if(isempty(p2_horphase)); return; end
            
            p1_hor = str2double(p1_hor{:});
            p1_horphase = str2double(p1_horphase{:});
            p2_hor = str2double(p2_hor{:});
            p2_horphase = str2double(p2_horphase{:});
            
            fprintf('Amplitude: %.15g / %.15g = \n%.15g\nPhase: 180 - (%.15g - %.15g) = \n%.15g\n', p2_hor, p1_hor, p2_hor / p1_hor, p2_horphase, p1_horphase, mod(180-(p2_horphase - p1_horphase), 360));
        end
    end
end