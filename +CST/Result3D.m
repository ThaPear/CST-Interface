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

% This object offers access and manipulation functions to 3D results. Therefore it may contain either vector fields or scalar fields. If a scalar field is represented by this object, its values are treated to be x-components of a vector field, while all other components are not available. Therefore all functions that manipulate the x-components manipulate the components of the scalar field.
classdef Result3D < handle
    %% CST Interface specific functions.
    methods(Access = {?CST.Project, ?CST.Result1D})
        % CST.Project can create a CST.Result3D object.
        % CST.Result3D.Copy can create a Result3D object.
        function obj = Result3D(project, hProjectOrhResult3D, resultname)
            if(nargin == 3)
                % Created by CST.Project.
                hProject = hProjectOrhResult3D;
                obj.project = project;
                obj.hResult3D = hProject.invoke('Result3D', resultname);
            else
                obj.project = project;
                obj.hResult3D = hProjectOrhResult3D;
            end
        end
    end
    %% CST Object functions.
    methods
        %% Initialization, File Operation
        % Construction
        % A Result3D object must be constructed with a string as argument. The string may either be empty or the name of a result file. If the string is empty, an empty object will be created.
        % If the string contains a valid result file name, the object will read the values into its memory and represent this data. The behavior will be the same as if an empty object is created and afterwards filled by the Load command.
        function Load(obj, sObjectName)
            % Only used for VBA scripts running in an external program. Loads a 3D result from a file with a file path contructed from sObjectName.
            % Syntax              Resulting file path
            % "ObjectName"        "object_name.m3d"  in the current working folder
            % "^ObjectName"       "projectName^ObjectName.m3d"  in the current working folder
            % "Path\ObjectName"   "object_name.m3d"  in the folder specified by "path". The "^" does not expand the file name.
            % For tetrahedral mesh, the ending ".m3t" has to be used, for surface mesh ".sct".
            obj.hResult3D.invoke('Load', sObjectName);
        end
        function Save(obj, sObjectName)
            % Saves the object with the given filename. Note, that like in the Load method, the project name is added if the first character is a '^'. If the filename is blank the data is saved with name of the previous loaded file.
            obj.hResult3D.invoke('Save', sObjectName);
        end
        function Initialize(obj, nx, ny, nz, type)
            % Initializes an empty Result3D object of the given type with the specified dimensions.
            % type: 'vector'
            %       'scalar'
            obj.hResult3D.invoke('Initialize', nx, ny, nz, type);
        end
        function InitSCT(obj, numberOfFirstSideTriangles, nSamplesPerTriangle, nComponents, numberOfSecondSideTriangles)
            % Initializes the object as zero valued SCT surface vector result data, i.e. nComponents=6 for complex vector.
            obj.hResult3D.invoke('InitSCT', numberOfFirstSideTriangles, nSamplesPerTriangle, nComponents, numberOfSecondSideTriangles);
        end
        function AddToTree(obj, sTreePath, sLabel)
            % Inserts the Result3D object into the tree at the folder specified by sTreePath with a item name given by sLabel.
            obj.hResult3D.invoke('AddToTree', sTreePath, sLabel);
        end
        %% Global Field Operators
        function result3D = Copy(obj)
            % Returns a new Result3D object as copy. Usage: set res2 = res1.Copy(). Be aware to use set when assigning vba objects.
            newhResult3D = obj.hResult3D.invoke('Copy');

            result3D = CST.Result3D(obj.project, newhResult3D);
        end
        function ScalarMult(obj, dFactor)
            % Scales the Result3D Object with the given factor.
            obj.hResult3D.invoke('ScalarMult', dFactor);
        end
        function ScalarMult3(obj, dFactorX, dFactorY, dFactorZ)
            % Scales the x/y/z components of the Result3D Object individually. This function is only valid for vector field Result Objects.
            obj.hResult3D.invoke('ScalarMult3', dFactorX, dFactorY, dFactorZ);
        end
        function Add(obj, oObject)
            % Adds / subtracts the components in oObject  to / from the calling object's components. The result will be stored in the calling object.
            if(isa(oObject, 'CST.Result3D'))
                oObject = oObject.hResult3D;
            end
            obj.hResult3D.invoke('Add', oObject);
        end
        function Subtract(obj, oObject)
            % Adds / subtracts the components in oObject  to / from the calling object's components. The result will be stored in the calling object.
            if(isa(oObject, 'CST.Result3D'))
                oObject = oObject.hResult3D;
            end
            obj.hResult3D.invoke('Subtract', oObject);
        end
        function Combine(obj, oObject2, dFactor2, iComponent1, iComponent2)
            % Performs a component wise operation between two Result3D objects: oCallingObject[iComponent1] += dFactor2 * oObject2[iComponent2]. The component indices iComponent1 and iComponent2 can have values from 0 to 5 for Xre=0, Yre=1, Zre=2, ..., Zim=5. The result will be stored in the calling object.
            if(isa(oObject2, 'CST.Result3D'))
                oObject2 = oObject.hResult3D;
            end
            obj.hResult3D.invoke('Combine', oObject2, dFactor2, iComponent1, iComponent2);
        end
        function DotProduct(obj, oObject, dRe, dIm)
            % Performs a inner product between field vectors of two Result3D objects for each point. The result will be stored in the x component of the calling object, y and z will be set to zero. The spatial sum over all points of the result can be obtained in dRe and dIm.
            if(isa(oObject, 'CST.Result3D'))
                oObject = oObject.hResult3D;
            end
            obj.hResult3D.invoke('DotProduct', oObject, dRe, dIm);
        end
        function VectorProd(obj, oObject)
            % Performs a vector product of two Result3D objects. The result will be stored in the calling object.
            if(isa(oObject, 'CST.Result3D'))
                oObject = oObject.hResult3D;
            end
            obj.hResult3D.invoke('VectorProd', oObject);
        end
        function Conjugate(obj)
            % Calculates the complex conjugates of calling object.
            obj.hResult3D.invoke('Conjugate');
        end
        %% Local Set/Get Methods
        % Local Set/Get methods use a zero-based index to reference data in the Result3D Object. For regular hexahedral mesh the index is given by
        % index = ix + iy*nx + iz*nx*ny < .GetLength = nx*ny*nz,
        % where ix, iy, iz are the zero based indices for the mesh nodes in one coordinate direction and nx, ny, nz are the numbers of meshnodes in the corresponding coordinate directions.
        % For tetrahedral mesh the index is based on the tetrahedron index combined with the number of samples per tetrahedron. A relation to coordinates is not given.
        function SetXRe(obj, index, dValue)
            % Changes the real/imaginary part of the x/y/z-component at the index in the Result3D Object to dValue. For scalar Result3D objects, only the SetXRe method may be used.
            obj.hResult3D.invoke('SetXRe', index, dValue);
        end
        function SetYRe(obj, index, dValue)
            % Changes the real/imaginary part of the x/y/z-component at the index in the Result3D Object to dValue. For scalar Result3D objects, only the SetXRe method may be used.
            obj.hResult3D.invoke('SetYRe', index, dValue);
        end
        function SetZRe(obj, index, dValue)
            % Changes the real/imaginary part of the x/y/z-component at the index in the Result3D Object to dValue. For scalar Result3D objects, only the SetXRe method may be used.
            obj.hResult3D.invoke('SetZRe', index, dValue);
        end
        function SetXIm(obj, index, dValue)
            % Changes the real/imaginary part of the x/y/z-component at the index in the Result3D Object to dValue. For scalar Result3D objects, only the SetXRe method may be used.
            obj.hResult3D.invoke('SetXIm', index, dValue);
        end
        function SetYIm(obj, index, dValue)
            % Changes the real/imaginary part of the x/y/z-component at the index in the Result3D Object to dValue. For scalar Result3D objects, only the SetXRe method may be used.
            obj.hResult3D.invoke('SetYIm', index, dValue);
        end
        function SetZIm(obj, index, dValue)
            % Changes the real/imaginary part of the x/y/z-component at the index in the Result3D Object to dValue. For scalar Result3D objects, only the SetXRe method may be used.
            obj.hResult3D.invoke('SetZIm', index, dValue);
        end
        function double = GetXRe(obj, index)
            % Returns the real/imaginary part of the x/y/z-component in the Result3D Object that corresponds to the given index. For scalar Result3D objects, only the GetXRe method may be used.
            double = obj.hResult3D.invoke('GetXRe', index);
        end
        function double = GetYRe(obj, index)
            % Returns the real/imaginary part of the x/y/z-component in the Result3D Object that corresponds to the given index. For scalar Result3D objects, only the GetXRe method may be used.
            double = obj.hResult3D.invoke('GetYRe', index);
        end
        function double = GetZRe(obj, index)
            % Returns the real/imaginary part of the x/y/z-component in the Result3D Object that corresponds to the given index. For scalar Result3D objects, only the GetXRe method may be used.
            double = obj.hResult3D.invoke('GetZRe', index);
        end
        function double = GetXIm(obj, index)
            % Returns the real/imaginary part of the x/y/z-component in the Result3D Object that corresponds to the given index. For scalar Result3D objects, only the GetXRe method may be used.
            double = obj.hResult3D.invoke('GetXIm', index);
        end
        function double = GetYIm(obj, index)
            % Returns the real/imaginary part of the x/y/z-component in the Result3D Object that corresponds to the given index. For scalar Result3D objects, only the GetXRe method may be used.
            double = obj.hResult3D.invoke('GetYIm', index);
        end
        function double = GetZIm(obj, index)
            % Returns the real/imaginary part of the x/y/z-component in the Result3D Object that corresponds to the given index. For scalar Result3D objects, only the GetXRe method may be used.
            double = obj.hResult3D.invoke('GetZIm', index);
        end
        function GetDataFromIndex(obj, index, xre, yre, zre, xim, yim, zim)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            % Not sure how to implement this with project.RunVBACode either.
            warning('Used unimplemented function ''GetDataFromIndex''.');
            return;
            % Yields real and imaginary parts of all vector components for the given index.
            obj.hResult3D.invoke('GetDataFromIndex', index, xre, yre, zre, xim, yim, zim);
        end
        function variant = GetArray(obj, component)
            % Returns the array of the component results for all meshnodes ordered by the indexing scheme described above. The return value is an array of doubles. Valid components are "xre", "yre", "zre",  "xim", "yim", "zim".
            variant = obj.hResult3D.invoke('GetArray', component);
        end
        function variant = GetSubArray(obj, component, offset, length)
            % Returns a sub range of an array of component results ordered by the indexing scheme described above. The return value is an array of doubles. Valid components are "xre", "yre", "zre",  "xim", "yim", "zim". Offset is the start index of the range and length the number of elements in the range
            variant = obj.hResult3D.invoke('GetSubArray', component, offset, length);
        end
        function SetArray(obj, values, component)
            % Sets an array of component results for all meshnodes ordered by the indexing scheme described above. Valid components are "xre", "yre", "zre",  "xim", "yim", "zim".
            obj.hResult3D.invoke('SetArray', values, component);
        end
        function SetSubArray(obj, values, component, offset)
            % Sets a sub range on an array of component results ordered by the indexing scheme described above. Valid components are "xre", "yre", "zre",  "xim", "yim", "zim". Offset is the start index of the range.
            obj.hResult3D.invoke('SetSubArray', values, component, offset);
        end
        %% General Settings
        function SetType(obj, type)
            % enum type                   Object contains...
            % "dynamic e-field"           electric vector field from a dynamic simulation.
            % "dynamic d-field"           electric flux density vector field from a dynamic simulation.
            % "dynamic h-field"           magnetic vector field from a dynamic simulation.
            % "dynamic b-field"           magnetic flux density vector field from a dynamic simulation.
            % "dynamic powerflow"         vector field of the calculated poynting vectors.
            % "dynamic Current"           vector field of the current density from a dynamic simulation.
            % "dynamic e-energy"          scalar field of the electric energy density.
            % "dynamic h-energy"          scalar field of the magnetic energy density.
            % "dynamic loss density"      scalar field of the loss density, caused by a conductivity.
            % "dynamic sar"               scalar field of a sar simulation.
            % "static e-field"            electric vector field from a static simulation.
            % "static d-field"            electric flux density vector field from a static simulation.
            % "static h-field"            magnetic vector field from a static simulation.
            % "static b-field"            magnetic flux density vector field from a static simulation.
            % "static current"            vector field of the current density from a static simulation.
            % "static el-potential"       scalar field of electric potentials.
            % "static charge"             scalar field of charges.
            % "static material mu"        scalar field of the permeability.
            % "space charge"              scalar field of the space charge density from a  PIC simulation
            % "temperature"               scalar field of the temperature distribution from a thermal simulation
            % "heat flow density"         vector field of the heat flow density from a thermal simulation
            % "mechanical displacement"   vector field of the displacement from a mechanical simulation
            % "mechanical stress"         scalar field of a component from the stress tensor from a mechanical simulation
            % "von mises stress"          scalar field of the von mises stress from a mechanical simulation
            % "hydrostatic stress"        scalar field of the hydrostatic stress from a mechanical simulation
            % "mechanical strain"         scalar field of a component from the strain tensor from a mechanical simulation
            % "volumetric strain"         scalar field of the volumetric strain from a mechanical simulation
            % "temperature change"        scalar field of the interpolated temperature change from a mechanical simulation
            obj.hResult3D.invoke('SetType', type);
        end
        function enum = GetType(obj)
            % Sets / returns the field type contained in the Result3D Object.
            enum = obj.hResult3D.invoke('GetType');
        end
        function SetActive(obj, flag)
            % Sets / determines, if the object contains valid data. GetActive may return "false" if, for instance, the monitor was outside the frequency range, when performing a dynamic simulation.
            obj.hResult3D.invoke('SetActive', flag);
        end
        function bool = GetActive(obj)
            % Sets / determines, if the object contains valid data. GetActive may return "false" if, for instance, the monitor was outside the frequency range, when performing a dynamic simulation.
            bool = obj.hResult3D.invoke('GetActive');
        end
        function SetFrequency(obj, dValue)
            % Sets / returns the frequency for which the values in the Result3D object are valid.
            obj.hResult3D.invoke('SetFrequency', dValue);
        end
        function double = GetFrequency(obj)
            % Sets / returns the frequency for which the values in the Result3D object are valid.
            double = obj.hResult3D.invoke('GetFrequency');
        end
        function SetQFactor(obj, dValue)
            % Sets / returns the Q factor for the Result3D Object. Usually set in fields calculated by the complex eigenmode solver.
            obj.hResult3D.invoke('SetQFactor', dValue);
        end
        function double = GetQFactor(obj)
            % Sets / returns the Q factor for the Result3D Object. Usually set in fields calculated by the complex eigenmode solver.
            double = obj.hResult3D.invoke('GetQFactor');
        end
        function SetExternalQFactor(obj, dValue)
            % Sets / returns the external Q factor for the Result3D Object. Usually set in fields calculated by the eigenmode solver.
            obj.hResult3D.invoke('SetExternalQFactor', dValue);
        end
        function double = GetExternalQFactor(obj)
            % Sets / returns the external Q factor for the Result3D Object. Usually set in fields calculated by the eigenmode solver.
            double = obj.hResult3D.invoke('GetExternalQFactor');
        end
        function SetLoadedFrequency(obj, dValue)
            % Sets / returns the loaded frequency for the Result3D Object. Usually set in fields calculated by the eigenmode solver.
            obj.hResult3D.invoke('SetLoadedFrequency', dValue);
        end
        function double = GetLoadedFrequency(obj)
            % Sets / returns the loaded frequency for the Result3D Object. Usually set in fields calculated by the eigenmode solver.
            double = obj.hResult3D.invoke('GetLoadedFrequency');
        end
        function SetAccuracy(obj, dValue)
            % Sets / returns the accuracy of the values in the Result3D object.
            obj.hResult3D.invoke('SetAccuracy', dValue);
        end
        function double = GetAccuracy(obj)
            % Sets / returns the accuracy of the values in the Result3D object.
            double = obj.hResult3D.invoke('GetAccuracy');
        end
        function SetUnit(obj, sUnit)
            % Sets / returns the unit as string of the stored field. The unit string uses the syntax described on the Units help page.
            obj.hResult3D.invoke('SetUnit', sUnit);
        end
        function string = GetUnit(obj)
            % Sets / returns the unit as string of the stored field. The unit string uses the syntax described on the Units help page.
            string = obj.hResult3D.invoke('GetUnit');
        end
        function SetLogarithmicFactor(obj, dValue)
            % Sets / returns logarithmic factor used for dB Scaling. The logarithmic factor can be 10 for power quantities, 20 for field quantities and zero if dB scaling is not available.
            obj.hResult3D.invoke('SetLogarithmicFactor', dValue);
        end
        function double = GetLogarithmicFactor(obj)
            % Sets / returns logarithmic factor used for dB Scaling. The logarithmic factor can be 10 for power quantities, 20 for field quantities and zero if dB scaling is not available.
            double = obj.hResult3D.invoke('GetLogarithmicFactor');
        end
        function long = GetNx(obj)
            % Returns the number of mesh nodes in x/y/z-direction. Returns zero for tetrahedral meshes.
            long = obj.hResult3D.invoke('GetNx');
        end
        function long = GetNy(obj)
            % Returns the number of mesh nodes in x/y/z-direction. Returns zero for tetrahedral meshes.
            long = obj.hResult3D.invoke('GetNy');
        end
        function long = GetNz(obj)
            % Returns the number of mesh nodes in x/y/z-direction. Returns zero for tetrahedral meshes.
            long = obj.hResult3D.invoke('GetNz');
        end
        function GetNxNyNz(obj, nx, ny, nz)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            % Not sure how to implement this with project.RunVBACode either.
            warning('Used unimplemented function ''GetNxNyNz''.');
            return;
            % Yields the number of mesh nodes in all three coordinate directions. Yields zero for tetrahedral meshes.
            obj.hResult3D.invoke('GetNxNyNz', nx, ny, nz);
        end
        function long = GetLength(obj)
            % Returns the dimension of the Result3D Object. This value is equal to nx*ny*nz for regular hexahedral meshes and equal to nTets*nSamplesPerTet for tetrahedral meshes.
            long = obj.hResult3D.invoke('GetLength');
        end
        function bool = IsScalar(obj)
            % Determines, if the object contains only scalar values.
            bool = obj.hResult3D.invoke('IsScalar');
        end
        function bool = IsComplex(obj)
            % Determines, if the object contains complex values.
            bool = obj.hResult3D.invoke('IsComplex');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hResult3D

    end
