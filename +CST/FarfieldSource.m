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

% Use this object to define a farfield as a source for the simulation. The field source can be used to excite a single simulation.
classdef FarfieldSource < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.FarfieldSource object.
        function obj = FarfieldSource(project, hProject)
            obj.project = project;
            obj.hFarfieldSource = hProject.invoke('FarfieldSource');
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
            % Resets the object.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Name(obj, name)
            % Sets the name of the farfield source.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Id(obj, id)
            % Sets a unique identifier for the imported farfield source data. Therefore farfield sources pointing to the same imported data (e.g. created via transform and copy) share the same id. Please use GetNextId to retrieve a free id.
            obj.AddToHistory(['.Id "', num2str(id, '%.15g'), '"']);
        end
        function SetPosition(obj, x, y, z)
            % Specifies the position for the point source.
            obj.AddToHistory(['.SetPosition "', num2str(x, '%.15g'), '", '...
                                           '"', num2str(y, '%.15g'), '", '...
                                           '"', num2str(z, '%.15g'), '"']);
        end
        function SetPhi0XYZ(obj, x, y, z)
            % Set new origin vectors in global cartesian coordinates for the x'-axis and z'axis. The x'axis defines the new start of the angle phi, the z'-axis defines the new start of the angle theta. Therefore SetPhi0 is used to set the new x'-axis, SetTheta0 to set the new z'-axis. The resulting vectors will be normalized to 1. The x'-axis will be orthogonalized to the z'-axis. Please make sure that the axes are not parallel and that the vectors do not have zero length. The y'-axis will be determined automatically.
            % Please note: x, y, and z must be double values here. Any expression is not allowed.
            obj.AddToHistory(['.SetPhi0XYZ "', num2str(x, '%.15g'), '", '...
                                          '"', num2str(y, '%.15g'), '", '...
                                          '"', num2str(z, '%.15g'), '"']);
        end
        function SetTheta0XYZ(obj, x, y, z)
            % Set new origin vectors in global cartesian coordinates for the x'-axis and z'axis. The x'axis defines the new start of the angle phi, the z'-axis defines the new start of the angle theta. Therefore SetPhi0 is used to set the new x'-axis, SetTheta0 to set the new z'-axis. The resulting vectors will be normalized to 1. The x'-axis will be orthogonalized to the z'-axis. Please make sure that the axes are not parallel and that the vectors do not have zero length. The y'-axis will be determined automatically.
            % Please note: x, y, and z must be double values here. Any expression is not allowed.
            obj.AddToHistory(['.SetTheta0XYZ "', num2str(x, '%.15g'), '", '...
                                            '"', num2str(y, '%.15g'), '", '...
                                            '"', num2str(z, '%.15g'), '"']);
        end
        function Import(obj, name)
            % name specifies the source file and path.
            % Note: The import is currently only available for files containing version and frequency information. Please see below for an example import file. Files can be created by the FarfieldPlot Object-method ASCIIExportAsSource(...) from any MWS farfield calculation.
            obj.AddToHistory(['.Import "', num2str(name, '%.15g'), '"']);
        end
        function UseCopyOnly(obj, flag)
            % The farfield source file is copied once into the project folder. Hence changes of the originally imported file do not affect the defined farfield source.
            obj.AddToHistory(['.UseCopyOnly "', num2str(flag, '%.15g'), '"']);
        end
        function UseMultipoleFFS(obj, flag)
            % This option enables the calculation of the multiple coefficients for the farfield source. For the simulation the farfield representation by the multipole coefficients will be used. It is recommended to use this option if the farfield source is positioned relatively close to the defined structure.
            obj.AddToHistory(['.UseMultipoleFFS "', num2str(flag, '%.15g'), '"']);
        end
        function SetAlignmentType(obj, type)
            % Specifies the alignment and positioning of the farfield source. The following types are available:
            % "user"          The farfield source position and orientation are defined via SetPosition, SetPhi0 and SetTheta0.
            % "currentwcs"    The farfield source is aligned with the current wcs at the time of the source definition.
            % "sourcefile"    The farfield source position and orientation are read from the specified source file.
            obj.AddToHistory(['.SetAlignmentType "', num2str(type, '%.15g'), '"']);
        end
        function SetMultipoleDegree(obj, degree)
            % Sets a user defined degree of the multipole expansion to guide the calculation. Its effect depends on the specified calculation mode.
            obj.AddToHistory(['.SetMultipoleDegree "', num2str(degree, '%.15g'), '"']);
        end
        function SetMultipoleCalcMode(obj, mode)
            % Defines the strategy used to determine the maximal degree of the multipole expansion. Three modes are available:
            % "automatic"         The maximal degree is automatically derived from the estimated discretization error of the farfield.
            % "user defined"      The value set by SetMultipoleDegree is used.
            % "autotruncation"    The value set by SetMultipoleDegree is used as a starting value to guide the automatic calculation.
            obj.AddToHistory(['.SetMultipoleCalcMode "', num2str(mode, '%.15g'), '"']);
        end
        function Store(obj)
            % Activates the import, which has to be previously specified using the described methods.
            obj.AddToHistory(['.Store']);

            % Prepend With FarfieldSource and append End With
            obj.history = [ 'With FarfieldSource', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define FarfieldSource: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj)
            % Deletes the farfield source specified by Name
            obj.project.AddToHistory(['FarfieldSource.Delete']);
        end
        function DeleteAll(obj)
            % Removes all farfield sources
            obj.project.AddToHistory(['FarfieldSource.DeleteAll']);
        end
        function integer = GetNextId(obj)
            % Returns the next free unique ID to for a new farfield source.
            integer = obj.hFarfieldSource.invoke('GetNextId');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hFarfieldSource
        history

        name
    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% Example for using the VBA object:
% % Define a FarfieldSource
% farfieldsource = project.FarfieldSource();
% .Reset
% .Name('ffs1');
% .Id('1');
% .UseCopyOnly('true');
% .Setposition('1.',('1.',('1.');
% .SetTheta0('0.',('0.',('1.');
% .SetPhi0('1.',('0.',('0.');
% .Import('example.txt');
% .UseMultipoleFFS('false');
% .SetAlignmentType('user');
% .SetMultipoleDegree('10');
% .SetMultipoleCalcMode('automatic');
% .Store
%
