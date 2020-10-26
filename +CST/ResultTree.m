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

% Offers methods to insert or delete user defined entries into the Navigation Tree . The name of the entries is defined by the Name method. Every backslash in this name creates another sub folder.
classdef ResultTree < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ResultTree object.
        function obj = ResultTree(project, hProject)
            obj.project = project;
            obj.hResultTree = hProject.invoke('ResultTree');
        end
    end
    %% CST Object functions.
    methods
        %% Tree Operations
        function Reset(obj)
            % Resets the current result tree item definition.
            obj.hResultTree.invoke('Reset');
        end
        function Add(obj)
            % Adds / deletes a previously specified tree item to / from the Navigation Tree.
            obj.hResultTree.invoke('Add');
        end
        function Delete(obj)
            % Adds / deletes a previously specified tree item to / from the Navigation Tree.
            obj.hResultTree.invoke('Delete');
        end
        function UpdateTree(obj)
            % Updates the appearance of the tree on the screen.
            obj.hResultTree.invoke('UpdateTree');
        end
        function EnableTreeUpdate(obj, boolean)
            % Enable or disable the update of the tree. After enabling the tree update, this method does actually update the tree also.
            obj.hResultTree.invoke('EnableTreeUpdate', boolean);
        end
        function GetFirstChildName(obj, sParentTreePath)
            % Get the name including tree path of the first child item of the specified parent item. An empty string will be returned if no child exists.
            obj.hResultTree.invoke('GetFirstChildName', sParentTreePath);
        end
        function GetNextItemName(obj, sCurrentTreeItem)
            % Get the name including tree path of the item following sCurrentTreeItem in the same tree folder. sCurrentTreeItem has to specify the tree folder and the current item name. An empty string will be returned if sCurrentTreeItem is the last item in the tree folder.
            obj.hResultTree.invoke('GetNextItemName', sCurrentTreeItem);
        end
        function RefreshView(obj)
            % Updates the results stored in the  tree.
            obj.hResultTree.invoke('RefreshView');
        end
        function bool = DoesTreeItemExist(obj, sTreepath)
            % Checks if an item called sTreepath exists in the Navigation Tree.
            bool = obj.hResultTree.invoke('DoesTreeItemExist', sTreepath);
        end
        function long = GetTreeResults(obj, rootPath, filterType, infoType, treePaths, resultTypes, fileNames, resultInformation)
            % Many reference arguments, as well as various Variant objects.
            error('Unimplemented function CST.ResultTree.GetTreeResults.\n');
            % Get result data of all children of a parent folder in the Navigation Tree. The string rootPath specifies the Navigation Tree path to the root item which is queried (typically a tree folder).  The method returns an error if no tree item exists for rootPath. The string filterType specifies which types of results should be included in the list. It can be a combination of the following types: "0D/1D", "2D/3D", "farfield", "colormap", "folder". Additionally, the string "recursive" can be used to include all sub-items recursively. If multiple types are requested, they need to be separated by white spaces, e.g. "folder 0D/1D recursive". In case the root item matches the filter, it will also be included.
            % The string infoType determines which additional information about the results is stored in the variant resultInformation. It can be an empty string or the string "filetype0D1D". In case "filetype0D1D" is used, the resultInfomation will contain data about the type of the 0D/1D result, which can be "complex, "real", "complex0D", "real0D" for all tree results of 0D/1D type.
            % The return value of this method is the number of elements which are found. The variants treepaths, resultTypes, fileNames, resultInformation are filled within the method call with a list of strings which contain information about the results. The variant treepath will contain the list of Navigation Tree paths for the results. The variant fileNames will contain the list of absolute filenames normalized to the Operating System. The variant resultTypes will contain the Result Type of the result. The variant resultInfomation will contain additional information about the result as specified by infoType or empty strings. See also the corresponding example.
            long = obj.hResultTree.invoke('GetTreeResults', rootPath, filterType, infoType, treePaths, resultTypes, fileNames, resultInformation);
        end
        %% Tree Item Methods
        function Name(obj, sTreePath)
            % Sets the Navigation Tree path including item name for the item.
            obj.hResultTree.invoke('Name', sTreePath);
        end
        function Type(obj, key)
            % Defines the result type of the tree item. See the Result Type Overview.
            obj.hResultTree.invoke('Type', key);
        end
        function Subtype(obj, key)
            % Defines the result sub type of the tree entry in case of a type = "XYSignal". Otherwise this setting has no effect.
            % enum key    meaning
            % "Complex"   Complex 1D data
            % "Linear"    Linear scaled real data
            % "dB"        Logarithmic scaled real plot
            % "Phase"     Phase data over frequency
            % "Time"      Time signal data
            % "Position"  Position depended data
            % "Energy"    Energy over time data
            % "Balance"   Energy balance over frequency data
            % "User"      User defined data
            obj.hResultTree.invoke('Subtype', key);
        end
        function Title(obj, name)
            % Defines the title / x-axis / y-axis label of the item.
            obj.hResultTree.invoke('Title', name);
        end
        function Xlabel(obj, name)
            % Defines the title / x-axis / y-axis label of the item.
            obj.hResultTree.invoke('Xlabel', name);
        end
        function Ylabel(obj, name)
            % Defines the title / x-axis / y-axis label of the item.
            obj.hResultTree.invoke('Ylabel', name);
        end
        function File(obj, sResultName)
            % Filename associated with the tree item. Either absolute file names or file names relative to the "Result" project folder are valid.
            obj.hResultTree.invoke('File', sResultName);
        end
        function DeleteAt(obj, type)
            % Defines the lifetime of the item.
            % enum type           meaning
            % "never"             The result will be never deleted.
            % "rebuild"           Deletion during model update. (default)
            % "solverstart"       A solver start will delete the result.
            % "truemodelchange"   A parameter change will delete the results.
            obj.hResultTree.invoke('DeleteAt', type);
        end
        function IsResult(obj, boolean)
            % If switch is True, the item is treated like a normal solver result item.
            obj.hResultTree.invoke('IsResult', boolean);
        end
        function string = GetResultTypeFromItemName(obj, sTreePath)
            % Returns the result type of the tree item. See the Result Type Overview.
            string = obj.hResultTree.invoke('GetResultTypeFromItemName', sTreePath);
        end
        function string = GetFileFromTreeItem(obj, sTreePath)
            % Returns the file name of the result file associated with this tree entry. If there is no result file, the return value will be an empty string.
            string = obj.hResultTree.invoke('GetFileFromTreeItem', sTreePath);
        end
        function string = GetTableFileFromItemName(obj, sTreePath)
            % Get the file name of the table if the tree item represents a table or an empty string.
            string = obj.hResultTree.invoke('GetTableFileFromItemName', sTreePath);
        end
        function variant = GetResultIDsFromTreeItem(obj, sTreePath)
            % Returns an array of Result IDs, which are strings are of the format "3D:RunID:1" and correspond to the existing Run IDs for the parametric data of the specified tree item. A Result ID can be resolved to a parameter combination with the command GetParameterCombination of the Project-object.
            variant = obj.hResultTree.invoke('GetResultIDsFromTreeItem', sTreePath);
        end
        function object = GetResultFromTreeItem(obj, sTreePath, sResultID)
            % Returns a result object containing the data specified by 'sTreePath' and 'sResultID' . The return value can be a Result0D, a Result 1D or a Result 1D Complex object. In case no data exists, a reference to an object is returned that is nothing. This can be queried via the VBA keyword Nothing (e.g. If(myObject Is Nothing)Then...). The method returns an error, if the tree item does not exist or the Result ID is invalid.
            % (2020) [Can also be a] Result 2D or a Result Matrix object.
            object = obj.hResultTree.invoke('GetResultFromTreeItem', sTreePath, sResultID);
        end
        function object = GetImpedanceResultFromTreeItem(obj, sTreePath, sResultID)
            % Returns a result object containing the reference impedance data of the tree item specified by 'sTreePath' and 'sResultID' . The return value can be a Result0D, a Result 1D or a Result 1D Complex object. In case no data exists, a reference to an object is returned that is nothing. This can be queried via the VBA keyword Nothing (e.g. If(myObject Is Nothing)Then...). The method also returns an error, if the tree item does not exist or the Result ID is invalid.
            object = obj.hResultTree.invoke('GetImpedanceResultFromTreeItem', sTreePath, sResultID);
        end
        function bool = TreeItemHasImpedance(obj, sTreePath, sResultID)
            % Returns whether the data specified by 'sTreePath' and 'sResultID' has reference impedances attached to it. This data can be accessed with GetImpedanceResultFromTreeItem. The method returns an error, if the tree item does not exist or if the Result ID is invalid.
            bool = obj.hResultTree.invoke('TreeItemHasImpedance', sTreePath, sResultID);
        end
        %% CST 2013 functions.
        function Macro(obj, sCommand)
            % Sets the string to be evaluated by the VBA Interpreter.
            obj.hResultTree.invoke('Macro', sCommand);
        end
        function string = GetTypeFromItemName(obj, sTreePath)
            % Returns the result type of the tree item. See the Result Type Overview.
            string = obj.hResultTree.invoke('GetTypeFromItemName', sTreePath);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hResultTree

    end
