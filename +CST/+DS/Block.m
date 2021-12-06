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
% Block types are listed right before Default Settings.

% Object referring to a block. Use this object to create or to manipulate a block.
classdef Block < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.DS.Project)
        % Only CST.DS.Project can create a Block object.
        function obj = Block(dsproject, hDSProject)
            obj.dsproject = dsproject;
            obj.hBlock = hDSProject.invoke('Block');
        end
    end
    %% CST Object functions.
    methods
        function Create(obj)
            % Creates a new block. Before a block's creation, its Type has to be specified. Some block types require additional properties to be set before the block creation (e. g. a file name). If block's the name has not been set, a default name for the specified block type will be used.
            obj.hBlock.invoke('Create');
        end
        function Delete(obj)
            % Deletes the currently selected block.
            obj.hBlock.invoke('Delete');
        end
        function bool = DoesExist(obj)
            % Checks if a block with the currently selected name already exists.
            bool = obj.hBlock.invoke('DoesExist');
        end
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.hBlock.invoke('Reset');
        end
        %% Identification
        function Name(obj, blockname)
            % Sets the name of a block before calling Create. Furthermore, this method can be used to select an existing block of your model prior of calling queries.
            obj.hBlock.invoke('Name', blockname);
        end
        %% Getter
        function str = GetTypeName(obj)
            % Returns the "type" name of a block. For example the type name of a resistor would be "resistor".
            str = obj.hBlock.invoke('GetTypeName');
        end
        function str = GetTypeShortName(obj)
            % Returns the short "type" name of a block. For example the short type name of a resistor would be "RES".
            str = obj.hBlock.invoke('GetTypeShortName');
        end
        function str = GetSpiceFilter(obj)
            % This method can only be applied to SPICE import blocks. It returns the SPICE dialect being applied to the block.  For possible return values see the description of the SetSpiceFilter command.
            str = obj.hBlock.invoke('GetSpiceFilter');
        end
        function str = GetPackage(obj)
            %  It returns the package name specified in the selected block. For possible return values see the description of the SetPackage command. If no package was specified the function returns an empty string.
            str = obj.hBlock.invoke('GetPackage');
        end
        function double = GetPackageLengthMM(obj)
            %  It returns the package length of the selected block in mm. If no package was specified the function returns zero.
            double = obj.hBlock.invoke('GetPackageLengthMM');
        end
        function double = GetPackageWidthMM(obj)
            %  It returns the package width of the selected block in mm. If no package was specified the function returns zero.
            double = obj.hBlock.invoke('GetPackageWidthMM');
        end
        function double = GetPackageHeightMM(obj)
            %  It returns the package height of the selected block in mm. If no package was specified the function returns zero.
            double = obj.hBlock.invoke('GetPackageHeightMM');
        end
        function str = GetReferenceName(obj)
            % Returns the name of block's reference block (or an empty string if the block has no reference block).
            str = obj.hBlock.invoke('GetReferenceName');
        end
        function GetNextUnusedName(obj, basename)
            % searches the model for the named blocks 'base name + index' and returns the block name with this base + first index that is not used.
            obj.hBlock.invoke('GetNextUnusedName', basename);
        end
        %% Setter
        function Type(obj, type)
            % Sets the type for a block. This setting must be made before calling Create. The type can not be modified after the creation. The list of block types contains all valid options.
            % Block types are listed right before Default Settings.
            obj.hBlock.invoke('Type', type);
        end
        function SetName(obj, blockname)
            % Modifies the name of an existing block.
            obj.hBlock.invoke('SetName', blockname);
        end
        function SetFile(obj, filename)
            % Sets the file for a block. This is only possible for block types that reference external data (file blocks) and for project blocks. In case of project blocks the specified file is copied into the project directory.
            obj.hBlock.invoke('SetFile', filename);
        end
        function SetGlobalUnitForProperty(obj, propertyname)
            % Sets the global unit for the specified property.
            obj.hBlock.invoke('SetGlobalUnitForProperty', propertyname);
        end
        function SetLocalUnitForProperty(obj, propertyname, unit)
            % Sets the given unit for the specified property, i.e. the property's value will not refer to the project's global unit any more but to this local unit.
            obj.hBlock.invoke('SetLocalUnitForProperty', propertyname, unit);
        end
        function SetLibraryModel(obj, model)
            % Sets the library model for a block. This is only possible for block types that support the device model library. The name is the tree path in the device model library which is also displayed in the "Model name" field of the block property page. See also ImportLibraryModel command if you want to import a new model.
            obj.hBlock.invoke('SetLibraryModel', model);
        end
        function SetRelativePath(obj, relative)
            % Specifies a relative file name. This is only possible for some types of blocks.
            obj.hBlock.invoke('SetRelativePath', relative);
        end
        function SetSimulationModel(obj, model, othersolverincaseoffailure)
            % Sets the simulation model for a block. This is only possible for some types of blocks. Set othersolverincaseoffailure if you don't want the simulation to stop if the selected solver is not supported for the current parameter set.
            % model may have the following settings:
            % "Standard"
            % Standard model
            % "Fast2D"
            % Fast 2D EM based model (only available for some microstrip and stripline blocks)
            % "2D"
            % Enhanced 2D EM based model (only available for microstrip and stripline blocks)
            % "3D"
            % 3D calculation performed by CST MICROWAVE STUDIO (only available for microstrip, stripline and waveguide blocks)
            % "Dispersive"
            % Dispersive model (only available for CS, PCBS and ideal transmissionline blocks)
            % "Nonlinear"
            % Nonlinear model based on state space interpolation (only available for EMS blocks with M-Statics solver option)
            obj.hBlock.invoke('SetSimulationModel', model, othersolverincaseoffailure);
        end
        function SetSolver(obj, solver)
            % Sets a solver for a block.
            obj.hBlock.invoke('SetSolver', solver);
        end
        function SetSpiceFilter(obj, type)
            % This method can only be applied to SPICE import blocks. It specifies the SPICE dialect being applied. Currently, the types "SPICE3", "PSPICE", "HSPICE", "AUTOMATIC" are supported. The latter is a combination of SPICE3f4 and a subset of PSPICE, where SPICE3f4 takes precedence over PSPICE, if conflicts occur.
            obj.hBlock.invoke('SetSpiceFilter', type);
        end
        function SetPackage(obj, type)
            % This method specifies the package of a block used during the assembly of complex structures in the "Assembly View". It can only be applied to blocks, which have the possibility to carry package information. These are for example circuit elements and Touchstone blocks. Please refer to table below to get an overview of the available packages. To unset a package please hand over an empty string or "None".
            % type may contain the following package strings:
            % Block Type
            % Available packages
            % "2 Pin Device"
            % "None","0201","0402","0504","0508","0603", "0612","0805","1005","1206","1209","1210","1218","1515","1808","1812","1825", "2010","2020","2211","2215","2221","2225","2512","2520","3030","3040","3333", "3520","3530","3540","3545","3640","4020","4040","4540","5040","5440","5550", "6560","7565","Melf-0102","Melf-0204","Melf-0207","SC-76","SC-79","SC-90", "SMA","SMB","SMC","SOD106","SOD110","SOD123F","SOD123W","SOD128","SOD131", "SOD132","SOD133","SOD323","SOD323F","SOD523","SOD80C","SOD87","SOD882","SOD882D")
            % "3 Pin Device"
            % "None","SC-101","SC-62","SC-70","SC-75","SOT1061", "SOT23","SOT323","SOT416","SOT663","SOT883","SOT89"
            % "4 Pin Device"
            % "None","SMDIP"
            % "8 Pin Device"
            % "None","SOT-28"
            obj.hBlock.invoke('SetPackage', type);
        end
        function SetReferenceBlock(obj, blockname)
            % Sets the reference block for a block. This is only possible for some types of blocks.
            obj.hBlock.invoke('SetReferenceBlock', blockname);
        end
        function SetAsDefaultReference(obj)
            % Makes a reference block the project's default reference block.
            obj.hBlock.invoke('SetAsDefaultReference');
        end
        function SetClonedBlock(obj, blockname)
            % Sets the cloned block for a clone block.
            obj.hBlock.invoke('SetClonedBlock', blockname);
        end
        function SetDeembedded(obj, deembed)
            % Sets the de-embedding property for a block, i.e. the inverse S-matrix will be considered for that block then.
            obj.hBlock.invoke('SetDeembedded', deembed);
        end
        function SetDefineProbes(obj, bFlag)
            % Activates probes on block ports for blocks that define probes.
            obj.hBlock.invoke('SetDefineProbes', bFlag);
        end
        function EnableSlaveCommands(obj, enable)
            % All blocks that are associated with a 3D CST STUDIO SUITE project offer access to the 3D related VBA commands via the block object: You can e.g. access the brick object of a CST MICROWAVE STUDIO block via Block.Brick. However, this mechanism requires that the corresponding project is opened when the block name is set. This can be disturbing, so if you know that you will not need any 3D related VBA command, you can call EnableSlaveCommands(false) before calling Name(), and then the project will not be opened, and the 3D VBA commands will not be available.
            obj.hBlock.invoke('EnableSlaveCommands', enable);
        end
        %% Iteration
        function int = StartBlockNameIteration(obj)
            % Resets the iterator for the blocks and returns the number of blocks.
            int = obj.hBlock.invoke('StartBlockNameIteration');
        end
        function name = GetNextBlockName(obj)
            % Returns the next block's name. Call StartBlockNameIteration before the first call of this method.
            name = obj.hBlock.invoke('GetNextBlockName');
        end
        function StartPropertyIteration(obj)
            % Resets the iterator for the properties of a block.
            obj.hBlock.invoke('StartPropertyIteration');
        end
        function [propertyname, type, value] = GetNextProperty(obj)
            % Returns the name, type and value of the next property. Call StartPropertyIteration before the first call of this method. An empty name is returned if the property iterator is positioned at the end.
            functionString = [...
                'Dim propertyname As String, var_type As String, value As String', newline, ...
                'Block.GetNextProperty(propertyname, var_type, value)', newline, ...
            ];
            returnvalues = {'propertyname', 'var_type', 'value'};
            [propertyname, type, value] = obj.dsproject.RunVBACode(functionString, returnvalues);
        end
        %% Positioning
        function FlipHorizontal(obj)
            % Horizontally flips a block. If this setting is made before calling Create, the flip is only stored. It will then be done in Create (before any rotation is applied).
            obj.hBlock.invoke('FlipHorizontal');
        end
        function FlipVertical(obj)
            % Vertically flips a block. If this setting is made before calling Create, the flip is only stored. It will then be done in Create (before any rotation is applied).
            obj.hBlock.invoke('FlipVertical');
        end
        function int = GetPinPositionX(obj, index)
            % Returns he horizontal position of a block pin specified by the given index. Index must be an integer between 0 and GetNumberOfPins()-1.
            int = obj.hBlock.invoke('GetPinPositionX', index);
        end
        function int = GetPinPositionY(obj, index)
            % Returns he vertical position of a block pin specified by the given index. Index must be an integer between 0 and GetNumberOfPins()-1.
            int = obj.hBlock.invoke('GetPinPositionY', index);
        end
        function int = GetPositionX(obj)
            % Returns the horizontal position of the center point of a block.
            int = obj.hBlock.invoke('GetPositionX');
        end
        function int = GetPositionY(obj)
            % Returns the vertical position of the center point of a block.
            int = obj.hBlock.invoke('GetPositionY');
        end
        function Move(obj, x, y)
            % Moves a block by the given offset. Note that the schematic size is given by 0 < x, y <100000. Use Position to specify a certain location. It is always ensured that the block is aligned with the grid, therefore the specified offset might get adjusted slightly. This setting must not be made before calling Create.
            obj.hBlock.invoke('Move', x, y);
        end
        function Position(obj, x, y)
            % Specifies the position of the block. This setting must be made before calling Create. Furthermore, it can be used to modify a block's position. Possible values are 0 < x, y <100000, i.e. (50000, 50000) is the center of the schematic. It is always ensured that the block is aligned with the grid, therefore the specified position might get adjusted slightly.
            obj.hBlock.invoke('Position', x, y);
        end
        function Rotate(obj, angle)
            % Rotates the block by the given angle in degrees around its center point. If this setting is made before calling Create, the angle is only stored. The rotation will then be done in Create (after any horizontal or vertical flip was applied).
            obj.hBlock.invoke('Rotate', angle);
        end
        %% Special Methods
        function Convert(obj)
            % For some file or project blocks only.
            % Converts a file block into a project block or vice versa. For conversion of a project block into a file block a file dialog opens, where you need to specify where the external file will be stored. The file(s) inside the project which were used by the original block will be deleted after conversion. In both cases, the file(s) used by the block will be copied from the old to the new location.
            obj.hBlock.invoke('Convert');
        end
        function str = ImportLibraryModel(obj, filename, path)
            % Imports a new model form a spice or touchstone file into the device model library. The imported model must be compatible with the current block. The path parameter can be used to import the device model to a specific path in the device model library, pass an empty string if the model should be imported into the device base path. If a library model with the same name and path is already present in the device model library it will be overwritten. Use the command LibraryModelExists to check the existence of a model before import. The return value is the tree path in the device model library which can be used together with the SetLibraryModel command.
            str = obj.hBlock.invoke('ImportLibraryModel', filename, path);
        end
        function bool = LibraryModelExists(obj, model)
            % Checks if a model exists in device model library. The name is the tree path in the device model library.
            bool = obj.hBlock.invoke('LibraryModelExists', model);
        end
        function bool = UpdateModel(obj)
            % Updates the model of block. Returns True if the block was updated.
            % Note: Currently used only for reloading IBIS-models.
            bool = obj.hBlock.invoke('UpdateModel');
        end
        %% IBIS
        function bool = SetIbisComponent(obj, component)
            % Sets the component of an IBIS reference block. The argument must match a name listed under the [Component] keyword in the block's IBIS file.
            % Returns True if no error occurred.
            bool = obj.hBlock.invoke('SetIbisComponent', component);
        end
        function bool = SetIbisPackage(obj, packageType, packageName)
            % Sets the package model of an IBIS reference block. The first argument must be one of 'None', 'Global', 'Pinwise', or 'Named'. If the latter is used, then a package model with the name given as second argument is sought. Otherwise the second argument is ignored.
            % Returns True if no error occurred.
            bool = obj.hBlock.invoke('SetIbisPackage', packageType, packageName);
        end
        function bool = SetIbisBuffer(obj, pin, invPin, models, invModels, modelParameter)
            % Sets the properties of an IBIS buffer block. The arguments are pin name, name of inverting pin (for differential buffers), a list of model names, a list of model names for the inverting pin and a parameter name for parameterized models.
            % The inverting pin name and the model parameter name may be empty strings. The pin name, inverting pin name (unless empty) and model names must match pin and model names, respectively, defined for the chosen IBIS component. Only pin-buffer combinations that are specified in the IBIS file are permitted. Differential buffers can only be set if a valid pair of differential pins is given.
            % The model parameter can be used to select models from the given model list in simulation control tasks like parameter sweeps.
            % Returns True if no error occurred.
            % An example for the use of this and other IBIS specific commands is provided in the examples section.
            bool = obj.hBlock.invoke('SetIbisBuffer', pin, invPin, models, invModels, modelParameter);
        end
        function bool = SetIbisCorner(obj, index, cornerParameter)
            % Sets the corner settings of an IBIS buffer block. The index can be 0 (typical), 1 (fast) or 2 (slow). The parameter can be used to parameterize the corner setting. If a non-empty string is passed, the parameter overrides the index.
            % Returns True if no error occurred.
            bool = obj.hBlock.invoke('SetIbisCorner', index, cornerParameter);
        end
        function SetIbisInternalPower(obj, internalPower)
            % Sets IBIS buffer block to simplified layout in order to use internal supplies with the voltages specified by the IBIS file ([Voltage Range] or [Pullup/Pulldown/POWER Clamp/GND Clamp Reference] keywords).
            obj.hBlock.invoke('SetIbisInternalPower', internalPower);
        end
        %% Interpolation
        function bool = CanSelectInterpolationMethod(obj)
            % Checks if the user can select between different interpolation methods for the given block. Currently, this is only possible for Touchstone blocks. Hence, the return value indicates, whether the set-method SetUseHigherOrderInterpolation()  and the get-method GetUseHigherOrderInterpolation() can be called.
            bool = obj.hBlock.invoke('CanSelectInterpolationMethod');
        end
        function CopyInterpolationDataToProject(obj)
            % Sets the block's interpolation data for all blocks of the same type that are contained in your model. This is only possible for some types of blocks.
            obj.hBlock.invoke('CopyInterpolationDataToProject');
        end
        function bool = GetUseHigherOrderInterpolation(obj)
            % The return value indicates whether higher-order interpolation is used for the S-Parameter data of the block or linear interpolation. The method can only be applied to blocks that able to switch between different interpolation methods. This can be queried by the method CanSelectInterpolationMethod().
            bool = obj.hBlock.invoke('GetUseHigherOrderInterpolation');
        end
        function SetInterpolation(obj, interpolate)
            % Switches on/off interpolation for a block. This is only possible for some types of blocks.
            obj.hBlock.invoke('SetInterpolation', interpolate);
        end
        function SetInterpolationDataForProperty(obj, propertyname, min, max, samples)
            % Sets the interval for a block's property inside that interpolation will be performed with a given number of samples. This is only possible for some types of blocks.
            obj.hBlock.invoke('SetInterpolationDataForProperty', propertyname, min, max, samples);
        end
        function SetUseHigherOrderInterpolation(obj, bFlag)
            % The flag specifies whether higher-order interpolation is to be used for the S-Parameter data of the block or linear interpolation. The method can only be applied to blocks that able to switch between different interpolation methods. This can be queried by the method CanSelectInterpolationMethod().
            obj.hBlock.invoke('SetUseHigherOrderInterpolation', bFlag);
        end
        %% Layout
        function int = FindPortsWithLabel(obj, labelname, portNames_strArray)
            % Finds the block ports with a given label. Since labels are not unique, there may exist more than one port for the given name. The number of found ports is returned.
            % (See Example)
            int = obj.hBlock.invoke('FindPortsWithLabel', labelname, portNames_strArray);
        end
        function int = GetBusSize(obj, pinindex)
            % Returns the bus size of the block pin specified by pinindex. Bus size is the number of electrical connections that the block pin carries. Non bus block pins have the bus size 1.
            int = obj.hBlock.invoke('GetBusSize', pinindex);
        end
        function bool = GetBusPortNames(obj, pinindex, portNames_strArray)
            % Returns the block ports inside a bus pin. true is returned if the operation was successful.
            % (See Example)
            bool = obj.hBlock.invoke('GetBusPortNames', pinindex, portNames_strArray);
        end
        function int = GetNumberOfNonReferencePorts(obj)
            % Returns a block's number of ports (without reference ports).
            int = obj.hBlock.invoke('GetNumberOfNonReferencePorts');
        end
        function int = GetNumberOfPins(obj)
            % Returns the block's number of pins (including reference pins).
            int = obj.hBlock.invoke('GetNumberOfPins');
        end
        function int = GetNumberOfPorts(obj)
            % Returns the block's number of ports (including reference ports).
            int = obj.hBlock.invoke('GetNumberOfPorts');
        end
        function GetPinLayout(obj, pinindex, edge, edgeindex)
            % Queries how the layout of the block pin with the specified pin index is defined. Writes one of the edges listed for SetPinLayout() into the variable edge and  the index of the pin on that edge into the variable edgeindex. Edge indexing is from top to bottom and from left to right.
            % (See Example)
            obj.hBlock.invoke('GetPinLayout', pinindex, edge, edgeindex);
        end
        function enum = GetPinLayoutType(obj)
            % Queries how the pin layout of a block is defined. "fixed" is returned for blocks that do not support different pin layout settings. For all other blocks one of the types listed for SetPinLayoutType() is returned.
            enum = obj.hBlock.invoke('GetPinLayoutType');
        end
        function bool = GetDifferentialCablePorts(obj)
            % Queries whether differential ports for a block using cable models are set.
            bool = obj.hBlock.invoke('GetDifferentialCablePorts');
        end
        function bool = GetDifferentialPorts(obj)
            % Queries whether differential ports are set for a block.
            bool = obj.hBlock.invoke('GetDifferentialPorts');
        end
        function str = GetPinName(obj, pinindex)
            % Returns the name of a block pin specified by the given index. Index must be an integer between 0 and GetNumberOfPins()-1.
            str = obj.hBlock.invoke('GetPinName', pinindex);
        end
        function SetPinName(obj, pinindex, pinname)
            % Set the name of a block pin specified by the given index. Index must be an integer between 0 and GetNumberOfPins()-1. Specifying an empty name resets the pin name to the default name.
            obj.hBlock.invoke('SetPinName', pinindex, pinname);
        end
        function int = GetPinIndex(obj, pinname)
            % Returns the index of a block pin specified by the given pinname. If a pin was found the returned index is an integer between 0 and GetNumberOfPins()-1. The function throws an error and returns -1 if no pin was found.
            int = obj.hBlock.invoke('GetPinIndex', pinname);
        end
        function int = GetPortIndex(obj, portname)
            % Returns the index of a block port specified by the given portname. If a port  was found the returned index is an integer between 0 and GetNumberOfPorts()-1. The function throws an error and returns -1 if no port was found.
            % (See Example)
            int = obj.hBlock.invoke('GetPortIndex', portname);
        end
        function str = GetPortLabel(obj, portindex)
            % Returns the label of a block port specified by the given portindex. Since not all blocks support port labels, this function may return an empty string. Index must be an integer between 0 and GetNumberOfPorts()-1.
            % (See Example)
            str = obj.hBlock.invoke('GetPortLabel', portindex);
        end
        function str = GetPortName(obj, portindex)
            % Returns the name of a block port specified by the given portindex that must be an integer between 0 and GetNumberOfPorts()-1.
            % (See Example)
            str = obj.hBlock.invoke('GetPortName', portindex);
        end
        function bool = IsPinConnected(obj, pinindex)
            % Checks if the specified pin of this block is connected. pinindex must be an integer between 0 and GetNumberOfPins()-1.
            bool = obj.hBlock.invoke('IsPinConnected', pinindex);
        end
        function SetPinLayout(obj, pinindex, edge, edgeindex)
            % Sets the location of a block pin specified by pinindex (i.e. 0,LEFT,1 => moves the pin with index 0 to be the second pin on left). This is only possible for some types of blocks and if the layout type is "manual". 0 based edge indexing is from top to bottom and from left to right. The following edges can be set:
            % "BOTTOM"
            % Bottom edge.
            % "LEFT"
            % Left edge.
            % "RIGHT"
            % Right edge.
            % "TOP"
            % Top edge.
            % (See Example)
            obj.hBlock.invoke('SetPinLayout', pinindex, edge, edgeindex);
        end
        function SetPinLayoutType(obj, type)
            % Sets how the pin layout of a block is defined, i.e. the position of each pin. This is only possible for some types of blocks. The following types are supported:
            % "manual"
            % The pins are manually positioned.
            % "left right clockwise"
            % The pins are distributed on the left and right edges in clockwise order.
            % "left right anticlockwise"
            % The pins are distributed on the left and right edges in anticlockwise order.
            % "left right alternating"
            % The pins are distributed on the left and right edges in alternating order.
            % "left right downward"
            % The first half of the pins is located on the left edge from top to bottom, and the second half of the pins is located on the right edge from top to bottom.
            % "clockwise"
            % The pins are distributed on all four edges in clockwise order.
            % "anticlockwise"
            % The pins are distributed on all four edges in anticlockwise order.
            % "automatic"
            % The pins are distributed for optimal connector routing.
            % (See Example)
            obj.hBlock.invoke('SetPinLayoutType', type);
        end
        function SetDifferentialCablePorts(obj, differential)
            % Sets differential ports for a block using cable models, i.e. its reference pins can also be accessed. This is only possible for SimLab TL/PEEC file blocks and CST CABLE STUDIO blocks.
            obj.hBlock.invoke('SetDifferentialCablePorts', differential);
        end
        function SetDifferentialPorts(obj, differential)
            % Sets differential ports for a block, i.e. its reference pins can also be accessed. This is only possible for some types of blocks.
            obj.hBlock.invoke('SetDifferentialPorts', differential);
        end
        %% Vector Fitting
        function bool = CanUseMOR(obj)
            % Checks if a block can use model order reduction (MOR) in transient simulation. MOR is implemented via a Vector Fitting algorithm. It is applied to blocks that are represented by dispersive S-Parameters. Hence, the return value indicates, whether
            % the get-methods:
            %   GetConvolutionFmax, GetMOR_AccuracyAbs, GetMOR_InitialPoles, GetMOR_MaximumPoles, GetMOR_PassivateToInfinity, GetMOR_PoleIncrement, GetUseNaturalImpedances, GetMOR_RenormalizationImpedance
            % and the set-methods:
            %   SetConvolutionFmax, SetMOR_AccuracyAbs, SetMOR_InitialPoles, SetMOR_MaximumPoles, SetMOR_PassivateToInfinity, SetMOR_PoleIncrement, SetUseNaturalImpedances, SetMOR_RenormalizationImpedance can be called.
            bool = obj.hBlock.invoke('CanUseMOR');
        end
        function DeleteMORCache(obj)
            % The MOR cache caches the poles and residues of a reduced order model for efficiency reasons since the Vector Fitting of a block can sometimes be costly and should not be repeated in every transient simulation. By this method, all cache entries for the block can be deleted. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            obj.hBlock.invoke('DeleteMORCache');
        end
        function GetMOR_AccuracyAbs(obj, value)
            % Returns the desired approximation accuracy of Vector Fitting. The value is absolute. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            obj.hBlock.invoke('GetMOR_AccuracyAbs', value);
        end
        function bool = GetMOR_EnhanceAccuracyAtDC(obj)
            % Indicates whether the accuracy of Vector Fitting is to be enhanced at DC to improve the steady-state behavior of the model in transient simulation. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            bool = obj.hBlock.invoke('GetMOR_EnhanceAccuracyAtDC');
        end
        function str = GetMOR_ErrorNorm(obj)
            % Returns the type of Error norm applied to the vector Fitting algorithm. The return value can assume values "Max" or "L2". The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            str = obj.hBlock.invoke('GetMOR_ErrorNorm');
        end
        function int = GetMOR_InitialPoles(obj)
            % Returns the initial number of poles used in Vector Fitting. A return value of 0 indicates that the required number of poles will be calculated automatically. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            int = obj.hBlock.invoke('GetMOR_InitialPoles');
        end
        function bool = GetMOR_ManualPoleChoice(obj)
            % The return value indicates whether the initial number of poles  and/or the pole increment, used in Vector Fitting, have been specified manually by the user and are applied in transient simulation. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            bool = obj.hBlock.invoke('GetMOR_ManualPoleChoice');
        end
        function int = GetMOR_MaximumPoles(obj)
            % Returns the maximum number of poles used in Vector Fitting. A return value of 0 indicates that the required number of poles will be calculated automatically. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            int = obj.hBlock.invoke('GetMOR_MaximumPoles');
        end
        function int = GetMOR_PoleIncrement(obj)
            % Returns the pole increment used in Vector Fitting. A return value of 0 indicates that the pole increment will be calculated internally by the Vector Fitting algorithm. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            int = obj.hBlock.invoke('GetMOR_PoleIncrement');
        end
        function bool = GetMOR_PassivateToInfinity(obj)
            % Indicates whether passivity is enforced to an infinite frequency during Vector Fitting. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            bool = obj.hBlock.invoke('GetMOR_PassivateToInfinity');
        end
        function bool = GetUseNaturalImpedances(obj)
            % The return value indicates whether the natural port impedances of the block or a fixed impedance, applied to all ports, are used as reference for the convolution in transient simulation. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR().
            bool = obj.hBlock.invoke('GetUseNaturalImpedances');
        end
        function double = GetConvolutionFmax(obj)
            % Returns the maximum frequency to which S-Parameters are fitted in Vector Fitting. A return value of 0 indicates that the maximum frequency is calculated automatically, based on the transient excitation. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            double = obj.hBlock.invoke('GetConvolutionFmax');
        end
        function double = GetMOR_RenormalizationImpedance(obj)
            % Returns a positive resistance in Ohms to which all ports impedances are renormalized when S-Parameters are fitted via Vector Fitting. Note that the renormalization is only carried out if no natural port impedances are used. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            double = obj.hBlock.invoke('GetMOR_RenormalizationImpedance');
        end
        function SetMOR_AccuracyAbs(obj, value)
            % value specifies the desired approximation accuracy of Vector Fitting. The accuracy is specified as an absolute value. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            obj.hBlock.invoke('SetMOR_AccuracyAbs', value);
        end
        function SetMOR_EnhanceAccuracyAtDC(obj, enhance)
            % By this method, the vector Fitting algorithm can be induced to put more emphasis on the model accuracy at DC to improve the steady-state behavior of the model. But note that the overall accuracy of the model might be decreased when demanding high accuracy at DC. Note also that it might not be possible to achieve a high accuracy at DC if there are strong passivity violations of the input data at DC. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            obj.hBlock.invoke('SetMOR_EnhanceAccuracyAtDC', enhance);
        end
        function SetMOR_ErrorNorm(obj, method)
            % Specifies the kind of error norm applied by the Vector Fitting algorithm. The argument can assume the values "Max" or "L2". The maximum norm considers the maximum error within the frequency range of interest while the L2 norm averages the error over the frequency range. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            obj.hBlock.invoke('SetMOR_ErrorNorm', method);
        end
        function SetMOR_InitialPoles(obj, poles)
            % Specifies the initial number of poles used in Vector Fitting. If the argument is zero by value, the required number of poles is estimated automatically in the MOR algorithm. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            obj.hBlock.invoke('SetMOR_InitialPoles', poles);
        end
        function SetMOR_ManualPoleChoice(obj, choice)
            % The argument choice indicates whether the initial number of poles  and/or the pole increment, used in Vector Fitting, are derived from manual user settings or calculated automatically, disregarding settings by the user, during transient simulation.  If choice is true, the initial number of poles and the pole increment can subsequently be set via the methods SetMOR_InitialPoles and SetMOR_PoleIncrement, respectively. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            obj.hBlock.invoke('SetMOR_ManualPoleChoice', choice);
        end
        function SetMOR_MaximumPoles(obj, poles)
            % Specifies the maximum number of poles used in Vector Fitting. If the argument is zero by value, the required number of poles is estimated automatically in the Vector Fitting algorithm. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            obj.hBlock.invoke('SetMOR_MaximumPoles', poles);
        end
        function SetMOR_PassivateToInfinity(obj, passivatetoinfinity)
            % Specifies whether S-Parameters are to be passivated to an infinite frequency in Vector Fitting. This guaranties absolute stability of the reduced order model, but it might reduce the accuracy of the approximated S-Parameters in the frequency range of interest. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            obj.hBlock.invoke('SetMOR_PassivateToInfinity', passivatetoinfinity);
        end
        function SetMOR_PoleIncrement(obj, increment)
            % Specifies the increment in the number of poles used in Vector Fitting. In the algorithm the number of poles is increased by the increment from iteration to iteration, starting at the initial number of poles. If the argument is zero by value, an appropriate pole increment is calculated automatically by the Vector Fitting algorithm. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            obj.hBlock.invoke('SetMOR_PoleIncrement', increment);
        end
        function SetUseNaturalImpedances(obj, bFlag)
            % The flag specifies whether natural port impedances are used as reference for the convolution of a Vector Fitting model, used in transient simulation or, if false, whether a fixed impedance is used as reference impedance for all ports. Natural port impedances are advantageous, because they tend to lead to shorter impulse responses and to a lower number of significant poles. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR().
            obj.hBlock.invoke('SetUseNaturalImpedances', bFlag);
        end
        function SetMOR_RenormalizationImpedance(obj, resistance)
            % Specifies a positive resistance to which all ports impedances are renormalized when S-Parameters are supplied to the Vector Fitting. The argument is in Ohms. Note that the renormalization is only carried out if no natural port impedances are used. This managed by the method SetUseNaturalImpedances. The method can only be applied to blocks that use Vector Fitting to represent dispersive data. This can be queried by the method CanUseMOR.
            obj.hBlock.invoke('SetMOR_RenormalizationImpedance', resistance);
        end
        function SetConvolutionFmax(obj, fmax)
            % Specifies the maximum frequency to which S-Parameters are fitted in Vector Fitting. The argument is in frequency units. If the argument is zero by value, the maximum frequency is calculated automatically, based on the transient excitation. The method can only be applied to blocks that can use convolution via MOR or IFT. This can be queried by the method CanUseMOR.
            obj.hBlock.invoke('SetConvolutionFmax', fmax);
        end
        %% Properties
        function SetDoubleProperty(obj, propertyname, value)
            % Sets the given value for the specified property. The list of properties available is individual for each type of block.
            % Note: Use SetIntegerProperty( name propertyname, string value ) to specifiy enum properties, characterized by a drop-down list. Each entry is numbered consecutively starting from "0". Please take a look at the examples below to get further information.
            obj.hBlock.invoke('SetDoubleProperty', propertyname, value);
        end
        function SetIntegerProperty(obj, propertyname, value)
            % Sets the given value for the specified property. The list of properties available is individual for each type of block.
            % Note: Use SetIntegerProperty( name propertyname, string value ) to specifiy enum properties, characterized by a drop-down list. Each entry is numbered consecutively starting from "0". Please take a look at the examples below to get further information.
            obj.hBlock.invoke('SetIntegerProperty', propertyname, value);
        end
        function SetBoolProperty(obj, propertyname, value)
            % Sets the given value for the specified property. The list of properties available is individual for each type of block.
            % Note: Use SetIntegerProperty( name propertyname, string value ) to specifiy enum properties, characterized by a drop-down list. Each entry is numbered consecutively starting from "0". Please take a look at the examples below to get further information.
            obj.hBlock.invoke('SetBoolProperty', propertyname, value);
        end
        function SetStringProperty(obj, propertyname, value)
            % Sets the given value for the specified property. The list of properties available is individual for each type of block.
            % Note: Use SetIntegerProperty( name propertyname, string value ) to specifiy enum properties, characterized by a drop-down list. Each entry is numbered consecutively starting from "0". Please take a look at the examples below to get further information.
            obj.hBlock.invoke('SetStringProperty', propertyname, value);
        end
        function SetDoubleArrayProperty(obj, propertyname, array)
            % Sets the given value for the specified property. The list of properties available is individual for each type of block.
            % Note: Use SetIntegerProperty( name propertyname, string value ) to specifiy enum properties, characterized by a drop-down list. Each entry is numbered consecutively starting from "0". Please take a look at the examples below to get further information.
            obj.hBlock.invoke('SetDoubleArrayProperty', propertyname, array);
        end
        function SetIntegerArrayProperty(obj, propertyname, array)
            % Sets the given value for the specified property. The list of properties available is individual for each type of block.
            % Note: Use SetIntegerProperty( name propertyname, string value ) to specifiy enum properties, characterized by a drop-down list. Each entry is numbered consecutively starting from "0". Please take a look at the examples below to get further information.
            obj.hBlock.invoke('SetIntegerArrayProperty', propertyname, array);
        end
        function SetStringArrayProperty(obj, propertyname, array)
            % Sets the given value for the specified property. The list of properties available is individual for each type of block.
            % Note: Use SetIntegerProperty( name propertyname, string value ) to specifiy enum properties, characterized by a drop-down list. Each entry is numbered consecutively starting from "0". Please take a look at the examples below to get further information.
            obj.hBlock.invoke('SetStringArrayProperty', propertyname, array);
        end
        %% Renorm
        function SetRenormForBlockLinks(obj, renorm)
            % Specifies if the block's S-parameters will be re-normalized if its impedances differ from the impedances of a connected block.
            obj.hBlock.invoke('SetRenormForBlockLinks', renorm);
        end
        function SetRenormRangeForBlockLinks(obj, percent)
            % Specifies the range of relative differences of the block's impedances and a connected block's impedances that is considered as equal, e.g. a value of 15 means that a deviation of up to 15 percent will be ignored.
            obj.hBlock.invoke('SetRenormRangeForBlockLinks', percent);
        end
        function SetRenormForPortLinks(obj, renorm)
            % Specifies if the block's S-parameters will be re-normalized if its impedances differ from the impedances of a connected external port.
            obj.hBlock.invoke('SetRenormForPortLinks', renorm);
        end
        function SetRenormRangeForPortLinks(obj, percent)
            % Specifies the range of relative differences of the block's impedances and a connected external port's impedance (if a fix impedance is set there) that is considered as equal, e.g. a value of 15 means that a deviation of up to 15 percent will be ignored.
            obj.hBlock.invoke('SetRenormRangeForPortLinks', percent);
        end
        %% Assembly
        % All methods in this section require that the block already exists.
        function str = GetGlobalTranslationInAssembly(obj)
            % Returns the block translation vector with respect to the global assembly coordinate system, comprising the (potentially parameterized) expressions for x, y, and z translation.
            str = obj.hBlock.invoke('GetGlobalTranslationInAssembly');
        end
        function double_array = GetGlobalTranslationInAssemblyValues(obj)
            % Returns the block translation vector with respect to the global assembly coordinate system, comprising the numerical values for x, y, and z translation.
            double_array = obj.hBlock.invoke('GetGlobalTranslationInAssemblyValues');
        end
        function str = GetLocalTranslationInAssembly(obj)
            % Returns the block translation vector in the assembly model with respect to the block's local coordinate system, comprising the (potentially parameterized) expressions for x, y, and z translation.
            str = obj.hBlock.invoke('GetLocalTranslationInAssembly');
        end
        function double_array = GetLocalTranslationInAssemblyValues(obj)
            % Returns the block translation vector in the assembly model with respect to the block's local coordinate system, comprising the numerical values for x, y, and z translation.
            double_array = obj.hBlock.invoke('GetLocalTranslationInAssemblyValues');
        end
        function str = GetRotationAnglesInAssembly(obj)
            % Returns the block rotation angles (Euler angles) in the assembly model, comprising the (potentially parameterized) expressions for the angles around the x-, y-, and z-axes.
            str = obj.hBlock.invoke('GetRotationAnglesInAssembly');
        end
        function double_array = GetRotationAnglesInAssemblyValues(obj)
            % Returns the block rotation angles (Euler angles) in the assembly model, comprising the numerical values for the angles around the x-, y-, and z-axes.
            double_array = obj.hBlock.invoke('GetRotationAnglesInAssemblyValues');
        end
        function str = GetRotationCenterInAssembly(obj)
            % Returns the block rotation center (pivot offset) with respect to the block's local coordinate system  in the assembly model, comprising the (potentially parameterized) expressions for x, y, and z offset.
            str = obj.hBlock.invoke('GetRotationCenterInAssembly');
        end
        function double_array = GetRotationCenterInAssemblyValues(obj)
            % Returns the block rotation center (pivot offset) with respect to the block's local coordinate system  in the assembly model, comprising the numerical values for x, y, and z offset.
            double_array = obj.hBlock.invoke('GetRotationCenterInAssemblyValues');
        end
        function SetGlobalTranslationInAssembly(obj, x, y, z)
            % Sets the translation vector with respect to the global assembly coordinate system in the assembly model. The coordinates can contain parameterized expressions.
            obj.hBlock.invoke('SetGlobalTranslationInAssembly', x, y, z);
        end
        function SetLocalTranslationInAssembly(obj, x, y, z)
            % Sets the translation vector with respect to the local block coordinate system in the assembly model. The coordinates can contain parameterized expressions.
            obj.hBlock.invoke('SetLocalTranslationInAssembly', x, y, z);
        end
        function SetRotationAnglesInAssembly(obj, rx, ry, rz)
            % Sets the rotation angles (Euler angles) for the block in the assembly model. The angles can contain parameterized expressions.
            obj.hBlock.invoke('SetRotationAnglesInAssembly', rx, ry, rz);
        end
        function SetRotationCenterInAssembly(obj, x, y, z)
            % Sets the rotation center (pivot offset) with respect to the local block coordinate system in the assembly model. The offset coordinates can contain parameterized expressions.
            obj.hBlock.invoke('SetRotationCenterInAssembly', x, y, z);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hBlock

    end
