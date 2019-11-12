function Reset()
    % Resets the export options to the default.
end
function FileName(filename)
    % Sets the name of the exported file.
end
function Mode(type)
    % Use a fixed step width or a fixed number of samples for your data export. This settings are only available for 2D/3D field results.
end
function type can have one of  the following values:()
    % "FixedNumber"
    % Fixed number of samples
    % "FixedWidth"
    % Fixed step width
end
function SetfileType(type)
    % Set the file format for exports. This setting is only available for 2D/3D field results.
end
function type can have one of  the following values:()
    % "ascii"
    % ASCII format (default)
    % "csv"
    % csv format
    % "bix"
    % binary format
end
function SetCsvSeparator(val)
    % Set the separator for "csv"-formats. This settings is only available for 2D/3D field results.
end
function ExportCoordinatesInMeter(val)
    % if "val" is true, then the coordinates  will be exported in meter else in project unit.  This setting is only available for 2D/3D field results.
end
function Step(steps)
    % Number of steps or step width in all directions. Use the .Mode method to select the step definition. This setting is only available for 2D/3D field results.
end
function StepX(steps)
    % StepY ( int steps / double stepwidth )
    % StepZ ( int steps / double stepwidth )
    % Number of steps or step width in x / y / z-direction. Use the .Mode method to select the step definition. This settings are only available for 2D/3D field results.
end
function SetPointFile(name)
    % Set the file name of a file containing points that are used for the field evaluation and export.
end
function SetSubvolume(xmin, doublexmax, ymin, ymax, zmin, zmax)
    %        Define axis aligned sub volume for the volume exports. This setting is only available for 2D/3D field results.
end
function UseSubvolume(val)
    %         Activate or deactivate defined sub volume defined with the ".SetSubvolume" method..
end
function SetTimeRange(val_min, val_max)
    %         Set the time range for time dependent results. Times are expected in project units. This setting is only available for 2D/3D field results.
end
function SetSampleRange(val_min, val_max)
    %         Set the time sample range for time dependent results.  This setting is only available for 2D/3D field results.
end
function Execute()
    % Performs the ASCIIExport.
end

%% Default Settings% FileName('');
% Mode('FixedWidth');
% Step(-1)
% File type('ascii');

%% Example - Taken from CST documentation and translated to MATLAB.
% % The following script exports a file containing the electric field('e1');(if available)
% % The file will show 9 columns:
% %     3 for the positions(x, y, z) and
% %     6 for the electric field vector(3 x Re/Im)
% 
% % Select the desired monitor in the tree.
% project.SelectTreeItem('2D/3D Results\E-Field\e1');
% 
% asciiexport = project.ASCIIExport()
%     asciiexport.Reset
%     asciiexport.FileName('.\example.txt');
%     asciiexport.Mode('FixedNumber');
%     asciiexport.StepX(12)
%     asciiexport.StepY(12)
%     asciiexport.StepZ(8)
%     asciiexport.Execute
% 
