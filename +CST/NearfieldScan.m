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

% The cylinder scan calculates electrical field values on parametrized cylinder outside the simulation volume. A proper farfield monitor has to be defined before starting the simulation to allow the cylinder scan calculation as a post-processing step.
classdef NearfieldScan < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.NearfieldScan object.
        function obj = NearfieldScan(project, hProject)
            obj.project = project;
            obj.hNearfieldScan = hProject.invoke('NearfieldScan');
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
        end
        function FarfieldMonitor(obj, sName)
            % Defines the farfield monitor used for the cylinder scan calculation.
            obj.AddToHistory(['.FarfieldMonitor "', num2str(sName, '%.15g'), '"']);
        end
        function Frequency(obj, frequency)
            % Specifies the frequency point use for the cylinder  scan evaluation. Available for broadband farfield monitors only.
            obj.AddToHistory(['.Frequency "', num2str(frequency, '%.15g'), '"']);
        end
        function UserBase(obj, x, y, z)
            % Base of the scan cylinder in project units.
            obj.AddToHistory(['.UserBase "', num2str(x, '%.15g'), '", '...
                                        '"', num2str(y, '%.15g'), '", '...
                                        '"', num2str(z, '%.15g'), '"']);
        end
        function Useraxis(obj, x, y, z)
            % Alignment axis of the scan cylinder.
            obj.AddToHistory(['.Useraxis "', num2str(x, '%.15g'), '", '...
                                        '"', num2str(y, '%.15g'), '", '...
                                        '"', num2str(z, '%.15g'), '"']);
        end
        function Step(obj, step)
            % Specifies the angular resolution of the scan cylinder in degrees.
            obj.AddToHistory(['.Step "', num2str(step, '%.15g'), '"']);
        end
        function Radius(obj, weight)
            % Specifies the radius in meters of the scan cylinder
            obj.AddToHistory(['.Radius "', num2str(weight, '%.15g'), '"']);
        end
        function Height(obj, height)
            % Specifies the height in meters of the scan cylinder.
            obj.AddToHistory(['.Height "', num2str(height, '%.15g'), '"']);
        end
        function Label(obj, sName)
            % Sets the label for the cylinder scan files and tree entry. The label is automatically created from the farfield monitor name if an empty string is set.
            obj.AddToHistory(['.Label "', num2str(sName, '%.15g'), '"']);
        end
        function StoreSettings(obj)
            % Saves all previously defined cylinder scan settings.
            obj.AddToHistory(['.StoreSettings']);
        end
        function Create(obj)
            % Executes the cylinder scan calculation using the previously defined settings.
            obj.AddToHistory(['.Create']);

            % Prepend With NearfieldScan and append End With
            obj.history = [ 'With NearfieldScan', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.RunVBACode(obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hNearfieldScan
        history

    end
end

%% Default Settings
% UserBase(0,0,0)
% Useraxis(0,0,1)
% Step(1)
% Radius(1)
% Height(1)
% Label('');

%% Example - Taken from CST documentation and translated to MATLAB.
% nearfieldscan = project.NearfieldScan();
%     nearfieldscan.Reset();
%     nearfieldscan.FarfieldMonitor('farfield(f=5) [1]');
%     nearfieldscan.UserBase(0,0,0)
%     nearfieldscan.Useraxis(0,1,0)
%     nearfieldscannearfieldscan.Step(1)
%     nearfieldscannearfieldscan.Radius(1)
%     nearfieldscan.Height(0.5)
%     nearfieldscan.Label('');
%     nearfieldscan.Create();
%