end

%% Block Types
% To create a new block, one of the following block types must be specified within the Type method of the Block object.

%% Field simulator block types
% "CSTMWS"                    CST MICROWAVE STUDIO block
% "CSTMWSFile"                CST MICROWAVE STUDIO file block
% "CSTEMStudio"               CST EM STUDIO block
% "CSTEMStudioFile"           CST EM STUDIO file block
% "CSTCableStudio"            CST CABLE STUDIO block
% "CSTCableStudioFile"        CST CABLE STUDIO file block
% "CSTPCBStudioFile"          CST PCB STUDIO file block
% "CSTMPhysicsStudio"         CST MPHYSICS STUDIO block
% "CSTMPhysicsStudioFile"     CST MPHYSICS STUDIO file block
% "CSTParticleStudio"         CST PARTICLE STUDIO block
% "CSTParticleStudioFile"     CST PARTICLE STUDIO file block

%% Data import block types
% "Touchstone"                        Touchstone file block
% "TouchstoneProjectInternal"         Touchstone block
% "SPICEImport"                       SPICE file block
% "SPICE"                             SPICE block
% "IBISRefFile"                       IBIS reference file block
% "IBISRefProj"                       IBIS reference project block
% "IBIS"                              IBIS buffer block
% "SimLabFile"                        SimLab TL/PEEC file block
% "SimLab"                            SimLab TL/PEEC block
% "ResistanceMatrix"                  Resistance matrix file block
% "ResistanceMatrixProjectInternal"   Resistance matrix block
% "InductanceMatrix"                  Inductance matrix file block
% "InductanceMatrixProjectInternal"   Inductance matrix block
% "ConductanceMatrix"                 Conductance matrix file block
% "ConductanceMatrixProjectInternal"  Conductance matrix block
% "CapacitanceMatrix"                 Capacitance matrix file block
% "CapacitanceMatrixProjectInternal"  Capacitance matrix block

