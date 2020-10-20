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

% Defines a new permanent magnet on a solid.
classdef Magnet < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Magnet object.
        function obj = Magnet(project, hProject)
            obj.project = project;
            obj.hMagnet = hProject.invoke('Magnet');
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
            % Resets the default values.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Name(obj, name)
            % Sets the name of the new charge source.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function SetMagnetType(obj, type)
            % Sets the type of the magnetization. Available options are "Constant" or "Radial".
            % type: 'Constant'
            %       'Radial'
            obj.AddToHistory(['.SetMagnetType "', num2str(type, '%.15g'), '"']);
        end
        function XMagVector(obj, value)
            % Sets the x component of the remanent magnetization vector. Used only for constant magnets.
            obj.AddToHistory(['.XMagVector "', num2str(value, '%.15g'), '"']);
        end
        function YMagVector(obj, value)
            % Sets the y component of the remanent magnetization vector. Used only for constant magnets.
            obj.AddToHistory(['.YMagVector "', num2str(value, '%.15g'), '"']);
        end
        function ZMagVector(obj, value)
            % Sets the z component of the remanent magnetization vector. Used only for constant magnets.
            obj.AddToHistory(['.ZMagVector "', num2str(value, '%.15g'), '"']);
        end
        function XMagAxis(obj, value)
            % Sets the x component of the axis which is orthogonal to the radial field (z-axis of a local cylindrical coordinate system). Used only for radial magnets.
            obj.AddToHistory(['.XMagAxis "', num2str(value, '%.15g'), '"']);
        end
        function YMagAxis(obj, value)
            % Sets the y component of the axis which is orthogonal to the radial field (z-axis of a local cylindrical coordinate system). Used only for radial magnets.
            obj.AddToHistory(['.YMagAxis "', num2str(value, '%.15g'), '"']);
        end
        function ZMagAxis(obj, value)
            % Sets the z component of the axis which is orthogonal to the radial field (z-axis of a local cylindrical coordinate system). Used only for radial magnets.
            obj.AddToHistory(['.ZMagAxis "', num2str(value, '%.15g'), '"']);
        end
        function XMagOrigin(obj, value)
            % Sets the x component of the center of the radial field (origin of a local cylindrical coordinate system). Used only for radial magnets.
            obj.AddToHistory(['.XMagOrigin "', num2str(value, '%.15g'), '"']);
        end
        function YMagOrigin(obj, value)
            % Sets the y component of the center of the radial field (origin of a local cylindrical coordinate system). Used only for radial magnets.
            obj.AddToHistory(['.YMagOrigin "', num2str(value, '%.15g'), '"']);
        end
        function ZMagOrigin(obj, value)
            % Sets the z component of the center of the radial field (origin of a local cylindrical coordinate system). Used only for radial magnets.
            obj.AddToHistory(['.ZMagOrigin "', num2str(value, '%.15g'), '"']);
        end
        function InverseDir(obj, type)
            % Specifies whether the radial field points towards the origin (type = true) or outwards (type = false).
            obj.AddToHistory(['.InverseDir "', num2str(type, '%.15g'), '"']);
        end
        function Remanence(obj, value)
            % Sets the remanence flux density. Used only for radial magnets.
            obj.AddToHistory(['.Remanence "', num2str(value, '%.15g'), '"']);
        end
        function Face(obj, solidname, faceid)
            % Selects a face from a solid by its face id, where the source is mapped to.
            obj.AddToHistory(['.Face "', num2str(solidname, '%.15g'), '", '...
                                    '"', num2str(faceid, '%.15g'), '"']);
        end
        function Transformable(obj, type)
            % Specifies whether the magnetization orientation will be transformed correlating with potential transformations (translation/rotation/mirroring) applied to the underlying solid.
            obj.AddToHistory(['.Transformable "', num2str(type, '%.15g'), '"']);
        end
        function Repick(obj)
            % Activates the face repicking for a previously specified magnet.
            obj.AddToHistory(['.Repick']);

            % Prepend With Magnet and append End With
            obj.history = [ 'With Magnet', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['Magnet.Repick: ', obj.name], obj.history);
            obj.history = [];
        end
        function Create(obj)
            % Creates the source with the previously made settings.
            obj.AddToHistory(['.Create']);

            % Prepend With Magnet and append End With
            obj.history = [ 'With Magnet', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Magnet: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the specified magnet source.
            obj.project.AddToHistory(['Magnet.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the specified magnet.
            obj.project.AddToHistory(['Magnet.Rename "', num2str(oldname, '%.15g'), '", '...
                                                    '"', num2str(newname, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hMagnet
        history

        name
    end
end

%% Default Settings
% SetMagnetType('Constant');
% XMagVector('0');
% YMagVector('0');
% ZMagVector('0');
% XMagAxis('0');
% YMagAxis('0');
% ZMagAxis('0');
% XMagOrigin('0');
% YMagOrigin('0');
% ZMagOrigin('0');
% InverseDir('0');
% Remanence('0');
% Face('', 0)
% Remanence('0');

%% Example - Taken from CST documentation and translated to MATLAB.
% To define a constant, non-transformable magnet:
% magnet = project.Magnet();
%     magnet.Reset
%     magnet.Name('magnet1');
%     magnet.XMagVector('1');
%     magnet.YMagVector('0');
%     magnet.ZMagVector('0');
%     magnet.Face('component1:solid1', '1');
%     magnet.Create
%
% To define a radial, transformable magnet:
%     magnet.Reset
%     magnet.MagnetType('Radial');
%     magnet.Name('magnet1');
%     magnet.XMagAxis('0');
%     magnet.YMagAxis('0');
%     magnet.ZMagAxis('1');
%     magnet.XMagOrigin('0');
%     magnet.YMagOrigin('0');
%     magnet.ZMagOrigin('0');
%     magnet.Remanence('0');
%     magnet.Face('component1:solid1', '1');
%     magnet.Transformable('1');
%     magnet.Create
%
