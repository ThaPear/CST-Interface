%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object offers access and manipulation functions to result tables. A table contains a collection of individual data items. Each of these data items is associated with a particular parameter combination and can be a either single 0d result (real or complex data value) or an entire xy data set.
classdef Table < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.DS.Project can create a Table object.
        function obj = Table(dsproject, hDSProject, path)
            obj.dsproject = dsproject;
            obj.hTable = hDSProject.invoke('Table', path);
        end
    end
    %% CST Object functions.
    methods
        %% Initialization, File Operation
        function Load(obj, sTableFileName)
            % Loads a result table file named sTableFileName into the current Table object.
            obj.hTable.invoke('Load', sTableFileName);
        end
        function ExportData(obj, name)
            % Exports the contents of the currently loaded table into an ASCII text file specified by its name. The results of all parameter combinations will be exported.
            obj.hTable.invoke('ExportData', name);
        end
        %% Access to General Table Data
        function string = GetName(obj)
            % This method returns the name which has been assigned with the current table.
            string = obj.hTable.invoke('GetName');
        end
        %% Access to Table Parameters
        function long = GetNumberOfParameters(obj)
            % This method returns the number of parameters which are associated with the data of the current table object.
            long = obj.hTable.invoke('GetNumberOfParameters');
        end
        function string = GetParameterNameFromIndex(obj, index)
            % This method returns the name of a parameter by specifying its index. The index must be within the range of 0 to GetNumberOfParameters - 1.
            string = obj.hTable.invoke('GetParameterNameFromIndex', index);
        end
        function double = GetParameterValueFromIndex(obj, index)
            % This method returns the current value of a parameter by specifying its index. The index must be within the range of 0 to GetNumberOfParameters - 1. This value will be used when the table properties dialog box is opened.
            double = obj.hTable.invoke('GetParameterValueFromIndex', index);
        end
        %% Access to Data Items
        function long = GetNumberOfDataItems(obj)
            % This method returns the total number of data items contained in the table.
            long = obj.hTable.invoke('GetNumberOfDataItems');
        end
        function string = GetResultTypeOfDataItem(obj, index)
            % This method returns a string containing the type of the data item specified by its index. The index must be within the range of 0 to GetNumberOfDataItems - 1. The type can be any one of the following strings:
            % "0d real"
            % The data item represents a single real value.
            % "0d complex"
            % The data item represents a single complex value.
            % "1d"
            % The data item represents an entire xy curve.
            % "1d complex"
            % The data item represents an entire complex curve.
            string = obj.hTable.invoke('GetResultTypeOfDataItem', index);
        end
        function double = GetParameterValueOfDataItem(obj, dataindex, parameterindex)
            % This method returns the value of a parameter corresponding to the data item specified by its index (dataindex). The parameter itself is speicifed by its index, too (parameterindex). The dataindex must be within the range of 0 to GetNumberOfDataItems - 1 and the parameterindex must be within the range of 0 to GetNumberOfParameters - 1.
            double = obj.hTable.invoke('GetParameterValueOfDataItem', dataindex, parameterindex);
        end
        function double = Get0DDataItem(obj, index)
            % This method is only available when the type of the data item is "0d real". The return value is the actual real value of the data item specified by its index. The index must be within the range of 0 to GetNumberOfDataItems - 1.
            double = obj.hTable.invoke('Get0DDataItem', index);
        end
        function double = Get0DDataItemRe(obj, index)
            % This method is only available when the type of the data item is "0d complex". The return value is the real part of the actual complex value of the data item specified by its index. The index must be within the range of 0 to GetNumberOfDataItems - 1.
            double = obj.hTable.invoke('Get0DDataItemRe', index);
        end
        function double = Get0DDataItemIm(obj, index)
            % This method is only available when the type of the data item is "0d complex". The return value is the imaginary part of the actual complex value of the data item specified by its index. The index must be within the range of 0 to GetNumberOfDataItems - 1.
            double = obj.hTable.invoke('Get0DDataItemIm', index);
        end
        function result1D = Get1DDataItem(obj, index)
            % This method is only available when the type of the data item is "1d". The return value is a Result1D object containing the xy data curve of the data item specified by its index. The index must be within the range of 0 to GetNumberOfDataItems - 1.
            hResult1D = obj.hTable.invoke('Get1DDataItem', index);
            result1D = CST.DS.Result1D(obj.dsproject, hResult1D);
        end
        function result1DComplex = Get1DComplexDataItem(obj, index)
            % This method is only available when the type of the data item is "1d complex". The return value is a Result1DComplex Object object containing the complex data curve of the data item specified by its index. The index must be within the range of 0 to GetNumberOfDataItems - 1.
            hResult1DComplex = obj.hTable.invoke('Get1DComplexDataItem', index);
            result1DComplex = CST.DS.Result1DComplex(obj.dsproject, hResult1DComplex);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hTable

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% % Construction
% % A Table object can be created as follows:
% 
% % From within CST DESIGN STUDIO™:
% dim objName as object
% set objName = Table('adapt_error.tab');
% 
% % From an external progam:
% % create a CSTStudio Application
% Dim app As Object
% Set app = CreateObject('CSTStudio.Application');
% 
% % open a Design Studio example
% Dim designstudio As Object
% Set designstudio = app.OpenFile('C:\Program Files(x86)\CST STUDIO SUITE 2017\Examples\DS\S-Parameter\Circuit-EM\Matched Antenna\antenna.cst');
% If designstudio.GetApplicationName <>('DS'); Then MsgBox('Example is not a Design Studio example.');
% 
% % load a table located in the project folder of the example
% Dim myTable As Object
% Set myTable = designstudio.Table(designstudio.GetProjectPath('Project'); +('\Result\DS\Generic\1D\magdB(S1,1).tab');
% MsgBox('Table has(' + CStr(myTable.GetNumberOfDataItems) +(' curves.');
% 
% % While ”adapt_error.tab” is the name of the result table which should be loaded into the Table object.
