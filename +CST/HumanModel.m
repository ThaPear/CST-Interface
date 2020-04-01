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

% This command offers the import of voxel data sets.
classdef HumanModel < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.HumanModel object.
        function obj = HumanModel(project, hProject)
            obj.project = project;
            obj.hHumanModel = hProject.invoke('HumanModel');
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
            
            obj.filename = [];
        end
        function FileName(obj, filename)
            % Sets the name of the imported file.
            obj.AddToHistory(['.FileName "', num2str(filename, '%.15g'), '"']);
            obj.filename = filename;
        end
        function Tissue(obj, index, materialname, importvoxel, importmaterial)
            % This method selects a material, specified by its materialname to be imported. Please indicate with the importvoxel flag if the material is enabled or disabled for the voxel set. Furthermore, the state of the importmaterial flag determines if the material is added to the list of materials available for the current project.
            obj.AddToHistory(['.Tissue "', num2str(index, '%.15g'), '", '...
                                      '"', num2str(materialname, '%.15g'), '", '...
                                      '"', num2str(importvoxel, '%.15g'), '", '...
                                      '"', num2str(importmaterial, '%.15g'), '"']);
        end
        function Volume(obj, xmin, xmax, ymin, ymax, zmin, zmax)
            % Selects a part of the data set’s volume by defining limits relatively to the entire volume.
            obj.AddToHistory(['.Volume "', num2str(xmin, '%.15g'), '", '...
                                      '"', num2str(xmax, '%.15g'), '", '...
                                      '"', num2str(ymin, '%.15g'), '", '...
                                      '"', num2str(ymax, '%.15g'), '", '...
                                      '"', num2str(zmin, '%.15g'), '", '...
                                      '"', num2str(zmax, '%.15g'), '"']);
        end
        function Priority(obj, priority)
            % Sets the mesh priority.
            obj.AddToHistory(['.Priority "', num2str(priority, '%.15g'), '"']);
        end
        function Scale(obj, xvalue, yvalue, zvalue)
            % Specifies the scale for the imported data set.
            obj.AddToHistory(['.Scale "', num2str(xvalue, '%.15g'), '", '...
                                     '"', num2str(yvalue, '%.15g'), '", '...
                                     '"', num2str(zvalue, '%.15g'), '"']);
        end
        function Resolution(obj, resolution)
            % Specifies the resolution of the imported data set. Possible values for resolution are 0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.007 and 0.008.
            obj.AddToHistory(['.Resolution "', num2str(resolution, '%.15g'), '"']);
        end
        function Frequency(obj, frequency)
            % Sets a single  frequency.
            obj.AddToHistory(['.Frequency "', num2str(frequency, '%.15g'), '"']);
        end
        function double = GetMIn(obj, dimension)
            % Get coordinate of the lower corner of the bounding box of the imported data set.
            double = obj.hHumanModel.invoke('GetMIn', dimension);
        end
        function double = GetMax(obj, dimension)
            % Get coordinate of the upper corner of the bounding box of the imported data set.
            double = obj.hHumanModel.invoke('GetMax', dimension);
        end
        function Read(obj)
            % Starts the actual import of the file.
            obj.AddToHistory(['.Read']);
            
            % Prepend With HumanModel and append End With
            obj.history = [ 'With HumanModel', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['import HumanModel: ', obj.filename], obj.history);
            obj.history = [];
        end
        function Modify(obj)
            % Applies the settings without reading the file again.
            obj.AddToHistory(['.Modify']);
            
            % Prepend With HumanModel and append End With
            obj.history = [ 'With HumanModel', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['modify HumanModel settings'], obj.history);
            obj.history = [];
        end
        function Delete(obj)
            % Deletes the previously imported human model data set.
            obj.project.AddToHistory(['HumanModel.Delete']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hHumanModel
        history

        filename
    end
end

%% Default Settings
% Volume(0.0, 1.0, 0.0, 1.0, 0.0, 1.0)
% Priority(0.0)
% Scale(-1.0, -1.0, -1.0)
% Subgrids(0)
% Resolution(0.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% humanmodel = project.HumanModel();
%     humanmodel.Reset
%     humanmodel.FileName('.\Human Model.vox');
%     humanmodel.Tissue(1, 'Marrow', 1, 1)
%     humanmodel.Tissue(3, 'Bones', 1, 1)
%     humanmodel.Volume(0.0, 1.0, 0.0, 1.0, 0.0, 1.0)
%     humanmodel.Resolution(0.008)
%     humanmodel.Subgrids(0)
%     humanmodel.Read
