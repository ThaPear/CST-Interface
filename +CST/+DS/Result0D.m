%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object offers access and manipulation functions to 0D solver results. A Result0D object can hold a real or a complex number.
classdef Result0D < handle
    %% CST Interface specific functions.
    methods(Access = {?CST.DS.Project, ?CST.DS.Result0D})
        % CST.DS.Project can create a Result0D object.
        % CST.DS.Result0D.Copy can create a Result0D object.
        function obj = Result0D(dsproject, hDSProjectOrhResult0D, resultname)
            if(nargin == 3)
                % Created by CST.DS.Project.
                hDSProject = hDSProjectOrhResult0D;
                obj.dsproject = dsproject;
                obj.hResult0D = hDSProject.invoke('Result0D', resultname);
            else
                obj.dsproject = dsproject;
                obj.hResult0D = hDSProjectOrhResult0D;
            end
        end
    end
    %% CST Object functions.
    methods
        %% Initialization, File Operation
        function Load(obj, FileName)
            % Loads a 0D result from the database. The string FileName is the result name, which may address the result inside the project database. If you do not specify an absolute path, the path of the current project will be used.
            % Note: The names used in the ResultTree do not necessarily correspond to the file names. The file names of tree items can be queried using the ResultTree Object.
            obj.hResult0D.invoke('Load', FileName);
        end
        function SetFileName(obj, FileName)
            % Sets the filename to the Result0D object. If you do not specify an absolute path, the path of the current project will be used.
            obj.hResult0D.invoke('SetFileName', FileName);
        end
        function Save(obj)
            % Saves the object to a filename set previously. If you do not specify an absolute path, the path of the current project will be used.
            obj.hResult0D.invoke('Save');
        end
        function AddToTree(obj, TreePath)
            % Inserts the Result0D object into the tree at the folder specified by TreePath. Please note that the Result0D object needs to be saved before it can be added to the tree. It will be automatically added below the "Results" tree folder.
            obj.hResult0D.invoke('AddToTree', TreePath);
        end
        %% 0D to 0D Operations:
        function result0D = Copy(obj)
            % Returns a copy of the Result0D object. Please note that in case a filename was specified, the filename will not be copied.
            newhResult0D = obj.hResult0D.invoke('Copy');
            
            result0D = CST.DS.Result0D(obj.dsproject, newhResult0D);
        end
        %% Local Operations:
        function GetData(obj, Value)
            % The value of the real 0D result can be found in Value.
            obj.hResult0D.invoke('GetData', Value);
        end
        function GetDataComplex(obj, ValueRe, ValueIm)
            % The values of real and imaginary part of a complex 0D result can be found in ValueRe and ValueIm.
            obj.hResult0D.invoke('GetDataComplex', ValueRe, ValueIm);
        end
        function GetDerivativeData(obj, Parameter, Value)
            % Writes the value of derivative information corresponding to the Parameter to the variable Value, if set previously.
            obj.hResult0D.invoke('GetDerivativeData', Parameter, Value);
        end
        function GetDerivativeDataComplex(obj, Parameter, ValueRe, doubleValueIm)
            % Writes real and imaginary part of the derivative information corresponding to the Parameter into the variables ValueRe and ValueIm, if set previously.
            obj.hResult0D.invoke('GetDerivativeDataComplex', Parameter, ValueRe, doubleValueIm);
        end
        function long = GetN(obj)
            % Returns 1 if the object is nonempty, otherwise 0.
            long = obj.hResult0D.invoke('GetN');
        end
        function SetData(obj, Value)
            % Sets the Value to the result object, which then is defined to be of type "double".
            obj.hResult0D.invoke('SetData', Value);
        end
        function SetDataComplex(obj, ValueRe, ValueIm)
            % Sets the real and imaginary part to the result object, which then is defined to be of type "complex double".
            obj.hResult0D.invoke('SetDataComplex', ValueRe, ValueIm);
        end
        function long = HasNDerivatives(obj)
            % Returns the number of derivatives set to the result.
            long = obj.hResult0D.invoke('HasNDerivatives');
        end
        function name = GetDervativeParName(obj, Index)
            % Returns the name of the parameter corresponding to the derivative Index.
            name = obj.hResult0D.invoke('GetDervativeParName', Index);
        end
        function HasDerivativeForParameter(obj, Parameter)
            % Returns if a derivative value was set for the corresponding Parameter.
            obj.hResult0D.invoke('HasDerivativeForParameter', Parameter);
        end
        %% General Settings
        function Title(obj, Name)
            % Defines the title of the result.  
            obj.hResult0D.invoke('Title', Name);
        end
        function string = GetTitle(obj)
            % Returns the title of the result.
            string = obj.hResult0D.invoke('GetTitle');
        end
        function string = GetType(obj)
            % Returns "double" if the result is real valued or "complex double" if the result is complex valued.
            string = obj.hResult0D.invoke('GetType');
        end
        function string = GetResultObjectType(obj)
            % Returns the string "0DC" if the result object contains complex-valued data, otherwise it returns the string "0D" . This method can be used to distinguish the result object from Result1D and Result1DComplex objects in a context where the type of a result object unknown.
            string = obj.hResult0D.invoke('GetResultObjectType');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hResult0D

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% Construction
% An Result0D object can be created as follows:
% Dim result As Object
% Set result = Result0D('');
% This will create an empty object. Alternatively, a file or database name can be given as a parameter, then the object loads the data from the hard disc.
% 
% This example creates an empty object, fills it with data and adds it to the ResultTree.
% 
% NOTE: The behavior of the('Result0D'); object depends on the context it is used. If you use it in CST DESIGN ENVIRONMENT, the .AddToTree command will place the curves into the result tree of CST DESIGN STUDIO. However, if for example used from within CST MICROWAVE STUDIO, the curves will be placed into the result tree of CST MICROWAVE STUDIO. To have the curves placed into CST DESIGN STUDIO you need to construct the result object as('DS.Result0D('');');.
% 
% Dim result As Object
% Set result = Result0D('');
% result0d = dsproject.Result0D();
% .SetDataComplex(0.0, 1.0)
% .Title('A result');
% .SetFileName('my_result');
% .Save()
% .AddToTree('Results\Test\complex_i');
% 