%% Miscellaneous block types
% "CSTDS"         CST DESIGN STUDIO block
% "VisualBasic"   Visual Basic block
% "Clone"         Clone block
% "ModeConverter" Mode converter block

%% Microwave RF block types
% "Attenuator"            Attenuator block
% "Isolator"              Isolator block
% "Amplifier"             Amplifier block
% "3dBSplitter"           3dB splitter block
% "PowerDivider"          Power Divider block
% "DirectionalCoupler"    Directional Coupler block
% "IdealPhaseShifter"     Ideal phase shifter block
% "VariableReflection"    Variable reflection block
% "PerfectAbsorber"       Perfect absorber block

%% Transmission line block types
% "GeneralizedTransmissionLineReference"  Generalized transmission line reference block
% "GeneralizedTransmissionLine"           Generalized transmission line block
% "TransmissionLineReference"             Transmission line reference block
% "ElectricalTransmissionLine"            Electrical transmission line block
% "TransmissionLine"                      Transmission line block
% "CoaxialLine"                           Coaxial line block
% "CoupledTransmissionLines"              Coupled transmission lines block
% "TransmissionLineShort"                 Transmission line short block
% "TransmissionLineOpen"                  Transmission line open block
% "TransmissionLineShuntShort"            Transmission line shunt short block
% "TransmissionLineShuntOpen"             Transmission line shunt open block

