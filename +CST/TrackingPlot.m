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

% This object offers access and manipulation functions to the trajectory plot.
classdef TrackingPlot < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TrackingPlot object.
        function obj = TrackingPlot(project, hProject)
            obj.project = project;
            obj.hTrackingPlot = hProject.invoke('TrackingPlot');
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets the tracking plot object.
            obj.hTrackingPlot.invoke('Reset');
        end
        function bool = SelectPlot(obj, sTrajectoryName)
            % Loads the selected trajectories' datafile.
            bool = obj.hTrackingPlot.invoke('SelectPlot', sTrajectoryName);
        end
        function long = GetNParticles(obj)
            % Returns the number of displayed particles i.e. trajectory paths.
            long = obj.hTrackingPlot.invoke('GetNParticles');
        end
        function long = GetNTimeSteps(obj)
            % Returns the number of displayed timesteps.
            long = obj.hTrackingPlot.invoke('GetNTimeSteps');
        end
        function double = GetTime(obj)
            % Returns the actual time of the displayed plot.
            double = obj.hTrackingPlot.invoke('GetTime');
        end
        %% Particle Queries
        function bool = SelectParticle(obj, index)
            % Selects a specific particle for the subsequent queries. The parameter index should be between 0 and GetNParticles()-1.
            bool = obj.hTrackingPlot.invoke('SelectParticle', index);
        end
        function double = GetCharge(obj)
            % Returns the macro charge of the selected particle at the selected time index. Please note that due to sheet transitions, the particles' macro charge can vary with time.
            double = obj.hTrackingPlot.invoke('GetCharge');
        end
        function double = GetMass(obj)
            % Returns the mass of the selected particle at the selected time index.
            double = obj.hTrackingPlot.invoke('GetMass');
        end
        function long = GetNParticleTimes(obj)
            % Returns the number of timesteps of the selected particle at the selected time index.
            long = obj.hTrackingPlot.invoke('GetNParticleTimes');
        end
        function bool = SelectParticleTimeIndex(obj, index)
            % Selects time index for the currently selected particle. The parameter index should be between 0 and GetNParticleTimes()-1.
            bool = obj.hTrackingPlot.invoke('SelectParticleTimeIndex', index);
        end
        function bool = SelectParticleTime(obj, time)
            % Select particle at the given time.
            bool = obj.hTrackingPlot.invoke('SelectParticleTime', time);
        end
        function double = GetParticleTime(obj)
            % Returns the particle time of the selected particle at the selected time index.
            double = obj.hTrackingPlot.invoke('GetParticleTime');
        end
        function double = GetTimeStep(obj)
            % Returns the particle timestep of the selected particle at the selected time index.
            double = obj.hTrackingPlot.invoke('GetTimeStep');
        end
        function [xpos, ypos, zpos] = GetPosition(obj)
            % Returns the position of the selected particle at the selected time index.
            functionString = [...
                'Dim xpos As Double, ypos As Double, zpos As Double', newline, ...
                'TrackingPlot.GetPosition(xpos, ypos, zpos)', newline, ...
            ];
            returnvalues = {'xpos', 'ypos', 'zpos'};
            [xpos, ypos, zpos] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            xpos = str2double(xpos);
            ypos = str2double(ypos);
            zpos = str2double(zpos);
        end
        function [ximp, yimp, zimp] = GetMomentum(obj)
            % Returns the impulse of the selected particle at the selected time index.
            functionString = [...
                'Dim ximp As Double, yimp As Double, zimp As Double', newline, ...
                'TrackingPlot.GetMomentum(ximp, yimp, zimp)', newline, ...
            ];
            returnvalues = {'ximp', 'yimp', 'zimp'};
            [ximp, yimp, zimp] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            ximp = str2double(ximp);
            yimp = str2double(yimp);
            zimp = str2double(zimp);
        end
        %% Deprecated Methods
        % Starting from CST STUDIO SUITE 2017, the following methods are deprecated. While they still operate on trajectories generated with older versions, they are not working on newer data. The functions are still listed here for reference and to support converting older macros. They should not be used in new projects.
        function Draw(obj)
            % Draws the selected trajectory file.
            obj.hTrackingPlot.invoke('Draw');
        end
        function VisualizeAlive(obj, flag)
            % If set to true only alive trajectory paths are visualized.
            obj.hTrackingPlot.invoke('VisualizeAlive', flag);
        end
        function SetParticleSampling(obj, samplingrate)
            % Defines the particle sampling rate of the plot. The value is given in %.
            obj.hTrackingPlot.invoke('SetParticleSampling', samplingrate);
        end
        function SetTemporalSampling(obj, samplingrate)
            % Defines the temporal sampling rate of the plot. The value is given in %.
            obj.hTrackingPlot.invoke('SetTemporalSampling', samplingrate);
        end
        function SetPlotType(obj, plottype)
            % Defines the coloring type of the trajectory-paths.
            % Plot-Type   Meaning
            % "velocity"  colors the path in respect to the particle's velocity.
            % "momentum"  colors the path in respect to the particle's momentum
            % "gamma"     colors the path in respect to the particle's gamma
            % "beta"      colors the path in respect to the particle's beta
            % "energy"    colors the path in respect to the particle's voltage.
            obj.hTrackingPlot.invoke('SetPlotType', plottype);
        end
        function SetTime(obj, time)
            % Sets the time at which the particle's trajectory is displayed.
            obj.hTrackingPlot.invoke('SetTime', time);
        end
        function SetTimeIndex(obj, index)
            % Sets the time index at which the particle's trajectory is displayed.
            obj.hTrackingPlot.invoke('SetTimeIndex', index);
        end
        function ASCIIExport(obj, filename)
            % Exports the trajectory data to an ASCII file with the given filename.
            % As a replacement, please use the ASCIIExport object (see also example below).
            obj.hTrackingPlot.invoke('ASCIIExport', filename);
        end
        function BitmapExport(obj, filename)
            % Exports the trajectory plot as a bitmap with the given filename.
            % As a replacement, please use the respective function of the Plot object (see also example below).
            obj.hTrackingPlot.invoke('BitmapExport', filename);
        end
        function SetPlotMin(obj, value)
            % Defines the minimal displayed value in the trajectory plot
            obj.hTrackingPlot.invoke('SetPlotMin', value);
        end
        function SetPlotMax(obj, value)
            % Defines the maximal displayed value in the trajectory plot
            obj.hTrackingPlot.invoke('SetPlotMax', value);
        end
        function SetScaleToRange(obj, flag)
            % If set to true the coloring of the trajectory is bounded by the PlotMin/PlotMax values.
            obj.hTrackingPlot.invoke('SetScaleToRange', flag);
        end
        function double = GetMinRampValue(obj)
            % Returns the minimal displayed value.
            double = obj.hTrackingPlot.invoke('GetMinRampValue');
        end
        function double = GetMaxRampValue(obj)
            % Returns the maximal displayed value.
            double = obj.hTrackingPlot.invoke('GetMaxRampValue');
        end
        function [xval, yval, zval] = GetEField(obj)
            % Returns the electric field vector at the position of the selected particle at the selected time index.
            functionString = [...
                'Dim xval As Double, yval As Double, zval As Double', newline, ...
                'TrackingPlot.GetEField(xval, yval, zval)', newline, ...
            ];
            returnvalues = {'xval', 'yval', 'zval'};
            [xval, yval, zval] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            xval = str2double(xval);
            yval = str2double(yval);
            zval = str2double(zval);
        end
        function [xval, yval, zval] = GetBField(obj)
            % Returns the magnetic field vector at the position of the selected particle at the selected time index
            functionString = [...
                'Dim xval As Double, yval As Double, zval As Double', newline, ...
                'TrackingPlot.GetBField(xval, yval, zval)', newline, ...
            ];
            returnvalues = {'xval', 'yval', 'zval'};
            [xval, yval, zval] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            xval = str2double(xval);
            yval = str2double(yval);
            zval = str2double(zval);
        end
        function double = GetArea(obj)
            % Returns the area of the selected particle at the selected time index.
            double = obj.hTrackingPlot.invoke('GetArea');
        end
        function Create(obj, filename, nparticles, ntimesteps)
            % Creates a new trajectory plot with the given number of particles (nparticles) and each particle with the given number of timesteps (ntimesteps).
            obj.hTrackingPlot.invoke('Create', filename, nparticles, ntimesteps);
        end
        function SetParticleTime(time)
            % Sets the time of the selected particle at the selected time index.
            obj.hTrackingPlot.invoke('SetParticleTime', time);
        end
        function SetParticleData(charge, mass, area)
            % Sets the characteristic data of the selected particle (mass, charge, area).
            obj.hTrackingPlot.invoke('SetParticleData', charge, mass, area);
        end
        function SetPosition(obj, xpos, ypos, zpos)
            % Sets the position of the selected particle at the selected time index.
            obj.hTrackingPlot.invoke('SetPosition', xpos, ypos, zpos);
        end
        function SetMomentum(obj, ximp, yimp, zimp)
            % Sets the impulse vector of the selected particle at the selected time index.
            obj.hTrackingPlot.invoke('SetMomentum', ximp, yimp, zimp);
        end
        function bool = Save(obj)
            % Saves the constructed trajectory to file.
            bool = obj.hTrackingPlot.invoke('Save');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTrackingPlot

    end
