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

% Represents the boundary condition of the calculation domain for each
% boundary plane. You may either have a magnetic, electric or an open
% boundary condition.
classdef Boundary < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Boundary object.
        function obj = Boundary(project, hProject)
            obj.project = project;
            obj.hBoundary = hProject.invoke('Boundary');
        end
    end
    methods
        function StartBulkMode(obj)
            % Buffers all commands instead of sending them to CST
            % immediately.
            obj.bulkmode = 1;
        end
        function EndBulkMode(obj)
            % Flushes all commands since StartBulkMode to CST.
            obj.bulkmode = 0;

            % Prepend With and append End With
            obj.history = [ 'With Boundary', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define boundaries'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['Boundary', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Xmin(obj, boundarytype)
            % Specifies the boundary conditions for the lower x calculation domain.
            %
            % boundarytype: 'electric' - Electric boundary condition (Etan = 0)
            %               'magnetic' - Magnetic boundary condition (Htan = 0)
            %               'tangential' - All tangential field components for all sorts of  fields are zero.
            %               'normal' - All normal field components for all sorts of  fields are zero.
            %               'open' - Simulates the open space.
            %               'expanded open' - Same as 'open' but adds some extra space to the calculation domain.
            %               'periodic' - Simulates a periodic expansion of the calculation domain.
            %               'conducting wall' - This boundary behaves like a wall of lossy metal material.
            %               'unit cell' - Simulates a unit cell structure.
            obj.AddToHistory(['.Xmin "', boundarytype, '"']);
        end
        function Xmax(obj, boundarytype)
            % Specifies the boundary conditions for the upper x calculation domain.
            %
            % boundarytype: 'electric' - Electric boundary condition (Etan = 0)
            %               'magnetic' - Magnetic boundary condition (Htan = 0)
            %               'tangential' - All tangential field components for all sorts of  fields are zero.
            %               'normal' - All normal field components for all sorts of  fields are zero.
            %               'open' - Simulates the open space.
            %               'expanded open' - Same as 'open' but adds some extra space to the calculation domain.
            %               'periodic' - Simulates a periodic expansion of the calculation domain.
            %               'conducting wall' - This boundary behaves like a wall of lossy metal material.
            %               'unit cell' - Simulates a unit cell structure.
            obj.AddToHistory(['.Xmax "', boundarytype, '"']);
        end
        function Ymin(obj, boundarytype)
            % Specifies the boundary conditions for the lower y calculation domain.
            %
            % boundarytype: 'electric' - Electric boundary condition (Etan = 0)
            %               'magnetic' - Magnetic boundary condition (Htan = 0)
            %               'tangential' - All tangential field components for all sorts of  fields are zero.
            %               'normal' - All normal field components for all sorts of  fields are zero.
            %               'open' - Simulates the open space.
            %               'expanded open' - Same as 'open' but adds some extra space to the calculation domain.
            %               'periodic' - Simulates a periodic expansion of the calculation domain.
            %               'conducting wall' - This boundary behaves like a wall of lossy metal material.
            %               'unit cell' - Simulates a unit cell structure.
            obj.AddToHistory(['.Ymin "', boundarytype, '"']);
        end
        function Ymax(obj, boundarytype)
            % Specifies the boundary conditions for the upper y calculation domain.
            %
            % boundarytype: 'electric' - Electric boundary condition (Etan = 0)
            %               'magnetic' - Magnetic boundary condition (Htan = 0)
            %               'tangential' - All tangential field components for all sorts of  fields are zero.
            %               'normal' - All normal field components for all sorts of  fields are zero.
            %               'open' - Simulates the open space.
            %               'expanded open' - Same as 'open' but adds some extra space to the calculation domain.
            %               'periodic' - Simulates a periodic expansion of the calculation domain.
            %               'conducting wall' - This boundary behaves like a wall of lossy metal material.
            %               'unit cell' - Simulates a unit cell structure.
            obj.AddToHistory(['.Ymax "', boundarytype, '"']);
        end
        function Zmin(obj, boundarytype)
            % Specifies the boundary conditions for the lower z calculation domain.
            %
            % boundarytype: 'electric' - Electric boundary condition (Etan = 0)
            %               'magnetic' - Magnetic boundary condition (Htan = 0)
            %               'tangential' - All tangential field components for all sorts of  fields are zero.
            %               'normal' - All normal field components for all sorts of  fields are zero.
            %               'open' - Simulates the open space.
            %               'expanded open' - Same as 'open' but adds some extra space to the calculation domain.
            %               'periodic' - Simulates a periodic expansion of the calculation domain.
            %               'conducting wall' - This boundary behaves like a wall of lossy metal material.
            %               'unit cell' - Simulates a unit cell structure.
            obj.AddToHistory(['.Zmin "', boundarytype, '"']);
        end
        function Zmax(obj, boundarytype)
            % Specifies the boundary conditions for the upper z calculation domain.
            %
            % boundarytype: 'electric' - Electric boundary condition (Etan = 0)
            %               'magnetic' - Magnetic boundary condition (Htan = 0)
            %               'tangential' - All tangential field components for all sorts of  fields are zero.
            %               'normal' - All normal field components for all sorts of  fields are zero.
            %               'open' - Simulates the open space.
            %               'expanded open' - Same as 'open' but adds some extra space to the calculation domain.
            %               'periodic' - Simulates a periodic expansion of the calculation domain.
            %               'conducting wall' - This boundary behaves like a wall of lossy metal material.
            %               'unit cell' - Simulates a unit cell structure.
            obj.AddToHistory(['.Zmax "', boundarytype, '"']);
        end
        function boundarytype = GetXmin(obj)
            % Returns the boundary conditions at the lower x calculation domain boundary.
            boundarytype = obj.hBoundary.invoke('GetXmin');
        end
        function boundarytype = GetXmax(obj)
            % Returns the boundary conditions at the upper x calculation domain boundary.
            boundarytype = obj.hBoundary.invoke('GetXmax');
        end
        function boundarytype = GetYmin(obj)
            % Returns the boundary conditions at the lower y calculation domain boundary.
            boundarytype = obj.hBoundary.invoke('GetYmin');
        end
        function boundarytype = GetYmax(obj)
            % Returns the boundary conditions at the upper y calculation domain boundary.
            boundarytype = obj.hBoundary.invoke('GetYmax');
        end
        function boundarytype = GetZmin(obj)
            % Returns the boundary conditions at the lower z calculation domain boundary.
            boundarytype = obj.hBoundary.invoke('GetZmin');
        end
        function boundarytype = GetZmax(obj)
            % Returns the boundary conditions at the upper z calculation domain boundary.
            boundarytype = obj.hBoundary.invoke('GetZmax');
        end
        function Xsymmetry(obj, symmetrytype)
            % Defines if the structure is electrically or magnetically symmetric regarding the
            % origin of the x-axis.
            %
            % symmetrytype: 'electric' - All tangential E-fields are considered zero at the symmetry plane.
            %               'magnetic' - All tangential H-fields are considered zero at the symmetry plane.
            %               'none' - No symmetry.
            obj.AddToHistory(['.Xsymmetry "', symmetrytype, '"']);
        end
        function Ysymmetry(obj, symmetrytype)
            % Defines if the structure is electrically or magnetically symmetric regarding the
            % origin of the y-axis.
            %
            % symmetrytype: 'electric' - All tangential E-fields are considered zero at the symmetry plane.
            %               'magnetic' - All tangential H-fields are considered zero at the symmetry plane.
            %               'none' - No symmetry.
            obj.AddToHistory(['.Ysymmetry "', symmetrytype, '"']);
        end
        function Zsymmetry(obj, symmetrytype)
            % Defines if the structure is electrically or magnetically symmetric regarding the
            % origin of the z-axis.
            %
            % symmetrytype: 'electric' - All tangential E-fields are considered zero at the symmetry plane.
            %               'magnetic' - All tangential H-fields are considered zero at the symmetry plane.
            %               'none' - No symmetry.
            obj.AddToHistory(['.Zsymmetry "', symmetrytype, '"']);
        end
        function symmetrytype = GetXSymmetry(obj)
            % Returns the currently set symmetry type for the x-symmetry plane.
            symmetrytype = obj.hBoundary.invoke('GetXSymmetry');
        end
        function symmetrytype = GetYSymmetry(obj)
            % Returns the currently set symmetry type for the y-symmetry plane.
            symmetrytype = obj.hBoundary.invoke('GetYSymmetry');
        end
        function symmetrytype = GetZSymmetry(obj)
            % Returns the currently set symmetry type for the z-symmetry plane.
            symmetrytype = obj.hBoundary.invoke('GetZSymmetry');
        end
        function ApplyInAllDirections(obj, boolean)
            % Is used by the background dialog to identify if the Xmin value should be applied in
            % all the other directions.
            obj.AddToHistory(['.ApplyInAllDirections "', num2str(boolean, '%.15g'), '"']);
        end
        % TODO:
        % PotentialType
        % Potential
        % Thermal
        % symmetryThermal
        % TemperatureType
        % Temperature
        function [xmin, xmax, ymin, ymax, zmin, zmax] = GetCalculationBox(obj)
            % Returns the bounding box the calculation domain. The minimum and maximum values of the
            % bounding box of the calculation domain regarding the x, y and z direction.
            functionString = [...
                'Dim xmin As Double, xmax As Double', newline, ...
                'Dim ymin As Double, ymax As Double', newline, ...
                'Dim zmin As Double, zmax As Double', newline, ...
                'Boundary.GetCalculationBox(xmin, xmax, ymin, ymax, zmin, zmax)', newline, ...
            ];
            returnvalues = {'xmin', 'xmax', 'ymin', 'ymax', 'zmin', 'zmax'};
            [xmin, xmax, ymin, ymax, zmin, zmax] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            xmin = str2double(xmin);
            xmax = str2double(xmax);
            ymin = str2double(ymin);
            ymax = str2double(ymax);
            zmin = str2double(zmin);
            zmax = str2double(zmax);
        end
        %% Methods Concerning Open Boundary Conditions
        function Layer(obj, numlayers)
            % Specifies the number of PML layers. Usually 4 layers are sufficient.
            obj.AddToHistory(['.Layer "', num2str(numlayers, '%.15g'), '"']);
        end
        function MinimumLinesDistance(obj, minimumlinesdistance)
            % Specifies the minimum distance from the PML boundary to the structure to be modeled.
            % The distance is determined by the absolute number of grid lines.
            obj.MinimumLinesDistance(['.MinimumLinesDistance "', num2str(minimumlinesdistance, '%.15g'), '"']);
        end
        function MinimumDistanceType(obj, type)
            % Selecting the Fraction option activates the geometrical domain enlargement computed as
            % a fraction of the wavelength. With the Absolute option the distance is directly given
            % in geometrical user units. To this purpose use the SetAbsoluteDistance command.
            %
            % type: 'Fraction', 'Absolute'
            obj.AddToHistory(['.MinimumDistanceType "', type, '"']);
        end
        function SetAbsoluteDistance(obj, distance)
            % Specifies the absolute distance to enlarge the simulation domain. To be used selecting
            % the Absolute option with the command MinimumDistanceType.
            %
            % Requires MinimumDistanceType 'Absolute'.
            obj.AddToHistory(['.SetAbsoluteDistance "', num2str(distance, '%.15g'), '"']);
        end
        function MinimumDistanceReferenceFrequencyType(obj, type)
            % The command determines the reference frequency where the wavelength has to be
            % computed. The command should be used jointly with the MinimumDistanceType command
            % activating the Fraction option.
            %
            % Center means that the reference frequency is the mid simulation frequency, in formula
            % (FMin+FMax)/2.
            %
            % The second choice Centernmonitors computes the reference frequency as the minimum non
            % zero frequency selected among the center frequency and the user defined relevant
            % monitor frequencies.
            %
            % The third possibility is User, which enables to specify directly the frequency with
            % the companion FrequencyForMinimumDistance command.
            %
            % type: 'Center', 'Centernmonitors', 'User'
            obj.AddToHistory(['.MinimumDistanceReferenceFrequencyType "', type, '"']);
        end
        function MinimumDistancePerWavelength(obj, distance)
            % Specifies the minimum distance from the PML boundary to the structure to be modeled.
            % The distance is determined relatively to the wavelength, either in respect to the
            % center frequency, center and monitor frequencies or to a user defined frequency value.
            % See also the MinimumDistanceReferenceFrequencyType command.
            %
            % Requires MinimumDistanceType 'Fraction'
            obj.AddToHistory(['.MinimumDistancePerWavelength "', num2str(distance, '%.15g'), '"']);
        end
        function MinimumDistancePerWavelengthNewMeshEngine(obj, distance)
            % Was found in the CST-generated history list, seems to replace the
            % MinimumDistancePerWavelength function.
            %
            % Requires MinimumDistanceType 'Fraction'
            obj.AddToHistory(['.MinimumDistancePerWavelengthNewMeshEngine "', num2str(distance, '%.15g'), '"']);
        end
        function FrequencyForMinimumDistance(obj, freq)
            % Specifies the frequency which represents the reference value for the
            % MinimumDistancePerWavelength method.
            %
            % Requires MinimumDistanceType 'Fraction'
            % Requires MinimumDistanceReferenceFrequencyType 'User'
            obj.AddToHistory(['.FrequencyForMinimumDistance "', num2str(freq, '%.15g'), '"']);
        end
        %% Methods Concerning Periodic Boundary Conditions
        function XPeriodicShift(obj, shift)
            % Enables to define a phase shift value for a periodic boundary condition. Please note
            % that the phase shift only applies to the frequency domain solver and the eigenmode
            % solver. The settings are ignored by the transient solver.
            obj.AddToHistory(['.XPeriodicShift "', num2str(shift, '%.15g'), '"']);
        end
        function YPeriodicShift(obj, shift)
            % Enables to define a phase shift value for a periodic boundary condition. Please note
            % that the phase shift only applies to the frequency domain solver and the eigenmode
            % solver. The settings are ignored by the transient solver.
            obj.AddToHistory(['.YPeriodicShift "', num2str(shift, '%.15g'), '"']);
        end
        function ZPeriodicShift(obj, shift)
            % Enables to define a phase shift value for a periodic boundary condition. Please note
            % that the phase shift only applies to the frequency domain solver and the eigenmode
            % solver. The settings are ignored by the transient solver.
            obj.AddToHistory(['.ZPeriodicShift "', num2str(shift, '%.15g'), '"']);
        end
        function PeriodicUseConstantAngles(obj, boolean)
            % In contrast to the definition of a constant phase shift between two opposite periodic
            % boundaries (using the XPeriodicShift, YPeriodicShift or ZPeriodicShift methods) it is
            % also possible to define an incident angle value of the normal propagation direction of
            % a virtual plane wave entering the calculation domain. The angle can be defined in a
            % spherical coordinate system using the SetPeriodicBoundaryAngles method. In fact this
            % procedure also realizes a phase shift between the periodic boundaries, however, this
            % time it depends on the current frequency sample. You can activate (bFlag = True) or
            % deactivate (bFlag = False) this option using the present method.
            obj.AddToHistory(['.PeriodicUseConstantAngles "', num2str(boolean, '%.15g'), '"']);
        end
        %% Methods Concerning Periodic Boundaries and Unit Cells
        function SetPeriodicBoundaryAngles(obj, theta, phi)
            % Defines the angle in a spherical coordinate system using theta and phi values for the
            % calculation of phase shifts between periodic boundaries. The z-axis corresponds to
            % that of the global coordinate system.
            %
            % Please note that this method is only relevant for the frequency domain solver and in
            % case that the PeriodicUseConstantAngles method is activated or unit cell boundaries
            % are used.
            obj.AddToHistory(['.SetPeriodicBoundaryAngles "', num2str(theta, '%.15g'), '", '...
                                                         '"', num2str(phi, '%.15g'), '"']);
        end
        function SetPeriodicBoundaryAnglesDirection(obj, direction)
            % direction defines whether the scan angle defined with
            % SetPeriodicBoundaryAngles refers to an inward or outward
            % (with respect to the radial unit vector in the spherical
            % coordinate system) propagating plane wave
            % direction: 'inward' - The phase is set for an outward traveling plane wave.
            %                       Floquet modes should be excited at Zmin.
            %            'outward' - The phase is set for an inward traveling plane wave.
            %                        Floquet modes should be excited at Zmax.
            obj.AddToHistory(['.SetPeriodicBoundaryAnglesDirection "', direction, '"']);
        end
        function [valid, theta, phi, direction] = GetUnitCellScanAngle(obj)
            % The scan angle defined with SetPeriodicBoundaryAngles and its orientation as defined
            % by calling SetPeriodicBoundaryAnglesDirection can be accessed using this function. All
            % arguments of this function are output values, which are set by the function. Its
            % return value is True if the unit cell is active and the expressions for the scan angle
            % are valid. If direction is +1, then it refers to the "outward" direction, and to the
            % "inward" direction if direction is -1.
            %
            % NOTE: valid is -1 when true.
            functionString = [...
                'Dim valid As Boolean', newline, ...
                'Dim theta As Double, phi As Double', newline, ...
                'Dim direction As Long', newline, ...
                'valid = Boundary.GetUnitCellScanAngle(theta, phi, direction)', newline, ...
            ];
            returnvalues = {'valid', 'theta', 'phi', 'direction'};
            [valid, theta, phi, direction] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            valid = str2double(valid);
            theta = str2double(theta);
            phi = str2double(phi);
            direction = str2double(direction);
        end
        %% Methods Concerning the Unit Cell Geometry
        function UnitCellDs1(obj, ds1)
            % These two methods specify the distances between two neighboring unit cells in two different coordinate directions, whereby the first axis (UnitCellDs1) is always aligned to the x-axis of the global coordinate system. The spatial relation between these two axes is defined by the UnitCellAngle method.
            %
            % By default Ds1 is the x-distance between unit cells.
            obj.AddToHistory(['.UnitCellDs1 "', num2str(ds1, '%.15g'), '"']);
        end
        function UnitCellDs2(obj, ds2)
            % These two methods specify the distances between two neighboring unit cells in two different coordinate directions, whereby the first axis (UnitCellDs1) is always aligned to the x-axis of the global coordinate system. The spatial relation between these two axes is defined by the UnitCellAngle method.
            %
            % By default Ds2 is the y-distance between unit cells.
            obj.AddToHistory(['.UnitCellDs2 "', num2str(ds2, '%.15g'), '"']);
        end
        function ds1 = GetUnitCellDs1(obj)
            % These two functions return the lengths of the unit cell lattice vectors.
            ds1 = obj.hBoundary.invoke('UnitCellDs1');
        end
        function ds2 = GetUnitCellDs2(obj)
            % These two functions return the lengths of the unit cell lattice vectors.
            ds2 = obj.hBoundary.invoke('UnitCellDs2');
        end
        function UnitCellAngle(obj, angle)
            % Specifies the spatial relation between the two axes defined by the methods UnitCellDs1 and UnitCellDs2 .
            %
            % Please note, that the hexahedral frequency domain solver needs a value of 90 degree for this value.
            obj.AddToHistory(['.UnitCellAngle "', num2str(angle, '%.15g'), '"']);
        end
        function angle = GetUnitCellAngle(obj)
            % This function returns the angle between the unit cell lattice vectors in degrees.
            angle = obj.hBoundary.invoke('GetUnitCellAngle');
        end
        function UnitCellOrigin(obj, originx, originy)
            % Allows to shift the origin of the unit cell and thereby the calculation domain for the frequency domain solver with tetrahedral mesh. The values may range from zero to one, where the default zero lets the center of the bounding box and the center of the unit cell coincide, while a value of one moves the origin by half the size of the unit cell lattice in the corresponding direction.
            obj.AddToHistory(['.UnitCellOrigin "', num2str(originx, '%.15g'), '", '...
                                              '"', num2str(originy, '%.15g'), '"']);
        end
        function UnitCellFitToBoundingBox(obj, boolean)
            % If this method is activated, the structure model will be repeated at its bounding box borders, neglecting any settings of the methods UnitCellDs1, UnitCellDs2 and UnitCellAngle.
            obj.project.AddToHistory(['Boundary.UnitCellFitToBoundingBox "', num2str(boolean, '%.15g'), '"']);
        end
        %% From 2013 documentation.
        function XminThermal(obj, ThermalBoundaryType)
            % ThermalBoundaryType: "isothermal" - Boundary condition with constant temperature (T=const). This boundary type can carry a temperature definition.
            %                      "adiabatic" - Boundary condition without any heat-flow through the boundary (dT / dN = 0).
            %                      "open" - Simulates the open space.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            obj.AddToHistory(['.XminThermal "', num2str(ThermalBoundaryType, '%.15g'), '"']);
        end
        function XmaxThermal(obj, ThermalBoundaryType)
            % ThermalBoundaryType: "isothermal" - Boundary condition with constant temperature (T=const). This boundary type can carry a temperature definition.
            %                      "adiabatic" - Boundary condition without any heat-flow through the boundary (dT / dN = 0).
            %                      "open" - Simulates the open space.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            obj.AddToHistory(['.XmaxThermal "', num2str(ThermalBoundaryType, '%.15g'), '"']);
        end
        function YminThermal(obj, ThermalBoundaryType)
            % ThermalBoundaryType: "isothermal" - Boundary condition with constant temperature (T=const). This boundary type can carry a temperature definition.
            %                      "adiabatic" - Boundary condition without any heat-flow through the boundary (dT / dN = 0).
            %                      "open" - Simulates the open space.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            obj.AddToHistory(['.YminThermal "', num2str(ThermalBoundaryType, '%.15g'), '"']);
        end
        function YmaxThermal(obj, ThermalBoundaryType)
            % ThermalBoundaryType: "isothermal" - Boundary condition with constant temperature (T=const). This boundary type can carry a temperature definition.
            %                      "adiabatic" - Boundary condition without any heat-flow through the boundary (dT / dN = 0).
            %                      "open" - Simulates the open space.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            obj.AddToHistory(['.YmaxThermal "', num2str(ThermalBoundaryType, '%.15g'), '"']);
        end
        function ZminThermal(obj, ThermalBoundaryType)
            % ThermalBoundaryType: "isothermal" - Boundary condition with constant temperature (T=const). This boundary type can carry a temperature definition.
            %                      "adiabatic" - Boundary condition without any heat-flow through the boundary (dT / dN = 0).
            %                      "open" - Simulates the open space.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            obj.AddToHistory(['.ZminThermal "', num2str(ThermalBoundaryType, '%.15g'), '"']);
        end
        function ZmaxThermal(obj, ThermalBoundaryType)
            % ThermalBoundaryType: "isothermal" - Boundary condition with constant temperature (T=const). This boundary type can carry a temperature definition.
            %                      "adiabatic" - Boundary condition without any heat-flow through the boundary (dT / dN = 0).
            %                      "open" - Simulates the open space.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            obj.AddToHistory(['.ZmaxThermal "', num2str(ThermalBoundaryType, '%.15g'), '"']);
        end
        function enum = GetXminThermal(obj)
            % ThermalBoundaryType: "isothermal" - Boundary condition with constant temperature (T=const). This boundary type can carry a temperature definition.
            %                      "adiabatic" - Boundary condition without any heat-flow through the boundary (dT / dN = 0).
            %                      "open" - Simulates the open space.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            enum = obj.hBoundary.invoke('GetXminThermal');
        end
        function enum = GetXmaxThermal(obj)
            % ThermalBoundaryType: "isothermal" - Boundary condition with constant temperature (T=const). This boundary type can carry a temperature definition.
            %                      "adiabatic" - Boundary condition without any heat-flow through the boundary (dT / dN = 0).
            %                      "open" - Simulates the open space.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            enum = obj.hBoundary.invoke('GetXmaxThermal');
        end
        function enum = GetYminThermal(obj)
            % ThermalBoundaryType: "isothermal" - Boundary condition with constant temperature (T=const). This boundary type can carry a temperature definition.
            %                      "adiabatic" - Boundary condition without any heat-flow through the boundary (dT / dN = 0).
            %                      "open" - Simulates the open space.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            enum = obj.hBoundary.invoke('GetYminThermal');
        end
        function enum = GetYmaxThermal(obj)
            % ThermalBoundaryType: "isothermal" - Boundary condition with constant temperature (T=const). This boundary type can carry a temperature definition.
            %                      "adiabatic" - Boundary condition without any heat-flow through the boundary (dT / dN = 0).
            %                      "open" - Simulates the open space.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            enum = obj.hBoundary.invoke('GetYmaxThermal');
        end
        function enum = GetZminThermal(obj)
            % ThermalBoundaryType: "isothermal" - Boundary condition with constant temperature (T=const). This boundary type can carry a temperature definition.
            %                      "adiabatic" - Boundary condition without any heat-flow through the boundary (dT / dN = 0).
            %                      "open" - Simulates the open space.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            enum = obj.hBoundary.invoke('GetZminThermal');
        end
        function enum = GetZmaxThermal(obj)
            % ThermalBoundaryType: "isothermal" - Boundary condition with constant temperature (T=const). This boundary type can carry a temperature definition.
            %                      "adiabatic" - Boundary condition without any heat-flow through the boundary (dT / dN = 0).
            %                      "open" - Simulates the open space.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            enum = obj.hBoundary.invoke('GetZmaxThermal');
        end
        function XsymmetryThermal(obj, ThermalSymmetryType)
            % thermalSymmetryType: "isothermal" - Symmetry condition with constant temperature at the symmetry plane (T=const).
            %                      "adiabatic" - Symmetry condition without any heat-flow through the symmetry plane (dT / dN = 0).
            %                      "none" - No symmetry.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            obj.AddToHistory(['.XsymmetryThermal "', num2str(ThermalSymmetryType, '%.15g'), '"']);
        end
        function YsymmetryThermal(obj, ThermalSymmetryType)
            % thermalSymmetryType: "isothermal" - Symmetry condition with constant temperature at the symmetry plane (T=const).
            %                      "adiabatic" - Symmetry condition without any heat-flow through the symmetry plane (dT / dN = 0).
            %                      "none" - No symmetry.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            obj.AddToHistory(['.YsymmetryThermal "', num2str(ThermalSymmetryType, '%.15g'), '"']);
        end
        function ZsymmetryThermal(obj, ThermalSymmetryType)
            % thermalSymmetryType: "isothermal" - Symmetry condition with constant temperature at the symmetry plane (T=const).
            %                      "adiabatic" - Symmetry condition without any heat-flow through the symmetry plane (dT / dN = 0).
            %                      "none" - No symmetry.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            obj.AddToHistory(['.ZsymmetryThermal "', num2str(ThermalSymmetryType, '%.15g'), '"']);
        end
        function enum = GetXSymmetryThermal(obj)
            % thermalSymmetryType: "isothermal" - Symmetry condition with constant temperature at the symmetry plane (T=const).
            %                      "adiabatic" - Symmetry condition without any heat-flow through the symmetry plane (dT / dN = 0).
            %                      "none" - No symmetry.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            enum = obj.hBoundary.invoke('GetXSymmetryThermal');
        end
        function enum = GetYSymmetryThermal(obj)
            % thermalSymmetryType: "isothermal" - Symmetry condition with constant temperature at the symmetry plane (T=const).
            %                      "adiabatic" - Symmetry condition without any heat-flow through the symmetry plane (dT / dN = 0).
            %                      "none" - No symmetry.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            enum = obj.hBoundary.invoke('GetYSymmetryThermal');
        end
        function enum = GetZSymmetryThermal(obj)
            % thermalSymmetryType: "isothermal" - Symmetry condition with constant temperature at the symmetry plane (T=const).
            %                      "adiabatic" - Symmetry condition without any heat-flow through the symmetry plane (dT / dN = 0).
            %                      "none" - No symmetry.
            %                      "expanded open" - Same as "open" but adds some extra space to the calculation domain.
            enum = obj.hBoundary.invoke('GetZSymmetryThermal');
        end
        function XminTemperatureType(obj, type)
            % Specifies the temperature type of the lower and upper boundaries.
            % type: "none" - No temperature is set for  the corresponding boundary.
            %       "fixed" - On the boundaries a fixed temperature value can be defined by use of the corresponding Temperature methods (see below).
            %       "floating" - The temperature is defined as floating on the corresponding boundary.
            obj.AddToHistory(['.XminTemperatureType "', num2str(type, '%.15g'), '"']);
        end
        function XmaxTemperatureType(obj, type)
            % Specifies the temperature type of the lower and upper boundaries.
            % type: "none" - No temperature is set for  the corresponding boundary.
            %       "fixed" - On the boundaries a fixed temperature value can be defined by use of the corresponding Temperature methods (see below).
            %       "floating" - The temperature is defined as floating on the corresponding boundary.
            obj.AddToHistory(['.XmaxTemperatureType "', num2str(type, '%.15g'), '"']);
        end
        function YminTemperatureType(obj, type)
            % Specifies the temperature type of the lower and upper boundaries.
            % type: "none" - No temperature is set for  the corresponding boundary.
            %       "fixed" - On the boundaries a fixed temperature value can be defined by use of the corresponding Temperature methods (see below).
            %       "floating" - The temperature is defined as floating on the corresponding boundary.
            obj.AddToHistory(['.YminTemperatureType "', num2str(type, '%.15g'), '"']);
        end
        function YmaxTemperatureType(obj, type)
            % Specifies the temperature type of the lower and upper boundaries.
            % type: "none" - No temperature is set for  the corresponding boundary.
            %       "fixed" - On the boundaries a fixed temperature value can be defined by use of the corresponding Temperature methods (see below).
            %       "floating" - The temperature is defined as floating on the corresponding boundary.
            obj.AddToHistory(['.YmaxTemperatureType "', num2str(type, '%.15g'), '"']);
        end
        function ZminTemperatureType(obj, type)
            % Specifies the temperature type of the lower and upper boundaries.
            % type: "none" - No temperature is set for  the corresponding boundary.
            %       "fixed" - On the boundaries a fixed temperature value can be defined by use of the corresponding Temperature methods (see below).
            %       "floating" - The temperature is defined as floating on the corresponding boundary.
            obj.AddToHistory(['.ZminTemperatureType "', num2str(type, '%.15g'), '"']);
        end
        function ZmaxTemperatureType(obj, type)
            % Specifies the temperature type of the lower and upper boundaries.
            % type: "none" - No temperature is set for  the corresponding boundary.
            %       "fixed" - On the boundaries a fixed temperature value can be defined by use of the corresponding Temperature methods (see below).
            %       "floating" - The temperature is defined as floating on the corresponding boundary.
            obj.AddToHistory(['.ZmaxTemperatureType "', num2str(type, '%.15g'), '"']);
        end
        function XminTemperature(obj, value)
            % Specifies the temperature values of the lower and upper boundaries. This settings has only an effect if the type of the corresponding TemperatureType is set to "fixed".
            obj.AddToHistory(['.XminTemperature "', num2str(value, '%.15g'), '"']);
        end
        function XmaxTemperature(obj, value)
            % Specifies the temperature values of the lower and upper boundaries. This settings has only an effect if the type of the corresponding TemperatureType is set to "fixed".
            obj.AddToHistory(['.XmaxTemperature "', num2str(value, '%.15g'), '"']);
        end
        function YminTemperature(obj, value)
            % Specifies the temperature values of the lower and upper boundaries. This settings has only an effect if the type of the corresponding TemperatureType is set to "fixed".
            obj.AddToHistory(['.YminTemperature "', num2str(value, '%.15g'), '"']);
        end
        function YmaxTemperature(obj, value)
            % Specifies the temperature values of the lower and upper boundaries. This settings has only an effect if the type of the corresponding TemperatureType is set to "fixed".
            obj.AddToHistory(['.YmaxTemperature "', num2str(value, '%.15g'), '"']);
        end
        function ZminTemperature(obj, value)
            % Specifies the temperature values of the lower and upper boundaries. This settings has only an effect if the type of the corresponding TemperatureType is set to "fixed".
            obj.AddToHistory(['.ZminTemperature "', num2str(value, '%.15g'), '"']);
        end
        function ZmaxTemperature(obj, value)
            % Specifies the temperature values of the lower and upper boundaries. This settings has only an effect if the type of the corresponding TemperatureType is set to "fixed".
            obj.AddToHistory(['.ZmaxTemperature "', num2str(value, '%.15g'), '"']);
        end
        %% Undocumented functions.
        % Found in history list of migrated CST 2014 file in 'define boundaries'
        function ApplyInAllDirectionsThermal(obj, boolean)
            obj.AddToHistory(['.ApplyInAllDirectionsThermal "', num2str(boolean, '%.15g'), '"']);
        end
        % Found in history list of migrated CST 2014 file in 'define pml specials'
        function ReflectionLevel(obj, level)
            obj.AddToHistory(['.ReflectionLevel "', num2str(level, '%.15g'), '"']);
        end
        %% Utility functions.
        function AllBoundaries(obj, xmin, xmax, ymin, ymax, zmin, zmax)
            if(nargin == 2)
                xmax = xmin;
                ymin = xmin;
                ymax = xmin;
                zmin = xmin;
                zmax = xmin;
            end

            obj.Xmin(xmin);
            obj.Xmax(xmax);
            obj.Ymin(ymin);
            obj.Ymax(ymax);
            obj.Zmin(zmin);
            obj.Zmax(zmax);
            obj.ApplyInAllDirections(0);
%             history = ['With Boundary', newline, ...
%                        '.ApplyInAllDirections "False"', newline, ...
%                        '     .Xmin "', xmin, '"', newline, ...
%                        '     .Xmax "', xmax, '"', newline, ...
%                        '     .Ymin "', ymin, '"', newline, ...
%                        '     .Ymax "', ymax, '"', newline, ...
%                        '     .Zmin "', zmin, '"', newline, ...
%                        '     .Zmax "', zmax, '"', newline, ...
%                        'End With'];
%             obj.project.AddToHistory('define boundaries', history);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hBoundary
        history
        bulkmode

    end
end

%% Default Values
% Xmin('electric')
% Xmax('electric')
% Ymin('electric')
% Ymax('electric')
% Zmin('electric')
% Zmax('electric')
% Xsymmetry('none')
% Ysymmetry('none')
% Zsymmetry('none')
% ApplyInAllDirections(0)
% XminTemperatureType('none')
% XmaxTemperatureType('none')
% YminTemperatureType('none')
% YmaxTemperatureType('none')
% ZminTemperatureType('none')
% ZmaxTemperatureType('none')
% XminPotentialType('none')
% XmaxPotentialType('none')
% YminPotentialType('none')
% YmaxPotentialType('none')
% ZminPotentialType('none')
% ZmaxPotentialType('none')
% Layer(4)
% Reflection(0.0001)
% MinimumLinesDistance(5)
% MinimumDistancePerWavelength (8)
% SetConvPMLExponentM(3)
% SetConvPMLKMax(5)
% SetConvPMLOuterBoundary('MAG')
% ActivePMLFactor (1.0)
% XPeriodicShift(0.0)
% YPeriodicShift(0.0)
% ZPeriodicShift(0.0)
% PeriodicUseConstantAngles(0)
% SetPeriodicBoundaryAnglesDirection('outward')
% SetPeriodicBoundaryAngles(0.0, 0.0)
% UnitCellFitToBoundingBox(1)
% UnitCellAngle(90.0)
% UnitCellOrigin(0.0, 0.0)
% MinimumDistanceAtCenterFrequency(1)

%% Example - Taken from CST documentation and translated to MATLAB.
% boundary = project.Boundary();
%      boundary.Xmin('electric');
%      boundary.Xmax('electric');
%      boundary.Ymin('electric');
%      boundary.Ymax('electric');
%      boundary.Zmin('electric');
%      boundary.Zmax('electric');
%      boundary.Xsymmetry('none');
%      boundary.Ysymmetry('none');
%      boundary.Zsymmetry('none');
%      boundary.ApplyInAllDirections(False);
%      boundary.XPeriodicShift(45.0);
%      boundary.YPeriodicShift(0.0);
%      boundary.ZPeriodicShift(0.0);
%      boundary.PeriodicUseConstantAngles(True);
%      boundary.SetPeriodicBoundaryAngles(30.0, 0.0);
%      boundary.XminPotential('');
%      boundary.XmaxPotential('');
%      boundary.YminPotential('');
%      boundary.YmaxPotential('');
%      boundary.ZmaxPotential('');