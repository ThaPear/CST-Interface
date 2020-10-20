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

% Use this object to create new moving media items for the thermal solver.
classdef MovingMedia < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.MovingMedia object.
        function obj = MovingMedia(project, hProject)
            obj.project = project;
            obj.hMovingMedia = hProject.invoke('MovingMedia');
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
            % Resets all internal settings of the moving media item to their default values.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Name(obj, name)
            % Specifies the name of the moving media item.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function AddFace(obj, solidname, faceid)
            % A moving media item can be defined on several solids. This method adds a face (indicated by its faceid) of a certain solid (indicated by its solidname) to the face list for the moving media item. Actually, the whole solidname is selected.
            obj.AddToHistory(['.AddFace "', num2str(solidname, '%.15g'), '", '...
                                       '"', num2str(faceid, '%.15g'), '"']);
        end
        function VelocityVector(obj, x_component, y_component, z_component, units)
            % Defines the velocity vector for the moving media.
            % units: 'm/s'
            %        'km/h'
            obj.AddToHistory(['.VelocityVector "', num2str(x_component, '%.15g'), '", '...
                                              '"', num2str(y_component, '%.15g'), '", '...
                                              '"', num2str(z_component, '%.15g'), '", '...
                                              '"', num2str(units, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new moving media item with its previously made settings.
            obj.AddToHistory(['.Create']);

            % Prepend With MovingMedia and append End With
            obj.history = [ 'With MovingMedia', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define MovingMedia: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the moving media item with the given name.
            obj.project.AddToHistory(['MovingMedia.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the moving media item with the given oldname to the defined newname.
            obj.project.AddToHistory(['MovingMedia.Rename "', num2str(oldname, '%.15g'), '", '...
                                                         '"', num2str(newname, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hMovingMedia
        history

        name
    end
end

%% Default Settings
% Name('');
% VelocityVector('0', '0', '0', 'm/s');

%% Example - Taken from CST documentation and translated to MATLAB.
% movingmedia = project.MovingMedia();
%     movingmedia.Reset
%     movingmedia.Name('translation1');
%     movingmedia.AddFace('component1:solid2', '1');
%     movingmedia.AddFace('component1:solid1', '2');
%     movingmedia.VelocityVector('0', '10', '0', 'm/s');
%     movingmedia.Create
