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

% Defines a plane wave excited at an open boundary of the calculation domain. Unlike discrete ports or waveguide ports no S-parameters will be calculated. Instead the stimulation amplitude (unit is V/m) is recorded. To obtain further information you might specify probes or different types of field monitors. Combined with farfield monitors the plane wave source can be used to compute the radar cross section (RCS).
classdef PlaneWave < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.PlaneWave object.
        function obj = PlaneWave(project, hProject)
            obj.project = project;
            obj.hPlaneWave = hProject.invoke('PlaneWave');
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
        function Store(obj)
            % This method stores the settings concerning the definition of a plane wave excitation after checking their validity.
            obj.AddToHistory(['.Store']);
            
            % Prepend With PlaneWave and append End With
            obj.history = [ 'With PlaneWave', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define PlaneWave'], obj.history);
            obj.history = [];
        end
        function Delete(obj)
            % Deletes the existing plane wave.
            obj.project.AddToHistory(['PlaneWave.Delete']);
        end
        function Normal(obj, xcomponent, ycomponent, zcomponent)
            % This method defines the propagation direction of an excited plane wave by setting the components of the three dimensional normal vector.
            obj.AddToHistory(['.Normal "', num2str(xcomponent, '%.15g'), '", '...
                                      '"', num2str(ycomponent, '%.15g'), '", '...
                                      '"', num2str(zcomponent, '%.15g'), '"']);
        end
        function EVector(obj, xcomponent, ycomponent, zcomponent)
            % This method defines the electrical field vector of an excited plane wave. This vector must not be parallel to the defined propagation normal.
            obj.AddToHistory(['.EVector "', num2str(xcomponent, '%.15g'), '", '...
                                       '"', num2str(ycomponent, '%.15g'), '", '...
                                       '"', num2str(zcomponent, '%.15g'), '"']);
        end
        function Polarization(obj, type)
            % Specifies the polarization type of the plane wave excitation.
            % type: 'Linear'
            %       'Circular'
            %       'Elliptic'
            obj.AddToHistory(['.Polarization "', num2str(type, '%.15g'), '"']);
        end
        function ReferenceFrequency(obj, frequency)
            % Specifies the reference frequency for the plane wave excitation in case of a circular or elliptical polarization.
            obj.AddToHistory(['.ReferenceFrequency "', num2str(frequency, '%.15g'), '"']);
        end
        function PhaseDifference(obj, angle)
            % The phase difference between the two excitation vectors used for elliptical polarized plane waves.
            obj.AddToHistory(['.PhaseDifference "', num2str(angle, '%.15g'), '"']);
        end
        function CircularDirection(obj, dir)
            % Specifies "Left" or "Right" circular polarized plane wave excitation.
            % dir: 'Left'
            %      'Right'
            obj.AddToHistory(['.CircularDirection "', num2str(dir, '%.15g'), '"']);
        end
        function AxialRatio(obj, ratio)
            % Defines the ratio between the amplitudes of the two electric field vectors used for elliptical polarization.
            obj.AddToHistory(['.AxialRatio "', num2str(ratio, '%.15g'), '"']);
        end
        function SetUserDecouplingPlane(obj, flag)
            % Activates a user defined decoupling plane for a plane wave excitation. The decoupling plane offers the possibility to deliberately imprint wave reflections due to metallic boundaries.
            obj.AddToHistory(['.SetUserDecouplingPlane "', num2str(flag, '%.15g'), '"']);
        end
        function DecouplingPlane(obj, dir, position)
            % This command sets the orientation and location of a user defined decoupling plane for a defined plane wave excitation.
            % dir,: 'x'
            %       'y'
            %       'z'
            obj.AddToHistory(['.DecouplingPlane "', num2str(dir, '%.15g'), '", '...
                                               '"', num2str(position, '%.15g'), '"']);
        end
        %% Queries
        function [xcomponent, ycomponent, zcomponent] = GetNormal(obj)
            % Returns the propagation direction of an excited plane wave by providing the components of the three dimensional normal vector.
            functionString = [...
                'Dim xcomponent As Double, ycomponent As Double, zcomponent As Double', newline, ...
                'valid = PlaneWave.GetNormal(xcomponent, ycomponent, zcomponent)', newline, ...
            ];
            returnvalues = {'xcomponent', 'ycomponent', 'zcomponent'};
            [xcomponent, ycomponent, zcomponent] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            xcomponent = str2double(xcomponent);
            ycomponent = str2double(ycomponent);
            zcomponent = str2double(zcomponent);
        end
        function [xcomponent, ycomponent, zcomponent] = GetEVector(obj)
            % Returns the electrical field vector of an excited plane wave.
            functionString = [...
                'Dim xcomponent As Double, ycomponent As Double, zcomponent As Double', newline, ...
                'valid = PlaneWave.GetEVector(xcomponent, ycomponent, zcomponent)', newline, ...
            ];
            returnvalues = {'xcomponent', 'ycomponent', 'zcomponent'};
            [xcomponent, ycomponent, zcomponent] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            xcomponent = str2double(xcomponent);
            ycomponent = str2double(ycomponent);
            zcomponent = str2double(zcomponent);
        end
        function enum = GetPolarizationType(obj)
            % Returns the polarization type of the plane wave excitation.
            enum = obj.hPlaneWave.invoke('GetPolarizationType');
        end
        function enum = GetCircularDirection(obj)
            % Returns the circular direction of a circular polarized plane wave excitation.
            enum = obj.hPlaneWave.invoke('GetCircularDirection');
        end
        function double = GetReferenceFrequency(obj)
            % Returns the reference frequency for the plane wave excitation in case of a circular or elliptical polarization.
            double = obj.hPlaneWave.invoke('GetReferenceFrequency');
        end
        function double = GetPhaseDifference(obj)
            % Returns the phase difference between the two excitation vectors used for elliptical polarized plane waves.
            double = obj.hPlaneWave.invoke('GetPhaseDifference');
        end
        function double = GetAxialRatio(obj)
            % Returns the ratio between the amplitudes of the two electric field vectors used for elliptical polarization.
            double = obj.hPlaneWave.invoke('GetAxialRatio');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPlaneWave
        history

    end
end

%% Default Settings
% .Normal(0, 0, 1)
% .EVector(1, 0, 0)
% .Polarization('Linear');
% .ReferenceFrequency(0.0)
% .PhaseDifference(-90.0)
% .CircularDirection('Left');
% .AxialRatio(1.0)
% .SetUserMirrorPlane(0)
% .MirrorPlane('x', 0.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% planewave = project.PlaneWave();
%     planewave.Reset
%     planewave.Normal(0, 0, 1)
%     planewave.EVector(1, 0, 0)
%     planewave.Polarization('Elliptical');
%     planewave.ReferenceFrequency('midfreq');
%     planewave.PhaseDifference(-90.0)
%     planewave.CircularDirection('Left');
%     planewave.AxialRatio(0.5)
%     planewave.SetUserMirrorPlane(1)
%     planewave.MirrorPlane('y', 10.1)
%     planewave.Store
