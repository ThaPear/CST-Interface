%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  
classdef Project < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Application)
        % Only CST.Application can create a Project object.
        function obj = Project(hDSProject)
            obj.hDSProject = hDSProject;
        end
    end
    %% CST Object functions.
    methods
        function bool = SelectTreeItem(obj, itemname)
            % Selects the tree Item, specified by name. The view will be updated according to the selection or a different view will be activated. A tree Item is specified by the full path, e.g. SelectTreeItem ("Tasks\SPara1"). The return value is True if the selection was successful.
            bool = obj.hDSProject.invoke('SelectTreeItem', itemname);
        end
        function string = GetSelectedTreeItem(obj)
            % Returns the path name of the currently selected tree item or folder with regard to the root of the tree. E.g. if the task "SPara1" is selected, the returned path name will be "Tasks\SPara1".
            string = obj.hDSProject.invoke('GetSelectedTreeItem');
        end
        function PositionWindow(obj, location, handle)
            % This functions sets the position of a window relatively to the location of the main application window. The following settings are valid locations:
            % %
            % "center"
            % Position the window in the center of the main application window
            % "top left"
            % Position the window in the top left corner of the main application window
            % "top right"
            % Position the window in the top right corner of the main application window
            % "bottom left"
            % Position the window in the bottom left corner of the main application window
            % "bottom right"
            % Position the window in the bottom right corner of the main application window
            % %
            % The window which needs to be positioned is specified by its window handle. The typical usage of this function is in the initialization part of a user defined dialog box function as shown in the example below:
            % %
            % Private Function DlgFunc(DlgItem$, Action%, SuppValue&) As Boolean
            % Select Case Action%
            % Case 1 ' Dialog box initialization
            % PositionWindow "top right", SuppValue
            % Case 2 ' Value changing or button pressed
            % Case 3 ' TextBox or ComboBox text changed
            % Case 4 ' Focus changed
            % Case 5 ' Idle
            % Case 6 ' Function key
            % End Select
            % End Function
            obj.hDSProject.invoke('PositionWindow', location, handle);
        end
        function bool = TouchstoneExport(obj, itemname, filename, impedance)
            % Performs a Touchstone export of S-, Y-, or Z-Parameter results. 'itemname'  is a tree item specified by name.  It must contain S-, Y-, or Z-Parameters for the Touchstone export to be successfull. 'filename' is the name of the Touchstone file to be generated without extension. An appropriate extension, .s*p, .y*p, or .z*p, will be automatically appended.   'impedance'  is the reference impedance, to which the N-Port parameters will be normalised. It is applied to all ports. The return type indicates whether the Touchstone export was successful.
            bool = obj.hDSProject.invoke('TouchstoneExport', itemname, filename, impedance);
        end
        function CopySelectionToClipboard(obj)
            % Copies the currently selected items to the clipboard.
            obj.hDSProject.invoke('CopySelectionToClipboard');
        end
        function SelectAllComponents(obj)
            % Selects all components on the schematic.
            obj.hDSProject.invoke('SelectAllComponents');
        end
        function DeleteSelectedComponents(obj, keepconnectors)
            % Deletes all selected components. If keepconnectors is false, all connectors which are connected to one of the deleted components are deleted as well. Otherwise they are kept.
            obj.hDSProject.invoke('DeleteSelectedComponents', keepconnectors);
        end
        function GetBBoxAllComponents(obj, opMode, nXMin, nXMax, nYMin, nYMax)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetBBoxAllComponents''.');
            return;
            % Gets the bounding box of all existing components on a schematic. You may restrict the bounding box calculation to specific component types by specifying first argument opMode:
            % %
            % "all"
            % All component types are considered
            % "no labels"
            % Only components but labels are considered
            % %
            % NOTE: The positive coordinate directions of the schematic go like this: from Left to Right and from Top to Bottom. However, nYmin specifies the bottom of the bounding box and nYmax specifies the top of the bounding box.
            obj.hDSProject.invoke('GetBBoxAllComponents', opMode, nXMin, nXMax, nYMin, nYMax);
        end
        function EnableSchematicBlockPins(obj, enable)
            % Enables or disables the creation of pins for the automatically created schematic block. This can only be called for 3D projects, since no schematic block exists in pure CST DS projects. Disabling the pins can improve performance for projects with many sources in the 3D part, but this should only be done if the schematic part is not needed.
            obj.hDSProject.invoke('EnableSchematicBlockPins', enable);
        end
        function string = CreateProjectTemplate(obj, application, workflow)
            % Creates a project template for the specified application ("MW & RF & Optical", "EDA / Electronics", "EMC / EMI", "Charged Particle Dynamics" or "Statics and Low Frequency") and workflow (needs to match the name shown in the project template wizard). The function returns the name of the project template. If a project template for the workflow does already exist no new template is created and the name of the existing template is returned.
            string = obj.hDSProject.invoke('CreateProjectTemplate', application, workflow);
        end
        %% File Handling
        function OpenFile(obj, filename)
            % Opens an existing project. A previous project will be closed. 'filename' is the name of the project to be opened.
            obj.hDSProject.invoke('OpenFile', filename);
        end
        function Quit(obj)
            % Closes the project without saving.
            obj.hDSProject.invoke('Quit');
        end
        function Save(obj)
            % Saves the current state of the project.
            obj.hDSProject.invoke('Save');
        end
        function SaveAs(obj, filename, include_results)
            % Saves the current state of the project under the file name specified by the parameter filename. Results will be included if include_results is set to True.
            obj.hDSProject.invoke('SaveAs', filename, include_results);
        end
        function UpdateFileReferences(obj)
            % Updates all file blocks that are outdated.
            obj.hDSProject.invoke('UpdateFileReferences');
        end
        %% Parameter Handling
        function DeleteParameter(obj, name)
            % Deletes an existing parameter with the specified name.
            obj.hDSProject.invoke('DeleteParameter', name);
        end
        function bool = DoesParameterExist(obj, name)
            % Returns if a parameter with the given name exists.
            bool = obj.hDSProject.invoke('DoesParameterExist', name);
        end
        function long = GetNumberOfParameters(obj)
            % Returns the number of parameters defined so far.
            long = obj.hDSProject.invoke('GetNumberOfParameters');
        end
        function string = GetParameterName(obj, index)
            % Returns the name of the parameter referenced by the given index. The first parameter is reference by the index 0.
            string = obj.hDSProject.invoke('GetParameterName', index);
        end
        function double = GetParameterNValue(obj, index)
            % Returns the value of the double parameter referenced by the given index. The first parameter is referenced by the index 0.
            double = obj.hDSProject.invoke('GetParameterNValue', index);
        end
        function string = GetParameterSValue(obj, index)
            % Returns the numerical expression for the parameter referenced by the given index. The first parameter is referenced by the index 0.
            string = obj.hDSProject.invoke('GetParameterSValue', index);
        end
        function RenameParameter(obj, oldName, newName)
            % Change the name of existing parameter 'oldName' to 'newName'.
            obj.hDSProject.invoke('RenameParameter', oldName, newName);
        end
        function string = RestoreParameter(obj, name)
            % Gets the value of the specified string parameter.
            string = obj.hDSProject.invoke('RestoreParameter', name);
        end
        function double = RestoreDoubleParameter(obj, name)
            % Gets the value of a specified double parameter.
            double = obj.hDSProject.invoke('RestoreDoubleParameter', name);
        end
        function string = RestoreParameterExpression(obj, name)
            % Gets the numerical expression for the specified string parameter.
            string = obj.hDSProject.invoke('RestoreParameterExpression', name);
        end
        function StoreParameterWithDescription(obj, name, value, description)
            % Creates a new string parameter or changes an existing one, with the specified string value and the description.
            obj.hDSProject.invoke('StoreParameterWithDescription', name, value, description);
        end
        function StoreParameter(obj, name, value)
            % Creates a new string parameter or changes an existing one, with the specified string value.
            obj.hDSProject.invoke('StoreParameter', name, value);
        end
        function StoreParameters(obj, names, values)
            % Adds or modifies an arbitrary number of parameters in one go. For bulk changes of many parameters this method can be considerably faster than changing parameters one after another in a loop.
            % The parameters are allowed to arbitrarily depend on each other or on other already existing parameters.
            % Example:
            % Dim names(1 To 2) As String, values(1 To 2) As String
            % names(1) = "a"
            % names(2) = "b"
            % values(1) = "5*b"
            % values(2) = "2"
            % StoreParameters(names, values)
            obj.hDSProject.invoke('StoreParameters', names, values);
        end
        function StoreDoubleParameter(obj, name, value)
            % Creates a new double parameter or changes an existing one, with the specified double value.
            % Example: StoreDoubleParameter ( "test", 100.22 )
            obj.hDSProject.invoke('StoreDoubleParameter', name, value);
        end
        function bool = GetParameterCombination(obj, resultID, parameterNames, parameterValues)
            % Fills the variant 'parameterValues'  with an array of double values that correspond to the parameter combination 'resultID' . The variant 'parameterNames'  is filled with an array containing the parameter names. In case the parameter combination does not exist, the variants will not be modified and the method returns false. The string 'resultID'  corresponds to an existing Run ID and is of the format "Schematic:RunID:1." Existing Result IDs can be queried using the command GetResultIDsFromTreeItem of the ResultTree Object. The method returns an error for Result IDs of invalid format. The following example prints parameter names and parameter values to the message window:
            % Dim names As Variant, values As Variant, exists As Boolean
            % exists = DS.GetParameterCombination( "Schematic:RunID:1", names, values )
            % If Not exists Then
            % DS.ReportInformationToWindow( "Parameter combination does not exist."  )
            % Else
            % Dim N As Long
            % For N = 0 To UBound( values )
            % DS.ReportInformationToWindow( names( N )  + ": " + CStr( values( N ) ) )
            % Next
            % End If
            bool = obj.hDSProject.invoke('GetParameterCombination', resultID, parameterNames, parameterValues);
        end
        %% Simulation
        function UpdateResults(obj)
            % Starts the simulator for all tasks (Update all tasks)
            obj.hDSProject.invoke('UpdateResults');
        end
        function ConvertSParameterToY(obj, source, task)
            % Converts the S-Parameters of a block or the complete circuit and a task to admittance parameters and adds them to the result tree. The S-Parameters must already exist.
            % Example (using the S-parameters of the whole circuit): ConvertSParameterToY ( "Design", "S-Parameters1" )
            obj.hDSProject.invoke('ConvertSParameterToY', source, task);
        end
        function ConvertSParameterToZ(obj, source, task)
            % Converts the S-Parameters of a block or the complete circuit and a task to impedance parameters and adds them to the result tree. The S-Parameters must already exist.
            % Example (using the S-parameters of block "MWS1"): ConvertSParameterToZ ( "MWS1", "S-Parameters1" )
            obj.hDSProject.invoke('ConvertSParameterToZ', source, task);
        end
        function ConvertSParameterToVSWR(obj, source, task)
            % Converts the S-Parameters of a block or the complete circuit and a task to voltage standing wave ratios and adds them to the result tree. The S-Parameters must already exist.
            obj.hDSProject.invoke('ConvertSParameterToVSWR', source, task);
        end
        function ConvertSParameterToPseudoWaveS(obj, source, task)
            % Converts the S-Parameters of a block or the complete circuit and a task to pseudo wave S-Parameters and adds them to the result tree. The S-Parameters must already exist.
            obj.hDSProject.invoke('ConvertSParameterToPseudoWaveS', source, task);
        end
        function CalculatePassivityMeasure(obj, SParameterContainerPath)
            % Calculates a Passivity Measure of S-Parameter data from the Navigation Tree and
            % inserts it into the Navigation Tree. S-Parameters are passive, if the matrix
            % [I]-[S]*Transjugate{[S]} is semi-positive definite. Here, [I] is the unity matrix and
            % [S] is the S-Matrix. The calculated passivity measure is the minimum eigenvalue of
            % [I]-[S]*Transjugate{[S]} as a function of frequency. S-Parameters are non-passive, if
            % the passivity measure is negative. S-ParameterContainerPath is the path of the
            % S-Parameter container in the Navigation Tree, for which the passivity measure is to be
            % calculated, e.g., "Tasks\SPara1\S-Parameters" for the results of a default S-Parameter
            % task.
            obj.hDSProject.invoke('CalculatePassivityMeasure', SParameterContainerPath);
        end
        %% Global Data Cache
        function ClearGlobalDataValues(obj)
            % Clear all global data values.
            obj.hDSProject.invoke('ClearGlobalDataValues');
        end
        function DeleteGlobalDataValue(obj, name)
            % Delete a global data value with a given name.
            obj.hDSProject.invoke('DeleteGlobalDataValue', name);
        end
        function string = RestoreGlobalDataValue(obj, name)
            % Returnes a global data value with a given name.
            string = obj.hDSProject.invoke('RestoreGlobalDataValue', name);
        end
        function StoreGlobalDataValue(obj, name, value)
            % Creates a new global data value with a given name and value or changes an existing one.
            obj.hDSProject.invoke('StoreGlobalDataValue', name, value);
        end
        %% Mathematical Functions / Constants
        function double = ACos(obj, value)
            % Returns the arc cosine of the input parameter as a radian value.
            double = obj.hDSProject.invoke('ACos', value);
        end
        function double = ACosD(obj, value)
            % Returns the arc cosine of the input parameter in degree.
            double = obj.hDSProject.invoke('ACosD', value);
        end
        function double = ASin(obj, value)
            % Returns the arc sine of the input parameter as a radian value.
            double = obj.hDSProject.invoke('ASin', value);
        end
        function double = ASinD(obj, value)
            % Returns the arc sine of the input parameter in degree.
            double = obj.hDSProject.invoke('ASinD', value);
        end
        function double = ATnD(obj, value)
            % Returns the arc tangent of the input parameter in degree.
            double = obj.hDSProject.invoke('ATnD', value);
        end
        function double = ATn2(obj, value1, value2)
            % Returns the arc tangent of the relation of value1 to value2 as a radian value.
            % value1
            % Numerator of the arc tangent calculation.
            % value2
            % Denominator of the arc tangent calculation.
            double = obj.hDSProject.invoke('ATn2', value1, value2);
        end
        function double = ATn2D(obj, value1, value2)
            % Returns the arc tangent of the relation of value1 to value2 in degree.
            % value1
            % Numerator of the arc tangent calculation.
            % value2
            % Denominator of the arc tangent calculation.
            double = obj.hDSProject.invoke('ATn2D', value1, value2);
        end
        function double = CLight(obj)
            % Returns the constant value for the speed of light in vacuum.
            double = obj.hDSProject.invoke('CLight');
        end
        function double = CosD(obj, value)
            % Returns the cosine of the input parameter in degree.
            double = obj.hDSProject.invoke('CosD', value);
        end
        function double = Eps0(obj)
            % Returns the constant value for the permittivity of vacuum.
            double = obj.hDSProject.invoke('Eps0');
        end
        function double = Evaluate(obj, expression)
            % Evaluates and returns the numerical double result of a string expression.
            double = obj.hDSProject.invoke('Evaluate', expression);
        end
        function double = im(obj, amplitude, phase)
            % Calculates the imaginary part of a complex number defined by its amplitude and phase.
            double = obj.hDSProject.invoke('im', amplitude, phase);
        end
        function double = Mu0(obj)
            % Returns the constant value for the permeability of vacuum.
            double = obj.hDSProject.invoke('Mu0');
        end
        function double = Pi(obj)
            % Returns the constant value of Pi.
            double = obj.hDSProject.invoke('Pi');
        end
        function double = re(obj, amplitude, phase)
            % Calculates the real part of a complex number defined by its amplitude and phase.
            double = obj.hDSProject.invoke('re', amplitude, phase);
        end
        function double = SinD(obj, value)
            % Returns the sine of the input parameter in degree.
            double = obj.hDSProject.invoke('SinD', value);
        end
        function double = TanD(obj, value)
            % Returns the tangent of the input parameter in degree.
            double = obj.hDSProject.invoke('TanD', value);
        end
        function double = ChargeElementary(obj)
            % Returns the constant value of the elementary charge.
            double = obj.hDSProject.invoke('ChargeElementary');
        end
        function double = MassElectron(obj)
            % Returns the constant value of the mass of an electron.
            double = obj.hDSProject.invoke('MassElectron');
        end
        function double = MassProton(obj)
            % Returns the constant value of the mass of a proton.
            double = obj.hDSProject.invoke('MassProton');
        end
        function double = ConstantBoltzmann(obj)
            % Returns the constant value of the Stefan-Boltzmann constant.
            double = obj.hDSProject.invoke('ConstantBoltzmann');
        end
        %% Result Templates
        function ActivateScriptSettings(obj, boolean)
            % This method activates (switch = "True") or deactivates (switch = "False")  the script settings of a customized result item.
            obj.hDSProject.invoke('ActivateScriptSettings', boolean);
        end
        function ClearScriptSettings(obj)
            % This method clears the internal settings of a previously customized result item.
            obj.hDSProject.invoke('ClearScriptSettings');
        end
        function double = GetLast0DResult(obj, name)
            % This method returns the last 0D result of the selected result template. 'name' is the name of a previously defined result template.
            double = obj.hDSProject.invoke('GetLast0DResult', name);
        end
        function Result1D = GetLast1DResult(obj, name)
            % This method returns the last 1D result of the selected result template. 'name' is the name of a previously defined result template.
            Result1D = obj.hDSProject.invoke('GetLast1DResult', name);
        end
        function Result1DComplex = GetLast1DComplexResult(obj, name)
            % This method returns the last complex 1D result of the selected result template. 'name' is the name of a previously defined result template.
            Result1DComplex = obj.hDSProject.invoke('GetLast1DComplexResult', name);
        end
        function string = GetLastResultID(obj)
            % This method returns the Result ID which identifies the last result. It allows access to the last 1D or 0D result via DSResulttree.GetResultFromTreeItem, e.g.:
            % Dim o As Object
            % Set o = DSResultTree.GetResultFromTreeItem("Tasks\SPara1\S-Parameters\S1,1", DS.GetLastResultID())
            % DS.ReportInformationToWindow("Last 1D/0D result object type: " + o.GetResultObjectType())
            string = obj.hDSProject.invoke('GetLastResultID');
        end
        function string = GetScriptSetting(obj, name, default_value)
            % This function is only active if a result template is currently in process. It returns the internal settings of the previously customized result item using the StoreScriptSetting method. In case that no settings has been stored, the default value will be returned.
            string = obj.hDSProject.invoke('GetScriptSetting', name, default_value);
        end
        function StoreScriptSetting(obj, name, value)
            % This function is only active if a result template is currently in process. It offers the possibility to customize the corresponding result item with help of internal settings, which can be recalled using the GetScriptSetting function. 'name' is the name defining the internal setting. 'value' is the value of the setting.
            obj.hDSProject.invoke('StoreScriptSetting', name, value);
        end
        function string = GetTreeNameScriptSetting(obj, name, default_value)
            % This function is only active if a result template is currently in process. It returns the internal settings of the previously customized result item using the StoreTreeNameScriptSetting method. In case that no settings has been stored, the default value will be returned. This function should be used instead of GetScriptSetting for all settings that correspond to tree items. It should recieve a full tree path, e.g. "Tasks\S-Parameters1". Settings stored with this method will be automatically adjusted if the corresponding tree item is renamed or moved, so that they still refer to the same object. This also includes the case when a template using this setting is part of a task hierarchy that is moved. If a template using this setting is part of a task hierarchy that is copied, and the referenced object is copied as well, then the template setting will also be adjusted to point to the copied object. It will not be adjusted if the referenced object is not copied. The following items will be automatically adjusted: Blocks, tasks, external ports and probes.
            string = obj.hDSProject.invoke('GetTreeNameScriptSetting', name, default_value);
        end
        function StoreTreeNameScriptSetting(obj, setting, value)
            % This function is only active if a result template is currently in process. It offers the possibility to customize the corresponding result item with help of internal settings, which can be recalled using the GetTreeNameScriptSetting function. 'name' is the name defining the internal setting. 'value' is the value of the setting. See the description of GetTreeNameScriptSetting for details about the differences to StoreScriptSetting.
            obj.hDSProject.invoke('StoreTreeNameScriptSetting', setting, value);
        end
        function StoreTemplateSetting(obj, setting, value)
            % This function is only active if a result template is processed. It defines the type of the template and needs to be set in the define method of every result template. The variable 'setting' has to be the string "TemplateType". The variable 'value' can be"0D", "1D", "1DC", "M0D", "M1D" or "M1DC". The choice of the template type determines which evaluation method of the template is called when being processed and what return type is expected. More details can be found on the Post-Processing Template Layout help page.
            obj.hDSProject.invoke('StoreTemplateSetting', setting, value);
        end
        function SetApplicationName(obj, name)
            % Sets the application name ("EMS", "PS", "MWS", "MS",  "DS for MWS", "DS for PCBS", "DS for CS", "DS for MS", "DS"). Use this function for developing a result template.
            obj.hDSProject.invoke('SetApplicationName', name);
        end
        function ResetApplicationName(obj)
            % Reset the application name to the default name. Use this function for developing a result template.
            obj.hDSProject.invoke('ResetApplicationName');
        end
        function ResetTemplateIterator(obj)
            % Resets the template iterator to the beginning of the list of defined result templates and clears all template filters.
            obj.hDSProject.invoke('ResetTemplateIterator');
        end
        function SetTemplateFilter(obj, filtername, value)
            % Sets a filter for the template iterator which iterates over the list of defined result templates. Allowed values for 'filtername' are "resultname", "type", "templatename" and "folder". If 'filtername' is set to 'type' , then 'value'  can be "0D", "1D", "1DC", "M0D", "M1D", or "M1DC". For all other filternames, 'value' can be an arbitrary string.
            obj.hDSProject.invoke('SetTemplateFilter', filtername, value);
        end
        function bool = GetNextTemplate(obj, resultname, type, templatename, folder)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetNextTemplate''.');
            bool = nan;
            return;
            % Fills the parameter variables with the data of the next template of the list of defined result templates. The variable "resultname" will be filled with the result name of the defined template, e.g. "S11". The variable "type" will be filled with the type of the current result template and can be "0D", "1D", "1DC", "M0D", "M1D" or "M1DC". The variable "templatename" will be filled with the name of the template definition file, e.g. "S-Parameter (1D)". The variable "folder" will be filled with the relative folder where the template definition file is located (e.g. "Farfield and Antenna Properties"). If a filter was defined (see SetTemplateFilter) the method only returns the data of templates that match the filter. If the end of the template list is reached or no more templates are present that meet the defined filter, the method returns false. The method requires ResetTemplateIterator to be called in advance.
            % The following example shows all defined 0D Templates:
            % Dim Resultname As String, Templatetype As String, Templatename As String, Folder As String
            % ResetTemplateIterator
            % SetTemplateFilter("type","0D")
            % While (GetNextTemplate( Resultname, Templatetype, Templatename, Folder) = True)
            % MsgBox(Resultname & vbNewLine & Templatetype & vbNewLine & Templatename & vbNewLine & Folder)
            % Wend
            % GetFileType( string filename) string
            % Checks the file type of the file with absolute path specified in the variable 'filename'. If the file is a complex signal file, the string "complex" will be returned. If the file is a real-valued signal file, the string "real" will be returned. If the file is a real-valued 0D file, the string "real0D" will be returned. If the file is a complex-valued 0D file, the string "complex0D" will be returned. If the file type is unknown or the file can not be found, "unknown" will be returned.
            bool = obj.hDSProject.invoke('GetNextTemplate', resultname, type, templatename, folder);
        end
        function Result1DComplex = GetImpedanceFromTreeItem(obj, treename)
            % If the 1D tree item with the name 'treename' can be visualized as a Smith Chart, this method returns a Result1DComplex object filled with the corresponding impedance data. If no impedance data is available, this method returns an empty Result1DComplex object.
            Result1DComplex = obj.hDSProject.invoke('GetImpedanceFromTreeItem', treename);
        end
        function string = GetFirstTableResult(obj, resultname)
            % Returns the name of the table that was created on evaluation of the template with the name 'resultname' or an empty string.
            string = obj.hDSProject.invoke('GetFirstTableResult', resultname);
        end
        function string = GetNextTableResult(obj, resultname)
            % If the template created more than one table on evaluation, this method returns the names of next table that was created on evaluation of the template with the name 'resultname'. If no more table names are available, this method returns an empty string. Please note that GetFirstTableName needs to be called before and that this method needs to be called with the same value for parameter 'resultname'.
            string = obj.hDSProject.invoke('GetNextTableResult', resultname);
        end
        function bool = GetTemplateAborted(obj)
            % Returns true if the user aborted the template based post-processing evaluation, otherwise false.
            bool = obj.hDSProject.invoke('GetTemplateAborted');
        end
        function string = GetActivePostprocessingTask(obj)
            % Returns the tree path of the running Post-Processing task or an empty string.
            string = obj.hDSProject.invoke('GetActivePostprocessingTask');
        end
        %% Macros
        function string = GetMacroPath(obj)
            % Returns the directory, that has been set as preferential location for globally defined macros.
            string = obj.hDSProject.invoke('GetMacroPath');
        end
        function string = GetMacroPathFromIndex(obj, index)
            % Returns the indexth directory, that has been set as location for globally defined macros.
            string = obj.hDSProject.invoke('GetMacroPathFromIndex', index);
        end
        function RunAndWait(obj, command)
            % Executes a 'command' and waits with the execution of the current VBA-Script until 'command' has finished. The VBA-command shell in contrast, executes a command in a second thread such that the execution of the script continues. 'command' is the command to be executed. For instance every properly installed program on the current computer can be started.
            obj.hDSProject.invoke('RunAndWait', command);
        end
        function RunMacro(obj, macroname)
            % Starts the execution of a macro.
            obj.hDSProject.invoke('RunMacro', macroname);
        end
        function RunScript(obj, scriptname)
            % Reads the script input of a file.
            obj.hDSProject.invoke('RunScript', scriptname);
        end
        function ReportInformationToWindow(obj, message)
            % Reports an information message to the user. This is either be done in the solver's logfile (if a solver is currently running) or in a message box.
            obj.hDSProject.invoke('ReportInformationToWindow', message);
        end
        function ReportWarningToWindow(obj, message)
            % Reports a warning message to the user. This is either be done in the solver's logfile (if a solver is currently running) or in a message box.
            obj.hDSProject.invoke('ReportWarningToWindow', message);
        end
        function ReportError(obj, message)
            % Reports an error message to the user. This is either be done in the solver's logfile (if a solver is currently running) or in a message box. The currently active VBA command evaluation will be stopped immediately. An On Error Goto statement will be able to catch this error.
            obj.hDSProject.invoke('ReportError', message);
        end
        %% Result Curve Handling
        function StoreCurvesInASCIIFile(obj, file_name)
            % Stores the selected 1D or 2D plot in the specified filename as ASCII data.
            obj.hDSProject.invoke('StoreCurvesInASCIIFile', file_name);
        end
        function StoreCurvesInClipboard(obj)
            % Stores the selected 1D or 2D plot in the clipboard.
            obj.hDSProject.invoke('StoreCurvesInClipboard');
        end
        %% Result Data Access
