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

% DRC Object
classdef DRC < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.DRC object.
        function obj = DRC(project, hProject)
            obj.project = project;
            obj.hDRC = hProject.invoke('DRC');
        end
    end
    %% CST Object functions.
    methods
        %% CST 2014 Functions.
        function Reset(obj)
            % Resets the import options to the default.
            obj.hDRC.invoke('Reset');
        end
        function FileName(obj, filename)
            % Sets a name of the exported file.
            obj.hDRC.invoke('FileName', filename);
        end
        function Precision(obj, precision)
            % Specify the precision of which the data shall be written to the exported file. If you specify single precision, the extension of the file name will be taken as ".drc". Setting this option to double precision will imply the file extension ".drd".
            % precision can have one of the following values:
            % "single" - Single precision mafia file
            % "double" - Double precision mafia file
            obj.hDRC.invoke('Precision', precision);
        end
        function Platform(obj, platform)
            % Specify whether the mafia file should be exported for a Windows PC or a Unix system.
            % platform can have one of the following values:
            % "pc" - Windows PC
            % "unix" - Unix PC or Unix workstation
            obj.hDRC.invoke('Platform', platform);
        end
        function IncludePBA(obj, boolean)
            % This option is used for internal testing only.
            obj.hDRC.invoke('IncludePBA', boolean);
        end
        function Write(obj)
            % Performs the export.
            obj.hDRC.invoke('Write');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hDRC

    end
end

%% Default Settings
% FileName('');
% IncludePBA(0)
% Precision('single');
% Platform('pc');

%% Example - Taken from CST documentation and translated to MATLAB.
% drc = project.DRC();
% .Reset
% .FileName('.\example.drc');
% .Precision('single');
% .Platform('pc');
% .Write
