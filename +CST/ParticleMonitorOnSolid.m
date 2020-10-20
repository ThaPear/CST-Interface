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

% Defines a particle monitor which collects information about particles colliding with the solid.
classdef ParticleMonitorOnSolid < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ParticleMonitorOnSolid object.
        function obj = ParticleMonitorOnSolid(project, hProject)
            obj.project = project;
            obj.hParticleMonitorOnSolid = hProject.invoke('ParticleMonitorOnSolid');
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
            % Defines a name for the particle monitor. This must be consistent with the names of the model components. For the background, there are two special names: "[Background]:Boundary" and "[Background]:Material. "[Background]:Boundary" represents the bounding box defining the PIC calculation domain and "[Background]:Material" represents the interface between the background material and the rest of the structure.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function EnableCollisionInfo(obj, enable)
            % Enables the monitoring of collision info: current vs time, power vs time and/or energy histogram.
            obj.AddToHistory(['.EnableCollisionInfo "', num2str(enable, '%.15g'), '"']);
        end
        function EnableCurrent(obj, enable)
            % Enables the monitoring of the particle current as a function of time. The solver time step is used for the x-axis step.
            obj.AddToHistory(['.EnableCurrent "', num2str(enable, '%.15g'), '"']);
        end
        function EnablePower(obj, enable)
            % Enables the monitoring of the particle power as a function of time. The solver time step is used for the x-axis step.
            obj.AddToHistory(['.EnablePower "', num2str(enable, '%.15g'), '"']);
        end
        function EnableEnergyHistogram(obj, enable)
            % Enables the monitoring of the number of particles as a function of energy.
            obj.AddToHistory(['.EnableEnergyHistogram "', num2str(enable, '%.15g'), '"']);
        end
        function EnergyBinSize(obj, val)
            % Sets the energy bin size of the histogram.
            obj.AddToHistory(['.EnergyBinSize "', num2str(val, '%.15g'), '"']);
        end
        function EnergyMin(obj, val)
            % Sets the lower energy bound of the histogram.
            obj.AddToHistory(['.EnergyMin "', num2str(val, '%.15g'), '"']);
        end
        function EnergyMax(obj, val)
            % Sets the upper energy bound of the histogram.
            obj.AddToHistory(['.EnergyMax "', num2str(val, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a monitor using the settings specified with the previous methods and the default settings.
            obj.AddToHistory(['.Create']);

            % Prepend With ParticleMonitorOnSolid and append End With
            obj.history = [ 'With ParticleMonitorOnSolid', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ParticleMonitorOnSolid: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the monitor with the specified name.
            obj.project.AddToHistory(['ParticleMonitorOnSolid.Delete "', num2str(name, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hParticleMonitorOnSolid
        history

        name
    end
end

%% Default Settings
% With ParticleMonitorOnSolid
%      .Reset
%      .Name('[Background]:Boundary');
%      .EnableCollisionInfo('1');
%      .EnableCurrent('1');
%      .EnablePower('1');
%      .EnableEnergyHistogram('0');
%      .EnergyBinSize('1.0');
%      .EnergyMin('0.0');
%      .EnergyMax('100.0');
%      .Create
% End With
%

%% Example - Taken from CST documentation and translated to MATLAB.
% particlemonitoronsolid = project.ParticleMonitorOnSolid();
%     particlemonitoronsolid.Reset
%     particlemonitoronsolid.Name('[Background]:Boundary');
%     particlemonitoronsolid.EnableCollisionInfo('1');
%     particlemonitoronsolid.EnableCurrent('1');
%     particlemonitoronsolid.EnablePower('0');
%     particlemonitoronsolid.EnableEnergyHistogram('1');
%     particlemonitoronsolid.EnergyBinSize('2.0');
%     particlemonitoronsolid.EnergyMin('100.0');
%     particlemonitoronsolid.EnergyMax('1000.0');
%     particlemonitoronsolid.Create
%
% particlemonitoronsolid.Delete('[Background]:Boundary');
