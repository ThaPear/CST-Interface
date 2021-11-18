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

% This object offers access and manipulation functions for 2D results.
classdef Result2D < handle
    %% CST Interface specific functions.
    methods(Access = {?CST.Project, ?CST.Result2D, ?CST.ResultTree, ?CST.EvaluateFieldAlongCurve})
        % CST.Project can create a CST.Result2D object.
        % CST.Result3D.Copy can create a Result3D object.
        % CST.ResultTree.GetResultFromTreeItem can create a CST.Result2D object.
        function obj = Result2D(project, hProject)
            obj.project = project;
            obj.hResult2D = hProject.invoke('Result2D');
        end
    end
    %% CST Object functions.
    methods
        %% Construction
        % A Result2D object can be created as follows:
        % Dim result As Object
        % Set result = Result2D("")
        % This will create an empty object. Alternatively, a file name can be given as a parameter, then the object loads the data from the hard disc.
        function Initialize(obj, nX, nY)
            % Initializes an empty Result2D object ("2D") arranged in a regular grid with the specified dimension nX x nY for the storage of real-valued data.
            obj.hResult2D.invoke('Initialize', nX, nY);
        end
        function InitializeComplex(obj, nX, nY)
            % Initializes an empty Result2D object ("2DC") arranged in a regular grid with the specified dimension nX x nY for the storage of complex-valued data.
            obj.hResult2D.invoke('InitializeComplex', nX, nY);
        end
        function InitializeTriangulation(obj, nTriangles)
            % Initializes an empty Result2D object ("2D") in a triangle based arrangement with the specified dimension nTriangles for the storage of real-valued data.
            obj.hResult2D.invoke('InitializeTriangulation', nTriangles);
        end
        function InitializeTriangulationComplex(obj, nTriangles)
            % Initializes an empty Result2D object ("2DC") in a triangle based arrangement with the specified dimension nTriangles for the storage of complex-valued data.
            obj.hResult2D.invoke('InitializeTriangulationComplex', nTriangles);
        end
        function Load(obj, sFileName)
            % Loads the Result2D object from file.
            % NOTE: The names used in the ResultTree do not necessarily correspond to the file names. The file names of tree items can be queried using the ResultTree Object.
            obj.hResult2D.invoke('Load', sFileName);
        end
        function Save(obj, sFileName)
            % Saves the Result2D object to file.
            obj.hResult2D.invoke('Save', sFileName);
        end
        function AddToTree(obj, sTreePath)
            % Inserts the Result2D object into the tree at the folder specified by sTreePath. NOTE: Save the Result2D object before adding it to the tree to set correct path.
            obj.hResult2D.invoke('AddToTree', sTreePath);
        end
        %% General Settings
        function SetTitle(obj, sName)
            % Sets / returns the title / x-axis label / y-axis label of the result.
            obj.hResult2D.invoke('SetTitle', sName);
        end
        function SetXLabel(obj, sName)
            % Sets / returns the title / x-axis label / y-axis label of the result.
            obj.hResult2D.invoke('SetXLabel', sName);
        end
        function SetYLabel(obj, sName)
            % Sets / returns the title / x-axis label / y-axis label of the result.
            obj.hResult2D.invoke('SetYLabel', sName);
        end
        function string = GetTitle(obj)
            % Sets / returns the title / x-axis label / y-axis label of the result.
            string = obj.hResult2D.invoke('GetTitle');
        end
        function string = GetXLabel(obj)
            % Sets / returns the title / x-axis label / y-axis label of the result.
            string = obj.hResult2D.invoke('GetXLabel');
        end
        function string = GetYLabel(obj)
            % Sets / returns the title / x-axis label / y-axis label of the result.
            string = obj.hResult2D.invoke('GetYLabel');
        end
        function SetXMin(obj, dValue)
            % Sets / returns the minimum / maximum value on the x- / y-axis. This defines the rectangular domain of the Result2D object.
            obj.hResult2D.invoke('SetXMin', dValue);
        end
        function SetXMax(obj, dValue)
            % Sets / returns the minimum / maximum value on the x- / y-axis. This defines the rectangular domain of the Result2D object.
            obj.hResult2D.invoke('SetXMax', dValue);
        end
        function SetYMin(obj, dValue)
            % Sets / returns the minimum / maximum value on the x- / y-axis. This defines the rectangular domain of the Result2D object.
            obj.hResult2D.invoke('SetYMin', dValue);
        end
        function SetYMax(obj, dValue)
            % Sets / returns the minimum / maximum value on the x- / y-axis. This defines the rectangular domain of the Result2D object.
            obj.hResult2D.invoke('SetYMax', dValue);
        end
        function double = GetXMin(obj)
            % Sets / returns the minimum / maximum value on the x- / y-axis. This defines the rectangular domain of the Result2D object.
            double = obj.hResult2D.invoke('GetXMin');
        end
        function double = GetXMax(obj)
            % Sets / returns the minimum / maximum value on the x- / y-axis. This defines the rectangular domain of the Result2D object.
            double = obj.hResult2D.invoke('GetXMax');
        end
        function double = GetYMin(obj)
            % Sets / returns the minimum / maximum value on the x- / y-axis. This defines the rectangular domain of the Result2D object.
            double = obj.hResult2D.invoke('GetYMin');
        end
        function double = GetYMax(obj)
            % Sets / returns the minimum / maximum value on the x- / y-axis. This defines the rectangular domain of the Result2D object.
            double = obj.hResult2D.invoke('GetYMax');
        end
        function SetDataUnit(obj, sUnit)
            % Sets / returns the unit of the stored data / x-axis / y-axis as string. The unit string uses the syntax described on the Units help page.
            obj.hResult2D.invoke('SetDataUnit', sUnit);
        end
        function SetXUnit(obj, sUnit)
            % Sets / returns the unit of the stored data / x-axis / y-axis as string. The unit string uses the syntax described on the Units help page.
            obj.hResult2D.invoke('SetXUnit', sUnit);
        end
        function etYUnit(obj, sUnit)
            % Sets / returns the unit of the stored data / x-axis / y-axis as string. The unit string uses the syntax described on the Units help page.
            obj.hResult2D.invoke('etYUnit', sUnit);
        end
        function string = GetDataUnit(obj)
            % Sets / returns the unit of the stored data / x-axis / y-axis as string. The unit string uses the syntax described on the Units help page.
            string = obj.hResult2D.invoke('GetDataUnit');
        end
        function string = GetXUnit(obj)
            % Sets / returns the unit of the stored data / x-axis / y-axis as string. The unit string uses the syntax described on the Units help page.
            string = obj.hResult2D.invoke('GetXUnit');
        end
        function string = GetYUnit(obj)
            % Sets / returns the unit of the stored data / x-axis / y-axis as string. The unit string uses the syntax described on the Units help page.
            string = obj.hResult2D.invoke('GetYUnit');
        end
        function SetLogarithmicFactor(obj, dValue)
            % Sets / returns logarithmic factor used for dB Scaling. The logarithmic factor can be 10 for power quantities, 20 for field quantities and zero if dB scaling is not available.
            obj.hResult2D.invoke('SetLogarithmicFactor', dValue);
        end
        function double = GetLogarithmicFactor(obj)
            % Sets / returns logarithmic factor used for dB Scaling. The logarithmic factor can be 10 for power quantities, 20 for field quantities and zero if dB scaling is not available.
            double = obj.hResult2D.invoke('GetLogarithmicFactor');
        end
        %% Data Access
        function long = GetNX(obj)
            % If the Result2D object has a regular grid arrangement GetNX / GetNY returns the number of data values on the x- / y-axis.
            % If the Result2D object has a triangle based arrangement GetNX returns the number of data values (total number of triangle corners) while GetNY always returns 1.
            % Thus the product of both values always is the total number of data values stored in the Result2D object.
            long = obj.hResult2D.invoke('GetNX');
        end
        function long = GetNY(obj)
            % If the Result2D object has a regular grid arrangement GetNX / GetNY returns the number of data values on the x- / y-axis.
            % If the Result2D object has a triangle based arrangement GetNX returns the number of data values (total number of triangle corners) while GetNY always returns 1.
            % Thus the product of both values always is the total number of data values stored in the Result2D object.
            long = obj.hResult2D.invoke('GetNY');
        end
        function long = GetNTriangles(obj)
            % Returns the total number of triangles stored in the Result2D object.
            long = obj.hResult2D.invoke('GetNTriangles');
        end
        function bool = IsComplex(obj)
            % Returns true if the Result2D object holds complex-valued data ("2DC"), otherwise false ("2D").
            bool = obj.hResult2D.invoke('IsComplex');
        end
        function string = GetResultObjectType(obj)
            % Returns the string "2DC" if the result object contains complex-valued data, otherwise it returns the string "2D". This method can be used to distinguish the result object from other result objects in a context where the type of a result object is unknown.
            string = obj.hResult2D.invoke('GetResultObjectType');
        end
        function SetValue(obj, iX, iY, dValue)
            % Sets / returns the real data value at the specified x/y index in the Result2D object. NOTE: If used with a "2DC" object an error is produced.
            obj.hResult2D.invoke('SetValue', iX, iY, dValue);
        end
        function double = GetValue(obj, iX, iY)
            % Sets / returns the real data value at the specified x/y index in the Result2D object. NOTE: If used with a "2DC" object an error is produced.
            double = obj.hResult2D.invoke('GetValue', iX, iY);
        end
        function SetValueComplex(obj, iX, iY, dRe, dIm)
            % Sets / returns the complex data value at the specified x/y index in the Result2D object. NOTE: If used with a "2D" object an error is produced.
            obj.hResult2D.invoke('SetValueComplex', iX, iY, dRe, dIm);
        end
        function [dRe, dIm] = GetValueComplex(obj, iX, iY)
            % Sets / returns the complex data value at the specified x/y index in the Result2D object. NOTE: If used with a "2D" object an error is produced.

            % Not sure how to implement this, so use the functions for each
            % one individually for now.
            dRe = obj.GetValueRe(iX, iY);
            dIm = obj.GetValueIm(iX, iY);

            % See Result3D.GetNxNyNz for the beginning of a possible implementation.
        end
        function SetValueRe(obj, iX, iY, dValue)
            % Sets / returns the real part / imaginary of the complex data value at the specified x/y index in the Result2D object. NOTE: If used with a "2D" object an error is produced.
            obj.hResult2D.invoke('SetValueRe', iX, iY, dValue);
        end
        function SetValueIm(obj, iX, iY, dValue)
            % Sets / returns the real part / imaginary of the complex data value at the specified x/y index in the Result2D object. NOTE: If used with a "2D" object an error is produced.
            obj.hResult2D.invoke('SetValueIm', iX, iY, dValue);
        end
        function double = GetValueRe(obj, iX, iY)
            % Sets / returns the real part / imaginary of the complex data value at the specified x/y index in the Result2D object. NOTE: If used with a "2D" object an error is produced.
            double = obj.hResult2D.invoke('GetValueRe', iX, iY);
        end
        function double = GetValueIm(obj, iX, iY)
            % Sets / returns the real part / imaginary of the complex data value at the specified x/y index in the Result2D object. NOTE: If used with a "2D" object an error is produced.
            double = obj.hResult2D.invoke('GetValueIm', iX, iY);
        end
        function SetArray(obj, dArray)
            % Sets data of the Result2D object from a double array.
            % The array needs to start with index zero and is expected to have as many elements as the Result2D object contains. Consider using the methods 'GetNX' and 'GetNY' to query and one of the 'Initialize...' commands to modify the number of data values of the Result2D object. The array's data layout is in row-major order. In case of complex data the real and imaginary values are alternating.
            obj.hResult2D.invoke('SetArray', dArray);
        end
        function variant = GetArray(obj)
            % Returns data of the Result2D object as a double array.
            % The array needs to start with index zero and is expected to have as many elements as the Result2D object contains. Consider using the methods 'GetNX' and 'GetNY' to query and one of the 'Initialize...' commands to modify the number of data values of the Result2D object. The array's data layout is in row-major order. In case of complex data the real and imaginary values are alternating.
            variant = obj.hResult2D.invoke('GetArray');
        end
        function SetTriangleArray(obj, dArray)
            % Sets triangle data of the Result2D object from a double array.
            % The array needs to start with index zero and is expected to have as many elements as the Result2D object contains. Consider using the methods 'GetNTriangle' to query and 'InitializeTriangulation' or 'InitializeTriangulationComplex' to modify the number of triangles of the Result2D object. The array's data layout is x11,y11, x12,y12, x13,y13, x21,y21,... with x1*, y1* being the coordinates of the first triangle and so on.
            obj.hResult2D.invoke('SetTriangleArray', dArray);
        end
        function variant = GetTriangleArray(obj)
            % Returns triangle data of the Result2D object as a double array.
            % The array needs to start with index zero and is expected to have as many elements as the Result2D object contains. Consider using the methods 'GetNTriangle' to query and 'InitializeTriangulation' or 'InitializeTriangulationComplex' to modify the number of triangles of the Result2D object. The array's data layout is x11,y11, x12,y12, x13,y13, x21,y21,... with x1*, y1* being the coordinates of the first triangle and so on.
            variant = obj.hResult2D.invoke('GetTriangleArray');
        end
        function double = GetGlobalMaximum(obj, iX, iY)
            % This function was not implemented due to the Result2D
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetGlobalMaximum''.');
            double = nan;
            return;
            % Returns the x/y index of the overall maximum / minimum of the data values and the overall maximum / minimum value itself. NOTE: If used with a "2DC" object an error is produced.
            double = obj.hResult2D.invoke('GetGlobalMaximum', iX, iY);
        end
        function double = GetGlobalMinimum(obj, iX, iY)
            % This function was not implemented due to the Result2D
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetGlobalMinimum''.');
            double = nan;
            return;
            % Returns the x/y index of the overall maximum / minimum of the data values and the overall maximum / minimum value itself. NOTE: If used with a "2DC" object an error is produced.
            double = obj.hResult2D.invoke('GetGlobalMinimum', iX, iY);
        end
        %% 2D to 2D Operations
        function result2D = Copy(obj)
            % Returns a copy of the object.
            newhResult2D = obj.hResult2D.invoke('Copy');

            result2D = CST.Result2D(obj.project, newhResult2D);
        end
        function result2D = Real(obj)
            % Returns a Result2D object filled with the real / imaginary part of the data stored in the calling Result2D object. NOTE: If used with a "2D" object an error is produced.
            newhResult2D = obj.hResult2D.invoke('Real');

            result2D = CST.Result2D(obj.project, newhResult2D);
        end
        function result2D = Imaginary(obj)
            % Returns a Result2D object filled with the real / imaginary part of the data stored in the calling Result2D object. NOTE: If used with a "2D" object an error is produced.
            newhResult2D = obj.hResult2D.invoke('Imaginary');

            result2D = CST.Result2D(obj.project, newhResult2D);
        end
        function result2D = Magnitude(obj)
            % Returns a Result2D object filled with the magnitude / phase (in degrees) of the data stored in the calling Result2D object. NOTE: If used with a "2D" object an error is produced.
            newhResult2D = obj.hResult2D.invoke('Magnitude');

            result2D = CST.Result2D(obj.project, newhResult2D);
        end
        function result2D = Phase(obj)
            % Returns a Result2D object filled with the magnitude / phase (in degrees) of the data stored in the calling Result2D object. NOTE: If used with a "2D" object an error is produced.
            newhResult2D = obj.hResult2D.invoke('Phase');

            result2D = CST.Result2D(obj.project, newhResult2D);
        end
        %% Local Operations
        function Add(obj, result2D)
            % Adds / subtracts the components in oObject  to / from the calling object's components. The result will be stored in the calling object. Before calling this method please make sure that the calling object and oObject contain compatible data (same number of samples, same value type (real/complex)).
            obj.hResult2D.invoke('Add', result2D.hResult2D);
        end
        function Subtract(obj, result2D)
            % Adds / subtracts the components in oObject  to / from the calling object's components. The result will be stored in the calling object. Before calling this method please make sure that the calling object and oObject contain compatible data (same number of samples, same value type (real/complex)).
            obj.hResult2D.invoke('Subtract', result2D.hResult2D);
        end
        function ComponentMult(obj, result2D)
            % Multiplies / divides the components in oObject  with / by the calling object's components. The result will be stored in the calling object. Before calling this method please make sure that the calling object and oObject contain compatible data (same number of samples, same value type (real/complex)).
            obj.hResult2D.invoke('ComponentMult', result2D.hResult2D);
        end
        function ComponentDiv(obj, result2D)
            % Multiplies / divides the components in oObject  with / by the calling object's components. The result will be stored in the calling object. Before calling this method please make sure that the calling object and oObject contain compatible data (same number of samples, same value type (real/complex)).
            obj.hResult2D.invoke('ComponentDiv', result2D.hResult2D);
        end
        function ScalarMult(obj, dValue)
            % Multiplies all real data values of the current object with the given real number. NOTE: If used with a "2DC" object an error is produced.
            obj.hResult2D.invoke('ScalarMult', dValue);
        end
        function ScalarMultReIm(obj, dRe, dIm)
            % Multiplies all complex data values of the current object with the given complex number. NOTE: If used with a "2D" object an error is produced.
            obj.hResult2D.invoke('ScalarMultReIm', dRe, dIm);
        end
        function Conjugate(obj)
            % Conjugates all complex data values of the current object.
            obj.hResult2D.invoke('Conjugate');
        end
        function InterpolateTriangulation(obj)
            % Converts a Result2D object with a triangle based arrangement into a Result2D object with a regular grid arrangement. The number of samples on the grid is automatically derived from the number of triangles.
            % NOTE: For complex data values, the interpolation is done on real and imaginary parts separately.
            % NOTE: If used with grid based Result2D object an error is produced.
            obj.hResult2D.invoke('InterpolateTriangulation');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hResult2D

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% This example creates an empty object, fills it with real-valued data and adds it to the ResultTree.
% 
% Dim result As Object
% Set result = Result2D('');
% result2d = project.Result2D();
%   .Initialize(2, 2)
%   .SetValue(0, 0, 0.0)
%   .SetValue(0, 1, 0.5)
%   .SetValue(1, 0, 0.5)
%   .SetValue(1, 1, 1.0)
%   .SetTitle('2D Result');
%   .Save('my_result.dat');
%   .AddToTree('2D/3D Results\Test\real2d');
% 
% 
% 
% 
% CST Studio Suite 2020 | 3DS.COM/SIMULIA
% 
