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

% The object is used to initialize predefined electric and magnetic fields for tracking- or PIC-simulations.
% Two distinct possibilities exist. One is to define analytical magnetic fields, which can be homogeneous or rotational symmetric. The other possibility is to import fields from external files or from external CST projects.
% Although the methods of this object can be used to import external electric or magnetic fields from files, it is recommended to use instead the dialog box "Simulation: Sources and Loads -> Source Field -> Import External Field".
classdef PredefinedField < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.PredefinedField object.
        function obj = PredefinedField(project, hProject)
            obj.project = project;
            obj.hPredefinedField = hProject.invoke('PredefinedField');
            obj.history = [];
        end
    end
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
    end
    %% CST Object functions.
    methods
        function ResetAnalyticSettings(obj)
            % Resets all settings of the analytically-defined magnetic fields to their default values.
            obj.AddToHistory(['.ResetAnalyticSettings']);
        end
        function ResetExternalSettings(obj)
            % Resets all settings of the fields which were imported from external files to their default values.
            obj.AddToHistory(['.ResetExternalSettings']);
        end
        function FieldType(obj, fieldtype)
            % Type of the source field.
            % enum fieldtype  meaning
            % "Hconst"        A constant homogeneous magnetic field is defined.
            % "Bconst"        A constant homogeneous magnetic flux density is defined.
            % "Bz"            A rotational syymetric field is defined.
            % "External"      An external field from an ASCII file or a .m3d file is imported.
            obj.AddToHistory(['.FieldType "', num2str(fieldtype, '%.15g'), '"']);
        end
        function HFieldVector(obj, xcomp, ycomp, zcomp)
            % Constant h-field,. The orientation and strength is given by the three arguments. Only evaluated if fieldtype "Hconst" is chosen.
            obj.AddToHistory(['.HFieldVector "', num2str(xcomp, '%.15g'), '", '...
                                            '"', num2str(ycomp, '%.15g'), '", '...
                                            '"', num2str(zcomp, '%.15g'), '"']);
        end
        function BFieldVector(obj, xcomp, ycomp, zcomp)
            % Constant b-field,. The orientation and strength is given by the three arguments. Only evaluated if fieldtype "Bconst" is chosen.
            obj.AddToHistory(['.BFieldVector "', num2str(xcomp, '%.15g'), '", '...
                                            '"', num2str(ycomp, '%.15g'), '", '...
                                            '"', num2str(zcomp, '%.15g'), '"']);
        end
        function AddBzValue(obj, position, bzvalue)
            % B-field value at the given position along the z/w axis of the active coordinate system for the "1d description" definition type. Only evaluated if fieldtype "Bz" is chosen.
            obj.AddToHistory(['.AddBzValue "', num2str(position, '%.15g'), '", '...
                                          '"', num2str(bzvalue, '%.15g'), '"']);
        end
        function ExternalFieldMur(obj, mur)
            % If a magnetic field monitor has been defined, this value is considered for the calculation of the relevant magnetic flux density.
            obj.AddToHistory(['.ExternalFieldMur "', num2str(mur, '%.15g'), '"']);
        end
        function UseLocalCopyOnly(obj, boolean)
            % Defines if the local copy of the imported field data file should be used only for all future simulation runs.
            obj.AddToHistory(['.UseLocalCopyOnly "', num2str(boolean, '%.15g'), '"']);
        end
        function UpdateLocalCopies(obj, boolean)
            % If switch is set to True, the local copies of the imported fields are updated with the field data from the import location.
            obj.AddToHistory(['.UpdateLocalCopies "', num2str(boolean, '%.15g'), '"']);
        end
        function SetExternalField(obj, boolean, fieldpath, factor, phase, fieldID, relpath)
            % Defines a new external field source. It is defined by a flag which indicates if the source is active, a field path, a scaling factor and for frequency dependant fields a phase value. The fieldID is a unique label that should be used only for the particular field import and it can be set to non-negative integer values.
            % When a field is imported from a CST project, fieldpath is the path to the CST project including the ending ".cst".
            % If relpath is set to True, the relative path of an imported file (with respect to the location of the .cst project) is used to access the imported files. For example, if the .cst project absolute path is "C:\projects\gun.cst" and the absolute path of the import file is "C:\imports\field.txt", then the relative path of the import is "..\..\imports\field.txt". This command is useful for simulations with the System Assembly and Modeling (SAM).
            obj.AddToHistory(['.SetExternalField "', num2str(boolean, '%.15g'), '", '...
                                                '"', num2str(fieldpath, '%.15g'), '", '...
                                                '"', num2str(factor, '%.15g'), '", '...
                                                '"', num2str(phase, '%.15g'), '", '...
                                                '"', num2str(fieldID, '%.15g'), '", '...
                                                '"', num2str(relpath, '%.15g'), '"']);
        end
        function SetExternalFieldTimeSignal(obj, fieldID, signal)
            % Sets the signal with which the field with the given field ID will be multiplied.
            obj.AddToHistory(['.SetExternalFieldTimeSignal "', num2str(fieldID, '%.15g'), '", '...
                                                          '"', num2str(signal, '%.15g'), '"']);
        end
        function SetExternalFieldTimeShift(obj, fieldID, shift)
            % Sets the time shift with which the field with the given field ID will be shifted.
            obj.AddToHistory(['.SetExternalFieldTimeShift "', num2str(fieldID, '%.15g'), '", '...
                                                         '"', num2str(shift, '%.15g'), '"']);
        end
        function SetExternalFieldDescription(obj, fieldID, description)
            % In case of a field import from a CST project (with the given field ID as set with SetExternalField), the description is the name of the field that is imported.
            obj.AddToHistory(['.SetExternalFieldDescription "', num2str(fieldID, '%.15g'), '", '...
                                                           '"', num2str(description, '%.15g'), '"']);
        end
        function SetExternalFiedASCIIType(obj, fieldpath, type)
            % In case of a ASCII field import with a given fieldpath , the type is the field type and must be set to one of the following strings: "B-Field", "H-Field" or "E-Field"..
            obj.AddToHistory(['.SetExternalFiedASCIIType "', num2str(fieldpath, '%.15g'), '", '...
                                                        '"', num2str(type, '%.15g'), '"']);
        end
        function SetExternalFiedASCIISymmetries(obj, fieldpath, symX, symY, symZ)
            % In case of a ASCII field import with a given fieldpath ,  symX, symY and symZ  set the symmetry type of the field in the corresponding directions and must be set to one of the following strings: "None", "Electric" or "Magnetic".
            obj.AddToHistory(['.SetExternalFiedASCIISymmetries "', num2str(fieldpath, '%.15g'), '", '...
                                                              '"', num2str(symX, '%.15g'), '", '...
                                                              '"', num2str(symY, '%.15g'), '", '...
                                                              '"', num2str(symZ, '%.15g'), '"']);
        end
        function SetExternalFiedASCIIFrequency(obj, fieldpath, frequency)
            % In case of a ASCII field import with a given fieldpath , this method sets the frequency of the imported field..
            obj.AddToHistory(['.SetExternalFiedASCIIFrequency "', num2str(fieldpath, '%.15g'), '", '...
                                                             '"', num2str(frequency, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the defined source field.
            obj.AddToHistory(['.Create']);
            
            % Prepend With PredefinedField and append End With
            obj.history = [ 'With PredefinedField', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define PredefinedField'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPredefinedField
        history

    end
end

%% Default Settings
% FieldType      ('');
% HFieldVector   ('0', '0', '0');
% BFieldVector   ('0', '0', '0');
% UseLocalCopyOnly('0');
% ExternalFieldMur('1.0');

%% Example - Taken from CST documentation and translated to MATLAB.
% predefinedfield = project.PredefinedField();
%     predefinedfield.ResetAnalyticSettings
%     predefinedfield.FieldType  ('Hconst');
%     predefinedfield.HFieldVector('0.0', '0.0', '1.0');
%     predefinedfield.Create
