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

% The object is used to initialize a static magnetic H-field with a given direction of the field vector or a rotational symmetric magnetic field with the help of the tangential B-field along the w/z-axis of the active coordinate system. This source definition is considered by the magnetostatic solver to calculate the magnetostatic scatter field.
classdef SourceField < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.SourceField object.
        function obj = SourceField(project, hProject)
            obj.project = project;
            obj.hSourceField = hProject.invoke('SourceField');
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
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function FieldVector(obj, xcomp, ycomp, zcomp)
            % Sets the orientation vector, i.e. the field components of a constant magnetic source field. The resulting total field is the sum of the specified source field and the computed  secondary field taking into account further sources and materials (e.g. jumps at material interfaces). Only the total field is available as a result.
            % For technical reasons the constant source field has to fulfill tangential/electric boundary conditions. On normal/magnetic boundaries no restrictions exist for the source field. Note that only the secondary field is normal at these boundaries while the total field has a tangential component prescribed by the source field.
            % Please note: The field components are always interpreted as peak values even if source value scaling RMS was activated in the low frequency solver settings.
            obj.AddToHistory(['.FieldVector "', num2str(xcomp, '%.15g'), '", '...
                                           '"', num2str(ycomp, '%.15g'), '", '...
                                           '"', num2str(zcomp, '%.15g'), '"']);
        end
        function FieldPhase(obj, xcomp, ycomp, zcomp)
            % Sets the phases of the X, Y, Z field components for a time harmonic and space-constant magnetic source field. This setting is only taken into account for the low frequency solver, but ignored for the magnetostatic solver.
            obj.AddToHistory(['.FieldPhase "', num2str(xcomp, '%.15g'), '", '...
                                          '"', num2str(ycomp, '%.15g'), '", '...
                                          '"', num2str(zcomp, '%.15g'), '"']);
        end
        function FieldType(obj, type)
            % Sets the type of the field. Valid types are:
            % type                meaning
            % "constant vector"   Define a magnetization by a constant vector.
            % "1d description"    Create a rotational symmetric magnetostatic field with a given 1D description of the tangential B-field along the active coordinates w/z-axis.
            obj.AddToHistory(['.FieldType "', num2str(type, '%.15g'), '"']);
        end
        function Store(obj)
            % Stores the defined source field.
            obj.AddToHistory(['.Store']);
            
            % Prepend With SourceField and append End With
            obj.history = [ 'With SourceField', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define SourceField'], obj.history);
            obj.history = [];
        end
        function Delete(obj)
            % Deletes the source field definition.
            obj.project.AddToHistory(['SourceField.Delete']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hSourceField
        history

    end
end

%% Default Settings
% Type        ('MStatic');
% FieldVector ('1', '0.0', '0.0');

%% Example - Taken from CST documentation and translated to MATLAB.
% sourcefield = project.SourceField();
%     sourcefield.Reset
%     sourcefield.Type        ('MStatic');
%     sourcefield.FieldVector ('1', '0.0', '0.0');
%     sourcefield.Store