%% Microstrip block types
% "MicrostripReference"               Microstrip reference block
% "MicrostripLine"                    Microstrip line block
% "MicrostripBend90"                  Microstrip bend block
% "MicrostripBend90OptimalMitered"    Microstrip bend optimal mitered block
% "MicrostripBendRadial"              Microstrip bend with radial stub block
% "MicrostripCurvedBend"              Microstrip curved arbitrary angle bend block
% "MicrostripTaper"                   Microstrip taper block
% "MicrostripStep"                    Microstrip step block
% "MicrostripStepAsymmetric"          Microstrip asymmetric step block
% "MicrostripGap"                     Microstrip gap block
% "MicrostripGapAsymmetric"           Microstrip asymmetric gap block
% "MicrostripMea"                     Microstrip meander line
% "MicrostripOpenEnd"                 Microstrip open end block
% "MicrostripRadialOpen"              Microstrip open radial stub
% "MicrostripShortStub"               Microstrip short stub
% "MicrostripRadial"                  Microstrip radial shunt stub
% "MicrostripRadial2"                 Microstrip butterfly shunt stub
% "MicrostripTJunction"               Microstrip T-junction block
% "MicrostripCrossJunction"           Microstrip cross-junction block
% "MicrostripCoupledLines"            Microstrip line coupler (4 ports) block
% "MicrostripCoupledLines2Port"       Microstrip line coupler (2 ports) block
% "MicrostripCoupledLinesOpen"        Microstrip coupled lines open end block
% "MicrostripCoupledMeaLine"          Microstrip coupled meander/straight lines block
% "MicrostripCoupledLinesMea"         Microstrip coupled meander lines block
% "MicrostripCoupledLinesRegular"     Microstrip regular coupled lines block
% "MicrostripCoupledLinesIrregular"   Microstrip irregular coupled lines block
% "MicrostripBranchlineCoupler"       Microstrip branchline coupler block
% "MicrostripRatraceCoupler"          Microstrip ratrace ring coupler block
% "MicrostripBroadsideCoupler"        Microstrip broadside coupler (4 ports) block
% "MicrostripVia"                     Microstrip via block
% "MicrostripVia2Port"                Microstrip two-port via block
% "MicrostripVia2Layer"               Microstrip two-port interconnection via block

