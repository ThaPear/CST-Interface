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

% The Project Object offers miscellaneous functions concerning the program in general.
classdef Project < handle
    %% CST Interface specific functions.
    methods(Access = {?CST.Application, ?CST.SimulationProject})
        % CST.Application can create a Project object.
        % CST.SimulationTask.Get3D can create a Project object.
        function obj = Project(hProject)
            obj.hProject = hProject;
            obj.captionhistory = {};
            obj.contenthistory = {};
            obj.bulkmode = 0;
            obj.nextcommandmodifiers = {};
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
            if(~isempty(obj.nextcommandmodifiers))
                for(i = length(obj.nextcommandmodifiers):-1:1)
                    modifier = obj.nextcommandmodifiers{i};
                    switch(modifier{1})
                        case 'Conditional'
                            % If condition Then [ statements ]
                            condition = modifier{2};
                            contents = [...
                                'If ', condition, ' Then', newline, ...
                                    contents, newline, ...
                                'End If', newline]; %#ok<AGROW>
                        case 'Loop'
                            % For counter = startval To endval [ Step stepval ]
                            %     [ history list item ]
                            % Next [ counter ]
                            counter = modifier{2};
                            startval = modifier{3};
                            endval = modifier{4};
                            if(length(modifier) > 4)
                                stepval = modifier{5};
                                stepstr = [' Step ', stepval];
                            else
                                stepstr = '';
                            end
                            contents = [...
                                'Dim ', counter, newline, ...
                                'For ', counter, ' = ', startval, ' To ', endval, stepstr, newline, ...
                                    contents, newline, ...
                                'Next ', counter, newline]; %#ok<AGROW>
                        otherwise
                            error('Unknown next command modifier ''%s''.', obj.nextcommandmodifier{i});
                    end
                end
                obj.nextcommandmodifiers = {};
            end
            if(obj.bulkmode)
                obj.captionhistory = [obj.captionhistory, {caption}];
                obj.contenthistory = [obj.contenthistory, {contents}];
            else
                bool = obj.hProject.invoke('AddToHistory', caption, contents);
                if(~bool)
                    error(['Could not execute command ', newline, '''', caption, ''', ', newline, '''', contents, '''']);
                end
            end
        end
        function PositionWindow(obj, location, handle)
            % This functions sets the position of a window relatively to the location of the main application window. The following settings are valid locations:
            % "center"        Position the window in the center of the main application window
            % "top left"      Position the window in the top left corner of the main application window
            % "top right"     Position the window in the top right corner of the main application window
            % "bottom left"   Position the window in the bottom left corner of the main application window
            % "bottom right"  Position the window in the bottom right corner of the main application window
            % The window which needs to be positioned is specified by its window handle. The typical usage of this function is in the initialization part of a user defined dialog box function as shown in the example below:
            % Private Function DlgFunc(DlgItem$, Action, SuppValue&) As Boolean
            %     Select Case Action
            %         Case 1 ' Dialog box initialization
            %             PositionWindow "top right", SuppValue
            %         Case 2 ' Value changing or button pressed
            %         Case 3 ' TextBox or ComboBox text changed
            %         Case 4 ' Focus changed
            %         Case 5 ' Idle
            %         Case 6 ' Function key
            %     End Select
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
            obj.AddToHistory(['ChangeSolverType "', type, '"']);
        end
        function string = GetSolverType(obj)
            % Returns the currently active solver.
            string = obj.hProject.invoke('GetSolverType');
        end
        function string = ImportSubProject(obj, filename, do_wcs_alignment)
            % This function performs a subproject import and adds the command into the history. filename is the name of the project which will be imported. And with do_wcs_alignment it can be specified if the sub project will be imported into the currently active WCS. If an error occurs during the import, the error message will be returned.
            string = obj.hProject.invoke('ImportSubProject', filename, do_wcs_alignment);
        end
        %% File Handling
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
        %% Parameter Handling
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
            % MATLAB Example:
            % names = {'param1', 'param2'};
            % values = {5, 30};
            % project.StoreParameters(names, values)
            N = length(names);
            functionString = [...
                sprintf('Dim names(1 To %i) As String, values(1 To %i) As String', N, N), newline, ...
                ];
            for(i = 1:N)
                functionString = [functionString, ...
                    sprintf('names(%i) = "%s"', i, names{i}), newline, ...
                    sprintf('values(%i) = "%s"', i, num2str(values{i}, '%.15g')), newline, ...
                    ]; %#ok<AGROW>
            end
            functionString = [functionString, ...
                'StoreParameters(names, values)', newline, ...
                ];
            returnvalues = {}; % No return values.
            obj.RunVBACode(functionString, returnvalues);
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
        function [bool, parameters] = GetParameterCombination(obj, resultID)
            % Fills the variant 'parameterValues'  with an array of double values that correspond to
            % the parameter combination 'resultID' . The variant 'parameterNames' is filled with an
            % array containing the parameter names. In case the parameter combination does not
            % exist, the variants will not be modified and the method will return false. The string
            % 'resultID'  corresponds to an existing Run ID and is of the format "3D:RunID:1".
            % Existing Result IDs can be queried using the command GetResultIDsFromTreeItem of the
            % ResultTree-object. The method returns an error for Result IDs of invalid format. The
            % following example prints parameter names and parameter values to the message window:
            % Dim names As Variant, values As Variant, exists As Boolean
            % exists = GetParameterCombination( "3D:RunID:1", names, values )
            % If Not exists Then
            %     ReportInformationToWindow( "Parameter combination does not exist."  )
            % Else
            %     Dim N As Long
            %     For N = 0 To UBound( values )
            %         ReportInformationToWindow( names( N )  + ": " + CStr( values( N ) ) )
            %     Next
            % End If
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim parameterNames As Variant, parameterValues As Variant', newline, ...
                'bool = GetParameterCombination("', resultID, '", parameterNames, parameterValues)', newline, ...
                'StoreGlobalDataValue("matlab1", bool)', newline, ...
                ... % If the resultID was valid, then bool will be true.
                'If bool Then', newline, ...
                    ... % Store the number of parameters.
                    'StoreGlobalDataValue("matlab2", UBound(parameterValues))', newline, ...
                    ... % Store parameter names & values.
                    'Dim i As Long', newline, ...
                    'For i = 0 To UBound(parameterValues)', newline, ...
                        'StoreGlobalDataValue("matlab" + CStr(3+2*i  ), parameterNames(i))', newline, ...
                        'StoreGlobalDataValue("matlab" + CStr(3+2*i+1), CStr(parameterValues(i)))', newline, ...
                    'Next', newline, ...
                'End If', newline, ...
            ];
            returnvalues = {}; % Handle returns ourselves.
            obj.RunVBACode(functionString, returnvalues);

            % Extract returns.
            bool = obj.RestoreGlobalDataValue('matlab1');
            bool = str2double(bool);
            if(bool)
                % Number of parameters.
                nparams = str2double(obj.RestoreGlobalDataValue('matlab2'));
                % Extract parameter names & values.
                for(i = 0:nparams)
                    parameterName  = obj.RestoreGlobalDataValue(['matlab', num2str(3+2*i  )]);
                    parameterValue = obj.RestoreGlobalDataValue(['matlab', num2str(3+2*i+1)]);
                    % Convert to numerical if possible.
                    if(~isnan(str2double(parameterValue)))
                        parameterValue = str2double(parameterValue);
                    end
                    % Store in return struct.
                    parameters.(parameterName) = parameterValue;
                end
            else
                parameters = [];
            end
        end
        %% Global Data Cache
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
        %% Mathematical Functions / Constants
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
            % value1  Numerator of the arc tangent calculation.
            % value2  Denominator of the arc tangent calculation.
            double = obj.hProject.invoke('ATn2', value1, value2);
        end
        function double = ATn2D(obj, value1, value2)
            % Returns the arc tangent of the relation of value1 to value2 in degree.
            % value1  Numerator of the arc tangent calculation.
            % value2  Denominator of the arc tangent calculation.
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
        %% Result Templates
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
            % This method returns the last 0D result of the selected result template. 'name' is the
            % name of a previously defined result template.
            double = obj.hProject.invoke('GetLast0DResult', name);
        end
        function result1D = GetLast1DResult(obj, name)
            % This method returns the last 1D result of the selected result template. 'name' is the
            % name of a previously defined result template.
            hResult1D = obj.hProject.invoke('GetLast1DResult', name);

            result1D = CST.Result1D(obj, hResult1D);
        end
        function result1DComplex = GetLast1DComplexResult(obj, name)
            % This method returns the last complex 1D result of the selected result template. 'name'
            % is the name of a previously defined result template.
            hResult1DComplex = obj.hProject.invoke('GetLast1DComplexResult', name);

            result1DComplex = CST.Result1DComplex(obj, hResult1DComplex);
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
        function result1DComplex = GetImpedanceFromTreeItem(obj, treename)
            % If the 1D tree item with the name 'treename' can be visualized as a Smith Chart, this method returns a Result1DComplex object filled with the corresponding impedance data. If no impedance data is available, this method returns an empty Result1DComplex object.
            hResult1DComplex = obj.hProject.invoke('GetImpedanceFromTreeItem', treename);

            result1DComplex = CST.Result1DComplex(obj, hResult1DComplex);
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
        %% Macros
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
        %% MPI Cluster Setup
        function SetCommonMPIClusterConfig(obj, install_folder, temp_folder, architecture)
            % Set global and common information relative to all machines in MPI cluster. It is necessary to specify, in order:
            % - the CST MICROWAVE STUDIO installation folder. This can be a local or network path.
            % This latter option enables executable depot to be maintained updated and homogeneous.
            % - the temporary folder, for data storing on remote machines.
            % - the machines architecture and Operating System (OS). This field should belong to the following set:
            % enum {"Windows IA32", " Windows AMD64", " Linux IA32", "r;Linux AMD64"} type
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
            % enum {"Windows IA32", " Windows AMD64", " Linux IA32", " Linux AMD64"} type
            % If left empty, default architecture setting is employed.
            % - an activation flag to enable or disable the computation on the machine.
            % Example
            % The typical usage of these functions is in the initialization of a cluster of machines, to be used in solver MPI parallelization mode.
            % The following example shows the configuration of 2 nodes:
            % ' Remove previous cluster definition
            % ClearMPIClusterConfig
            % ' Set default parameters
            % SetCommonMPIClusterConfig("r;C:\program files\MWS 2009","e:\temp\mpi","Windows IA32")
            % ' Add active nodes (with default parameter)
            % AddMPIClusterNodeConfig ("r;Mynode1","","","",true)
            % ' Add second node specializing parameter
            % AddMPIClusterNodeConfig ("r;Mynode2","C:\programme\MWS 2009","f:\mpi","Windows IA32",true)
            % ' Enable solver MPI computation
            % Solver.MPIParallelization(true)
            obj.hProject.invoke('AddMPIClusterNodeConfig', host_name, install_folder, temp_folder, architecture, active);
        end
        %% Result Curve Handling
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
        %% Result Data Access
        function CalculateFourierComplex(obj, Input, InputUnit, Output, OutputUnit, isign, normalization, vMin, vMax, vSamples)
            % This VBA command computes the integral:
            % f(u) represents an arbitrarily sampled input signal Input. The meaning of u and v abscissas depends on the values specified via InputUnit and OutputUnit. Allowed values and the corresponding project units are:
            % Unit string value   Unit
            % "time"              TIME UNIT
            % "frequency"         FREQUENCY UNIT
            % "angularfrequency"  RADIAN x FREQUENCY UNIT
            % "space"             LENGTH UNIT
            % "wavenumber"        1/LENGTH UNIT
            % "angularwavenumber" RADIAN/LENGTH UNIT
            % vMin and vMax speficy the desired data interval in transformed coordinates and vSamples defines the desired number of equidistant samples. Only time-frequency and space-wavenumber space transforms are supported. Frequency and wavenumber functions are related as follows to their angular frequency/wavenumber counterparts:
            % No further scaling is applied. isign controls the sign of the exponent to affect a forward or a backward transform. The argument normalization may assume any value, depending on the employed normalization convention. However, forward and backward transform normalizations must always guarantee:
            % Fourier transform conventions adopted by  CST MICROWAVE STUDIO are:
            % CalculateFourierComplex(Signal, "time", Spectrum, "frequency", "-1", "1.0", ...)
            % CalculateFourierComplex(Spectrum, "frequency", Signal, "time", "+1", "1.0/(2.0*Pi)", ...)
            obj.hProject.invoke('CalculateFourierComplex', Input, InputUnit, Output, OutputUnit, isign, normalization, vMin, vMax, vSamples);
        end
        function CalculateCONV(obj, a, b, conv) %#ok<INUSD>
            % This function was not implemented due to the Result1D
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''CalculateCONV''.');
            return;
            % This method calculates the convolution of two sequences. All signals are given as Result1D objects.
            % a - First sequence to be convoluted.
            % b - Second sequence to be convoluted.
            % conv - Convolution of sequence_a and sequence_b
%             obj.hProject.invoke('CalculateCONV', a, b, conv);
        end
        function CalculateCROSSCOR(obj, a, b, corr, bNorm) %#ok<INUSD>
            % This function was not implemented due to the Result1D
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''CalculateCROSSCOR''.');
            return;
            % This method calculates the cross correlation sequence of two sequences. All signals are given as Result1D objects. If "bNorm" is "False"  then the standard cross correlation sequence is calculated by the following equation.
            % For "bNorm = True" a normed correlation sequence is determined. The resulting sequence will have values in the interval [-1,1] and will be independent to scalar multiplication of the sequences "a" and "b".  This normed sequence is derived from the term below.
            % Please note that "corr" may have a different sampling than "a" and "b". An internal resampling is done to assure compatibility of the x-values of the processed sequences.
            % a - First sequence to be correlated.
            % b - Second sequence to be correlated.
            % corr - Sequence of correlation coefficients of the sequences above.
            % bNorm - Flag if normed or standard correlation is calculated.
%             obj.hProject.invoke('CalculateCROSSCOR', a, b, corr, bNorm);
        end
        function DeleteResults(obj)
            % Deletes all results of the actual project.
            obj.hProject.invoke('DeleteResults');
        end
        function double = GetFieldFrequency(obj)
            % Returns the frequency of the currently plotted field. If no field is plotted, zero will be returned.
            double = obj.hProject.invoke('GetFieldFrequency');
        end
        function [value, x, y, z] = GetFieldPlotMaximumPos(obj)
            % Returns the maximum of the color scale and its global position of a plot without
            % considering the manual setting of the borders. 'x', 'y', 'z' are the absolute
            % coordinate of the maximum as return values.
            functionString = [...
                'Dim value As Double, x As Double, y As Double, z As Double', newline, ...
                'value = GetFieldPlotMaximumPos(x, y, z)', newline, ...
            ];
            returnvalues = {'value', 'x', 'y', 'z'};
            [value, x, y, z] = obj.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            value = str2double(value);
            x = str2double(x);
            y = str2double(y);
            z = str2double(z);
        end
        function [value, x, y, z] = GetFieldPlotMinimumPos(obj)
            % Returns the minimum of the color scale and its global position of a plot without
            % considering the manual setting of the borders. 'x', 'y', 'z' are the absolute
            % coordinate of the minimum as return values.
            functionString = [...
                'Dim value As Double, x As Double, y As Double, z As Double', newline, ...
                'value = GetFieldPlotMinimumPos(x, y, z)', newline, ...
            ];
            returnvalues = {'value', 'x', 'y', 'z'};
            [value, x, y, z] = obj.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            value = str2double(value);
            x = str2double(x);
            y = str2double(y);
            z = str2double(z);
        end
        function [bool, x, y, z, vxre, vyre, vzre, vxim, vyim, vzim] = GetFieldVector(obj)
            % Returns the complex vector field value of the currently active field plot at the given position. If the field is scalar, only the vxre component has non-zero values. If no field plot is active or the given position is out of range the function returns false.
            % x    - X - value of the position of the desired field value.
            % y    - Y - value of the position of the desired field value.
            % z    - Z - value of the position of the desired field value.
            % vxre - Real part of the x-component of the field value.
            % vyre - Real part of the y-component of the field value.
            % vzre - Real part of the z-component of the field value.
            % vxim - Imaginary part of the x-component of the field value.
            % vyim - Imaginary part of the y-component of the field value.
            % vzim - Imaginary part of the z-component of the field value.
            %
            % NOTE: valid is -1 when true.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim x As Double, y As Double, z As Double', newline, ...
                'Dim vxre As Double, vyre As Double, vzre As Double', newline, ...
                'Dim vxim As Double, vyim As Double, vzim As Double', newline, ...
                'bool = GetFieldVector(x, y, z, vxre, vyre, vzre, vxim, vyim, vzim)', newline, ...
            ];
            returnvalues = {'bool', 'x', 'y', 'z', 'vxre', 'vyre', 'vzre', 'vxim', 'vyim', 'vzim'};
            [bool, x, y, z, vxre, vyre, vzre, vxim, vyim, vzim] = obj.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            bool = str2double(bool);
            x = str2double(x);
            y = str2double(y);
            z = str2double(z);
            vxre = str2double(vxre);
            vyre = str2double(vyre);
            vzre = str2double(vzre);
            vxim = str2double(vxim);
            vyim = str2double(vyim);
            vzim = str2double(vzim);
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
        %% Queries
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
            % type        Path returned
            % Root        c:\MySolvedProblems
            % Project     c:\MySolvedProblems\Try
            % Model3D     c:\MySolvedProblems\Try\Model\3D
            % ModelCache  c:\MySolvedProblems\Try\ModelCache
            % Result      c:\MySolvedProblems\Try\Result
            % Temp        c:\MySolvedProblems\Try\Temp
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
        %% Parametric Modelling
        function Assign(obj, variable_name)
            % This function can be used only in connection with the BeginHide/EndHide Functions. 'variable_name' is a variable, defined within a BeginHide/EndHide block, that has to be valid outside of this block.
            obj.hProject.invoke('Assign', variable_name);
        end
        function BeginHide(obj)
            % These function has an effect only if they are used in connection with the History List .
