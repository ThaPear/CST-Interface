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

% Defines a 2D position monitor. The monitor uses a plane to record the data of the particles of which the trajectories intersect the monitor plane.
classdef PIC2DMonitor < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.PIC2DMonitor object.
        function obj = PIC2DMonitor(project, hProject)
            obj.project = project;
            obj.hPIC2DMonitor = hProject.invoke('PIC2DMonitor');
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
            % Resets all internal values to their default settings.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Name(obj, monitorName)
            % Sets the name of the monitor.
            obj.AddToHistory(['.Name "', num2str(monitorName, '%.15g'), '"']);
            obj.name = monitorName;
        end
        function SetDirection(obj, dir)
            % This method defines the plane normal of the particle 2D monitor.
            % The values for dir can be: "X", "Y" or "Z".
            % When the plane normal is defined in the w-direction of the local uvw-coordinate system, so that the uv-plane is transverse to the plane normal, the following table applies depending on the choice of dir:
            % dir (w-direction)   u-direction         v-direction
            % X                   Y                   Z
            % Y                   Z                   X
            % Z                   X                   Y
            obj.AddToHistory(['.SetDirection "', num2str(dir, '%.15g'), '"']);
        end
        function SetWPosition(obj, wcut)
            % Position of the 2D monitor plane along the direction of the specified plane normal (e.g. along the Z-axis when dir = "Z").
            obj.AddToHistory(['.SetWPosition "', num2str(wcut, '%.15g'), '"']);
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
        function Tstart(obj, startTime)
            % Sets starting time for a time domain monitor to startTime.
            obj.AddToHistory(['.Tstart "', num2str(startTime, '%.15g'), '"']);
        end
        function Tstep(obj, timeStep)
            % Sets the time increment for a time domain monitor to timeStep.
            obj.AddToHistory(['.Tstep "', num2str(timeStep, '%.15g'), '"']);
        end
        function Tend(obj, stopTime)
            % Sets the end time for a time domain monitor to stopTime.
            obj.AddToHistory(['.Tend "', num2str(stopTime, '%.15g'), '"']);
        end
        function UseTend(obj, bFlag)
            % If bFlag is True the time domain monitor stops storing the results when the end time set with Tend is reached. Otherwise the monitor will continue until the simulation stops.
            obj.AddToHistory(['.UseTend "', num2str(bFlag, '%.15g'), '"']);
        end
        function Delete(obj, monitorName)
            % Deletes the monitor named monitorName.
            obj.project.AddToHistory(['PIC2DMonitor.Delete "', num2str(monitorName, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the monitor named oldname to newname.
            obj.project.AddToHistory(['PIC2DMonitor.Rename "', num2str(oldname, '%.15g'), '", '...
                                                          '"', num2str(newname, '%.15g'), '"']);
        end
        function SetElementsMaxGPU(obj, number)
            % Set the maximum number of particles that can be monitored per time step for PIC on GPU. This setting is a global setting, therefore it affects all PIC 2D monitors.
            obj.AddToHistory(['.SetElementsMaxGPU "', num2str(number, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the monitor with the previously applied settings.
            obj.AddToHistory(['.Create']);

            % Prepend With PIC2DMonitor and append End With
            obj.history = [ 'With PIC2DMonitor', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define PIC2DMonitor: ', obj.name], obj.history);
            obj.history = [];
        end
        %% Queries
        function SelectMonitor(obj, monitorName)
            % This command must be called before any of the queries below can be executed. It selects the specific monitor to be evaluated by the subsequent commands.
            obj.hPIC2DMonitor.invoke('SelectMonitor', monitorName);
        end
        function long = GetDirection(obj)
            % Get the orientation (normal) of the PIC 2D monitor. The return value 0 means x, 1 means y and 2 means z-direction.
            long = obj.hPIC2DMonitor.invoke('GetDirection');
        end
        function double = GetWPosition(obj)
            % Get the pic 2D monitor plane position in normal (w-)direction.
            double = obj.hPIC2DMonitor.invoke('GetWPosition');
        end
        function double = GetUmin(obj)
            % Get the left boundary (minimum value) of the pic 2D monitor plane in u-direction.
            double = obj.hPIC2DMonitor.invoke('GetUmin');
        end
        function double = GetUmax(obj)
            % Get the right boundary (maximum value) of the pic 2D monitor plane in u-direction.
            double = obj.hPIC2DMonitor.invoke('GetUmax');
        end
        function double = GetVmin(obj)
            % Get the left boundary (minimum value) of the pic 2D monitor plane in v-direction.
            double = obj.hPIC2DMonitor.invoke('GetVmin');
        end
        function double = GetVmax(obj)
            % Get the right boundary (maximum value) of the pic 2D monitor plane in v-direction.
            double = obj.hPIC2DMonitor.invoke('GetVmax');
        end
        function long = GetNFrames(obj)
            % Gets the number of frames.
            long = obj.hPIC2DMonitor.invoke('GetNFrames');
        end
        function long = GetNParticles(obj, iFrame)
            % Gets the number of recorded particles in one frame.
            long = obj.hPIC2DMonitor.invoke('GetNParticles', iFrame);
        end
        function double = GetCurrentPerFrame(obj, iFrame)
            % Get the current that is monitored in one frame. The current in the monitors' normal direction is positive weighted whereas the current in the opposite direction is negative weighted.
            double = obj.hPIC2DMonitor.invoke('GetCurrentPerFrame', iFrame);
        end
        function double = GetTime(obj, iFrame)
            % Gets the time from the requested frame.
            double = obj.hPIC2DMonitor.invoke('GetTime', iFrame);
        end
        function double = GetTimeStep(obj, iFrame)
            % Gets the time step from the requested frame.
            double = obj.hPIC2DMonitor.invoke('GetTimeStep', iFrame);
        end
        function double = GetChargeTotal(obj, iFrame)
            % Gets the total charge of all particles recorded in one frame. In this case all charges are just added up, the direction in that they hit the monitor's plane is not considered.
            double = obj.hPIC2DMonitor.invoke('GetChargeTotal', iFrame);
        end
        function double = GetChargeTotalMacro(obj, iFrame)
            % Gets the total macro charge of all particles recorded in one frame. In this case all charges are just added up, the direction in that they hit the monitor's plane is not considered.
            double = obj.hPIC2DMonitor.invoke('GetChargeTotalMacro', iFrame);
        end
        function [dPosX, dPosY, dPosZ] = GetPosition(obj, iFrame, iParticle)
            % Gets the position of one particle in one frame.
            functionString = [...
                'Dim dPosX As Double, dPosY As Double, dPosZ As Double', newline, ...
                'PIC2DMonitor.GetPosition("', num2str(iFrame, '%.15g'), '", "', num2str(iParticle, '%.15g'), '", dPosX, dPosY, dPosZ)', newline, ...
            ];
            returnvalues = {'dPosX', 'dPosY', 'dPosZ'};
            [dPosX, dPosY, dPosZ] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            dPosX = str2double(dPosX);
            dPosY = str2double(dPosY);
            dPosZ = str2double(dPosZ);
        end
        function [dMomX, dMomY, dMomZ] = GetMomentumNormed(obj, iFrame, iParticle)
            % Gets the normalized momentum of one particle in one frame.
            functionString = [...
                'Dim dMomX As Double, dMomY As Double, dMomZ As Double', newline, ...
                'PIC2DMonitor.GetMomentumNormed("', num2str(iFrame, '%.15g'), '", "', num2str(iParticle, '%.15g'), '", dMomX, dMomY, dMomZ)', newline, ...
            ];
            returnvalues = {'dMomX', 'dMomY', 'dMomZ'};
            [dMomX, dMomY, dMomZ] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            dMomX = str2double(dMomX);
            dMomY = str2double(dMomY);
            dMomZ = str2double(dMomZ);
        end
        function double = GetMomentumNormedAbs(obj, iFrame, iParticle)
            % Gets the absolute value of the normed momentum.
            double = obj.hPIC2DMonitor.invoke('GetMomentumNormedAbs', iFrame, iParticle);
        end
        function double = GetMass(obj, iFrame, iParticle)
            % Gets the particle's mass.
            double = obj.hPIC2DMonitor.invoke('GetMass', iFrame, iParticle);
        end
        function double = GetMassMacro(obj, iFrame, iParticle)
            % Gets the particle's macro mass.
            double = obj.hPIC2DMonitor.invoke('GetMassMacro', iFrame, iParticle);
        end
        function double = GetCharge(obj, iFrame, iParticle)
            % Gets the particle's charge.
            double = obj.hPIC2DMonitor.invoke('GetCharge', iFrame, iParticle);
        end
        function double = GetChargeMacro(obj, iFrame, iParticle)
            % Gets the particle's macro charge.
            double = obj.hPIC2DMonitor.invoke('GetChargeMacro', iFrame, iParticle);
        end
        function double = GetCurrent(obj, iFrame, iParticle)
            % Gets the particle's current.
            double = obj.hPIC2DMonitor.invoke('GetCurrent', iFrame, iParticle);
        end
        function [EmittanceU, EmittanceV] = GetMonitorEmittance(obj)
            % Calculate the transverse emittance in U and V directions for all frames. To calculate the emittance, at least two particles are required. When less than two particles are present, -1.0 is returned.
            functionString = [...
                'Dim EmittanceU As Double, EmittanceV As Double', newline, ...
                'PIC2DMonitor.GetMonitorEmittance(EmittanceU, EmittanceV)', newline, ...
            ];
            returnvalues = {'EmittanceU', 'EmittanceV'};
            [EmittanceU, EmittanceV] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            EmittanceU = str2double(EmittanceU);
            EmittanceV = str2double(EmittanceV);
        end
        function [EmittanceU, EmittanceV] = GetFrameEmittance(obj, iFrame)
            % Calculate the transverse emittance in U and V directions for a given frame. To calculate the emittance, at least two particles are required. When less than two particles are present, -1.0 is returned.
            functionString = [...
                'Dim EmittanceU As Double, EmittanceV As Double', newline, ...
                'PIC2DMonitor.GetFrameEmittance("', num2str(iFrame, '%.15g'), '", EmittanceU, EmittanceV)', newline, ...
            ];
            returnvalues = {'EmittanceU', 'EmittanceV'};
            [EmittanceU, EmittanceV] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            EmittanceU = str2double(EmittanceU);
            EmittanceV = str2double(EmittanceV);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPIC2DMonitor
        history

        name
    end
end

%% Default Settings
% Dir('Z');
% Wcut(0)
% Umin(0)
% Umax(0)
% Vmin(0)
% Vmax(0)
% Tstart(0.0)
% Tstep (0.0)
% Tend  (0.0)
% UseTend(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% % creates a PIC 2D Monitor
% pic2dmonitor = project.PIC2DMonitor();
%     pic2dmonitor.Reset
%     pic2dmonitor.Name('pic 2d monitor 1');
%     pic2dmonitor.SetDirection('Z');
%     pic2dmonitor.SetWPosition('-50');
%     pic2dmonitor.Umin('-10');
%     pic2dmonitor.Umax('10');
%     pic2dmonitor.Vmin('-10');
%     pic2dmonitor.Vmax('10');
%     pic2dmonitor.Tstart('0.0');
%     pic2dmonitor.Tstep('0.05');
%     pic2dmonitor.Tend('0.0');
%     pic2dmonitor.UseTend('0');
%     pic2dmonitor.Create
%
% % get some result data from the pic 2d monitor and prints it into a text file
% Sub Main
% Dim nFrames          As Long
% Dim nParticles       As Long
% Dim dTime            As Double
% Dim dX               As Double
% Dim dY               As Double
% Dim dZ               As Double
% Dim dChargeMacro     As Double
% Dim dCurrentPerFrame As Double
%
% SelectMonitor('pic 2d monitor 1');
%
% Open('pic 2d monitor 1.txt'); For Output As #1
% nFrames = .GetNFrames
%
% Dim iFrame As Long
% For iFrame = 0 To nFrames - 1
%
% nParticles       = .GetNParticles(iFrame)
% dTime            = .GetTime(iFrame)
% dCurrentPerFrame = .GetChargeTotalMacro(iFrame) / .GetTimeStep(iFrame)
%
% Print #1, 'Time                :('; dTime
% Print #1, 'Number of Particles :('; nParticles
% Print #1, 'Current per Frame   :('; dCurrentPerFrame
%
% Dim iParticle As Long
% For iParticle = 0 To nParticles - 1
%
% dChargeMacro = .GetChargeMacro(iFrame, iParticle)
% .GetPosition(iFrame, iParticle, dX, dY, dZ)
% Print #1, 'Particle data       :('; iFrame;('('; iParticle;('('; dX;('('; dY;('('; dZ;('('
%
% Next iParticle
% Next iFrame
%
% Close #1
% End Sub
%
