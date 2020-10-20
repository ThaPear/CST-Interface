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

% This Object is used to define a particle beam source for the wakefield-solver.
classdef ParticleBeam < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ParticleBeam object.
        function obj = ParticleBeam(project, hProject)
            obj.project = project;
            obj.hParticleBeam = hProject.invoke('ParticleBeam');
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
        function Delete(obj, name)
            % Deletes the specified particle-beam source.
            obj.project.AddToHistory(['ParticleBeam.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the specified particle-beam.
            obj.project.AddToHistory(['ParticleBeam.Rename "', num2str(oldname, '%.15g'), '", '...
                                      '"', num2str(newname, '%.15g'), '"']);
        end
        function Name(obj, name)
            % Sets the name of the new particle-beam source.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function IsBunchGaussian(obj, flag)
            % Sets the beam shape to a gaussian excitation.
            obj.AddToHistory(['.IsBunchGaussian "', num2str(flag, '%.15g'), '"']);
        end
        function ExcitationSignal(obj, name)
            % Sets the name of the excitation signal, which should be of type ASCII-import or User-defined.
            obj.AddToHistory(['.ExcitationSignal "', num2str(name, '%.15g'), '"']);
        end
        function Length(obj, value)
            % Sets the standard deviation (sigma) of the Gaussian shaped particle bunch.
            obj.AddToHistory(['.Length "', num2str(value, '%.15g'), '"']);
        end
        function Beta(obj, value)
            % Sets the velocity of the particle bunch.
            obj.AddToHistory(['.Beta "', num2str(value, '%.15g'), '"']);
        end
        function Charge(obj, value)
            % Sets  the total charge of the particle bunch
            obj.AddToHistory(['.Charge "', num2str(value, '%.15g'), '"']);
        end
        function ConsiderForMeshRefinement(obj, flag)
            % Determines if the bunch settings should affect the mesh generation or not. It is strongly recommended to set this value to "True".
            obj.AddToHistory(['.ConsiderForMeshRefinement "', num2str(flag, '%.15g'), '"']);
        end
        function LinesPerSigma(obj, flag, lines)
            % Allows to specify a longitudinal mesh refinement for particle beams. In case numerical dispersion plays an important role it is possible to refine the mesh with this setting only in direction of beam propagation.
            obj.AddToHistory(['.LinesPerSigma "', num2str(flag, '%.15g'), '", '...
                                             '"', num2str(lines, '%.15g'), '"']);
        end
        function BeamPoint(obj, pickpoint, xcoord, ycoord, zcoord)
            % Define one point on the beam axis by choosing the last pickpoint (set pickpoint to "True") or by defining the coordinates numerically.
            obj.AddToHistory(['.BeamPoint "', num2str(pickpoint, '%.15g'), '", '...
                                         '"', num2str(xcoord, '%.15g'), '", '...
                                         '"', num2str(ycoord, '%.15g'), '", '...
                                         '"', num2str(zcoord, '%.15g'), '"']);
        end
        function BeamDir(obj, xdir, ydir, zdir)
            % Define the beam axis direction numerically. The beam axis must be parallel to a main coordinate axis x,y or z.
            obj.AddToHistory(['.BeamDir "', num2str(xdir, '%.15g'), '", '...
                                       '"', num2str(ydir, '%.15g'), '", '...
                                       '"', num2str(zdir, '%.15g'), '"']);
        end
        function IndirectWakeIntegration(obj, flag)
            % Determines if the indirect integration should be used (more accurate) or not. If it is not possible to compute wakepotentials with the indirect method, the direct integration will be used.
            obj.AddToHistory(['.IndirectWakeIntegration "', num2str(flag, '%.15g'), '"']);
        end
        function WakeIntegrationShift(obj, xshift, yshift, zshift)
            % The wake integration axis, where the wake potential is calculated can be shifted to the particle beam axis, in order to compute wakefields for particles which are "off-axis". Ony two of three values are taken into account, since the wake-axis is shifted only transversal.
            obj.AddToHistory(['.WakeIntegrationShift "', num2str(xshift, '%.15g'), '", '...
                                                    '"', num2str(yshift, '%.15g'), '", '...
                                                    '"', num2str(zshift, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the source with the previously made settings.
            obj.AddToHistory(['.Create']);

            % Prepend With ParticleBeam and append End With
            obj.history = [ 'With ParticleBeam', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ParticleBeam: ', obj.name], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hParticleBeam
        history

        name
    end
end

%% Default Settings
% Length('0.0');
% Beta('0.0');
% Charge('0.0');
% ConsiderForMeshRefinement('1');
% BeamPoint('0', '0.0', '0.0', '0.0');
% BeamDir('0.0', '0.0', '0.0');
% IndirectWakeIntegration('1');
% WakeIntegrationShift('0.0', '0.0', '0.0');

%% Example - Taken from CST documentation and translated to MATLAB.
% particlebeam = project.ParticleBeam();
%     particlebeam.Reset
%     particlebeam.Name('ParticleBeam1');
%     particlebeam.Length('1');
%     particlebeam.Beta('1.0');
%     particlebeam.Charge('1e-12');
%     particlebeam.ConsiderForMeshRefinement('1');
%     particlebeam.BeamPoint('1', '2.4', '-1.2', '3.2');
%     particlebeam.BeamDir('0.0', '0.0', '1.0');
%     particlebeam.IndirectWakeIntegration('0');
%     particlebeam.WakeIntegrationShift('0.0', '0.0', '0.0');
%     particlebeam.Create
%
