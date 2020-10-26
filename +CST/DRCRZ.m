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

% This command offers Mafia DRC file export in a rz coordinate system.
classdef DRCRZ < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.DRCRZ object.
        function obj = DRCRZ(project, hProject)
            obj.project = project;
            obj.hDRCRZ = hProject.invoke('DRCRZ');
        end
    end
    %% CST Object functions.
    methods
        %% CST 2013 Functions.
        function Reset(obj)
            % Resets the import options to the default.
            obj.hDRCRZ.invoke('Reset');
        end
        function FileName(obj, filename)
            % Sets a name of the exported file.
            obj.hDRCRZ.invoke('FileName', filename);
        end
        function Precision(obj, precision)
            % Specify the precision of which the data shall be written to the exported file. If you specify single precision, the extension of the file name will be taken as ".drc". Setting this option to double precision will imply the file extension ".drd".
            %
            % precision can have one of  the following values:
            % "single"    Single precision mafia file
            % "double"    Double precision mafia file
            obj.hDRCRZ.invoke('Precision', precision);
        end
        function Platform(obj, platform)
            % Specify whether the mafia file should be exported for a Windows PC or a Unix system.
            %
            % platform can have one of  the following values:
            % "pc"    Windows PC
            % "unix"  Unix PC or Unix workstation
            obj.hDRCRZ.invoke('Platform', platform);
        end
        function RAxis(obj, axis)
            % Select the coordinate axis used as the r-axis in positive or negative direction.
            %
            % axis can have one of  the following values:
            % "-x"    Negative x-direction
            % "+x"    Positive x-direction
            % "-y"    Negative y-direction
            % "+y"    Positive y-direction
            % "-z"    Negative z-direction
            % "+z"    Positive z-direction
            obj.hDRCRZ.invoke('RAxis', axis);
        end
        function ZAxis(obj, axis)
            % Select the coordinate axis used as the z-axis in positive or negative direction.
            obj.hDRCRZ.invoke('ZAxis', axis);
        end
        function can = axis(obj)
            % "-x"    Negative x-direction
            % "+x"    Positive x-direction
            % "-y"    Negative y-direction
            % "+y"    Positive y-direction
            % "-z"    Negative z-direction
            % "+z"    Positive z-direction
            can = obj.hDRCRZ.invoke('axis');
        end
        function Write(obj)
            % Performs the export.
            obj.hDRCRZ.invoke('Write');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hDRCRZ

    end
end

%% Default Settings
% FileName('');
% IncludePBA(0)
% Precision('single');
% Platform('pc');
% RAxis('+x');
% ZAxis('+z');

%% Example - Taken from CST documentation and translated to MATLAB.
% drcrz = project.DRCRZ();
%     drcrz.Reset
%     drcrz.FileName('.\example.drc');
%     drcrz.Precision('single');
%     drcrz.Platform('pc');
%     drcrz.RAxis('+x');
%     drcrz.ZAxis('+z');
%     drcrz.Write