%         function Result1D(obj, file_name)
%             % Creates a Result1D object with the given file. If file_name is empty, an empty object is created.
%             obj.hDSProject.invoke('Result1D', file_name);
%         end
        function CalculateFourierComplex(obj, Input, InputUnit, Output, OutputUnit, isign, normalization, vMin, vMax, vSamples)
            % This VBA command computes the integral:
            % %
            % f(u) represents an arbitrarily sampled input signal Input. The meaning of u and v abscissas depends on the values specified via InputUnit and OutputUnit. Allowed values and the corresponding project units are:
            % %
            % Unit string value
            % Unit
            % "time"
            % TIME UNIT
            % "frequency"
            % FREQUENCY UNIT
            % "angularfrequency"
            % RADIAN x FREQUENCY UNIT
            % "space"
            % LENGTH UNIT
            % "wavenumber"
            % 1/LENGTH UNIT
            % "angularwavenumber"
            % RADIAN/LENGTH UNIT
            % %
            % vMin and vMax speficy the desired data interval in transformed coordinates and vSamples defines the desired number of equidistant samples. Only time-frequency and space-wavenumber space transforms are supported. Frequency and wavenumber functions are related as follows to their angular frequency/wavenumber counterparts:
            % %
            % No further scaling is applied. isign controls the sign of the exponent to affect a forward or a backward transform. The argument normalization may assume any value, depending on the employed normalization convention. However, forward and backward transform normalizations must always guarantee:
            % %
            % Fourier transform conventions adopted by  CST MICROWAVE STUDIO® are:
            % %
            % CalculateFourierComplex(Signal, "time", Spectrum, "frequency", "-1", "1.0", ...)
            % CalculateFourierComplex(Spectrum, "frequency", Signal, "time", "+1", "1.0/(2.0*Pi)", ...)
            obj.hDSProject.invoke('CalculateFourierComplex', Input, InputUnit, Output, OutputUnit, isign, normalization, vMin, vMax, vSamples);
        end
        function CalculateCONV(obj, seuence_a, Result1Dsequence_b, sequence_conv)
            % This method calculates the convolution of two sequences. All signals are given asResult1D objects.
            % sequence_a
            % First sequence to be convoluted.
            % sequence_b
            % Second sequence to be convoluted.
            % sequence_conv
            % Convolution of sequence_a and sequence_b
            obj.hDSProject.invoke('CalculateCONV', seuence_a, Result1Dsequence_b, sequence_conv);
        end
        function CalculateCROSSCOR(obj, a, b, corr, bNorm)
            % This method calculates the cross correlation sequence of two sequences. All signals are given as Result1D objects. If "bNorm" is "False"  then the standard cross correlation sequence is calculated by the following equation.
            % %
            % For "bNorm = True" a normed correlation sequence is determined. The resulting sequence will have values in the interval [-1,1] and will be independent to scalar multiplication of the sequences "a" and "b".  This normed sequence is derived from the term below.
            % %
            % Please note that "corr" may have a different sampling than "a" and "b". An internal resampling is done to assure compatibility of the x-values of the processed sequences.
            % a
            % First sequence to be correlated.
            % b
            % Second sequence to be correlated.
            % corr
            % Sequence of correlation coefficients of the sequences above.
            % bNorm
            % Flag if normed or standard correlation is calculated.
            obj.hDSProject.invoke('CalculateCROSSCOR', a, b, corr, bNorm);
        end
        function DeleteResults(obj)
            % Deletes all results of the actual project.
            obj.hDSProject.invoke('DeleteResults');
        end
        %% Queries
        function string = GetApplicationName(obj)
            % Returns the application name.
            string = obj.hDSProject.invoke('GetApplicationName');
        end
        function string = GetApplicationVersion(obj)
            % Returns the current version number as a string.
            string = obj.hDSProject.invoke('GetApplicationVersion');
        end
        function string = GetInstallPath(obj)
            % Returns the path where the program is installed.
            string = obj.hDSProject.invoke('GetInstallPath');
        end
        function string = GetProjectPath(obj, path_id)
            % Returns the path to the project's sub-folder specified by path_id. Valid settings for path_id are:
            % "Root"
            % Returns the path to the folder where the project file is stored, e.g. "c:\test" for a project stored under "c:\test\project.cst".
            % "Project"
            % Returns the path to the project's main folder, e.g. "c:\test\project" for a project stored under "c:\test\project.cst".
            % "Model3D"
            % Returns the path to the sub-folder where all 3D model information is stored.
            % "ModelDS"
            % Returns the path to the sub-folder where all model information is stored. Any project settings can be restored with the files located there.
            % "ModelCacheDS"
            % Returns the path to the sub-folder where additional model information is stored that is used to speed up some updates, etc.
            % "ResultDS"
            % Returns the path to the sub-folder where result data are stored that have been generated while executing the simulation tasks or added by a parameter sweep or by the template based post-processing.
            % "ResultDSGeneric"
            % Returns the path to the sub-folder where result data are stored that have been added by the user.
            % "TempDS"
            % Returns the path to a temporary sub-folder where temporary data is stored for the current session.
            string = obj.hDSProject.invoke('GetProjectPath', path_id);
        end
        function string = GetProjectSeparator(obj)
            % Gets the separator character used for separating the project's base name from specific result file endings. Currently the default separator character is the hat separator "^".
            string = obj.hDSProject.invoke('GetProjectSeparator');
        end
        function object = GetOwnProject(obj)
            % Returns the COM interface of the current project.
            object = obj.hDSProject.invoke('GetOwnProject');
        end
        function object = GetSimulationProject(obj, name)
            % Returns the COM interface of the simulation project.
            object = obj.hDSProject.invoke('GetSimulationProject', name);
        end
        function string = GetLicenseHostId(obj)
            % Gets the host id for the currently used license (hardlock). This information may be useful for support purposes.
            string = obj.hDSProject.invoke('GetLicenseHostId');
        end
        function string = GetLicenseCustomerNumber(obj)
            % Gets the current customer number from the license. This information may be useful for support purposes.
            string = obj.hDSProject.invoke('GetLicenseCustomerNumber');
        end
        function bool = SchematicBlockPinsEnabled(obj)
            % Gets whether the pins of the schematic block are enabled. This can only be called for 3D projects, since no schematic block exists in pure CST DS projects.
            bool = obj.hDSProject.invoke('SchematicBlockPinsEnabled');
        end
        %% Result Plotting
        function string = ResultNavigatorRequest(obj, request, parameter)
            % Sends modification requests or queries to the Result Navigator. Allowed strings for request are "set selection", "get selection", "reset selection". The expected format of the string parameter and the return value of the function depend on the request. The function requires a preselected 1D or 0D result in the Navigation Tree, which can be achieved by a preceding call of SelectTreeItem. If no 1D Plot is selected, the method will return an error.
            % The request "set selection" allows modifying the selection state of the Result Navigator and expects parameter to be a string containing a whitespace separated list of non-negative integers which correspond to Run IDs to be selected. The return value of the function will be an empty string. The following example shows how to select and plot parametric s-parameters from the Navigation Tree:
            % SelectTreeItem("Tasks\SPara1\S-Parameters")
            % Dim selection As String
            % selection = Join(Array(0,1,5)) 'selection = "0 1 5"
            % ResultNavigatorRequest("set selection",selection)
            % The request "get selection" queries the current selection state of the Result Navigator and returns a string containing a whitespace separated list of integers which correspond to the selected Run IDs. The variable parameter is ignored. The following example shows how to query the selected parametric results and print the selection to the message window:
            % SelectTreeItem("Tasks\SPara1\S-Parameters")
            % ReportInformationToWindow( ResultNavigatorRequest("get selection","") )'print current selection to message window
            % The request "reset selection" resets the selection state of the Result Navigator to default behavior (similar to "Reset Selection" in the context menu). The variable parameter is ignored and the return value of the function will be an empty string. The following example shows how to reset the selection in the Result Navigator:
            % SelectTreeItem("Tasks\SPara1\S-Parameters")
            % ResultNavigatorRequest("reset selection","") 'reset Result Navigator selection state to default behavior
            string = obj.hDSProject.invoke('ResultNavigatorRequest', request, parameter);
        end
        %% View
        function StoreViewInBmpFile(obj, file_name)
            % Stores the contents of the main view into a bitmap file defined by 'file_name'.
            % Example: StoreViewInBmpFile ("MyPicture.bmp")
            obj.hDSProject.invoke('StoreViewInBmpFile', file_name);
        end
        
        function StoreViewInClipboard(obj)
            % Stores the contents of the main window to the clipboard as a bitmap.
            obj.hDSProject.invoke('StoreViewInClipboard');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        hDSProject
    end
    %% Matlab interface Project functions.
    properties(Access = protected)
        arraytask                   CST.DS.ArrayTask
        block                       CST.DS.Block
        circuitprobe                CST.DS.CircuitProbe
        connectionlabel             CST.DS.ConnectionLabel
        externalport                CST.DS.ExternalPort
        link                        CST.DS.Link
        networkparameterextraction  CST.DS.NetworkParameterExtraction
        optimizer                   CST.DS.Optimizer
        parametersweep              CST.DS.ParameterSweep