end

%% Default Settings

%% Example - Taken from CST documentation and translated to MATLAB.
% The following VBA-Script adds a result vector with its complex conjugate, stores it to file with a separate filename and adds the result to the Navigation Tree.
%
% % result file('projectName^e1.m3d');
% res1 = project.Result3D('^e1');
%
% % Copy the data of res1 into res2
% res2 = res1.Copy();
% % Calculate the complex conjugate
% res1.Conjugate();
% % Add both results
% res1.Add(res2)
%
% % Save the result in a file named('projectName^MyResult.m3d');
% res1.Save('^MyResult');
%
% %Store the result into the tree
% res1.AddToTree('2D/3D Results\MyFolder', 'MyResult');
%
%
% % Example for Tetrahedral Mesh
% % As above, but for tetrahedral mesh, the following VBA-Script adds a result vector with its complex conjugate, stores it to file with a separate filename and adds the result to the Navigation Tree.
%
% % Create an object with the project result file('projectName^e1.m3t');
% res1 = project.Result3D('^e-field(#0001)_1(1).m3t');
%
% % Copy the data of res1 into res2
% res2 = res1.Copy();
% % Calculate the complex conjugate
% res1.Conjugate();
% % Add both results
% res1.Add(res2);
%
% % Save the result in a file named('projectName^MyResult.m3t');
% res1.Save('^MyResult.m3t');
%
% % Store the result into the tree
% res1.AddToTree('2D/3D Results\MyFolder', 'MyResult.m3t');
%