%% Stripline block types
% "StriplineReference"                        Stripline reference block
% "Stripline"                                 Stripline line block
% "StriplineBend90"                           Stripline bend block
% "StriplineBend90OptimalMitered"             Stripline bend optimal mitered block
% "StriplineBendRadial"                       Stripline bend with radial stub block
% "StriplineCurvedBend"                       Stripline curved arbitrary angle bend block
% "StriplineTaper"                            Stripline taper block
% "StriplineStep"                             Stripline step block
% "StriplineStepAsymmetric"                   Stripline asymmetric step block
% "StriplineGap"                              Stripline gap block
% "StriplineGapAsymmetric"                    Stripline asymmetric gap block
% "StriplineMea"                              Stripline meander line
% "StriplineOpenEnd"                          Stripline open end block
% "StriplineRadialOpen"                       Stripline open radial stub
% "StriplineShortStub"                        Stripline short stub
% "StriplineRadial"                           Stripline radial shunt stub
% "StriplineRadial2"                          Stripline butterfly shunt stub
% "StriplineTJunction"                        Stripline T-junction block
% "StriplineCrossJunction"                    Stripline cross-junction block
% "StriplineCoupledLines"                     Stripline line coupler (4 ports) block
% "StriplineCoupledLines2Port"                Stripline line coupler (2 ports) block
% "StriplineCoupledLinesOpen"                 Stripline coupled lines open end block
% "StriplineCoupledMeaLine"                   Stripline coupled meander/straight lines block
% "StriplineCoupledLinesMea"                  Stripline coupled meander lines block
% "StriplineCoupledLinesRegular"              Stripline regular coupled lines block
% "StriplineCoupledLinesIrregular"            Stripline irregular coupled lines block
% "StriplineBranchlineCoupler"                Stripline branchline coupler block
% "StriplineRatraceCoupler"                   Stripline ratrace ring coupler block
% "StriplineVia"                              Stripline via block
% "StriplineVia2Port"                         Stripline two-port via block