%         result0d                    CST.DS.Result0D
%         result1d                    CST.DS.Result1D
%         result1dcomplex             CST.DS.Result1DComplex
        resulttree                  CST.DS.ResultTree
        simulationtask              CST.DS.SimulationTask
%         table                       CST.DS.Table
        units                       CST.DS.Units
    end
    methods
        function arraytask = ArrayTask(obj)
            if(isempty(obj.arraytask))
                obj.arraytask = CST.DS.ArrayTask(obj, obj.hDSProject);
            end
            arraytask = obj.arraytask;
        end
        
        function block = Block(obj)
            if(isempty(obj.block))
                obj.block = CST.DS.Block(obj, obj.hDSProject);
            end
            block = obj.block;
        end
        
        function circuitprobe = CircuitProbe(obj)
            if(isempty(obj.circuitprobe))
                obj.circuitprobe = CST.DS.CircuitProbe(obj, obj.hDSProject);
            end
            circuitprobe = obj.circuitprobe;
        end
        
        function connectionlabel = ConnectionLabel(obj)
            if(isempty(obj.connectionlabel))
                obj.connectionlabel = CST.DS.ConnectionLabel(obj, obj.hDSProject);
            end
            connectionlabel = obj.connectionlabel;
        end
        
        function externalport = ExternalPort(obj)
            if(isempty(obj.externalport))
                obj.externalport = CST.DS.ExternalPort(obj, obj.hDSProject);
            end
            externalport = obj.externalport;
        end
        
        function link = Link(obj)
            if(isempty(obj.link))
                obj.link = CST.DS.Link(obj, obj.hDSProject);
            end
            link = obj.link;
        end
        
        function networkparameterextraction = NetworkParameterExtraction(obj)
            if(isempty(obj.networkparameterextraction))
                obj.networkparameterextraction = CST.DS.NetworkParameterExtraction(obj, obj.hDSProject);
            end
            networkparameterextraction = obj.networkparameterextraction;
        end
        
        function optimizer = Optimizer(obj)
            if(isempty(obj.optimizer))
                obj.optimizer = CST.DS.Optimizer(obj, obj.hDSProject);
            end
            optimizer = obj.optimizer;
        end
        
        function parametersweep = ParameterSweep(obj)
            if(isempty(obj.parametersweep))
                obj.parametersweep = CST.DS.ParameterSweep(obj, obj.hDSProject);
            end
            parametersweep = obj.parametersweep;
        end
        
        function result0d = Result0D(obj, resultname)
