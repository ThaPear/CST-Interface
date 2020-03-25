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

% The Material Object lets you define or change materials. Each material defines the material constants of the associated solids.
classdef Material < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Material object.
        function obj = Material(project, hProject)
            obj.project = project;
            obj.hMaterial = hProject.invoke('Material');
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
        %% General
        function Reset(obj)
            % Sets all internal settings to their defaults.
            obj.AddToHistory(['.Reset']);
            obj.folder = '';
            obj.name = '';
        end
        function Create(obj)
            % Creates a new material. All necessary settings have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Material and append End With
            obj.history = [ 'With Material', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Material: ', obj.name], obj.history);
            obj.history = [];
        end
        function Name(obj, name)
            % Sets the name for the new material to be created using .Create.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Folder(obj, foldername)
            % Sets the name for the new material folder to be created using .Create. If the name is empty, then the material does not belong to a folder.
            obj.AddToHistory(['.Folder "', num2str(foldername, '%.15g'), '"']);
            obj.folder = foldername;
        end
        function Type(obj, key)
            % Sets the type for the material to be defined.  
            % key: 'PEC'
            %      'Normal'
            %      'Anisotropic'
            %      'Lossy Metal'
            %      'Corrugated wall'
            %      'Ohmic sheet'
            %      'Tensor formula'
            %      'Nonlinear'
            obj.AddToHistory(['.Type "', num2str(key, '%.15g'), '"']);
            obj.type = key;
        end
        function MaterialUnit(obj, Key, Unit)
            % Sets frequency, time and length units for the material to be defined.
            % All relevant units for the frequency, like for the reference tangent delta (electric or magnetic), for the dispersion, tangent delta or surface impedance list will be displayed and interpreted accordingly to this frequency scale unit.
            % In similar way all (possibly) corrugation properties or coating of the material will be will be displayed and interpreted accordingly to the given length scale unit.
            % Similar considerations apply to the time dependent material properties which will be displayed and interpreted accordingly to the given time scale unit.
            % The available combination of Key and Unit are as follows:
            % if the Key is "Frequency", the available enum values for the Unit  field are { "Hz", "KHz", "MHz", "GHz", "THz", "PHz" };
            % if the Key is "Geometry", the available enum values for the Unit  field are { "m", "cm", "mm", "um", "nm", "ft", "mil", "in" };
            % if the Key is "Time", the available enum values for the Unit  field are { "fs", "ps", "ns", "us", "ms", "s" }.
            % if the Key is "Temperature", the available enum values for the Unit  field are { "Kelvin", "Celsius" or "Fahrenheit" }.
            % Once that frequency, time, length and temperature units are defined by means of  MaterialUnit command, successive project changes in terms of global unit scale will not affect the material properties.
            obj.AddToHistory(['.MaterialUnit "', num2str(Key, '%.15g'), '", '...
                                            '"', num2str(Unit, '%.15g'), '"']);
            obj.materialunit.Key = Key;
            obj.materialunit.Unit = Unit;
        end
        function Delete(obj, name)
            % Deletes an existing material with the specified name and all shapes the material is assigned to.
            obj.AddToHistory(['.Delete "', num2str(name, '%.15g'), '"']);
            obj.delete = name;
        end
        function Rename(obj, sOldName, sNewName)
            % Renames the object specified by sOldName to sNewName.
            obj.AddToHistory(['.Rename "', num2str(sOldName, '%.15g'), '", '...
                                      '"', num2str(sNewName, '%.15g'), '"']);
            obj.rename.sOldName = sOldName;
            obj.rename.sNewName = sNewName;
        end
        function NewFolder(obj, foldername)
            % Creates a new folder with the given name.
            obj.project.AddToHistory(['Material.NewFolder "', num2str(foldername, '%.15g'), '"']);
            obj.newfolder = foldername;
        end
        function DeleteFolder(obj, foldername)
            % Deletes an existing folder and all the containing elements.
            obj.project.AddToHistory(['Material.DeleteFolder "', num2str(foldername, '%.15g'), '"']);
            obj.deletefolder = foldername;
        end
        function RenameFolder(obj, oldFoldername, newFoldername)
            % Changes the name of an existing folder.
            obj.project.AddToHistory(['Material.RenameFolder "', num2str(oldFoldername, '%.15g'), '", '...
                                                            '"', num2str(newFoldername, '%.15g'), '"']);
            obj.renamefolder.oldFoldername = oldFoldername;
            obj.renamefolder.newFoldername = newFoldername;
        end
        %% Appearance
        function Colour(obj, red, green, blue)
            % Sets the color for a new material by double values ranging from 0 to 1.
            obj.AddToHistory(['.Colour "', num2str(red, '%.15g'), '", '...
                                      '"', num2str(green, '%.15g'), '", '...
                                      '"', num2str(blue, '%.15g'), '"']);
            obj.colour.red = red;
            obj.colour.green = green;
            obj.colour.blue = blue;
        end
        function Transparency(obj, dValue)
            % Allows to changes the appearance from opaque (dValue = 0) to a transparency value up to 100. Setting will be ignored if .Wireframe is set.
            obj.AddToHistory(['.Transparency "', num2str(dValue, '%.15g'), '"']);
            obj.transparency = dValue;
        end
        function Wireframe(obj, boolean)
            % If switch is True, all solids associated with this material will be displayed as a wireframe.
            obj.AddToHistory(['.Wireframe "', num2str(boolean, '%.15g'), '"']);
            obj.wireframe = boolean;
        end
        function Reflection(obj, boolean)
            % If switch is True, all solids associated with this material are displayed using reflective surfaces (usually applied to metallic surfaces).
            obj.AddToHistory(['.Reflection "', num2str(boolean, '%.15g'), '"']);
            obj.reflection = boolean;
        end
        function Allowoutline(obj, boolean)
            % Determine whether outlines are allowed to be drawn for solids belonging to this material. The actual visibility of outlines also depends on the setting of the global outline state as well as the current selection. If switch is False, outlines will never be drawn for the corresponding solids.
            obj.AddToHistory(['.Allowoutline "', num2str(boolean, '%.15g'), '"']);
            obj.allowoutline = boolean;
        end
        function Transparentoutline(obj, boolean)
            % If switch is True, outlines are also displayed when the corresponding solids are drawn transparently.
            obj.AddToHistory(['.Transparentoutline "', num2str(boolean, '%.15g'), '"']);
            obj.transparentoutline = boolean;
        end
        function ChangeColour(obj)
            % Changes the appearance for an existing material specified by the .Name method to the settings given by the .Colour, .Transparency or .Wireframe method. Changes to other parameters will not be taken. The execution of this method will - in contrast to .Create - not be regarded as a structural change and though not require the deletion of results.
            obj.AddToHistory(['.ChangeColour']);
            
            % Prepend With and append End With 
            obj.history = ['With Material', newline, obj.history, 'End With']; 
            obj.project.AddToHistory(['define material colour: ', obj.name], obj.history); 
            obj.history = []; 
        end
        %% Basic Material Parameters
        function Epsilon(obj, dValue)
            % Defines the relative electric permittivity. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal electric permittivity tensor can be set with the respective methods.
            obj.AddToHistory(['.Epsilon "', num2str(dValue, '%.15g'), '"']);
            obj.epsilon = dValue;
        end
        function EpsilonX(obj, dValue)
            % Defines the relative electric permittivity. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal electric permittivity tensor can be set with the respective methods.
            obj.AddToHistory(['.EpsilonX "', num2str(dValue, '%.15g'), '"']);
            obj.epsilonx = dValue;
        end
        function EpsilonY(obj, dValue)
            % Defines the relative electric permittivity. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal electric permittivity tensor can be set with the respective methods.
            obj.AddToHistory(['.EpsilonY "', num2str(dValue, '%.15g'), '"']);
            obj.epsilony = dValue;
        end
        function EpsilonZ(obj, dValue)
            % Defines the relative electric permittivity. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal electric permittivity tensor can be set with the respective methods.
            obj.AddToHistory(['.EpsilonZ "', num2str(dValue, '%.15g'), '"']);
            obj.epsilonz = dValue;
        end
        function Mu(obj, dValue)
            % Defines the relative permeability. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal permeability tensor can be set with the respective methods.
            obj.AddToHistory(['.Mu "', num2str(dValue, '%.15g'), '"']);
            obj.mu = dValue;
        end
        function MuX(obj, dValue)
            % Defines the relative permeability. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal permeability tensor can be set with the respective methods.
            obj.AddToHistory(['.MuX "', num2str(dValue, '%.15g'), '"']);
            obj.mux = dValue;
        end
        function MuY(obj, dValue)
            % Defines the relative permeability. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal permeability tensor can be set with the respective methods.
            obj.AddToHistory(['.MuY "', num2str(dValue, '%.15g'), '"']);
            obj.muy = dValue;
        end
        function MuZ(obj, dValue)
            % Defines the relative permeability. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal permeability tensor can be set with the respective methods.
            obj.AddToHistory(['.MuZ "', num2str(dValue, '%.15g'), '"']);
            obj.muz = dValue;
        end
        function Rho(obj, dValue)
            % (*) property shared among all available material sets property shared among all available material sets
            % Sets the material density value of the material in kg/m³, i.e. used for SAR calculations.
            % This setting is important for transient thermal simulations.
            obj.AddToHistory(['.Rho "', num2str(dValue, '%.15g'), '"']);
            obj.rho = dValue;
        end
        function AddCoatedMaterial(obj, materialname, thickness)
            % Used for the coated materials feature. This function defines one layer. Materialname is the name of the material which is used for the coat and thickness defines the thickness of this material.
            obj.AddToHistory(['.AddCoatedMaterial "', num2str(materialname, '%.15g'), '", '...
                                                 '"', num2str(thickness, '%.15g'), '"']);
            obj.addcoatedmaterial.materialname = materialname;
            obj.addcoatedmaterial.thickness = thickness;
        end
        function ReferenceCoordSystem(obj, key)
            % Specifies whether the given material settings are to be interpreted in global coordinates or relative to local solid coordinates. By default, global coordinate settings are considered. The advantage of local solid coordinates is that if the material is applied to multiple solids the material orientation does not change when single solids are transformed. This is useful, in particular, for anisotropic materials. This setting will be ignored for other material types.
            % Please note that local solid coordinate settings are considered only by tetrahedral solvers.
            % key: 'Global'
            %      'Solid'
            obj.AddToHistory(['.ReferenceCoordSystem "', num2str(key, '%.15g'), '"']);
            obj.referencecoordsystem = key;
        end
        function CoordSystemType(obj, key)
            % Defines the type of the coordinate system in which the material settings are given. This is meaningful, in particular, for anisotropic materials. This setting will be ignored for other material types. By default, all material settings are interpreted in Cartesian coordinates (x/y/z or u/v/w depending on the reference coordinate system specified under ReferenceCoordSystem). It is also possible to prescribe settings (like permeability, permittivity or conductivity) in cylindrical or spherical coordinates. To this end, the same commands are used (e.g. EpsilonX/EpsilonY/EpsilonZ), but they are interpreted as (R/phi/z) or (r/theta/phi), respectively.
            % For cylindrical coordinates (R,phi,z), the first component means the radial direction, where the radius R is the distance to the z/w axis. The second component prescribes the angular direction, where the azimuth phi is the angle to the x-z-plane (u-w-plane). The third component is the longitudinal direction and coincides with the Cartesian z/w component.
            % For spherical coordinates (r,theta,phi), the radius r specifies the distance to the origin, theta is the inclination (zenith angle) measured from the z-axis, and phi is the azimuth (angle to the x-z-plane/u-w-plane).
            % Please note that non-Cartesian coordinate settings are considered only by tetrahedral solvers.
            % key: 'Cartesian'
            %      'Cylindrical'
            %      'Spherical'
            obj.AddToHistory(['.CoordSystemType "', num2str(key, '%.15g'), '"']);
            obj.coordsystemtype = key;
        end
        %% Surface Impedance / Thin Panel Materials
        function Corrugation(obj, depth, gapwidth, toothwidth)
            % Sets the parameter for the Corrugated wall material type, which is a planar surface with a periodically repeated rectangular corrugation with a certain depth, gapwidth, and a small toothwidth. The corrugation depth must be much larger than the corrugation width for the model to be valid. The number of corrugations per wavelength should be large, with ten per wavelength being the lowest limit. There is a resonance in the effective material behavior when the corrugation depth is close to a quarter wavelength and its odd multiples.
            % When truly modeling these surfaces the mesh would end up with a very high number of mesh cells in order to represent all details. However, in many cases such as S-Parameter calculations  the exact field solution inside the corrugation is not of interest. Then it is sufficient to replace the real corrugation by a appropriate material with the same macroscopic properties. Much like the lossy metal, a surface impedance model is used to relate fields on the corrugated wall surface.
            % The theoretical formula for corrugated wall surface impedance may be directly computed by the frequency domain solvers but due to its high non-linear frequency dependence is not straightforward applicable to the transient solver. To this purpose a specific fitting and representation of the impedance, based on a proprietary resonance expansion mode algorithm, will be automatically computed. This model leads to an accurate representation and results within the simulation frequency bandwidth.
            % Please note that this type of material is available only for the transient solver and the tetrahedral frequency domain solver.
            obj.AddToHistory(['.Corrugation "', num2str(depth, '%.15g'), '", '...
                                           '"', num2str(gapwidth, '%.15g'), '", '...
                                           '"', num2str(toothwidth, '%.15g'), '"']);
            obj.corrugation.depth = depth;
            obj.corrugation.gapwidth = gapwidth;
            obj.corrugation.toothwidth = toothwidth;
        end
        function OhmicSheetImpedance(obj, resistance, reactance)
            % Defines the impedance value (resistance and reactance) of an Ohmic sheet material type. A surface impedance model is used to relate fields on the ohmic sheet surface. The complex impedance will be assumed defined or measured in correspondence of the reference frequency provided by the command OhmicSheetFreq.
            % Frequency domain solvers may assume and compute a constant (i.e. frequency independent) complex impedance for the Ohmic sheet. This constant model may be generally "non-physical" (due to the so called Kramers-Kronig relations) and may lead to "non-causal" effects. Therefore, for the transient solver, a first order (Debye) model of the impedance will be assumed which exactly interpolates the user given impedance in correspondence of the reference frequency.
            % Please note that this type of material is available only for the transient solver and the tetrahedral frequency domain solver.
            % To define a frequency-dependent ohmic sheet, please use the command .SetTabulatedSurfaceImpedanceModel with a "Transparent" surface impedance model.
            obj.AddToHistory(['.OhmicSheetImpedance "', num2str(resistance, '%.15g'), '", '...
                                                   '"', num2str(reactance, '%.15g'), '"']);
            obj.ohmicsheetimpedance.resistance = resistance;
            obj.ohmicsheetimpedance.reactance = reactance;
        end
        function OhmicSheetFreq(obj, frequency)
            % Defines the reference frequency value of an Ohmic sheet material type where the corresponding impedance will be defined or measured. This value will be used to compute the first order (Debye) model and to exactly interpolate the user given impedance value (resistance and reactance).
            % In case the reference frequency will not be provided the center value of the frequency simulation range will be automatically assumed.
            % Please note that this type of material is available only for the transient solver and the tetrahedral frequency domain solver.
            obj.AddToHistory(['.OhmicSheetFreq "', num2str(frequency, '%.15g'), '"']);
            obj.ohmicsheetfreq = frequency;
        end
        function SetTabulatedSurfaceImpedanceModel(obj, model)
            % Enables an isotropic Tabulated surface impedance (resistance and reactance versus frequency), where model defines the way fields on opposite sides of infinitely thin sheets couple. With an "Opaque" model, there is no coupling between front and back side of surface impedance sheets, while "Transparent" means that the electric field on both sides of a sheet is the same. The actual material data is defined by calling .AddTabulatedSurfaceImpedanceValue.
            % Please note that this type of material is available only for the transient solver and the tetrahedral frequency domain solver.
            % model: 'Opaque'
            %        'Transparent'
            obj.AddToHistory(['.SetTabulatedSurfaceImpedanceModel "', num2str(model, '%.15g'), '"']);
            obj.settabulatedsurfaceimpedancemodel = model;
        end
        function AddTabulatedSurfaceImpedanceFittingValue(obj, frequency, resistance, reactance, weight)
            % Defines an entry of the frequency-dependent, tabulated impedance values by means of resistance and reactance of a Tabulated surface impedance material type. The frequency is given in the currently active unit for frequencies. See also .SetTabulatedSurfaceImpedanceModel.
            % Moreover a weight, i.e. a double value greater than/equal to 0.0, is assigned to each frequency in order to direct the interpolation algorithm and to enforce a reduced error in correspondence of the given frequency point.
            % Please note that this type of material is available only for the transient solver and the tetrahedral frequency domain solver.
            obj.AddToHistory(['.AddTabulatedSurfaceImpedanceFittingValue "', num2str(frequency, '%.15g'), '", '...
                                                                        '"', num2str(resistance, '%.15g'), '", '...
                                                                        '"', num2str(reactance, '%.15g'), '", '...
                                                                        '"', num2str(weight, '%.15g'), '"']);
            obj.addtabulatedsurfaceimpedancefittingvalue.frequency = frequency;
            obj.addtabulatedsurfaceimpedancefittingvalue.resistance = resistance;
            obj.addtabulatedsurfaceimpedancefittingvalue.reactance = reactance;
            obj.addtabulatedsurfaceimpedancefittingvalue.weight = weight;
        end
        function AddTabulatedSurfaceImpedanceValue(obj, frequency, resistance, reactance)
            % Defines an entry of the frequency-dependent, tabulated impedance values by means of resistance and reactance of a Tabulated surface impedance material type. The frequency is given in the currently active unit for frequencies. See also .SetTabulatedSurfaceImpedanceModel.
            % Moreover a weight, i.e. a double value greater than/equal to 0.0, is assigned to each frequency in order to direct the interpolation algorithm and to enforce a reduced error in correspondence of the given frequency point.
            % Please note that this type of material is available only for the transient solver and the tetrahedral frequency domain solver.
            obj.AddToHistory(['.AddTabulatedSurfaceImpedanceValue "', num2str(frequency, '%.15g'), '", '...
                                                                 '"', num2str(resistance, '%.15g'), '", '...
                                                                 '"', num2str(reactance, '%.15g'), '"']);
            obj.addtabulatedsurfaceimpedancevalue.frequency = frequency;
            obj.addtabulatedsurfaceimpedancevalue.resistance = resistance;
            obj.addtabulatedsurfaceimpedancevalue.reactance = reactance;
        end
        function DispersiveFittingSchemeTabSI(obj, key)
            % Sets the required fitting scheme for the tabulated surface impedance. Actually only Nth Order general fitting is allowed, due to its generality and wide application range.
            % key: 'Nth Order'
            obj.AddToHistory(['.DispersiveFittingSchemeTabSI "', num2str(key, '%.15g'), '"']);
            obj.dispersivefittingschemetabsi = key;
        end
        function MaximalOrderNthModelFitTabSI(obj, iValue)
            % Set the maximum allowed order for the nth fit interpolation scheme ("Nth Order"), for the tabulated surface impedance. The maximum number of poles is directly related both to the fitting accuracy and to the model complexity and therefore to simulation memory and computational time requirements.
            obj.AddToHistory(['.MaximalOrderNthModelFitTabSI "', num2str(iValue, '%.15g'), '"']);
            obj.maximalordernthmodelfittabsi = iValue;
        end
        function UseOnlyDataInSimFreqRangeNthModelTabSI(obj, boolean)
            % Allow the nth order fit interpolation scheme ("Nth Order"), for the tabulated surface impedance, to use only the frequency data points that lie within the "frequency range settings" defined by the user. Activating this switch enables an accurate data fitting of the material resonances which occur in the simulation bandwidth of interest using possibly a reduced number of poles and zeroes with respect to the complete data fitting. And this, in turn, translates into benefits for the simulation complexity in terms of memory and computational time.
            obj.AddToHistory(['.UseOnlyDataInSimFreqRangeNthModelTabSI "', num2str(boolean, '%.15g'), '"']);
            obj.useonlydatainsimfreqrangenthmodeltabsi = boolean;
        end
        function ErrorLimitNthModelFitTabSI(obj, limit)
            % Defines the error limit goal (threshold) for the nth fit interpolation scheme ("Nth Order"), for the tabulated surface impedance. The maximum number of poles is directly related both to the fitting accuracy and to the model complexity and therefore to simulation memory and computational time requirements.
            obj.AddToHistory(['.ErrorLimitNthModelFitTabSI "', num2str(limit, '%.15g'), '"']);
            obj.errorlimitnthmodelfittabsi = limit;
        end
        function TabulatedCompactModel(obj, boolean)
            % Set the current material as tabulated compact model. The complete material parameters will be specified by means of the following commands.
            obj.AddToHistory(['.TabulatedCompactModel "', num2str(boolean, '%.15g'), '"']);
            obj.tabulatedcompactmodel = boolean;
        end
        function ResetTabulatedCompactModelList(obj)
            % Remove any previously defined tabulated compact model item.
            obj.AddToHistory(['.ResetTabulatedCompactModelList']);
        end
        function SetTabulatedCompactModelImpedance(obj, impedance_p1, impedance_p2)
            % Specify the port reference impedance for the compact model S parameter. In case of symmetric model (i.e. the two ports are completely equivalent and they could be exchanged without altering the model) only one impedance is required. The command SetSymmTabulatedCompactModelImpedance allows this simplified description assuming impedance_p1 = impedance_p2.
            obj.AddToHistory(['.SetTabulatedCompactModelImpedance "', num2str(impedance_p1, '%.15g'), '", '...
                                                                 '"', num2str(impedance_p2, '%.15g'), '"']);
            obj.settabulatedcompactmodelimpedance.impedance_p1 = impedance_p1;
            obj.settabulatedcompactmodelimpedance.impedance_p2 = impedance_p2;
        end
        function SetSymmTabulatedCompactModelImpedance(obj, impedance_p)
            % Specify the port reference impedance for the compact model S parameter. In case of symmetric model (i.e. the two ports are completely equivalent and they could be exchanged without altering the model) only one impedance is required. The command SetSymmTabulatedCompactModelImpedance allows this simplified description assuming impedance_p1 = impedance_p2.
            obj.AddToHistory(['.SetSymmTabulatedCompactModelImpedance "', num2str(impedance_p, '%.15g'), '"']);
            obj.setsymmtabulatedcompactmodelimpedance = impedance_p;
        end
        function AddTabulatedCompactModelItem(obj, frequency, S11_r, S11_i, S21_r, S21_i, S12_r, S12_i, S22_r, S22_i, weight)
            % Defines an entry of the frequency-dependent tabulated compact model values by means of the real and imaginary part of the S parameter. The frequency is given in the currently active unit for frequencies. Moreover a weight, i.e. a double value greater than/equal to 0.0, is assigned to each frequency in order to direct the interpolation algorithm and to enforce a reduced error in correspondence of the given frequency point.
            % In case of symmetric compact model (i.e. the two sides are completely equivalent and they could be exchanged without altering the model) only the S11 and S21 parameter needs to be specified. The remaining parameters will be computed by symmetry assuming S22 = S11 and S12 = S21.
            obj.AddToHistory(['.AddTabulatedCompactModelItem "', num2str(frequency, '%.15g'), '", '...
                                                            '"', num2str(S11_r, '%.15g'), '", '...
                                                            '"', num2str(S11_i, '%.15g'), '", '...
                                                            '"', num2str(S21_r, '%.15g'), '", '...
                                                            '"', num2str(S21_i, '%.15g'), '", '...
                                                            '"', num2str(S12_r, '%.15g'), '", '...
                                                            '"', num2str(S12_i, '%.15g'), '", '...
                                                            '"', num2str(S22_r, '%.15g'), '", '...
                                                            '"', num2str(S22_i, '%.15g'), '", '...
                                                            '"', num2str(weight, '%.15g'), '"']);
            obj.addtabulatedcompactmodelitem.frequency = frequency;
            obj.addtabulatedcompactmodelitem.S11_r = S11_r;
            obj.addtabulatedcompactmodelitem.S11_i = S11_i;
            obj.addtabulatedcompactmodelitem.S21_r = S21_r;
            obj.addtabulatedcompactmodelitem.S21_i = S21_i;
            obj.addtabulatedcompactmodelitem.S12_r = S12_r;
            obj.addtabulatedcompactmodelitem.S12_i = S12_i;
            obj.addtabulatedcompactmodelitem.S22_r = S22_r;
            obj.addtabulatedcompactmodelitem.S22_i = S22_i;
            obj.addtabulatedcompactmodelitem.weight = weight;
        end
        function AddSymmTabulatedCompactModelItem(obj, frequency, S11_r, S11_i, S21_r, S21_i, weight)
            % Defines an entry of the frequency-dependent tabulated compact model values by means of the real and imaginary part of the S parameter. The frequency is given in the currently active unit for frequencies. Moreover a weight, i.e. a double value greater than/equal to 0.0, is assigned to each frequency in order to direct the interpolation algorithm and to enforce a reduced error in correspondence of the given frequency point.
            % In case of symmetric compact model (i.e. the two sides are completely equivalent and they could be exchanged without altering the model) only the S11 and S21 parameter needs to be specified. The remaining parameters will be computed by symmetry assuming S22 = S11 and S12 = S21.
            obj.AddToHistory(['.AddSymmTabulatedCompactModelItem "', num2str(frequency, '%.15g'), '", '...
                                                                '"', num2str(S11_r, '%.15g'), '", '...
                                                                '"', num2str(S11_i, '%.15g'), '", '...
                                                                '"', num2str(S21_r, '%.15g'), '", '...
                                                                '"', num2str(S21_i, '%.15g'), '", '...
                                                                '"', num2str(weight, '%.15g'), '"']);
            obj.addsymmtabulatedcompactmodelitem.frequency = frequency;
            obj.addsymmtabulatedcompactmodelitem.S11_r = S11_r;
            obj.addsymmtabulatedcompactmodelitem.S11_i = S11_i;
            obj.addsymmtabulatedcompactmodelitem.S21_r = S21_r;
            obj.addsymmtabulatedcompactmodelitem.S21_i = S21_i;
            obj.addsymmtabulatedcompactmodelitem.weight = weight;
        end
        function TabulatedCompactModelAnisotropic(obj, boolean)
            % Set the current material as tabulated compact model with anisotropic model. For further information see the Material Overview (HF) - Thin Panel section.
            % In case of isotropic material the tangential field components (denoted as "u" and "v") at the ports are completely equivalent and interchangeable. The material is therefore characterized by the four S11, S21, S12 and S22 parameters.
            % In case of anisotropic material the "u" and "v" field components possibly behave differently and the material has to be treated as a 4 port system. The model can be described by a S block matrix where each block is a 2x2 S parameter matrix for the selected pair of field components (uu, uv, vu and vv) leading to 16 parameters in a total.
            obj.AddToHistory(['.TabulatedCompactModelAnisotropic "', num2str(boolean, '%.15g'), '"']);
            obj.tabulatedcompactmodelanisotropic = boolean;
        end
        function AddAnisoTabulatedCompactModelItem(obj, entry_block, frequency, S11_r, S11_i, S21_r, S21_i, S12_r, S12_i, S22_r, S22_i, weight)
            % The two commands are a generalization of the previous ones and allow the specification of a general anisotropic compact model (see the TabulatedCompactModelAnisotropic command). In this case the S parameters need to be specified separately for the four field component combinations. Denoting as "u" and "v" the tangential field components leads to the specification of the "uu", "vu", "uv", "vv" blocks - 16 S parameters in a total. For further information see the Material Overview (HF) - Thin Panel section.
            % The entry_block key (belonging to the set "uu", "vu", "uv", "vv") selects the corresponding matrix block (i.e. the tangential components).
            % The frequency is given in the currently active unit for frequencies and to each frequency the real and imaginary part of the S parameter is specified.
            % Moreover a weight, i.e. a double value greater than/equal to 0.0, is assigned to each frequency in order to direct the interpolation algorithm and to enforce a reduced error in correspondence of the given frequency point.
            % In case of symmetric compact model (i.e. the two sides of the thin panel are completely equivalent and they could be exchanged without altering the model) only the S11 and S21 parameter needs to be specified for each entry_block key ("uu", "vu", "uv", "vv"). The remaining parameters will be computed by symmetry assuming S22 = S11 and S12 = S21. The AddAnisoSymmTabulatedCompactModelItem allows this more compact representation.
            obj.AddToHistory(['.AddAnisoTabulatedCompactModelItem "', num2str(entry_block, '%.15g'), '", '...
                                                                 '"', num2str(frequency, '%.15g'), '", '...
                                                                 '"', num2str(S11_r, '%.15g'), '", '...
                                                                 '"', num2str(S11_i, '%.15g'), '", '...
                                                                 '"', num2str(S21_r, '%.15g'), '", '...
                                                                 '"', num2str(S21_i, '%.15g'), '", '...
                                                                 '"', num2str(S12_r, '%.15g'), '", '...
                                                                 '"', num2str(S12_i, '%.15g'), '", '...
                                                                 '"', num2str(S22_r, '%.15g'), '", '...
                                                                 '"', num2str(S22_i, '%.15g'), '", '...
                                                                 '"', num2str(weight, '%.15g'), '"']);
            obj.addanisotabulatedcompactmodelitem.entry_block = entry_block;
            obj.addanisotabulatedcompactmodelitem.frequency = frequency;
            obj.addanisotabulatedcompactmodelitem.S11_r = S11_r;
            obj.addanisotabulatedcompactmodelitem.S11_i = S11_i;
            obj.addanisotabulatedcompactmodelitem.S21_r = S21_r;
            obj.addanisotabulatedcompactmodelitem.S21_i = S21_i;
            obj.addanisotabulatedcompactmodelitem.S12_r = S12_r;
            obj.addanisotabulatedcompactmodelitem.S12_i = S12_i;
            obj.addanisotabulatedcompactmodelitem.S22_r = S22_r;
            obj.addanisotabulatedcompactmodelitem.S22_i = S22_i;
            obj.addanisotabulatedcompactmodelitem.weight = weight;
        end
        function AddAnisoSymmTabulatedCompactModelItem(obj, entry_block, frequency, S11_r, S11_i, S21_r, S21_i, weight)
            % The two commands are a generalization of the previous ones and allow the specification of a general anisotropic compact model (see the TabulatedCompactModelAnisotropic command). In this case the S parameters need to be specified separately for the four field component combinations. Denoting as "u" and "v" the tangential field components leads to the specification of the "uu", "vu", "uv", "vv" blocks - 16 S parameters in a total. For further information see the Material Overview (HF) - Thin Panel section.
            % The entry_block key (belonging to the set "uu", "vu", "uv", "vv") selects the corresponding matrix block (i.e. the tangential components).
            % The frequency is given in the currently active unit for frequencies and to each frequency the real and imaginary part of the S parameter is specified.
            % Moreover a weight, i.e. a double value greater than/equal to 0.0, is assigned to each frequency in order to direct the interpolation algorithm and to enforce a reduced error in correspondence of the given frequency point.
            % In case of symmetric compact model (i.e. the two sides of the thin panel are completely equivalent and they could be exchanged without altering the model) only the S11 and S21 parameter needs to be specified for each entry_block key ("uu", "vu", "uv", "vv"). The remaining parameters will be computed by symmetry assuming S22 = S11 and S12 = S21. The AddAnisoSymmTabulatedCompactModelItem allows this more compact representation.
            obj.AddToHistory(['.AddAnisoSymmTabulatedCompactModelItem "', num2str(entry_block, '%.15g'), '", '...
                                                                     '"', num2str(frequency, '%.15g'), '", '...
                                                                     '"', num2str(S11_r, '%.15g'), '", '...
                                                                     '"', num2str(S11_i, '%.15g'), '", '...
                                                                     '"', num2str(S21_r, '%.15g'), '", '...
                                                                     '"', num2str(S21_i, '%.15g'), '", '...
                                                                     '"', num2str(weight, '%.15g'), '"']);
            obj.addanisosymmtabulatedcompactmodelitem.entry_block = entry_block;
            obj.addanisosymmtabulatedcompactmodelitem.frequency = frequency;
            obj.addanisosymmtabulatedcompactmodelitem.S11_r = S11_r;
            obj.addanisosymmtabulatedcompactmodelitem.S11_i = S11_i;
            obj.addanisosymmtabulatedcompactmodelitem.S21_r = S21_r;
            obj.addanisosymmtabulatedcompactmodelitem.S21_i = S21_i;
            obj.addanisosymmtabulatedcompactmodelitem.weight = weight;
        end
        function MaximalOrderFitTabulatedCompactModel(obj, iValue)
            % Set the maximum allowed order for the fit interpolation scheme for the tabulated compact model. The maximum number of poles is directly related both to the fitting accuracy and to the model complexity and therefore to simulation memory and computational time requirements.
            obj.AddToHistory(['.MaximalOrderFitTabulatedCompactModel "', num2str(iValue, '%.15g'), '"']);
            obj.maximalorderfittabulatedcompactmodel = iValue;
        end
        function UseOnlyDataInSimFreqRangeTabulatedCompactModel(obj, boolean)
            % Allow the fit interpolation scheme for the tabulated compact model, to use only the frequency data points that lie within the "frequency range settings" defined by the user. Activating this switch enables an accurate data fitting of the material resonances which occur in the simulation bandwidth of interest using possibly a reduced number of poles and zeroes with respect to the complete data fitting. And this, in turn, translates into benefits for the simulation complexity in terms of memory and computational time.
            obj.AddToHistory(['.UseOnlyDataInSimFreqRangeTabulatedCompactModel "', num2str(boolean, '%.15g'), '"']);
            obj.useonlydatainsimfreqrangetabulatedcompactmodel = boolean;
        end
        function ErrorLimitFitTabulatedCompactModel(obj, limit)
            % Defines the error limit goal (threshold) for the fit interpolation scheme for the tabulated compact model. The maximum number of poles is directly related both to the fitting accuracy and to the model complexity and therefore to simulation memory and computational time requirements.
            obj.AddToHistory(['.ErrorLimitFitTabulatedCompactModel "', num2str(limit, '%.15g'), '"']);
            obj.errorlimitfittabulatedcompactmodel = limit;
        end
        function LossyMetalSIRoughness(obj, roughness)
            % Defines the roughness value for the lossy metal surface impedance model. The surface profile may be assumed as random and the surface heights are modelled according to a normal distribution. The roughness value corresponds to the surface height variance (root mean square Rq - standard DIN EN ISO 4287). The length unit is selected with the method MaterialUnit.
            % The roughness effect is predicted from this only one single parameter using the Gradient Model. According to this physical and Maxwell´s equation based formulation an equivalent frequency dependent impedance is computed accounting for the increased total loss due to surface roughness. See the Gradient Model description in the Material Overview (HF) - Lossy metal section for more information.
            obj.AddToHistory(['.LossyMetalSIRoughness "', num2str(roughness, '%.15g'), '"']);
            obj.lossymetalsiroughness = roughness;
        end
        %% Conductivity
        %% Electric Conductivity
        function Sigma(obj, dValue)
            % Set the electric conductivity. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. Has no effect if TanDGiven is set to True.
            obj.AddToHistory(['.Sigma "', num2str(dValue, '%.15g'), '"']);
            obj.sigma = dValue;
        end
        function SigmaX(obj, dValue)
            % Set the electric conductivity. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. Has no effect if TanDGiven is set to True.
            obj.AddToHistory(['.SigmaX "', num2str(dValue, '%.15g'), '"']);
            obj.sigmax = dValue;
        end
        function SigmaY(obj, dValue)
            % Set the electric conductivity. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. Has no effect if TanDGiven is set to True.
            obj.AddToHistory(['.SigmaY "', num2str(dValue, '%.15g'), '"']);
            obj.sigmay = dValue;
        end
        function SigmaZ(obj, dValue)
            % Set the electric conductivity. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. Has no effect if TanDGiven is set to True.
            obj.AddToHistory(['.SigmaZ "', num2str(dValue, '%.15g'), '"']);
            obj.sigmaz = dValue;
        end
        function SetElParametricConductivity(obj, boolean)
            % Enables or disables the parametric electric conductivity property. This allows to specify special conductivity dependencies on the time as in case of the time dependent conductivity, or on the electric field as in case of the nonlinear J-E curve. To guarantee a consistent material definition the material has to be defined as a conductive one (therefore it has no effect if TanDGiven is set to True) and the conductivity provided with the Sigma command (or SigmaX / SigmaY / SigmaZ in case of anisotropic material) should be greater than zero.
            obj.AddToHistory(['.SetElParametricConductivity "', num2str(boolean, '%.15g'), '"']);
            obj.setelparametricconductivity = boolean;
        end
        function AddJEValue(obj, dJValue, dEValue)
            % This method enables you to define a specific nonlinear J-E curve by adding point by point. Based on this curve, the dependency of electric conductivity on E-field is computed. Has no effect if TanDGiven is set to True. Please note that not all solvers can currently support the nonlinear electric conductivity.
            obj.AddToHistory(['.AddJEValue "', num2str(dJValue, '%.15g'), '", '...
                                          '"', num2str(dEValue, '%.15g'), '"']);
            obj.addjevalue.dJValue = dJValue;
            obj.addjevalue.dEValue = dEValue;
        end
        function ResetJEList(obj)
            % Deletes the nonlinear J-E curve.
            obj.AddToHistory(['.ResetJEList']);
        end
        function ResetElTimeDepCond(obj)
            % Deletes the time dependent conductivity curve.
            obj.AddToHistory(['.ResetElTimeDepCond']);
        end
        function AddElTimeDepCondValue(obj, dTime, dCondValue)
            % This method enables you to define a specific time dependent conductivity curve by adding point by point. This function should be used for normal (isotropic) material.
            % The dCondValue will be identically assigned to the three (x, y, z) components in correspondence of the given dTime value. The dTime unit will be assumed accordingly to the selected time unit (see the MaterialUnit command) whereas the conductivity unit is S/m.
            % Based on this curve the dependency of the electric conductivity on time is computed. Please note that at the moment only the transient solver supports this material property.
            obj.AddToHistory(['.AddElTimeDepCondValue "', num2str(dTime, '%.15g'), '", '...
                                                     '"', num2str(dCondValue, '%.15g'), '"']);
            obj.addeltimedepcondvalue.dTime = dTime;
            obj.addeltimedepcondvalue.dCondValue = dCondValue;
        end
        function AddElTimeDepCondAnisoValue(obj, dTime, dCondValueX, dCondValueY, dCondValueZ)
            % This method is the counterpart of the AddElTimeDepCondValue method for anisotropic material. The dCondValueX, dCondValueY and dCondValueZ will be assigned to the three (x, y, z) components respectively, in correspondence of the given dTime value. The dTime  unit will be assumed accordingly to the selected time unit (see the MaterialUnit command) whereas the conductivity unit is S/m.
            % Based on this curve, the dependency of the electric conductivity on time is computed. Please note that at the moment only the transient solver supports this material property.
            obj.AddToHistory(['.AddElTimeDepCondAnisoValue "', num2str(dTime, '%.15g'), '", '...
                                                          '"', num2str(dCondValueX, '%.15g'), '", '...
                                                          '"', num2str(dCondValueY, '%.15g'), '", '...
                                                          '"', num2str(dCondValueZ, '%.15g'), '"']);
            obj.addeltimedepcondanisovalue.dTime = dTime;
            obj.addeltimedepcondanisovalue.dCondValueX = dCondValueX;
            obj.addeltimedepcondanisovalue.dCondValueY = dCondValueY;
            obj.addeltimedepcondanisovalue.dCondValueZ = dCondValueZ;
        end
        function LoadElTimeDepConductivity(obj, Filename, tUnit)
            % Specifies the file which describes the electric time dependent conductivity. The file name could be provided as absolute path or as a path relative to the project folder and the file must be available at the VBA command execution time.
            % In case of normal material the file name has a two column format, the first one specifying the time and the second one the electrical conductivity.
            % The time unit reading the file is specified by the tUnit parameter, belonging to the set { "fs", "ps", "ns", "us", "ms" or "s" }. The conductivity unit is assumed in any case as S/m.
            % In case of anisotropic material the file has 4 columns, the first one specifying the time and the other three the conductivity for the x, y and z direction.
            % At the moment only the transient solver supports this material property.
            obj.AddToHistory(['.LoadElTimeDepConductivity "', num2str(Filename, '%.15g'), '", '...
                                                         '"', num2str(tUnit, '%.15g'), '"']);
            obj.loadeltimedepconductivity.Filename = Filename;
            obj.loadeltimedepconductivity.tUnit = tUnit;
        end
        function TanD(obj, dValue)
            % Set the electric tangent(delta). Only valid if TanDGiven is set to True. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods.
            obj.AddToHistory(['.TanD "', num2str(dValue, '%.15g'), '"']);
            obj.tand = dValue;
        end
        function TanDX(obj, dValue)
            % Set the electric tangent(delta). Only valid if TanDGiven is set to True. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods.
            obj.AddToHistory(['.TanDX "', num2str(dValue, '%.15g'), '"']);
            obj.tandx = dValue;
        end
        function TanDY(obj, dValue)
            % Set the electric tangent(delta). Only valid if TanDGiven is set to True. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods.
            obj.AddToHistory(['.TanDY "', num2str(dValue, '%.15g'), '"']);
            obj.tandy = dValue;
        end
        function TanDZ(obj, dValue)
            % Set the electric tangent(delta). Only valid if TanDGiven is set to True. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods.
            obj.AddToHistory(['.TanDZ "', num2str(dValue, '%.15g'), '"']);
            obj.tandz = dValue;
        end
        function TanDGiven(obj, boolean)
            % There are two ways to define lossy materials. Either a value for conductivity (s) can be given, or a value for tangent(delta). The two values are correlated by: tan(delta) = s/(e * e0 * 2 * p * f). If switch is True and though tan(delta) is used to define losses,  the frequency for which tan(delta) has been determined must been given by the TanDFreq method.
            obj.AddToHistory(['.TanDGiven "', num2str(boolean, '%.15g'), '"']);
            obj.tandgiven = boolean;
        end
        function TanDFreq(obj, dValue)
            % If TanDGiven is set to True, specify the frequency at which tan(delta) has been determined.
            obj.AddToHistory(['.TanDFreq "', num2str(dValue, '%.15g'), '"']);
            obj.tandfreq = dValue;
        end
        function TanDModel(obj, key)
            % Sets the model type for tan(delta) of a material.
            % key: 'ConstSigma'
            %      'ConstTanD'
            obj.AddToHistory(['.TanDModel "', num2str(key, '%.15g'), '"']);
            obj.tandmodel = key;
        end
        function EnableUserConstTanDModelOrderEps(obj, boolean)
            % If set to "True" the model order for the ConstTanD model will be selected according to the ConstTanDModelOrderEps method. If set to "False" the model order will be automatically determined by the fitting algorithm, selecting the best choice between optimal approximation and smallest possible number of poles.
            obj.AddToHistory(['.EnableUserConstTanDModelOrderEps "', num2str(boolean, '%.15g'), '"']);
            obj.enableuserconsttandmodelordereps = boolean;
        end
        function ConstTanDModelOrderEps(obj, iValue)
            % Sets the order for the ConstTanD model which corresponds to the number of poles used in the internal material representation. An order=1 corresponds to a Debye model. The command will be ignored if EnableUserConstTanDModelOrderEps is set to "False", in which case the model order will be automatically determined by the fitting algorithm.
            obj.AddToHistory(['.ConstTanDModelOrderEps "', num2str(iValue, '%.15g'), '"']);
            obj.consttandmodelordereps = iValue;
        end
        %% Magnetic Conductivity
        function SigmaM(obj, dValue)
            % Set the magnetic conductivity. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. Has no effect if TanDMGiven is set to True.
            obj.AddToHistory(['.SigmaM "', num2str(dValue, '%.15g'), '"']);
            obj.sigmam = dValue;
        end
        function SigmaMX(obj, dValue)
            % Set the magnetic conductivity. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. Has no effect if TanDMGiven is set to True.
            obj.AddToHistory(['.SigmaMX "', num2str(dValue, '%.15g'), '"']);
            obj.sigmamx = dValue;
        end
        function SigmaMY(obj, dValue)
            % Set the magnetic conductivity. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. Has no effect if TanDMGiven is set to True.
            obj.AddToHistory(['.SigmaMY "', num2str(dValue, '%.15g'), '"']);
            obj.sigmamy = dValue;
        end
        function SigmaMZ(obj, dValue)
            % Set the magnetic conductivity. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. Has no effect if TanDMGiven is set to True.
            obj.AddToHistory(['.SigmaMZ "', num2str(dValue, '%.15g'), '"']);
            obj.sigmamz = dValue;
        end
        function SetMagParametricConductivity(obj, boolean)
            % Enables or disables the parametric magnetic conductivity property. This allows to specify special conductivity dependencies on the time as in case of the time dependent conductivity. To guarantee a consistent material definition the material has to be defined as a conductive one (therefore it has no effect if TanDMGiven is set to True) and the conductivity provided with the SigmaM command (or SigmaMX / SigmaMY / SigmaMZ in case of anisotropic material) should be greater than zero.
            obj.AddToHistory(['.SetMagParametricConductivity "', num2str(boolean, '%.15g'), '"']);
            obj.setmagparametricconductivity = boolean;
        end
        function ResetMagTimeDepCond(obj)
            % Deletes the time dependent conductivity curve.
            obj.AddToHistory(['.ResetMagTimeDepCond']);
        end
        function AddMagTimeDepCondValue(obj, dTime, dCondValue)
            % This method enables you to define a specific time dependent conductivity curve by adding point by point. This function should be used for normal (isotropic) material.
            % The dCondValue will be identically assigned to the three (x, y, z) components in correspondence of the given dTime value. The dTime unit will be assumed accordingly to the selected time unit (see the MaterialUnit command) whereas the conductivity unit is 1/Sm.
            % Based on this curve the dependency of the magnetic conductivity on time is computed. Please note that at the moment only the transient solver supports this material property.
            obj.AddToHistory(['.AddMagTimeDepCondValue "', num2str(dTime, '%.15g'), '", '...
                                                      '"', num2str(dCondValue, '%.15g'), '"']);
            obj.addmagtimedepcondvalue.dTime = dTime;
            obj.addmagtimedepcondvalue.dCondValue = dCondValue;
        end
        function AddMagTimeDepCondAnisoValue(obj, dTime, dCondValueX, dCondValueY, dCondValueZ)
            % This method is the counterpart of the AddMagTimeDepCondValue method for anisotropic material. The dCondValueX, dCondValueY and dCondValueZ will be assigned to the three (x, y, z) components respectively, in correspondence of the given dTime value. The dTime  unit will be assumed accordingly to the selected time unit (see the MaterialUnit command) whereas the conductivity unit is 1/Sm.
            % Based on this curve, the dependency of the magnetic conductivity on time is computed. Please note that at the moment only the transient solver supports this material property.
            obj.AddToHistory(['.AddMagTimeDepCondAnisoValue "', num2str(dTime, '%.15g'), '", '...
                                                           '"', num2str(dCondValueX, '%.15g'), '", '...
                                                           '"', num2str(dCondValueY, '%.15g'), '", '...
                                                           '"', num2str(dCondValueZ, '%.15g'), '"']);
            obj.addmagtimedepcondanisovalue.dTime = dTime;
            obj.addmagtimedepcondanisovalue.dCondValueX = dCondValueX;
            obj.addmagtimedepcondanisovalue.dCondValueY = dCondValueY;
            obj.addmagtimedepcondanisovalue.dCondValueZ = dCondValueZ;
        end
        function LoadMagTimeDepConductivity(obj, Filename, tUnit)
            % Specifies the file which describes the magnetic time dependent conductivity. The file name could be provided as absolute path or as a path relative to the project folder and the file must be available at the VBA command execution time.
            % In case of normal material the file name has a two column format, the first one specifying the time and the second one the magnetic conductivity.
            % The time unit reading the file is specified by the tUnit parameter, belonging to the set { "fs", "ps", "ns", "us", "ms" or "s" }. The conductivity unit is assumed in any case as 1/Sm.
            % In case of anisotropic material the file has 4 columns, the first one specifying the time and the other three the conductivity for the x, y and z direction.
            % At the moment only the transient solver supports this material property.
            obj.AddToHistory(['.LoadMagTimeDepConductivity "', num2str(Filename, '%.15g'), '", '...
                                                          '"', num2str(tUnit, '%.15g'), '"']);
            obj.loadmagtimedepconductivity.Filename = Filename;
            obj.loadmagtimedepconductivity.tUnit = tUnit;
        end
        function TanDM(obj, dValue)
            % Set the magnetic tan(delta). Only valid if TanDMGiven is set to True. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods.
            obj.AddToHistory(['.TanDM "', num2str(dValue, '%.15g'), '"']);
            obj.tandm = dValue;
        end
        function TanDMX(obj, dValue)
            % Set the magnetic tan(delta). Only valid if TanDMGiven is set to True. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods.
            obj.AddToHistory(['.TanDMX "', num2str(dValue, '%.15g'), '"']);
            obj.tandmx = dValue;
        end
        function TanDMY(obj, dValue)
            % Set the magnetic tan(delta). Only valid if TanDMGiven is set to True. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods.
            obj.AddToHistory(['.TanDMY "', num2str(dValue, '%.15g'), '"']);
            obj.tandmy = dValue;
        end
        function TanDMZ(obj, dValue)
            % Set the magnetic tan(delta). Only valid if TanDMGiven is set to True. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods.
            obj.AddToHistory(['.TanDMZ "', num2str(dValue, '%.15g'), '"']);
            obj.tandmz = dValue;
        end
        function TanDMGiven(obj, boolean)
            % As for electric conductivity, there are two ways to define magnetic lossy materials. If switch is True, tan(delta) is used to define losses. Usage of the TanDMFreq method is mandatory in this case.
            obj.AddToHistory(['.TanDMGiven "', num2str(boolean, '%.15g'), '"']);
            obj.tandmgiven = boolean;
        end
        function TanDMFreq(obj, dValue)
            % If TanDMGiven is set to True, specify the frequency at which tan(delta) has been determined.
            obj.AddToHistory(['.TanDMFreq "', num2str(dValue, '%.15g'), '"']);
            obj.tandmfreq = dValue;
        end
        function TanDMModel(obj, key)
            % Sets the model type for tan(delta) of a material.
            % key: 'ConstSigma'
            %      'ConstTanD'
            obj.AddToHistory(['.TanDMModel "', num2str(key, '%.15g'), '"']);
            obj.tandmmodel = key;
        end
        function EnableUserConstTanDModelOrderMu(obj, boolean)
            % If set to "True" the model order for the ConstTanD model will be selected according to the ConstTanDModelOrderMu method. If set to "False" the model order will be automatically determined by the fitting algorithm, selecting the best choice between optimal approximation and smallest possible number of poles.
            obj.AddToHistory(['.EnableUserConstTanDModelOrderMu "', num2str(boolean, '%.15g'), '"']);
            obj.enableuserconsttandmodelordermu = boolean;
        end
        function ConstTanDModelOrderMu(obj, iValue)
            % Sets the order for the ConstTanD model which corresponds to the number of poles used in the internal material representation. An order=1 corresponds to a Debye model. The command will be ignored if EnableUserConstTanDModelOrderMu is set to "False", in which case the model order will be automatically determined by the fitting algorithm.
            obj.AddToHistory(['.ConstTanDModelOrderMu "', num2str(iValue, '%.15g'), '"']);
            obj.consttandmodelordermu = iValue;
        end
        %% Dispersion
        function DispModelEps(obj, key)
            % Sets the dispersion model for dielectric / magnetic dispersion.
            % These material dispersions are specified by several coefficients, describing the corresponding dispersive behavior. Please find the meaning of the coefficients in the following list, for epsilon and mu respectively. Note, that in case of general 1st or 2nd order models the parameters have no special physical meaning, but represent mathematical coefficients of general polynomials.
            % The following table describes the coefficient for the linear dispersive materials.
            %                         Coeff1              Coeff2              Coeff3                  Coeff4
            % Debye 1st order         Static value        Relaxation time     -                       -
            % Debye 2nd order         Static value 1      Static value  2     Relaxation time 1       Relaxation time 2
            % Drude                   Plasma freq.        Collision freq.     -                       -
            % Lorentz                 Static epsilon      Resonance freq.     Damping freq.           -
            % Gyrotropic Gauss        Landé factor        Sat. magnetization  Resonance line width    Magnetic field vector
            % Gyrotropic SI           Larmor freq.        Gyrotropic freq.    Damping factor          Biasing direction
            % General 1st order       Alpha0              Beta0               -                       -
            % General 2nd order       Alpha0              Alpha1              Beta0                   Beta1
            % General                 Higher order dispersion model is specified with a summation of first and second order poles using the AddDispEpsPole1stOrder or AddDispEpsPole2ndOrder methods for the dielectric dispersion or AddDispMuPole1stOrder or AddDispMuPole2ndOrder methods for the magnetic dispersion, respectively.
            % In case of the nonlinear dispersive material the parameter correspondence is described by the following table.
            %                         Coeff0              Coeff1              Coeff2                  Coeff3      Coeff4
            % Nonlinear 2nd order     Chi2 value          -                   -                       -           -
            % Nonlinear 3rd order     Chi3 value          -                   -                       -           -
            % Nonlinear Kerr          Chi3 infinity value Chi3 static value   Relaxation time         -           -
            % Nonlinear Raman         Chi3 infinity value Chi3 static value   Plasma freq.        Collision freq. -
            % key: 'None'
            %      'Debye1st'
            %      'Debye2nd'
            %      'Drude'
            %      'Lorentz'
            %      'General1st'
            %      'General2nd
            %      General'
            %      'NonLinear2nd'
            %      'NonLinear3rd'
            %      'NonLinearKerr'
            %      'NonLinearRaman'
            obj.AddToHistory(['.DispModelEps "', num2str(key, '%.15g'), '"']);
            obj.dispmodeleps = key;
        end
        function DispModelMu(obj, key)
            % See DispModelEps for details.
            % key: 'None'
            %      'Debye1st'
            %      'Debye2nd'
            %      'Drude'
            %      'Lorentz'
            %      'Gyrotropic'
            %      'General1st'
            %      'General2nd'
            %      'NonLinear2nd'
            %      'NonLinear3rd'
            %      'NonLinearKerr'
            %      'NonLinearRaman'
            obj.AddToHistory(['.DispModelMu "', num2str(key, '%.15g'), '"']);
            obj.dispmodelmu = key;
        end
        function EpsInfinity(obj, dValue)
            % Define the permittivity high frequency limit for one of the dispersion models specified with the DispModelEps method.
            obj.AddToHistory(['.EpsInfinity "', num2str(dValue, '%.15g'), '"']);
            obj.epsinfinity = dValue;
        end
        function EpsInfinityX(obj, dValue)
            % Define the permittivity high frequency limit for one of the dispersion models specified with the DispModelEps method.
            obj.AddToHistory(['.EpsInfinityX "', num2str(dValue, '%.15g'), '"']);
            obj.epsinfinityx = dValue;
        end
        function EpsInfinityY(obj, dValue)
            % Define the permittivity high frequency limit for one of the dispersion models specified with the DispModelEps method.
            obj.AddToHistory(['.EpsInfinityY "', num2str(dValue, '%.15g'), '"']);
            obj.epsinfinityy = dValue;
        end
        function EpsInfinityZ(obj, dValue)
            % Define the permittivity high frequency limit for one of the dispersion models specified with the DispModelEps method.
            obj.AddToHistory(['.EpsInfinityZ "', num2str(dValue, '%.15g'), '"']);
            obj.epsinfinityz = dValue;
        end
        function DispCoeff0Eps(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff0Eps "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff0eps = dValue;
        end
        function DispCoeff0EpsX(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff0EpsX "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff0epsx = dValue;
        end
        function DispCoeff0EpsY(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff0EpsY "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff0epsy = dValue;
        end
        function DispCoeff0EpsZ(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff0EpsZ "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff0epsz = dValue;
        end
        function DispCoeff1Eps(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff1Eps "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff1eps = dValue;
        end
        function DispCoeff1EpsX(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff1EpsX "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff1epsx = dValue;
        end
        function DispCoeff1EpsY(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff1EpsY "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff1epsy = dValue;
        end
        function DispCoeff1EpsZ(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff1EpsZ "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff1epsz = dValue;
        end
        function DispCoeff2Eps(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff2Eps "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff2eps = dValue;
        end
        function DispCoeff2EpsX(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff2EpsX "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff2epsx = dValue;
        end
        function DispCoeff2EpsY(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff2EpsY "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff2epsy = dValue;
        end
        function DispCoeff2EpsZ(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff2EpsZ "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff2epsz = dValue;
        end
        function DispCoeff3Eps(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff3Eps "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff3eps = dValue;
        end
        function DispCoeff3EpsX(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff3EpsX "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff3epsx = dValue;
        end
        function DispCoeff3EpsY(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff3EpsY "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff3epsy = dValue;
        end
        function DispCoeff3EpsZ(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff3EpsZ "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff3epsz = dValue;
        end
        function DispCoeff4Eps(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff4Eps "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff4eps = dValue;
        end
        function DispCoeff4EpsX(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff4EpsX "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff4epsx = dValue;
        end
        function DispCoeff4EpsY(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff4EpsY "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff4epsy = dValue;
        end
        function DispCoeff4EpsZ(obj, dValue)
            % Define specific dielectric dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelEps method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the EpsInfinity method whereas the DispCoeff0Eps method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff4EpsZ "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff4epsz = dValue;
        end
        function AddDispEpsPole1stOrder(obj, alpha0, beta0)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the dielectric dispersion and only work together with the "General" model defined with the DispModelEps method. The corresponding infinity value has to be defined with the EpsInfinity method.
            obj.AddToHistory(['.AddDispEpsPole1stOrder "', num2str(alpha0, '%.15g'), '", '...
                                                      '"', num2str(beta0, '%.15g'), '"']);
            obj.adddispepspole1storder.alpha0 = alpha0;
            obj.adddispepspole1storder.beta0 = beta0;
        end
        function AddDispEpsPole1stOrderX(obj, alpha0, beta0)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the dielectric dispersion and only work together with the "General" model defined with the DispModelEps method. The corresponding infinity value has to be defined with the EpsInfinity method.
            obj.AddToHistory(['.AddDispEpsPole1stOrderX "', num2str(alpha0, '%.15g'), '", '...
                                                       '"', num2str(beta0, '%.15g'), '"']);
            obj.adddispepspole1storderx.alpha0 = alpha0;
            obj.adddispepspole1storderx.beta0 = beta0;
        end
        function AddDispEpsPole1stOrderY(obj, alpha0, beta0)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the dielectric dispersion and only work together with the "General" model defined with the DispModelEps method. The corresponding infinity value has to be defined with the EpsInfinity method.
            obj.AddToHistory(['.AddDispEpsPole1stOrderY "', num2str(alpha0, '%.15g'), '", '...
                                                       '"', num2str(beta0, '%.15g'), '"']);
            obj.adddispepspole1stordery.alpha0 = alpha0;
            obj.adddispepspole1stordery.beta0 = beta0;
        end
        function AddDispEpsPole1stOrderZ(obj, alpha0, beta0)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the dielectric dispersion and only work together with the "General" model defined with the DispModelEps method. The corresponding infinity value has to be defined with the EpsInfinity method.
            obj.AddToHistory(['.AddDispEpsPole1stOrderZ "', num2str(alpha0, '%.15g'), '", '...
                                                       '"', num2str(beta0, '%.15g'), '"']);
            obj.adddispepspole1storderz.alpha0 = alpha0;
            obj.adddispepspole1storderz.beta0 = beta0;
        end
        function AddDispEpsPole2ndOrder(obj, alpha0, alpha1, beta0, beta1)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the dielectric dispersion and only work together with the "General" model defined with the DispModelEps method. The corresponding infinity value has to be defined with the EpsInfinity method.
            obj.AddToHistory(['.AddDispEpsPole2ndOrder "', num2str(alpha0, '%.15g'), '", '...
                                                      '"', num2str(alpha1, '%.15g'), '", '...
                                                      '"', num2str(beta0, '%.15g'), '", '...
                                                      '"', num2str(beta1, '%.15g'), '"']);
            obj.adddispepspole2ndorder.alpha0 = alpha0;
            obj.adddispepspole2ndorder.alpha1 = alpha1;
            obj.adddispepspole2ndorder.beta0 = beta0;
            obj.adddispepspole2ndorder.beta1 = beta1;
        end
        function AddDispEpsPole2ndOrderX(obj, alpha0, alpha1, beta0, beta1)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the dielectric dispersion and only work together with the "General" model defined with the DispModelEps method. The corresponding infinity value has to be defined with the EpsInfinity method.
            obj.AddToHistory(['.AddDispEpsPole2ndOrderX "', num2str(alpha0, '%.15g'), '", '...
                                                       '"', num2str(alpha1, '%.15g'), '", '...
                                                       '"', num2str(beta0, '%.15g'), '", '...
                                                       '"', num2str(beta1, '%.15g'), '"']);
            obj.adddispepspole2ndorderx.alpha0 = alpha0;
            obj.adddispepspole2ndorderx.alpha1 = alpha1;
            obj.adddispepspole2ndorderx.beta0 = beta0;
            obj.adddispepspole2ndorderx.beta1 = beta1;
        end
        function AddDispEpsPole2ndOrderY(obj, alpha0, alpha1, beta0, beta1)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the dielectric dispersion and only work together with the "General" model defined with the DispModelEps method. The corresponding infinity value has to be defined with the EpsInfinity method.
            obj.AddToHistory(['.AddDispEpsPole2ndOrderY "', num2str(alpha0, '%.15g'), '", '...
                                                       '"', num2str(alpha1, '%.15g'), '", '...
                                                       '"', num2str(beta0, '%.15g'), '", '...
                                                       '"', num2str(beta1, '%.15g'), '"']);
            obj.adddispepspole2ndordery.alpha0 = alpha0;
            obj.adddispepspole2ndordery.alpha1 = alpha1;
            obj.adddispepspole2ndordery.beta0 = beta0;
            obj.adddispepspole2ndordery.beta1 = beta1;
        end
        function AddDispEpsPole2ndOrderZ(obj, alpha0, alpha1, beta0, beta1)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the dielectric dispersion and only work together with the "General" model defined with the DispModelEps method. The corresponding infinity value has to be defined with the EpsInfinity method.
            obj.AddToHistory(['.AddDispEpsPole2ndOrderZ "', num2str(alpha0, '%.15g'), '", '...
                                                       '"', num2str(alpha1, '%.15g'), '", '...
                                                       '"', num2str(beta0, '%.15g'), '", '...
                                                       '"', num2str(beta1, '%.15g'), '"']);
            obj.adddispepspole2ndorderz.alpha0 = alpha0;
            obj.adddispepspole2ndorderz.alpha1 = alpha1;
            obj.adddispepspole2ndorderz.beta0 = beta0;
            obj.adddispepspole2ndorderz.beta1 = beta1;
        end
        function AddDispMuPole1stOrder(obj, alpha0, beta0)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the magnetic dispersion and only work together with the "General" model defined with the DispModelMu method. The corresponding infinity value has to be defined with the MuInfinity method.
            obj.AddToHistory(['.AddDispMuPole1stOrder "', num2str(alpha0, '%.15g'), '", '...
                                                     '"', num2str(beta0, '%.15g'), '"']);
            obj.adddispmupole1storder.alpha0 = alpha0;
            obj.adddispmupole1storder.beta0 = beta0;
        end
        function AddDispMuPole1stOrderX(obj, alpha0, beta0)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the magnetic dispersion and only work together with the "General" model defined with the DispModelMu method. The corresponding infinity value has to be defined with the MuInfinity method.
            obj.AddToHistory(['.AddDispMuPole1stOrderX "', num2str(alpha0, '%.15g'), '", '...
                                                      '"', num2str(beta0, '%.15g'), '"']);
            obj.adddispmupole1storderx.alpha0 = alpha0;
            obj.adddispmupole1storderx.beta0 = beta0;
        end
        function AddDispMuPole1stOrderY(obj, alpha0, beta0)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the magnetic dispersion and only work together with the "General" model defined with the DispModelMu method. The corresponding infinity value has to be defined with the MuInfinity method.
            obj.AddToHistory(['.AddDispMuPole1stOrderY "', num2str(alpha0, '%.15g'), '", '...
                                                      '"', num2str(beta0, '%.15g'), '"']);
            obj.adddispmupole1stordery.alpha0 = alpha0;
            obj.adddispmupole1stordery.beta0 = beta0;
        end
        function AddDispMuPole1stOrderZ(obj, alpha0, beta0)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the magnetic dispersion and only work together with the "General" model defined with the DispModelMu method. The corresponding infinity value has to be defined with the MuInfinity method.
            obj.AddToHistory(['.AddDispMuPole1stOrderZ "', num2str(alpha0, '%.15g'), '", '...
                                                      '"', num2str(beta0, '%.15g'), '"']);
            obj.adddispmupole1storderz.alpha0 = alpha0;
            obj.adddispmupole1storderz.beta0 = beta0;
        end
        function AddDispMuPole2ndOrder(obj, alpha0, alpha1, beta0, beta1)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the magnetic dispersion and only work together with the "General" model defined with the DispModelMu method. The corresponding infinity value has to be defined with the MuInfinity method.
            obj.AddToHistory(['.AddDispMuPole2ndOrder "', num2str(alpha0, '%.15g'), '", '...
                                                     '"', num2str(alpha1, '%.15g'), '", '...
                                                     '"', num2str(beta0, '%.15g'), '", '...
                                                     '"', num2str(beta1, '%.15g'), '"']);
            obj.adddispmupole2ndorder.alpha0 = alpha0;
            obj.adddispmupole2ndorder.alpha1 = alpha1;
            obj.adddispmupole2ndorder.beta0 = beta0;
            obj.adddispmupole2ndorder.beta1 = beta1;
        end
        function AddDispMuPole2ndOrderX(obj, alpha0, alpha1, beta0, beta1)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the magnetic dispersion and only work together with the "General" model defined with the DispModelMu method. The corresponding infinity value has to be defined with the MuInfinity method.
            obj.AddToHistory(['.AddDispMuPole2ndOrderX "', num2str(alpha0, '%.15g'), '", '...
                                                      '"', num2str(alpha1, '%.15g'), '", '...
                                                      '"', num2str(beta0, '%.15g'), '", '...
                                                      '"', num2str(beta1, '%.15g'), '"']);
            obj.adddispmupole2ndorderx.alpha0 = alpha0;
            obj.adddispmupole2ndorderx.alpha1 = alpha1;
            obj.adddispmupole2ndorderx.beta0 = beta0;
            obj.adddispmupole2ndorderx.beta1 = beta1;
        end
        function AddDispMuPole2ndOrderY(obj, alpha0, alpha1, beta0, beta1)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the magnetic dispersion and only work together with the "General" model defined with the DispModelMu method. The corresponding infinity value has to be defined with the MuInfinity method.
            obj.AddToHistory(['.AddDispMuPole2ndOrderY "', num2str(alpha0, '%.15g'), '", '...
                                                      '"', num2str(alpha1, '%.15g'), '", '...
                                                      '"', num2str(beta0, '%.15g'), '", '...
                                                      '"', num2str(beta1, '%.15g'), '"']);
            obj.adddispmupole2ndordery.alpha0 = alpha0;
            obj.adddispmupole2ndordery.alpha1 = alpha1;
            obj.adddispmupole2ndordery.beta0 = beta0;
            obj.adddispmupole2ndordery.beta1 = beta1;
        end
        function AddDispMuPole2ndOrderZ(obj, alpha0, alpha1, beta0, beta1)
            % These commands allow the specification of a higher order dispersion model in form of an arbitrary summation of first or second order pole descriptions. These commands apply to the magnetic dispersion and only work together with the "General" model defined with the DispModelMu method. The corresponding infinity value has to be defined with the MuInfinity method.
            obj.AddToHistory(['.AddDispMuPole2ndOrderZ "', num2str(alpha0, '%.15g'), '", '...
                                                      '"', num2str(alpha1, '%.15g'), '", '...
                                                      '"', num2str(beta0, '%.15g'), '", '...
                                                      '"', num2str(beta1, '%.15g'), '"']);
            obj.adddispmupole2ndorderz.alpha0 = alpha0;
            obj.adddispmupole2ndorderz.alpha1 = alpha1;
            obj.adddispmupole2ndorderz.beta0 = beta0;
            obj.adddispmupole2ndorderz.beta1 = beta1;
        end
        function MuInfinity(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.MuInfinity "', num2str(dValue, '%.15g'), '"']);
            obj.muinfinity = dValue;
        end
        function MuInfinityX(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.MuInfinityX "', num2str(dValue, '%.15g'), '"']);
            obj.muinfinityx = dValue;
        end
        function MuInfinityY(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.MuInfinityY "', num2str(dValue, '%.15g'), '"']);
            obj.muinfinityy = dValue;
        end
        function MuInfinityZ(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.MuInfinityZ "', num2str(dValue, '%.15g'), '"']);
            obj.muinfinityz = dValue;
        end
        function DispCoeff0Mu(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff0Mu "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff0mu = dValue;
        end
        function DispCoeff0MuX(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff0MuX "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff0mux = dValue;
        end
        function DispCoeff0MuY(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff0MuY "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff0muy = dValue;
        end
        function DispCoeff0MuZ(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff0MuZ "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff0muz = dValue;
        end
        function DispCoeff1Mu(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff1Mu "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff1mu = dValue;
        end
        function DispCoeff1MuX(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff1MuX "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff1mux = dValue;
        end
        function DispCoeff1MuY(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff1MuY "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff1muy = dValue;
        end
        function DispCoeff1MuZ(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff1MuZ "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff1muz = dValue;
        end
        function DispCoeff2Mu(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff2Mu "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff2mu = dValue;
        end
        function DispCoeff2MuX(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff2MuX "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff2mux = dValue;
        end
        function DispCoeff2MuY(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff2MuY "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff2muy = dValue;
        end
        function DispCoeff2MuZ(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff2MuZ "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff2muz = dValue;
        end
        function DispCoeff3Mu(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff3Mu "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff3mu = dValue;
        end
        function DispCoeff3MuX(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff3MuX "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff3mux = dValue;
        end
        function DispCoeff3MuY(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff3MuY "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff3muy = dValue;
        end
        function DispCoeff3MuZ(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff3MuZ "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff3muz = dValue;
        end
        function DispCoeff4Mu(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff4Mu "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff4mu = dValue;
        end
        function DispCoeff4MuX(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff4MuX "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff4mux = dValue;
        end
        function DispCoeff4MuY(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff4MuY "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff4muy = dValue;
        end
        function DispCoeff4MuZ(obj, dValue)
            % Define specific magnetic dispersion model parameters of dispersions model for the linear and nonlinear material. The settings depend on the dispersion model selected by the DispModelMu method. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal tensor can be set with the respective methods. The infinity value for the linear dispersive model has to be defined with the MuInfinity method whereas the DispCoeff0Mu method is used in correspondence of the nonlinear material.
            obj.AddToHistory(['.DispCoeff4MuZ "', num2str(dValue, '%.15g'), '"']);
            obj.dispcoeff4muz = dValue;
        end
        function UseSISystem(obj, boolean)
            % The Gauss or SI unit system can be selected for different input parameters of the gyrotropic material.
            obj.AddToHistory(['.UseSISystem "', num2str(boolean, '%.15g'), '"']);
            obj.usesisystem = boolean;
        end
        function GyroMuFreq(obj, dValue)
            % Reference frequency for the conversion of gyrotropic material parameters given in Gauss units into the SI system.
            obj.AddToHistory(['.GyroMuFreq "', num2str(dValue, '%.15g'), '"']);
            obj.gyromufreq = dValue;
        end
        function DispersiveFittingFormatEps(obj, Format)
            % Use this method to specify the data representation of the complex material value eps/mu set with the method AddGeneralDispersionValueEps/AddGeneralDispersionValueMu for the anisotropic material or with the method AddGeneralDispersionValueXYZEps/AddGeneralDispersionValueXYZMu for the diagonal anisotropic case.
            % The available enum values for the Format  field are { "Real_Imag", "Real_Tand" } which enable the complex data to be represented as a (Real, Imaginary) pair or as (Real, Tangent delta) pair respectively
            obj.AddToHistory(['.DispersiveFittingFormatEps "', num2str(Format, '%.15g'), '"']);
            obj.dispersivefittingformateps = Format;
        end
        function DispersiveFittingFormatMu(obj, Format)
            % Use this method to specify the data representation of the complex material value eps/mu set with the method AddGeneralDispersionValueEps/AddGeneralDispersionValueMu for the anisotropic material or with the method AddGeneralDispersionValueXYZEps/AddGeneralDispersionValueXYZMu for the diagonal anisotropic case.
            % The available enum values for the Format  field are { "Real_Imag", "Real_Tand" } which enable the complex data to be represented as a (Real, Imaginary) pair or as (Real, Tangent delta) pair respectively
            obj.AddToHistory(['.DispersiveFittingFormatMu "', num2str(Format, '%.15g'), '"']);
            obj.dispersivefittingformatmu = Format;
        end
        function AddDispersionFittingValueEps(obj, dFrequency, dRe, dImordTand, dWeight)
            % Use this method to add a complex material value eps/mu with the corresponding frequency to the dispersion curve represented by a list. The weight specifies with which priority the values are considered. In case of diagonal anisotropic material, use the AddGeneralDispersionValueXYZEps/AddGeneralDispersionValueXYZMu method to define the components of the diagonal tensor.
            % This method offers the possibility to define a specific electric/magnetic material dispersion curve, which is then fitted to the model defined by function DispersiveFittingSchemeEps/DispersiveFittingSchemeMu. The user defined dispersion fit is activated by the function UseGeneralDispersionEps/UseGeneralDispersionMu.
            % The provided values are interpreted according to the method DispersiveFittingFormatEps / DispersiveFittingFormatMu. If the "Real_Imag" representation is selected then the complex data are read as (Real, Imag) pair. If instead the "Real_Tand" format is selected the data are read as (Real, Tangent delta) pair and the imaginary part will be automatically computed as Imag = Real * Tangent delta.
            obj.AddToHistory(['.AddDispersionFittingValueEps "', num2str(dFrequency, '%.15g'), '", '...
                                                            '"', num2str(dRe, '%.15g'), '", '...
                                                            '"', num2str(dImordTand, '%.15g'), '", '...
                                                            '"', num2str(dWeight, '%.15g'), '"']);
            obj.adddispersionfittingvalueeps.dFrequency = dFrequency;
            obj.adddispersionfittingvalueeps.dRe = dRe;
            obj.adddispersionfittingvalueeps.dImordTand = dImordTand;
            obj.adddispersionfittingvalueeps.dWeight = dWeight;
        end
        function AddDispersionFittingValueMu(obj, dFrequency, dRe, dImordTand, dWeight)
            % Use this method to add a complex material value eps/mu with the corresponding frequency to the dispersion curve represented by a list. The weight specifies with which priority the values are considered. In case of diagonal anisotropic material, use the AddGeneralDispersionValueXYZEps/AddGeneralDispersionValueXYZMu method to define the components of the diagonal tensor.
            % This method offers the possibility to define a specific electric/magnetic material dispersion curve, which is then fitted to the model defined by function DispersiveFittingSchemeEps/DispersiveFittingSchemeMu. The user defined dispersion fit is activated by the function UseGeneralDispersionEps/UseGeneralDispersionMu.
            % The provided values are interpreted according to the method DispersiveFittingFormatEps / DispersiveFittingFormatMu. If the "Real_Imag" representation is selected then the complex data are read as (Real, Imag) pair. If instead the "Real_Tand" format is selected the data are read as (Real, Tangent delta) pair and the imaginary part will be automatically computed as Imag = Real * Tangent delta.
            obj.AddToHistory(['.AddDispersionFittingValueMu "', num2str(dFrequency, '%.15g'), '", '...
                                                           '"', num2str(dRe, '%.15g'), '", '...
                                                           '"', num2str(dImordTand, '%.15g'), '", '...
                                                           '"', num2str(dWeight, '%.15g'), '"']);
            obj.adddispersionfittingvaluemu.dFrequency = dFrequency;
            obj.adddispersionfittingvaluemu.dRe = dRe;
            obj.adddispersionfittingvaluemu.dImordTand = dImordTand;
            obj.adddispersionfittingvaluemu.dWeight = dWeight;
        end
        function AddDispersionFittingValueXYZEps(obj, dFrequency, dReX, dImXordTandX, dReY, dImYordTandY, dReZ, dImZordTandZ, dWeight)
            % Use this method to add a complex material value eps/mu with the corresponding frequency to the dispersion curve represented by a list. The weight specifies with which priority the values are considered. In case of diagonal anisotropic material, use the AddGeneralDispersionValueXYZEps/AddGeneralDispersionValueXYZMu method to define the components of the diagonal tensor.
            % This method offers the possibility to define a specific electric/magnetic material dispersion curve, which is then fitted to the model defined by function DispersiveFittingSchemeEps/DispersiveFittingSchemeMu. The user defined dispersion fit is activated by the function UseGeneralDispersionEps/UseGeneralDispersionMu.
            % The provided values are interpreted according to the method DispersiveFittingFormatEps / DispersiveFittingFormatMu. If the "Real_Imag" representation is selected then the complex data are read as (Real, Imag) pair. If instead the "Real_Tand" format is selected the data are read as (Real, Tangent delta) pair and the imaginary part will be automatically computed as Imag = Real * Tangent delta.
            obj.AddToHistory(['.AddDispersionFittingValueXYZEps "', num2str(dFrequency, '%.15g'), '", '...
                                                               '"', num2str(dReX, '%.15g'), '", '...
                                                               '"', num2str(dImXordTandX, '%.15g'), '", '...
                                                               '"', num2str(dReY, '%.15g'), '", '...
                                                               '"', num2str(dImYordTandY, '%.15g'), '", '...
                                                               '"', num2str(dReZ, '%.15g'), '", '...
                                                               '"', num2str(dImZordTandZ, '%.15g'), '", '...
                                                               '"', num2str(dWeight, '%.15g'), '"']);
            obj.adddispersionfittingvaluexyzeps.dFrequency = dFrequency;
            obj.adddispersionfittingvaluexyzeps.dReX = dReX;
            obj.adddispersionfittingvaluexyzeps.dImXordTandX = dImXordTandX;
            obj.adddispersionfittingvaluexyzeps.dReY = dReY;
            obj.adddispersionfittingvaluexyzeps.dImYordTandY = dImYordTandY;
            obj.adddispersionfittingvaluexyzeps.dReZ = dReZ;
            obj.adddispersionfittingvaluexyzeps.dImZordTandZ = dImZordTandZ;
            obj.adddispersionfittingvaluexyzeps.dWeight = dWeight;
        end
        function AddDispersionFittingValueXYZMu(obj, dFrequency, dReX, dImXordTandX, dReY, dImYordTandY, dReZ, dImZordTandZ, dWeight)
            % Use this method to add a complex material value eps/mu with the corresponding frequency to the dispersion curve represented by a list. The weight specifies with which priority the values are considered. In case of diagonal anisotropic material, use the AddGeneralDispersionValueXYZEps/AddGeneralDispersionValueXYZMu method to define the components of the diagonal tensor.
            % This method offers the possibility to define a specific electric/magnetic material dispersion curve, which is then fitted to the model defined by function DispersiveFittingSchemeEps/DispersiveFittingSchemeMu. The user defined dispersion fit is activated by the function UseGeneralDispersionEps/UseGeneralDispersionMu.
            % The provided values are interpreted according to the method DispersiveFittingFormatEps / DispersiveFittingFormatMu. If the "Real_Imag" representation is selected then the complex data are read as (Real, Imag) pair. If instead the "Real_Tand" format is selected the data are read as (Real, Tangent delta) pair and the imaginary part will be automatically computed as Imag = Real * Tangent delta.
            obj.AddToHistory(['.AddDispersionFittingValueXYZMu "', num2str(dFrequency, '%.15g'), '", '...
                                                              '"', num2str(dReX, '%.15g'), '", '...
                                                              '"', num2str(dImXordTandX, '%.15g'), '", '...
                                                              '"', num2str(dReY, '%.15g'), '", '...
                                                              '"', num2str(dImYordTandY, '%.15g'), '", '...
                                                              '"', num2str(dReZ, '%.15g'), '", '...
                                                              '"', num2str(dImZordTandZ, '%.15g'), '", '...
                                                              '"', num2str(dWeight, '%.15g'), '"']);
            obj.adddispersionfittingvaluexyzmu.dFrequency = dFrequency;
            obj.adddispersionfittingvaluexyzmu.dReX = dReX;
            obj.adddispersionfittingvaluexyzmu.dImXordTandX = dImXordTandX;
            obj.adddispersionfittingvaluexyzmu.dReY = dReY;
            obj.adddispersionfittingvaluexyzmu.dImYordTandY = dImYordTandY;
            obj.adddispersionfittingvaluexyzmu.dReZ = dReZ;
            obj.adddispersionfittingvaluexyzmu.dImZordTandZ = dImZordTandZ;
            obj.adddispersionfittingvaluexyzmu.dWeight = dWeight;
        end
        function DispersiveFittingSchemeEps(obj, key)
            % Sets the required fitting scheme.
            % key: 'Conductivity'
            %      '1st Order'
            %      '2nd Order'
            %      'Nth Order'
            obj.AddToHistory(['.DispersiveFittingSchemeEps "', num2str(key, '%.15g'), '"']);
            obj.dispersivefittingschemeeps = key;
        end
        function DispersiveFittingSchemeMu(obj, key)
            % Sets the required fitting scheme.
            % key: 'Conductivity'
            %      '1st Order'
            %      '2nd Order'
            %      'Nth Order'
            obj.AddToHistory(['.DispersiveFittingSchemeMu "', num2str(key, '%.15g'), '"']);
            obj.dispersivefittingschememu = key;
        end
        function MaximalOrderNthModelFitEps(obj, iValue)
            % Set the maximum allowed order for the nth fit interpolation scheme ("Nth Order"), for the eps or mu interpolation, respectively. The maximum number of poles is directly related both to the fitting accuracy and to the model complexity and therefore to simulation memory and computational time requirements.
            obj.AddToHistory(['.MaximalOrderNthModelFitEps "', num2str(iValue, '%.15g'), '"']);
            obj.maximalordernthmodelfiteps = iValue;
        end
        function MaximalOrderNthModelFitMu(obj, iValue)
            % Set the maximum allowed order for the nth fit interpolation scheme ("Nth Order"), for the eps or mu interpolation, respectively. The maximum number of poles is directly related both to the fitting accuracy and to the model complexity and therefore to simulation memory and computational time requirements.
            obj.AddToHistory(['.MaximalOrderNthModelFitMu "', num2str(iValue, '%.15g'), '"']);
            obj.maximalordernthmodelfitmu = iValue;
        end
        function UseOnlyDataInSimFreqRangeNthModelEps(obj, boolean)
            % Allow the nth order fit for the eps or mu interpolation scheme, respectively, ("Nth Order") to use only the frequency data points that lie within the "frequency range settings" defined by the user. Activating this switch enables an accurate data fitting of the material resonances which occur in the simulation bandwidth of interest using possibly a reduced number of poles and zeroes with respect to the complete data fitting. And this, in turn, translates into benefits for the simulation complexity in terms of memory and computational time.
            obj.AddToHistory(['.UseOnlyDataInSimFreqRangeNthModelEps "', num2str(boolean, '%.15g'), '"']);
            obj.useonlydatainsimfreqrangenthmodeleps = boolean;
        end
        function UseOnlyDataInSimFreqRangeNthModelMu(obj, boolean)
            % Allow the nth order fit for the eps or mu interpolation scheme, respectively, ("Nth Order") to use only the frequency data points that lie within the "frequency range settings" defined by the user. Activating this switch enables an accurate data fitting of the material resonances which occur in the simulation bandwidth of interest using possibly a reduced number of poles and zeroes with respect to the complete data fitting. And this, in turn, translates into benefits for the simulation complexity in terms of memory and computational time.
            obj.AddToHistory(['.UseOnlyDataInSimFreqRangeNthModelMu "', num2str(boolean, '%.15g'), '"']);
            obj.useonlydatainsimfreqrangenthmodelmu = boolean;
        end
        function UseGeneralDispersionEps(obj, boolean)
            % Use this function to activate/deactivate the user defined dispersion.
            obj.AddToHistory(['.UseGeneralDispersionEps "', num2str(boolean, '%.15g'), '"']);
            obj.usegeneraldispersioneps = boolean;
        end
        function UseGeneralDispersionMu(obj, boolean)
            % Use this function to activate/deactivate the user defined dispersion.
            obj.AddToHistory(['.UseGeneralDispersionMu "', num2str(boolean, '%.15g'), '"']);
            obj.usegeneraldispersionmu = boolean;
        end
        %% Tensor Formulas
        % The following methods apply if used together with .Type("Tensor formula").
        function TensorFormulaFor(obj, key)
            % Call to begin the definition of a dispersive material, the material properties of which are described by complex tensors with each entry given by a formula. You may either define the relative permittivity or permeability, or both. If not specified otherwise, tensor values on its diagonal will be interpreted as One, and other entries as Zero. An alignment vector can be specified independently for each material property to rotate the tensor. Details are given below.
            % key: 'epsilon_r'
            %      'mu_r'
            obj.AddToHistory(['.TensorFormulaFor "', num2str(key, '%.15g'), '"']);
            obj.tensorformulafor = key;
        end
        function TensorFormulaReal(obj, row, column, formula)
            % Use this method to continue the definition of a dispersive material's complex tensor. Provide the formula for the real part's value at the given row and column. The character "f" is used as a placeholder for the frequency in Hz. The real part of the tensor is one on the main diagonal and zero elsewhere if not specified. Admissible values for row and column are 0, 1, and 2.
            obj.AddToHistory(['.TensorFormulaReal "', num2str(row, '%.15g'), '", '...
                                                 '"', num2str(column, '%.15g'), '", '...
                                                 '"', num2str(formula, '%.15g'), '"']);
            obj.tensorformulareal.row = row;
            obj.tensorformulareal.column = column;
            obj.tensorformulareal.formula = formula;
        end
        function TensorFormulaImag(obj, row, column, formula)
            % Use this method to continue the definition of a dispersive material's complex tensor. Provide the formula for the negative imaginary part's value at the given row and column. Since the negative imaginary part is given, formulas on the main diagonal that evaluate to a positive value introduce losses into the structure, while a negative value for the negative imaginary part results in an active material. The character "f" is used as a placeholder for the frequency in Hz. The imaginary part of the tensor is zero if not specified. Values for the integer tensor indices are zero to two.
            obj.AddToHistory(['.TensorFormulaImag "', num2str(row, '%.15g'), '", '...
                                                 '"', num2str(column, '%.15g'), '", '...
                                                 '"', num2str(formula, '%.15g'), '"']);
            obj.tensorformulaimag.row = row;
            obj.tensorformulaimag.column = column;
            obj.tensorformulaimag.formula = formula;
        end
        function TensorAlignment(obj, w_x, w_y, w_z)
            % Defines a rotation of the tensor. By default, the alignment vector is w_x=0, w_y=0, w_z=1, and no rotation will be applied. The tensor is then taken as-is. For other alignment vectors, the rotation transformation is defined such that it maps the alignment vector onto the z-axis. After applying the tensor, the result vector is mapped back by the inverse transformation.
            % This allows to specify the formulas for the z-direction, and consider the actual material alignment in space later on. Please note that this approach is for tensors which have a different material behavior in one designated direction and the same properties perpendicular to that direction, as is the case for some material models for biased ferrites. If a rotation around the designated direction is required, it must be entered manually, since the TensorAlignment vector does not provide enough information to define that rotation.
            % Also note that the alignment vector needs to be set for each material property separately. Thus call TensorAlignment after each call to TensorFormulaFor.
            obj.AddToHistory(['.TensorAlignment "', num2str(w_x, '%.15g'), '", '...
                                               '"', num2str(w_y, '%.15g'), '", '...
                                               '"', num2str(w_z, '%.15g'), '"']);
            obj.tensoralignment.w_x = w_x;
            obj.tensoralignment.w_y = w_y;
            obj.tensoralignment.w_z = w_z;
        end
        function TensorAlignment2(obj, u_x, u_y, u_z, v_y, v_z)
            % Defines a rotation of the tensor. By default, the alignment vectors are u_x=1, u_y=0, u_z=0 and v_x=0, v_y=1, v_z=0 and no rotation will be applied. The tensor is then taken as-is. For other alignment vectors, the rotation transformation is defined such that it maps the local (u, v, w) coordinate system onto the global (x, z, y) coordinate system. After applying the tensor, the result vector is mapped back by the inverse transformation.
            % This allows to specify the formulas for the z-direction, and consider the actual material alignment in space later on.
            % Please note that the alignment vector needs to be set for each material property separately. Thus call TensorAlignment2 after each call to TensorFormulaFor.
            obj.AddToHistory(['.TensorAlignment2 "', num2str(u_x, '%.15g'), '", '...
                                                '"', num2str(u_y, '%.15g'), '", '...
                                                '"', num2str(u_z, '%.15g'), '", '...
                                                '"', num2str(v_y, '%.15g'), '", '...
                                                '"', num2str(v_z, '%.15g'), '"']);
            obj.tensoralignment2.u_x = u_x;
            obj.tensoralignment2.u_y = u_y;
            obj.tensoralignment2.u_z = u_z;
            obj.tensoralignment2.v_y = v_y;
            obj.tensoralignment2.v_z = v_z;
        end
        %% Spatially Varying Materials
        % The following methods define a radial spatially varying material whose properties vary according to a function of radius - in case of spherical structure - or of the distance to an axis - in case of cylindrical structure (see also Methods for Spatially Varying Material Geometry Generation in the Mesh Object page). The function domain is normalized within the [0, 1] range where 0 corresponds to the sphere center (or cylindrical axis) and 1 to the structure surface.
        % The following commands may be applied to specify the material permittivity or permeability and the electric or magnetic conductivity. The corresponding keys to be used in the following commands are ( enum { "eps" , "mu" , "sigma" , "sigmam" } property ).
        function ResetSpatiallyVaryingMaterialParameter(obj, property)
            % Resets the spatially varying definition for the selected material property (permittivity, permeability or electric and magnetic conductivity).
            % property: 'eps'
            %           'mu'
            %           'sigma'
            %           'sigmam'
            obj.AddToHistory(['.ResetSpatiallyVaryingMaterialParameter "', num2str(property, '%.15g'), '"']);
            obj.resetspatiallyvaryingmaterialparameter = property;
        end
        function SpatiallyVaryingMaterialModel(obj, property, model)
            % Specifies the radial dependency for the selected material property. The available analytical values for model are the following:
            % Constant - defines a constant radial dependency.
            % Luneburg - defines a quadratic radial dependency, as normally encountered for the specification of Luneburg lenses.
            % PowerLaw - defines a generic polynomial radial dependency.
            % GradedIndex - defines an hyperbolic radial dependency, as normally encountered for the specification of optical fibers.
            % property,: 'eps'
            %            'mu'
            %            'sigma'
            %            'sigmam'
            obj.AddToHistory(['.SpatiallyVaryingMaterialModel "', num2str(property, '%.15g'), '", '...
                                                             '"', num2str(model, '%.15g'), '"']);
            obj.spatiallyvaryingmaterialmodel.property = property;
            obj.spatiallyvaryingmaterialmodel.model = model;
        end
        function SpatiallyVaryingMaterialModelAniso(obj, property, direction, model)
            % This command defines a spatially varying material model exactly as the previous one but applying the model only to a specific (x, y, z) direction. This is useful to define a spatially varying anisotropic material.
            % property,: 'eps'
            %            'mu'
            %            'sigma'
            %            'sigmam'
            % direction,: 'x'
            %             'y'
            %             'z'
            obj.AddToHistory(['.SpatiallyVaryingMaterialModelAniso "', num2str(property, '%.15g'), '", '...
                                                                  '"', num2str(direction, '%.15g'), '", '...
                                                                  '"', num2str(model, '%.15g'), '"']);
            obj.spatiallyvaryingmaterialmodelaniso.property = property;
            obj.spatiallyvaryingmaterialmodelaniso.direction = direction;
            obj.spatiallyvaryingmaterialmodelaniso.model = model;
        end
        function AddSpatiallyVaryingMaterialParameter(obj, property, key, value)
            % With this command it is possible to define the analytical radial dependency. Each function model specified with the .SpatiallyVaryingMaterialModel command comes with its own set of values to be defined in order to completely specify the function. The available set of key is therefore dependent on the selected model. In the following table the complete list is given where f(r) denotes the radial function itself.
            % Constant
            %     f(r) = value_constant
            %     This function  defines a constant value independent on the radius.
            %     The only key to be provided is the function constant value value_constant.
            % Luneburg
            %     f(r) =  value_center + ( value_surface - value_center )  * r^2
            %     This function defines a quadratic radial dependency, as normally encountered for the specification of Luneburg lenses.
            %     The keys to be provided are the value at the center of the sphere value_center and the value at the surface of it value_surface.
            % PowerLaw
            %     f(r) =  value_axis * ( 1 - delta * r^value_profile ) where  delta = ( value_axis - value_cladding ) / value_axis
            %     This function defines a generic polynomial radial dependency, generally used for optical fibers.
            %     The keys to be specified are the value at the axis center value_axis and the value at the surface value_cladding of the fiber. The polynomial dependency is controlled by the value_profile value.
            % GradedIndex
            %     f(r) =  value_axis / cosh( arg )^2  where  arg = value_gradient  * r
            %     This function defines an hyperbolic radial dependency, as normally encountered for the specification of optical fibers.
            %     The keys to be specified are the value at the axis center value_axis and the slope value value_gradient.
            % property,: 'eps'
            %            'mu'
            %            'sigma'
            %            'sigmam'
            obj.AddToHistory(['.AddSpatiallyVaryingMaterialParameter "', num2str(property, '%.15g'), '", '...
                                                                    '"', num2str(key, '%.15g'), '", '...
                                                                    '"', num2str(value, '%.15g'), '"']);
            obj.addspatiallyvaryingmaterialparameter.property = property;
            obj.addspatiallyvaryingmaterialparameter.key = key;
            obj.addspatiallyvaryingmaterialparameter.value = value;
        end
        function AddSpatiallyVaryingMaterialParameterAniso(obj, property, direction, key, value)
            % This command define a (key, value) pair to specify the analytical radial dependency material exactly as the previous one, but applying the properties only to a specific (x, y, z) direction. This is useful to define a spatially varying anisotropic material.
            % property,: 'eps'
            %            'mu'
            %            'sigma'
            %            'sigmam'
            % direction,: 'x'
            %             'y'
            %             'z'
            obj.AddToHistory(['.AddSpatiallyVaryingMaterialParameterAniso "', num2str(property, '%.15g'), '", '...
                                                                         '"', num2str(direction, '%.15g'), '", '...
                                                                         '"', num2str(key, '%.15g'), '", '...
                                                                         '"', num2str(value, '%.15g'), '"']);
            obj.addspatiallyvaryingmaterialparameteraniso.property = property;
            obj.addspatiallyvaryingmaterialparameteraniso.direction = direction;
            obj.addspatiallyvaryingmaterialparameteraniso.key = key;
            obj.addspatiallyvaryingmaterialparameteraniso.value = value;
        end
        %% Space Map Based Materials
        function following = The(obj)
            % The corresponding keys to be used in the following commands belong to the property enumeration  ( enum { "eps" , "mu" , "sigma" , "sigmam" , "epsinfinity" , "muinfinity" , "dispcoeff0eps" , "dispcoeff0mu" , "dispcoeff1eps" , "dispcoeff1mu" , "dispcoeff2eps" , "dispcoeff2mu" , "dispcoeff3eps" , "dispcoeff3mu" , "dispcoeff4eps" , "dispcoeff4mu" } property ).
            % The permittivity and permeability ("eps" , "mu") and electric or magnetic conductivity ("sigma" , "sigmam") are used in case of conductivity models. In case of general dispersion all coefficients required to define the model can be specified as space map. Allowed models are both the linear (Debye first and second order, Drude, Lorentz, general first or second order) and the nonlinear ones (nonlinear second and third order, Kerr and Raman). For all these cases the property dispcoeffXeps and dispcoeffXmu (with X=0...4) are used according to the parameter table of the DispModelEps / DispModelMu commands in the Dispersion section.
            following = obj.hMaterial.invoke('The');
        end
        function ResetSpaceMapBasedMaterial(obj, property)
            % Resets the space map based definition for the selected material property (permittivity, permeability, electric and magnetic conductivity or dispersive coefficients).
            obj.AddToHistory(['.ResetSpaceMapBasedMaterial "', num2str(property, '%.15g'), '"']);
            obj.resetspacemapbasedmaterial = property;
        end
        function SpaceMapBasedOperator(obj, property, model)
            % Specifies the spatial model (operator) for the selected material property. The available values for model are the following:
            % 3DConstant - defines a spatial constant dependency.
            % 3DDefault - defines a spatial constant dependency and equal to material default value.
            % 3DImport - the spatial distribution is described in a file.
            obj.AddToHistory(['.SpaceMapBasedOperator "', num2str(property, '%.15g'), '", '...
                                                     '"', num2str(model, '%.15g'), '"']);
            obj.spacemapbasedoperator.property = property;
            obj.spacemapbasedoperator.model = model;
        end
        function SpaceMapBasedOperatorAniso(obj, property, direction, model)
            % This command defines a space map based material model exactly as the previous one but applying the model only to a specific (x, y, z) direction. This is useful to define a space map based anisotropic material.
            % direction,: 'x'
            %             'y'
            %             'z'
            obj.AddToHistory(['.SpaceMapBasedOperatorAniso "', num2str(property, '%.15g'), '", '...
                                                          '"', num2str(direction, '%.15g'), '", '...
                                                          '"', num2str(model, '%.15g'), '"']);
            obj.spacemapbasedoperatoraniso.property = property;
            obj.spacemapbasedoperatoraniso.direction = direction;
            obj.spacemapbasedoperatoraniso.model = model;
        end
        function AddSpaceMapBasedMaterialStringParameter(obj, property, key, value)
            % With this command it is possible to define the spatial distribution. Each model specified with the .SpaceMapBasedOperator command comes with its own set of values to be defined in order to completely specify the function. The available set of key is therefore dependent on the selected model. A String or Double interface is available depending on the specific of key and model. In the following table the complete list is given, where f(x,y,z) denotes the material distribution.
            obj.AddToHistory(['.AddSpaceMapBasedMaterialStringParameter "', num2str(property, '%.15g'), '", '...
                                                                       '"', num2str(key, '%.15g'), '", '...
                                                                       '"', num2str(value, '%.15g'), '"']);
            obj.addspacemapbasedmaterialstringparameter.property = property;
            obj.addspacemapbasedmaterialstringparameter.key = key;
            obj.addspacemapbasedmaterialstringparameter.value = value;
        end
        function AddSpaceMapBasedMaterialDoubleParameter(obj, property, key, value)
            % With this command it is possible to define the spatial distribution. Each model specified with the .SpaceMapBasedOperator command comes with its own set of values to be defined in order to completely specify the function. The available set of key is therefore dependent on the selected model. A String or Double interface is available depending on the specific of key and model. In the following table the complete list is given, where f(x,y,z) denotes the material distribution.
            % 3DConstant
            %     f(x,y,z) = value_constant
            %     This function defines a constant value independent on the position.
            %     The only key to be provided is the function constant value [double] value_constant.
            % 3DDefault
            %     f(x,y,z) = value_default
            %     This function defines a constant value independent on the position and equal to the material default.
            %     No key is required.
            % 3DImport
            %     f(x,y,z) is specified on a cartesian grid stored on a file. The required values are obtained interpolating the available ones.
            %     The only key to be provided is the file name [name] map_filename. The file (with extension .m3d) should be stored in the Model/3D project subfolder.
            obj.AddToHistory(['.AddSpaceMapBasedMaterialDoubleParameter "', num2str(property, '%.15g'), '", '...
                                                                       '"', num2str(key, '%.15g'), '", '...
                                                                       '"', num2str(value, '%.15g'), '"']);
            obj.addspacemapbasedmaterialdoubleparameter.property = property;
            obj.addspacemapbasedmaterialdoubleparameter.key = key;
            obj.addspacemapbasedmaterialdoubleparameter.value = value;
        end
        function AddSpaceMapBasedMaterialStringParameterAniso(obj, property, direction, key, value)
            % This command defines a (key, value) pair to specify the space map based material exactly as the previous ones but applying the properties only to a specific (x, y, z) direction. This is useful to define a space map based anisotropic material.
            % direction,: 'x'
            %             'y'
            %             'z'
            obj.AddToHistory(['.AddSpaceMapBasedMaterialStringParameterAniso "', num2str(property, '%.15g'), '", '...
                                                                            '"', num2str(direction, '%.15g'), '", '...
                                                                            '"', num2str(key, '%.15g'), '", '...
                                                                            '"', num2str(value, '%.15g'), '"']);
            obj.addspacemapbasedmaterialstringparameteraniso.property = property;
            obj.addspacemapbasedmaterialstringparameteraniso.direction = direction;
            obj.addspacemapbasedmaterialstringparameteraniso.key = key;
            obj.addspacemapbasedmaterialstringparameteraniso.value = value;
        end
        function AddSpaceMapBasedMaterialDoubleParameterAniso(obj, property, direction, key, value)
            % This command defines a (key, value) pair to specify the space map based material exactly as the previous ones but applying the properties only to a specific (x, y, z) direction. This is useful to define a space map based anisotropic material.
            % direction,: 'x'
            %             'y'
            %             'z'
            obj.AddToHistory(['.AddSpaceMapBasedMaterialDoubleParameterAniso "', num2str(property, '%.15g'), '", '...
                                                                            '"', num2str(direction, '%.15g'), '", '...
                                                                            '"', num2str(key, '%.15g'), '", '...
                                                                            '"', num2str(value, '%.15g'), '"']);
            obj.addspacemapbasedmaterialdoubleparameteraniso.property = property;
            obj.addspacemapbasedmaterialdoubleparameteraniso.direction = direction;
            obj.addspacemapbasedmaterialdoubleparameteraniso.key = key;
            obj.addspacemapbasedmaterialdoubleparameteraniso.value = value;
        end
        function ConvertMaterialField(obj, filename_in, filename_out)
            % This is a convenience method to generate the material map file to be used together with the 3DImport operator which can be executed as control macro with the VBA macro editor.
            % The filename_in corresponds to an ascii file describing the spatial material distribution (see later the available formats).
            % The filename_out (with optional .m3d extension) will be generated as binary file and stored in the Model/3D project subfolder, according to the 3DImport model requirement.
            % The import file may be of the following types, FourColumns, FixedGrid and FlexibleGrid.
            % %
            % In case of the FourColumns format the data should be saved in four columns each separated by a space or tabulation character.
            % A template for the FourColumns format is the following:
            % x [mm]     y [mm]     z [mm]     ValueLabel [ValueUnit]
            % --------------------------------------------------------------------
            % x(0)       y(0)       z(0)       val(0)
            % ...
            % x(n-1)     y(n-1)     z(n-1)     val(n-1)
            % %
            % Notes:
            % The header of the file (the first two lines) is optional and contains information on the geometrical scale unit for the (x,y,z) coordinate.
            % Please note that the three units can be selected independently. In case the header is missing the user project units are used.
            % The following lines specify the material value at a given point.
            % The first three columns contain the (x, y, z) coordinate and are followed by the material property value.
            % A Cartesian grid will be generated from the available sets of coordinates { x(0)...x(n-1) }, { y(0)...y(n-1) } and { z(0)...z(n-1) } respectively.
            % If some coordinates are not found in the file and the corresponding values therefore not explicitly defined in the grid, they will be initialized with a 0 value.
            % This format can be conveniently used together with the ASCII file export for 2D/3D results (or with the equivalent result template). For more information see the Export Plot Data (ASCII / Binary) help page.
            % With this tool a 3D monitor can be exported (completely or specifying a sub volume) to an ASCII file compatible to the FourColumns format. The exported file can be therefore directly processed by the ConvertMaterialField command.
            % --------------------------------------------------------------
            % A template for the FixedGrid format is the following:
            % # CST material field file
            % # Format: FixedGrid
            % # Version: 20150107
            % # LengthUnit: mm
            % # SamplePoint x:
            % x(0) x(1)... x(n-1)
            % # SamplePoint y:
            % y(0) y(1)... y(m-1)
            % # SamplePoint z:
            % z(0) z(1)... z(l-1)
            % # Symmetry x: true
            % # Symmetry y: false
            % # Symmetry z: true
            % # Data section:
            % val(0,0,0) val(1, 0, 0) ... val(n-1, 0, 0)
            % val(0,1,0) val(1, 1, 0) ... val(n-1, 1, 0)
            % ...
            % val(0,m-1,0) val(1, m-1, 0) ... val(n-1, m-1, 0)
            % val(0,0,1) val(1, 0, 1) ... val(n-1, 0, 1)
            % val(0,1,1) val(1, 1, 1) ... val(n-1, 1, 1)
            % ...
            % val(0,m-1,0) val(1, m-1, 0) ... val(n-1, m-1, 1)
            % ...
            % val(0,0,l-1) val(1, 0, l-1) ... val(n-1, 0, l-1)
            % val(0,1,l-1) val(1, 1, l-1) ... val(n-1, 1, l-1)
            % ...
            % val(0,m-1,l-1) val(1, m-1, l-1) ... val(n-1, m-1, l-1)
            % %
            % Notes:
            % # LengthUnit: mm
            % Specifies the geometrical unit for the grid and the sample points. This is an optional field, if not specified the user project unit is used.
            % # SamplePoint x:
            % x(0) x(1)... x(n-1)
            % Specifies the n grid sample points for the x (y, z) axis. The point dimension is interpreted according to the # LengthUnit setting.
            % The set of sample points in the x, y and z direction generates the complete grid.
            % # Symmetry x: true
            % Specifies if the grid should be symmetrized across the x axis, enabling a more compact description of the values. This is an optional field, if not specified no symmetry will be applied.
            % # Data section:
            % After this key the value map has to be provided. A set of l block (each with n x m size and corresponding to a given z position) has to be specified.
            % In this way all n x m x l points of the grid are described.
            % --------------------------------------------------------------
            % A template for the FlexibleGrid format is the following:
            % # CST material field file
            % # Format: FlexibleGrid
            % # Version: 20150107
            % # LengthUnit: mm
            % # Background: 1.0
            % # SamplePoint x:
            % x(0) x(1)... x(n-1)
            % # SamplePoint y:
            % y(0) y(1)... y(m-1)
            % # SamplePoint z:
            % z(0) z(1)... z(l-1)
            % # Symmetry x: true
            % # Symmetry y: false
            % # Symmetry z: true
            % # Data section:
            % [i, j, k]  val(i, j, k)
            % %
            % Notes:
            % # LengthUnit: mm
            % Specifies the geometrical unit for the grid and the sample points. This is an optional field, if not specified the user project unit is used.
            % # Background: 1.0
            % This value is assumed as background and default value on the entire grid. This is an optional field, if not specified the background value is set as 0.0.
            % # SamplePoint x:
            % x(0) x(1)... x(n-1)
            % Specifies the n grid sample points for the x (y, z) axis. The point dimension is interpreted according to the # LengthUnit setting.
            % The set of sample points in the x, y and z direction generates the complete grid.
            % # Symmetry x: true
            % Specifies if the grid should be symmetrized across the x axis, enabling a more compact description of the values. This is an optional field, if not specified no symmetry will be applied.
            % # Data section:
            % After this key the values on the grid have to be provided. The [i, j, k] integer corresponds to the x(i), y(j), z(k) grid position and the val(i, j, k) is set to this grid position.
            % The remaining unset grid positions assume the # Background value.
            obj.AddToHistory(['.ConvertMaterialField "', num2str(filename_in, '%.15g'), '", '...
                                                    '"', num2str(filename_out, '%.15g'), '"']);
            obj.convertmaterialfield.filename_in = filename_in;
            obj.convertmaterialfield.filename_out = filename_out;
        end
        %% Raytracing Specific Materials
        % The following methods define a material whose properties are relevant for solvers based on raytracing techniques. The settings describe how the rays are being transmitted and reflected as a function of frequency and incident angle.
        function SetCoatingTypeDefinition(obj, property)
            % This command defines the type of the description for the material's properties:
            % PERFECT_ABSORBER - defines a perfectly absorbing material. All rays hitting this material are perfectly absorbed (no reflection).
            % SURFACE_IMPEDANCE_TABLE - defines an opaque material by describing the complex surface impedance as a function of frequency and incident angle. The surface impedance is specified separately for TE and TM polarizations.
            % REFLECTION_FACTOR_TABLE - defines an opaque material by describing the complex ray reflection factor as a function of frequency and incident angle. The reflection factor is specified separately for TE and TM polarizations.
            % REFLECTION_TRANSMISSION_FACTOR_TABLE - defines a transparent material by describing the complex ray reflection and transmission factors as functions of frequency and incident angle. The reflection and transmission factors are specified separately for TE and TM polarizations.
            % property: 'PERFECT_ABSORBER'
            %           'SURFACE_IMPEDANCE_TABLE'
            %           'REFLECTION_FACTOR_TABLE'
            %           'REFLECTION_TRANSMISSION_FACTOR_TABLE'
            obj.AddToHistory(['.SetCoatingTypeDefinition "', num2str(property, '%.15g'), '"']);
            obj.setcoatingtypedefinition = property;
        end
        function AddTabulatedSurfaceImpedance(obj, frequency, angle, ZReTE, ZImTE, ZReTM, ZImTM)
            % Defines a table entry for the surface impedance for a particular frequency in Hz and angle in degrees combination. The surface impedance is specified in Ohms and is described by real and imaginary parts for the TE and TM polarizations. This setting is only valid if the coating type definition is set to SURFACE_IMPEDANCE_TABLE.
            obj.AddToHistory(['.AddTabulatedSurfaceImpedance "', num2str(frequency, '%.15g'), '", '...
                                                            '"', num2str(angle, '%.15g'), '", '...
                                                            '"', num2str(ZReTE, '%.15g'), '", '...
                                                            '"', num2str(ZImTE, '%.15g'), '", '...
                                                            '"', num2str(ZReTM, '%.15g'), '", '...
                                                            '"', num2str(ZImTM, '%.15g'), '"']);
            obj.addtabulatedsurfaceimpedance.frequency = frequency;
            obj.addtabulatedsurfaceimpedance.angle = angle;
            obj.addtabulatedsurfaceimpedance.ZReTE = ZReTE;
            obj.addtabulatedsurfaceimpedance.ZImTE = ZImTE;
            obj.addtabulatedsurfaceimpedance.ZReTM = ZReTM;
            obj.addtabulatedsurfaceimpedance.ZImTM = ZImTM;
        end
        function AddTabulatedReflectionFactor(obj, frequency, angle, RReTE, RImTE, RReTM, RImTM)
            % Defines a table entry for the reflection factor for a particular frequency in Hz and angle in degrees combination. The reflection factor is described by real and imaginary parts for the TE and TM polarizations. This setting is only valid if the coating type definition is set to REFLECTION_FACTOR_TABLE.
            obj.AddToHistory(['.AddTabulatedReflectionFactor "', num2str(frequency, '%.15g'), '", '...
                                                            '"', num2str(angle, '%.15g'), '", '...
                                                            '"', num2str(RReTE, '%.15g'), '", '...
                                                            '"', num2str(RImTE, '%.15g'), '", '...
                                                            '"', num2str(RReTM, '%.15g'), '", '...
                                                            '"', num2str(RImTM, '%.15g'), '"']);
            obj.addtabulatedreflectionfactor.frequency = frequency;
            obj.addtabulatedreflectionfactor.angle = angle;
            obj.addtabulatedreflectionfactor.RReTE = RReTE;
            obj.addtabulatedreflectionfactor.RImTE = RImTE;
            obj.addtabulatedreflectionfactor.RReTM = RReTM;
            obj.addtabulatedreflectionfactor.RImTM = RImTM;
        end
        function AddTabulatedReflectionTransmissionFactor(obj, frequency, angle, RReTE, RImTE, RReTM, RImTM, TReTE, TImTE, TReTM, TImTM)
            % Defines a table entry for the reflection and transmission factors for a particular frequency in Hz and angle in degrees combination. The reflection and transmission factors are described by real and imaginary parts for the TE and TM polarizations. This setting is only valid if the coating type definition is set to REFLECTION_TRANSMISSION_FACTOR_TABLE.
            obj.AddToHistory(['.AddTabulatedReflectionTransmissionFactor "', num2str(frequency, '%.15g'), '", '...
                                                                        '"', num2str(angle, '%.15g'), '", '...
                                                                        '"', num2str(RReTE, '%.15g'), '", '...
                                                                        '"', num2str(RImTE, '%.15g'), '", '...
                                                                        '"', num2str(RReTM, '%.15g'), '", '...
                                                                        '"', num2str(RImTM, '%.15g'), '", '...
                                                                        '"', num2str(TReTE, '%.15g'), '", '...
                                                                        '"', num2str(TImTE, '%.15g'), '", '...
                                                                        '"', num2str(TReTM, '%.15g'), '", '...
                                                                        '"', num2str(TImTM, '%.15g'), '"']);
            obj.addtabulatedreflectiontransmissionfactor.frequency = frequency;
            obj.addtabulatedreflectiontransmissionfactor.angle = angle;
            obj.addtabulatedreflectiontransmissionfactor.RReTE = RReTE;
            obj.addtabulatedreflectiontransmissionfactor.RImTE = RImTE;
            obj.addtabulatedreflectiontransmissionfactor.RReTM = RReTM;
            obj.addtabulatedreflectiontransmissionfactor.RImTM = RImTM;
            obj.addtabulatedreflectiontransmissionfactor.TReTE = TReTE;
            obj.addtabulatedreflectiontransmissionfactor.TImTE = TImTE;
            obj.addtabulatedreflectiontransmissionfactor.TReTM = TReTM;
            obj.addtabulatedreflectiontransmissionfactor.TImTM = TImTM;
        end
        function Thickness(obj, thickness)
            % Defines the thickness of the transparent material coating. This setting is only valid if the coating type definition is set to REFLECTION_TRANSMISSION_FACTOR_TABLE.
            obj.AddToHistory(['.Thickness "', num2str(thickness, '%.15g'), '"']);
            obj.thickness = thickness;
        end
        %% Temperature Dependent Materials
        function AddTemperatureDepEps(obj, dTemperature, dValue)
            % This method enables you to define a specific temperature dependency curve for electric permittivity by adding point by point. Use with .Type set "Normal".
            obj.AddToHistory(['.AddTemperatureDepEps "', num2str(dTemperature, '%.15g'), '", '...
                                                    '"', num2str(dValue, '%.15g'), '"']);
            obj.addtemperaturedepeps.dTemperature = dTemperature;
            obj.addtemperaturedepeps.dValue = dValue;
        end
        function ResetTemperatureDepEps(obj)
            % Deletes the temperature dependency curve for electric permittivity.
            obj.AddToHistory(['.ResetTemperatureDepEps']);
        end
        function AddTemperatureDepMu(obj, dTemperature, dValue)
            % With this method a new point for temperature dependency of magnetic permeability can be specified. Use with .Type set "Normal" or "Lossy Metal".
            obj.AddToHistory(['.AddTemperatureDepMu "', num2str(dTemperature, '%.15g'), '", '...
                                                   '"', num2str(dValue, '%.15g'), '"']);
            obj.addtemperaturedepmu.dTemperature = dTemperature;
            obj.addtemperaturedepmu.dValue = dValue;
        end
        function ResetTemperatureDepMu(obj)
            % Deletes the temperature dependency curve for magnetic permeability.
            obj.AddToHistory(['.ResetTemperatureDepMu']);
        end
        function AddTemperatureDepSigma(obj, dTemperature, dValue)
            % With this method a new point for temperature dependency of electric conductivity can be specified. Use with .Type set "Normal" or "Lossy Metal".
            obj.AddToHistory(['.AddTemperatureDepSigma "', num2str(dTemperature, '%.15g'), '", '...
                                                      '"', num2str(dValue, '%.15g'), '"']);
            obj.addtemperaturedepsigma.dTemperature = dTemperature;
            obj.addtemperaturedepsigma.dValue = dValue;
        end
        function ResetTemperatureDepSigma(obj)
            % Deletes the temperature dependency curve for electric conductivity.
            obj.AddToHistory(['.ResetTemperatureDepSigma']);
        end
        function SetTemperatureDepSourceField(obj, fieldName)
            % Select the name of the imported temperature field to use with this material. If it is not specified, the temperature field imported in the current project will be used.
            obj.AddToHistory(['.SetTemperatureDepSourceField "', num2str(fieldName, '%.15g'), '"']);
            obj.settemperaturedepsourcefield = fieldName;
        end
        %% Nonlinear Materials
        function AddHBValue(obj, Hvalue, Bvalue)
            % This method enables you to define a specific nonlinear H-B curve by adding point by point. Use with .Type set to "Nonlinear".
            obj.AddToHistory(['.AddHBValue "', num2str(Hvalue, '%.15g'), '", '...
                                          '"', num2str(Bvalue, '%.15g'), '"']);
            obj.addhbvalue.Hvalue = Hvalue;
            obj.addhbvalue.Bvalue = Bvalue;
        end
        function ResetHBList(obj)
            % Deletes the nonlinear H-B curve.
            obj.AddToHistory(['.ResetHBList']);
        end
        %% Nonlinear Stacking Properties
        function NLAnisotropy(obj, bUseAnisotropy)
            % Specifies whether the nonlinear material is purely isotropic or not. If the flag is set True, laminated materials are considered  in this context which can be specified via a stacking factor and a stacking direction. By default, purely isotropic material is assumed (bUseAnisotropy = False), i.e. stacking settings are ignored.
            % This setting applies only to materials of type Nonlinear.
            obj.AddToHistory(['.NLAnisotropy "', num2str(bUseAnisotropy, '%.15g'), '"']);
            obj.nlanisotropy = bUseAnisotropy;
        end
        function NLAStackingFactor(obj, dFactor)
            % Sets the fraction of the layers in the laminated material. The fraction of each layer is the ratio of the thickness of the nonlinear part to the thickness of the entire layer including the insulation. By default, this fraction is 1 (dFactor = 1), which is equivalent to isotropy.
            % This setting applies only to materials of type Nonlinear with NLAnisotropy switched on.
            obj.AddToHistory(['.NLAStackingFactor "', num2str(dFactor, '%.15g'), '"']);
            obj.nlastackingfactor = dFactor;
        end
        function NLADirectionX(obj, dDirX)
            % Set the stacking direction which is perpendicular to the layers (lamination direction) of the stacked material. Depending on the chosen coordinate system (NLACoordSystem), the direction is interpreted either in global coordinates or in the coordinates of the local solid coordinate system (provided there is one). By default, the direction points into X-direction (dDirX = 1.0, dDirY = dDirZ = 0.0).
            % This setting applies only to materials of type Nonlinear with NLAnisotropy switched on.
            % Please note that the direction set by NLADirectionX/Y/Z is interpreted either in global or local solid coordinates, depending on the setting ReferenceCoordSystem (see Basic Material Parameters). When the type "Solid" is chosen, it is required that each solid with this material has a local solid coordinate system. When there is no local solid coordinate system available, the stacking direction will be interpreted in global coordinates. By default, the stacking direction is interpreted in global coordinates.
            % The advantage of choosing local solid coordinates is that only one material has to be defined for solids with different orientations.
            % This setting applies only to materials of type Nonlinear with NLAnisotropy switched on.
            obj.AddToHistory(['.NLADirectionX "', num2str(dDirX, '%.15g'), '"']);
            obj.nladirectionx = dDirX;
        end
        function NLADirectionY(obj, dDirY)
            % Set the stacking direction which is perpendicular to the layers (lamination direction) of the stacked material. Depending on the chosen coordinate system (NLACoordSystem), the direction is interpreted either in global coordinates or in the coordinates of the local solid coordinate system (provided there is one). By default, the direction points into X-direction (dDirX = 1.0, dDirY = dDirZ = 0.0).
            % This setting applies only to materials of type Nonlinear with NLAnisotropy switched on.
            % Please note that the direction set by NLADirectionX/Y/Z is interpreted either in global or local solid coordinates, depending on the setting ReferenceCoordSystem (see Basic Material Parameters). When the type "Solid" is chosen, it is required that each solid with this material has a local solid coordinate system. When there is no local solid coordinate system available, the stacking direction will be interpreted in global coordinates. By default, the stacking direction is interpreted in global coordinates.
            % The advantage of choosing local solid coordinates is that only one material has to be defined for solids with different orientations.
            % This setting applies only to materials of type Nonlinear with NLAnisotropy switched on.
            obj.AddToHistory(['.NLADirectionY "', num2str(dDirY, '%.15g'), '"']);
            obj.nladirectiony = dDirY;
        end
        function NLADirectionZ(obj, dDirZ)
            % Set the stacking direction which is perpendicular to the layers (lamination direction) of the stacked material. Depending on the chosen coordinate system (NLACoordSystem), the direction is interpreted either in global coordinates or in the coordinates of the local solid coordinate system (provided there is one). By default, the direction points into X-direction (dDirX = 1.0, dDirY = dDirZ = 0.0).
            % This setting applies only to materials of type Nonlinear with NLAnisotropy switched on.
            % Please note that the direction set by NLADirectionX/Y/Z is interpreted either in global or local solid coordinates, depending on the setting ReferenceCoordSystem (see Basic Material Parameters). When the type "Solid" is chosen, it is required that each solid with this material has a local solid coordinate system. When there is no local solid coordinate system available, the stacking direction will be interpreted in global coordinates. By default, the stacking direction is interpreted in global coordinates.
            % The advantage of choosing local solid coordinates is that only one material has to be defined for solids with different orientations.
            % This setting applies only to materials of type Nonlinear with NLAnisotropy switched on.
            obj.AddToHistory(['.NLADirectionZ "', num2str(dDirZ, '%.15g'), '"']);
            obj.nladirectionz = dDirZ;
        end
        %% Particle-material Interactions
        function ParticleProperty(obj, strValue)
            % Sets the property for materials that support particle-material interactions: "None", "SecondaryEmission", "SheetTransparency".
            obj.AddToHistory(['.ParticleProperty "', num2str(strValue, '%.15g'), '"']);
            obj.particleproperty = strValue;
        end
        function SeModel(obj, strValue)
            % Sets the type of  the secondary electron emission model: "None", "Furman", "Import", "Vaughan".
            obj.AddToHistory(['.SeModel "', num2str(strValue, '%.15g'), '"']);
            obj.semodel = strValue;
        end
        function SeMaxGenerations(obj, iValue)
            % Sets the number of secondary generations that one primary (source) electron can produce.
            obj.AddToHistory(['.SeMaxGenerations "', num2str(iValue, '%.15g'), '"']);
            obj.semaxgenerations = iValue;
        end
        function SeMaxSecondaries(obj, iValue)
            % Sets the maximum number of electrons that a primary (source) electron can produce per hit.
            obj.AddToHistory(['.SeMaxSecondaries "', num2str(iValue, '%.15g'), '"']);
            obj.semaxsecondaries = iValue;
        end
        function SeTsParam_T1(obj, dValue)
            % Sets the basic model parameters for the true secondary electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeTsParam_T1 "', num2str(dValue, '%.15g'), '"']);
            obj.setsparam_t1 = dValue;
        end
        function SeTsParam_T2(obj, dValue)
            % Sets the basic model parameters for the true secondary electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeTsParam_T2 "', num2str(dValue, '%.15g'), '"']);
            obj.setsparam_t2 = dValue;
        end
        function SeTsParam_T3(obj, dValue)
            % Sets the basic model parameters for the true secondary electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeTsParam_T3 "', num2str(dValue, '%.15g'), '"']);
            obj.setsparam_t3 = dValue;
        end
        function SeTsParam_T4(obj, dValue)
            % Sets the basic model parameters for the true secondary electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeTsParam_T4 "', num2str(dValue, '%.15g'), '"']);
            obj.setsparam_t4 = dValue;
        end
        function SeTsParam_SEY(obj, dValue)
            % Sets the basic model parameters for the true secondary electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeTsParam_SEY "', num2str(dValue, '%.15g'), '"']);
            obj.setsparam_sey = dValue;
        end
        function SeTsParam_Energy(obj, dValue)
            % Sets the basic model parameters for the true secondary electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeTsParam_Energy "', num2str(dValue, '%.15g'), '"']);
            obj.setsparam_energy = dValue;
        end
        function SeTsParam_S(obj, dValue)
            % Sets the basic model parameters for the true secondary electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeTsParam_S "', num2str(dValue, '%.15g'), '"']);
            obj.setsparam_s = dValue;
        end
        function SeTsParam_PN(obj, iValue, dValue)
            % Sets the additional model parameters for the true secondary electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview. For SeTsParam_PN and SeTsParam_EpsN  10 values have to be set. The parameter iValue has to be in the range 0 to 9.
            obj.AddToHistory(['.SeTsParam_PN "', num2str(iValue, '%.15g'), '", '...
                                            '"', num2str(dValue, '%.15g'), '"']);
            obj.setsparam_pn.iValue = iValue;
            obj.setsparam_pn.dValue = dValue;
        end
        function SeTsParam_EpsN(obj, iValue, dValue)
            % Sets the additional model parameters for the true secondary electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview. For SeTsParam_PN and SeTsParam_EpsN  10 values have to be set. The parameter iValue has to be in the range 0 to 9.
            obj.AddToHistory(['.SeTsParam_EpsN "', num2str(iValue, '%.15g'), '", '...
                                              '"', num2str(dValue, '%.15g'), '"']);
            obj.setsparam_epsn.iValue = iValue;
            obj.setsparam_epsn.dValue = dValue;
        end
        function SeRdParam_R(obj, dValue)
            % Sets the model parameters for the rediffused secondary electrons.  Further information can be found inthe online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeRdParam_R "', num2str(dValue, '%.15g'), '"']);
            obj.serdparam_r = dValue;
        end
        function SeRdParam_R1(obj, dValue)
            % Sets the model parameters for the rediffused secondary electrons.  Further information can be found inthe online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeRdParam_R1 "', num2str(dValue, '%.15g'), '"']);
            obj.serdparam_r1 = dValue;
        end
        function SeRdParam_R2(obj, dValue)
            % Sets the model parameters for the rediffused secondary electrons.  Further information can be found inthe online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeRdParam_R2 "', num2str(dValue, '%.15g'), '"']);
            obj.serdparam_r2 = dValue;
        end
        function SeRdParam_Q(obj, dValue)
            % Sets the model parameters for the rediffused secondary electrons.  Further information can be found inthe online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeRdParam_Q "', num2str(dValue, '%.15g'), '"']);
            obj.serdparam_q = dValue;
        end
        function SeRdParam_P1Inf(obj, dValue)
            % Sets the model parameters for the rediffused secondary electrons.  Further information can be found inthe online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeRdParam_P1Inf "', num2str(dValue, '%.15g'), '"']);
            obj.serdparam_p1inf = dValue;
        end
        function SeRdParam_Energy(obj, dValue)
            % Sets the model parameters for the rediffused secondary electrons.  Further information can be found inthe online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeRdParam_Energy "', num2str(dValue, '%.15g'), '"']);
            obj.serdparam_energy = dValue;
        end
        function SeBsParam_Sigma(obj, dValue)
            % Sets the model parameters for the backscattered or elastic reflected electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeBsParam_Sigma "', num2str(dValue, '%.15g'), '"']);
            obj.sebsparam_sigma = dValue;
        end
        function SeBsParam_E1(obj, dValue)
            % Sets the model parameters for the backscattered or elastic reflected electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeBsParam_E1 "', num2str(dValue, '%.15g'), '"']);
            obj.sebsparam_e1 = dValue;
        end
        function SeBsParam_E2(obj, dValue)
            % Sets the model parameters for the backscattered or elastic reflected electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeBsParam_E2 "', num2str(dValue, '%.15g'), '"']);
            obj.sebsparam_e2 = dValue;
        end
        function SeBsParam_P1Hat(obj, dValue)
            % Sets the model parameters for the backscattered or elastic reflected electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeBsParam_P1Hat "', num2str(dValue, '%.15g'), '"']);
            obj.sebsparam_p1hat = dValue;
        end
        function SeBsParam_P1Inf(obj, dValue)
            % Sets the model parameters for the backscattered or elastic reflected electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeBsParam_P1Inf "', num2str(dValue, '%.15g'), '"']);
            obj.sebsparam_p1inf = dValue;
        end
        function SeBsParam_Energy(obj, dValue)
            % Sets the model parameters for the backscattered or elastic reflected electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeBsParam_Energy "', num2str(dValue, '%.15g'), '"']);
            obj.sebsparam_energy = dValue;
        end
        function SeBsParam_P(obj, dValue)
            % Sets the model parameters for the backscattered or elastic reflected electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeBsParam_P "', num2str(dValue, '%.15g'), '"']);
            obj.sebsparam_p = dValue;
        end
        function SeBsParam_W(obj, dValue)
            % Sets the model parameters for the backscattered or elastic reflected electrons. Further information can be found in the online help at the topic Secondary Electron Emission Overview.
            obj.AddToHistory(['.SeBsParam_W "', num2str(dValue, '%.15g'), '"']);
            obj.sebsparam_w = dValue;
        end
        function SePlot1D(obj, bPlot, dAngle, dEnergy)
            % If bPlot is true, the secondary emission yield and the probability distribution function are added to 1D Results folder Materials in the Navigation Tree. This plot is enabled per default. The incident angle and energy must be also specified.
            obj.AddToHistory(['.SePlot1D "', num2str(bPlot, '%.15g'), '", '...
                                        '"', num2str(dAngle, '%.15g'), '", '...
                                        '"', num2str(dEnergy, '%.15g'), '"']);
            obj.seplot1d.bPlot = bPlot;
            obj.seplot1d.dAngle = dAngle;
            obj.seplot1d.dEnergy = dEnergy;
        end
        function SeVaughan(obj, dEnergyMax, dSEYieldMax, dEnergyThreshold, dSmoothness, dTemperature)
            % When the type of the emission model is set to "Vaughan", this method sets the parameters of the Vaughan emission model. dEnergyMax, in units of eV, is the energy where the maximum SEY, set by dSEYieldMax, takes place. dSmoothness is a smoothness parameter that depends on the surface of the material and has the value of one. The method sets the temperature parameter of the energy distribution of the secondary electrons (gamma distributed). This is done in units of eV via the argument dTemperature.
            obj.AddToHistory(['.SeVaughan "', num2str(dEnergyMax, '%.15g'), '", '...
                                         '"', num2str(dSEYieldMax, '%.15g'), '", '...
                                         '"', num2str(dEnergyThreshold, '%.15g'), '", '...
                                         '"', num2str(dSmoothness, '%.15g'), '", '...
                                         '"', num2str(dTemperature, '%.15g'), '"']);
            obj.sevaughan.dEnergyMax = dEnergyMax;
            obj.sevaughan.dSEYieldMax = dSEYieldMax;
            obj.sevaughan.dEnergyThreshold = dEnergyThreshold;
            obj.sevaughan.dSmoothness = dSmoothness;
            obj.sevaughan.dTemperature = dTemperature;
        end
        function SeImportSettings(obj, sFileName, dTemperature)
            % When the type of the emission model is set to "Import" (method SeModel), this method sets the name of the secondary electron yield (SEY) import file (including the parth) that is displayed in the SEY import dialog box. This setting  is to be used as a helpful display of the file name in the import dialog box and it cannot used to import SEY data from sFileName. To import SEY data, one can use either the method SeImportData or the SEY import dialog box. The method sets also the temperature parameter of the energy distribution of the secondary electrons (gamma distributed). This is done in units of eV via the argument dTemperature.
            obj.AddToHistory(['.SeImportSettings "', num2str(sFileName, '%.15g'), '", '...
                                                '"', num2str(dTemperature, '%.15g'), '"']);
            obj.seimportsettings.sFileName = sFileName;
            obj.seimportsettings.dTemperature = dTemperature;
        end
        function SeImportData(obj, dEnergy, dSEY)
            % When the type of the emission model is set to "Import", this method sets the secondary electron yield dSEY at the energy dENergy. This is equivalent to importing one pair of energy - SEY values of the SEY curve.
            obj.AddToHistory(['.SeImportData "', num2str(dEnergy, '%.15g'), '", '...
                                            '"', num2str(dSEY, '%.15g'), '"']);
            obj.seimportdata.dEnergy = dEnergy;
            obj.seimportdata.dSEY = dSEY;
        end
        function ParticleTransparencySettings(obj, sType, dPercent, sFileName)
            % This method can be used to adjust the input settings of the materials which are transparent to particles. These materials are characterized by a so-called transparency, which takes values between 0 and 1. The settings apply only on bodies which are sheets, i.e. which have zero length in one dimension,  and which are composed of these materials.
            % When the particles move through a sheet with transparency T, their macro-charge Q and mass M become T*Q and T*M after crossing the sheet.  If the transparency is 1, the particles move through the sheet. A transparency of 0 means that the particles collide with the sheet.
            % The argument sType can be used to define two possibilities for the transparency input settings. First, if the material has a homogeneous transparency, sType should be set to "Scalar". If the material has a transparency which depends on the particle incident energy, sType should be set to "Import". The dependency of the transparency on the incident particle energy can be provided either using the transparency import button in the material dialog box or using the method ParticleTransparencyImportData.
            % The argument dPercent can be used to set the transparency in % when sType is "Scalar".
            % The argument sFileName can be used to set the import file name (including the path). This is to be used as a helpful display of the file name in the material dialog box and not as a means to import the particle transparency data.
            % Note for the Tracking solver:
            % The Tracking solver does not support energy-dependent transparency, so no import is supported. Thus, the correct settings should have sType = "Scalar" and sFileName = "" (empty string).
            obj.AddToHistory(['.ParticleTransparencySettings "', num2str(sType, '%.15g'), '", '...
                                                            '"', num2str(dPercent, '%.15g'), '", '...
                                                            '"', num2str(sFileName, '%.15g'), '"']);
            obj.particletransparencysettings.sType = sType;
            obj.particletransparencysettings.dPercent = dPercent;
            obj.particletransparencysettings.sFileName = sFileName;
        end
        function ParticleTransparencyImportData(obj, dEnergy, dTransparency)
            % Note: this method applies only for the PIC solver.
            % When the type of the the transparency input data is set to "Import" (see method ParticleTransparencySettings) , this method sets the  dTransparency at the incident particle energy dEnergy. This is equivalent to importing one point of the transparency distribution as a function of energy. To import a complete transparency distribution, this method can be applied for every point of the distribution.
            obj.AddToHistory(['.ParticleTransparencyImportData "', num2str(dEnergy, '%.15g'), '", '...
                                                              '"', num2str(dTransparency, '%.15g'), '"']);
            obj.particletransparencyimportdata.dEnergy = dEnergy;
            obj.particletransparencyimportdata.dTransparency = dTransparency;
        end
        function SetEnergyStepForSEYPlots(obj, dStep)
            % Sets the energy step for SEY plots in units of eV.
            obj.AddToHistory(['.SetEnergyStepForSEYPlots "', num2str(dStep, '%.15g'), '"']);
            obj.setenergystepforseyplots = dStep;
        end
        function SpecialDispParamForPIC(obj, dEpsInf, dRelaxFreq, dResonFreq, dResonWidth, dLorentzWeight)
            % Note: this method applies only for the PIC solver.
            % This method can be used to set the special dispersion parameters, which is typically used to mitigate the effects of the numerical Cerenkov instability.
            obj.AddToHistory(['.SpecialDispParamForPIC "', num2str(dEpsInf, '%.15g'), '", '...
                                                      '"', num2str(dRelaxFreq, '%.15g'), '", '...
                                                      '"', num2str(dResonFreq, '%.15g'), '", '...
                                                      '"', num2str(dResonWidth, '%.15g'), '", '...
                                                      '"', num2str(dLorentzWeight, '%.15g'), '"']);
            obj.specialdispparamforpic.dEpsInf = dEpsInf;
            obj.specialdispparamforpic.dRelaxFreq = dRelaxFreq;
            obj.specialdispparamforpic.dResonFreq = dResonFreq;
            obj.specialdispparamforpic.dResonWidth = dResonWidth;
            obj.specialdispparamforpic.dLorentzWeight = dLorentzWeight;
        end
        function SpecialDispParamVisual(obj, MaxFreq, PropDist)
            % Note: this method applies only for the PIC solver.
            % This method can be used to adjust the display of the special dispersion plots.
            obj.AddToHistory(['.SpecialDispParamVisual "', num2str(MaxFreq, '%.15g'), '", '...
                                                      '"', num2str(PropDist, '%.15g'), '"']);
            obj.specialdispparamvisual.MaxFreq = MaxFreq;
            obj.specialdispparamvisual.PropDist = PropDist;
        end
        function IonizImportFile(obj, sFileName)
            % This method can be used to set the name of the file which is used to import the ionization cross-section data. To import the data, the method IonizImportDataPair must be used.
            obj.AddToHistory(['.IonizImportFile "', num2str(sFileName, '%.15g'), '"']);
            obj.ionizimportfile = sFileName;
        end
        function IonizImportDataPair(obj, dEnergy, dCrossSection)
            % This method sets the ionization collision cross-section at a given energy. This is equivalent to importing one data pair of energy the cross-section curve.
            obj.AddToHistory(['.IonizImportDataPair "', num2str(dEnergy, '%.15g'), '", '...
                                                   '"', num2str(dCrossSection, '%.15g'), '"']);
            obj.ionizimportdatapair.dEnergy = dEnergy;
            obj.ionizimportdatapair.dCrossSection = dCrossSection;
        end
        function IonizElectronEnergySpread(obj, dValue)
            % This method sets the energy spread for the low-energy secondary electrons.
            obj.AddToHistory(['.IonizElectronEnergySpread "', num2str(dValue, '%.15g'), '"']);
            obj.ionizelectronenergyspread = dValue;
        end
        function IonizIonMass(obj, dValue)
            % This method sets the mass of the ions created via ionization.
            obj.AddToHistory(['.IonizIonMass "', num2str(dValue, '%.15g'), '"']);
            obj.ionizionmass = dValue;
        end
        function IonizPressure(obj, dValue)
            % This method sets the gas pressure used to calculate the ionization collision frequency.
            obj.AddToHistory(['.IonizPressure "', num2str(dValue, '%.15g'), '"']);
            obj.ionizpressure = dValue;
        end
        function IonizTemperature(obj, dValue)
            % This method sets the ion temperature of the ions created via ionization.
            obj.AddToHistory(['.IonizTemperature "', num2str(dValue, '%.15g'), '"']);
            obj.ioniztemperature = dValue;
        end
        function IonizIsActive(obj, bFlag)
            % With this method, the ionization settings can be enalbed or disabled for the specific material.
            obj.AddToHistory(['.IonizIsActive "', num2str(bFlag, '%.15g'), '"']);
            obj.ionizisactive = bFlag;
        end
        %% Thermal Material Properties
        function ThermalType(obj, key)
            % (*) property shared among all available material sets
            % Allows to set the thermal material type:
            % : 'PTC'
            %   'Normal'
            %   'Anisotropic'
            obj.AddToHistory(['.ThermalType "', num2str(key, '%.15g'), '"']);
            obj.thermaltype = key;
        end
        function PTC(obj)
            % Perfect Thermal Conductor - this is the thermal equivalent to PEC. Temperature- and Heat-sources can be assigned to PTC material surfaces.
            % Normal
            % Isotropic material with a homogeneous material distribution
            % Anisotropic
            % Anisotropic material with a homogeneous material distribution
            obj.AddToHistory(['.PTC']);
        end
        function ThermalConductivity(obj, dValue)
            % (*) property shared among all available material sets
            % Defines the thermal conductivity of a material. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal thermal conductivity tensor can be set with the respective methods.
            obj.AddToHistory(['.ThermalConductivity "', num2str(dValue, '%.15g'), '"']);
            obj.thermalconductivity = dValue;
        end
        function ThermalConductivityX(obj, dValue)
            % (*) property shared among all available material sets
            % Defines the thermal conductivity of a material. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal thermal conductivity tensor can be set with the respective methods.
            obj.AddToHistory(['.ThermalConductivityX "', num2str(dValue, '%.15g'), '"']);
            obj.thermalconductivityx = dValue;
        end
        function ThermalConductivityY(obj, dValue)
            % (*) property shared among all available material sets
            % Defines the thermal conductivity of a material. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal thermal conductivity tensor can be set with the respective methods.
            obj.AddToHistory(['.ThermalConductivityY "', num2str(dValue, '%.15g'), '"']);
            obj.thermalconductivityy = dValue;
        end
        function ThermalConductivityZ(obj, dValue)
            % (*) property shared among all available material sets
            % Defines the thermal conductivity of a material. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal thermal conductivity tensor can be set with the respective methods.
            obj.AddToHistory(['.ThermalConductivityZ "', num2str(dValue, '%.15g'), '"']);
            obj.thermalconductivityz = dValue;
        end
        function HeatCapacity(obj, dValue)
            % (*) property shared among all available material sets
            % This parameter defines the specific heat capacity in [kJ / (K kg)]. This setting is relevant only for transient thermal simulations.
            obj.AddToHistory(['.HeatCapacity "', num2str(dValue, '%.15g'), '"']);
            obj.heatcapacity = dValue;
        end
        function BloodFlow(obj, dValue)
            % (*) property shared among all available material sets
            % The Bloodflow coefficient is a parameter of the bioheat equation. It determines the influence of blood at a certain temperature inside the tissue volume V. The reference temperature for the bloodflow (usually: 37 C) can be defined in the thermal solver specials dialog boxes of the stationary and the transient solver (ThermalSolver.BloodTemperature or ThermalTDSolver.BloodTemperature).
            obj.AddToHistory(['.BloodFlow "', num2str(dValue, '%.15g'), '"']);
            obj.bloodflow = dValue;
        end
        function MetabolicRate(obj, dValue)
            % (*) property shared among all available material sets
            % The Basal metabolic rate is a parameter of the bioheat equation. It describes the amount of heat  which is produced by tissue per volume V.
            obj.AddToHistory(['.MetabolicRate "', num2str(dValue, '%.15g'), '"']);
            obj.metabolicrate = dValue;
        end
        function VoxelConvection(obj, dValue)
            % (*) property shared among all available material sets
            % This parameter allows to consider convection processes on voxel models. In principle, a convection coefficient is prescribed. Typically this parameter is used with a material describing skin. For coarse voxel models it is advisable to use fat in addition. Only voxel-surfaces which are between the voxel material and the background material are taken into account.
            obj.AddToHistory(['.VoxelConvection "', num2str(dValue, '%.15g'), '"']);
            obj.voxelconvection = dValue;
        end
        function DynamicViscosity(obj, dValue)
            % (*) property shared among all available material sets
            % This setting is relevant only for background material in a CHT simulation. The parameter dValue sets the dynamic viscosity of the background fluid in [Pa s]. Please not that this value is not taken into account by default, but only in a CHT simulation if thermal radiation if turned on (CHTSolver.Radiation). Only solids with a strictly positive emissivity value can radiate.
            obj.AddToHistory(['.DynamicViscosity "', num2str(dValue, '%.15g'), '"']);
            obj.dynamicviscosity = dValue;
        end
        function Emissivity(obj, dValue)
            % (*) property shared among all available material sets
            % The parameter dValue sets the material emissivity. Please not that this value is not taken into account by default, but only in a CHT simulation if thermal radiation if turned on (CHTSolver.Radiation). Only solids with a strictly positive emissivity value can radiate.
            obj.AddToHistory(['.Emissivity "', num2str(dValue, '%.15g'), '"']);
            obj.emissivity = dValue;
        end
        function ResetNLThermalCond(obj)
            % (*) property shared among all available material sets
            % Delete the nonlinear thermal conductivity curve.
            obj.AddToHistory(['.ResetNLThermalCond']);
        end
        function AddNLThermalCond(obj, dTemperature, dValue)
            % (*) property shared among all available material sets
            % Adds a new data point for the dependence of isotropic thermal conductivity on temperature. Parameter dTemperature must be specified in the temperature units selected in MaterialUnit "Temperature" command. If no temperature material unit has been selected, the current user unit is applied. If anisotropic thermal type has been selected, all three components of thermal conductivity are set to dValue.
            obj.AddToHistory(['.AddNLThermalCond "', num2str(dTemperature, '%.15g'), '", '...
                                                '"', num2str(dValue, '%.15g'), '"']);
            obj.addnlthermalcond.dTemperature = dTemperature;
            obj.addnlthermalcond.dValue = dValue;
        end
        function AddNLThermalCondAniso(obj, dTemperature, dValueX, dValueY, dValueZ)
            % (*) property shared among all available material sets
            % Adds a new data point for the dependence of anisotropic thermal conductivity on temperature. Parameter dTemperature must be specified in the temperature units selected in MaterialUnit "Temperature" command. If no temperature material unit has been selected, the current user unit is applied. If normal thermal type has been selected, thermal conductivity is set to dValueX.
            obj.AddToHistory(['.AddNLThermalCondAniso "', num2str(dTemperature, '%.15g'), '", '...
                                                     '"', num2str(dValueX, '%.15g'), '", '...
                                                     '"', num2str(dValueY, '%.15g'), '", '...
                                                     '"', num2str(dValueZ, '%.15g'), '"']);
            obj.addnlthermalcondaniso.dTemperature = dTemperature;
            obj.addnlthermalcondaniso.dValueX = dValueX;
            obj.addnlthermalcondaniso.dValueY = dValueY;
            obj.addnlthermalcondaniso.dValueZ = dValueZ;
        end
        function ResetNLHeatCap(obj)
            % (*) property shared among all available material sets
            % Delete the nonlinear specific heat capacity curve.
            obj.AddToHistory(['.ResetNLHeatCap']);
        end
        function AddNLHeatCap(obj, dTemperature, dValue)
            % (*) property shared among all available material sets
            % Adds a new data point for the dependence of specific heat capacity on temperature. Parameter dTemperature must be specified in the temperature units selected in MaterialUnit "Temperature" command. If no temperature material unit has been selected, the current user unit is applied.
            obj.AddToHistory(['.AddNLHeatCap "', num2str(dTemperature, '%.15g'), '", '...
                                            '"', num2str(dValue, '%.15g'), '"']);
            obj.addnlheatcap.dTemperature = dTemperature;
            obj.addnlheatcap.dValue = dValue;
        end
        function ResetNLBloodFlow(obj)
            % (*) property shared among all available material sets
            % Delete the nonlinear blood flow coefficient curve.
            obj.AddToHistory(['.ResetNLBloodFlow']);
        end
        function SetNLBloodFlowMinTemperature(obj, dTemperature)
            % (*) property shared among all available material sets
            % Specifies the minimal temperature value, starting from which the blood flow coefficient gets nonlinear. Parameter dTemperature must be specified in the temperature units selected in MaterialUnit "Temperature" command. If no temperature material unit has been selected, the current user unit is applied.
            obj.AddToHistory(['.SetNLBloodFlowMinTemperature "', num2str(dTemperature, '%.15g'), '"']);
            obj.setnlbloodflowmintemperature = dTemperature;
        end
        function SetNLBloodFlowBasalValue(obj, dValue)
            % (*) property shared among all available material sets
            % Specifies the value of the nonlinear blood flow coefficient at minimal temperature. This value is normally equal to that specified in the BloodFlow command.
            obj.AddToHistory(['.SetNLBloodFlowBasalValue "', num2str(dValue, '%.15g'), '"']);
            obj.setnlbloodflowbasalvalue = dValue;
        end
        function SetNLBloodFlowLocalVasodilationParam(obj, dValue)
            % (*) property shared among all available material sets
            % Specifies the local vasodilation parameter for the nonlinear blood flow coefficient. The typical value is 1.6.
            obj.AddToHistory(['.SetNLBloodFlowLocalVasodilationParam "', num2str(dValue, '%.15g'), '"']);
            obj.setnlbloodflowlocalvasodilationparam = dValue;
        end
        function SetNLBloodFlowMaxMultiplier(obj, dValue)
            % (*) property shared among all available material sets
            % Specifies the ratio between the maximal and minimal blood flow coefficients. After the curve has reached the maximal blood flow value, it is considered constant for higher temperatures.
            obj.AddToHistory(['.SetNLBloodFlowMaxMultiplier "', num2str(dValue, '%.15g'), '"']);
            obj.setnlbloodflowmaxmultiplier = dValue;
        end
        %% Mechanics Material Properties
        function MechanicsType(obj, key)
            % (*) property shared among all available material sets
            % This list allows to select if the material should be used with isotropic properties for the simulation.
            % : 'Unused'
            %   'Isotropic'
            obj.AddToHistory(['.MechanicsType "', num2str(key, '%.15g'), '"']);
            obj.mechanicstype = key;
        end
        function YoungsModulus(obj, dValue)
            % (*) property shared among all available material sets
            % This parameter defines the stiffness of an isotropic elastic material. It is normally measured in GPa, or kN/mm2. The typical values vary between 0.01 GPa (rubber) and over 1000 GPa (diamond). It is important to know the value of this material parameter very well, since it has a large influence on the accuracy of the solution.
            obj.AddToHistory(['.YoungsModulus "', num2str(dValue, '%.15g'), '"']);
            obj.youngsmodulus = dValue;
        end
        function PoissonsRatio(obj, dValue)
            % (*) property shared among all available material sets
            % This parameter defines the scale of the transverse contraction of a longitudinally stretched body. This parameter can vary between -1 and 0.5, whereas most of the materials are characterized by a positive Poisson's ratio.
            obj.AddToHistory(['.PoissonsRatio "', num2str(dValue, '%.15g'), '"']);
            obj.poissonsratio = dValue;
        end
        function ThermalExpansionRate(obj, dValue)
            % (*) property shared among all available material sets
            % The expansion coefficient is the strain of a body, if its temperature changes by 1 K. This value is utilized to compute strain induced by an external temperature field.
            obj.AddToHistory(['.ThermalExpansionRate "', num2str(dValue, '%.15g'), '"']);
            obj.thermalexpansionrate = dValue;
        end
        function ResetTempDepYoungsModulus(obj)
            % (*) property shared among all available material sets
            % Delete the temperature dependent Young's modulus curve.
            obj.AddToHistory(['.ResetTempDepYoungsModulus']);
        end
        function AddTempDepYoungsModulus(obj, dTemperature, dValue)
            % (*) property shared among all available material sets
            % Adds a new data point for the dependence of Young's modulus on temperature. Parameter dTemperature must be specified in Kelvin.
            obj.AddToHistory(['.AddTempDepYoungsModulus "', num2str(dTemperature, '%.15g'), '", '...
                                                       '"', num2str(dValue, '%.15g'), '"']);
            obj.addtempdepyoungsmodulus.dTemperature = dTemperature;
            obj.addtempdepyoungsmodulus.dValue = dValue;
        end
        %% Flow Resistance Material Properties
        % Please note that flow resistance material properties are considered only by the conjugated heat transfer (CHT) solver. Depending on the shape (solid or sheet) to which the material is assigned, only the respective material properties will be taken into account (solid properties or sheet properties), the other will be ignored for the corresponding shape.
        function FlowResPressureLossTypeU(obj, key)
            % When a material with active flow resistance properties is assigned to a solid (volume), a local solid coordinate system (scs) should be attached to this solid in order to transform the material properties with the solid. With respect to this scs, the pressure loss can be prescribed for each of the main directions U, V, W. If no scs is given, the global coordinates (X, Y, Z) will be used instead. Three different pressure loss definition types are available:
            % Blocked         Perfect wall: no pressure flow through this shape. This is the default setting.
            % Coefficient     Direct input of the pressure loss coefficient.
            % Curve           User defined specification of flow rate and pressure value pairs as a flow resistance curve.
            % : 'Blocked'
            %   'Coefficient'
            %   'Curve'
            obj.AddToHistory(['.FlowResPressureLossTypeU "', num2str(key, '%.15g'), '"']);
            obj.flowrespressurelosstypeu = key;
        end
        function FlowResPressureLossTypeV(obj, key)
            % When a material with active flow resistance properties is assigned to a solid (volume), a local solid coordinate system (scs) should be attached to this solid in order to transform the material properties with the solid. With respect to this scs, the pressure loss can be prescribed for each of the main directions U, V, W. If no scs is given, the global coordinates (X, Y, Z) will be used instead. Three different pressure loss definition types are available:
            % Blocked         Perfect wall: no pressure flow through this shape. This is the default setting.
            % Coefficient     Direct input of the pressure loss coefficient.
            % Curve           User defined specification of flow rate and pressure value pairs as a flow resistance curve.
            % : 'Blocked'
            %   'Coefficient'
            %   'Curve'
            obj.AddToHistory(['.FlowResPressureLossTypeV "', num2str(key, '%.15g'), '"']);
            obj.flowrespressurelosstypev = key;
        end
        function FlowResPressureLossTypeW(obj, key)
            % When a material with active flow resistance properties is assigned to a solid (volume), a local solid coordinate system (scs) should be attached to this solid in order to transform the material properties with the solid. With respect to this scs, the pressure loss can be prescribed for each of the main directions U, V, W. If no scs is given, the global coordinates (X, Y, Z) will be used instead. Three different pressure loss definition types are available:
            % Blocked         Perfect wall: no pressure flow through this shape. This is the default setting.
            % Coefficient     Direct input of the pressure loss coefficient.
            % Curve           User defined specification of flow rate and pressure value pairs as a flow resistance curve.
            % : 'Blocked'
            %   'Coefficient'
            %   'Curve'
            obj.AddToHistory(['.FlowResPressureLossTypeW "', num2str(key, '%.15g'), '"']);
            obj.flowrespressurelosstypew = key;
        end
        function FlowResLossCoefficientU(obj, dValue)
            % This value defines the pressure loss coefficient for the specified direction and is considered only if the corresponding pressure loss type is "Coefficient". Otherwise it is ignored. A non-negative number is expected. The default value is 0.
            obj.AddToHistory(['.FlowResLossCoefficientU "', num2str(dValue, '%.15g'), '"']);
            obj.flowreslosscoefficientu = dValue;
        end
        function FlowResLossCoefficientV(obj, dValue)
            % This value defines the pressure loss coefficient for the specified direction and is considered only if the corresponding pressure loss type is "Coefficient". Otherwise it is ignored. A non-negative number is expected. The default value is 0.
            obj.AddToHistory(['.FlowResLossCoefficientV "', num2str(dValue, '%.15g'), '"']);
            obj.flowreslosscoefficientv = dValue;
        end
        function FlowResLossCoefficientW(obj, dValue)
            % This value defines the pressure loss coefficient for the specified direction and is considered only if the corresponding pressure loss type is "Coefficient". Otherwise it is ignored. A non-negative number is expected. The default value is 0.
            obj.AddToHistory(['.FlowResLossCoefficientW "', num2str(dValue, '%.15g'), '"']);
            obj.flowreslosscoefficientw = dValue;
        end
        function FlowResPressureLossTypeSheet(obj, key)
            % For thin sheets, the pressure loss can be described by using one of the following types:
            % Blocked         Perfect wall: no pressure flow through this shape. This is the default setting.
            % Coefficient     Direct input of the pressure loss coefficient.
            % Curve           User defined specification of flow rate and pressure value pairs as a flow resistance curve.
            % Perforation     Specification of an equidistant distribution of holes in the sheet.
            % FreeAreaRatio   Specification of the ratio "area covered by holes" / "total area".
            % : 'Blocked'
            %   'Coefficient'
            %   'Curve'
            %   'Perforation'
            %   'FreeAreaRatio'
            obj.AddToHistory(['.FlowResPressureLossTypeSheet "', num2str(key, '%.15g'), '"']);
            obj.flowrespressurelosstypesheet = key;
        end
        function FlowResLossCoefficientSheet(obj, dValue)
            % This value defines the pressure loss coefficient and is considered only if the FlowResPressureLossTypeSheet is set to "Coefficient". Otherwise it is ignored. A non-negative number is expected. The default value is 0.
            obj.AddToHistory(['.FlowResLossCoefficientSheet "', num2str(dValue, '%.15g'), '"']);
            obj.flowreslosscoefficientsheet = dValue;
        end
        function FlowResFreeAreaRatio(obj, dValue)
            % This value defines the ratio of the area which is covered by holes and the total area of the sheet. It is considered only if the FlowResPressureLossTypeSheet is set to "FreeAreaRatio". Otherwise it is ignored. A positive number between 0 and 1 is expected. If this value is unset, the sheet is treated like a wall, i.e. the flow is blocked.
            obj.AddToHistory(['.FlowResFreeAreaRatio "', num2str(dValue, '%.15g'), '"']);
            obj.flowresfreearearatio = dValue;
        end
        function FlowResShapeType(obj, key)
            % These settings are taken into account only when the FlowResPressureLossTypeSheet is set to "Perforation". With FlowResShapeType the shape of the holes in the surface can be prescribed. An equidistant distribution of equal sized shapes is assumed. The following shape types are supported:.
            % Hexagon     Size is the side length of the regular hexagon.
            % Circle      Size is the diameter of the circle.
            % Square      Size is the side length of the square.
            % key: 'Hexagon'
            %      'Circle'
            %      'Square'
            obj.AddToHistory(['.FlowResShapeType "', num2str(key, '%.15g'), '"']);
            obj.flowresshapetype = key;
        end
        function FlowResShapeSize(obj, Size)
            % These settings are taken into account only when the FlowResPressureLossTypeSheet is set to "Perforation". With FlowResShapeType the shape of the holes in the surface can be prescribed. An equidistant distribution of equal sized shapes is assumed. The following shape types are supported:.
            % Hexagon     Size is the side length of the regular hexagon.
            % Circle      Size is the diameter of the circle.
            % Square      Size is the side length of the square.
            obj.AddToHistory(['.FlowResShapeSize "', num2str(Size, '%.15g'), '"']);
            obj.flowresshapesize = Size;
        end
        function FlowResShapeUPitch(obj, UPitch)
            % These settings are taken into account only when the FlowResPressureLossTypeSheet is set to "Perforation". With FlowResShapeType the shape of the holes in the surface can be prescribed. An equidistant distribution of equal sized shapes is assumed. The following shape types are supported:.
            % Hexagon     Size is the side length of the regular hexagon.
            % Circle      Size is the diameter of the circle.
            % Square      Size is the side length of the square.
            obj.AddToHistory(['.FlowResShapeUPitch "', num2str(UPitch, '%.15g'), '"']);
            obj.flowresshapeupitch = UPitch;
        end
        function FlowResShapeVPitch(obj, VPitch)
            % These settings are taken into account only when the FlowResPressureLossTypeSheet is set to "Perforation". With FlowResShapeType the shape of the holes in the surface can be prescribed. An equidistant distribution of equal sized shapes is assumed. The following shape types are supported:.
            % Hexagon     Size is the side length of the regular hexagon.
            % Circle      Size is the diameter of the circle.
            % Square      Size is the side length of the square.
            % The size of the shape (side length or diameter according to the table above) is prescribed with a positive number for FlowResShapeSize. The distance of the center points of the holes in an imaginary U-V coordinate system on the surface is defined by two positive values UPitch and VPitch via FlowResShapeUPitch and FlowResShapeVPitch.
            obj.AddToHistory(['.FlowResShapeVPitch "', num2str(VPitch, '%.15g'), '"']);
            obj.flowresshapevpitch = VPitch;
        end
        %% Queries
        function long = GetNumberOfMaterials(obj)
            % Returns the number of materials.
            long = obj.hMaterial.invoke('GetNumberOfMaterials');
        end
        function string = GetNameOfMaterialFromIndex(obj, index)
            % Returns the material name for the material specified by the zero-based index index < .GetNumberOfMaterials - 1.
            string = obj.hMaterial.invoke('GetNameOfMaterialFromIndex', index);
            obj.getnameofmaterialfromindex = index;
        end
        function bool = IsBackgroundMaterial(obj, name)
            % Returns True if this is the background material. Typically the name is air_0;
            bool = obj.hMaterial.invoke('IsBackgroundMaterial', name);
            obj.isbackgroundmaterial = name;
        end
        function string = GetTypeOfBackgroundMaterial(obj)
            % Returns the material type. Valid types are: "PEC", "Normal", "Anisotropic", "Lossy Metal", "Corrugated wall", "Ohmic sheet", "Tensor formula", "Nonlinear".
            string = obj.hMaterial.invoke('GetTypeOfBackgroundMaterial');
        end
        function string = GetTypeOfMaterial(obj, name)
            % Returns the material type. Valid types are: "PEC", "Normal", "Anisotropic", "Lossy Metal", "Corrugated wall", "Ohmic sheet", "Tensor formula", "Nonlinear".
            string = obj.hMaterial.invoke('GetTypeOfMaterial', name);
            obj.gettypeofmaterial = name;
        end
        function [red, green, blue] = GetColour(obj, name)
            % Returns the current color values of the material named name in the parameters red, green and blue. The color values vary between 0 and 1.
            functionString = [...
                'Dim red As Double, green As Double, blue As Double', newline, ...
                'Material.GetColour(', name, ', red, green, blue)', newline, ...
            ];
            returnvalues = {'red', 'green', 'blue'};
            [red, green, blue] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            red = str2double(red);
            green = str2double(green);
            blue = str2double(blue);
        end
        function [EpsX, EpsY, EpsZ] = GetEpsilon(obj, name)
            % Returns the specific material parameter for the material specified by name in the respective double variables.
            functionString = [...
                'Dim EpsX As Double, EpsY As Double, EpsZ As Double', newline, ...
                'Material.GetEpsilon(', name, ', EpsX, EpsY, EpsZ)', newline, ...
            ];
            returnvalues = {'EpsX', 'EpsY', 'EpsZ'};
            [EpsX, EpsY, EpsZ] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            EpsX = str2double(EpsX);
            EpsY = str2double(EpsY);
            EpsZ = str2double(EpsZ);
        end
        function [MuX, MuY, MuZ] = GetMu(obj, name)
            % Returns the specific material parameter for the material specified by name in the respective double variables.
            functionString = [...
                'Dim MuX As Double, MuY As Double, MuZ As Double', newline, ...
                'Material.GetMu(', name, ', MuX, MuY, MuZ)', newline, ...
            ];
            returnvalues = {'MuX', 'MuY', 'MuZ'};
            [MuX, MuY, MuZ] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            MuX = str2double(MuX);
            MuY = str2double(MuY);
            MuZ = str2double(MuZ);
        end
        function [SigmaX, SigmaY, SigmaZ] = GetSigma(obj, name)
            % Returns the specific material parameter for the material specified by name in the respective double variables.
            functionString = [...
                'Dim SigmaX As Double, SigmaY As Double, SigmaZ As Double', newline, ...
                'Material.GetSigma(', name, ', SigmaX, SigmaY, SigmaZ)', newline, ...
            ];
            returnvalues = {'SigmaX', 'SigmaY', 'SigmaZ'};
            [SigmaX, SigmaY, SigmaZ] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            SigmaX = str2double(SigmaX);
            SigmaY = str2double(SigmaY);
            SigmaZ = str2double(SigmaZ);
        end
        function [SigmaMX, SigmaMY, SigmaMZ] = GetSigmaM(obj, name)
            % Returns the specific material parameter for the material specified by name in the respective double variables.
            functionString = [...
                'Dim SigmaMX As Double, SigmaMY As Double, SigmaMZ As Double', newline, ...
                'Material.GetSigmaM(', name, ', SigmaMX, SigmaMY, SigmaMZ)', newline, ...
            ];
            returnvalues = {'SigmaMX', 'SigmaMY', 'SigmaMZ'};
            [SigmaMX, SigmaMY, SigmaMZ] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            SigmaMX = str2double(SigmaMX);
            SigmaMY = str2double(SigmaMY);
            SigmaMZ = str2double(SigmaMZ);
        end
        function [Rho] = GetRho(obj, name)
            % (*) property shared among all available material sets
            % Returns the specific material parameter for the material specified by name in the respective double variables.
            functionString = [...
                'Dim Rho As Double', newline, ...
                'Material.GetRho(', name, ', Rho)', newline, ...
            ];
            returnvalues = {'Rho'};
            [Rho] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            Rho = str2double(Rho);
        end
        function [bool, depth, gapwidth, toothwidth] = GetCorrugation(obj, name)
            % Returns the specific material parameter for the material specified by name in the respective double variables.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim depth As Double, gapwidth As Double, toothwidth As Double', newline, ...
                'bool = Material.GetCorrugation(', name, ', depth, gapwidth, toothwidth)', newline, ...
            ];
            returnvalues = {'bool', 'depth', 'gapwidth', 'toothwidth'};
            [bool, depth, gapwidth, toothwidth] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            depth = str2double(depth);
            gapwidth = str2double(gapwidth);
            toothwidth = str2double(toothwidth);
        end
        function [bool, resistance, reactance] = GetOhmicSheetImpedance(obj, name)
            % Returns the specific material parameter for the material specified by name in the respective double variables.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim resistance As Double, reactance As Double', newline, ...
                'bool = Material.GetOhmicSheetImpedance(', name, ', resistance, reactance)', newline, ...
            ];
            returnvalues = {'bool', 'resistance', 'reactance'};
            [bool, resistance, reactance] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            resistance = str2double(resistance);
            reactance = str2double(reactance);
        end
        function [viscosity] = GetDynamicViscosity(obj, name)
            % Returns the dynamic viscosity in [Pa s] which is set for the material specified by name. Please note that this value is taken into account only for the background material in a CHT simulation.
            functionString = [...
                'Dim viscosity As Double', newline, ...
                'Material.GetDynamicViscosity(', name, ', viscosity)', newline, ...
            ];
            returnvalues = {'viscosity'};
            [viscosity] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            viscosity = str2double(viscosity);
        end
        function [emissivity] = GetEmissivity(obj, name)
            % Returns the material emissivity which is set for the material specified by name. Please note that this value is not taken into account by default, but only in a CHT simulation if thermal radiation if turned on (CHTSolver.Radiation). Only solids with a strictly positive emissivity value can radiate.
            functionString = [...
                'Dim emissivity As Double', newline, ...
                'Material.GetEmissivity(', name, ', emissivity)', newline, ...
            ];
            returnvalues = {'emissivity'};
            [emissivity] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            emissivity = str2double(emissivity);
        end
        function [condX, condY, condZ] = GetThermalConductivity(obj, name)
            % Returns the thermal conductivity of the material specified by name. In case of diagonal anisotropic material, the parameters for the specific components of the diagonal thermal conductivity tensor can (set by ThermalConductivityX, ThermalConductivityY, ThermalConductivityZ, respectively) will be returned in condX, condY, condZ. Otherwise, each will contain the number specified by ThermalConductivity.
            functionString = [...
                'Dim condX As Double, condY As Double, condZ As Double', newline, ...
                'Material.GetThermalConductivity(', name, ', condX, condY, condZ)', newline, ...
            ];
            returnvalues = {'condX', 'condY', 'condZ'};
            [condX, condY, condZ] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            condX = str2double(condX);
            condY = str2double(condY);
            condZ = str2double(condZ);
        end
        function [heatcapacity] = GetHeatCapacity(obj, name)
            % Returns the specific heat capacity in [kJ / (K kg)] of the material specified by name. Please note that this setting is taken into account only for transient thermal simulations.
            functionString = [...
                'Dim heatcapacity As Double', newline, ...
                'Material.GetHeatCapacity(', name, ', heatcapacity)', newline, ...
            ];
            returnvalues = {'heatcapacity'};
            [heatcapacity] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            heatcapacity = str2double(heatcapacity);
        end
        function [bloodflow] = GetBloodFlow(obj, name)
            % Returns the blood flow coefficient of the material specified by name. Please note that this setting is taken into account only for thermal simulations.
            functionString = [...
                'Dim bloodflow As Double', newline, ...
                'Material.GetBloodFlow(', name, ', bloodflow)', newline, ...
            ];
            returnvalues = {'bloodflow'};
            [bloodflow] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bloodflow = str2double(bloodflow);
        end
        function [rate] = GetMetabolicRate(obj, name)
            % Returns the Basal metabolic rate of the material specified by name. Please note that this setting is taken into account only for thermal simulations.
            functionString = [...
                'Dim rate As Double', newline, ...
                'Material.GetMetabolicRate(', name, ', rate)', newline, ...
            ];
            returnvalues = {'rate'};
            [rate] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            rate = str2double(rate);
        end
        function [convection] = GetVoxelConvection(obj, name)
            % Returns the voxel convection coefficient which is set for the material specified by name. This parameter allows to consider convection processes on voxel models. Please note that this setting is taken into account only for thermal simulations and only on voxel-surfaces which are between the voxel material and the background material.
            functionString = [...
                'Dim convection As Double', newline, ...
                'Material.GetVoxelConvection(', name, ', convection)', newline, ...
            ];
            returnvalues = {'convection'};
            [convection] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            convection = str2double(convection);
        end
        function bool = Exists(obj, name)
            % Returns True if the material specified by name exists.
            bool = obj.hMaterial.invoke('Exists', name);
            obj.exists = name;
        end
        %% Notes
        % (*) The value will be shared among all available material sets and problem types.
        %% Undocumented functions.
        % Found in history list when background material is changed.
        function ChangeBackgroundMaterial(obj)
            obj.AddToHistory(['.ChangeBackgroundMaterial']); 
            
            % Prepend With and append End With 
            obj.history = ['With Material', newline, obj.history, 'End With']; 
            obj.project.AddToHistory(['define background'], obj.history); 
            obj.history = []; 
        end
        % Found in history list when defining a new material.
        function FrqType(obj, frqtype)
            % frqtype: 'all'
            obj.AddToHistory(['.FrqType "', num2str(frqtype, '%.15g'), '"']);
            obj.frqtype = frqtype;
        end
        % Found in history list when defining a new material.
        function ErrorLimitNthModelFitEps(obj, errorlimit)
            obj.AddToHistory(['.ErrorLimitNthModelFitEps "', num2str(errorlimit, '%.15g'), '"']);
            obj.errorlimitnthmodelfiteps = errorlimit;
        end
        % Found in history list when defining a new material.
        function ErrorLimitNthModelFitMu(obj, errorlimit)
            obj.AddToHistory(['.ErrorLimitNthModelFitMu "', num2str(errorlimit, '%.15g'), '"']);
            obj.errorlimitnthmodelfitmu = errorlimit;
        end
        % Found in history list when defining a new material.
        function NonlinearMeasurementError(obj, error)
            obj.AddToHistory(['.NonlinearMeasurementError "', num2str(error, '%.15g'), '"']);
            obj.nonlinearmeasurementerror = error;
        end
        %% Utility Functions.
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
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hMaterial
        history

        name
        folder
        type
        materialunit
        delete
        rename
        newfolder
        deletefolder
        renamefolder
        colour
        transparency
        wireframe
        reflection
        allowoutline
        transparentoutline
        epsilon
        epsilonx
        epsilony
        epsilonz
        mu
        mux
        muy
        muz
        rho
        addcoatedmaterial
        referencecoordsystem
        coordsystemtype
        corrugation
        ohmicsheetimpedance
        ohmicsheetfreq
        settabulatedsurfaceimpedancemodel
        addtabulatedsurfaceimpedancefittingvalue
        addtabulatedsurfaceimpedancevalue
        dispersivefittingschemetabsi
        maximalordernthmodelfittabsi
        useonlydatainsimfreqrangenthmodeltabsi
        errorlimitnthmodelfittabsi
        tabulatedcompactmodel
        settabulatedcompactmodelimpedance
        setsymmtabulatedcompactmodelimpedance
        addtabulatedcompactmodelitem
        addsymmtabulatedcompactmodelitem
        tabulatedcompactmodelanisotropic
        addanisotabulatedcompactmodelitem
        addanisosymmtabulatedcompactmodelitem
        maximalorderfittabulatedcompactmodel
        useonlydatainsimfreqrangetabulatedcompactmodel
        errorlimitfittabulatedcompactmodel
        lossymetalsiroughness
        sigma
        sigmax
        sigmay
        sigmaz
        setelparametricconductivity
        addjevalue
        addeltimedepcondvalue
        addeltimedepcondanisovalue
        loadeltimedepconductivity
        tand
        tandx
        tandy
        tandz
        tandgiven
        tandfreq
        tandmodel
        enableuserconsttandmodelordereps
        consttandmodelordereps
        sigmam
        sigmamx
        sigmamy
        sigmamz
        setmagparametricconductivity
        addmagtimedepcondvalue
        addmagtimedepcondanisovalue
        loadmagtimedepconductivity
        tandm
        tandmx
        tandmy
        tandmz
        tandmgiven
        tandmfreq
        tandmmodel
        enableuserconsttandmodelordermu
        consttandmodelordermu
        dispmodeleps
        dispmodelmu
        epsinfinity
        epsinfinityx
        epsinfinityy
        epsinfinityz
        dispcoeff0eps
        dispcoeff0epsx
        dispcoeff0epsy
        dispcoeff0epsz
        dispcoeff1eps
        dispcoeff1epsx
        dispcoeff1epsy
        dispcoeff1epsz
        dispcoeff2eps
        dispcoeff2epsx
        dispcoeff2epsy
        dispcoeff2epsz
        dispcoeff3eps
        dispcoeff3epsx
        dispcoeff3epsy
        dispcoeff3epsz
        dispcoeff4eps
        dispcoeff4epsx
        dispcoeff4epsy
        dispcoeff4epsz
        adddispepspole1storder
        adddispepspole1storderx
        adddispepspole1stordery
        adddispepspole1storderz
        adddispepspole2ndorder
        adddispepspole2ndorderx
        adddispepspole2ndordery
        adddispepspole2ndorderz
        adddispmupole1storder
        adddispmupole1storderx
        adddispmupole1stordery
        adddispmupole1storderz
        adddispmupole2ndorder
        adddispmupole2ndorderx
        adddispmupole2ndordery
        adddispmupole2ndorderz
        muinfinity
        muinfinityx
        muinfinityy
        muinfinityz
        dispcoeff0mu
        dispcoeff0mux
        dispcoeff0muy
        dispcoeff0muz
        dispcoeff1mu
        dispcoeff1mux
        dispcoeff1muy
        dispcoeff1muz
        dispcoeff2mu
        dispcoeff2mux
        dispcoeff2muy
        dispcoeff2muz
        dispcoeff3mu
        dispcoeff3mux
        dispcoeff3muy
        dispcoeff3muz
        dispcoeff4mu
        dispcoeff4mux
        dispcoeff4muy
        dispcoeff4muz
        usesisystem
        gyromufreq
        dispersivefittingformateps
        dispersivefittingformatmu
        adddispersionfittingvalueeps
        adddispersionfittingvaluemu
        adddispersionfittingvaluexyzeps
        adddispersionfittingvaluexyzmu
        dispersivefittingschemeeps
        dispersivefittingschememu
        maximalordernthmodelfiteps
        maximalordernthmodelfitmu
        useonlydatainsimfreqrangenthmodeleps
        useonlydatainsimfreqrangenthmodelmu
        usegeneraldispersioneps
        usegeneraldispersionmu
        tensorformulafor
        tensorformulareal
        tensorformulaimag
        tensoralignment
        tensoralignment2
        resetspatiallyvaryingmaterialparameter
        spatiallyvaryingmaterialmodel
        spatiallyvaryingmaterialmodelaniso
        addspatiallyvaryingmaterialparameter
        addspatiallyvaryingmaterialparameteraniso
        resetspacemapbasedmaterial
        spacemapbasedoperator
        spacemapbasedoperatoraniso
        addspacemapbasedmaterialstringparameter
        addspacemapbasedmaterialdoubleparameter
        addspacemapbasedmaterialstringparameteraniso
        addspacemapbasedmaterialdoubleparameteraniso
        convertmaterialfield
        setcoatingtypedefinition
        addtabulatedsurfaceimpedance
        addtabulatedreflectionfactor
        addtabulatedreflectiontransmissionfactor
        thickness
        addtemperaturedepeps
        addtemperaturedepmu
        addtemperaturedepsigma
        settemperaturedepsourcefield
        addhbvalue
        nlanisotropy
        nlastackingfactor
        nladirectionx
        nladirectiony
        nladirectionz
        particleproperty
        semodel
        semaxgenerations
        semaxsecondaries
        setsparam_t1
        setsparam_t2
        setsparam_t3
        setsparam_t4
        setsparam_sey
        setsparam_energy
        setsparam_s
        setsparam_pn
        setsparam_epsn
        serdparam_r
        serdparam_r1
        serdparam_r2
        serdparam_q
        serdparam_p1inf
        serdparam_energy
        sebsparam_sigma
        sebsparam_e1
        sebsparam_e2
        sebsparam_p1hat
        sebsparam_p1inf
        sebsparam_energy
        sebsparam_p
        sebsparam_w
        seplot1d
        sevaughan
        seimportsettings
        seimportdata
        particletransparencysettings
        particletransparencyimportdata
        setenergystepforseyplots
        specialdispparamforpic
        specialdispparamvisual
        ionizimportfile
        ionizimportdatapair
        ionizelectronenergyspread
        ionizionmass
        ionizpressure
        ioniztemperature
        ionizisactive
        thermaltype
        thermalconductivity
        thermalconductivityx
        thermalconductivityy
        thermalconductivityz
        heatcapacity
        bloodflow
        metabolicrate
        voxelconvection
        dynamicviscosity
        emissivity
        addnlthermalcond
        addnlthermalcondaniso
        addnlheatcap
        setnlbloodflowmintemperature
        setnlbloodflowbasalvalue
        setnlbloodflowlocalvasodilationparam
        setnlbloodflowmaxmultiplier
        mechanicstype
        youngsmodulus
        poissonsratio
        thermalexpansionrate
        addtempdepyoungsmodulus
        flowrespressurelosstypeu
        flowrespressurelosstypev
        flowrespressurelosstypew
        flowreslosscoefficientu
        flowreslosscoefficientv
        flowreslosscoefficientw
        flowrespressurelosstypesheet
        flowreslosscoefficientsheet
        flowresfreearearatio
        flowresshapetype
        flowresshapesize
        flowresshapeupitch
        flowresshapevpitch
        getnameofmaterialfromindex
        isbackgroundmaterial
        gettypeofmaterial
        exists
        frqtype
        errorlimitnthmodelfiteps
        errorlimitnthmodelfitmu
        nonlinearmeasurementerror
    end
end

%% Default Settings
% .Type('Normal');
% .Colour('0', '1', '1');
% .Wireframe('0');
% .Transparency('0');
% .Epsilon('1.0');
% .Mu('1.0');
% .Rho('0.0');
% .Sigma('0.0');
% .TanD('0.0');
% .TanDFreq('0.0');
% .TanDGiven('0');
% .TanDModel('ConstTanD');
% .SigmaM('0.0');
% .TanDM('0.0');
% .TanDMFreq('0.0');
% .TanDMGiven('0');
% .DispModelEps('None');
% .DispModelMu('None');
% .MuInfinity('1.0');
% .EpsInfinity('1.0');
% .DispCoeff1Eps('0.0');
% .DispCoeff2Eps('0.0');
% .DispCoeff3Eps('0.0');
% .DispCoeff4Eps('0.0');
% .DispCoeff1Mu('0.0');
% .DispCoeff2Mu('0.0');
% .DispCoeff3Mu('0.0');
% .DispCoeff4Mu('0.0');
% .AddDispEpsPole1stOrder('0.0', '0.0');
% .AddDispEpsPole2ndOrder('0.0', '0.0', '0.0', '0.0');
%  
%  
