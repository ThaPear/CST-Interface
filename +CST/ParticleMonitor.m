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

% Definition, control and manipulation of particle monitors in the tracking solver.
classdef ParticleMonitor < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ParticleMonitor object.
        function obj = ParticleMonitor(project, hProject)
            obj.project = project;
            obj.hParticleMonitor = hProject.invoke('ParticleMonitor');
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
            % Defines a name for the particle monitor.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function AutoLabel(obj, autolabel)
            % If autolabel=True, a name for the particle monitor is automatically generated.
            obj.AddToHistory(['.AutoLabel "', num2str(autolabel, '%.15g'), '"']);
            obj.name = 'auto-labelled';
        end
        function SourceName(obj, name)
            % Sets the name of the particle source of the emitted particles are monitored. To monitor all particles, name can be set to an empty string, i.e. "".
            obj.AddToHistory(['.SourceName "', num2str(name, '%.15g'), '"']);
        end
        function SourceType(obj, name)
            % Sets the type of the particle sources of which the emitted particles are monitored by the monitor.  The following three types are valid entries: "ParticleSource", "ParticleInterface" and "AllSources". This setting must be in agreement with the SourceName setting.
            obj.AddToHistory(['.SourceType "', num2str(name, '%.15g'), '"']);
        end
        function UsePlane(obj, useplane)
            % If set to True, the monitor is defined on a plane, otherwise it is defined on a face.
            obj.AddToHistory(['.UsePlane "', num2str(useplane, '%.15g'), '"']);
        end
        function PlaneNormal(obj, uNorm, vNorm, wNorm)
            % Defines the normal of the monitoring plane.
            obj.AddToHistory(['.PlaneNormal "', num2str(uNorm, '%.15g'), '", '...
                                           '"', num2str(vNorm, '%.15g'), '", '...
                                           '"', num2str(wNorm, '%.15g'), '"']);
        end
        function PlanePoint(obj, uPos, vPos, wPos)
            % Defines a point on the monitoring plane.
            obj.AddToHistory(['.PlanePoint "', num2str(uPos, '%.15g'), '", '...
                                          '"', num2str(vPos, '%.15g'), '", '...
                                          '"', num2str(wPos, '%.15g'), '"']);
        end
        function PlaneLocalU(obj, uLocU, vLocU, wLocU)
            % Defines the direction of the local u-axis of the plane. Note that the vector has to be parallel to the plane. The vectors Normal, LocalU und LocalV have to represent three axis of an orthogonal cartesian coordinate system.
            obj.AddToHistory(['.PlaneLocalU "', num2str(uLocU, '%.15g'), '", '...
                                           '"', num2str(vLocU, '%.15g'), '", '...
                                           '"', num2str(wLocU, '%.15g'), '"']);
        end
        function PlaneLocalV(obj, uLocV, vLocV, wLocV)
            % Defines the direction of the local v-axis of the plane. Note that the vector has to be parallel to the plane. The vectors Normal, LocalU und LocalV have to represent three axis of an orthogonal cartesian coordinate system.
            obj.AddToHistory(['.PlaneLocalV "', num2str(uLocV, '%.15g'), '", '...
                                           '"', num2str(vLocV, '%.15g'), '", '...
                                           '"', num2str(wLocV, '%.15g'), '"']);
        end
        function FaceNameAndID(obj, facename, faceid)
            % Specifies the solid and the faceid if the plane is defined on a face.
            obj.AddToHistory(['.FaceNameAndID "', num2str(facename, '%.15g'), '", '...
                                             '"', num2str(faceid, '%.15g'), '"']);
        end
        function TemporalBehaviour(obj, behaviour)
            % Temporal behavior of the monitoring process.
            % enum behaviour  meaning
            % "once"          A particle is monitored only the first time it penetrates the monitoring face.
            % "continuous"    A particle is monitored continuously.
            % "timespan"      The monitor is only active during the given time-span.
            obj.AddToHistory(['.TemporalBehaviour "', num2str(behaviour, '%.15g'), '"']);
        end
        function TimeSpan(obj, begintime, endtime)
            % Specifies the time-span for monitoring the particles.
            obj.AddToHistory(['.TimeSpan "', num2str(begintime, '%.15g'), '", '...
                                        '"', num2str(endtime, '%.15g'), '"']);
        end
        function Align(obj, aligntype)
            % Defines the type of plane-alignment of the monitor.
            % enum typename   meaning
            % "GLOBAL"        The monitoring plane is defined with respect to the global coordinate system (GCS).
            % "WCS"           The monitoring plane is defined with respect to the working coordinate system (WCS).
            % "FREE"          The monitoring plane is freely defined.
            obj.AddToHistory(['.Align "', num2str(aligntype, '%.15g'), '"']);
        end
        function PlaneSetting(obj, axisname, position)
            % Direction of the plane's normal with respect to the GCS or WCS. The position describes the plane's location along the specified axis.
            % enum axisname   meaning
            % "x-direction"   Plane's normal is the X/U axis.
            % "y-direction"   Plane's normal is the Y/V axis.
            % "z-direction"   Plane's normal is the Z/W axis.
            obj.AddToHistory(['.PlaneSetting "', num2str(axisname, '%.15g'), '", '...
                                            '"', num2str(position, '%.15g'), '"']);
        end
        function PlotType(obj, plottype)
            % Specifies the type of the generated plot.
            % Note: If a histogram-plot is chosen, the ordinate is automatically set to "probability", i.e. it shows the percentage of particles which correspond to the given abscissa value.
            % enum plottype   meaning
            % "phase-space"   The plot is a 2D-plot (phase-space diagram).
            % "histogram"     The plot is a histogram.
            obj.AddToHistory(['.PlotType "', num2str(plottype, '%.15g'), '"']);
        end
        function DensitySamples(obj, samples)
            % Number of columns for the histogram plot.
            obj.AddToHistory(['.DensitySamples "', num2str(samples, '%.15g'), '"']);
        end
        function AbscissaSetting(obj, type, direction)
            % Definition of the physical quantity which is displayed in the diagram. Note that for the plot-type "histogram" only the abscissa setting is considered.
            obj.AddToHistory(['.AbscissaSetting "', num2str(type, '%.15g'), '", '...
                                               '"', num2str(direction, '%.15g'), '"']);
        end
        function OrdinateSetting(obj, type, direction)
            % Definition of the physical quantity which is displayed in the diagram. Note that for the plot-type "histogram" only the abscissa setting is considered.
            %
            % enum type   meaning
            % "position"  Position of the particles relative to the plane's origin point and local coordinate system.
            % "velocity"  Velocity of the particles relative to the plane's local coordinate system.
            % "angle"     Penetration Angle in local u- and v-direction.
            % "momentum"  Momentum of the particles relative to the plane's local coordinate system.
            % "gamma"     Gamma of the particles relative to the plane's local coordinate system.
            % "beta"      Beta of the particles relative to the plane's local coordinate system.
            % "current"   Current of the particles relative to the plane's local coordinate system.
            % "charge"    Charge of the monitored particles.
            %
            % enum direction  meaning
            % "x-direction"   x-component
            % "y-direction"   y-component
            % "z-direction"   z-component
            % "absolute"      absolute value
            obj.AddToHistory(['.OrdinateSetting "', num2str(type, '%.15g'), '", '...
                                               '"', num2str(direction, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the particle monitor
            obj.AddToHistory(['.Create']);

            % Prepend With ParticleMonitor and append End With
            obj.history = [ 'With ParticleMonitor', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ParticleMonitor: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the specified particle monitor.
            obj.project.AddToHistory(['ParticleMonitor.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldName, newName)
            % Renames the particle monitor.
            obj.project.AddToHistory(['ParticleMonitor.Rename "', num2str(oldName, '%.15g'), '", '...
                                                             '"', num2str(newName, '%.15g'), '"']);
        end
        %% General Queries
        function bool = SelectMonitor(obj, name)
            % Selects the monitor "name" for the following operations.
            bool = obj.hParticleMonitor.invoke('SelectMonitor', name);
        end
        function ClearMonitorData(obj)
            % Delete the data created by SelectMonitor.
            obj.hParticleMonitor.invoke('ClearMonitorData');
        end
        function bool = IsPlane(obj)
            % Is true, if monitor is defined on a plane, false if it is defined on a face.
            bool = obj.hParticleMonitor.invoke('IsPlane');
        end
        function int = GetAlign(obj)
            % Returns the align-type of the monitor (if defined on a plane).
            % enum typename   meaning
            % 0               "GLOBAL"
            % 1               "WCS"
            % 2               "FREE"
            int = obj.hParticleMonitor.invoke('GetAlign');
        end
        function [uNorm, vNorm, wNorm] = GetNormal(obj)
            % Returns the plane's normal (local W-axis)  (if defined on a plane) in global coordinates.
            functionString = [...
                'Dim uNorm As Double, vNorm As Double, wNorm As Double', newline, ...
                'ParticleMonitor.GetNormal(uNorm, vNorm, wNorm)', newline, ...
            ];
            returnvalues = {'uNorm', 'vNorm', 'wNorm'};
            [uNorm, vNorm, wNorm] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            uNorm = str2double(uNorm);
            vNorm = str2double(vNorm);
            wNorm = str2double(wNorm);
        end
        function [uLocU, vLocU, wLocU] = GetLocalU(obj)
            % Returns the plane's local U-axis (if defined on a plane) in global coordinates.
            functionString = [...
                'Dim uLocU As Double, vLocU As Double, wLocU As Double', newline, ...
                'ParticleMonitor.GetLocalU(uLocU, vLocU, wLocU)', newline, ...
            ];
            returnvalues = {'uLocU', 'vLocU', 'wLocU'};
            [uLocU, vLocU, wLocU] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            uLocU = str2double(uLocU);
            vLocU = str2double(vLocU);
            wLocU = str2double(wLocU);
        end
        function [uLocV, vLocV, wLocV] = GetLocalV(obj)
            % Returns the plane's local V-axis (if defined on a plane) in global coordinates.
            functionString = [...
                'Dim uLocV As Double, vLocV As Double, wLocV As Double', newline, ...
                'ParticleMonitor.GetLocalV(uLocV, vLocV, wLocV)', newline, ...
            ];
            returnvalues = {'uLocV', 'vLocV', 'wLocV'};
            [uLocV, vLocV, wLocV] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            uLocV = str2double(uLocV);
            vLocV = str2double(vLocV);
            wLocV = str2double(wLocV);
        end
        function int = GetPlaneDirection(obj)
            % Returns the alignment of the plane with respect to the active coordinate system (GCS or WCS).  (Only if plane-aligned.)
            % enum typename   meaning
            % 0               "U/X-component"
            % 1               "V/Y-component"
            % 2               "W/Z-component"
            int = obj.hParticleMonitor.invoke('GetPlaneDirection');
        end
        function double = GetPlanePosition(obj)
            % Offset of the plane along the normal axis of the GCS or WCS. (Only if plane-aligned.)
            double = obj.hParticleMonitor.invoke('GetPlanePosition');
        end
        function int = GetNParticles(obj)
            % Returns the number of particles which were recorded by the monitor. If a particle passes the monitor face several times it is counted only once for this query.
            int = obj.hParticleMonitor.invoke('GetNParticles');
        end
        function int = GetNParticlesTotal(obj)
            % Returns the number of all recorded events (or hits). If a particle passes the monitor-face several times, all events are counted.
            % An application example where the number of particles and events is usually different would be a cyclotron.
            int = obj.hParticleMonitor.invoke('GetNParticlesTotal');
        end
        function double = GetCurrent(obj)
            % Returns the amount of current flowing through the monitor's surface.
            double = obj.hParticleMonitor.invoke('GetCurrent');
        end
        function [uEmittance, vEmittance] = GetEmittance(obj)
            % Returns the averaged transverse emittance, i.e. u- and v-components, of the particles that move through the monitor.
            functionString = [...
                'Dim uEmittance As Double, vEmittance As Double', newline, ...
                'ParticleMonitor.GetEmittance(uEmittance, vEmittance)', newline, ...
            ];
            returnvalues = {'uEmittance', 'vEmittance'};
            [uEmittance, vEmittance] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            uEmittance = str2double(uEmittance);
            vEmittance = str2double(vEmittance);
        end
        function double = GetMeanValue(obj, type, direction)
            % Statistical evaluation: arithmetic mean in the direction of the quantitiy type, e.g. the component of "velocity" in "x-direction". Admissible entries for the type are shown in the table of the description of AbcissaSetting.
            % Admissible entries for direction are "x-direction", "y-direction", "z-direction" and "absolute". Here, "x", "y" and "z" represent the local coordinates of the monitor plane: "z" corresponds to the axis that is normal to the monitor plane and "x" and "y" are parallel to it. In the local coordinate system UVW, "x" is "u", "y" is "v" and "z" is "w". The table below translates the directions in the local coordinate system to those in the global coordinate system, depending on which of the principal planes of the global coordinate system the monitor plane is aligned to.
            %
            % direction (local)   direction when plane normal is x (global)   direction when plane normal is y (global)   direction when plane normal is z (global)
            % "x-direction"       y                                           z                                           x
            % "y-direction"       z                                           x                                           y
            % "z-direction"       x                                           y                                           z
            double = obj.hParticleMonitor.invoke('GetMeanValue', type, direction);
        end
        function double = GetRMS(obj, type, component)
            % Statistical evaluation: Get root mean square. For further information, see description of GetMeanValue.
            double = obj.hParticleMonitor.invoke('GetRMS', type, component);
        end
        function double = GetSigma(obj, type, component)
            % Statistical evaluation: Get standard deviation. For further information, see description of GetMeanValue.
            double = obj.hParticleMonitor.invoke('GetSigma', type, component);
        end
        function double = GetMin(obj, type, component)
            % Statistical evaluation: Get minimum value. For further information, see description of GetMeanValue.
            double = obj.hParticleMonitor.invoke('GetMin', type, component);
        end
        function double = GetMax(obj, type, component)
            % Statistical evaluation: Get maximum value. For further information, see description of GetMeanValue.
            double = obj.hParticleMonitor.invoke('GetMax', type, component);
        end
        %% Particle Queries
        function SelectParticle(obj, particleindex)
            % Selects the particle with the index particleindex for the following operations.
            obj.hParticleMonitor.invoke('.SelectParticle', particleindex);
        end
        function double = GetArea(obj)
            % Returns the specific area of the selected particle.
            double = obj.hParticleMonitor.invoke('GetArea');
        end
        function double = GetCharge(obj)
            % Returns the specific charge of the selected particle.
            double = obj.hParticleMonitor.invoke('GetCharge');
        end
        function double = GetMass(obj)
            % Returns the specific mass of the selected particle.
            double = obj.hParticleMonitor.invoke('GetMass');
        end
        function double = GetTimeStep(obj)
            % Returns the specific time step of the selected particle.
            double = obj.hParticleMonitor.invoke('GetTimeStep');
        end
        function int = GetNHits(obj)
            % Returns the number of hits of the particle with the plane. (If particle has penetrated the face more than once).
            int = obj.hParticleMonitor.invoke('GetNHits');
        end
        function double = GetHitTime(obj, hitindex)
            % Returns the time of the hit  with number hitindex.
            double = obj.hParticleMonitor.invoke('GetHitTime', hitindex);
        end
        function [uNorm, vNorm, wNorm] = GetPosition(obj, hitindex)
            % Returns the hit-position of the hit  with number hitindex.
            functionString = [...
                'Dim uNorm As Double, vNorm As Double, wNorm As Double', newline, ...
                'ParticleMonitor.GetPosition("', num2str(hitindex, '%.15g'), '", uNorm, vNorm, wNorm)', newline, ...
            ];
            returnvalues = {'uNorm', 'vNorm', 'wNorm'};
            [uNorm, vNorm, wNorm] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            uNorm = str2double(uNorm);
            vNorm = str2double(vNorm);
            wNorm = str2double(wNorm);
        end
        function [uNorm, vNorm, wNorm] = GetMomentum(obj, hitindex)
            % Returns the momentum of the hit  with number hitindex.
            functionString = [...
                'Dim uNorm As Double, vNorm As Double, wNorm As Double', newline, ...
                'ParticleMonitor.GetMomentum("', num2str(hitindex, '%.15g'), '", uNorm, vNorm, wNorm)', newline, ...
            ];
            returnvalues = {'uNorm', 'vNorm', 'wNorm'};
            [uNorm, vNorm, wNorm] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            uNorm = str2double(uNorm);
            vNorm = str2double(vNorm);
            wNorm = str2double(wNorm);
        end
        function [uNorm, vNorm, wNorm] = GetVelocity(obj, hitindex)
            % Returns the velocity of the hit  with number hitindex.
            functionString = [...
                'Dim uNorm As Double, vNorm As Double, wNorm As Double', newline, ...
                'ParticleMonitor.GetVelocity("', num2str(hitindex, '%.15g'), '", uNorm, vNorm, wNorm)', newline, ...
            ];
            returnvalues = {'uNorm', 'vNorm', 'wNorm'};
            [uNorm, vNorm, wNorm] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            uNorm = str2double(uNorm);
            vNorm = str2double(vNorm);
            wNorm = str2double(wNorm);
        end
        function double = GetValue(obj, hitindex, type, direction)
            % Returns the specific value of type type in direction direction of the hit with the number hitindex.
            double = obj.hParticleMonitor.invoke('GetValue', hitindex, type, direction);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hParticleMonitor
        history

        name
    end
end

%% Default Settings
%     Name('all sources_Z(0)');
%     AutoLabel(TRUE)
%     SourceName('all sources');
%     TemporalBehaviour('once');
%     TimeSpan(0,0)
%     UsePlane(TRUE)
%     Align('GLOBAL');
%     PlotType('phase-space');
%     AbscissaSetting('position', 'x-direction');
%     OrdinateSetting('angle', 'x-direction');
%     DensitySamples(100)
%     PlaneSetting('z-direction', 0)

%% Example - Taken from CST documentation and translated to MATLAB.
% The following program demonstrates the application of the interrogative commands. The results of these commands are written into a text file.
%
% function Example(project)
%     particlemonitor = project.ParticleMonitor();
%         particlemonitor.Reset();
%         particlemonitor.Name('mymonitor');
%         particlemonitor.AutoLabel('0');
%         particlemonitor.SourceName('');
%         particlemonitor.SourceType('AllSources');
%         particlemonitor.TemporalBehaviour('continuous');
%         particlemonitor.TimeSpan('0', '0');
%         particlemonitor.UsePlane('1');
%         particlemonitor.Align('GLOBAL');
%         particlemonitor.PlotType('phase-space');
%         particlemonitor.AbscissaSetting('position', 'z-direction');
%         particlemonitor.OrdinateSetting('position', 'y-direction');
%         particlemonitor.DensitySamples('100');
%         particlemonitor.PlaneSetting('x-direction', '0.00');
%         particlemonitor.Create();
%
%     hOutFile = fopen('trk monitor.txt', 'w'); For Output
%
%     % Test of a Particle Monitor
%     % selection of monitor
%     particlemonitor.SelectMonitor('mymonitor');
%
%     % normal is 0,0,1
%     particlemonitor.GetNormal(ucomp,vcomp,wcomp);
%     fprintf(hOutFile, ['Normal                     :', num2str(ucomp, '%.15g'), ';', num2str(vcomp, '%.15g'), ';', num2str(wcomp, '%.15g'), '\n']);
%     % localU is 1,0,0
%     particlemonitor.GetLocalU(ucomp,vcomp,wcomp);
%     fprintf(hOutFile, ['NormalU                    :', num2str(ucomp, '%.15g'), ';', num2str(vcomp, '%.15g'), ';', num2str(wcomp, '%.15g'), '\n']);
%     % localV is 0,1,0
%     particlemonitor.GetLocalV(ucomp,vcomp,wcomp);
%     fprintf(hOutFile, ['NormalV                    :', num2str(ucomp, '%.15g'), ';', num2str(vcomp, '%.15g'), ';', num2str(wcomp, '%.15g'), '\n']);
%     % 0 is GCS, 1 is WCS, 2 is Free positioned cutplane
%     itest = particlemonitor.GetAlign();
%     fprintf(hOutFile, ['Align                      :', num2str(itest, '%.15g'), '\n']);
%     % TRUE is cutplane, FALSE is Face-based monitor - face based monitors only consider the GCS
%     btest = particlemonitor.IsPlane
%     fprintf(hOutFile, ['IsPlane                    :', num2str(btest, '%.15g'), '\n']);
%     % The plane direction
%     itest = particlemonitor.GetPlaneDirection();
%     fprintf(hOutFile, ['PlaneDirection             :', num2str(itest, '%.15g'), '\n']);
%     % The plane position
%     dtest = particlemonitor.GetPlanePosition();
%     fprintf(hOutFile, ['PlanePosition              :', num2str(dtest, '%.15g'), '\n']);
%     % number of particles recorded by the monitor
%     itest = particlemonitor.GetNParticles();
%     fprintf(hOutFile, ['Number of Particles        :', num2str(itest, '%.15g'), '\n']);
%     % number of all particles recorded by the monitor(with multiple penetrated particles)
%     itest = particlemonitor.GetNParticlesTotal();
%     fprintf(hOutFile, ['Number of all Particles    :', num2str(itest, '%.15g'), '\n']);
%     % Total current of all single penetrated particles.
%     dtest = particlemonitor.GetCurrent();
%     fprintf(hOutFile, ['Current                    :', num2str(dtest, '%.15g'), '\n']);
%     % averaged values of all particles(also multiple penetrated particles) in the given direction
%     % As direction, also('absolute'); is considered
%     dtest = particlemonitor.GetMeanValue('position', 'x-direction');
%     fprintf(hOutFile, ['Position-X(mean)          :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetMeanValue('velocity', 'z-direction');
%     fprintf(hOutFile, ['Velocity-Z(mean)          :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetMeanValue('angle', 'x-direction');
%     fprintf(hOutFile, ['Angle-X   (mean)          :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetMeanValue('momentum', 'z-direction');
%     fprintf(hOutFile, ['Momentum-Z(mean)          :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetMeanValue('beta', 'z-direction');
%     fprintf(hOutFile, ['Beta-Z    (mean)          :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetMeanValue('gamma', 'z-direction');
%     fprintf(hOutFile, ['Gamma-Z   (mean)          :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetMeanValue('current', 'z-direction');
%     fprintf(hOutFile, ['Current-Z (mean)          :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetMeanValue('charge', 'z-direction');
%     fprintf(hOutFile, ['Charge-Z  (mean)          :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetMin('position', 'x-direction');
%     fprintf(hOutFile, ['Position-Z(min)           :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetMax('position', 'x-direction');
%     fprintf(hOutFile, ['Position-X(max)           :', num2str(dtest, '%.15g'), '\n']);
%     % returns the emittance in localU and LocalV direction
%     particlemonitor.GetEmittance(ucomp, vcomp);
%     fprintf(hOutFile, ['Emittance-U                :', num2str(ucomp, '%.15g'), '\n']);
%     fprintf(hOutFile, ['Emittance-V                :', num2str(vcomp, '%.15g'), '\n']);
%
%     % A single particle #2 is chosen
%     particlemonitor.SelectParticle(2);
%     fprintf(hOutFile, '\n');
%     fprintf(hOutFile, ['Particle                   :', num2str(2, '%.15g'), '\n']);
%     % properties of particle #2
%     dtest = particlemonitor.GetArea();
%     fprintf(hOutFile, ['   Area                    :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetCharge();
%     fprintf(hOutFile, ['   Charge                  :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetMass();
%     fprintf(hOutFile, ['   Mass                    :', num2str(dtest, '%.15g'), '\n']);
%     % Initial timestep(is used for current calculation I=q/dt)
%     dtest = particlemonitor.GetTimeStep();
%     fprintf(hOutFile, ['   Timestep                :', num2str(dtest, '%.15g'), '\n']);
%     % number of particle-hits
%     itest = particlemonitor.GetNHits();
%     fprintf(hOutFile, ['   Particle-hits           :', num2str(itest, '%.15g'), '\n']);
%
%     % point of time of hit
%     dtest = particlemonitor.GetHitTime(0);
%     fprintf(hOutFile, '\n');
%     fprintf(hOutFile, ['Time of hit #0            :', num2str(dtest, '%.15g'), '\n']);
%     % particle data of hit #0
%     particlemonitor.GetPosition(0,ucomp,vcomp,wcomp);
%     fprintf(hOutFile, ['   Hit #0: position       :', num2str(ucomp, '%.15g'), ';', num2str(vcomp, '%.15g'), ';', num2str(wcomp, '%.15g'), '\n']);
%     particlemonitor.GetMomentum(0,ucomp,vcomp,wcomp);
%     fprintf(hOutFile, ['   Hit #0: momentum       :', num2str(ucomp, '%.15g'), ';', num2str(vcomp, '%.15g'), ';', num2str(wcomp, '%.15g'), '\n']);
%     particlemonitor.GetVelocity(0,ucomp,vcomp,wcomp);
%     fprintf(hOutFile, ['   Hit #0: velocity       :', num2str(ucomp, '%.15g'), ';', num2str(vcomp, '%.15g'), ';', num2str(wcomp, '%.15g'), '\n']);
%     % specific data of particle for hit #0
%     dtest = particlemonitor.GetValue(0, 'position', 'y-direction');
%     fprintf(hOutFile, ['   Hit #0: position-y     :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetValue(0, 'velocity', 'z-direction');
%     fprintf(hOutFile, ['   Hit #0: velocity-z     :', num2str(dtest, '%.15g'), '\n']);
%     dtest = particlemonitor.GetValue(0, 'beta', 'z-direction');
%     fprintf(hOutFile, ['   Hit #0: beta-z         :', num2str(dtest, '%.15g'), '\n']);
%
%     % delete the above created result data
%     particlemonitor.ClearMonitorData();
%
%     fclose(hOutFile);
% end
