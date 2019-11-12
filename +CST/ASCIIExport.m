%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Export result data as an ASCII file.
classdef ASCIIExport < handle
    properties(SetAccess = protected)
        project
        hASCIIExport
        
        filename
        mode
        type
        csvseparator
        exportcoordinatesinmeter
        step
        stepx, stepy, stepz
        xmin, xmax, ymin, ymax, zmin, zmax
        usesubvolume
        tmin, tmax
        samplemin, samplemax
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ASCIIExport object.
        function obj = ASCIIExport(project, hProject)
            obj.project = project;
            obj.hASCIIExport = hProject.invoke('ASCIIExport');
            
            obj.Reset();
        end
    end
    
    methods
        function Reset(obj)
            % Resets the export options to the default.
            obj.hASCIIExport.invoke('Reset');
            
            obj.filename = '';
            obj.mode = 'FixedWidth';
            obj.type = 'ascii';
            obj.exportcoordinatesinmeter = 0;
            obj.step = -1;
            obj.stepx = -1; obj.stepy = -1; obj.stepz = -1;
            obj.tmin = 0; obj.tmax = 0;
            obj.samplemin = 0; obj.samplemax = 0;
        end
        function FileName(obj, filename)
            % Sets the name of the exported file.
            obj.hASCIIExport.invoke('FileName', filename);
            obj.filename = filename;
        end
        function Mode(obj, mode)
            % Use a fixed step width or a fixed number of samples for your
            % data export. This settings are only available for 2D/3D field
            % results.
            %
            % mode: 'FixedNumber' - Fixed number of samples
            %       'FixedWidth' - Fixed step width
            obj.hASCIIExport.invoke('Mode', mode);
            obj.mode = mode;
        end
        function SetFileType(obj, type)
            % Set the file format for exports. This setting is only available for 2D/3D field results.
            %
            % type: 'ascii' - ASCII format (default)
            %       'csv' - csv format
            %       'bix' - binary format
            obj.hASCIIExport.invoke('SetFileType', type);
            obj.type = type;
        end
        function SetCsvSeparator(obj, csvseparator)
            % Set the separator for "csv"-formats. This settings is only available for 2D/3D field results.
            %
            obj.hASCIIExport.invoke('SetCsvSeparator', csvseparator);
            obj.csvseparator = csvseparator;
        end
        function ExportCoordinatesInMeter(obj, boolean)
            % If 'boolean' is true, then the coordinates will be exported
            % in meter else in project unit. This setting is only available
            % for 2D/3D field results.
            obj.hASCIIExport.invoke('ExportCoordinatesInMeter', boolean);
            obj.exportcoordinatesinmeter = boolean;
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
            obj.step = step;
            obj.stepx = step;
            obj.stepy = step;
            obj.stepz = step;
        end
        function StepX(obj, stepx)
            % Number of steps or step width in x-direction. Use the .Mode
            % method to select the step definition. This settings are only
            % available for 2D/3D field results.
            obj.hASCIIExport.invoke('StepX', stepx);
            obj.stepx = stepx;
        end
        function StepY(obj, stepy)
            % Number of steps or step width in y-direction. Use the .Mode
            % method to select the step definition. This settings are only
            % available for 2D/3D field results.
            obj.hASCIIExport.invoke('StepY', stepy);
            obj.stepy = stepy;
        end
        function StepZ(obj, stepz)
            % Number of steps or step width in z-direction. Use the .Mode
            % method to select the step definition. This settings are only
            % available for 2D/3D field results.
            obj.hASCIIExport.invoke('StepZ', stepz);
            obj.stepz = stepz;
        end
        function SetPointFile(obj, filename)
            % Set the file name of a file containing points that are used
            % for the field evaluation and export.
            obj.hASCIIExport.invoke('SetPointFile', filename);
            obj.filename = filename;
        end
        function SetSubvolume(obj, xmin, xmax, ymin, ymax, zmin, zmax)
            % Define axis aligned sub volume for the volume exports. This
            % setting is only available for 2D/3D field results.
            obj.hASCIIExport.invoke('ParameterRange', xmin, xmax, ...
                                                      ymin, ymax, ...
                                                      zmin, zmax);
            obj.xmin = xmin; obj.xmax = xmax;
            obj.ymin = xmin; obj.ymax = ymax;
            obj.zmin = xmin; obj.zmax = zmax;
        end
        function UseSubvolume(obj, boolean)
            % Activate or deactivate defined sub volume defined with the
            % SetSubvolume method.
            obj.hASCIIExport.invoke('UseSubvolume', boolean);
            obj.usesubvolume = boolean;
        end
        function SetTimeRange(obj, tmin, tmax)
            % Set the time range for time dependent results. Times are
            % expected in project units. This setting is only available for
            % 2D/3D field results.
            obj.hASCIIExport.invoke('SetTimeRange', tmin, tmax);
            obj.tmin = tmin;
            obj.tmax = tmax;
        end
        function SetSampleRange(obj, samplemin, samplemax)
            % Set the time sample range for time dependent results.  This
            % setting is only available for 2D/3D field results.
            obj.hASCIIExport.invoke('SetSampleRange', samplemin, samplemax);
            obj.samplemin = samplemin;
            obj.samplemax = samplemax;
        end
        
        function Execute(obj)
            % Performs the ASCIIExport.
            obj.hASCIIExport.invoke('Execute');
        end
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