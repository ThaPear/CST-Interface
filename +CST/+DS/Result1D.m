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

% This object offers access and manipulation functions to 1D results.
classdef Result1D < handle
    %% CST Interface specific functions.
    methods(Access = {?CST.DS.Project, ?CST.DS.Result1D, ?CST.DS.Result1DComplex, ?CST.DS.Table, ?CST.DS.ResultTree})
        % CST.DS.Project can create a Result1D object.
        % CST.DS.Result1D.Copy can create a Result1D object.
        % CST.DS.Result1DComplex.Real/Imaginary/Magnitude/Phase can create a Result1D object.
        % CST.DS.Table.Get1DDataItem can create a Result1D object.
        % CST.DS.ResultTree.GetResultFromTreeItem/GetImpedanceResultFromTreeItem can create a Result1D object.
        function obj = Result1D(dsproject, hDSProjectOrhResult1D, resultname)
            if(nargin == 3)
                % Created by CST.DS.Project.
                hDSProject = hDSProjectOrhResult1D;
                obj.dsproject = dsproject;
                obj.hResult1D = hDSProject.invoke('Result1D', resultname);
            else
                obj.dsproject = dsproject;
                obj.hResult1D = hDSProjectOrhResult1D;
            end
        end
    end
    %% CST Object functions.
    methods
        %% Initialization, File Operation
        function Initialize(obj, n)
            % Initializes an empty Result1D object with the specified dimension n.
            obj.hResult1D.invoke('Initialize', n);
        end
        function Load(obj, sObjectName)
            % Loads a 1D result. sObjectName is the signal file name extension for the signal to be loaded.
            %  dim app As Object
            %  set app = CreateObject("CSTStudio.Application")
            %  dim ds As Object
            %  set ds = app.NewDS
            %  dim res as object
            %  set res = ds.Result1D("")
            %  res.Load("E:\Test\Project\Result\DS\Tasks\AC1\Components\P1\Data\P1\aAC Voltage")
            obj.hResult1D.invoke('Load', sObjectName);
        end
        function LoadPlainFile(obj, sObjectName)
            % Loads an external 1D result stored in the file sObjectName. If the file name sObjectName starts with a '^' the project name will automatically be added such that the corresponding signal of the current project will be loaded.
            % sObjectName may be a signal file of any source. It may have an arbitrary header, followed by the signal data organized in two columns.
            obj.hResult1D.invoke('LoadPlainFile', sObjectName);
        end
        function Save(obj, sObjectName)
            % Saves the object with the given filename. Note, that like in the LoadPlainFile method, the project name is added if the first character is a '^'. If the filename is blank the data is saved with name of the previous loaded file.
            obj.hResult1D.invoke('Save', sObjectName);
        end
        function AddToTree(obj, sTreePath)
            % Inserts the Result1D object into the tree at the folder specified by sTreePath.
            obj.hResult1D.invoke('AddToTree', sTreePath);
        end
        %% 1D to 1D Operations
        function result1D = Copy(obj)
            % Returns a copy of the object.
            newhResult1D = obj.hResult1D.invoke('Copy');
            result1D = CST.DS.Result1D(obj.dsproject, newhResult1D);
        end
        function Add(obj, Object)
            % Adds the components in oObject  to/from the calling object's components. The result will be stored in the calling object. Before calling this method please make sure that the calling object and oObject contain compatible data (same number of samples, same values of the independent variable).
            obj.hResult1D.invoke('Add', Object);
        end
        function Subtract(obj, Object)
            % Subtracts the components in oObject  to/from the calling object's components. The result will be stored in the calling object. Before calling this method please make sure that the calling object and oObject contain compatible data (same number of samples, same values of the independent variable).
            obj.hResult1D.invoke('Subtract', Object);
        end
        function ScalarMult(obj, dFactor)
            % Scales the Result1D Object with the given factor.
            obj.hResult1D.invoke('ScalarMult', dFactor);
        end
        function ComponentMult(obj, Object)
            % Multiplies the components in oObject  with/by the calling object's components. The result will be stored in the calling object. Before calling this method please make sure that the calling object and oObject contain compatible data (same number of samples, same values of the independent variable).
            obj.hResult1D.invoke('ComponentMult', Object);
        end
        function ComponentDiv(obj, Object)
            % Divides the components in oObject  with/by the calling object's components. The result will be stored in the calling object. Before calling this method please make sure that the calling object and oObject contain compatible data (same number of samples, same values of the independent variable).
            obj.hResult1D.invoke('ComponentDiv', Object);
        end
        function ApplyTimeWindow(obj, smoothness)
            % Applies a squared cosine windowing function to the result. Set smoothness to a value from 0 to 100 to specify when the cosine shape starts. At a value of 100, t0 equals to zero and at a value of zero, t0 equals to tmax, which means that it is identical to a rectangular window.
            obj.hResult1D.invoke('ApplyTimeWindow', smoothness);
        end
        function ApplyLowPass(obj, fmax)
            % Filters the result using a low pass filter with the cut-off-frequency fmax.
            obj.hResult1D.invoke('ApplyLowPass', fmax);
        end
        function ResampleTo(obj, min, max, nSamples)
            % Resample the result to a given number of samples between a minimum and maximum value. The new data samples are calculated by a linear interpolation of the original data samples.
            obj.hResult1D.invoke('ResampleTo', min, max, nSamples);
        end
        function MakeCompatibleTo(obj, Object)
            % Re-samples the result in the calling object to make it compatible to the sampling of oObject. The new data samples are calculated by a linear interpolation of the original data samples.
            obj.hResult1D.invoke('MakeCompatibleTo', Object);
        end
        function SortByX(obj)
            % Sorts the data contained in the result object to have monotonically increasing x-values.
            obj.hResult1D.invoke('SortByX');
        end
        %% 1D to 0D Operations
        function double = ScalarProd(obj, Object)
            % Performs a scalar product between two Result1D objects. The result will be returned as a double value.
            double = obj.hResult1D.invoke('ScalarProd', Object);
        end
        function long = GetGlobalMaximum(obj)
            % Returns the index of the overall maximum of the y-values.
            long = obj.hResult1D.invoke('GetGlobalMaximum');
        end
        function long = GetGlobalMinimum(obj)
            % Returns the index of the overall minimum of the y-values.
            long = obj.hResult1D.invoke('GetGlobalMinimum');
        end
        function long = GetMaximumInRange(obj, x1, x2)
            % Returns the index to the maximum y-value that can be found between x1 and x2.
            long = obj.hResult1D.invoke('GetMaximumInRange', x1, x2);
        end
        function long = GetMinimumInRange(obj, x1, x2)
            % Returns the index to the minimum y-value that can be found between x1 and x2.
            long = obj.hResult1D.invoke('GetMinimumInRange', x1, x2);
        end
        function long = GetMaximumInIndexRange(obj, i1, i2)
            % Returns the index to the maximum y-value that can be found between two x-values referenced by the indices i1 and i2.
            long = obj.hResult1D.invoke('GetMaximumInIndexRange', i1, i2);
        end
        function long = GetMinimumInIndexRange(obj, i1, i2)
            % Returns the index to the minimum y-value that can be found between two x-values referenced by the indices i1 and i2.
            long = obj.hResult1D.invoke('GetMinimumInIndexRange', i1, i2);
        end
        function long = GetFirstMaximum(obj, yLimit)
            % Returns the index to the first maximum y-value. The parameter yLimit defines a minimum difference between the found local maximum y-value and the previous and next local maximum y-value. If no further maximum could be found the returned index will be �1.
            long = obj.hResult1D.invoke('GetFirstMaximum', yLimit);
        end
        function long = GetFirstMinimum(obj, yLimit)
            % Returns the index to the first minimum y-value. The parameter yLimit defines a minimum difference between the found local minimum y-value and the previous and next local minimum y-value. If no further minimum could be found the returned index will be �1.
            long = obj.hResult1D.invoke('GetFirstMinimum', yLimit);
        end
        function long = GetNextMaximum(obj, yLimit)
            % Returns the index to the next maximum y-value. The parameter yLimit defines a minimum difference between the found local maximum/minimum y-value and the previous and next local maximum y-value. If no further maximum could be found the returned index will be �1.
            long = obj.hResult1D.invoke('GetNextMaximum', yLimit);
        end
        function long = GetNextMinimum(obj, yLimit)
            % Returns the index to the next minimum y-value. The parameter yLimit defines a minimum difference between the found local maximum/minimum y-value and the previous and next local minimum y-value. If no further minimum could be found the returned index will be �1.
            long = obj.hResult1D.invoke('GetNextMinimum', yLimit);
        end
        function double = GetMeanValue(obj)
            % Returns the mean value of the Result1D object's y-values.
            double = obj.hResult1D.invoke('GetMeanValue');
        end
        function double = GetSigma(obj)
            % Returns the deviation of the Result1D object's y-values.
            double = obj.hResult1D.invoke('GetSigma');
        end
        function double = GetIntegral(obj)
            % Returns the integral of the Result1D object, which is calculated via the Trapezoidal Rule.
            double = obj.hResult1D.invoke('GetIntegral');
        end
        function double = GetNorm(obj)
            % Returns the square root mean norm of the Result1D object.
            double = obj.hResult1D.invoke('GetNorm');
        end
        %% Local Operations:
        function SetX(obj, index, dValue)
            % Sets the x-value at the specified index in the Result1D object.
            obj.hResult1D.invoke('SetX', index, dValue);
        end
        function SetY(obj, index, dValue)
            % Sets the y-value at the specified index in the Result1D object.
            obj.hResult1D.invoke('SetY', index, dValue);
        end
        function double = GetX(obj, index)
            % Returns the x-value at the specified index in the Result1D object.
            double = obj.hResult1D.invoke('GetX', index);
        end
        function double = GetY(obj, index)
            % Returns the y-value at the specified index in the Result1D object.
            double = obj.hResult1D.invoke('GetY', index);
        end
        function SetXY(obj, index, xValue, yValue)
            % Sets the x- and  y-value at the specified index in the Result1D object.
            obj.hResult1D.invoke('SetXY', index, xValue, yValue);
        end
        function SetXYDouble(obj, index, xValue, yValue)
            % Sets the x- and  y-value at the specified index in the Result1D object.
            % Note, that these methods in contrast to .SetXY do only accept double parameters and no expressions.
            obj.hResult1D.invoke('SetXYDouble', index, xValue, yValue);
        end
        function [xValue, yValue] = GetXYDouble(obj, index)
            % Returns the x- and  y-value at the specified index in the Result1D object.
            % Note, that these methods in contrast to .SetXY do only accept double parameters and no expressions.

            % Not sure how to implement this, so use the functions for each
            % one individually for now.
            xValue = obj.GetX(index);
            yValue = obj.GetY(index);

            % See Result3D.GetNxNyNz for the beginning of a possible implementation.
        end
        function AppendXY(obj, xValue, yValue)
            % Appends a new pair of values to the end of the result object.
            obj.hResult1D.invoke('AppendXY', xValue, yValue);
        end
        function long = GetClosestIndexFromX(obj, dValue)
            % Returns the index of the x-value stored in the Result1D object that is closest to the specified value.
            long = obj.hResult1D.invoke('GetClosestIndexFromX', dValue);
        end
        function variant = GetArray(obj, component)
            % Returns data of  the Result 1D object as double array . The string component can be 'x' or 'y' and specifies which component of the Result 1D object will be returned, analogous to 'GetX' and 'GetY'.
            variant = obj.hResult1D.invoke('GetArray', component);
        end
        function SetArray(obj, doubleArray, component)
            % Overwrites the data in the Result 1D object with the data provided as double array . The string component can be 'x' or 'y' and specifies which component of the Result 1D object will be overwritten, analogous to 'SetX' and 'SetY'. The variant doubleArray can be an array of double values. It has to start with index zero and it is expected to have at least as many elements as the Result 1D object contains. In case more elements are provided, they will be ignored. Consider using the methods 'GetN' to query and 'Initialize' to modify the size of the Result1D object.
            obj.hResult1D.invoke('SetArray', doubleArray, component);
        end
        %% General Settings
        function Title(obj, name)
            % Defines the title of the result.
            obj.hResult1D.invoke('Title', name);
        end
        function Xlabel(obj, name)
            % Defines the x-axis label of the result.
            obj.hResult1D.invoke('Xlabel', name);
        end
        function Ylabel(obj, name)
            % Defines the y-axis label of the result.
            obj.hResult1D.invoke('Ylabel', name);
        end
        function str = GetTitle(obj)
            % Returns the title label of the result. This function works only for user added tree result objects.
            str = obj.hResult1D.invoke('GetTitle');
        end
        function str = GetXlabel(obj)
            % Returns the x-axis label of the result. This function works only for user added tree result objects.
            str = obj.hResult1D.invoke('GetXlabel');
        end
        function str = GetYlabel(obj)
            % Returns the y-axis label of the result. This function works only for user added tree result objects.
            str = obj.hResult1D.invoke('GetYlabel');
        end
        function Type(obj, key)
            % Defines the type of the Result1D object.
            % enum key          meaning
            % "magnitude"       Magnitude
            % "dB"              Magnitude in dB
            % "phase"           Phase in degrees
            % "real"            Real part
            % "imaginary"       Imaginary part
            % "linear_points"   A linear scaled result plotted as unconnected points
            % "farfield:polar"  Polar Farfield result
            % The type "farfield:polar" is considered only if the Result1D object is created and processed within a template evaluation in the Template Based Post-Processing framework.
            obj.hResult1D.invoke('Type', key);
        end
        function long = GetN(obj)
            % Returns the total number of value pairs stored in the Result1D object.
            long = obj.hResult1D.invoke('GetN');
        end
        function str = GetResultObjectType(obj)
            % Returns the string "1D". This method can be used to distinguish the result object from Result1D and Result1DComplex objects in a context where the type of a result object is unknown.
            str = obj.hResult1D.invoke('GetResultObjectType');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hResult1D

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% % Construction
% % An Result1D object can be created within the built-in basic editor as follows:
% dim objName1 as object
% set objName1 = Result1D(GetProjectPath('ResultsDSTask'); +('AC1\Components\P1\Data\P1\aAC Voltage');
% % From an external progam:
% dim app As Object
% set app = CreateObject('CSTStudio.Application');
% dim ds As Object
% set ds = app.OpenFile('E:\Test\Project.cst');
% dim objName1 as object
% set objName1 = ds.Result1D(ds.GetProjectPath('ResultsDSTask'); +('AC1\Components\P1\Data\P1\aAC Voltage');
% % NOTE: The behavior of the('Result1D'); object depends on the context it is used. If you use it in CST DESIGN ENVIRONMENT, the .AddToTree command will place the curves into the result tree of CST DESIGN STUDIO. However, if for example used from within CST MICROWAVE STUDIO, the curves will be placed into the result tree of CST MICROWAVE STUDIO. To have the curves placed into CST DESIGN STUDIO you need to construct the result object as('DS.Result1D('');');.
%
% %% The following example shows how a Result1D object can be filled with data and added to the Navigation Tree.
%
% Dim o As Object
% Set o = Result1D('');
% %fill empty object with data
% Dim n As Long
% For n = 0 To 1000
% Dim x As Double
% x = 2.0*PI*n/1000
% o.Appendxy(x,Cos(x))
% Next
% %set label, save data, add it to the Navigation Tree
% o.ylabel('cosine');
% o.Save('cosine_curve.sig');
% o.AddToTree('Results\Data\curve_1D');
%
% This example shows how  ASCII data from an external file can be loaded into a Result1D object and added to the Navigation Tree.
%
% Dim o As Object
% Set o = Result1D('');
% %load external ASCII file containing two data columns separated by white space or tabulator
% o.LoadPlainFile('C:\two_column_data.txt');
% %set labels
% o.xlabel('x-axis label');
% o.ylabel('y-axis label');
% %save it within the project
% o.Save('imported_curve.sig');
% %add it to the Navigation Tree
% o.AddToTree('Results\Data\curve_import');
%
% The example shows how to access all values of a result stored under the tree path('Tasks\Tran1\TD Voltages\Port1');. Please note that depending on type of the tree result, a Result1DComplex object might be needed to load the data.
%
% Dim nPoints As Long
% Dim n As Long
% Dim x As Double
% Dim y As Double
% Dim filename As String
% filename = DSResulttree.GetFileFromTreeItem('Tasks\Tran1\TD Voltages\Port1');
% If filename =(''); Then
% DS.ReportInformationToWindow('Result does not exist.');
% Else
% result1d = dsproject.Result1D();
% nPoints = .GetN %get number of points
% For n = 0 To nPoints-1
% %read all points, index of first point is zero.
% x = .GetX(n)
% y = .GetY(n)
% %print to message window
% DS.ReportInformationToWindow('x:(' + Cstr(x) +(' y:(' + CStr(y))
% Next n
% End If
%
% This example loads S1,1 and extracts the real part of the complex-valued S-Parameter. It then determines the closest existing data point to a certain frequency(here 0.65 GHz) and prints the result to the message window. It shows how the ResultTree object , the Result1DComplex object and the Result1D object can be used together to access 1D data.
%
% Dim filename As String
% filename = DSResulttree.GetFileFromTreeItem('Tasks\SPara1\S-Parameters\S1,1');
% If filename =(''); Then
% DS.ReportInformationToWindow('Result does not exist.');
% Else
% Dim o As Object
% Set o = Result1DComplex(filename) %load complex-valued S1,1
% Dim realPart As Object
% Set realPart = o.Real() %extract a Result1D-object containing the real part of S1,1
% Dim n As Integer
% n = realPart.GetClosestIndexFromX(0.65)
% DS.ReportInformationToWindow('Closest data point to frequency 0.65 Ghz:(' + Cstr(realPart.GetX(n)) + ', ' + Cstr(realPart.GetY(n)))
% End If
%
%
%