%             if(isempty(obj.result0d))
%                 obj.result0d = CST.Result0D(obj, obj.hDSProject, resultname);
%             end
%             result0d = obj.result0d;

            % Each result0d can be different depending on resultname.
            % So don't store it.
            result0d = CST.Result0D(obj, obj.hDSProject, resultname);
        end
        
        function result1d = Result1D(obj, resultname)
%             if(isempty(obj.result1d))
%                 obj.result1d = CST.Result1D(obj, obj.hDSProject, resultname);
%             end
%             result1d = obj.result1d;

            % Each result1d can be different depending on resultname.
            % So don't store it.
            result1d = CST.Result1D(obj, obj.hDSProject, resultname);
        end
        
        function result1dcomplex = Result1DComplex(obj, resultname)
%             if(isempty(obj.result1dcomplex))
%                 obj.result1dcomplex = CST.Result1DComplex(obj, obj.hDSProject, resultname);
%             end
%             result1dcomplex = obj.result1dcomplex;

            % Each result1d can be different depending on resultname.
            % So don't store it.
            result1dcomplex = CST.Result1DComplex(obj, obj.hDSProject, resultname);
        end
        
        function resulttree = ResultTree(obj)
            if(isempty(obj.resulttree))
                obj.resulttree = CST.DS.ResultTree(obj, obj.hDSProject);
            end
            resulttree = obj.resulttree;
        end
        
        function simulationtask = SimulationTask(obj)
            if(isempty(obj.simulationtask))
                obj.simulationtask = CST.DS.SimulationTask(obj, obj.hDSProject);
            end
            simulationtask = obj.simulationtask;
        end
        
        function table = Table(obj, path)
%             if(isempty(obj.table))
%                 obj.table = CST.Table(obj, obj.hDSProject, path);
%             end
%             table = obj.table;

            % Each table can be different depending on path, so don't store it.
            table = CST.Table(obj, obj.hDSProject, path);
        end
        
        function units = Units(obj)
            if(isempty(obj.units))
                obj.units = CST.DS.Units(obj, obj.hDSProject);
            end
            units = obj.units;
        end
    end
end

%% Default Settings
%  

%% Example - Taken from CST documentation and translated to MATLAB.
