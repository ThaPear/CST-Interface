%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object offers access and manipulation functions to complex 1D results. A Result1DComplex object can hold a number of points ( x, y ) where x is a real number and y is a complex number. Access to the points is possible by specifying an zero-based index.
classdef Result1DComplex < handle
    %% CST Interface specific functions.
    methods(Access = {?CST.DS.Project, ?CST.DS.Result1DComplex, ?CST.DS.Table})
        % CST.DS.Project can create a Result1DComplex object.
        % CST.DS.Result1DComplex.Copy can create a Result1DComplex object.
        % CST.DS.Table.Get1DDataItem can create a Result1D object.
        function obj = Result1DComplex(dsproject, hDSProjectOrhResult1DComplex, resultname)
            if(nargin == 3)
                % Created by CST.DS.Project.
                hDSProject = hDSProjectOrhResult1DComplex;
                obj.dsproject = dsproject;
                obj.hResult1DComplex = hDSProject.invoke('Result1DComplex', resultname);
            else
                obj.dsproject = dsproject;
                obj.hResult1DComplex = hDSProjectOrhResult1DComplex;
            end
        end
    end
    %% CST Object functions.
    methods
        %% Initialization, File Operation
        function Initialize(obj, Size)
            % Initializes an empty Result1DComplex object with the given number of samples.
            obj.hResult1DComplex.invoke('Initialize', Size);
        end
        function Load(obj, FileName)
            % Loads a 1D Complex result from a file. The string FileName is the signal file name for the complex signal to be loaded. If you do not specify an absolute path, the path of the current project will be used. If you do not specify a file ending, the default file ending ".sig" will be used.
            % Note: The names used in the ResultTree do not necessarily correspond to the file names. The file names of tree items can be queried using the ResultTree Object.
            obj.hResult1DComplex.invoke('Load', FileName);
        end
        function Save(obj, FileName)
            % Saves the object to a file with the given filename. If you do not specify an absolute path, the path of the current project will be used. If you do not specify a file ending, the default file ending ".sig" will be used.
            obj.hResult1DComplex.invoke('Save', FileName);
        end
        function LoadFromMagnitudeAndPhase(obj, MagnitudeFilename, PhaseFilename)
            % Loads a 1D Complex result out of two files. The string MagnitudeFilename specifies the file where the magnitude of the data is stored. The string PhaseFilename specifies the file where the phase in degree of the data is stored. If the two files have a different sampling, an error will be returned. If you do not specify an absolute path, the path of the current project will be used. If you do not specify a file ending, the default file ending ".sig" will be used.
            obj.hResult1DComplex.invoke('LoadFromMagnitudeAndPhase', MagnitudeFilename, PhaseFilename);
        end
        function LoadFromRealAndImaginary(obj, RealFilename, ImaginaryFilename)
            % Loads a 1D Complex result out of two files. The string RealFilename specifies the file where the real part of the data is stored. The string ImaginaryFilename specifies the file where the imaginary part of the data is stored. If the two files have a different sampling, an error will be returned. If you do not specify an absolute path, the path of the current project will be used. If you do not specify a file ending, the default file ending ".sig" will be used.
            obj.hResult1DComplex.invoke('LoadFromRealAndImaginary', RealFilename, ImaginaryFilename);
        end
        function AddToTree(obj, TreePath)
            % Inserts the Result1DComplex object into the tree at the folder specified by TreePath. Please note that the Result1DComplex object needs to be saved before it can be added to the tree. It will be automatically added below the "Results" tree folder. See also SetReferenceImpedanceLink.
            obj.hResult1DComplex.invoke('AddToTree', TreePath);
        end
        function Clear(obj)
            % Deletes all data stored in the Result1DComplex object.
            obj.hResult1DComplex.invoke('Clear');
        end
        function DeleteDataAt(obj, Index)
            % Deletes the data point at the given index.
            obj.hResult1DComplex.invoke('DeleteDataAt', Index);
        end
        %% 1D Complex to 1D Complex Operations
        function result1DComplex = Copy(obj)
            % Returns a copy of the Result1D Complex object.
            newhResult1DComplex = obj.hResult1DComplex.invoke('Copy');
            
            result1DComplex = CST.DS.Result1DComplex(obj.dsproject, newhResult1DComplex);
        end
        %% 1D Complex to 1D Operations
        function result1D = Real(obj)
            % Returns a Result1D object filled with the real part of the data stored in the Result1DComplex object.
            hResult1D = obj.hResult1DComplex.invoke('Real');
            
            result1D = CST.DS.Result1D(obj.dsproject, hResult1D);
        end
        function result1D = Imaginary(obj)
            % Returns a Result1D object filled with the imaginary part of the data stored in the Result1DComplex object.
            hResult1D = obj.hResult1DComplex.invoke('Imaginary');
            
            result1D = CST.DS.Result1D(obj.dsproject, hResult1D);
        end
        function result1D = Magnitude(obj)
            % Returns a Result1D object filled with the magnitude of the data stored in the Result1DComplex object.
            hResult1D = obj.hResult1DComplex.invoke('Magnitude');
            
            result1D = CST.DS.Result1D(obj.dsproject, hResult1D);
        end
        function result1D = Phase(obj)
            % Returns a Result1D object filled with the phase in degrees of the data stored in the Result1DComplex object.
            hResult1D = obj.hResult1DComplex.invoke('Phase');
            
            result1D = CST.DS.Result1D(obj.dsproject, hResult1D);
        end
        %% Local Operations:
        function long = GetN(obj)
            % Returns the number of elements in the Result1DComplex object.
            long = obj.hResult1DComplex.invoke('GetN');
        end
        function SetX(obj, index, dValue)
            % Sets the x-value at the specified index in the Result1D object.
            obj.hResult1DComplex.invoke('SetX', index, dValue);
        end
        function SetYRe(obj, index, dValue)
            % Sets the y-value at the specified index in the Result1D object.
            obj.hResult1DComplex.invoke('SetYRe', index, dValue);
        end
        function SetYIm(obj, index, dValue)
            % Sets the y-value at the specified index in the Result1D object.
            obj.hResult1DComplex.invoke('SetYIm', index, dValue);
        end
        function double = GetX(obj, index)
            % Returns the x-value at the specified index in the Result1D object.
            double = obj.hResult1DComplex.invoke('GetX', index);
        end
        function double = GetYRe(obj, index)
            % Returns the y-value at the specified index in the Result1D object.
            double = obj.hResult1DComplex.invoke('GetYRe', index);
        end
        function double = GetYIm(obj, index)
            % Returns the y-value at the specified index in the Result1D object.
            double = obj.hResult1DComplex.invoke('GetYIm', index);
        end
        function GetDataFromIndex(obj, Index, X, YReal, YImaginary)
            % Fills the variables X, YReal and YImaginary with the data point at the given index.
            obj.hResult1DComplex.invoke('GetDataFromIndex', Index, X, YReal, YImaginary);
        end
        function AppendXY(obj, XValue, YReal, YImaginary)
            % Appends a data point  to the end of the complex result object.
            obj.hResult1DComplex.invoke('AppendXY', XValue, YReal, YImaginary);
        end
        function AppendXYDouble(obj, XValue, YReal, YImaginary)
            % This command has the same behavior as AppendXY, but it accepts double values, which may be evaluated more efficiently depending on the context.
            obj.hResult1DComplex.invoke('AppendXYDouble', XValue, YReal, YImaginary);
        end
        function ScalarMultReIm(obj, YReal, YImaginary)
            % Multiplies all y-values of the current object with the given complex number.
            obj.hResult1DComplex.invoke('ScalarMultReIm', YReal, YImaginary);
        end
        function ScalarMultAmPh(obj, YAmplitude, YPhase)
            % Multiplies all y-values of the current object with the given complex number. The phase needs to be scaled in degrees.
            obj.hResult1DComplex.invoke('ScalarMultAmPh', YAmplitude, YPhase);
        end
        function Conjugate(obj)
            % Conjugates all complex y-values of the current object.
            obj.hResult1DComplex.invoke('Conjugate');
        end
        function NthPower(obj, Exponent)
            % Raises each complex y-value of the current object to the real power of Exponent .
            obj.hResult1DComplex.invoke('NthPower', Exponent);
        end
        function ResampleTo(obj, Min, Max, Samples)
            % Re-samples the data points of the object to a given number of samples between a minimum specified in Min and maximum value specified in Max. The new data samples are calculated using an interpolation of the original data samples. The method returns an error if less than three data points are contained in the object.
            obj.hResult1DComplex.invoke('ResampleTo', Min, Max, Samples);
        end
        function Add(obj, Object)
            % Adds the complex y-values of the other object to the y-values of the current object. The number of points need to be the same in both objects. The x-values are taken from the current object.
            obj.hResult1DComplex.invoke('Add', Object);
        end
        function Subtract(obj, Object)
            % Subtracts the complex y-values of the other object from the y-values of the current object. The number of points need to be the same in both objects. The x-values are taken from the current object.
            obj.hResult1DComplex.invoke('Subtract', Object);
        end
        function ComponentMult(obj, Object)
            % Multiplies the complex y-values of the other object with the y-values of the current object. The number of points need to be the same in both objects. The x-values are taken from the current object.
            obj.hResult1DComplex.invoke('ComponentMult', Object);
        end
        function ComponentDiv(obj, Object)
            % Divides the complex y-values of the current object by the y-values of the other object. The method returns an error if a division by zero was encountered. The number of points need to be the same in both objects. The x-values are taken from the current object.
            obj.hResult1DComplex.invoke('ComponentDiv', Object);
        end
        function MakeCompatibleTo(obj, Object)
            % Result1D Object/Result1DComplex Object
            % Re-samples the result data of the current object to make it compatible to the sampling of the other object. The new data samples are calculated by an interpolation of the original data samples. The method returns an error if less than three data points are contained in the current object or less than two data points are contained in the other object.
            obj.hResult1DComplex.invoke('MakeCompatibleTo', Object);
        end
        function SortByX(obj)
            % Sorts the data contained in the result object to have monotonically increasing x-values.
            obj.hResult1DComplex.invoke('SortByX');
        end
        function ZthPower(obj, Object)
            % Raises each complex y-value of the current object to the complex power of the y-value of the other object at the same index. The number of points need to be the same in both objects. The x-values remain unchanged. The method returns an error if an invalid operation was encountered (e.g. zero to the power of zero).
            obj.hResult1DComplex.invoke('ZthPower', Object);
        end
        function variant = GetArray(obj, component)
            % Returns data of  the Result1DComplex object as double array . The string component can be 'x', 'yre' or 'yim' and specifies which component of the Result1DComplex object will be returned, analogous to 'GetX' and 'GetYRe' and 'GetYIm' .
            variant = obj.hResult1DComplex.invoke('GetArray', component);
        end
        function SetArray(obj, doubleArray, component)
            % Overwrites the data in the Result1DComplex object with the data provided as double array . The string component can be 'x', 'yre'  or 'yim' and specifies which component of the Result1DComplex object will be overwritten, analogous to 'SetX' and 'SetYRe' and 'SetYIm'. The variant doubleArray can be an array of double values. It has to start with index zero and it is expected to have at least as many elements as the Result1DComplex object contains. In case more elements are provided, they will be ignored. Consider using the methods 'GetN' to query and 'Initialize' to modify the size of the Result1DComplex object.
            obj.hResult1DComplex.invoke('SetArray', doubleArray, component);
        end
        %% General Settings
        function Title(obj, name)
            % Defines the title of the result.
            obj.hResult1DComplex.invoke('Title', name);
        end
        function Xlabel(obj, name)
            % Defines the x-axis label of the result.
            obj.hResult1DComplex.invoke('Xlabel', name);
        end
        function Ylabel(obj, name)
            % Defines the y-axis label of the result.
            obj.hResult1DComplex.invoke('Ylabel', name);
        end
        function string = GetTitle(obj)
            % Returns the title label of the result. This function works only for user added tree result objects.
            string = obj.hResult1DComplex.invoke('GetTitle');
        end
        function string = GetXlabel(obj)
            % Returns the x-axis label of the result. This function works only for user added tree result objects.
            string = obj.hResult1DComplex.invoke('GetXlabel');
        end
        function string = GetYlabel(obj)
            % Returns the y-axis label of the result. This function works only for user added tree result objects.
            string = obj.hResult1DComplex.invoke('GetYlabel');
        end
        function SetLogarithmicFactor(obj, LogFactor)
            % When the complex curve contained in the Result1DComplex object is visualized in dB, the logarithmic factor provides the scaling of the data. The string LogFactor can be 10 for a power quantity, 20 for a field quantity, or -1 which will disable the dB option. The default is 20.
            obj.hResult1DComplex.invoke('SetLogarithmicFactor', LogFactor);
        end
        function double = GetLogarithmicFactor(obj)
            % Returns the logarithmic factor.
            double = obj.hResult1DComplex.invoke('GetLogarithmicFactor');
        end
        function SetReferenceImpedanceLink(obj, TreePath)
            % This command allows adding a 1D result to the Navigation Tree which can be visualized as a Smith Chart. One can specify a link to another existing 1D result in the Navigation Tree which will be interpreted as reference impedance data. The link is created when the Result1DComplex object is added to the Navigation Tree via a subsequent call of AddToTree. The reference impedance item needs to be an existing complex-valued item of the same sampling as the processed data. It also needs to be located within the same Navigation Tree folder as the reference impedance tree item, otherwise AddToTree will report an error. See also Examples.
            obj.hResult1DComplex.invoke('SetReferenceImpedanceLink', TreePath);
        end
        function string = GetReferenceImpedanceLink(obj)
            % Returns the tree item specified by SetReferenceImpedanceLink.
            string = obj.hResult1DComplex.invoke('GetReferenceImpedanceLink');
        end
        function SetDefaultPlotView(obj, Type)
            % This setting specifies the default plot view type that should be used when a 1D plot of  this result is opened. The variable Type specifies the type of view that should be plotted and can be one of the following strings: "real", "imaginary", "magnitude", "magnitudedb", "phase", "polar", or an empty string. This setting is considered if the Result1DComplex object is created and processed within a template evaluation in the Template Based Post-Processing framework or if the object is added to the Navigation Tree via AddToTree.
            obj.hResult1DComplex.invoke('SetDefaultPlotView', Type);
        end
        function string = GetDefaultPlotView(obj)
            % Returns the default plot view type specified by SetDefaultPlotView.
            string = obj.hResult1DComplex.invoke('GetDefaultPlotView');
        end
        function string = GetResultObjectType(obj)
            % Returns the string "1DC". This method can be used to distinguish the result object from Result0D and Result1D objects in a context where the type of a result object is unknown.
            string = obj.hResult1DComplex.invoke('GetResultObjectType');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hResult1DComplex

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% % An Result1DComplex object can be created as follows:
% 
% Dim result As Object
% Set result = Result1DComplex('');
% 
% This will create an empty object. Alternatively, a filename of a complex .sig-file can be given as a parameter, then the object loads the data from the .sig-file(see Examples).
% % This example creates an empty object, fills it with data and adds it to the ResultTree.
% 
% NOTE: The behavior of the('Result1DComplex'); object depends on the context it is used. If you use it in CST DESIGN ENVIRONMENT, the .AddToTree command will place the curves into the result tree of CST DESIGN STUDIO. However, if for example used from within CST MICROWAVE STUDIO, the curves will be placed into the result tree of CST MICROWAVE STUDIO. To have the curves placed into CST DESIGN STUDIO you need to construct the result object as('DS.Result1DComplex('');');.
% 
% Dim result As Object
% Set result = Result1DComplex('');
% result1dcomplex = dsproject.Result1DComplex();
%     result1dcomplex.AppendXY(1,1,1)
%     result1dcomplex.AppendXY(2,2,1)
%     result1dcomplex.AppendXY(3,2,2)
%     result1dcomplex.Title('A complex curve');
%     result1dcomplex.Save('a_file_name');
%     result1dcomplex.AddToTree('Results\Test\complex_curve');
% 
% % This example loads a S-Parameter and adds it to the ResultTree.
% 
% Dim TreeItem As String, FileName As String
% TreeItem =('Tasks\SPara1\S-Parameters\S1,1');
% FileName = DSResultTree.GetFileFromTreeItem(TreeItem)
% Dim result As Object
% Set result = DS.Result1DComplex('');
%     result1dcomplex.Load(FileName)
%     result1dcomplex.Save('my_file_name');
%     result1dcomplex.AddToTree('Results\S-Parameter\S1,1');
% 
% % This example links two objects via the command SetReferenceImpedanceLink.
% 
% Dim refImp As Object
% Set refImp = Result1DComplex('');
% refImp.Appendxy(1,50,0)
% refImp.Save('refimp_name.sig');
% refImp.AddToTree('Results\Data\result-ref-imp');
% 
% Dim result As Object
% Set result = Result1DComplex('');
% result.Appendxy(1,0.4,0.6)
% result.Save('result_name.sig');
% result.SetReferenceImpedanceLink('Results\Data\result-ref-imp');
% result.AddToTree('Results\Data\result');
