% CST Interface - Interface with CST from MATLAB.
% Copyright (C) 2020 Alexander van Katwijk
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK> 

% Defines the settings for the farfield plots and recalculates the farfield plot if necessary.
classdef FarfieldPlot < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.FarfieldPlot object.
        function obj = FarfieldPlot(project, hProject)
            obj.project = project;
            obj.hFarfieldPlot = hProject.invoke('FarfieldPlot');
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
            % Resets all internal values to their default settings.
            obj.AddToHistory(['.Reset']);
        end
        function ResetPlot(obj)
            % Deletes all in-memory plotting data. This forces a complete reload of the current farfield result.
            obj.AddToHistory(['.ResetPlot']);
        end
        function Plottype(obj, type)
            % Defines the type of the farfield plot.
            % type can have one of the following values:
            % polar
            % Plots the farfield with one coordinate varying and one fixed as a polar plot. Underneath the plot there will be shown some secondary coefficients like main lobe direction, 3dB-angular width and side lobe suppression.
            % cartesian
            % Plots the farfield with one coordinate varying and one fixed as a cartesian plot.
            % 2d
            % Plots the farfield with both coordinates varying as a 2D plot with each point colored according to its field value (see the color bar below the plot).
            % 3d
            % Plots the farfield with both coordinates varying as a 3D plot.
            obj.AddToHistory(['.Plottype "', num2str(type, '%.15g'), '"']);
            obj.plottype = type;
        end
        function Vary(obj, varyAngle)
            % Varies the first or the second coordinate respectively if  the plot type is set to "polar" or "cartesian" using Plottype. The coordinate type depends on the active coordinate system:
            % Name
            % Angle 1
            % Angle 2
            % Spherical
            % Theta
            % Phi
            % Ludwig 2 AE
            % Elevation
            % Azimuth
            % Ludwig 2 EA
            % Alpha
            % Epsilon
            % Ludwig 3
            % Theta
            % Phi
            % varyAngle: 'angle1'
            %            'angle2'
            obj.AddToHistory(['.Vary "', num2str(varyAngle, '%.15g'), '"']);
            obj.vary = varyAngle;
        end
        function Phi(obj, angleInDegree)
            % Sets the constant value for the second angle (e.g. phi), if the Vary method is set to "angle1".
            % Please note: angleInDegree must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.Phi "', num2str(angleInDegree, '%.15g'), '"']);
            obj.phi = angleInDegree;
        end
        function Theta(obj, angleInDegree)
            % Sets the constant value for the first angle (e.g. theta), if the Vary method is set to "angle2".
            % Please note: angleInDegree must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.Theta "', num2str(angleInDegree, '%.15g'), '"']);
            obj.theta = angleInDegree;
        end
        function Step(obj, angleInDegree)
            % Sets the theta step width used to calculate the farfield plot. Step sizes need to be a divisor of 180°. A checking mechanism automatically reduces the entered step size if this criterion is not met.
            % Please note: angleInDegree must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.Step "', num2str(angleInDegree, '%.15g'), '"']);
            obj.step = angleInDegree;
        end
        function Step2(obj, angleInDegree)
            % Sets the phi step width used to calculate the farfield plot. Step sizes need to be a divisor of 180°. A checking mechanism automatically reduces the entered step size if this criterion is not met.
            % Please note: angleInDegree must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.Step2 "', num2str(angleInDegree, '%.15g'), '"']);
            obj.step2 = angleInDegree;
        end
        function SetLockSteps(obj, bFlag)
            % Enforce a common step width for theta step and phi step.
            obj.AddToHistory(['.SetLockSteps "', num2str(bFlag, '%.15g'), '"']);
            obj.setlocksteps = bFlag;
        end
        function SetPlotRangeOnly(obj, bFlag)
            % Activates the phi and theta plot range.
            obj.AddToHistory(['.SetPlotRangeOnly "', num2str(bFlag, '%.15g'), '"']);
            obj.setplotrangeonly = bFlag;
        end
        function SetThetaStart(obj, angleInDegree)
            % Sets the lower bound of the displayed theta range.
            % Please note: angleInDegree must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.SetThetaStart "', num2str(angleInDegree, '%.15g'), '"']);
            obj.setthetastart = angleInDegree;
        end
        function SetThetaEnd(obj, angleInDegree)
            % Sets the upper bound of the displayed theta range.
            % Please note: angleInDegree must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.SetThetaEnd "', num2str(angleInDegree, '%.15g'), '"']);
            obj.setthetaend = angleInDegree;
        end
        function SetPhiStart(obj, angleInDegree)
            % Sets the lower bound of the displayed phi range.
            % Please note: angleInDegree must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.SetPhiStart "', num2str(angleInDegree, '%.15g'), '"']);
            obj.setphistart = angleInDegree;
        end
        function SetPhiEnd(obj, angleInDegree)
            % Sets the upper bound of the displayed phi range.
            % Please note: angleInDegree must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.SetPhiEnd "', num2str(angleInDegree, '%.15g'), '"']);
            obj.setphiend = angleInDegree;
        end
        function UseFarfieldApproximation(obj, bFlag)
            % Enables or disables the farfield approximation. If disabled, the farfield calculation is more accurate in areas close to the antenna. On the other hand computation time increases if farfield approximation is disabled.
            obj.AddToHistory(['.UseFarfieldApproximation "', num2str(bFlag, '%.15g'), '"']);
            obj.usefarfieldapproximation = bFlag;
        end
        function SetMultipolNumber(obj, nmax)
            % Restricts the maximal order of the plotted multipoles to nmax. If the calculated number of multipol orders is smaller, then nmax is ignored. This setting affects only broadband farfields.
            obj.AddToHistory(['.SetMultipolNumber "', num2str(nmax, '%.15g'), '"']);
            obj.setmultipolnumber = nmax;
        end
        function SetFrequency(obj, frequency)
            % Sets the farfield plot frequency. This setting affects only broadband farfields.
            obj.AddToHistory(['.SetFrequency "', num2str(frequency, '%.15g'), '"']);
            obj.setfrequency = frequency;
        end
        function SetTime(obj, time)
            % Sets the desired time for a transient farfield plot. time does not include the delay due to the finite distance to the farfield origin. This setting affects only broadband farfields.
            obj.AddToHistory(['.SetTime "', num2str(time, '%.15g'), '"']);
            obj.settime = time;
        end
        function SetTimeDomainFF(obj, bFlag)
            % This setting switches from the farfield calculation to the transient field display. This setting affects only broadband farfields.
            obj.AddToHistory(['.SetTimeDomainFF "', num2str(bFlag, '%.15g'), '"']);
            obj.settimedomainff = bFlag;
        end
        function SetMovieSamples(obj, Nsamples)
            % Sets the number of movie samples used for the broadband farfield animation. Set Nsamples equal to zero to use the frequency samples of the broadband monitor as a default value.
            obj.AddToHistory(['.SetMovieSamples "', num2str(Nsamples, '%.15g'), '"']);
            obj.setmoviesamples = Nsamples;
        end
        function Plot(obj)
            % Starts the farfield calculation if necessary and refreshes the plot window.
            obj.AddToHistory(['.Plot']);
        end
        function StoreSettings(obj)
            % Applies all farfield plot specific settings without refreshing the plot window.
            obj.AddToHistory(['.StoreSettings']);
            
            % Prepend With FarfieldPlot and append End With
            obj.history = [ 'With FarfieldPlot', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define FarfieldPlot'], obj.history);
            obj.history = [];
        end
        function ASCIIExportSummary(obj, fileName)
            % This method offers ASCII file export of the summarized settings concerning the farfield plot (array pattern, monitor name, component, plot type, step angle, frequency) as well as the most important farfield values characterizing the current calculation (radiation efficiency, total efficiency, maximum directivity, maximum gain). The summary is saved to a file named fileName.
            obj.AddToHistory(['.ASCIIExportSummary "', num2str(fileName, '%.15g'), '"']);
            obj.asciiexportsummary = fileName;
        end
        function ASCIIExportVersion(obj, version)
            % Use this method to select the ascii export version to maintain compatibility. However, older ascii export versions may not support all features. Supported versions are 2009 and 2010.
            obj.AddToHistory(['.ASCIIExportVersion "', num2str(version, '%.15g'), '"']);
            obj.asciiexportversion = version;
        end
        function ASCIIExportAsSource(obj, fileName)
            % This method creates a farfield source from the selected farfield plot (2D/3D plot type only). The data are saved to a file named fileName. This file can be used for defining a farfield excitation.
            obj.AddToHistory(['.ASCIIExportAsSource "', num2str(fileName, '%.15g'), '"']);
            obj.asciiexportassource = fileName;
        end
        function ASCIIExportAsBroadbandSource(obj, fileName)
            % This method creates a broadband farfield source from the selected farfield plot (2D/3D plot type only). Other farfield results generated by the same excitation are automatically collected and merged into the farfield source file.
            obj.AddToHistory(['.ASCIIExportAsBroadbandSource "', num2str(fileName, '%.15g'), '"']);
            obj.asciiexportasbroadbandsource = fileName;
        end
        function CopyFarfieldTo1DResults(obj, ResultFolder, ResultName)
            % Copies the active 1D farfield to the subfolder ResultFolder in the 1D Results folder using the name ResultName. If empty strings are passed a default folder and/or a default name is derived from the farfield settings.
            obj.AddToHistory(['.CopyFarfieldTo1DResults "', num2str(ResultFolder, '%.15g'), '", '...
                                                       '"', num2str(ResultName, '%.15g'), '"']);
            obj.copyfarfieldto1dresults.ResultFolder = ResultFolder;
            obj.copyfarfieldto1dresults.ResultName = ResultName;
        end
        function IncludeUnitCellSidewalls(obj, flag)
            % This method affects the farfield calculation for periodic and unit cell boundaries. If flag is true, the farfield integration considers periodic and unit cell boundaries like open boundaries. Otherwise, these side wall contributions are ignored, and the aperture field comprises the open and Floquet port boundaries only.
            obj.AddToHistory(['.IncludeUnitCellSidewalls "', num2str(flag, '%.15g'), '"']);
            obj.includeunitcellsidewalls = flag;
        end
        %%Calculation at User Defined Points
        function double = CalculatePoint(obj, thetaInDegree, phiInDegree, fieldComponent, farfieldName)
            % Calculates a single farfield value from the farfield result item farfieldName at the specified angles thetaInDegree and phiInDegree. If farfieldName = "" the currently selected farfield will be taken. There are different field components available for the resulting farfield mode, which itself is selected by the SetPlotMode method. The result will be influenced also by SetScaleLinear.
            % In case of CalculatePointNoApprox method the calculation is done without using the farfield approximation. Thus, radial field components may exist.
            % fieldComponent is a concatenation of four component specifiers separated by space:
            % fieldComponent = <Coord.System> +" " + <Polarization> +" " + <Component> +" " + <ComplexComp.>
            % Allowed values are:
            % <Coord.System>
            % "spherical", "ludwig2ae", "ludwig2ea", "ludwig3"
            % <Polarization>
            % "linear", "circular", "slant", "abs"
            % <Component>
            % "radial",
            % "comp1", "theta", "azimuth", "left", "alpha", "horizontal", "crosspolar",
            % "comp2", "phi", "elevation", "right", "epsilon", "vertical", "copolar"
            % <ComplexComp.>
            % "abs", "phase", "re", "im"
            % The absolute value of the field vector is accessible via:
            % fieldComponent = <Coord.System> +" " + "abs"
            % The axial ratio and the component ratios are accessible through
            % fieldComponent = <Coord.System> +" " + <Polarization> +" " + "axialratio"
            % fieldComponent = <Coord.System> +" " + <Polarization> +" " + "compratio12"
            % fieldComponent = <Coord.System> +" " + <Polarization> +" " + "compratio21"
            % where compratio12 refers to comp1/comp2.
            double = obj.hFarfieldPlot.invoke('CalculatePoint', thetaInDegree, phiInDegree, fieldComponent, farfieldName);
            obj.calculatepoint.thetaInDegree = thetaInDegree;
            obj.calculatepoint.phiInDegree = phiInDegree;
            obj.calculatepoint.fieldComponent = fieldComponent;
            obj.calculatepoint.farfieldName = farfieldName;
        end
        function double = CalculatePointNoApprox(obj, thetaInDegree, phiInDegree, radius, fieldComponent, farfieldName)
            % Calculates a single farfield value from the farfield result item farfieldName at the specified angles thetaInDegree and phiInDegree. If farfieldName = "" the currently selected farfield will be taken. There are different field components available for the resulting farfield mode, which itself is selected by the SetPlotMode method. The result will be influenced also by SetScaleLinear.
            % In case of CalculatePointNoApprox method the calculation is done without using the farfield approximation. Thus, radial field components may exist.
            % fieldComponent is a concatenation of four component specifiers separated by space:
            % fieldComponent = <Coord.System> +" " + <Polarization> +" " + <Component> +" " + <ComplexComp.>
            % Allowed values are:
            % <Coord.System>
            % "spherical", "ludwig2ae", "ludwig2ea", "ludwig3"
            % <Polarization>
            % "linear", "circular", "slant", "abs"
            % <Component>
            % "radial",
            % "comp1", "theta", "azimuth", "left", "alpha", "horizontal", "crosspolar",
            % "comp2", "phi", "elevation", "right", "epsilon", "vertical", "copolar"
            % <ComplexComp.>
            % "abs", "phase", "re", "im"
            % The absolute value of the field vector is accessible via:
            % fieldComponent = <Coord.System> +" " + "abs"
            % The axial ratio and the component ratios are accessible through
            % fieldComponent = <Coord.System> +" " + <Polarization> +" " + "axialratio"
            % fieldComponent = <Coord.System> +" " + <Polarization> +" " + "compratio12"
            % fieldComponent = <Coord.System> +" " + <Polarization> +" " + "compratio21"
            % where compratio12 refers to comp1/comp2.
            double = obj.hFarfieldPlot.invoke('CalculatePointNoApprox', thetaInDegree, phiInDegree, radius, fieldComponent, farfieldName);
            obj.calculatepointnoapprox.thetaInDegree = thetaInDegree;
            obj.calculatepointnoapprox.phiInDegree = phiInDegree;
            obj.calculatepointnoapprox.radius = radius;
            obj.calculatepointnoapprox.fieldComponent = fieldComponent;
            obj.calculatepointnoapprox.farfieldName = farfieldName;
        end
        function AddListEvaluationPoint(obj, polarAngleInDegree, lateralAngleInDegree, radius, coordinateSystem, tf_type, freq_time)
            % Defines an evaluation point for CalculateList. The evaluation point is specified by a polar angle and a lateral angle referring to a coordinate system coordinateSystem. Please refer to CalculatePoint for a summary of all supported coordinate systems. Use tf_type = "time" to provide an evaluation time or tf_type = "frequency" to pass an evaluation frequency via freq_time. This settings is only supported by broadband far field monitor results. Leaving tf_type empty will use the current time/frequency settings of the far field plotter.
            obj.AddToHistory(['.AddListEvaluationPoint "', num2str(polarAngleInDegree, '%.15g'), '", '...
                                                      '"', num2str(lateralAngleInDegree, '%.15g'), '", '...
                                                      '"', num2str(radius, '%.15g'), '", '...
                                                      '"', num2str(coordinateSystem, '%.15g'), '", '...
                                                      '"', num2str(tf_type, '%.15g'), '", '...
                                                      '"', num2str(freq_time, '%.15g'), '"']);
            obj.addlistevaluationpoint.polarAngleInDegree = polarAngleInDegree;
            obj.addlistevaluationpoint.lateralAngleInDegree = lateralAngleInDegree;
            obj.addlistevaluationpoint.radius = radius;
            obj.addlistevaluationpoint.coordinateSystem = coordinateSystem;
            obj.addlistevaluationpoint.tf_type = tf_type;
            obj.addlistevaluationpoint.freq_time = freq_time;
        end
        function CalculateList(obj, Name)
            % Calculates farfield values at the evaluation points defined by the AddListEvaluationPoint command using the currently selected farfield result. Name needs to be an empty string.
            obj.AddToHistory(['.CalculateList "', num2str(Name, '%.15g'), '"']);
            obj.calculatelist = Name;
        end
        function variant = GetList(obj, fieldComponent)
            % The above three commands work the same way as CalculatePoint, but they can calculate more than one point in only one call. This procedure is much faster than calling CalculatePoint one by one.
            % First, all points have to be added using AddListEvaluationPoint. After once calling CalculateList, the results can be inquired using the GetListItem command, providing the 0-based index of the points in the same order as adding them before. With GetList the whole list of results can be retrieved at once, which is faster than GetListItem in most cases. It will return an Array of double values. Depending on the fieldComponent identifier,  the point coordinates or the farfield result can be returned.
            % Note: If the radius for a point is set to 0, the farfield approximation will be used.
            % Use Reset to delete the point list.
            % The identifier fieldComponent may have one of the values as listed in the table for the CalculatePoint method or additionally one the following values:
            % "Point_T" - The spatial theta value of the defined point.
            % "Point_P" - The spatial phi value of the defined point.
            % "Point_R" - The spatial radius value of the defined point.
            % Please see the second example how to apply these methods.
            variant = obj.hFarfieldPlot.invoke('GetList', fieldComponent);
            obj.getlist = fieldComponent;
        end
        function double = GetListItem(obj, index, fieldComponent)
            % The above three commands work the same way as CalculatePoint, but they can calculate more than one point in only one call. This procedure is much faster than calling CalculatePoint one by one.
            % First, all points have to be added using AddListEvaluationPoint. After once calling CalculateList, the results can be inquired using the GetListItem command, providing the 0-based index of the points in the same order as adding them before. With GetList the whole list of results can be retrieved at once, which is faster than GetListItem in most cases. It will return an Array of double values. Depending on the fieldComponent identifier,  the point coordinates or the farfield result can be returned.
            % Note: If the radius for a point is set to 0, the farfield approximation will be used.
            % Use Reset to delete the point list.
            % The identifier fieldComponent may have one of the values as listed in the table for the CalculatePoint method or additionally one the following values:
            % "Point_T" - The spatial theta value of the defined point.
            % "Point_P" - The spatial phi value of the defined point.
            % "Point_R" - The spatial radius value of the defined point.
            % Please see the second example how to apply these methods.
            double = obj.hFarfieldPlot.invoke('GetListItem', index, fieldComponent);
            obj.getlistitem.index = index;
            obj.getlistitem.fieldComponent = fieldComponent;
        end
        function ClearCuts(obj)
            % Deletes all defined 1D far field cuts.
            obj.AddToHistory(['.ClearCuts']);
        end
        function AddCut(obj, CutType, ConstAngle, Step)
            % Defines a 1D far field cut for the automatic far field post-processing. Each defined cut will be automatically evaluated for all far field monitors after a solver run. All calculated cuts are stored under "Farfields\Farfield Cuts" in the Navigation Tree. CutType sets the constant angle of the cut. Use "polar" to cut along a line with constant polar angle (e.g. theta) or "lateral" to cut along a line with constant lateral angle (e.g. phi): ConstAngle is the value of the constant angle in degree and step specifies the sampling step in degree. Calling AddCut overwrites any previously defined cut with the same CutType and ConstAngle.
            obj.AddToHistory(['.AddCut "', num2str(CutType, '%.15g'), '", '...
                                      '"', num2str(ConstAngle, '%.15g'), '", '...
                                      '"', num2str(Step, '%.15g'), '"']);
            obj.addcut.CutType = CutType;
            obj.addcut.ConstAngle = ConstAngle;
            obj.addcut.Step = Step;
        end
        %% Plot Style
        function SetColorByValue(obj, bFlag)
            % Enables or disables mapping of plot values to colors using the current color ramp for plot types 2D or 3D.
            obj.AddToHistory(['.SetColorByValue "', num2str(bFlag, '%.15g'), '"']);
            obj.setcolorbyvalue = bFlag;
        end
        function SetTheta360(obj, bFlag)
            % This settings extends the plot range of the polar angle (theta, elevation, alpha) to the full circle. The plot range of the corresponding lateral angle (phi, azimuth, epsilon) is reduced accordingly, depending on the active plot type.
            obj.AddToHistory(['.SetTheta360 "', num2str(bFlag, '%.15g'), '"']);
            obj.settheta360 = bFlag;
        end
        function DrawStepLines(obj, bFlag)
            % In case of plot type "3D", draws black lines at each angular step, if activated.
            obj.AddToHistory(['.DrawStepLines "', num2str(bFlag, '%.15g'), '"']);
            obj.drawsteplines = bFlag;
        end
        function SymmetricRange(obj, bFlag)
            % Choose the plot range of the lateral angles (phi, azimuth, epsilon) symmetric about the origin. This setting is also applied to the polar angles if possible.
            obj.AddToHistory(['.SymmetricRange "', num2str(bFlag, '%.15g'), '"']);
            obj.symmetricrange = bFlag;
        end
        function DrawIsoLongitudeLatitudeLines(obj, bFlag)
            % Draws iso lines for the longitude and the latitude of the active coordinate system, if activated.
            obj.AddToHistory(['.DrawIsoLongitudeLatitudeLines "', num2str(bFlag, '%.15g'), '"']);
            obj.drawisolongitudelatitudelines = bFlag;
        end
        function ShowStructure(obj, bFlag)
            % Enables to plot the structure into the 3D-farfield plot.
            obj.AddToHistory(['.ShowStructure "', num2str(bFlag, '%.15g'), '"']);
            obj.showstructure = bFlag;
        end
        function ShowStructureProfile(obj, bFlag)
            % Plots a structure profile image into the 1D polar farfield plot.
            obj.AddToHistory(['.ShowStructureProfile "', num2str(bFlag, '%.15g'), '"']);
            obj.showstructureprofile = bFlag;
        end
        function SetStructureTransparent(obj, bFlag)
            % Plots the structure transparent.
            obj.AddToHistory(['.SetStructureTransparent "', num2str(bFlag, '%.15g'), '"']);
            obj.setstructuretransparent = bFlag;
        end
        function SetFarfieldTransparent(obj, bFlag)
            % Plots the farfield transparent. This setting affects only 3D farfield plots.
            obj.AddToHistory(['.SetFarfieldTransparent "', num2str(bFlag, '%.15g'), '"']);
            obj.setfarfieldtransparent = bFlag;
        end
        function FarfieldSize(obj, size)
            % Size of the farfield. Valid range is between 0 and 100.
            obj.AddToHistory(['.FarfieldSize "', num2str(size, '%.15g'), '"']);
            obj.farfieldsize = size;
        end
        %% Scaling and Plot Modes
        function SetPlotMode(obj, plotMode)
            % SetPlotMode specifies the mode for the farfield plot. GetPlotMode returns the currently set plot mode.
            % plotMode can have one of the following values:
            % "directivity" - The directivity is plotted in the farfield plot.
            % "gain" - The gain is plotted in the farfield plot.
            % "realized gain" - The realized gain is plotted in the farfield plot.
            % "efield" - The electric field is plotted in the farfield plot.
            % "epattern" - The electric field pattern is plotted in the farfield plot.
            % "hfield" - The magnetic field is plotted in the farfield plot.
            % "pfield" - The power flow is plotted in the farfield plot.
            % "rcs" - The radar cross section (square meters) is plotted in the farfield plot.
            % "rcsunits" - The radar cross section (project length units squared)  is plotted in the farfield plot.
            % "rcssw" - The radar cross section (square wavelength)  is plotted in the farfield plot.
            obj.AddToHistory(['.SetPlotMode "', num2str(plotMode, '%.15g'), '"']);
            obj.setplotmode = plotMode;
        end
        function GetPlotMode(obj, plotMode)
            % SetPlotMode specifies the mode for the farfield plot. GetPlotMode returns the currently set plot mode.
            % plotMode can have one of the following values:
            % "directivity" - The directivity is plotted in the farfield plot.
            % "gain" - The gain is plotted in the farfield plot.
            % "realized gain" - The realized gain is plotted in the farfield plot.
            % "efield" - The electric field is plotted in the farfield plot.
            % "epattern" - The electric field pattern is plotted in the farfield plot.
            % "hfield" - The magnetic field is plotted in the farfield plot.
            % "pfield" - The power flow is plotted in the farfield plot.
            % "rcs" - The radar cross section (square meters) is plotted in the farfield plot.
            % "rcsunits" - The radar cross section (project length units squared)  is plotted in the farfield plot.
            % "rcssw" - The radar cross section (square wavelength)  is plotted in the farfield plot.
            obj.AddToHistory(['.GetPlotMode "', num2str(plotMode, '%.15g'), '"']);
            obj.getplotmode = plotMode;
        end
        function SelectComponent(obj, fieldComponent)
            % Changes the currently plotted field component. fieldComponent specifies the desired component as it appears in the tree/ribbon, e.g., "Abs", "Phi/Theta", "Axial Ratio", ...
            obj.AddToHistory(['.SelectComponent "', num2str(fieldComponent, '%.15g'), '"']);
            obj.selectcomponent = fieldComponent;
        end
        function SetSpecials(obj, option)
            % Activates additional farfield plot settings. Allowed values of option are:
            % "enablepolarextralines" - Activates the main lobe and side lobe level visualization.
            % "disablepolarextralines" - Deactivates the visualization.
            % "showtrp" - Show the total radiated power. This settings affects only 3D farfields.
            % "showtrpdb" - Show the total radiated power in dBmW.
            % "showtrpoff" - Hide the total radiated power.
            % "showtis" - Display the total isotropic sensitivity.
            % "showtisdb" - Display the total isotropic sensitivity in dBmW.
            % "showtisoff" - Hide the total isotropic sensitivity.
            obj.AddToHistory(['.SetSpecials "', num2str(option, '%.15g'), '"']);
            obj.setspecials = option;
        end
        function Distance(obj, radius)
            % Set the radius of the virtual sphere for which the farfield is calculated. Available for plot modes e-field / h-field and power flow.
            % Please note: radius must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.Distance "', num2str(radius, '%.15g'), '"']);
            obj.distance = radius;
        end
        function SetScaleLinear(obj, bFlag)
            % If activated the farfield is plotted using linear scaling. Otherwise the scaling is logarithmic.
            obj.AddToHistory(['.SetScaleLinear "', num2str(bFlag, '%.15g'), '"']);
            obj.setscalelinear = bFlag;
        end
        function bool = IsScaleLinear(obj)
            % Returns True if the farfield is plotted linearly. Otherwise returns False.
            bool = obj.hFarfieldPlot.invoke('IsScaleLinear');
        end
        function SetInverseAxialRatio(obj, bFlag)
            % If activated the inverse IEEE axial ratio is plotted.
            obj.AddToHistory(['.SetInverseAxialRatio "', num2str(bFlag, '%.15g'), '"']);
            obj.setinverseaxialratio = bFlag;
        end
        function bool = IsInverseAxialRatio(obj)
            % Returns true if the inverse IEEE axial ratio is plotted.
            bool = obj.hFarfieldPlot.invoke('IsInverseAxialRatio');
        end
        function SetLogRange(obj, range)
            % Sets the logarithmic farfield plot range in dB. For plot type "polar" the plot ranges maximum will be at the next 10 dB step above the plots maximum (i.e. 20 dB if the maximum is 14). For plot types "cartesian", 2D and 3D the ranges maximum will be the plots maximum.
            % Please note: range must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.SetLogRange "', num2str(range, '%.15g'), '"']);
            obj.setlogrange = range;
        end
        function SetLogNorm(obj, norm)
            % Sets the logarithmic farfield plot normalization in dB. This setting requires the deactivation of the maximum normalization.
            % Please note: norm must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.SetLogNorm "', num2str(norm, '%.15g'), '"']);
            obj.setlognorm = norm;
        end
        function double = GetLogRange(obj)
            % Returns the currently defined logarithmic plot range.
            double = obj.hFarfieldPlot.invoke('GetLogRange');
        end
        function SetMainLobeThreshold(obj, limit)
            % Sets the threshold used for the main lobe width calculation. limit is in dB.
            obj.AddToHistory(['.SetMainLobeThreshold "', num2str(limit, '%.15g'), '"']);
            obj.setmainlobethreshold = limit;
        end
        function DBUnit(obj, unitCode)
            % Sets the a unit for linear and logarithmic farfield plots.
            % unitCode can have one of the following values:
            % "-1"
            % Maximum = 1
            % Maximum = 0 dB
            % "0"
            % V/m, A/m, W/m2
            % dBV/m, dBA/m, dBW/m2
            % "60"
            % mV/m, mA/m, uW/m2
            % dBmV/m, dBmA/m, dBpW/m2
            % "120"
            % uV/m, uA/m, pW/m2
            % dBuV/m, dBuA/m, dBpW/m2
            % "-60"
            % kV/m, kA/m, MW/m2
            % dBkV/m, dBkA/m, dBMW/m2
            obj.AddToHistory(['.DBUnit "', num2str(unitCode, '%.15g'), '"']);
            obj.dbunit = unitCode;
        end
        function EnableFixPlotMaximum(obj, bFlag)
            % If activated all farfield plots are scaled to the same  fixed maximum value set with SetFixPlotMaximumValue. Otherwise the plot maximum is recalculated  for each farfield plot automatically.
            obj.AddToHistory(['.EnableFixPlotMaximum "', num2str(bFlag, '%.15g'), '"']);
            obj.enablefixplotmaximum = bFlag;
        end
        function bool = IsPlotMaximumFixed(obj)
            % Returns True if the current plot maximum is fixed else returns False.
            bool = obj.hFarfieldPlot.invoke('IsPlotMaximumFixed');
        end
        function SetFixPlotMaximumValue(obj, plotMax)
            % Sets the plot maximum value to plotMax. If scaling to fixed plot maximum is activated all farfield plots are scaled to plotMax.
            obj.AddToHistory(['.SetFixPlotMaximumValue "', num2str(plotMax, '%.15g'), '"']);
            obj.setfixplotmaximumvalue = plotMax;
        end
        function double = GetFixPlotMaximumValue(obj)
            % Returns the currently set fixed plot maximum value.
            double = obj.hFarfieldPlot.invoke('GetFixPlotMaximumValue');
        end
        %% Farfield Orientation, Origin and Coordinate Systems
        function Origin(obj, originType)
            % The origin type of the farfield calculation.
            obj.AddToHistory(['.Origin "', num2str(originType, '%.15g'), '"']);
            obj.origin = originType;
        end
        function can = originType(obj)
            % bbox
            % The center of the bounding box of the structure.
            % zero
            % Origin of coordinate system.
            % free
            % Any desired point defined by Userorigin
            can = obj.hFarfieldPlot.invoke('originType');
        end
        function Userorigin(obj, x, y, z)
            % Sets origin of the farfield calculation if the origin type is set to free.
            % Please note: x, y, and z must be double values here. Any expression is not allowed.
            obj.AddToHistory(['.Userorigin "', num2str(x, '%.15g'), '", '...
                                          '"', num2str(y, '%.15g'), '", '...
                                          '"', num2str(z, '%.15g'), '"']);
            obj.userorigin.x = x;
            obj.userorigin.y = y;
            obj.userorigin.z = z;
        end
        function Phistart(obj, x, y, z)
            % Set new origin vectors in global cartesian coordinates for the x'-axis and z'axis. The x'axis defines the new start of the angle phi, the z'-axis defines the new start of the angle theta. Therefore Phistart is used to set the new x'-axis, Thetastart to set the new z'-axis. The resulting vectors will be normalized to 1. The x'-axis will be orthogonalized to the z'-axis. Please make sure that the axes are not parallel and that the vectors do not have zero length. The y'-axis will be determined automatically.
            % Please note: x, y, and z must be double values here. Any expression is not allowed.
            obj.AddToHistory(['.Phistart "', num2str(x, '%.15g'), '", '...
                                        '"', num2str(y, '%.15g'), '", '...
                                        '"', num2str(z, '%.15g'), '"']);
            obj.phistart.x = x;
            obj.phistart.y = y;
            obj.phistart.z = z;
        end
        function Thetastart(obj, x, y, z)
            % Set new origin vectors in global cartesian coordinates for the x'-axis and z'axis. The x'axis defines the new start of the angle phi, the z'-axis defines the new start of the angle theta. Therefore Phistart is used to set the new x'-axis, Thetastart to set the new z'-axis. The resulting vectors will be normalized to 1. The x'-axis will be orthogonalized to the z'-axis. Please make sure that the axes are not parallel and that the vectors do not have zero length. The y'-axis will be determined automatically.
            % Please note: x, y, and z must be double values here. Any expression is not allowed.
            obj.AddToHistory(['.Thetastart "', num2str(x, '%.15g'), '", '...
                                          '"', num2str(y, '%.15g'), '", '...
                                          '"', num2str(z, '%.15g'), '"']);
            obj.thetastart.x = x;
            obj.thetastart.y = y;
            obj.thetastart.z = z;
        end
        function SetAxesType(obj, type)
            % Specifies the alignment of the farfield coordinate system. The following rotation types are available:
            % "xyz" - Alignment with the global coordinate system.
            % "user" - User defined alignment using the orientation specified by Thetastart and Phistart.
            % "mainlobe" - Aligns the coordinate system with the main lobe direction (z') and the PolarizationVector (y').
            % "currentwcs" - The coordinate system is set to the current wcs.
            obj.AddToHistory(['.SetAxesType "', num2str(type, '%.15g'), '"']);
            obj.setaxestype = type;
        end
        function SetAntennaType(obj, type)
            % Specifies the antenna used to preconfigure the axes settings. The following types are available
            % "unknown" - Antenna type is not known.
            % "isotropic" - Isotropic antenna.
            % "isotropic_linear" - Linearly polarized isotropic antenna.
            % "directional_linear" - Linearly polarized directional antenna.
            % "directional_circular" - Circularly  polarized directional antenna.
            obj.AddToHistory(['.SetAntennaType "', num2str(type, '%.15g'), '"']);
            obj.setantennatype = type;
        end
        function PolarizationVector(obj, x, y, z)
            % Set the polarization vector or y'-axis in global cartesian coordinates . You may enter any numbers, the resulting vector will be normalized to 1 later.
            obj.AddToHistory(['.PolarizationVector "', num2str(x, '%.15g'), '", '...
                                                  '"', num2str(y, '%.15g'), '", '...
                                                  '"', num2str(z, '%.15g'), '"']);
            obj.polarizationvector.x = x;
            obj.polarizationvector.y = y;
            obj.polarizationvector.z = z;
        end
        function SetCoordinateSystemType(obj, coordSys)
            % Sets the coordinate system to the type coordSys. According to the chosen coordinate system different field components are calculated based on the respective coordinate transforms.
            obj.AddToHistory(['.SetCoordinateSystemType "', num2str(coordSys, '%.15g'), '"']);
            obj.setcoordinatesystemtype = coordSys;
        end
        function can = coordSys(obj)
            % "spherical" - Sets the coordinate system to spherical coordinates.
            % "ludwig2ae" - Sets the coordinate system to Ludwig2 - azimuth over elevation
            % "ludwig2ea" - Sets the coordinate system to Ludwig2 - elevation over azimuth
            % "ludwig3" - Sets the coordinate system to Ludwig3
            can = obj.hFarfieldPlot.invoke('coordSys');
        end
        function SetAutomaticCoordinateSystem(obj, bFlag)
            % Activates the automatic choice of the coordinate system based on the axes type.
            obj.AddToHistory(['.SetAutomaticCoordinateSystem "', num2str(bFlag, '%.15g'), '"']);
            obj.setautomaticcoordinatesystem = bFlag;
        end
        function SetPolarizationType(obj, polarization)
            % Sets the polarization type to polarization. Supported values are "linear", "circular" and "slant".
            obj.AddToHistory(['.SetPolarizationType "', num2str(polarization, '%.15g'), '"']);
            obj.setpolarizationtype = polarization;
        end
        function SlantAngle(obj, angle)
            % Sets the slant angle to angle. This settings is only required for the polarization type "slant".
            obj.AddToHistory(['.SlantAngle "', num2str(angle, '%.15g'), '"']);
            obj.slantangle = angle;
        end
        %% Decoupling Plane
        function UseDecouplingPlane(obj, bFlag)
            % Enable or disable a PEC plane for the farfield calculation. For models containing a (possibly discontinuous) PEC plane which touches the boundaries of the calculation domain you have to use a decoupling plane (e.g. a coplanar antenna on a substrate).
            obj.AddToHistory(['.UseDecouplingPlane "', num2str(bFlag, '%.15g'), '"']);
            obj.usedecouplingplane = bFlag;
        end
        function DecouplingPlaneAxis(obj, axis)
            % This command sets the normal of the user defined PEC-plane. The normal is always aligned with one of the three cartesian coordinate axes x, y, or z.
            % axis: 'x'
            %       'y'
            %       'z'
            obj.AddToHistory(['.DecouplingPlaneAxis "', num2str(axis, '%.15g'), '"']);
            obj.decouplingplaneaxis = axis;
        end
        function DecouplingPlanePosition(obj, position)
            % Enter here the coordinate of the user defined decoupling plane in normal direction.
            % Please note: position must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.DecouplingPlanePosition "', num2str(position, '%.15g'), '"']);
            obj.decouplingplaneposition = position;
        end
        function SetUserDecouplingPlane(obj, bFlag)
            % If activated the user defined decoupling plane is used for the farfield calculation instead of an automatically detected decoupling plane.
            obj.AddToHistory(['.SetUserDecouplingPlane "', num2str(bFlag, '%.15g'), '"']);
            obj.setuserdecouplingplane = bFlag;
        end
        %% Farfield Calculation Secondary Results
        function double = Getmax(obj)
            % Returns the maximum of the plotted farfield component.
            double = obj.hFarfieldPlot.invoke('Getmax');
        end
        function double = Getmin(obj)
            % Returns the minimum of the plotted farfield component.
            double = obj.hFarfieldPlot.invoke('Getmin');
        end
        function double = GetMean(obj)
            % Returns the average value of the plotted farfield component.
            double = obj.hFarfieldPlot.invoke('GetMean');
        end
        function double = GetRadiationEfficiency(obj)
            % Returns the calculated radiation efficiency of the currently active farfield plot.
            double = obj.hFarfieldPlot.invoke('GetRadiationEfficiency');
        end
        function double = GetTotalEfficiency(obj)
            % Returns the calculated total efficiency of the currently active farfield plot.
            double = obj.hFarfieldPlot.invoke('GetTotalEfficiency');
        end
        function double = GetSystemRadiationEfficiency(obj)
            % Returns the calculated radiation efficiency of the currently active farfield plot for the complete system (CST DESIGN STUDIO model) if available.
            double = obj.hFarfieldPlot.invoke('GetSystemRadiationEfficiency');
        end
        function double = GetSystemTotalEfficiency(obj)
            % Returns the calculated total efficiency of the currently active farfield plot for the complete system (CST DESIGN STUDIO model) if available.
            double = obj.hFarfieldPlot.invoke('GetSystemTotalEfficiency');
        end
        function double = GetTRP(obj)
            % Returns the total radiated power in W.
            double = obj.hFarfieldPlot.invoke('GetTRP');
        end
        function double = GetTotalRCS(obj)
            % Returns the total radar cross section of the currently active RCS plot with the active unit scaling.
            double = obj.hFarfieldPlot.invoke('GetTotalRCS');
        end
        function double = GetTotalACS(obj)
            % Returns the total absorption cross section of the currently active RCS plot with the active unit scaling.
            double = obj.hFarfieldPlot.invoke('GetTotalACS');
        end
        function double = GetMainLobeDirection(obj)
            % Returns the main lobe direction of the farfield in degrees. This method only applies to "polar" plots.
            double = obj.hFarfieldPlot.invoke('GetMainLobeDirection');
        end
        function [x, y, z] = GetMainLobeVector(obj)
            % Returns the direction of the 3D farfield main lobe.
            functionString = [...
                'Dim x As Double, y As Double, z As Double', newline, ...
                'LumpedElement.GetCoordinates(x, y, z)', newline, ...
            ];
            returnvalues = {'x', 'y', 'z'};
            [x, y, z] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            x = str2double(x);
            y = str2double(y);
            z = str2double(z);
        end
        function double = GetAngularWidthXdB(obj)
            % Returns the angular width of the farfield in degrees according to the currently active main lobe threshold. This method only applies to "polar" plots.
            double = obj.hFarfieldPlot.invoke('GetAngularWidthXdB');
        end
        function double = GetSideLobeSuppression(obj)
            % Returns the side lobe suppression. This method only applies to "polar" plots.
            double = obj.hFarfieldPlot.invoke('GetSideLobeSuppression');
        end
        function double = GetSideLobeLevel(obj)
            % Returns the side lobe level. This method only applies to "polar" plots.
            double = obj.hFarfieldPlot.invoke('GetSideLobeLevel');
        end
        function double = GetFrontToBackRatio(obj)
            % Returns the ratio of the front field value (in main lobe direction) to the back field value (antipodal main lobe direction) using the current farfield plot component and scaling.
            double = obj.hFarfieldPlot.invoke('GetFrontToBackRatio');
        end
        %% Phase Center Calculation
        function EnablePhaseCenterCalculation(obj, bFlag)
            % If activated the phase center is being calculated as soon as the farfield is replotted.
            obj.AddToHistory(['.EnablePhaseCenterCalculation "', num2str(bFlag, '%.15g'), '"']);
            obj.enablephasecentercalculation = bFlag;
        end
        function SetPhaseCenterComponent(obj, component)
            % Selects the desired farfield component which is used for the phase center calculation. Theta and phi use the phase of the corresponding spherical components. Boresight evaluates the farfield in +z' direction, extracts the polarization vector from this field and uses this reference to calculate the phase.
            % component: 'theta'
            %            'phi'
            %            'boresight'
            obj.AddToHistory(['.SetPhaseCenterComponent "', num2str(component, '%.15g'), '"']);
            obj.setphasecentercomponent = component;
        end
        function SetPhaseCenterPlane(obj, component)
            % The phase center is calculated in either the E-plane (x' = 0), H-plane (y' = 0) or in both planes. Select the desired plane here.
            % component: 'both'
            %            'e-plane'
            %            'h-plane'
            obj.AddToHistory(['.SetPhaseCenterPlane "', num2str(component, '%.15g'), '"']);
            obj.setphasecenterplane = component;
        end
        function SetPhaseCenterAngularLimit(obj, angleInDegrees)
            % The phase center is calculated using the phase values around the z'axis in the x' = 0 (E-Plane) and y' = 0 (H-Plane) planes with a constant distance from the origin. To limit the area around the z'-axis taken into account for the calculation in those planes you may specify an angle here.
            obj.AddToHistory(['.SetPhaseCenterAngularLimit "', num2str(angleInDegrees, '%.15g'), '"']);
            obj.setphasecenterangularlimit = angleInDegrees;
        end
        function ShowPhaseCenter(obj, bFlag)
            % Visualizes the phase center in the 3D-farfield plot.
            obj.AddToHistory(['.ShowPhaseCenter "', num2str(bFlag, '%.15g'), '"']);
            obj.showphasecenter = bFlag;
        end
        function double = GetPhaseCenterResult(obj, direction, mode)
            % Returns the previously calculated  phase center location in global coordinates  for a given direction and mode. The direction may be either "x", "y" or "z". The mode may be either "avg" (for averaged phase center location), "eplane" (for the phase center location calculated in the E-plane) or "hplane" (for the phase center location calculated in the H-plane).
            % direction,: 'x'
            %             'y'
            %             'z'
            % mode: 'avg'
            %       'eplane'
            %       'hplane'
            double = obj.hFarfieldPlot.invoke('GetPhaseCenterResult', direction, mode);
            obj.getphasecenterresult.direction = direction;
            obj.getphasecenterresult.mode = mode;
        end
        function string = GetPhaseCenterResultExpr(obj)
            % Returns the previously calculated  phase center location in global coordinates  as character string as displayed in the main view window.
            string = obj.hFarfieldPlot.invoke('GetPhaseCenterResultExpr');
        end
        function string = GetPhaseCenterResultExprAvg(obj)
            % Returns the previously calculated  phase center location in global coordinates  as character string. The phase center location is average by the values calculated in the E-plane and H-plane.
            string = obj.hFarfieldPlot.invoke('GetPhaseCenterResultExprAvg');
        end
        function string = GetPhaseCenterResultExprEPlane(obj)
            % Returns the previously calculated  phase center location calculated in the E-plane in global coordinates  as character string.
            string = obj.hFarfieldPlot.invoke('GetPhaseCenterResultExprEPlane');
        end
        function string = GetPhaseCenterResultExprHPlane(obj)
            % Returns the previously calculated  phase center location calculated in the H-plane in global coordinates  as character string.
            string = obj.hFarfieldPlot.invoke('GetPhaseCenterResultExprHPlane');
        end
        %% Undocumented functions
        % Found in the history list.
        function LossyGround(obj, bool)
            obj.AddToHistory(['.LossyGround "', num2str(bool, '%.15g'), '"']);
            obj.lossyground = bool;
        end
        % Found in the history list.
        function GroundEpsilon(obj, value)
            obj.AddToHistory(['.GroundEpsilon "', num2str(value, '%.15g'), '"']);
            obj.groundepsilon = value;
        end
        % Found in the history list.
        function GroundKappa(obj, value)
            obj.AddToHistory(['.GroundKappa "', num2str(value, '%.15g'), '"']);
            obj.groundkappa = value;
        end
        
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hFarfieldPlot
        history

        plottype
        vary
        phi
        theta
        step
        step2
        setlocksteps
        setplotrangeonly
        setthetastart
        setthetaend
        setphistart
        setphiend
        usefarfieldapproximation
        setmultipolnumber
        setfrequency
        settime
        settimedomainff
        setmoviesamples
        asciiexportsummary
        asciiexportversion
        asciiexportassource
        asciiexportasbroadbandsource
        copyfarfieldto1dresults
        includeunitcellsidewalls
        calculatepoint
        calculatepointnoapprox
        addlistevaluationpoint
        calculatelist
        getlist
        getlistitem
        addcut
        setcolorbyvalue
        settheta360
        drawsteplines
        symmetricrange
        drawisolongitudelatitudelines
        showstructure
        showstructureprofile
        setstructuretransparent
        setfarfieldtransparent
        farfieldsize
        setplotmode
        getplotmode
        selectcomponent
        setspecials
        distance
        setscalelinear
        setinverseaxialratio
        setlogrange
        setlognorm
        setmainlobethreshold
        dbunit
        enablefixplotmaximum
        setfixplotmaximumvalue
        origin
        userorigin
        phistart
        thetastart
        setaxestype
        setantennatype
        polarizationvector
        setcoordinatesystemtype
        setautomaticcoordinatesystem
        setpolarizationtype
        slantangle
        usedecouplingplane
        decouplingplaneaxis
        decouplingplaneposition
        setuserdecouplingplane
        enablephasecentercalculation
        setphasecentercomponent
        setphasecenterplane
        setphasecenterangularlimit
        showphasecenter
        getphasecenterresult
        lossyground
        groundepsilon
        groundkappa
    end
end

%% Default Settings
% Plottype('polar');
% Vary('angle1');
% Phi(0.0)
% Theta(0.0)
% Step(30.0)
% Step2(30.0)
% SetLockSteps(1)
% SetPlotRangeOnly(0)
% SetThetaStart(0.0)
% SetThetaEnd(180.0)
% SetPhiStart(0.0)
% SetPhiEnd(360.0)
% UseFarfieldApproximation(1)
% SetColorByValue(1)
% SetTheta360(0)
% DrawStepLines(0)
% CartSymRange(0)
% DrawIsoLongitudeLatitudeLines(0)
% ShowStructure(0)
% SetStructureTransparent(0)
% SetFarfieldTransparent(1)
% FarfieldSize(50)
% SetPlotMode('directivity');
% SetInverseAxialRatio(0)
% Distance(1.0)
% SetScaleLinear(0)
% SetLogRange(40.0)
% SetLogNorm(0.0)
% SetMainLobeThreshold(3.0)
% DBUnit('0');
% EnableFixPlotMaximum(0)
% SetFixPlotMaximumValue(1.0)
% Origin('bbox');
% Userorigin(0.0, 0.0, 0.0)
% Phistart(1.0, 0.0, 0.0)
% Thetastart(0.0, 0.0, 0.0)
% SetAxesType('user');
% SetAntennaType('unknown');
% PolarizationVector(0.0, 1.0, 0.0)
% SetCoordinateSystemType('spherical');
% SetAutomaticCoordinateSystem(1)
% UseMirrorPlane(0)
% SetUserMirrorPlane(0)
% EnablePhaseCenterCalculation(0)
% SetPhaseCenterComponent('boresight');
% SetPhaseCenterPlane('both');
% SetPhaseCenterAngularLimit(30.0)
% ShowPhaseCenter(0)
% SetTimeDomainFF(0)
% SetMovieSamples(0)
% IncludeUnitCellSidewalls(1)

%% Example - Taken from CST documentation and translated to MATLAB.
% % This example demonstrate some general settings for a farfield plot:
% 
% farfieldplot = project.FarfieldPlot();
%     farfieldplot.Reset
%     farfieldplot.Plottype('3d');
%     farfieldplot.Step(5)
%     farfieldplot.SetColorByValue(1)
%     farfieldplot.DrawStepLines(0)
%     farfieldplot.DrawIsoLongitudeLatitudeLines(0)
%     farfieldplot.SetTheta360(0)
%     farfieldplot.CartSymRange(0)
%     farfieldplot.UseFarfieldApproximation(0)
%     farfieldplot.SetPlotMode('Efield');
%     farfieldplot.SetInverseAxialRatio(0)
%     farfieldplot.Distance(1)
%     farfieldplot.SetScaleLinear(1)
%     farfieldplot.SetLogRange(50)
%     farfieldplot.DBUnit('0');
%     farfieldplot.EnableFixPlotMaximum(0)
%     farfieldplot.SetFixPlotMaximumValue(1.0)
%     farfieldplot.SetAxesType('mainlobe');
%     farfieldplot.Phistart(1.0, 0.0, 0.0)
%     farfieldplot.Thetastart(0.0, 1.0, 1.0)
%     farfieldplot.PolarizationVector(1.0, 1.0, 0.0)
%     farfieldplot.Origin('free');
%     farfieldplot.Userorigin(0.0, 0.0, 5.0)
%     farfieldplot.SetUserMirrorPlane(0)
%     farfieldplot.UseMirrorPlane(0)
%     farfieldplot.MirrorPlaneAxis('X');
%     farfieldplot.MirrorPlanePosition(0.0)
%     farfieldplot.EnablePhaseCenterCalculation(1)
%     farfieldplot.SetPhaseCenterAngularLimit(36.3)
%     farfieldplot.SetPhaseCenterComponent('Theta');
%     farfieldplot.SetPhaseCenterPlane('both');
% 
% SelectTreeItem('Farfields\farfield(f=16) [1]');
%     farfieldplot.Plot
% SelectTreeItem('Farfields\farfield(f=30) [1]');
%     farfieldplot.Plot
% 
% 
% % The second example calculates theta and phi component and the phases along a user defined path:
% 
%     farfieldplot.Reset
% n = 0
% dFrequency = 2
% For phi=0 To 360 STEP 5
%      theta = 90
%      FarfieldPlot.AddListEvaluationPoint(theta, phi, 0, 'spherical', 'frequency', dFrequency)
%      n = n + 1
% Next phi
% 
%     farfieldplot.CalculateList('');
% theta_am_list = FarfieldPlot.GetList('Spherical linear theta abs');
% theta_ph_list = FarfieldPlot.GetList('Spherical linear theta phase');
% phi_am = FarfieldPlot.GetList('Spherical linear phi abs');
% phi_ph = FarfieldPlot.GetList('Spherical linear phi phase');
% position_theta = FarfieldPlot.GetList('Point_T');
% position_phi   = FarfieldPlot.GetList('Point_P');
% 
% % further process your results here
% 