%% Waveguide block types
% "RectangularWaveguideReference"             Rectangular waveguide reference block
% "RectangularWaveguide"                      Rectangular waveguide block
% "RectangularWaveguideEPlaneCorner"          Rectangular waveguide E-plane corner block (TE10)
% "RectangularWaveguideHPlaneCorner"          Rectangular waveguide H-plane corner block (TE10)
% "RectangularWaveguideEPlaneBend"            Rectangular waveguide E-plane bend block (TE10)
% "RectangularWaveguideHPlaneBend"            Rectangular waveguide H-plane bend block (TE10)
% "RectangularWaveguideEPlaneTJunction"       Rectangular waveguide E-plane T-junction block (TE10)
% "RectangularWaveguideHPlaneTJunction"       Rectangular waveguide H-plane T-junction block (TE10)
% "RectangularWaveguideSymIrisFinitePerp"     Rectangular waveguide finite symmetric iris perpendicular to E block (TE10)
% "RectangularWaveguideSymIrisFinitePar"      Rectangular waveguide finite symmetric iris parallel to E block (TE10)
% "RectangularWaveguideAsymIrisFinitePerp"    Rectangular waveguide finite asymmetric iris perpendicular to E block (TE10)
% "RectangularWaveguideAsymIrisFinitePar"     Rectangular waveguide finite asymmetric iris parallel to E block (TE10)
% "CircularWaveguideReference"                Circular waveguide reference block
% "CircularWaveguide"                         Circular waveguide block
% "HollowWaveguide"                           Hollow waveguide block

