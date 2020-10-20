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

% This Object is used to create a new particle interface for the tracking- or the PIC-solver.
classdef ParticleInterface < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ParticleInterface object.
        function obj = ParticleInterface(project, hProject)
            obj.project = project;
            obj.hParticleInterface = hProject.invoke('ParticleInterface');
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

            obj.name = [];
        end
        function Name(obj, name)
            % Sets the name of the particle interface.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Type(obj, typename)
            % Type of the particle interface.
            % enum typename       meaning
            % "Export"            Particle interface to export particle data to other projects.
            % "Import"            Particle interface to import particle data from other projects.
            % "Import ASCII DC"   Particle interface to import an ascii file (particle emission data).
            % "Import ASCII TD"   Particle interface to import an ascii file (particle emission data).
            obj.AddToHistory(['.Type "', num2str(typename, '%.15g'), '"']);
        end
        function Delete(obj, name)
            % Deletes the specified particle interface.
            obj.project.AddToHistory(['ParticleInterface.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the particle interface.
            obj.project.AddToHistory(['ParticleInterface.Rename "', num2str(oldname, '%.15g'), '", '...
                                                               '"', num2str(newname, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the particle interface.
            obj.AddToHistory(['.Create']);

            % Prepend With ParticleInterface and append End With
            obj.history = [ 'With ParticleInterface', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ParticleInterface: ', obj.name], obj.history);
            obj.history = [];
        end
        %% Export Methods
        function ExportParticleInterfaces(obj)
            % Export particle interface data to file.
            obj.AddToHistory(['.ExportParticleInterfaces']);
        end
        function Dir(obj, dir)
            % The particle interface is defined on a plane.
            % This method defines the plane normal of the particle interface.
            % The values for dir can be: "X", "Y" or "Z".
            % When the plane normal is defined in the w-direction of the local uvw-coordinate system, so that the uv-plane is transverse to the plane normal, the following table applies depending on the choice of dir:
            % dir (w-direction)   u-direction         v-direction
            % X                   Y                   Z
            % Y                   Z                   X
            % Z                   X                   Y
            obj.AddToHistory(['.Dir "', num2str(dir, '%.15g'), '"']);
        end
        function Wcut(obj, wcut)
            % Value of the position of the interface plane along the direction of the specified plane normal (e.g. along the Z-axis when dir = "Z").
            obj.AddToHistory(['.Wcut "', num2str(wcut, '%.15g'), '"']);
        end
        function Umin(obj, umin)
            % Value of the lower transverse u-boundary. The u and v direction are defined by the plane normal (see table above).
            obj.AddToHistory(['.Umin "', num2str(umin, '%.15g'), '"']);
        end
        function Umax(obj, umax)
            % Value of the upper transverse u-boundary. The u and v direction are defined by the plane normal (see table above).
            obj.AddToHistory(['.Umax "', num2str(umax, '%.15g'), '"']);
        end
        function Vmin(obj, vmin)
            % Value of the lower transverse v-boundary. The u and v direction are defined by the plane normal (see table above).
            obj.AddToHistory(['.Vmin "', num2str(vmin, '%.15g'), '"']);
        end
        function Vmax(obj, vmax)
            % Value of the upper transverse v-boundary. The u and v direction are defined by the plane normal (see table above).
            obj.AddToHistory(['.Vmax "', num2str(vmax, '%.15g'), '"']);
        end
        %% Import Methods
        function InterfaceFile(obj, filename)
            % Sets the name of the interface file which has to be imported.
            obj.AddToHistory(['.InterfaceFile "', num2str(filename, '%.15g'), '"']);
        end
        function UseLocalCopyOnly(obj, boolean)
            % Defines if the local copy of the imported interface file should be used for all future simulation runs.
            obj.AddToHistory(['.UseLocalCopyOnly "', num2str(boolean, '%.15g'), '"']);
        end
        function DirNew(obj, dir)
            % This method defines the new plane normal of the imported particle interface.
            % The values for dir can be: "X", "Y" or "Z".
            obj.AddToHistory(['.DirNew "', num2str(dir, '%.15g'), '"']);
        end
        function InvertOrientation(obj, boolean)
            % This settings defines if the starting normal of all particles should be mirrored on the interface plane.
            obj.AddToHistory(['.InvertOrientation "', num2str(boolean, '%.15g'), '"']);
        end
        function XShift(obj, xshift)
            % Translation of the planes center-point along x-direction.
            obj.AddToHistory(['.XShift "', num2str(xshift, '%.15g'), '"']);
        end
        function YShift(obj, yshift)
            % Translation of the planes center-point along y-direction.
            obj.AddToHistory(['.YShift "', num2str(yshift, '%.15g'), '"']);
        end
        function ZShift(obj, zshift)
            % Translation of the planes center-point along z-direction.
            obj.AddToHistory(['.ZShift "', num2str(zshift, '%.15g'), '"']);
        end
        function PICSuppressionLength(obj, length)
            % Defines the distance along the new interface normal, where particles do not react on fields caused by other particles in the PIC simulation.
            obj.AddToHistory(['.PICSuppressionLength "', num2str(length, '%.15g'), '"']);
        end
        function PICEmissionModel(obj, type)
            % Defines the emission model of the particle import interface. Possible emission models are "DC" and "TD".
            obj.AddToHistory(['.PICEmissionModel "', num2str(type, '%.15g'), '"']);
        end
        function PICRiseTimeDC(obj, time)
            % Defines the rise time of the DC emission model for the PIC solver.
            obj.AddToHistory(['.PICRiseTimeDC "', num2str(time, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hParticleInterface
        history

        name
    end
end

%% Default Settings
% Name('');
% Type(Export)
% Dir('X');
% Wcut(0)
% Umin(0)
% Umax(0)
% Vmin(0)
% Vmax(0)
% InterfaceFile('');
% UseLocalCopyOnly(0)
% DirNew('X');
% InvertOrientation(0)
% XShift(0)
% YShift(0)
% ZShift(0)
% PICEmissionModel('DC');
% PICSuppressionLength(0)
% PICRiseTimeDC(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% In the following example, a particle interface is defined to import the particle data from the binary file('particle interface 1.pio');. The binary file has been created using an export interface. The .pio files are located under the('Results'); folder of a given CST STUDIO SUITE project folder.
%
% particleinterface = project.ParticleInterface();
%     particleinterface.Reset
%     particleinterface.Name('particle interface 1');
%     particleinterface.Type('Import');
%     particleinterface.InterfaceFile('C:\Example\PIC-TRK-Interfaces\Result\particle interface 1.pio');
%     particleinterface.UseLocalCopyOnly('0');
%     particleinterface.DirNew('Z');
%     particleinterface.InvertOrientation('0');
%     particleinterface.XShift('0.0');
%     particleinterface.YShift('0.0');
%     particleinterface.ZShift('-66');
%     particleinterface.PICEmissionModel('DC');
%     particleinterface.PICRiseTimeDC('1.0');
%     particleinterface.PICSuppressionLength('0.0');
%     particleinterface.Create
%