%             obj.hProject.invoke('BeginHide');
            obj.AddToHistory('BeginHide');
        end
        function EndHide(obj)
            % These function has an effect only if they are used in connection with the History List .
%             obj.hProject.invoke('EndHide');
            obj.AddToHistory('EndHide');
        end
        function double = dist2d(obj, id, x, y)
            % Returns the spatial distance in 2d of a pickpoint to a specified position.
            % id  Number of the requested point in the pickpoint list.
            % x   x-coordinate of the specific position.
            % y   y-coordinate of the specific position.
            double = obj.hProject.invoke('dist2d', id, x, y);
        end
        function double = dist3d(obj, id, x, y, z)
            % Returns the spatial distance in 3d of a pickpoint to a specified position.
            % id  Number of the requested point in the pickpoint list.
            % x   x-coordinate of the specific position.
            % y   y-coordinate of the specific position.
            % z   z-coordinate of the specific position.
            double = obj.hProject.invoke('dist3d', id, x, y, z);
        end
        function double = ldist2D(obj, id, x1, y1, x2, y2)
            % Returns the spatial distance in 2d of a pickpoint to a line defined by two points.
            % id  Number of the requested point in the pickpoint list.
            % x1  x-coordinate of the start point of the specific line.
            % y1  y-coordinate of the start point of the specific line.
            % x2  x-coordinate of the end point of the specific line.
            % y2  y-coordinate of the end point of the specific line.
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
        %% Result Plotting
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
        %% Distributed Computing Setup
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
        %% (2020) Global Data Storage
        % The global data storage can be used to store named settings in projects.
        % Caution: It is very easy to use the global data storage in a way that introduces very hard to find result inconsistencies. It is strongly advised to be used by experienced users only. If possible, project parameters should be used instead.
        % The global data storage has the following properties:
        % It is shared between simulation projects and master projects, i.e. a setting stored in a simulation project will be visible in the master and other simulation projects. This is even true for simulation projects with disabled "Link geometry to master" flag.
        % Names and values of settings can be arbitrary strings, but line breaks are forbidden.
        % The standard dependency and result invalidation mechanisms of project parameters are not applied to the global data storage. Changing a value that is used in the history list of 3D projects or in a block or task setting on the schematic does neither prompt for a history rebuild, nor does it cause an invalidation of task results, the assembly or simulation projects. The user of the global data storage is responsible for any re-calculations and/or history rebuilds which might be needed.
        % Global Data storage settings must not be used in value expressions of project parameters. This would break the parametric result management.
        % When opening an existing project that uses GetGlobalData, it is impossible to tell whether the current state (3D geometry, task settings, block settings, results etc.) was obtained with the current result of GetGlobalData. The only way to find this out is to rebuild all 3D blocks and to run all 3D solvers and simulation tasks again.
        function ResetGlobalDataStorage(obj)
            % Clear all global data storage settings.
            obj.AddToHistory(['.ResetGlobalDataStorage']);
        end
        function SetGlobalData(obj, name, value)
            % Creates a new global data storage setting with a given name and value or changes an existing one. For storing floating point numbers it is recommended to use an explicit conversion first to double and then to string to avoid errors caused by locale dependent decimal separators:
            % SetGlobalData(name, CStr(Cdbl(value)))
            obj.AddToHistory(['.SetGlobalData "', num2str(name, '%.15g'), '", '...
                                             '"', num2str(value, '%.15g'), '"']);
        end
        function string = GetGlobalData(obj, name)
            % Returns a global data storage setting.
            string = obj.hProject.invoke('GetGlobalData', name);
        end
        %% CST 2019 Functions.
        function object = GetSimulationProject(obj, name)
            % Returns the COM interface of the simulation project.
            object = obj.hProject.invoke('GetSimulationProject', name);
        end
        function object = GetParentOfSimulationProject(obj)
            % Returns the COM interface of the parent project if the current project is a simulation project.
            object = obj.hProject.invoke('GetParentOfSimulationProject');
        end
        %% CST 2020 Functions.
        function SetPlotStyleForTreeItem(obj, treepath, settings)
            % This command allows modifying plot styles of 1D curves such as curve color, line style, etc. The modifications behave like modifications which are done in the Curve Style Dialog. It is not required to have any open 1D Plot to use this command. However, existing open 1D Plots will not be updated automatically; consider using the Plot1D object in this case. The parameter treepath is expected to be a Navigation Tree path to a 1D leaf item, that is a tree item which represents a single curve, e.g. "1D Results\S-Parameters\S1,1". If the tree item does not exist or is a folder, an error is reported. This check can be deactivated (see parameter settings ).
            % The parameter settings is expected to be a whitespace separated list of the following strings:
            % Keyword         Setting                                                                                                                             Example
            % nocheck         Disables the existence check for the provided tree path. This allows modifying plot styles a priori to a solver run.
            % runid=...       Allows controlling the plot styles of a parametric curve. If no runid is provided, runid=0 is assumed. No existence check is done.  runid=0
            % color=...       Specifies the desired curve color in semicolon separated list of RGB values in the range [0,255].                                   color=255;255;0
            % linewidth=...   Accepts an integer in the range [1,8] and specifies the line thickness.                                                             linewidth=3
            % linetype=...    Can be used to specify the line style, which can be one of the options "Solid", "Dashed", "Dotted", "Dashdotted".                   linetype=Solid
            % markerstyle=... Can be used to specify the marker style, which can be one of the options "Auto", "Additional", "Marksonly", "Nomarks".              markershape=Auto
            % markersize=...  Accepts an integer in the range [1,8] and specifies the marker size.                                                                markersize=5
            % clear           Removes all configured plot styles and sets it back to default values.
            % The following example shows how a plot style can be modified:
            % SetPlotStyleForTreeItem("1D Results\S-Parameters\S1,1","color=177;1;165 linetype=Dotted linewidth=8")
            obj.AddToHistory(['.SetPlotStyleForTreeItem "', num2str(treepath, '%.15g'), '", '...
                                                       '"', num2str(settings, '%.15g'), '"']);
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
        % Found in history list of migrated CST 2014 file.
        function ChangeSolverAndMeshType(obj, type)
            % type: 'HF Frequency Domain'
            obj.AddToHistory(['ChangeSolverAndMeshType "', type, '"']);
        end
        %% Utility functions.
        function varargout = RunVBACode(obj, functionstring, returnvalues)
            % functionstring specifies the VBA code to be run.
            % returnvalues specifies the VBA names of the values to be returned to MATLAB.
            %     This must match the number of output arguments nargout.
            %     An empty array causes returns to be ignored.
            if((nargout ~= 0 || nargin >= 3) && ~isempty(returnvalues))
                if(nargout ~= length(returnvalues))
                    error('Invalid number of return values specified.');
                end

                % Append the code to return the values to MATLAB.
                for(i = 1:length(returnvalues))
                    functionstring = [functionstring, newline, ...
                    'StoreGlobalDataValue("matlab', num2str(i), '", ', returnvalues{i}, ')']; %#ok<AGROW>
                end
            end

            % Determine the full path to the RunVBACode.bas file.
            folders = what('+CST');
            cstinterfacefolder = [];
            % There may be multiple folders named '+CST'.
            for(i = 1:length(folders))
                % Find the one that contains adscomponentexport.m.
                if(any([cellfun(@(name) strcmpi(name, 'adscomponentexport.m'), folders(i).m)]))
                    % Strip '\+CST' from the folder.
                    cstinterfacefolder = folders(i).path(1:end-5);
                    break;
                end
            end
            % Ensure the folder is found.
            if(isempty(cstinterfacefolder))
                error('''+CST'' folder not found, something went wrong.');
            end
            basfilepath = [cstinterfacefolder, '\Bas\RunVBACode.bas'];
            % Ensure the script is present.
            if(~exist(basfilepath, 'file'))
                error('RunVBACode.bas macro not found, ensure it is placed in the Bas folder.\nThe Bas folder should be next to the +CST folder.');
            end

            % Run the code in CST.
            obj.StoreGlobalDataValue('matlabfcn', functionstring);
            obj.RunScript(basfilepath);

            if(nargin >= 3 && ~isempty(returnvalues))
                % Retrieve return arguments.
                varargout = cell(1, nargout);
                for(i = 1:nargout)
                    varargout{i} = obj.RestoreGlobalDataValue(['matlab', num2str(i)]);
                end
            end
        end
        function parameters = GetAllParameters(obj)
            nparams = obj.GetNumberOfParameters();
            parameters = struct();
            for(i = 0:nparams-1)
                parametername = obj.GetParameterName(i);
                parameters.(parametername) = obj.GetParameterSValue(double(i));
%                 parameters.(parametername) = obj.RestoreParameterExpression(parametername);
            end
        end
        function [parameters, descriptions] = GetAllParametersWithDescription(obj)
            nparams = obj.GetNumberOfParameters();
            parameters = struct();
            descriptions = struct();
            for(i = 0:nparams-1)
                parametername = obj.GetParameterName(i);
                parameters.(parametername) = obj.RestoreParameterExpression(parametername);
%                 parameters.(parametername) = obj.GetParameterSValue(double(i));
                descriptions.(parametername) = obj.GetParameterDescription(parametername);
            end
        end
        function StoreParameterStruct(obj, strct)
            names = fieldnames(strct);
            values = cell(size(names, 1), size(names, 2));
            for(i = 1:length(names))
                values{i} = strct.(names{i});
            end
            obj.StoreParameters(names, values);
        end
        function StartBulkMode(obj)
            if(obj.bulkmode)
                error('Bulkmode already active.');
            end
            obj.bulkmode = 1;
        end
        function EndBulkMode(obj)
            vba = ['ScreenUpdating "False"', newline];
            % Translate caption & content history.
            for(i = 1:length(obj.captionhistory))
                caption = obj.captionhistory{i};

                content = obj.contenthistory{i};
                % Double the double quotes
                vbacaption = strrep(caption, '"', '""');
                vbacontent = strrep(content, '"', '""');
                % Add the right newlines
                vbacaption = strrep(vbacaption, newline, ['" + vbNewLine + _', newline, '"']);
                vbacontent = strrep(vbacontent, newline, ['" + vbNewLine + _', newline, '"']);

                vba = [vba, newline, ...
                    'AddToHistory("', vbacaption, '", _', newline, '"', vbacontent, '")', newline, ...
                    ]; %#ok<AGROW>
            end

            obj.RunVBACode(vba);

            obj.captionhistory = {};
            obj.contenthistory = {};
            obj.bulkmode = 0;
        end
        function NextCommandConditional(obj, conditionString)
            % Make next command conditional by inserting If conditionString Then and End If
            obj.nextcommandmodifiers{end+1} = {'Conditional', conditionString};
        end
        function NextCommandLoop(obj, counter, startval, endval, stepval)
            % Make next command loop by inserting the following code around the history list item.
            % Step is an optional argument.
            % NOTE: Parameters are case insensitive, be aware of CST project parameters.
            % For counter = startval To endval [ Step stepval ]
            %     [ history list item ]
            % Next [ counter ]
            if(nargin < 5)
                obj.nextcommandmodifiers{end+1} = {'Loop', counter, ...
                                                           num2str(startval, '%.15g'), ...
                                                           num2str(endval, '%.15g')};
            else
                obj.nextcommandmodifiers{end+1} = {'Loop', counter, ...
                                                           num2str(startval, '%.15g'), ...
                                                           num2str(endval, '%.15g'), ...
                                                           num2str(stepval, '%.15g')};
            end
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        hProject
        captionhistory
        contenthistory
        bulkmode
        nextcommandmodifiers
    end
    %% Matlab interface Project functions.
    properties(Access = protected)
        adscomponentexport          CST.ADSComponentExport
        adscosimulation             CST.ADSCosimulation
        align                       CST.Align_
        analyticalcurve             CST.AnalyticalCurve
        analyticalface              CST.AnalyticalFace
        arc                         CST.Arc
        arfilter                    CST.Arfilter
        asciiexport                 CST.ASCIIExport
        asymptoticsolver            CST.AsymptoticSolver
        autodeskinventor            CST.AutodeskInventor
        background                  CST.Background
        bending                     CST.Bending
        blendcurve                  CST.BlendCurve
        boundary                    CST.Boundary
        brick                       CST.Brick
        catia                       CST.CATIA
        chamfercurve                CST.ChamferCurve
        charge                      CST.Charge
        chtsolver                   CST.CHTSolver
        circle                      CST.Circle
        coil                        CST.Coil
        colorramp                   CST.ColorRamp
        colourmapplot               CST.ColourMapPlot
        combineresults              CST.CombineResults
        component                   CST.Component
        cone                        CST.Cone
        contactproperties           CST.ContactProperties
        coventorware                CST.CoventorWare
        covercurve                  CST.CoverCurve
        currentmonitor              CST.CurrentMonitor
        currentpath                 CST.CurrentPath
        currentport                 CST.CurrentPort
        curve                       CST.Curve
        cylinder                    CST.Cylinder
        dimension                   CST.Dimension
        discretefaceport            CST.DiscreteFacePort
        discreteport                CST.DiscretePort
        discretizer                 CST.Discretizer
        displacement                CST.Displacement
        drc                         CST.DRC
        drcrz                       CST.DRCRZ
        dxf                         CST.DXF
        ecylinder                   CST.ECylinder
        edaimportdefaults           CST.EDAImportDefaults
        edgecurve                   CST.EdgeCurve
        eigenmodesolver             CST.EigenmodeSolver
        ellipse                     CST.Ellipse
        eqssolver                   CST.EQSSolver
        estaticsolver               CST.EStaticSolver
        evaluatefieldalongcurve     CST.EvaluateFieldAlongCurve
        evaluatefieldonface         CST.EvaluateFieldOnFace
        extrude                     CST.Extrude
        extrudecurve                CST.ExtrudeCurve
        face                        CST.Face
        fan                         CST.Fan
        farfieldarray               CST.FarfieldArray
        farfieldplot                CST.FarfieldPlot
        farfieldsource              CST.FarfieldSource
        fdsolver                    CST.FDSolver
        fieldsource                 CST.FieldSource
        floquetport                 CST.FloquetPort
        fluiddomain                 CST.FluidDomain
        force                       CST.Force
        gdsii                       CST.GDSII
        gerber                      CST.GERBER
        group                       CST.Group
        heatsource                  CST.HeatSource
        hfss                        CST.HFSS
        humanmodel                  CST.HumanModel
        iesolver                    CST.IESolver
        iges                        CST.IGES
        interiorboundary            CST.InteriorBoundary
        layerstacking               CST.LayerStacking
        layoutdb                    CST.LayoutDB
        lfsolver                    CST.LFSolver
        line                        CST.Line
        livelink                    CST.LiveLink
        localmodification           CST.LocalModification
        loft                        CST.Loft
        loftcurves                  CST.LoftCurves
        lumpedelement               CST.LumpedElement
        lumpedfaceelement           CST.LumpedFaceElement
        magnet                      CST.Magnet
        material                    CST.Material
        mecadtron                   CST.Mecadtron
        mechfieldsettings           CST.MechFieldSettings
        mesh                        CST.Mesh
        meshadaption3d              CST.MeshAdaption3D
        meshsettings                CST.MeshSettings
        monitor                     CST.Monitor
        motiongap                   CST.MotionGap
        movingmedia                 CST.MovingMedia
        mqstdsolver                 CST.MQSTDSolver
        mstaticsolver               CST.MStaticSolver
        nastran                     CST.NASTRAN
        nearfieldscan               CST.NearfieldScan
        networkparameterextraction  CST.NetworkParameterExtraction
        nfsfile                     CST.NFSFile
        obj_                        CST.OBJ
        optimizer                   CST.Optimizer
        parametersweep              CST.ParameterSweep
        parasolid                   CST.Parasolid
        particle2dmonitorreader     CST.Particle2DMonitorReader
        particlebeam                CST.ParticleBeam
        particleinterface           CST.ParticleInterface
        particlemonitor             CST.ParticleMonitor
        particlemonitoronsolid      CST.ParticleMonitorOnSolid
        particlesource              CST.ParticleSource
        particletrajectoryreader    CST.ParticleTrajectoryReader
        pic2dmonitor                CST.PIC2DMonitor
        pic2dmonitorreader          CST.PIC2DMonitorReader
        pick                        CST.Pick
        picphasespacemonitor        CST.PICPhaseSpaceMonitor
        picpositionmonitor          CST.PICPositionMonitor
        picpositionmonitorreader    CST.PICPositionMonitorReader
        picsolver                   CST.PICSolver
        planewave                   CST.PlaneWave
        plot                        CST.Plot
        plot1d                      CST.Plot1D
        polygon                     CST.Polygon
        polygon3d                   CST.Polygon3D
        port                        CST.Port
        postprocess1d               CST.PostProcess1D
        potential                   CST.Potential
        predefinedfield             CST.PredefinedField
        probe                       CST.Probe
        proe                        CST.PROE
        qfactor                     CST.QFactor
        rayresultcreator            CST.RayResultCreator
        rectangle                   CST.Rectangle
%       result0d                    CST.Result0D
%       result1d                    CST.Result1D
%       result1dcomplex             CST.Result1DComplex
%       result2d                    CST.Result2D
%       result3d                    CST.Result3D
        resultdatabase              CST.ResultDatabase
%       resultmap                   CST.ResultMap
%       resultmatrix                CST.ResultMatrix
        resulttree                  CST.ResultTree
        rigidbodymotion             CST.RigidBodyMotion
        rotate                      CST.Rotate
        sar                         CST.SAR
        sat                         CST.SAT
        scalarplot2d                CST.ScalarPlot2D
        scalarplot3d                CST.ScalarPlot3D
        sensitivityanalysis         CST.SensitivityAnalysis
        siemensnx                   CST.SiemensNX
        simulationproject           CST.SimulationProject
        simuliacse                  CST.SimuliaCSE
        solid                       CST.Solid
        solidedge                   CST.SolidEdge
        solidworks                  CST.SolidWorks
        solver                      CST.Solver
        solverparameter             CST.SolverParameter
        sourcefield                 CST.SourceField
        sphere                      CST.Sphere
        spline                      CST.Spline
        stationarycurrentsolver     CST.StationaryCurrentSolver
        step                        CST.STEP
        stl                         CST.STL
        structuralmechanicssolver   CST.StructuralMechanicsSolver
        sweepcurve                  CST.SweepCurve
%       table                       CST.Table
        temperaturesource           CST.TemperatureSource
        thermallossimport           CST.ThermalLossImport
        thermalsolver               CST.ThermalSolver
        thermalsourceparameter      CST.ThermalSourceParameter
        thermalsurfaceproperty      CST.ThermalSurfaceProperty
        thermaltdsolver             CST.ThermalTDSolver
        timemonitor                 CST.TimeMonitor
        timemonitor0d               CST.TimeMonitor0D
        timemonitor1d               CST.TimeMonitor1D
        timemonitor2d               CST.TimeMonitor2D
        timemonitor3d               CST.TimeMonitor3D
        timesignal                  CST.TimeSignal
        torus                       CST.Torus
        touchstone                  CST.TOUCHSTONE
        tracefromcurve              CST.TraceFromCurve
        trackingplot                CST.TrackingPlot
        trackingsolver              CST.TrackingSolver
        traction                    CST.Traction
        transform                   CST.Transform_
        trimcurves                  CST.TrimCurves
        units                       CST.Units
        vdafs                       CST.VDAFS
        vectorplot2d                CST.VectorPlot2D
        vectorplot3d                CST.VectorPlot3D
        voltagemonitor              CST.VoltageMonitor
        voltagewire                 CST.VoltageWire
        wakefieldpostprocessor      CST.WakefieldPostprocessor
        wcs                         CST.WCS
        wire                        CST.Wire
        yieldanalysis               CST.YieldAnalysis
    end
    methods
        function adscomponentexport          = ADSComponentExport(obj);          if(isempty(obj.adscomponentexport));          obj.adscomponentexport          = CST.ADSComponentExport(obj, obj.hProject);          end; adscomponentexport          = obj.adscomponentexport;          end
        function adscosimulation             = ADSCosimulation(obj);             if(isempty(obj.adscosimulation));             obj.adscosimulation             = CST.ADSCosimulation(obj, obj.hProject);             end; adscosimulation             = obj.adscosimulation;             end
        function align                       = Align(obj);                       if(isempty(obj.align));                       obj.align                       = CST.Align_(obj, obj.hProject);                       end; align                       = obj.align;                       end
        function analyticalcurve             = AnalyticalCurve(obj);             if(isempty(obj.analyticalcurve));             obj.analyticalcurve             = CST.AnalyticalCurve(obj, obj.hProject);             end; analyticalcurve             = obj.analyticalcurve;             end
        function analyticalface              = AnalyticalFace(obj);              if(isempty(obj.analyticalface));              obj.analyticalface              = CST.AnalyticalFace(obj, obj.hProject);              end; analyticalface              = obj.analyticalface;              end
        function arc                         = Arc(obj);                         if(isempty(obj.arc));                         obj.arc                         = CST.Arc(obj, obj.hProject);                         end; arc                         = obj.arc;                         end
        function arfilter                    = Arfilter(obj);                    if(isempty(obj.arfilter));                    obj.arfilter                    = CST.Arfilter(obj, obj.hProject);                    end; arfilter                    = obj.arfilter;                    end
        function asciiexport                 = ASCIIExport(obj);                 if(isempty(obj.asciiexport));                 obj.asciiexport                 = CST.ASCIIExport(obj, obj.hProject);                 end; asciiexport                 = obj.asciiexport;                 end
        function asymptoticsolver            = AsymptoticSolver(obj);            if(isempty(obj.asymptoticsolver));            obj.asymptoticsolver            = CST.AsymptoticSolver(obj, obj.hProject);            end; asymptoticsolver            = obj.asymptoticsolver;            end
        function autodeskinventor            = AutodeskInventor(obj);            if(isempty(obj.autodeskinventor));            obj.autodeskinventor            = CST.AutodeskInventor(obj, obj.hProject);            end; autodeskinventor            = obj.autodeskinventor;            end
        function background                  = Background(obj);                  if(isempty(obj.background));                  obj.background                  = CST.Background(obj, obj.hProject);                  end; background                  = obj.background;                  end
        function bending                     = Bending(obj);                     if(isempty(obj.bending));                     obj.bending                     = CST.Bending(obj, obj.hProject);                     end; bending                     = obj.bending;                     end
        function blendcurve                  = BlendCurve(obj);                  if(isempty(obj.blendcurve));                  obj.blendcurve                  = CST.BlendCurve(obj, obj.hProject);                  end; blendcurve                  = obj.blendcurve;                  end
        function boundary                    = Boundary(obj);                    if(isempty(obj.boundary));                    obj.boundary                    = CST.Boundary(obj, obj.hProject);                    end; boundary                    = obj.boundary;                    end
        function brick                       = Brick(obj);                       if(isempty(obj.brick));                       obj.brick                       = CST.Brick(obj, obj.hProject);                       end; brick                       = obj.brick;                       end
        function catia                       = CATIA(obj);                       if(isempty(obj.catia));                       obj.catia                       = CST.CATIA(obj, obj.hProject);                       end; catia                       = obj.catia;                       end
        function chamfercurve                = ChamferCurve(obj);                if(isempty(obj.chamfercurve));                obj.chamfercurve                = CST.ChamferCurve(obj, obj.hProject);                end; chamfercurve                = obj.chamfercurve;                end
        function charge                      = Charge(obj);                      if(isempty(obj.charge));                      obj.charge                      = CST.Charge(obj, obj.hProject);                      end; charge                      = obj.charge;                      end
        function chtsolver                   = CHTSolver(obj);                   if(isempty(obj.chtsolver));                   obj.chtsolver                   = CST.CHTSolver(obj, obj.hProject);                   end; chtsolver                   = obj.chtsolver;                   end
        function circle                      = Circle(obj);                      if(isempty(obj.circle));                      obj.circle                      = CST.Circle(obj, obj.hProject);                      end; circle                      = obj.circle;                      end
        function coil                        = Coil(obj);                        if(isempty(obj.coil));                        obj.coil                        = CST.Coil(obj, obj.hProject);                        end; coil                        = obj.coil;                        end
        function colorramp                   = ColorRamp(obj);                   if(isempty(obj.colorramp));                   obj.colorramp                   = CST.ColorRamp(obj, obj.hProject);                   end; colorramp                   = obj.colorramp;                   end
        function colourmapplot               = ColourMapPlot(obj);               if(isempty(obj.colourmapplot));               obj.colourmapplot               = CST.ColourMapPlot(obj, obj.hProject);               end; colourmapplot               = obj.colourmapplot;               end
        function combineresults              = CombineResults(obj);              if(isempty(obj.combineresults));              obj.combineresults              = CST.CombineResults(obj, obj.hProject);              end; combineresults              = obj.combineresults;              end
        function component                   = Component(obj);                   if(isempty(obj.component));                   obj.component                   = CST.Component(obj, obj.hProject);                   end; component                   = obj.component;                   end
        function cone                        = Cone(obj);                        if(isempty(obj.cone));                        obj.cone                        = CST.Cone(obj, obj.hProject);                        end; cone                        = obj.cone;                        end
        function contactproperties           = ContactProperties(obj);           if(isempty(obj.contactproperties));           obj.contactproperties           = CST.ContactProperties(obj, obj.hProject);           end; contactproperties           = obj.contactproperties;           end
        function coventorware                = CoventorWare(obj);                if(isempty(obj.coventorware));                obj.coventorware                = CST.CoventorWare(obj, obj.hProject);                end; coventorware                = obj.coventorware;                end
        function covercurve                  = CoverCurve(obj);                  if(isempty(obj.covercurve));                  obj.covercurve                  = CST.CoverCurve(obj, obj.hProject);                  end; covercurve                  = obj.covercurve;                  end
        function currentmonitor              = CurrentMonitor(obj);              if(isempty(obj.currentmonitor));              obj.currentmonitor              = CST.CurrentMonitor(obj, obj.hProject);              end; currentmonitor              = obj.currentmonitor;              end
        function currentpath                 = CurrentPath(obj);                 if(isempty(obj.currentpath));                 obj.currentpath                 = CST.CurrentPath(obj, obj.hProject);                 end; currentpath                 = obj.currentpath;                 end
        function currentport                 = CurrentPort(obj);                 if(isempty(obj.currentport));                 obj.currentport                 = CST.CurrentPort(obj, obj.hProject);                 end; currentport                 = obj.currentport;                 end
        function curve                       = Curve(obj);                       if(isempty(obj.curve));                       obj.curve                       = CST.Curve(obj, obj.hProject);                       end; curve                       = obj.curve;                       end
        function cylinder                    = Cylinder(obj);                    if(isempty(obj.cylinder));                    obj.cylinder                    = CST.Cylinder(obj, obj.hProject);                    end; cylinder                    = obj.cylinder;                    end
        function dimension                   = Dimension(obj);                   if(isempty(obj.dimension));                   obj.dimension                   = CST.Dimension(obj, obj.hProject);                   end; dimension                   = obj.dimension;                   end
        function discretefaceport            = DiscreteFacePort(obj);            if(isempty(obj.discretefaceport));            obj.discretefaceport            = CST.DiscreteFacePort(obj, obj.hProject);            end; discretefaceport            = obj.discretefaceport;            end
        function discreteport                = DiscretePort(obj);                if(isempty(obj.discreteport));                obj.discreteport                = CST.DiscretePort(obj, obj.hProject);                end; discreteport                = obj.discreteport;                end
        function discretizer                 = Discretizer(obj);                 if(isempty(obj.discretizer));                 obj.discretizer                 = CST.Discretizer(obj, obj.hProject);                 end; discretizer                 = obj.discretizer;                 end
        function displacement                = Displacement(obj);                if(isempty(obj.displacement));                obj.displacement                = CST.Displacement(obj, obj.hProject);                end; displacement                = obj.displacement;                end
        function drc                         = DRC(obj);                         if(isempty(obj.drc));                         obj.drc                         = CST.DRC(obj, obj.hProject);                         end; drc                         = obj.drc  ;                       end
        function drcrz                       = DRCRZ(obj);                       if(isempty(obj.drcrz));                       obj.drcrz                       = CST.DRCRZ(obj, obj.hProject);                       end; drcrz                       = obj.drcrz;                       end
        function dxf                         = DXF(obj);                         if(isempty(obj.dxf));                         obj.dxf                         = CST.DXF(obj, obj.hProject);                         end; dxf                         = obj.dxf;                         end
        function ecylinder                   = ECylinder(obj);                   if(isempty(obj.ecylinder));                   obj.ecylinder                   = CST.ECylinder(obj, obj.hProject);                   end; ecylinder                   = obj.ecylinder;                   end
        function edaimportdefaults           = EDAImportDefaults(obj);           if(isempty(obj.edaimportdefaults));           obj.edaimportdefaults           = CST.EDAImportDefaults(obj, obj.hProject);           end; edaimportdefaults           = obj.edaimportdefaults;           end
        function edgecurve                   = EdgeCurve(obj);                   if(isempty(obj.edgecurve));                   obj.edgecurve                   = CST.EdgeCurve(obj, obj.hProject);                   end; edgecurve                   = obj.edgecurve;                   end
        function eigenmodesolver             = EigenmodeSolver(obj);             if(isempty(obj.eigenmodesolver));             obj.eigenmodesolver             = CST.EigenmodeSolver(obj, obj.hProject);             end; eigenmodesolver             = obj.eigenmodesolver;             end
        function ellipse                     = Ellipse(obj);                     if(isempty(obj.ellipse));                     obj.ellipse                     = CST.Ellipse(obj, obj.hProject);                     end; ellipse                     = obj.ellipse;                     end
        function eqssolver                   = EQSSolver(obj);                   if(isempty(obj.eqssolver));                   obj.eqssolver                   = CST.EQSSolver(obj, obj.hProject);                   end; eqssolver                   = obj.eqssolver;                   end
        function estaticsolver               = EStaticSolver(obj);               if(isempty(obj.estaticsolver));               obj.estaticsolver               = CST.EStaticSolver(obj, obj.hProject);               end; estaticsolver               = obj.estaticsolver;               end
        function evaluatefieldalongcurve     = EvaluateFieldAlongCurve(obj);     if(isempty(obj.evaluatefieldalongcurve));     obj.evaluatefieldalongcurve     = CST.EvaluateFieldAlongCurve(obj, obj.hProject);     end; evaluatefieldalongcurve     = obj.evaluatefieldalongcurve;     end
        function evaluatefieldonface         = EvaluateFieldOnFace(obj);         if(isempty(obj.evaluatefieldonface));         obj.evaluatefieldonface         = CST.EvaluateFieldOnFace(obj, obj.hProject);         end; evaluatefieldonface         = obj.evaluatefieldonface;         end
        function extrude                     = Extrude(obj);                     if(isempty(obj.extrude));                     obj.extrude                     = CST.Extrude(obj, obj.hProject);                     end; extrude                     = obj.extrude;                     end
        function extrudecurve                = ExtrudeCurve(obj);                if(isempty(obj.extrudecurve));                obj.extrudecurve                = CST.ExtrudeCurve(obj, obj.hProject);                end; extrudecurve                = obj.extrudecurve;                end
        function face                        = Face(obj);                        if(isempty(obj.face));                        obj.face                        = CST.Face(obj, obj.hProject);                        end; face                        = obj.face;                        end
        function fan                         = Fan(obj);                         if(isempty(obj.fan));                         obj.fan                         = CST.Fan(obj, obj.hProject);                         end; fan                         = obj.fan;                         end
        function farfieldarray               = FarfieldArray(obj);               if(isempty(obj.farfieldarray));               obj.farfieldarray               = CST.FarfieldArray(obj, obj.hProject);               end; farfieldarray               = obj.farfieldarray;               end
        function farfieldplot                = FarfieldPlot(obj);                if(isempty(obj.farfieldplot));                obj.farfieldplot                = CST.FarfieldPlot(obj, obj.hProject);                end; farfieldplot                = obj.farfieldplot;                end
        function farfieldsource              = FarfieldSource(obj);              if(isempty(obj.farfieldsource));              obj.farfieldsource              = CST.FarfieldSource(obj, obj.hProject);              end; farfieldsource              = obj.farfieldsource;              end
        function fdsolver                    = FDSolver(obj);                    if(isempty(obj.fdsolver));                    obj.fdsolver                    = CST.FDSolver(obj, obj.hProject);                    end; fdsolver                    = obj.fdsolver;                    end
        function fieldsource                 = FieldSource(obj);                 if(isempty(obj.fieldsource));                 obj.fieldsource                 = CST.FieldSource(obj, obj.hProject);                 end; fieldsource                 = obj.fieldsource;                 end
        function floquetport                 = FloquetPort(obj);                 if(isempty(obj.floquetport));                 obj.floquetport                 = CST.FloquetPort(obj, obj.hProject);                 end; floquetport                 = obj.floquetport;                 end
        function fluiddomain                 = FluidDomain(obj);                 if(isempty(obj.fluiddomain));                 obj.fluiddomain                 = CST.FluidDomain(obj, obj.hProject);                 end; fluiddomain                 = obj.fluiddomain;                 end
        function force                       = Force(obj);                       if(isempty(obj.force));                       obj.force                       = CST.Force(obj, obj.hProject);                       end; force                       = obj.force;                       end
        function gdsii                       = GDSII(obj);                       if(isempty(obj.gdsii));                       obj.gdsii                       = CST.GDSII(obj, obj.hProject);                       end; gdsii                       = obj.gdsii;                       end
        function gerber                      = GERBER(obj);                      if(isempty(obj.gerber));                      obj.gerber                      = CST.GERBER(obj, obj.hProject);                      end; gerber                      = obj.gerber;                      end
        function group                       = Group(obj);                       if(isempty(obj.group));                       obj.group                       = CST.Group(obj, obj.hProject);                       end; group                       = obj.group;                       end
        function heatsource                  = HeatSource(obj);                  if(isempty(obj.heatsource));                  obj.heatsource                  = CST.HeatSource(obj, obj.hProject);                  end; heatsource                  = obj.heatsource;                  end
        function hfss                        = HFSS(obj);                        if(isempty(obj.hfss));                        obj.hfss                        = CST.HFSS(obj, obj.hProject);                        end; hfss                        = obj.hfss;                        end
        function humanmodel                  = HumanModel(obj);                  if(isempty(obj.humanmodel));                  obj.humanmodel                  = CST.HumanModel(obj, obj.hProject);                  end; humanmodel                  = obj.humanmodel;                  end
        function iesolver                    = IESolver(obj);                    if(isempty(obj.iesolver));                    obj.iesolver                    = CST.IESolver(obj, obj.hProject);                    end; iesolver                    = obj.iesolver;                    end
        function iges                        = IGES(obj);                        if(isempty(obj.iges));                        obj.iges                        = CST.IGES(obj, obj.hProject);                        end; iges                        = obj.iges;                        end
        function interiorboundary            = InteriorBoundary(obj);            if(isempty(obj.interiorboundary));            obj.interiorboundary            = CST.InteriorBoundary(obj, obj.hProject);            end; interiorboundary            = obj.interiorboundary;            end
        function layerstacking               = LayerStacking(obj);               if(isempty(obj.layerstacking));               obj.layerstacking               = CST.LayerStacking(obj, obj.hProject);               end; layerstacking               = obj.layerstacking;               end
        function layoutdb                    = LayoutDB(obj);                    if(isempty(obj.layoutdb));                    obj.layoutdb                    = CST.LayoutDB(obj, obj.hProject);                    end; layoutdb                    = obj.layoutdb;                    end
        function lfsolver                    = LFSolver(obj);                    if(isempty(obj.lfsolver));                    obj.lfsolver                    = CST.LFSolver(obj, obj.hProject);                    end; lfsolver                    = obj.lfsolver;                    end
        function line                        = Line(obj);                        if(isempty(obj.line));                        obj.line                        = CST.Line(obj, obj.hProject);                        end; line                        = obj.line;                        end
        function livelink                    = LiveLink(obj);                    if(isempty(obj.livelink));                    obj.livelink                    = CST.LiveLink(obj, obj.hProject);                    end; livelink                    = obj.livelink;                    end
        function localmodification           = LocalModification(obj);           if(isempty(obj.localmodification));           obj.localmodification           = CST.LocalModification(obj, obj.hProject);           end; localmodification           = obj.localmodification;           end
        function loft                        = Loft(obj);                        if(isempty(obj.loft));                        obj.loft                        = CST.Loft(obj, obj.hProject);                        end; loft                        = obj.loft;                        end
        function loftcurves                  = LoftCurves(obj);                  if(isempty(obj.loftcurves));                  obj.loftcurves                  = CST.LoftCurves(obj, obj.hProject);                  end; loftcurves                  = obj.loftcurves;                  end
        function lumpedelement               = LumpedElement(obj);               if(isempty(obj.lumpedelement));               obj.lumpedelement               = CST.LumpedElement(obj, obj.hProject);               end; lumpedelement               = obj.lumpedelement;               end
        function lumpedfaceelement           = LumpedFaceElement(obj);           if(isempty(obj.lumpedfaceelement));           obj.lumpedfaceelement           = CST.LumpedFaceElement(obj, obj.hProject);           end; lumpedfaceelement           = obj.lumpedfaceelement;           end
        function magnet                      = Magnet(obj);                      if(isempty(obj.magnet));                      obj.magnet                      = CST.Magnet(obj, obj.hProject);                      end; magnet                      = obj.magnet;                      end
        function material                    = Material(obj);                    if(isempty(obj.material));                    obj.material                    = CST.Material(obj, obj.hProject);                    end; material                    = obj.material;                    end
        function mecadtron                   = Mecadtron(obj);                   if(isempty(obj.mecadtron));                   obj.mecadtron                   = CST.Mecadtron(obj, obj.hProject);                   end; mecadtron                   = obj.mecadtron;                   end
        function mechfieldsettings           = MechFieldSettings(obj);           if(isempty(obj.mechfieldsettings));           obj.mechfieldsettings           = CST.MechFieldSettings(obj, obj.hProject);           end; mechfieldsettings           = obj.mechfieldsettings;           end
        function mesh                        = Mesh(obj);                        if(isempty(obj.mesh));                        obj.mesh                        = CST.Mesh(obj, obj.hProject);                        end; mesh                        = obj.mesh;                        end
        function meshadaption3d              = MeshAdaption3D(obj);              if(isempty(obj.meshadaption3d));              obj.meshadaption3d              = CST.MeshAdaption3D(obj, obj.hProject);              end; meshadaption3d              = obj.meshadaption3d;              end
        function meshsettings                = MeshSettings(obj);                if(isempty(obj.meshsettings));                obj.meshsettings                = CST.MeshSettings(obj, obj.hProject);                end; meshsettings                = obj.meshsettings;                end
        function monitor                     = Monitor(obj);                     if(isempty(obj.monitor));                     obj.monitor                     = CST.Monitor(obj, obj.hProject);                     end; monitor                     = obj.monitor;                     end
        function motiongap                   = MotionGap(obj);                   if(isempty(obj.motiongap));                   obj.motiongap                   = CST.MotionGap(obj, obj.hProject);                   end; motiongap                   = obj.motiongap;                   end
        function movingmedia                 = MovingMedia(obj);                 if(isempty(obj.movingmedia));                 obj.movingmedia                 = CST.MovingMedia(obj, obj.hProject);                 end; movingmedia                 = obj.movingmedia;                 end
        function mqstdsolver                 = MQSTDSolver(obj);                 if(isempty(obj.mqstdsolver));                 obj.mqstdsolver                 = CST.MQSTDSolver(obj, obj.hProject);                 end; mqstdsolver                 = obj.mqstdsolver;                 end
        function mstaticsolver               = MStaticSolver(obj);               if(isempty(obj.mstaticsolver));               obj.mstaticsolver               = CST.MStaticSolver(obj, obj.hProject);               end; mstaticsolver               = obj.mstaticsolver;               end
        function nastran                     = NASTRAN(obj);                     if(isempty(obj.nastran));                     obj.nastran                     = CST.NASTRAN(obj, obj.hProject);                     end; nastran                     = obj.nastran;                     end
        function nearfieldscan               = NearfieldScan(obj);               if(isempty(obj.nearfieldscan));               obj.nearfieldscan               = CST.NearfieldScan(obj, obj.hProject);               end; nearfieldscan               = obj.nearfieldscan;               end
        function networkparameterextraction  = NetworkParameterExtraction(obj);  if(isempty(obj.networkparameterextraction));  obj.networkparameterextraction  = CST.NetworkParameterExtraction(obj, obj.hProject);  end; networkparameterextraction  = obj.networkparameterextraction;  end
        function nfsfile                     = NFSFile(obj);                     if(isempty(obj.nfsfile));                     obj.nfsfile                     = CST.NFSFile(obj, obj.hProject);                     end; nfsfile                     = obj.nfsfile;                     end
        function obj_                        = OBJ(obj);                         if(isempty(obj.obj_));                        obj.obj_                        = CST.OBJ(obj, obj.hProject);                        end; obj_                        = obj.obj_;                        end
        function optimizer                   = Optimizer(obj);                   if(isempty(obj.optimizer));                   obj.optimizer                   = CST.Optimizer(obj, obj.hProject);                   end; optimizer                   = obj.optimizer;                   end
        function parametersweep              = ParameterSweep(obj);              if(isempty(obj.parametersweep));              obj.parametersweep              = CST.ParameterSweep(obj, obj.hProject);              end; parametersweep              = obj.parametersweep;              end
        function parasolid                   = Parasolid(obj);                   if(isempty(obj.parasolid));                   obj.parasolid                   = CST.Parasolid(obj, obj.hProject);                   end; parasolid                   = obj.parasolid;                   end
        function particle2dmonitorreader     = Particle2DMonitorReader(obj);     if(isempty(obj.particle2dmonitorreader));     obj.particle2dmonitorreader     = CST.Particle2DMonitorReader(obj, obj.hProject);     end; particle2dmonitorreader     = obj.particle2dmonitorreader;     end
        function particlebeam                = ParticleBeam(obj);                if(isempty(obj.particlebeam));                obj.particlebeam                = CST.ParticleBeam(obj, obj.hProject);                end; particlebeam                = obj.particlebeam;                end
        function particleinterface           = ParticleInterface(obj);           if(isempty(obj.particleinterface));           obj.particleinterface           = CST.ParticleInterface(obj, obj.hProject);           end; particleinterface           = obj.particleinterface;           end
        function particlemonitor             = ParticleMonitor(obj);             if(isempty(obj.particlemonitor));             obj.particlemonitor             = CST.ParticleMonitor(obj, obj.hProject);             end; particlemonitor             = obj.particlemonitor;             end
        function particlemonitoronsolid      = ParticleMonitorOnSolid(obj);      if(isempty(obj.particlemonitoronsolid));      obj.particlemonitoronsolid      = CST.ParticleMonitorOnSolid(obj, obj.hProject);      end; particlemonitoronsolid      = obj.particlemonitoronsolid;      end
        function particlesource              = ParticleSource(obj);              if(isempty(obj.particlesource));              obj.particlesource              = CST.ParticleSource(obj, obj.hProject);              end; particlesource              = obj.particlesource;              end
        function particletrajectoryreader    = ParticleTrajectoryReader(obj);    if(isempty(obj.particletrajectoryreader));    obj.particletrajectoryreader    = CST.ParticleTrajectoryReader(obj, obj.hProject);    end; particletrajectoryreader    = obj.particletrajectoryreader;    end
        function pic2dmonitor                = PIC2DMonitor(obj);                if(isempty(obj.pic2dmonitor));                obj.pic2dmonitor                = CST.PIC2DMonitor(obj, obj.hProject);                end; pic2dmonitor                = obj.pic2dmonitor;                end
        function pic2dmonitorreader          = PIC2DMonitorReader(obj);          if(isempty(obj.pic2dmonitorreader));          obj.pic2dmonitorreader          = CST.PIC2DMonitorReader(obj, obj.hProject);          end; pic2dmonitorreader          = obj.pic2dmonitorreader;          end
        function pick                        = Pick(obj);                        if(isempty(obj.pick));                        obj.pick                        = CST.Pick(obj, obj.hProject);                        end; pick                        = obj.pick;                        end
        function picphasespacemonitor        = PICPhaseSpaceMonitor(obj);        if(isempty(obj.picphasespacemonitor));        obj.picphasespacemonitor        = CST.PICPhaseSpaceMonitor(obj, obj.hProject);        end; picphasespacemonitor        = obj.picphasespacemonitor;        end
        function picpositionmonitor          = PICPositionMonitor(obj);          if(isempty(obj.picpositionmonitor));          obj.picpositionmonitor          = CST.PICPositionMonitor(obj, obj.hProject);          end; picpositionmonitor          = obj.picpositionmonitor;          end
        function picpositionmonitorreader    = PICPositionMonitorReader(obj);    if(isempty(obj.picpositionmonitorreader));    obj.picpositionmonitorreader    = CST.PICPositionMonitorReader(obj, obj.hProject);    end; picpositionmonitorreader    = obj.picpositionmonitorreader;    end
        function picsolver                   = PICSolver(obj);                   if(isempty(obj.picsolver));                   obj.picsolver                   = CST.PICSolver(obj, obj.hProject);                   end; picsolver                   = obj.picsolver;                   end
        function planewave                   = PlaneWave(obj);                   if(isempty(obj.planewave));                   obj.planewave                   = CST.PlaneWave(obj, obj.hProject);                   end; planewave                   = obj.planewave;                   end
        function plot                        = Plot(obj);                        if(isempty(obj.plot));                        obj.plot                        = CST.Plot(obj, obj.hProject);                        end; plot                        = obj.plot;                        end
        function plot1d                      = Plot1D(obj);                      if(isempty(obj.plot1d));                      obj.plot1d                      = CST.Plot1D(obj, obj.hProject);                      end; plot1d                      = obj.plot1d;                      end
        function polygon                     = Polygon(obj);                     if(isempty(obj.polygon));                     obj.polygon                     = CST.Polygon(obj, obj.hProject);                     end; polygon                     = obj.polygon;                     end
        function polygon3d                   = Polygon3D(obj);                   if(isempty(obj.polygon3d));                   obj.polygon3d                   = CST.Polygon3D(obj, obj.hProject);                   end; polygon3d                   = obj.polygon3d;                   end
        function port                        = Port(obj);                        if(isempty(obj.port));                        obj.port                        = CST.Port(obj, obj.hProject);                        end; port                        = obj.port;                        end
        function postprocess1d               = PostProcess1D(obj);               if(isempty(obj.postprocess1d));               obj.postprocess1d               = CST.PostProcess1D(obj, obj.hProject);               end; postprocess1d               = obj.postprocess1d;               end
        function potential                   = Potential(obj);                   if(isempty(obj.potential));                   obj.potential                   = CST.Potential(obj, obj.hProject);                   end; potential                   = obj.potential;                   end
        function predefinedfield             = PredefinedField(obj);             if(isempty(obj.predefinedfield));             obj.predefinedfield             = CST.PredefinedField(obj, obj.hProject);             end; predefinedfield             = obj.predefinedfield;             end
        function probe                       = Probe(obj);                       if(isempty(obj.probe));                       obj.probe                       = CST.Probe(obj, obj.hProject);                       end; probe                       = obj.probe;                       end
        function proe                        = PROE(obj);                        if(isempty(obj.proe));                        obj.proe                        = CST.PROE(obj, obj.hProject);                        end; proe                        = obj.proe;                        end
        function qfactor                     = QFactor(obj);                     if(isempty(obj.qfactor));                     obj.qfactor                     = CST.QFactor(obj, obj.hProject);                     end; qfactor                     = obj.qfactor;                     end
        function rayresultcreator            = RayResultCreator(obj);            if(isempty(obj.rayresultcreator));            obj.rayresultcreator            = CST.RayResultCreator(obj, obj.hProject);            end; rayresultcreator            = obj.rayresultcreator;            end
        function rectangle                   = Rectangle(obj);                   if(isempty(obj.rectangle));                   obj.rectangle                   = CST.Rectangle(obj, obj.hProject);                   end; rectangle                   = obj.rectangle;                   end
%       function result0d                    = Result0D(obj, resultname);        if(isempty(obj.result0d));                    obj.result0d                    = CST.Result0D(obj, obj.hProject, resultname);        end; result0d                    = obj.result0d;                    end
        % Each result0d can be different depending on resultname, so don't store it.
        function result0d                    = Result0D(obj, resultname);                                                          result0d                    = CST.Result0D(obj, obj.hProject, resultname);                                                                            end
%       function result1d                    = Result1D(obj, resultname);        if(isempty(obj.result1d));                    obj.result1d                    = CST.Result1D(obj, obj.hProject, resultname);        end; result1d                    = obj.result1d;                    end
        % Each result1d can be different depending on resultname, so don't store it.
        function result1d                    = Result1D(obj, resultname);                                                          result1d                    = CST.Result1D(obj, obj.hProject, resultname);                                                                            end
%       function result1dcomplex             = Result1DComplex(obj, resultname); if(isempty(obj.result1dcomplex));             obj.result1dcomplex             = CST.Result1DComplex(obj, obj.hProject, resultname); end; result1dcomplex             = obj.result1dcomplex;             end
        % Each result1dcomplex can be different depending on resultname, so don't store it.
        function result1dcomplex             = Result1DComplex(obj, resultname);                                                   result1dcomplex             = CST.Result1DComplex(obj, obj.hProject, resultname);                                                                     end
%       function result2d                    = Result2D(obj, resultname);        if(isempty(obj.result2d));                    obj.result2d                    = CST.Result2D(obj, obj.hProject, resultname);        end; result2d                    = obj.result2d;                    end
        % Each result2d can be different depending on resultname, so don't store it.
        function result2d                    = Result2D(obj, resultname);                                                          result2d                    = CST.Result2D(obj, obj.hProject, resultname);                                                                            end
%       function result3d                    = Result3D(obj, resultname);        if(isempty(obj.result3d));                    obj.result3d                    = CST.Result3D(obj, obj.hProject, resultname);        end; result3d                    = obj.result3d;                    end
        % Each result3d can be different depending on resultname, so don't store it.
        function result3d                    = Result3D(obj, resultname);                                                          result3d                    = CST.Result3D(obj, obj.hProject, resultname);                                                                            end
        function resultdatabase              = ResultDatabase(obj);              if(isempty(obj.resultdatabase));              obj.resultdatabase              = CST.ResultDatabase(obj, obj.hProject);              end; resultdatabase              = obj.resultdatabase;              end
%       function resultmap                   = ResultMap(obj, treepath);         if(isempty(obj.resultmap));                   obj.resultmap                   = CST.ResultMap(obj, obj.hProject, treepath);         end; resultmap                   = obj.resultmap;                   end
        % Each resultmap can be different depending on treepath, so don't store it.
        function resultmap                   = ResultMap(obj, treepath);                                                           resultmap                   = CST.ResultMap(obj, obj.hProject, treepath);                                                                             end
%       function resultmatrix                = ResultMatrix(obj, treepath);      if(isempty(obj.resultmatrix));                obj.resultmatrix                = CST.ResultMatrix(obj, obj.hProject, treepath);      end; resultmatrix                = obj.resultmatrix;                end
        % Each resultmatrix can be different depending on treepath, so don't store it.
        function resultmatrix                = ResultMatrix(obj, treepath);                                                        resultmatrix                = CST.ResultMatrix(obj, obj.hProject, treepath);                                                                          end
        function resulttree                  = ResultTree(obj);                  if(isempty(obj.resulttree));                  obj.resulttree                  = CST.ResultTree(obj, obj.hProject);                  end; resulttree                  = obj.resulttree;                  end
        function rigidbodymotion             = RigidBodyMotion(obj);             if(isempty(obj.rigidbodymotion));             obj.rigidbodymotion             = CST.RigidBodyMotion(obj, obj.hProject);             end; rigidbodymotion             = obj.rigidbodymotion;             end
        function rotate                      = Rotate(obj);                      if(isempty(obj.rotate));                      obj.rotate                      = CST.Rotate(obj, obj.hProject);                      end; rotate                      = obj.rotate;                      end
        function sar                         = SAR(obj);                         if(isempty(obj.sar));                         obj.sar                         = CST.SAR(obj, obj.hProject);                         end; sar                         = obj.sar;                         end
        function sat                         = SAT(obj);                         if(isempty(obj.sat));                         obj.sat                         = CST.SAT(obj, obj.hProject);                         end; sat                         = obj.sat;                         end
        function scalarplot2d                = ScalarPlot2D(obj);                if(isempty(obj.scalarplot2d));                obj.scalarplot2d                = CST.ScalarPlot2D(obj, obj.hProject);                end; scalarplot2d                = obj.scalarplot2d;                end
        function scalarplot3d                = ScalarPlot3D(obj);                if(isempty(obj.scalarplot3d));                obj.scalarplot3d                = CST.ScalarPlot3D(obj, obj.hProject);                end; scalarplot3d                = obj.scalarplot3d;                end
        function sensitivityanalysis         = SensitivityAnalysis(obj);         if(isempty(obj.sensitivityanalysis));         obj.sensitivityanalysis         = CST.SensitivityAnalysis(obj, obj.hProject);         end; sensitivityanalysis         = obj.sensitivityanalysis;         end
        function siemensnx                   = SiemensNX(obj);                   if(isempty(obj.siemensnx));                   obj.siemensnx                   = CST.SiemensNX(obj, obj.hProject);                   end; siemensnx                   = obj.siemensnx;                   end
        function simulationproject           = SimulationProject(obj);           if(isempty(obj.simulationproject));           obj.simulationproject           = CST.SimulationProject(obj, obj.hProject);           end; simulationproject           = obj.simulationproject;           end
        function simuliacse                  = SimuliaCSE(obj);                  if(isempty(obj.simuliacse));                  obj.simuliacse                  = CST.SimuliaCSE(obj, obj.hProject);                  end; simuliacse                  = obj.simuliacse;                  end
        function solid                       = Solid(obj);                       if(isempty(obj.solid));                       obj.solid                       = CST.Solid(obj, obj.hProject);                       end; solid                       = obj.solid;                       end
        function solidedge                   = SolidEdge(obj);                   if(isempty(obj.solidedge));                   obj.solidedge                   = CST.SolidEdge(obj, obj.hProject);                   end; solidedge                   = obj.solidedge;                   end
        function solidworks                  = SolidWorks(obj);                  if(isempty(obj.solidworks));                  obj.solidworks                  = CST.SolidWorks(obj, obj.hProject);                  end; solidworks                  = obj.solidworks;                  end
        function solver                      = Solver(obj);                      if(isempty(obj.solver));                      obj.solver                      = CST.Solver(obj, obj.hProject);                      end; solver                      = obj.solver;                      end
        function solverparameter             = SolverParameter(obj);             if(isempty(obj.solverparameter));             obj.solverparameter             = CST.SolverParameter(obj, obj.hProject);             end; solverparameter             = obj.solverparameter;             end
        function sourcefield                 = SourceField(obj);                 if(isempty(obj.sourcefield));                 obj.sourcefield                 = CST.SourceField(obj, obj.hProject);                 end; sourcefield                 = obj.sourcefield;                 end
        function sphere                      = Sphere(obj);                      if(isempty(obj.sphere));                      obj.sphere                      = CST.Sphere(obj, obj.hProject);                      end; sphere                      = obj.sphere;                      end
        function spline                      = Spline(obj);                      if(isempty(obj.spline));                      obj.spline                      = CST.Spline(obj, obj.hProject);                      end; spline                      = obj.spline;                      end
        function stationarycurrentsolver     = StationaryCurrentSolver(obj);     if(isempty(obj.stationarycurrentsolver));     obj.stationarycurrentsolver     = CST.StationaryCurrentSolver(obj, obj.hProject);     end; stationarycurrentsolver     = obj.stationarycurrentsolver;     end
        function step                        = STEP(obj);                        if(isempty(obj.step));                        obj.step                        = CST.STEP(obj, obj.hProject);                        end; step                        = obj.step;                        end
        function stl                         = STL(obj);                         if(isempty(obj.stl));                         obj.stl                         = CST.STL(obj, obj.hProject);                         end; stl                         = obj.stl;                         end
        function structuralmechanicssolver   = StructuralMechanicsSolver(obj);   if(isempty(obj.structuralmechanicssolver));   obj.structuralmechanicssolver   = CST.StructuralMechanicsSolver(obj, obj.hProject);   end; structuralmechanicssolver   = obj.structuralmechanicssolver;   end
        function sweepcurve                  = SweepCurve(obj);                  if(isempty(obj.sweepcurve));                  obj.sweepcurve                  = CST.SweepCurve(obj, obj.hProject);                  end; sweepcurve                  = obj.sweepcurve;                  end
%       function table                       = Table(obj, tablefilename);        if(isempty(obj.table));                       obj.table                       = CST.Table(obj, obj.hProject, tablefilename);        end; table                       = obj.table;                       end
        % Each table can be different depending on tablefilename, so don't store it.
        function table                       = Table(obj, tablefilename);                                                          table                       = CST.Table(obj, obj.hProject, tablefilename);                                                                            end
        function temperaturesource           = TemperatureSource(obj);           if(isempty(obj.temperaturesource));           obj.temperaturesource           = CST.TemperatureSource(obj, obj.hProject);           end; temperaturesource           = obj.temperaturesource;           end
        function thermallossimport           = ThermalLossImport(obj);           if(isempty(obj.thermallossimport));           obj.thermallossimport           = CST.ThermalLossImport(obj, obj.hProject);           end; thermallossimport           = obj.thermallossimport;           end
        function thermalsolver               = ThermalSolver(obj);               if(isempty(obj.thermalsolver));               obj.thermalsolver               = CST.ThermalSolver(obj, obj.hProject);               end; thermalsolver               = obj.thermalsolver;               end
        function thermalsourceparameter      = ThermalSourceParameter(obj);      if(isempty(obj.thermalsourceparameter));      obj.thermalsourceparameter      = CST.ThermalSourceParameter(obj, obj.hProject);      end; thermalsourceparameter      = obj.thermalsourceparameter;      end
        function thermalsurfaceproperty      = ThermalSurfaceProperty(obj);      if(isempty(obj.thermalsurfaceproperty));      obj.thermalsurfaceproperty      = CST.ThermalSurfaceProperty(obj, obj.hProject);      end; thermalsurfaceproperty      = obj.thermalsurfaceproperty;      end
        function thermaltdsolver             = ThermalTDSolver(obj);             if(isempty(obj.thermaltdsolver));             obj.thermaltdsolver             = CST.ThermalTDSolver(obj, obj.hProject);             end; thermaltdsolver             = obj.thermaltdsolver;             end
        function timemonitor                 = TimeMonitor(obj);                 if(isempty(obj.timemonitor));                 obj.timemonitor                 = CST.TimeMonitor(obj, obj.hProject);                 end; timemonitor                 = obj.timemonitor;                 end
        function timemonitor0d               = TimeMonitor0D(obj);               if(isempty(obj.timemonitor0d));               obj.timemonitor0d               = CST.TimeMonitor0D(obj, obj.hProject);               end; timemonitor0d               = obj.timemonitor0d;               end
        function timemonitor1d               = TimeMonitor1D(obj);               if(isempty(obj.timemonitor1d));               obj.timemonitor1d               = CST.TimeMonitor1D(obj, obj.hProject);               end; timemonitor1d               = obj.timemonitor1d;               end
        function timemonitor2d               = TimeMonitor2D(obj);               if(isempty(obj.timemonitor2d));               obj.timemonitor2d               = CST.TimeMonitor2D(obj, obj.hProject);               end; timemonitor2d               = obj.timemonitor2d;               end
        function timemonitor3d               = TimeMonitor3D(obj);               if(isempty(obj.timemonitor3d));               obj.timemonitor3d               = CST.TimeMonitor3D(obj, obj.hProject);               end; timemonitor3d               = obj.timemonitor3d;               end
        function timesignal                  = TimeSignal(obj);                  if(isempty(obj.timesignal));                  obj.timesignal                  = CST.TimeSignal(obj, obj.hProject);                  end; timesignal                  = obj.timesignal;                  end
        function torus                       = Torus(obj);                       if(isempty(obj.torus));                       obj.torus                       = CST.Torus(obj, obj.hProject);                       end; torus                       = obj.torus;                       end
        function touchstone                  = TOUCHSTONE(obj);                  if(isempty(obj.touchstone));                  obj.touchstone                  = CST.TOUCHSTONE(obj, obj.hProject);                  end; touchstone                  = obj.touchstone;                  end
        function tracefromcurve              = TraceFromCurve(obj);              if(isempty(obj.tracefromcurve));              obj.tracefromcurve              = CST.TraceFromCurve(obj, obj.hProject);              end; tracefromcurve              = obj.tracefromcurve;              end
        function trackingplot                = TrackingPlot(obj);                if(isempty(obj.trackingplot));                obj.trackingplot                = CST.TrackingPlot(obj, obj.hProject);                end; trackingplot                = obj.trackingplot;                end
        function trackingsolver              = TrackingSolver(obj);              if(isempty(obj.trackingsolver));              obj.trackingsolver              = CST.TrackingSolver(obj, obj.hProject);              end; trackingsolver              = obj.trackingsolver;              end
        function traction                    = Traction(obj);                    if(isempty(obj.traction));                    obj.traction                    = CST.Traction(obj, obj.hProject);                    end; traction                    = obj.traction;                    end
        function transform                   = Transform(obj);                   if(isempty(obj.transform));                   obj.transform                   = CST.Transform_(obj, obj.hProject);                   end; transform                   = obj.transform;                   end
        function trimcurves                  = TrimCurves(obj);                  if(isempty(obj.trimcurves));                  obj.trimcurves                  = CST.TrimCurves(obj, obj.hProject);                  end; trimcurves                  = obj.trimcurves;                  end
        function units                       = Units(obj);                       if(isempty(obj.units));                       obj.units                       = CST.Units(obj, obj.hProject);                       end; units                       = obj.units;                       end
        function vdafs                       = VDAFS(obj);                       if(isempty(obj.vdafs));                       obj.vdafs                       = CST.VDAFS(obj, obj.hProject);                       end; vdafs                       = obj.vdafs;                       end
        function vectorplot2d                = VectorPlot2D(obj);                if(isempty(obj.vectorplot2d));                obj.vectorplot2d                = CST.VectorPlot2D(obj, obj.hProject);                end; vectorplot2d                = obj.vectorplot2d;                end
        function vectorplot3d                = VectorPlot3D(obj);                if(isempty(obj.vectorplot3d));                obj.vectorplot3d                = CST.VectorPlot3D(obj, obj.hProject);                end; vectorplot3d                = obj.vectorplot3d;                end
        function voltagemonitor              = VoltageMonitor(obj);              if(isempty(obj.voltagemonitor));              obj.voltagemonitor              = CST.VoltageMonitor(obj, obj.hProject);              end; voltagemonitor              = obj.voltagemonitor;              end
        function voltagewire                 = VoltageWire(obj);                 if(isempty(obj.voltagewire));                 obj.voltagewire                 = CST.VoltageWire(obj, obj.hProject);                 end; voltagewire                 = obj.voltagewire;                 end
        function wakefieldpostprocessor      = WakefieldPostprocessor(obj);      if(isempty(obj.wakefieldpostprocessor));      obj.wakefieldpostprocessor      = CST.WakefieldPostprocessor(obj, obj.hProject);      end; wakefieldpostprocessor      = obj.wakefieldpostprocessor;      end
        function wcs                         = WCS(obj);                         if(isempty(obj.wcs));                         obj.wcs                         = CST.WCS(obj, obj.hProject);                         end; wcs                         = obj.wcs;                         end
        function wire                        = Wire(obj);                        if(isempty(obj.wire));                        obj.wire                        = CST.Wire(obj, obj.hProject);                        end; wire                        = obj.wire;                        end
        function yieldanalysis               = YieldAnalysis(obj);               if(isempty(obj.yieldanalysis));               obj.yieldanalysis               = CST.YieldAnalysis(obj, obj.hProject);               end; yieldanalysis               = obj.yieldanalysis;               end
    end
end