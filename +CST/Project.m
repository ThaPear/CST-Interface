%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The Project Object offers miscellaneous functions concerning the program in general.
classdef Project < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Application)
        % Only CST.Application can create a Project object.
        function obj = Project(hProject)
            obj.hProject = hProject;
        end
    end
    %% CST Object functions.
    methods
        function ResetAll(obj)
            % Resets the actual project. All results will be deleted and all internal data structures will be reset to default values. However, the History List and the parameters will not be affected. You may restore the project (except for the results) with the Rebuild Function.
            obj.hProject.invoke('ResetAll');
        end
        function ScreenUpdating(obj, boolean)
            % Switches the update of the results of the main view during the simulation on and off.
            obj.hProject.invoke('ScreenUpdating', boolean);
        end
        function SelectQuickStartGuide(obj, type)
            % Sets the kind of QuickStartGuide.
            % type: 'Transient'
            %       'Eigenmode'
            %       'Frequency Domain'
            %       'Electrostatic'
            %       'Magnetostatic'
            %       'Stationary Current'
            %       'Low Frequency'
            %       'Particle Tracking'
            %       'Electrostatic'
            %       'Magnetostatic'
            %       'Particle Tracking'
            obj.hProject.invoke('SelectQuickStartGuide', type);
        end
        function bool = SelectTreeItem(obj, itemname)
            % Selects the tree Item, specified by name. The main view will be updated according to the selection. A tree Item that is not the root Item may be specified by the full path. The return value is True if the selection was successful.
            % Example: SelectTreeItem ("Components\component1\solid1")
            bool = obj.hProject.invoke('SelectTreeItem', itemname);
        end
        function long = GetNumberOfSelectedTreeItems(obj)
            % Returns the number of tree items which are currently selected.
            long = obj.hProject.invoke('GetNumberOfSelectedTreeItems');
        end
        function string = GetSelectedTreeItem(obj)
            % Returns the path name of the currently selected tree item or folder with regard to the root of the tree.
            % Example: If a solid named "solid1" is selected in the "component1" folder of the "Components" folder, the returned path name will be "Components\component1\sold1".
            string = obj.hProject.invoke('GetSelectedTreeItem');
        end
        function string = GetNextSelectedTreeItem(obj)
            % Returns the path name of the next selected tree item or folder if multiple items are selected. You need to use GetSelectedTreeItem  once before using this command.
            % Example: If a solid named "solid1" is selected in the "component1" folder of the "Components" folder, the returned path name will be "Components\component1\sold1".
            string = obj.hProject.invoke('GetNextSelectedTreeItem');
        end
        function SetLock(obj, boolean)
            % Disables the interaction. No user actions can be made. After a VBA-Script has been executed, SetLock is automatically reset to False.
            obj.hProject.invoke('SetLock', boolean);
        end
        function bool = AddToHistory(obj, caption, contents)
            % Adds a new entry to the history list entitled caption. The contents of the entry is stored in contents. This contents is executed through the VBA interpreter if this method is called. Therefore it must contain valid VBA commands. If the new entry could be created and the contents could be executed AddToHistory returns True, otherwise False.
            % If the previous history block has the same caption, it is assumed that it has the same content, it will be removed, in order to keep the history slim.
            if(nargin == 2)
                contents = caption;
            end
            ret = obj.hProject.invoke('AddToHistory', caption, contents);
            if(~ret)
                breakpoint;
                error(['Could not execute command ', newline, '''', caption, ''', ', newline, '''', contents, '''']);
            end
        end
        function PositionWindow(obj, location, handle)
            % This functions sets the position of a window relatively to the location of the main application window. The following settings are valid locations:
            % "center"
            % Position the window in the center of the main application window
            % "top left"
            % Position the window in the top left corner of the main application window
            % "top right"
            % Position the window in the top right corner of the main application window
            % "bottom left"
            % Position the window in the bottom left corner of the main application window
            % "bottom right"
            % Position the window in the bottom right corner of the main application
            %  window
            % The window which needs to be positioned is specified by its window handle. The typical usage of this function is in the initialization part of a user defined dialog box function as shown in the example below:
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
            obj.hProject.invoke('PositionWindow', location, handle);
        end
        function string = GetDataBaseValue(obj, key)
            % Provide access to the settings database. Returnes the data base value specified by key as a string.
            string = obj.hProject.invoke('GetDataBaseValue', key);
        end
        function string = GetDataBaseArrayValue(obj, key, index)
            % Provide access to the settings database. Returnes the data base value specified by key as a string.
            string = obj.hProject.invoke('GetDataBaseArrayValue', key, index);
        end
        function ChangeSolverType(obj, type)
            % Switch to another solver. Valid solver types are: "HF Time Domain", "HF Eigenmode", "HF Frequency Domain", "HF IntegralEq", "HF Multilayer", "HF Asymptotic", "LF EStatic", "LF MStatic", "LF Stationary Current", "LF Frequency Domain", "LF Time Domain (MQS)", "PT Tracking", "PT Wakefields", "PT PIC", "Thermal Steady State", "Thermal Transient",  "Mechanics".
            obj.hProject.invoke('ChangeSolverType', type);
        end
        function string = GetSolverType(obj)
            % Returns the currently active solver.
            string = obj.hProject.invoke('GetSolverType');
        end
        function string = ImportSubProject(obj, filename, do_wcs_alignment)
            % This function performs a subproject import and adds the command into the history. filename is the name of the project which will be imported. And with do_wcs_alignment it can be specified if the sub project will be imported into the currently active WCS. If an error occurs during the import, the error message will be returned.
            string = obj.hProject.invoke('ImportSubProject', filename, do_wcs_alignment);
        end
        function Backup(obj, filename)
            % Creates a copy of the actual project and its results. The current project is not affected. 'filename' is the name of the copy.
            obj.hProject.invoke('Backup', filename);
        end
        function FileNew(obj)
            % Resets the entire program. A new unnamed project will be opened.
            obj.hProject.invoke('FileNew');
        end
        function OpenFile(obj, filename)
            % Opens an existing project. A previous project will be closed. 'filename' is the name of the project to be opened.
            obj.hProject.invoke('OpenFile', filename);
        end
        function Quit(obj)
            % Closes the program without saving unless the structure of the project has been changed.
            obj.hProject.invoke('Quit');
        end
        function Save(obj)
            % Saves the current state of the project, including all results obtained so far.
            obj.hProject.invoke('Save');
        end
        function SaveAs(obj, filename, include_results)
            % Saves the current state of the project, including all results obtained so far (optional with 'include_results''). 'filename' is the name of the project to be opened.
            obj.hProject.invoke('SaveAs', filename, include_results);
        end
        function StoreInArchive(obj, filename, keepAllResults, keep1DResults, keepFarfieldData, deleteProjFolder)
            % Stores a project in a zip-file with the specified settings. You have the choice to
            % include different sets of files. Either you include all calculated results
            % ('keepAllResults'') or you can keep the calculated 1D results ('keep1DResults'')
            % and/or the calculated farfield data ('keepFarfieldData').  'filename' is the name of
            % the project to be archived as well as the destination of the zip-file. The last option
            % is to delete the project  folder. Note that the project folder has to be deleted if
            % none of the result/data files are included.
            obj.hProject.invoke('StoreInArchive', filename, keepAllResults, keep1DResults, keepFarfieldData, deleteProjFolder);
        end
        function DeleteParameter(obj, name)
            % Deletes an existing parameter with the specified name.
            obj.hProject.invoke('DeleteParameter', name);
        end
        function bool = DoesParameterExist(obj, name)
            % Returns if a parameter with the given name exists.
            bool = obj.hProject.invoke('DoesParameterExist', name);
        end
        function long = GetNumberOfParameters(obj)
            % Returns the number of parameters defined so far.
            long = obj.hProject.invoke('GetNumberOfParameters');
        end
        function string = GetParameterName(obj, index)
            % Returns the name of the parameter referenced by the given index. The first parameter is reference by the index 0.
            string = obj.hProject.invoke('GetParameterName', index);
        end
        function double = GetParameterNValue(obj, index)
            % Returns the value of the double parameter referenced by the given index. The first parameter is referenced by the index 0.
            double = obj.hProject.invoke('GetParameterNValue', index);
        end
        function string = GetParameterSValue(obj, index)
            % Returns the numerical expression for the parameter referenced by the given index. The first parameter is referenced by the index 0.
            string = obj.hProject.invoke('GetParameterSValue', index);
        end
        function RenameParameter(obj, oldName, newName)
            % Change the name of existing parameter 'oldName' to 'newName'.
            obj.hProject.invoke('RenameParameter', oldName, newName);
        end
        function string = RestoreParameter(obj, name)
            % Gets the value of the specified string parameter.
            string = obj.hProject.invoke('RestoreParameter', name);
        end
        function double = RestoreDoubleParameter(obj, name)
            % Gets the value of a specified double parameter.
            double = obj.hProject.invoke('RestoreDoubleParameter', name);
        end
        function string = RestoreParameterExpression(obj, name)
            % Gets the numerical expression for the specified string parameter.
            string = obj.hProject.invoke('RestoreParameterExpression', name);
        end
        function StoreParameterWithDescription(obj, name, value, description)
            % Creates a new string parameter or changes an existing one, with the specified string value and the description.
            obj.hProject.invoke('StoreParameterWithDescription', name, value, description);
        end
        function StoreParameter(obj, name, value)
            % Creates a new string parameter or changes an existing one, with the specified string value.
            obj.hProject.invoke('StoreParameter', name, value);
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
            obj.hProject.invoke('StoreParameters', names, values);
        end
        function StoreDoubleParameter(obj, name, value)
            % Creates a new double parameter or changes an existing one, with the specified double value.
            obj.hProject.invoke('StoreDoubleParameter', name, value);
        end
        function MakeSureParameterExists(obj, name, value)
            % Makes sure that the parameter name is available. If it is already defined it is left unchanged. If there is no parameter name, it is created with the specified value.
            obj.hProject.invoke('MakeSureParameterExists', name, value);
        end
        function SetParameterDescription(obj, name, description)
            % Defines the description for a given parameter, which is specified by its name.
            obj.hProject.invoke('SetParameterDescription', name, description);
        end
        function string = GetParameterDescription(obj, name)
            % Returns the description of a given parameter, which is specified by its name.
            string = obj.hProject.invoke('GetParameterDescription', name);
        end
        function bool = GetParameterCombination(obj, resultID, parameterNames, parameterValues)
            % Fills the variant 'parameterValues'  with an array of double values that correspond to the parameter combination 'resultID' . The variant 'parameterNames' is filled with an array containing the parameter names. In case the parameter combination does not exist, the variants will not be modified and the method will return false. The string 'resultID'  corresponds to an existing Run ID and is of the format "3D:RunID:1". Existing Result IDs can be queried using the command GetResultIDsFromTreeItem of the ResultTree-object. The method returns an error for Result IDs of invalid format. The following example prints parameter names and parameter values to the message window:
            % Dim names As Variant, values As Variant, exists As Boolean
            % exists = GetParameterCombination( "3D:RunID:1", names, values )
            % If Not exists Then
            % ReportInformationToWindow( "Parameter combination does not exist."  )
            % Else
            % Dim N As Long
            % For N = 0 To UBound( values )
            % ReportInformationToWindow( names( N )  + ": " + CStr( values( N ) ) )
            % Next
            % End If
            bool = obj.hProject.invoke('GetParameterCombination', resultID, parameterNames, parameterValues);
        end
        function ClearGlobalDataValues(obj)
            % Clear all global data values.
            obj.hProject.invoke('ClearGlobalDataValues');
        end
        function DeleteGlobalDataValue(obj, name)
            % Delete a global data value with a given name.
            obj.hProject.invoke('DeleteGlobalDataValue', name);
        end
        function string = RestoreGlobalDataValue(obj, name)
            % Returnes a global data value with a given name.
            string = obj.hProject.invoke('RestoreGlobalDataValue', name);
        end
        function StoreGlobalDataValue(obj, name, value)
            % Creates a new global data value with a given name and value or changes an existing one.
            obj.hProject.invoke('StoreGlobalDataValue', name, value);
        end
        function double = ACos(obj, value)
            % Returns the arc cosine of the input parameter as a radian value.
            double = obj.hProject.invoke('ACos', value);
        end
        function double = ACosD(obj, value)
            % Returns the arc cosine of the input parameter in degree.
            double = obj.hProject.invoke('ACosD', value);
        end
        function double = ASin(obj, value)
            % Returns the arc sine of the input parameter as a radian value.
            double = obj.hProject.invoke('ASin', value);
        end
        function double = ASinD(obj, value)
            % Returns the arc sine of the input parameter in degree.
            double = obj.hProject.invoke('ASinD', value);
        end
        function double = ATnD(obj, value)
            % Returns the arc tangent of the input parameter in degree.
            double = obj.hProject.invoke('ATnD', value);
        end
        function double = ATn2(obj, value1, value2)
            % Returns the arc tangent of the relation of value1 to value2 as a radian value.
            % value1
            % Numerator of the arc tangent calculation.
            % value2
            % Denominator of the arc tangent calculation.
            double = obj.hProject.invoke('ATn2', value1, value2);
        end
        function double = ATn2D(obj, value1, value2)
            % Returns the arc tangent of the relation of value1 to value2 in degree.
            % value1
            % Numerator of the arc tangent calculation.
            % value2
            % Denominator of the arc tangent calculation.
            double = obj.hProject.invoke('ATn2D', value1, value2);
        end
        function double = CLight(obj)
            % Returns the constant value for the speed of light in vacuum.
            double = obj.hProject.invoke('CLight');
        end
        function double = CosD(obj, value)
            % Returns the cosine of the input parameter in degree.
            double = obj.hProject.invoke('CosD', value);
        end
        function double = Eps0(obj)
            % Returns the constant value for the permittivity of vacuum.
            double = obj.hProject.invoke('Eps0');
        end
        function double = Evaluate(obj, expression)
            % Evaluates and returns the numerical double result of a string expression.
            double = obj.hProject.invoke('Evaluate', expression);
        end
        function double = im(obj, amplitude, phase)
            % Calculates the imaginary part of a complex number defined by its amplitude and phase.
            double = obj.hProject.invoke('im', amplitude, phase);
        end
        function double = Mu0(obj)
            % Returns the constant value for the permeability of vacuum.
            double = obj.hProject.invoke('Mu0');
        end
        function double = Pi(obj)
            % Returns the constant value of Pi.
            double = obj.hProject.invoke('Pi');
        end
        function double = re(obj, amplitude, phase)
            % Calculates the real part of a complex number defined by its amplitude and phase.
            double = obj.hProject.invoke('re', amplitude, phase);
        end
        function double = SinD(obj, value)
            % Returns the sine of the input parameter in degree.
            double = obj.hProject.invoke('SinD', value);
        end
        function double = TanD(obj, value)
            % Returns the tangent of the input parameter in degree.
            double = obj.hProject.invoke('TanD', value);
        end
        function double = FMod(obj, value1, value2)
            % Returns the floating point remainder of value1 divided by value2.
            double = obj.hProject.invoke('FMod', value1, value2);
        end
        function ActivateScriptSettings(obj, boolean)
            % This method activates (switch = "True") or deactivates
            % (switch = "False")  the script settings of a customized
            % result item.
            obj.hProject.invoke('ActivateScriptSettings', boolean);
        end
        function ClearScriptSettings(obj)
            % This method clears the internal settings of a previously
            % customized result item.
            obj.hProject.invoke('ClearScriptSettings');
        end
        function double = GetLast0DResult(obj, name)
            % This method returns the last 0D result of the selected result
            % template. 'name' is the name of a previously defined result
            % template.
            double = obj.hProject.invoke('GetLast0DResult', name);
        end
        function Result1D = GetLast1DResult(obj, name)
            % This method returns the last 1D result of the selected result
            % template. 'name' is the name of a previously defined result
            % template.
            Result1D = obj.hProject.invoke('GetLast1DResult', name);
        end
        function Result1DComplex = GetLast1DComplexResult(obj, name)
            % This method returns the last complex 1D result of the
            % selected result template. 'name' is the name of a previously
            % defined result template.
            Result1DComplex = obj.hProject.invoke('GetLast1DComplexResult', name);
        end
        function string = GetLastResultID(obj)
            % This method returns the Result ID which identifies the last
            % result. It allows access to the last 1D or 0D result via
            % Resulttree.GetResultFromTreeItem, e.g.:
            %
            % Dim o As Object
            % Set o = Resulttree.GetResultFromTreeItem("1D Results\S-Parameters\S1,1", GetLastResultID())
            % ReportInformationToWindow("Last 1D/0D result object type: " + o.GetResultObjectType())
            string = obj.hProject.invoke('GetLastResultID');
        end
        function string = GetScriptSetting(obj, name, default_value)
            % This function is only active if a result template is
            % currently in process. It returns the internal settings of the
            % previously customized result item using the
            % StoreScriptSetting method. In case that no settings has been
            % stored, the default value will be returned.
            string = obj.hProject.invoke('GetScriptSetting', name, default_value);
        end
        function StoreScriptSetting(obj, name, value)
            % This function is only active if a result template is
            % currently in process. It offers the possibility to customize
            % the corresponding result item with help of internal settings,
            % which can be recalled using the GetScriptSetting function.
            % 'name' is the name defining the internal setting. 'value' is
            % the value of the setting.
            obj.hProject.invoke('StoreScriptSetting', name, value);
        end
        function StoreTemplateSetting(obj, setting, value)
            % This function is only active if a result template is
            % processed. It defines the type of the template and needs to
            % be set in the define method of every result template. The
            % variable 'setting' has to be the string "TemplateType". The
            % variable 'value' can be"0D", "1D", "1DC", "M0D", "M1D" or
            % "M1DC". The choice of the template type determines which
            % evaluation method of the template is called when being
            % processed and what return type is expected. More details can
            % be found on the Post-Processing Template Layout help page.
            obj.hProject.invoke('StoreTemplateSetting', setting, value);
        end
        function string = GetScriptFileName(obj)
            % Returns the file name of the currently active script.
            string = obj.hProject.invoke('GetScriptFileName');
        end
        function EvaluateResultTemplates(obj)
            % Evaluates all existing result templates. As well as after a
            % solverrun or pushing 'Evaluate All' in Template Base
            % Post-Processing dialog.
            obj.hProject.invoke('EvaluateResultTemplates');
        end
        function SetApplicationName(obj, name)
            % Sets the application name ("EMS", "PS", "MWS", "MS",  "DS for
            % MWS", "DS for PCBS", "DS for CS", "DS for MS", "DS"). Use
            % this function for developing a result template.
            obj.hProject.invoke('SetApplicationName', name);
        end
        function ResetApplicationName(obj)
            % Reset the application name to the default name. Use this function for developing a result template.
            obj.hProject.invoke('ResetApplicationName');
        end
        function ResetTemplateIterator(obj)
            % Resets the template iterator to the beginning of the list of defined result templates and clears all template filters.
            obj.hProject.invoke('ResetTemplateIterator');
        end
        function SetTemplateFilter(obj, filtername, value)
            % Sets a filter for the template iterator which iterates over the list of defined result templates. Allowed values for 'filtername' are "resultname", "type", "templatename" and "folder". If 'filtername' is set to 'type' , then 'value'  can be "0D", "1D", "1DC", "M0D", "M1D", or "M1DC". For all other filternames, 'value' can be an arbitrary string.
            obj.hProject.invoke('SetTemplateFilter', filtername, value);
        end
        function bool = GetNextTemplate(obj, resultname, type, templatename, folder)
            % Fills the parameter variables with the data of the next template of the list of defined result templates. The variable "resultname" will be filled with the result name of the defined template, e.g. "S11". The variable "type" will be filled with the type of the current result template and can be "0D", "1D", "1DC", "M0D", "M1D" or "M1DC". The variable "templatename" will be filled with the name of the template definition file, e.g. "S-Parameter (1D)". The variable "folder" will be filled with the relative folder where the template definition file is located (e.g. "Farfield and Antenna Properties"). If a filter was defined (see SetTemplateFilter) the method only returns the data of templates that match the filter. If the end of the template list is reached or no more templates are present that meet the defined filter, the method returns false. The method requires ResetTemplateIterator to be called in advance.
            % The following example shows all defined 0D Templates:
            % Dim Resultname As String, Templatetype As String, Templatename As String, Folder As String
            % ResetTemplateIterator
            % SetTemplateFilter("type","0D")
            % While (GetNextTemplate( Resultname, Templatetype, Templatename, Folder) = True)
            % MsgBox(Resultname & vbNewLine & Templatetype & vbNewLine & Templatename & vbNewLine & Folder)
            % Wend
            bool = obj.hProject.invoke('GetNextTemplate', resultname, type, templatename, folder);
        end
        function string = GetFileType(obj, filename)
            % Checks the file type of the file with absolute path specified in the variable 'filename'. If the file is a complex signal file, the string "complex" will be returned. If the file is a real-valued signal file, the string "real" will be returned. If the file is a real-valued 0D file, the string "real0D" will be returned. If the file is a complex-valued 0D file, the string "complex0D" will be returned. If the file type is unknown or the file can not be found, "unknown" will be returned.
            string = obj.hProject.invoke('GetFileType', filename);
        end
        function Result1DComplex = GetImpedanceFromTreeItem(obj, treename)
            % If the 1D tree item with the name 'treename' can be visualized as a Smith Chart, this method returns a Result1DComplex object filled with the corresponding impedance data. If no impedance data is available, this method returns an empty Result1DComplex object.
            Result1DComplex = obj.hProject.invoke('GetImpedanceFromTreeItem', treename);
        end
        function string = GetFirstTableResult(obj, resultname)
            % Returns the name of the table that was created on evaluation of the template with the name 'resultname' or an empty string.
            string = obj.hProject.invoke('GetFirstTableResult', resultname);
        end
        function string = GetNextTableResult(obj, resultname)
            % If the template created more than one table on evaluation, this method returns the names of next table that was created on evaluation of the template with the name 'resultname'. If no more table names are available, this method returns an empty string. Please note that GetFirstTableName needs to be called before and that this method needs to be called with the same value for parameter 'resultname'.
            string = obj.hProject.invoke('GetNextTableResult', resultname);
        end
        function bool = GetTemplateAborted(obj)
            % Returns true if the user aborted the template based post-processing evaluation, otherwise false.
            bool = obj.hProject.invoke('GetTemplateAborted');
        end
        function string = GetMacroPath(obj)
            % Returns the first directory, that has been set as location for globally defined macros. This function is the same as "GetMacroPathFromIndex(0)"
            string = obj.hProject.invoke('GetMacroPath');
        end
        function string = GetMacroPathFromIndex(obj, index)
            % Returns the name of the macro path referenced by the given index. The first macro path is reference by the index 0.
            string = obj.hProject.invoke('GetMacroPathFromIndex', index);
        end
        function int = GetNumberOfMacroPaths(obj)
            % Returns the number of defined macro directories.
            int = obj.hProject.invoke('GetNumberOfMacroPaths');
        end
        function RunAndWait(obj, command)
            % Executes a 'command' and waits with the execution of the current VBA-Script until 'command' has finished. The VBA-command shell in contrast, executes a command in a second thread such that the execution of the script continues. 'command' is the command to be executed. For instance every properly installed program on the current computer can be started.
            obj.hProject.invoke('RunAndWait', command);
        end
        function RunMacro(obj, macroname)
            % Starts the execution of a macro.
            obj.hProject.invoke('RunMacro', macroname);
        end
        function RunScript(obj, scriptname)
            % Reads the script input of a file.
            obj.hProject.invoke('RunScript', scriptname);
        end
        function ReportInformation(obj, message)
            % Reports the information text message to the user. The text will be written either into the output window (if a solver is currently running) or into a message dialog box.
            obj.hProject.invoke('ReportInformation', message);
        end
        function ReportWarning(obj, message)
            % Reports the warning text message to the user. The text will be written either into the output window (if a solver is currently running) or into a message dialog box.
            obj.hProject.invoke('ReportWarning', message);
        end
        function ReportInformationToWindow(obj, message)
            % Reports the information text message to the user. The text will be written into the output window.
            obj.hProject.invoke('ReportInformationToWindow', message);
        end
        function ReportWarningToWindow(obj, message)
            % Reports the warning text message to the user. The text will be written into the output window.
            obj.hProject.invoke('ReportWarningToWindow', message);
        end
        function ReportError(obj, message)
            % Reports the error text message to the user. The text will be written into a message dialog box. The currently active VBA command evaluation will be stopped immediately. An On Error Goto statement will be able to catch this error.
            obj.hProject.invoke('ReportError', message);
        end
        function SetCommonMPIClusterConfig(obj, install_folder, temp_folder, architecture)
            % Set global and common information relative to all machines in MPI cluster. It is necessary to specify, in order:
            % - the CST MICROWAVE STUDIO installation folder. This can be a local or network path.
            % This latter option enables executable depot to be maintained updated and homogeneous.
            % - the temporary folder, for data storing on remote machines.
            % - the machines architecture and Operating System (OS). This field should belong to the following set:
            % enum {"Windows IA32", " Windows AMD64", " Linux IA32”, ”r;Linux AMD64”} type
            obj.hProject.invoke('SetCommonMPIClusterConfig', install_folder, temp_folder, architecture);
        end
        function SetCommonMPIClusterLoginInfo(obj, login_user, login_private_key_file)
            % Set global and common information relative to the MPI mechanism starting a Linux cluster from a Windows frontend. To enable a password less access the Linux login mechanism actually requires:
            % - the user name which will be used as login to the Linux cluster.
            % - the user private key file location. The file may be a local one or network one stored on a location shared by all cluster machines.
            obj.hProject.invoke('SetCommonMPIClusterLoginInfo', login_user, login_private_key_file);
        end
        function long = GetMPIClusterSize(obj)
            % Return the number of machine defined in the MPI cluster.
            long = obj.hProject.invoke('GetMPIClusterSize');
        end
        function ClearMPIClusterConfig(obj)
            % Reset all entries for the machine definition in the MPI cluster.
            obj.hProject.invoke('ClearMPIClusterConfig');
        end
        function AddMPIClusterNodeConfig(obj, host_name, install_folder, temp_folder, architecture, active)
            % Add a new machine to MPI cluster, setting all its relevant properties:
            % - the CST MICROWAVE STUDIO installation folder. This can be a local or network path. If left empty, default installation folder setting is employed.
            % - the temporary folder, for data storing on remote machines. If left empty, default temporary folder setting is employed.
            % - the machines architecture and Operating System (OS). This field may belong to the following set:
            % enum {"Windows IA32", " Windows AMD64", " Linux IA32”, ” Linux AMD64”} type
            % If left empty, default architecture setting is employed.
            % - an activation flag to enable or disable the computation on the machine.
            % Example
            % The typical usage of these functions is in the initialization of a cluster of machines, to be used in solver MPI parallelization mode.
            % The following example shows the configuration of 2 nodes:
            % ' Remove previous cluster definition
            % ClearMPIClusterConfig
            % ' Set default parameters
            % SetCommonMPIClusterConfig(”r;C:\program files\MWS 2009”,”e:\temp\mpi”,”Windows IA32”)
            % ' Add active nodes (with default parameter)
            % AddMPIClusterNodeConfig (”r;Mynode1”,””,””,””,true)
            % ' Add second node specializing parameter
            % AddMPIClusterNodeConfig (”r;Mynode2”,”C:\programme\MWS 2009”,”f:\mpi”,”Windows IA32”,true)
            % ' Enable solver MPI computation
            % Solver.MPIParallelization(true)
            obj.hProject.invoke('AddMPIClusterNodeConfig', host_name, install_folder, temp_folder, architecture, active);
        end
        function ImportXYCurveFromASCIIFile(obj, folder_name, file_name)
            % Imports the data of the file "fileName" to the folder "folderName"
            obj.hProject.invoke('ImportXYCurveFromASCIIFile', folder_name, file_name);
        end
        function PasteCurvesFromASCIIFile(obj, folder_name, file_name)
            % Pastes the data of the ASCII-file "fileName" to the folder "folderName"
            obj.hProject.invoke('PasteCurvesFromASCIIFile', folder_name, file_name);
        end
        function PasteCurvesFromClipboard(obj, folder_name)
            % Pastes the clipboard contents to the folder "folderName".
            obj.hProject.invoke('PasteCurvesFromClipboard', folder_name);
        end
        function ScaleCurves(obj, folder_name, xScale, yScale)
            % Scales the x and y data rows of all 1D plot data located in the specified folder "folder_name"  of the Navigation Tree and in all its subfolders. 'folder_name' is a path or folder in the Navigation Tree. 'xScale'/'yScale' is the value multiplied with each sample of the x/y data row.
            obj.hProject.invoke('ScaleCurves', folder_name, xScale, yScale);
        end
        function StoreCurvesInASCIIFile(obj, file_name)
            % Stores the selected 1D or 2D plot in the specified filename as ASCII data.
            obj.hProject.invoke('StoreCurvesInASCIIFile', file_name);
        end
        function StoreCurvesInClipboard(obj)
            % Stores the selected 1D or 2D plot in the clipboard.
            obj.hProject.invoke('StoreCurvesInClipboard');
        end
        function CalculateFourierComplex(obj, Input, InputUnit, Output, OutputUnit, isign, normalization, vMin, vMax, vSamples)
            % This VBA command computes the integral:
            % f(u) represents an arbitrarily sampled input signal Input. The meaning of u and v abscissas depends on the values specified via InputUnit and OutputUnit. Allowed values and the corresponding project units are:
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
            % vMin and vMax speficy the desired data interval in transformed coordinates and vSamples defines the desired number of equidistant samples. Only time-frequency and space-wavenumber space transforms are supported. Frequency and wavenumber functions are related as follows to their angular frequency/wavenumber counterparts:
            % No further scaling is applied. isign controls the sign of the exponent to affect a forward or a backward transform. The argument normalization may assume any value, depending on the employed normalization convention. However, forward and backward transform normalizations must always guarantee:
            % Fourier transform conventions adopted by  CST MICROWAVE STUDIO® are:
            % CalculateFourierComplex(Signal, "time", Spectrum, "frequency", "-1", "1.0", ...)
            % CalculateFourierComplex(Spectrum, "frequency", Signal, "time", "+1", "1.0/(2.0*Pi)", ...)
            obj.hProject.invoke('CalculateFourierComplex', Input, InputUnit, Output, OutputUnit, isign, normalization, vMin, vMax, vSamples);
        end
        function CalculateCONV(obj, a, b, conv)
            % This method calculates the convolution of two sequences. All signals are given as Result1D objects.
            % a
            % First sequence to be convoluted.
            % b
            % Second sequence to be convoluted.
            % conv
            % Convolution of sequence_a and sequence_b
            obj.hProject.invoke('CalculateCONV', a, b, conv);
        end
        function CalculateCROSSCOR(obj, a, b, corr, bNorm)
            % This method calculates the cross correlation sequence of two sequences. All signals are given as Result1D objects. If "bNorm" is "False"  then the standard cross correlation sequence is calculated by the following equation.
            % For "bNorm = True" a normed correlation sequence is determined. The resulting sequence will have values in the interval [-1,1] and will be independent to scalar multiplication of the sequences "a" and "b".  This normed sequence is derived from the term below.
            % Please note that "corr" may have a different sampling than "a" and "b". An internal resampling is done to assure compatibility of the x-values of the processed sequences.
            % a
            % First sequence to be correlated.
            % b
            % Second sequence to be correlated.
            % corr
            % Sequence of correlation coefficients of the sequences above.
            % bNorm
            % Flag if normed or standard correlation is calculated.
            obj.hProject.invoke('CalculateCROSSCOR', a, b, corr, bNorm);
        end
        function DeleteResults(obj)
            % Deletes all results of the actual project.
            obj.hProject.invoke('DeleteResults');
        end
        function double = GetFieldFrequency(obj)
            % Returns the frequency of the currently plotted field. If no field is plotted, zero will be returned.
            double = obj.hProject.invoke('GetFieldFrequency');
        end
        function double = GetFieldPlotMaximumPos(obj, x, y, z)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetFieldPlotMaximumPos''.');
            double = nan;
            return;
            % Returns the maximum / minimum of the color scale and its global position of a plot without considering the manual setting of the borders. 'x', 'y', 'z' are the absolute coordinate of the maximum / minimum as return values.
            double = obj.hProject.invoke('GetFieldPlotMaximumPos', x, y, z);
        end
        function double = GetFieldPlotMinimumPos(obj, x, y, z)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetFieldPlotMinimumPos''.');
            double = nan;
            return;
            % Returns the maximum / minimum of the color scale and its global position of a plot without considering the manual setting of the borders. 'x', 'y', 'z' are the absolute coordinate of the maximum / minimum as return values.
            double = obj.hProject.invoke('GetFieldPlotMinimumPos', x, y, z);
        end
        function bool = GetFieldVector(obj, x, y, z, vxre, vyre, vzre, vxim, vyim, vzim)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetFieldVector''.');
            bool = nan;
            return;
            % Returns the complex vector field value of the currently active field plot at the given position. If the field is scalar, only the vxre component has non-zero values. If no field plot is active or the given position is out of range the function returns false.
            % x
            % X - value of the position of the desired field value.
            % y
            % Y - value of the position of the desired field value.
            % z
            % Z - value of the position of the desired field value.
            % vxre
            % Real part of the x-component of the field value.
            % vyre
            % Real part of the y-component of the field value.
            % vzre
            % Real part of the z-component of the field value.
            % vxim
            % Imaginary part of the x-component of the field value.
            % vyim
            % Imaginary part of the y-component of the field value.
            % vzim
            % Imaginary part of the z-component of the field value.
            bool = obj.hProject.invoke('GetFieldVector', x, y, z, vxre, vyre, vzre, vxim, vyim, vzim);
        end
        function ClearGeometryDataCache(obj)
            % Deletes the geometry data cache that has been built up by GetFieldVector.
            obj.hProject.invoke('ClearGeometryDataCache');
        end
        function double = GetMaxVectorLength(obj, vxre, vxim, vyre, vyim, vzre, vzim)
            % Returns the maximum / minimum absolute value of a three dimensional vector. 'vxre', 'vxim', 'very', 'vyim', 'vzre', 'vzim' are the real and imaginary part the vector's components.
            double = obj.hProject.invoke('GetMaxVectorLength', vxre, vxim, vyre, vyim, vzre, vzim);
        end
        function double = GetMinVectorLength(obj, vxre, vxim, vyre, vyim, vzre, vzim)
            % Returns the maximum / minimum absolute value of a three dimensional vector. 'vxre', 'vxim', 'very', 'vyim', 'vzre', 'vzim' are the real and imaginary part the vector's components.
            double = obj.hProject.invoke('GetMinVectorLength', vxre, vxim, vyre, vyim, vzre, vzim);
        end
        function string = GetApplicationName(obj)
            % Returns the application name.
            string = obj.hProject.invoke('GetApplicationName');
        end
        function string = GetApplicationVersion(obj)
            % Returns the current version number as a string.
            string = obj.hProject.invoke('GetApplicationVersion');
        end
        function string = GetInstallPath(obj)
            % Returns the path where the program is installed.
            string = obj.hProject.invoke('GetInstallPath');
        end
        function string = GetProjectPath(obj, type)
            % Gets the project path. If the name of the current project is Try and its location is in c:\MySolvedProblems, the result of this function will be
            % type
            % Path returned
            % Root
            % c:\MySolvedProblems
            % Project
            % c:\MySolvedProblems\Try
            % Model3D
            % c:\MySolvedProblems\Try\Model\3D
            % ModelCache
            % c:\MySolvedProblems\Try\ModelCache
            % Result
            % c:\MySolvedProblems\Try\Result
            % Temp
            % c:\MySolvedProblems\Try\Temp
            string = obj.hProject.invoke('GetProjectPath', type);
        end
        function object = GetOwnProject(obj)
            % Returns the COM interface of the current project.
            object = obj.hProject.invoke('GetOwnProject');
        end
        function bool = IsBuildingModel(obj)
            % Encounters whether the history list is currently processing or not
            bool = obj.hProject.invoke('IsBuildingModel');
        end
        function string = GetLicenseHostId(obj)
            % Gets the host id for the currently used license (hardlock). This information may be useful for support purposes.
            string = obj.hProject.invoke('GetLicenseHostId');
        end
        function string = GetLicenseCustomerNumber(obj)
            % Gets the current customer number from the license. This information may be useful for support purposes.
            string = obj.hProject.invoke('GetLicenseCustomerNumber');
        end
        function Assign(obj, variable_name)
            % This function can be used only in connection with the BeginHide/EndHide Functions. 'variable_name' is a variable, defined within a BeginHide/EndHide block, that has to be valid outside of this block.
            obj.hProject.invoke('Assign', variable_name);
        end
        function BeginHide(obj)
            % These function has an effect only if they are used in connection with the History List .
            obj.hProject.invoke('BeginHide');
        end
        function EndHide(obj)
            % These function has an effect only if they are used in connection with the History List .
            obj.hProject.invoke('EndHide');
        end
        function double = dist2d(obj, id, x, y)
            % Returns the spatial distance in 2d of a pickpoint to a specified position.
            % id
            % Number of the requested point in the pickpoint list.
            % x
            % x-coordinate of the specific position.
            % y
            % y-coordinate of the specific position.
            double = obj.hProject.invoke('dist2d', id, x, y);
        end
        function double = dist3d(obj, id, x, y, z)
            % Returns the spatial distance in 3d of a pickpoint to a specified position.
            % id
            % Number of the requested point in the pickpoint list.
            % x
            % x-coordinate of the specific position.
            % y
            % y-coordinate of the specific position.
            % z
            % z-coordinate of the specific position.
            double = obj.hProject.invoke('dist3d', id, x, y, z);
        end
        function double = ldist2D(obj, id, x1, y1, x2, y2)
            % Returns the spatial distance in 2d of a pickpoint to a line defined by two points.
            % id
            % Number of the requested point in the pickpoint list.
            % x1
            % x-coordinate of the start point of the specific line.
            % y1
            % y-coordinate of the start point of the specific line.
            % x2
            % x-coordinate of the end point of the specific line.
            % y2
            % y-coordinate of the end point of the specific line.
            double = obj.hProject.invoke('ldist2D', id, x1, y1, x2, y2);
        end
        function bool = Rebuild(obj)
            % Recreates the structure by processing the History List . All results will be deleted.
            % Returns True if the rebuild was successful.
            bool = obj.hProject.invoke('Rebuild');
        end
        function bool = RebuildOnParametricChange(obj, bfullRebuild, bShowErrorMsgBox)
            % Updates the structure after parametric changes have been made by processing the History List. Results which should survive parametric changes will be kept, all other results will be deleted.
            % If bfullRebuild is True the complete history list is processed instead of only those blocks which are affected by the parametric change. If bShowErrorMsgBox is set False no message box is shown in case of an error.
            % Returns True if the rebuild was successful.
            bool = obj.hProject.invoke('RebuildOnParametricChange', bfullRebuild, bShowErrorMsgBox);
        end
        function double = xp(obj, id)
            % Returns the x / y / z-coordinate of a specified pickpoint defined by it's number in the pickpoint list.
            double = obj.hProject.invoke('xp', id);
        end
        function double = yp(obj, id)
            % Returns the x / y / z-coordinate of a specified pickpoint defined by it's number in the pickpoint list.
            double = obj.hProject.invoke('yp', id);
        end
        function double = zp(obj, id)
            % Returns the x / y / z-coordinate of a specified pickpoint defined by it's number in the pickpoint list.
            double = obj.hProject.invoke('zp', id);
        end
        function Plot3DPlotsOn2DPlane(obj, boolean)
            % Plots a 3D field on a 2D plane if 'switch' is True.
            obj.hProject.invoke('Plot3DPlotsOn2DPlane', boolean);
        end
        function str = ResultNavigatorRequest(obj, request, parameter)
            % Sends modification requests or queries to the Result Navigator. Allowed strings for request are "set selection", "get selection", "reset selection". The expected format of the string parameter and the return value of the function depend on the request. The function requires a preselected 1D or 0D result in the Navigation Tree, which can be achieved by a preceding call of SelectTreeItem. If no 1D Plot is selected, the method will return an error.
            % The request "set selection" allows modifying the selection state of the Result Navigator and expects parameter to be a string containing a whitespace separated list of non-negative integers which correspond to Run IDs to be selected. The return value of the function will be an empty string. The following example shows how to select and plot parametric s-parameters from the Navigation Tree:
            % SelectTreeItem("1D Results\S-Parameters")
            % Dim selection As String
            % selection = Join(Array(0,1,5)) 'selection = "0 1 5"
            % ResultNavigatorRequest("set selection",selection)
            % The request "get selection" queries the current selection state of the Result Navigator and returns a string containing a whitespace separated list of integers which correspond to the selected Run IDs. The variable parameter is ignored. The following example shows how to query the selected parametric results and print the selection to the message window:
            % SelectTreeItem("1D Results\S-Parameters")
            % ReportInformationToWindow( ResultNavigatorRequest("get selection","") )'print current selection to message window
            % The request "reset selection" resets the selection state of the Result Navigator to default behavior (similar to "Reset Selection" in the context menu). The variable parameter is ignored and the return value of the function will be an empty string. The following example shows how to reset the selection in the Result Navigator:
            % SelectTreeItem("1D Results\S-Parameters")
            % ResultNavigatorRequest("reset selection","") 'reset Result Navigator selection state to default behavior
            
            % Convert all double spaces into single spaces.
            % This is added because num2str converts an array into a double-space separated string.
            while(contains(parameter, '  '))
                parameter = strrep(parameter, '  ', ' ');
            end
            str = obj.hProject.invoke('ResultNavigatorRequest', request, parameter);
        end
        function UseDistributedComputingForParameters(obj, flag)
            % Enables distributed computing for parameter sweep or optimizer runs.
            % Example: UseDistributedComputingForParameters ("True")
            obj.hProject.invoke('UseDistributedComputingForParameters', flag);
        end
        function MaxNumberOfDistributedComputingParameters(obj, num)
            % Sets the number of CST DC Solver Servers which should be used in parallel during a distribute parameter sweep / optimizer run. This is also the number of required acceleration tokens.
            % Example: MaxNumberOfDistributedComputingParameters (4)
            obj.hProject.invoke('MaxNumberOfDistributedComputingParameters', num);
        end
        function UseDistributedComputingMemorySetting(obj, flag)
            % Enables the lower memory limit for a distributed computing run.
            % Example: UseDistributedComputingMemorySetting ("True")
            obj.hProject.invoke('UseDistributedComputingMemorySetting', flag);
        end
        function MinDistributedComputingMemoryLimit(obj, lowerLimit)
            % Sets the lower limit of required memory for a distributed computing run. A CST DC Solver Server with at least lowerLimit MB available memory will be used for the job.
            % Example: MinDistributedComputingMemoryLimit (1024)
            obj.hProject.invoke('MinDistributedComputingMemoryLimit', lowerLimit);
        end
        
        %% Undocumented functions.
        % Found at https://www.researchgate.net/post/How_to_export_all_tables_obtained_from_parameter_sweep_in_CST_together
        function ExportPlotData(obj, filename)
            % Appears to do the same as the following snippet:
            % ASCIIExport.Reset();
            % ASCIIExport.FileName([exportfilename, '.txt']);
            % ASCIIExport.Execute();
            obj.hProject.invoke('ExportPlotData', filename);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        hProject
    end
    %% Matlab interface Project functions.
    properties(Access = protected)
        adscosimulation             CST.ADSCosimulation
        analyticalcurve             CST.AnalyticalCurve
        arc                         CST.Arc
        arfilter                    CST.Arfilter
        asciiexport                 CST.ASCIIExport
        asymptoticsolver            CST.AsymptoticSolver
        background                  CST.Background
        blendcurve                  CST.BlendCurve
        boundary                    CST.Boundary
        brick                       CST.Brick
        colorramp                   CST.ColorRamp
        component                   CST.Component
        curve                       CST.Curve
        cylinder                    CST.Cylinder
        discretefaceport            CST.DiscreteFacePort
        eigenmodesolver             CST.EigenmodeSolver
        evaluatefieldalongcurve     CST.EvaluateFieldAlongCurve
        evaluatefieldonface         CST.EvaluateFieldOnFace
        extrude                     CST.Extrude
        extrudecurve                CST.ExtrudeCurve
        farfieldarray               CST.FarfieldArray
        farfieldplot                CST.FarfieldPlot
        fdsolver                    CST.FDSolver
        floquetport                 CST.FloquetPort
        force                       CST.Force
        group                       CST.Group
        iesolver                    CST.IESolver
        layerstacking               CST.LayerStacking
        line                        CST.Line
        loft                        CST.Material
        material                    CST.Material
        meshadaption3d              CST.MeshAdaption3D
        meshsettings                CST.MeshSettings
        monitor                     CST.Monitor
        networkparameterextraction  CST.NetworkParameterExtraction
        optimizer                   CST.Optimizer
        parametersweep              CST.ParameterSweep
        pick                        CST.Pick
        plot                        CST.Plot
        plot1d                      CST.Plot1D
        polygon                     CST.Polygon
        polygon3d                   CST.Polygon3D
        port                        CST.Port
        postprocess1d               CST.PostProcess1D
        qfactor                     CST.QFactor
        rectangle                   CST.Rectangle
        result1d                    CST.Result1D
        resulttree                  CST.ResultTree
        solid                       CST.Solid
        solver                      CST.Solver
        solverparameter             CST.SolverParameter
        touchstone                  CST.Touchstone
        tracefromcurve              CST.TraceFromCurve
        transform                   CST.Transform_
        units                       CST.Units
        wcs                         CST.WCS
    end
    methods
        function adscosimulation = ADSCosimulation(obj)
            if(isempty(obj.adscosimulation))
                obj.adscosimulation = CST.ADSCosimulation(obj, obj.hProject);
            end
            adscosimulation = obj.adscosimulation;
        end
        
        function analyticalcurve = AnalyticalCurve(obj)
            if(isempty(obj.analyticalcurve))
                obj.analyticalcurve = CST.AnalyticalCurve(obj, obj.hProject);
            end
            analyticalcurve = obj.analyticalcurve;
        end
        
        function arfilter = Arfilter(obj)
            if(isempty(obj.arfilter))
                obj.arfilter = CST.Arfilter(obj, obj.hProject);
            end
            arfilter = obj.arfilter;
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
        
        function asymptoticsolver = AsymptoticSolver(obj)
            if(isempty(obj.asymptoticsolver))
                obj.asymptoticsolver = CST.AsymptoticSolver(obj, obj.hProject);
            end
            asymptoticsolver = obj.asymptoticsolver;
        end
        
        function background = Background(obj)
            if(isempty(obj.background))
                obj.background = CST.Background(obj, obj.hProject);
            end
            background = obj.background;
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
        
        function colorramp = ColorRamp(obj)
            if(isempty(obj.colorramp))
                obj.colorramp = CST.ColorRamp(obj, obj.hProject);
            end
            colorramp = obj.colorramp;
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
        
        function eigenmodesolver = EigenmodeSolver(obj)
            if(isempty(obj.eigenmodesolver))
                obj.eigenmodesolver = CST.EigenmodeSolver(obj, obj.hProject);
            end
            eigenmodesolver = obj.eigenmodesolver;
        end
        
        function evaluatefieldalongcurve = EvaluateFieldAlongCurve(obj)
            if(isempty(obj.evaluatefieldalongcurve))
                obj.evaluatefieldalongcurve = CST.EvaluateFieldAlongCurve(obj, obj.hProject);
            end
            evaluatefieldalongcurve = obj.evaluatefieldalongcurve;
        end
        
        function evaluatefieldonface = EvaluateFieldOnFace(obj)
            if(isempty(obj.evaluatefieldonface))
                obj.evaluatefieldonface = CST.EvaluateFieldOnFace(obj, obj.hProject);
            end
            evaluatefieldonface = obj.evaluatefieldonface;
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
        
        function farfieldarray = FarfieldArray(obj)
            if(isempty(obj.farfieldarray))
                obj.farfieldarray = CST.FarfieldArray(obj, obj.hProject);
            end
            farfieldarray = obj.farfieldarray;
        end
        
        function farfieldplot = FarfieldPlot(obj)
            if(isempty(obj.farfieldplot))
                obj.farfieldplot = CST.FarfieldPlot(obj, obj.hProject);
            end
            farfieldplot = obj.farfieldplot;
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
        
        function force = Force(obj)
            if(isempty(obj.force))
                obj.force = CST.Force(obj, obj.hProject);
            end
            force = obj.force;
        end
        
        function group = Group(obj)
            if(isempty(obj.group))
                obj.group = CST.Group(obj, obj.hProject);
            end
            group = obj.group;
        end
        
        function iesolver = IESolver(obj)
            if(isempty(obj.iesolver))
                obj.iesolver = CST.IESolver(obj, obj.hProject);
            end
            iesolver = obj.iesolver;
        end
        
        function layerstacking = LayerStacking(obj)
            if(isempty(obj.layerstacking))
                obj.layerstacking = CST.LayerStacking(obj, obj.hProject);
            end
            layerstacking = obj.layerstacking;
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
        
        function networkparameterextraction = NetworkParameterExtraction(obj)
            if(isempty(obj.networkparameterextraction))
                obj.networkparameterextraction = CST.NetworkParameterExtraction(obj, obj.hProject);
            end
            networkparameterextraction = obj.networkparameterextraction;
        end
        
        function optimizer = Optimizer(obj)
            if(isempty(obj.optimizer))
                obj.optimizer = CST.Optimizer(obj, obj.hProject);
            end
            optimizer = obj.optimizer;
        end
        
        function parametersweep = ParameterSweep(obj)
            if(isempty(obj.parametersweep))
                obj.parametersweep = CST.ParameterSweep(obj, obj.hProject);
            end
            parametersweep = obj.parametersweep;
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
        
        function qfactor = QFactor(obj)
            if(isempty(obj.qfactor))
                obj.qfactor = CST.QFactor(obj, obj.hProject);
            end
            qfactor = obj.qfactor;
        end
        
        function rectangle = Rectangle(obj)
            if(isempty(obj.rectangle))
                obj.rectangle = CST.Rectangle(obj, obj.hProject);
            end
            rectangle = obj.rectangle;
        end
        
        function result1d = Result1D(obj, resultname)
%             if(isempty(obj.result1d))
%                 obj.result1d = CST.Result1D(obj, obj.hProject, resultname);
%             end
%             result1d = obj.result1d;

            % Each result1d can be different depending on resultname.
            % So don't store it.
            result1d = CST.Result1D(obj, obj.hProject, resultname);
        end
        
        function resulttree = ResultTree(obj)
            if(isempty(obj.resulttree))
                obj.resulttree = CST.ResultTree(obj, obj.hProject);
            end
            resulttree = obj.resulttree;
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
        
        function solverparameter = SolverParameter(obj)
            if(isempty(obj.solverparameter))
                obj.solverparameter = CST.SolverParameter(obj, obj.hProject);
            end
            solverparameter = obj.solverparameter;
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