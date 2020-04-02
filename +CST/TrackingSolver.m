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

% The Object is used to define the Tracking Solver parameters.
classdef TrackingSolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TrackingSolver object.
        function obj = TrackingSolver(project, hProject)
            obj.project = project;
            obj.hTrackingSolver = hProject.invoke('TrackingSolver');
            obj.history = [];
            obj.bulkmode = 0;
        end
    end
    methods
        function StartBulkMode(obj)
            % Buffers all commands instead of sending them to CST
            % immediately.
            obj.bulkmode = 1;
        end
        function EndBulkMode(obj)
            % Flushes all commands since StartBulkMode to CST.
            obj.bulkmode = 0;
            % Prepend With TrackingSolver and append End With
            obj.history = [ 'With TrackingSolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define TrackingSolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['TrackingSolver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function MaxTimeSteps(obj, timesteps)
            % Sets the maximal number of time steps for the tracking solver. The solver stops calculating the electrons'  trajectories when the last particle leaves the calculation domain or the maximal number of time steps is reached.
            obj.AddToHistory(['.MaxTimeSteps "', num2str(timesteps, '%.15g'), '"']);
        end
        function SetSpatialSamplingRate(obj, spatialsampling)
            % Defines the number of steps the fastest particle has to stay at least within the smallest mesh cell.
            obj.AddToHistory(['.SetSpatialSamplingRate "', num2str(spatialsampling, '%.15g'), '"']);
        end
        function SetTemporalSamplingRate(obj, temporalsampling)
            % Defines the rate at which the data are sampled over time. If  it is set to "1", the data for every time step is recorded. If it is set to "2", only every second time step is recorded, etc..
            obj.AddToHistory(['.SetTemporalSamplingRate "', num2str(temporalsampling, '%.15g'), '"']);
        end
        function SetParticleSamplingRate(obj, particlesampling)
            % Defines the rate  at which the data are sampled over particles.  If it is set to "1", the data for every particle is recorded. If it is set to "2", only every second particle is recorded, etc..
            obj.AddToHistory(['.SetParticleSamplingRate "', num2str(particlesampling, '%.15g'), '"']);
        end
        function SetTemporalReorganizingRate(obj, temporalreorganizing)
            % It is possible to change the temporal sampling rate value after the tracking solver has finished the calculation. The time-based data format (saved in the .ttl file, if "TrackToFile" is activated) is converted into a particle-based format, saved in the .trk file. During this reorganization, (which can be recomputed if the .ttl file is present) an additional downsampling of the time steps can be performed.
            obj.AddToHistory(['.SetTemporalReorganizingRate "', num2str(temporalreorganizing, '%.15g'), '"']);
        end
        function SetParticlelReorganizingRate(obj, particlereorganizing)
            % It is possible to change the particle sampling rate value after the tracking solver has finished the calculation. The time-based data format (saved in the .ttl file, if "TrackToFile" is activated) is also converted into a  particle-based format, saved in the .trk file. During this reorganization, (which can be recomputed if the .ttl file is present) an additional downsampling of the particles can be performed.
            obj.AddToHistory(['.SetParticlelReorganizingRate "', num2str(particlereorganizing, '%.15g'), '"']);
        end
        function SetReorganize(obj, PEC)
            % Starts the tracking solver in the reorganizing mode, i.e. an existing ttl-file is reorganized to a trk-file with the spatial and temporal sampling rate defined by the macro commands "SetTemporalReorganizingRate" and "SetTemporalReorganizingRate".
            obj.AddToHistory(['.SetReorganize "', num2str(PEC, '%.15g'), '"']);
        end
        function TrackToFile(obj, tracktofile)
            % Activates the recording of the particle data to a ttl-file instead of saving it to memory during the particle tracking process.  Activating this option slows down slightly the tracking, but prevents problems due to memory  limitations.
            obj.AddToHistory(['.TrackToFile "', num2str(tracktofile, '%.15g'), '"']);
        end
        function SetTemporalDynamic(obj, dynamic)
            % Sets the dynamic of the adaptive temporal discretization, i.e. the maximal increase or decrease of the time step size. Consider two successive time steps: a value of "2" means that the second time step size can at most twice the first time step. A value of "1" ensures an equidistant time step size.
            obj.AddToHistory(['.SetTemporalDynamic "', num2str(dynamic, '%.15g'), '"']);
        end
        function ConsiderSpaceCharge(obj, spacecharge)
            % When activated, the particle current and space charge are stored. If the gun-iteration is activated this setting is enabled by default and cannot be disabled.
            obj.AddToHistory(['.ConsiderSpaceCharge "', num2str(spacecharge, '%.15g'), '"']);
        end
        function SetGunIteration(obj, spacecharge)
            % Activates the gun-iteration solver. When this setting is deactivated, the particles have no effect on the electrostatic field. When this setting is activated, the gun-solver takes into account the effect of the particle space charge on the electrostatic field and calculates iteratively both the particle trajectories and the electrostatic field.
            obj.AddToHistory(['.SetGunIteration "', num2str(spacecharge, '%.15g'), '"']);
        end
        function SetGunIterationMaxN(obj, iteration)
            % Sets the maximal number of iterations of the gun-solver.
            obj.AddToHistory(['.SetGunIterationMaxN "', num2str(iteration, '%.15g'), '"']);
        end
        function SetGunIterationAccuracy(obj, accuracy)
            % Sets the termination condition of the GUN-Solver. The solver finishes its calculation when the relative difference of the computed space charge between two consecutive iteration steps is less than accuracy. Possible values are "-10 dB", "-20 dB", "-30 dB",... , "-120 dB". When accuracy is set to  "No Check", the solver will stop when the maximum number of GUN iterations is reached.
            % For example, when "-20 dB" is entered, the solver stops when the relative difference is less than 0.1. It is also possible to enter a double value for the relative difference, such as "0.1".
            obj.AddToHistory(['.SetGunIterationAccuracy "', num2str(accuracy, '%.15g'), '"']);
        end
        function SetGunIterationRelaxation(obj, relaxation)
            % Defines the weighting factor for the update of the global space charge vector with the resulting space charge of the last tracking process. A factor of "1" results in a space charge which is directly influenced by the last tracking result, a value of "0.1" results in an only 10% modification of the global space charge vector by the last computed space charge.
            obj.AddToHistory(['.SetGunIterationRelaxation "', num2str(relaxation, '%.15g'), '"']);
        end
        function AddStaticsField(obj, fieldtype, factor, recalculate)
            % Adds a static field of type fieldtype, scaled by factor that will influence the particles' trajectories. If recalculate is set to true, the fields will be recalculated before the tracking solver starts.
            % Note that a factor of "0" leaves the field unconsidered for the tracking process.
            % enum fieldtype  meaning
            % "E-Static"      Electrostatic field.
            % "M-Static"      Magnetostatic field.
            obj.AddToHistory(['.AddStaticsField "', num2str(fieldtype, '%.15g'), '", '...
                                               '"', num2str(factor, '%.15g'), '", '...
                                               '"', num2str(recalculate, '%.15g'), '"']);
        end
        function AddModeField(obj, fieldtype, modenumber, factor, frequency, phase, recalculate)
            % Defines an eigenmode fieldtype, which is determined by its modenumber (the fieldtype should be "Eigenmode").
            % In addition this methods specifies the weighting factor with which the particles' trajectory is influenced by the field, the frequency, the phase of the electric field at the beginning of the simulation and the option to recalculate the field.
            % Note that a factor of "0" leaves the field unconsidered for the tracking process.
            % enum fieldtype  meaning
            % "Eigenmode"     Eigenmode field.
            obj.AddToHistory(['.AddModeField "', num2str(fieldtype, '%.15g'), '", '...
                                            '"', num2str(modenumber, '%.15g'), '", '...
                                            '"', num2str(factor, '%.15g'), '", '...
                                            '"', num2str(frequency, '%.15g'), '", '...
                                            '"', num2str(phase, '%.15g'), '", '...
                                            '"', num2str(recalculate, '%.15g'), '"']);
        end
        function AddTrackingSource(obj, type, name)
            % Defines the particle sources that are included in the solver calculations. The argument type defines the source type and can be "all sources", "particle" or "interface". When type = "all sources", the argument name defines the particular particle source or interface that is included in the solver calculations (e.g., "particle1").
            obj.AddToHistory(['.AddTrackingSource "', num2str(type, '%.15g'), '", '...
                                                 '"', num2str(name, '%.15g'), '"']);
        end
        function StoreResultsInDataCache(obj, flag)
            % Activate or deactivate the storage of the results in the data cache.
            obj.AddToHistory(['.StoreResultsInDataCache "', num2str(flag, '%.15g'), '"']);
        end
        function DefaultBoundaryEstatic(obj, boundarytype)
            % When periodic boundaries are selected for the eigenmode solver setup, the electrostatic solver must use different boundary settings: here, this method sets these different settings for the electrostatic solver.
            % enum boundarytype   meaning
            % "electric"          Electric tangential and magnetic normal field is set to zero.
            % "magnetic"          Electric normal and magnetic tangential field is set to zero.
            % "normal"            Electric and magnetic normal field is set to zero.
            % "tangential"        Electric and magnetic tangential field is set to zero.
            % "open"              Open boundary condition
            % "expanded open"     Open boundary condition (and extra space is added to the computational domain)
            % "periodic"          invalid
            % "none"              invalid
            % "conducting wall"   invalid
            % "unit cell"         invalid
            obj.AddToHistory(['.DefaultBoundaryEstatic "', num2str(boundarytype, '%.15g'), '"']);
        end
        function DefaultBoundaryMstatic(obj, boundarytype)
            % When periodic boundaries are selected for the eigenmode solver setup, the magnetostatic solver must use different boundary settings: here, this method sets these different settings for the magnetostatic solver.
            % enum boundarytype   meaning
            % "electric"          Electric tangential and magnetic normal field is set to zero.
            % "magnetic"          Electric normal and magnetic tangential field is set to zero.
            % "normal"            Electric and magnetic normal field is set to zero.
            % "tangential"        Electric and magnetic tangential field is set to zero.
            % "open"              Open boundary condition
            % "expanded open"     Open boundary condition (and extra space is added to the computational domain)
            % "periodic"          invalid
            % "none"              invalid
            % "conducting wall"   invalid
            % "unit cell"         invalid
            obj.AddToHistory(['.DefaultBoundaryMstatic "', num2str(boundarytype, '%.15g'), '"']);
        end
        function DefaultBoundaryEigenmode(obj, boundarytype)
            % When open boundary conditions are selected for the setup of the electro- and magnetostatic solvers, the eigenmode solver must use different boundary settings: here, this method sets these different settings for the eigenmode solver.
            % enum boundarytype   meaning
            % "electric"          Electric tangential and magnetic normal field is set to zero.
            % "magnetic"          Electric normal and magnetic tangential field is set to zero.
            % "normal"            invalid
            % "tangential"        invalid
            % "open"              Open boundary condition
            % "expanded open"     Open boundary condition (and extra space is added to the computational domain)
            % "periodic"          Periodic boundary condition.
            % "none"              invalid
            % "conducting wall"   invalid
            % "unit cell"         Unit cell boundary condition.
            obj.AddToHistory(['.DefaultBoundaryEigenmode "', num2str(boundarytype, '%.15g'), '"']);
        end
        function SEEDeterministicRandom(obj, flag)
            % Enables or disables a nondeterministic random number generation process for the secondary electron generation. The default is set to deterministic, that means true.
            obj.AddToHistory(['.SEEDeterministicRandom "', num2str(flag, '%.15g'), '"']);
        end
        function long = Start(obj)
            % Starts the tracking solver. Returns 0 if the solver run was successful, an error code >0 otherwise.
            long = obj.hTrackingSolver.invoke('Start');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTrackingSolver
        history
        bulkmode

    end
end

%% Default Settings
% SetReorganize('0');
% MaxTimeSteps('10000');
% SetSpatialSamplingRate('5');
% SetTemporalSamplingRate('1');
% SetParticleSamplingRate('1');
% TrackToFile('0');
% SetTemporalDynamic('1.2');
% ConsiderSpacecharge('1');
% SetGunIteration('0');
% SetGunIterationMaxN('50');
% SetGunIterationAccuracy('1e-3');
% SetGunIterationRelaxation('0.35');
% AddTrackingSource('All sources', '');
% AddStaticsField('E-Static', 1.0, TRUE
% AddModeField('Eigenmode', 1, 1.0, 0.0, 0, TRUE
% DefaultBoundaryEstatic('normal');
% DefaultBoundaryMstatic('tangential');
% DefaultBoundaryEigenmode('electric');
% DefaultBoundaryTimedomain('electric');

%% Example - Taken from CST documentation and translated to MATLAB.
% trackingsolver = project.TrackingSolver();
% .Reset
% .SetReorganize('0');
% .MaxTimeSteps('10000');
% .SetSpatialSamplingRate('5');
% .SetTemporalSamplingRate('1');
% .SetParticleSamplingRate('1');
% .TrackToFile('0');
% .SetTemporalDynamic('1.2');
% .ConsiderSpacecharge('1');
% .SetGunIteration('0');
% .SetGunIterationMaxN('50');
% .SetGunIterationAccuracy('1e-3');
% .SetGunIterationRelaxation('0.35');
% .AddParticleSource('All sources');
% .AddField('E-Static', '1.0', '0.0', '0');
% 
% 
