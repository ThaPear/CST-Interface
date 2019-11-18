%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object allows operations on the CST DESIGN STUDIO result tree.
classdef ResultTree < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a ResultTree object.
        function obj = ResultTree(project, hProject)
            obj.project = project;
            obj.hResultTree = hProject.invoke('ResultTree');
        end
    end
    %% CST Object functions.
    methods
        function string = GetNextItemName(obj, treeItemName)
            % Returns the next tree item name after "treeItemName". It does only return folder names in the same hierarchy level. If there is no next tree item the function returns an empty string.
            string = obj.hResultTree.invoke('GetNextItemName', treeItemName);
        end
        function string = GetFirstChildName(obj, treeItemName)
            % Returns the first child tree item of  "treeItemName". If there is no child of the specified tree item the function returns an empty string.
            string = obj.hResultTree.invoke('GetFirstChildName', treeItemName);
        end
        function string = GetFileFromTreeItem(obj, resultTreeItemName)
            % This function only affects tree items containing results. It returns the file name of the CST MICROWAVE STUDIO compatible result file associated with this entry. If there is no result file, the return value will be an empty string.
            string = obj.hResultTree.invoke('GetFileFromTreeItem', resultTreeItemName);
        end
        function string = GetTableFileFromItemName(obj, resultTreeItemName)
            % If the result tree item represents a table this function returns the file name of the table, otherwise an empty string will be returned.
            string = obj.hResultTree.invoke('GetTableFileFromItemName', resultTreeItemName);
        end
        function variant = GetResultIDsFromTreeItem(obj, treeItemName)
            % Returns an array of Result IDs, which are strings are of the format "Schematic:RunID:1" and correspond to the existing Run IDs for the parametric data of the specified tree item. A Result ID can be resolved to a parameter combination with the command GetParameterCombination of the Project object.
            variant = obj.hResultTree.invoke('GetResultIDsFromTreeItem', treeItemName);
        end
        function object = GetResultFromTreeItem(obj, treeItemName, resultID)
            % Returns a result object containing the data specified by 'treeItemName' and 'resultID' . The return value can be a Result0D, a Result 1D or a Result 1D Complex object.  In case no data exists, a reference to an object is returned that is nothing. This can be queried via the VBA keyword Nothing (e.g. If(myObject Is Nothing)Then...). The method returns an error, if the tree item does not exist or the Result ID is invalid.
            object = obj.hResultTree.invoke('GetResultFromTreeItem', treeItemName, resultID);
        end
        function object = GetImpedanceResultFromTreeItem(obj, treeItemName, resultID)
            % Returns a result object containing the reference impedance data of the tree item specified by 'treeItemName' and 'resultID' . The return value can be a Result0D, a Result 1D or a Result 1D Complex object. In case no data exists, a reference to an object is returned that is nothing. This can be queried via the VBA keyword Nothing (e.g. If(myObject Is Nothing)Then...). The method also returns an error, if the tree item does not exist or the Result ID is invalid.
            object = obj.hResultTree.invoke('GetImpedanceResultFromTreeItem', treeItemName, resultID);
        end
        function bool = TreeItemHasImpedance(obj, treeItemName, resultID)
            % Returns whether the data specified by 'treeItemName' and 'resultID'  has reference impedances attached to it. This data can be accessed with GetImpedanceResultFromTreeItem. The method returns an error, if the tree item does not exist or if the Result ID is invalid.
            bool = obj.hResultTree.invoke('TreeItemHasImpedance', treeItemName, resultID);
        end
        function long = GetTreeResults(obj, rootPath, filterType, infoType, treePaths, resultTypes, fileNames, resultInformation)
            % Get result data of all children of a parent folder in the Navigation Tree. The string rootPath specifies the Navigation Tree path to the root item which is queried (typically a tree folder). The method returns an error if no tree item exists for rootPath. The string filterType specifies which types of results should be included in the list. It can be a combination of the following types: "0D/1D", "2D/3D", "farfield", "colormap", "folder". Additionally, the string "recursive" can be used to include all sub-items recursively. If multiple types are requested, they need to be separated by white spaces, e.g. "folder 0D/1D recursive". In case the root item matches the filter, it will also be included. Please note that only Navigation Tree folders which contain 1D results are taken into account when the filter type "folder" is specified. Furthermore, please note that some Design Studio tree elements will not have an associated result type (e.g. Tasks) and therefore will not appear in the list for any filter type.
            % The string infoType determines which additional information about the results is stored in the variant resultInformation. It can be an empty string or the string "filetype0D1D". In case "filetype0D1D" is used, the resultInfomation will contain data about the type of the 0D/1D result, which can be "complex, "real", "complex0D", "real0D" for all tree results of 0D/1D type.
            % The return value of this method is the number of elements which are found. The variants treepaths, resultTypes, fileNames, resultInformation are filled within the method call with a list of strings which contain information about the results. The variant treepath will contain the list of Navigation Tree paths for the results. The variant fileNames will contain the list of absolute filenames normalized to the Operating System. The variant resultTypes will contain the Result Type of the result. The variant resultInfomation will contain additional information about the result as specified by infoType or empty strings. See also the corresponding example.
            long = obj.hResultTree.invoke('GetTreeResults', rootPath, filterType, infoType, treePaths, resultTypes, fileNames, resultInformation);
        end
        function Reset(obj)
            % Resets the current result tree item definition.
            obj.hResultTree.invoke('Reset');
        end
        function Add(obj)
            % Adds a previously specified tree item to / from the Navigation Tree.
            obj.hResultTree.invoke('Add');
        end
        function Delete(obj)
            % Deletes a previously specified tree item to / from the Navigation Tree.
            obj.hResultTree.invoke('Delete');
        end
        function bool = DoesTreeItemExist(obj, treeItemName)
            % Checks if an item called treeItemName exists in the Navigation Tree.
            bool = obj.hResultTree.invoke('DoesTreeItemExist', treeItemName);
        end
        function Name(obj, sTreepath)
            % Sets the Navigation Tree path including item name for the item. User defined items are only allowed below the "Results" folder of the Navigation Tree.
            obj.hResultTree.invoke('Name', sTreepath);
        end
        function Type(obj, key)
            % Defines the result type of the tree item. Supported types are:
            % enum key	meaning
            % "folder"	Folder
            % "colourmap"	Color map result
            % "xysignal"	1D or 1DC result
            % "notefile"	Generic ASCII text file
            obj.hResultTree.invoke('Type', key);
        end
        function Subtype(obj, key)
            % Defines the result subtype of the tree item. Supported subtypes are:
            % enum key	meaning
            % "complex"	Complex 1D data
            % "linear"	Linear scaled real data
            % "dB"	Logarithmically scaled real data
            % "Phase"	Phase data over frequency
            % "User"	User defined data
            obj.hResultTree.invoke('Subtype', key);
        end
        function Title(obj, name)
            % Defines the title label of the item.
            obj.hResultTree.invoke('Title', name);
        end
        function Xlabel(obj, name)
            % Defines the x-axis label of the item.
            obj.hResultTree.invoke('Xlabel', name);
        end
        function Ylabel(obj, name)
            % Defines the y-axis label of the item.
            obj.hResultTree.invoke('Ylabel', name);
        end
        function File(obj, sResultName)
            % Filename associated with the tree item. Either absolute file names or file names relative to the "Result\DS" project folder are valid.
            obj.hResultTree.invoke('File', sResultName);
        end
        function DeleteAt(obj, type)
            % Defines the lifetime of the item.
            % enum type
            % meaning
            % "never"
            % The result will be never deleted.
            obj.hResultTree.invoke('DeleteAt', type);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hResultTree

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% % Iterate over parametric S-Parameter data
% This macro demonstrates access to parametric data of an S-Parameter. The access works similar for other tree items.
% 
% Dim TreeItem As String
% TreeItem =('Tasks\SPara1\S-Parameters\S1,1');
% %get an array of existing result ids for this tree item
% Dim IDs As Variant
% IDs = DSResultTree.GetResultIDsFromTreeItem(TreeItem)
% If IsEmpty(IDs) Then
% DS.ReportInformationToWindow('No parametric data available.');
% Else
% Dim N As Long
% For N = 0 To UBound(IDs)
% Dim spara As Object
% Set spara = DSResultTree.GetResultFromTreeItem(TreeItem, IDs(N))
% If spara.GetResultObjectType() =('1DC'); Then
% %access data of R1DC Object
% DS.ReportInformationToWindow('First data point:('+CStr(spara.GetYRe(0))+', '+CStr(spara.GetYIm(0)))
% If DSResultTree.TreeItemHasImpedance(TreeItem, IDs(N)) Then
% Dim ref_imp As Object
% Set ref_imp = DSResultTree.GetImpedanceResultFromTreeItem(TreeItem, IDs(N))
% %access data of R1DC Object containing ref. imp.
% DS.ReportInformationToWindow('Ref. Imp. :'); + CStr(ref_imp.GetYRe(0))+', '+CStr(ref_imp.GetYIm(0)))
% End If
% End If
% Next
% End If
% % Add a Color Map Plot into Tree
% resulttree = project.ResultTree();
% resulttree.Reset
% resulttree.Name('Results\Hotspot');  % Entry name and its destination folder
% resulttree.Type('colourmap');                   
% resulttree.File('hotspots.dat');      % file names are either absolute or relative to <project>\Result\DS
% resulttree.Add
% 
% % List all 1D items and 1D folders below('Tasks');
% This macro demonstrates the use of GetTreeResults. It recursively queries all 0D and 1D items and result folders below('Tasks'); and prints the gathered data to the message window.
% 
% Dim paths As Variant, types As Variant, files As Variant, info As Variant, nResults As Long
% nResults = DSResulttree.GetTreeResults('Tasks', 'folder 0D/1D recursive', '', paths,types,files,info)
% Dim n As Long
% For n = 0 To nResults-1
% ReportInformationToWindow('path:(' + CStr(paths(n)) + vbCrLf +('type:(' + CStr(types(n)) + vbCrLf +('file:(' + CStr(files(n)))
% Next