end

%% Default Settings

%% Example - Taken from CST documentation and translated to MATLAB.
% The ResultTree VBA Object offers very interesting possibilities to configure the Navigation Tree. It is possible to insert different simulation results as well as VBA macros. The following examples will show its functionality.
%
% General Example to add items into the tree
% Add text file into tree
% Example to access 1D Results
% Please refer to the examples section of the Result0D, Result 1D or Result 1D Complex objects to see how 1D data can be added to the Navigation Tree.
% Iterate over parametric S-Parameter data:  This macro demonstrates access to parametric 1D data.
% List all items and folders below '1D Results':  This macro demonstrates the use of GetTreeResults.
% Example to add field results into the tree
% For results others than 1D Results only those of the current project can be inserted into the tree!
% Add Field Monitor Result into Tree: Adds a 3D-Vector result into the tree.
% Add Farfield Monitor Result into Tree: Adds a farfield monitor into the tree.
%
%% Example Add text file into tree
% Add a generic ASCII text file with the name('Some Information'); to the tree. The file('Sometext.nfo'); needs to be located in the project%s sub folder('Model\3D');. The file name can be arbitrary, but should have the extension('.nfo');
%
% resulttree = project.ResultTree();
% resulttree.Name('Some Information');
% resulttree.File('Sometext.nfo');
% resulttree.Type('Notefile');
% resulttree.DeleteAt('never'); % Survive rebuilds and delete results
% resulttree.Add();
%
% Delete the  tree item('Some Information');
%
% resulttree.Name('Some Information');
% resulttree.Delete();
%
%% Example Add Field Monitor Result into Tree
% Adds a field monitor result of the electric field from the current project into the folder "My Field".
%
% resulttree.Name('My Field\E_Field');   % Entry name and destination folder
% resulttree.File('e1_1.m3d');              % Result file name
% resulttree.Type('Efield3D');
% resulttree.Add();
%
%% Example Add Farfield Monitor Result into Tree
% Adds a farfield monitor result from the current project into the folder "My Field".
%
% % The entry name and its destination folder
% resulttree.Name('My Field\Farfield');   % Entry name and destination folder
% resulttree.File('ff1_1.ffm');              % Result file name
% resulttree.Type('Farfield');
% resulttree.Add();
%
%% Example Iterate over Parametric S-Parameter Data
% This macro demonstrates access to parametric data of an S-Parameter. The access works similar for arbitrary tree items below the 1D Results folder.
%
% TreeItem = '1D Results\S-Parameters\S1,1';
% %get an array of existing result ids for this tree item
% IDs = resulttree.GetResultIDsFromTreeItem(TreeItem)
% if(isempty(IDs))
%     disp('No parametric data available.');
% else
%     for N = 0:length(IDs)
%         spara = resulttree.GetResultFromTreeItem(TreeItem, IDs(N))
%         if(strcmpi(spara.GetResultObjectType(), '1DC'))
%             %access data of R1DC Object
%             disp('First data point: ', num2str(spara.GetYRe(0)), ', ', num2str(spara.GetYIm(0)))
%             if(resulttree.TreeItemHasImpedance(TreeItem, IDs(N)))
%                 ref_imp = resulttree.GetImpedanceResultFromTreeItem(TreeItem, IDs(N))
%                 %access data of R1DC Object containing ref. imp.
%                 disp('Ref. Imp. :', num2str(ref_imp.GetYRe(0)), ', ', num2str(ref_imp.GetYIm(0)))
%             end
%         end
%     end
% end
%
%% Example List all items and folders below('1D Results');
% This macro demonstrates the use of GetTreeResults. It recursively queries all 0D and 1D items and result folders below('1D Results'); and prints the gathered data to the message window.
%
% nResults = resulttree.GetTreeResults('1D Results', 'folder 0D/1D recursive', '', paths, types, files, info)
% for(n = 0:nResults-1)
%     disp('path: ', num2str(paths(n)), vbCrLf, 'type: ',  num2str(types(n)),  vbCrLf, 'file: ' + CStr(files(n)))
% end
%
%
%% CST 2013 Examples - Taken from CST 2013 documentation and translated to MATLAB.
%% Example Add Adaptation Error Plot into Tree
% Adds adaptation error plots from the current and an external project into one folder. Thus, the plots can be compared by clicking on the folder('My 1D Results');.
%
% resulttree = project.ResultTree();
% resulttree.Reset();
% resulttree.Name('My 1D Results\ExtProj');   % Entry name and its destination folder
% resulttree.Title('Error versus Passes');
% resulttree.File('ExtProj^adapt_error.sig'); % Name of external result file
% resulttree.Type('XYSignal');
% resulttree.XLabel('Pass');
% resulttree.Add();
% resulttree.Reset();
% resulttree.Name('My 1D Results\ThisProj');  % Entry name and its destination folder
% resulttree.Title('Error versus Passes');
% resulttree.File('^adapt_error.sig');        % Name of result file from current project
% resulttree.Type('XYSignal');
% resulttree.XLabel('Pass');
% resulttree.Add();
%
%% Example Add Command into Tree
% Adds a command into the "Userdefined" folder that starts the time domain solver.
%
% resulttree.Name('Userdefined\Macro1');   % Entry name and its destination folder
% resulttree.Macro('Solver.Start');        % String to be evaluated by VBA interpreter
% resulttree.Type('Macro');
% resulttree.Add();
%
%% Example Add Macro into Tree
% Adds the previously defined control macro "AutoTest" into the tree.
%
% At first a string will be defined that contains a VBA command that executes the control macro. The command is "RunMacro" that takes a string(the name of the control macro) as its argument. However, strings have to be specified within quotes. Unfortunately quotes are special characters which are not recognized as normal characters. They mark the start and the end of a string. Therefore the variable a is defined with a single quote as its only content. With this quote the entire command string can be constructed.
%
% a = 'RunMacro "AutoTest"'
%
% resulttree.Name('Userdefined\Macro2');   % Entry name and its destination folder
% resulttree.Macro(a)                      % String to be evaluated by VBA Interpreter
% resulttree.Type('Macro');
% resulttree.Add();
%
%% Example Add External Script into Tree
% Adds an external VBA script into the tree. Let the name of the external macro be "Macro1.bas" that will be located in the directory of the current project.
%
% At first a string will be defined that contains a VBA command that executes an external VBA script file. The command is "MacroRun" that takes a string(the name of the script) as its argument. However, strings have to be specified within quotes. Unfortunately quotes are special characters which are not recognized as normal characters. They mark the start and the end of a string. Therefore the variable a is defined with a single quote as its only content. With this quote the entire command string can be constructed.
%
% a = 'MacroRun "Macro1.bas"'
%
% resulttree.Name('Userdefined\Macro3');   % Entry name and its destination folder
% resulttree.Macro(a)                      % String to be evaluated by VBA Interpreter
% resulttree.Type('Macro');
% resulttree.Add();
% 