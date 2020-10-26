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

% Export result data as an ASCII file.
classdef ASCIIExport < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ASCIIExport object.
        function obj = ASCIIExport(project, hProject)
            obj.project = project;
            obj.hASCIIExport = hProject.invoke('ASCIIExport');

            obj.Reset();
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets the export options to the default.
            obj.hASCIIExport.invoke('Reset');
        end
        function FileName(obj, filename)
            % Sets the name of the exported file.
            obj.hASCIIExport.invoke('FileName', filename);
        end
        function Mode(obj, mode)
            % Use a fixed step width or a fixed number of samples for your
            % data export. This settings are only available for 2D/3D field
            % results.
            %
            % mode: 'FixedNumber' - Fixed number of samples
            %       'FixedWidth' - Fixed step width
            obj.hASCIIExport.invoke('Mode', mode);
        end
        function SetFileType(obj, type)
            % Set the file format for exports. This setting is only available for 2D/3D field results.
            %
            % type: 'ascii' - ASCII format (default)
            %       'csv' - csv format
            %       'bix' - binary format
            %       (2020) 'hdf5' - HDF5 format
            obj.hASCIIExport.invoke('SetFileType', type);
        end
        function SetCsvSeparator(obj, csvseparator)
            % Set the separator for "csv"-formats. This settings is only available for 2D/3D field results.
            %
            obj.hASCIIExport.invoke('SetCsvSeparator', csvseparator);
        end
        function ExportCoordinatesInMeter(obj, boolean)
            % If 'boolean' is true, then the coordinates will be exported
            % in meter else in project unit. This setting is only available
            % for 2D/3D field results.
            obj.hASCIIExport.invoke('ExportCoordinatesInMeter', boolean);
        end
        function Step(obj, step)
            % Number of steps or step width in all directions. Use the
            % .Mode method to select the step definition. This setting is
            % only available for 2D/3D field results.
            %
            % Depending on Mode:
            % FixedNumber: step = number of steps.
            % FixedWidth:  step = step width.
            obj.hASCIIExport.invoke('Step', step);
        end
        function StepX(obj, stepx)
            % Number of steps or step width in x-direction. Use the .Mode
            % method to select the step definition. This settings are only
            % available for 2D/3D field results.
            obj.hASCIIExport.invoke('StepX', stepx);
        end
        function StepY(obj, stepy)
            % Number of steps or step width in y-direction. Use the .Mode
            % method to select the step definition. This settings are only
            % available for 2D/3D field results.
            obj.hASCIIExport.invoke('StepY', stepy);
        end
        function StepZ(obj, stepz)
            % Number of steps or step width in z-direction. Use the .Mode
            % method to select the step definition. This settings are only
            % available for 2D/3D field results.
            obj.hASCIIExport.invoke('StepZ', stepz);
        end
        function SetPointFile(obj, filename)
            % Set the file name of a file containing points that are used
            % for the field evaluation and export.
            obj.hASCIIExport.invoke('SetPointFile', filename);
        end
        function SetSubvolume(obj, xmin, xmax, ymin, ymax, zmin, zmax)
            % Define axis aligned sub volume for the volume exports. This
            % setting is only available for 2D/3D field results.
            obj.hASCIIExport.invoke('ParameterRange', xmin, xmax, ...
                                                      ymin, ymax, ...
                                                      zmin, zmax);
        end
        function UseSubvolume(obj, boolean)
            % Activate or deactivate defined sub volume defined with the
            % SetSubvolume method.
            obj.hASCIIExport.invoke('UseSubvolume', boolean);
        end
        function SetTimeRange(obj, tmin, tmax)
            % Set the time range for time dependent results. Times are
            % expected in project units. This setting is only available for
            % 2D/3D field results.
            obj.hASCIIExport.invoke('SetTimeRange', tmin, tmax);
        end
        function SetSampleRange(obj, samplemin, samplemax)
            % Set the time sample range for time dependent results.  This
            % setting is only available for 2D/3D field results.
            obj.hASCIIExport.invoke('SetSampleRange', samplemin, samplemax);
        end
        function Execute(obj)
            % Performs the ASCIIExport.
            obj.hASCIIExport.invoke('Execute');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hASCIIExport

    end
end

%% Default settings.
% FileName('')
% Mode('FixedWidth')
% Step(-1)
% SetFileType('ascii')

%% Example - Taken from CST documentation and translated to MATLAB.
% % The following script exports a file containing the electric field  'e1' (if available)
% % The file will show 9 columns:
% %     3 for the positions (x, y, z) and
% %     6 for the electric field vector (3 x Re/Im)
% %
% % Select the desired monitor in the tree.
% project.SelectTreeItem('2D/3D Results\E-Field\e1')
%
% asciiexport = project.ASCIIExport();
%     asciiexport.Reset();
%     asciiexport.FileName('.\example.txt');
%     asciiexport.Mode('FixedNumber');
%     asciiexport.StepX(12);
%     asciiexport.StepY(12);
%     asciiexport.StepZ(8);
%     asciiexport.Execute();