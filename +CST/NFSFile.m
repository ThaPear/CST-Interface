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

% The NFS file format allows the imprint of equivalent surface fields on a box or even on single planes. This format is especially designed for scan data and is able to handle an equidistant as well as a non-equidistant sampled spatial distribution of field data.
% The format is based on the IEC® Technical Report IEC/TR 61967-1-1.
%
% In order to describe surface fields on a rectangular box surface, each face and field component has to be defined  in a single XML-file and a corresponding DAT-file.
% The XML-file contains all meta-data such as field type, field components (Ex, Ey, Ez, Hx, Hy, Hz ), frequencies, and a reference to the DAT-file.
%
% The DAT-file contains the actual field data values in the following ASCII pattern:
% x0 y0 z0 Re(freq1) Im(freq1) Re(freq2) Im(freq2) Re(freq3) Im(freq3) ...
% x1 y0 z0 Re(freq1) Im(freq1) Re(freq2) Im(freq2) Re(freq3) Im(freq3) ...
% x0 y1 z0 Re(freq1) Im(freq1) Re(freq2) Im(freq2) Re(freq3) Im(freq3) ...
% ...
% Where (x_i, y_i, z_i) describe point positions of a cartesian grid and Re(freq1) / Im(freq2) the real / imaginary part of the field value at frequency freq1 and position (x_i, y_i, z_i). Example files for the supported types of the NFS format for the CST MICROWAVE STUDIO transient solver can be found here. A detailed description of the file syntax can be found in  IEC® Technical Report IEC/TR 61967-1-1.
classdef NFSFile < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.NFSFile object.
        function obj = NFSFile(project, hProject)
            obj.project = project;
            obj.hNFSFile = hProject.invoke('NFSFile');
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
            % Resets the import options to the default.
            obj.AddToHistory(['.Reset']);
        end
        function SetCoarsening(obj, coarseningFactor)
            % Set the coarsening of the hexaedral mesh that will be generated to export the field monitor data. The factor sets the density of the output mesh in relation to the existing mesh, that can be inspected with  "Home -> Mesh -> Mesh View". For example, a factor of 2 leads to a mesh which is 2 times coarser than the original mesh.
            obj.AddToHistory(['.SetCoarsening "', num2str(coarseningFactor, '%.15g'), '"']);
        end
        function SetInteractive(obj, Interactive)
            % Set to true, will ask for user interaction when something unexpected happens, e.g. if a folder has to be deleted before exporting. Otherwise will abort.
            obj.AddToHistory(['.SetInteractive "', num2str(Interactive, '%.15g'), '"']);
        end
        function DeleteFolderIfPresent(obj, DeleteFolderIfPresent)
            % Set this option to True to delete an existing folder when exporting without prompting. Only works in non-interactive mode.
            obj.AddToHistory(['.DeleteFolderIfPresent "', num2str(DeleteFolderIfPresent, '%.15g'), '"']);
        end
        function SetOutputFolder(obj, NFSDirectoryPath)
            % Sets the output directory path where the NFS files should be located.
            obj.AddToHistory(['.SetOutputFolder "', num2str(NFSDirectoryPath, '%.15g'), '"']);
        end
        function Export(obj, MonitorName, ExcitationString)
            % Export the specified field source monitor of the excitation in the current project.
            obj.AddToHistory(['.Export "', num2str(MonitorName, '%.15g'), '", '...
                                      '"', num2str(ExcitationString, '%.15g'), '"']);

            % Prepend With NFSFile and append End With
            obj.history = [ 'With NFSFile', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.RunVBACode(obj.history);
            obj.history = [];
        end
        function Write(obj, FSMFile, NFSDirectoryPath)
            % Converts FSM-file to NFS-files, that will be saved in the specified directory. An absolute path has to be specified.
            obj.AddToHistory(['.Write "', num2str(FSMFile, '%.15g'), '", '...
                                     '"', num2str(NFSDirectoryPath, '%.15g'), '"']);

            % Prepend With NFSFile and append End With
            obj.history = [ 'With NFSFile', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.RunVBACode(obj.history);
            obj.history = [];
        end
        %% CST 2014 Functions.
        function SetNFSDirectory(obj, NFSDirectoryPath)
            % Sets the output directory path where the NFS files should be located.
            obj.AddToHistory(['.SetNFSDirectory "', num2str(NFSDirectoryPath, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hNFSFile
        history

    end
end

%% Default Settings
% SetOutputFolder('<Path to FSM-file>\<FSM-filename without file-ending(.fsm)>\');
% SetCoarsening(1)
% SetInteractive(1)
% DeleteFolderIfPresent(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% % Convert an FSM-file by directly specifying the filename and output folder
% nfsfile = project.NFSFile();
%     nfsfile.Write('C:\Path\To\Some\Monitorfile.fsm', 'C:\Output');
%
% % Export the monitor named('my_monitor'); with excitation string('1'); to the path('C:\nfs-export\');.
% % Set the mesh half as dense as the mesh on the field source monitor surface.
%     nfsfile.Reset
%     nfsfile.SetCoarsening(2)
%     nfsfile.SetOutputFolder('C:\nfs-export');
%     nfsfile.Export('my_monitor', '1');
%