end

%% Default Settings

%% Example - Taken from CST documentation and translated to MATLAB.
% The following testprogram shows the application of the query commands, ASCII export and Bitmap export.
% 
% % Query data from the trajectories
% trackingplot = project.TrackingPlot();
% trackingplot.Reset();
% % Select the trajectory data for particle source('particle1');
% if(trackingplot.SelectPlot('particle1'))
%     % Number of all particles
%     itest = trackingplot.GetNParticles();
%     % Number of stored timesteps
%     itest = trackingplot.GetNTimeSteps();
%     % Get time of timestep 20
%     dtest = trackingplot.GetTime(20);
% 
%     % Select particle with index 14 and query some information about it
%     if(trackingplot.SelectParticle(14))
%         % Get number of timesteps
%         itest = trackingplot.GetNParticleTimes();
% 
%         % Select timeindex 157 of the selected particle
%         if(trackingplot.SelectParticleTimeIndex(157))
%             % Get mass
%             dtest = trackingplot.GetMass();
%             % Get charge
%             dtest = trackingplot.GetCharge();
%             % Get time of timeindex 157
%             dtest = trackingplot.GetParticleTime();
%             % Get timestep of timeindex 157
%             dtest = trackingplot.GetTimeStep();
%             % Get position and momentum
%             [ucomp, vcomp, wcomp] = trackingplot.GetPosition();
%             [ucomp, vcomp, wcomp] = trackingplot.GetMomentum();
%         end
%     end
% end
% 
% % Export all trajectory data to an ASCII file in the same directory as the .cst file
% project.SelectTreeItem('2D/3D Results\Trajectories');
% asciiexport = project.ASCIIExport();
% asciiexport.Reset();
% asciiexport.FileName([project.GetProjectPath('Root'), '\trajectories.txt']);
% asciiexport.Execute();
% 
% % Export trajectory picture to a bitmap file in the same directory as the .cst file and resolution 1024x768
% project.SelectTreeItem('2D/3D Results\Trajectories');
% plot = project.Plot();
% plot.StoreBMPHighResolution([project.GetProjectPath('Root'), '\trajectories.bmp'], 1024, 768);