%% Circuit Basic block types
% "Ground"                                                    Ground element
% "CircuitBasic\Resistor"                                     Resistor
% "CircuitBasic\Capacitor"                                    Capacitor
% "CircuitBasic\Inductor"                                     Inductor
% "CircuitBasic\Generic 2-Pin Device"                         Generic 2-Pin Device
% "CircuitBasic\Generic 3-Pin Device"                         Generic 3-Pin Device
% "CircuitBasic\Generic 4-Pin Device"                         Generic 4-Pin Device
% "CircuitBasic\Mutual Coupling"                              Mutual Coupling
% "CircuitBasic\Voltage DC Source"                            Voltage DC Source
% "CircuitBasic\Voltage Signal Source"                        Voltage Signal Source (AC or HB)
% "CircuitBasic\Current Source"                               Current Source
% "CircuitBasic\Linear Current-Controlled Current Source"     Linear Current-Controlled Current Source
% "CircuitBasic\Linear Voltage-Controlled Current Source"     Linear Voltage-Controlled Current Source
% "CircuitBasic\Linear Current-Controlled Voltage Source"     Linear Current-Controlled Voltage Source
% "CircuitBasic\Linear Voltage-Controlled Voltage Source"     Linear Voltage-Controlled Voltage Source
% "CircuitBasic\Infinite Value Capacitor"                     Infinite Value Capacitor
% "CircuitBasic\Infinite Value Inductor"                      Infinite Value Inductor
% "CircuitBasic\Ideal Transformer"                            Ideal Transformer
% "CircuitBasic\Operational Amplifier"                        Operational Amplifier
% "VoltageControlledSwitch"                                   Voltage-Controlled Switch
% "CurrentControlledSwitch"                                   Current-Controlled Switch

