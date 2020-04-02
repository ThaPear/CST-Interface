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

% This object offers access and manipulation functions to result tables. A table contains a collection of individual data items. Each of these data items is associated with a particular parameter combination and can be a either single 0d result (real or complex data value) or an entire xy data set.
classdef Table < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Table object.
        function obj = Table(project, hProject, tablefilename)
            obj.project = project;
            obj.hTable = hProject.invoke('Table', tablefilename);
        end
    end
    %% CST Object functions.
    methods
        %% Construction
        % A Table object can be created as follows:
        % From within CST MICROWAVE STUDIOCST EM STUDIOCST PARTICLE STUDIO:CST MPHYSICS STUDIO
        % dim objName as object
        % set objName = Table("adapt_error.tab")
        % 
        % From an external progam
        % dim objName as object
        % set objName = CreateObject("CSTStudio.Table")
        % objName.Load("adapt_error.tab")
        % Where ”adapt_error.tab” is the name of the result table which should be loaded into the Table object.
        % 
        % From MATLAB
        % objName = project.Table('adapt_error.tab');
        % 
        %% Initialization, File Operation
        function Load(obj, sTableFileName)
            % Loads a result table file named sTableFileName into the current Table object.
            % dim res as object
            % set res = CreateObject("CSTStudio.Table")
            % res.Load("adapt_error.tab")
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
            % "0d real"       The data item represents a single real value.
            % "0d complex"    The data item represents a single complex value.
            % "1d"            The data item represents an entire xy curve.
            % "1d complex"    The data item represents an entire complex curve.
            string = obj.hTable.invoke('GetResultTypeOfDataItem', index);
        end
        function double = GetParameterValueOfDataItem(obj, dataindex, parameterindex)
            % This method returns the value of a parameter corresponding to the data item specified by its index (dataindex). The parameter itself is speicifed by its index, too (parameterindex). The dataindex must be within the range of 0 to GetNumberOfDataItems - 1 and the parameterindex must be within the range of 0 to GetNumberOfParameters - 1.
            double = obj.hTable.invoke('GetParameterValueOfDataItem', dataindex, parameterindex);
        end
        function long = GetIndexOfLastAddedDataItem(obj)
            % This method returns the index of the data item that was the last one added to the table.
            long = obj.hTable.invoke('GetIndexOfLastAddedDataItem');
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
            
            result1D = CST.Result1D(obj.project, hResult1D);
        end
        function result1Dcomplex = Get1DComplexDataItem(obj, index)
            % This method is only available when the type of the data item is "1d complex". The return value is a Result1DComplex object containing the complex data curve of the data item specified by its index. The index must be within the range of 0 to GetNumberOfDataItems - 1.
            hResult1DComplex = obj.hTable.invoke('Get1DComplexDataItem', index);
            
            result1Dcomplex = CST.Result1DComplex(obj.project, hResult1DComplex);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTable

    end
end

%% Default Settings

%% Example - Taken from CST documentation and translated to MATLAB.