%% Circuit Semiconductor block types
% "CircuitSemi\Diode"                                                     Diode
% "CircuitSemi\Schottky Diode"                                            Schottky diode
% "CircuitSemi\Zener Diode"                                               Zener diode
% "CircuitSemi\NPN Bipolar Transistor"                                    NPN bipolar transistor
% "CircuitSemi\PNP Bipolar Transistor"                                    PNP bipolar transistor
% "CircuitSemi\N Junction Field-Effect Transistor"                        N Junction Field-Effect Transistor
% "CircuitSemi\P Junction Field-Effect Transistor"                        P Junction Field-Effect Transistor
% "CircuitSemi\N GaAS Metal-Schottky Field-Effect Transistor (MESFET)"    N GaAS Metal-Schottky Field-Effect Transistor (MESFET)
% "CircuitSemi\P GaAS Metal-Schottky Field-Effect Transistor (MESFET)"    P GaAS Metal-Schottky Field-Effect Transistor (MESFET)
% "CircuitSemi\N MOS Transistor"                                          N MOS Transistor
% "CircuitSemi\P MOS Transistor"                                          P MOS Transistor
% "CircuitSemi\N MOS Transistor (3 Terminal)"                             N MOS Transistor (3 Terminal)
% "CircuitSemi\P MOS Transistor (3 Terminal)"                             P MOS Transistor (3 Terminal)
% "CircuitSemi\NPN Darlington Transistor"                                 NPN Darlington Transistor
% "CircuitSemi\PNP Darlington Transistor"                                 PNP Darlington Transistor
% "CircuitSemi\N-Channel IGBT"                                            N-Channel Insulated Gate Bipolar Transistor
% "CircuitSemi\P-Channel IGBT"                                            P-Channel Insulated Gate Bipolar Transistor
% "CircuitSemi\Thyristor"                                                 Thyristor

%% Default Settings
% Position(50000, 50000)
% EnableSlaveCommands(1)
% SetRelativePath(1)

%% Example - Taken from CST documentation and translated to MATLAB.
% %Create a block
%
% block = dsproject.Block();
% .Reset
% .Type('MicrostripCoupledLinesIrregular');
% .Name('MC2');
% Dim sWidth(0 To 3) As String
% sWidth(0) =('0.5');
% sWidth(1) =('1.1');
% sWidth(2) =('2.2');
% sWidth(3) =('3.3');
% .SetIntegerProperty('Number Of Lines', 4)
% .SetDoubleArrayProperty('Widths', sWidth)
% .Position(51050, 51000)
% .Create
%
% %Modify an existing block%s position and some solver settings
%
% .Reset
% .Name('MyTLine');
% .Position(57000, 50000)
% .Rotate(90)
% .SetDeembedded(1)
%
% %Set the enum property('Model Type'); of a resistor named('RES1'); to('Parasitic(1st Order)');(entries of the drop-down list are numbered from 0 -(n-1) ).
%
% .name('RES1');
% .Type('CircuitBasic\Resistor');
% .SetIntegerProperty('Model Type', '1');
%
% %Find all ports with label %MyLabel%
% Dim portNames As Variant
% Dim numberOfPorts As Long
% Dim iPortIndex As Integer
%    .Reset
%    .Name('MyBlock');
%    numberOfPorts = .FindPortsWithLabel(('MyLabel', portNames )
%    If IsEmpty(portNames) Then
%       DS.ReportInformation('Port with label %MyLabel% does not exist.');
%    Else
%       Dim N As Long
%       For N = 0 To UBound( portNames )
%          iPortIndex = .GetPortIndex(portNames(N))
%          DS.ReportInformation( .GetPortName(iPortIndex)+');('+.GetPortLabel(iPortIndex)+');'); )
%       Next
%    End If
%
% %Get ports inside a bus pin 0
% Dim portNames As Variant
% Dim exists As Boolean
% Dim iPortIndex As Integer
%    .Reset
%    .Name('MyBlock');
%    exists = .GetBusPortNames( 0, portNames )
%    If Not exists Then
%       DS.ReportInformation('Pin is not a bus pin.');
%    Else
%       Dim N As Long
%       For N = 0 To UBound( portNames )
%          iPortIndex = .GetPortIndex(portNames(N))
%          DS.ReportInformation( .GetPortName(iPortIndex)+');('+.GetPortLabel(iPortIndex)+');'); )
%       Next
%    End If
%
% %Change the layout of the block
% %Precondition: block %MyBlock% have at least 2 pins on the left and 2 pins on the right
% Dim edge As String
% Dim edgeindex As Integer
%    .Reset
%    .Name('MyBlock');
%    .GetPinLayout( 0, edge, edgeindex ) % gets the location of pin 0
%    .SetPinLayout( 0, edge, edgeindex+1 ) %moves the pin 0 down on the same edge
%    .SetPinLayout( 0, 'RIGHT', 1 ) %moves the pin 0 to be the second pin on the right
%    .SetPinLayoutType(('clockwise'); ) %The pins are distributed on all four edges in clockwise order.
%
% %Create and configure an IBIS reference block
% %It is assumed that an IBIS reference block exists and refers to an IBIS file in which the specified pins and buffers are defined
%    .Reset
%    .Type('IBISImport');
%    .Name('IBISFILE1');
%    .Create
%    .SetIbisInternalPower(1)
%    Dim pin1 As String
%    pin1 =('14P');
%    Dim pin2 As String
%    pin2 =('14N');
%    Dim models(1) As String
%    models(0) =('BUFFER_I_P');
%    models(1) =('BUFFER_II_P');
%    Dim invModels(2) As String
%    invModels(0) =('BUFFER_I_N');
%    invModels(1) =('BUFFER_II_N');
%    Dim parameter As String
%    parameter =('models');
%    .SetIbisBuffer(pin1, pin2, models, invModels, parameter)
%    .SetIBIsCorner(1, '');
% 