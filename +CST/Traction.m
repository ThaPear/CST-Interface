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

% Defines a new traction boundary condition on one or more faces.
classdef Traction < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Traction object.
        function obj = Traction(project, hProject)
            obj.project = project;
            obj.hTraction = hProject.invoke('Traction');
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
            % Sets the name of the new traction boundary.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Value(obj, valueX, valueY, valueZ)
            % Sets the components of the traction in a cartesian coordinate system.
            obj.AddToHistory(['.Value "', num2str(valueX, '%.15g'), '", '...
                                     '"', num2str(valueY, '%.15g'), '", '...
                                     '"', num2str(valueZ, '%.15g'), '"']);
        end
        function NormalValue(obj, value)
            % Sets the components of the traction oriented normally to a body's surface.
            obj.AddToHistory(['.NormalValue "', num2str(value, '%.15g'), '"']);
        end
        function UseValue(obj, useX, useY, useZ)
            % Allows to deactivate certain components of the traction definition, so that these deactivated components are not fixed anymore.
            obj.AddToHistory(['.UseValue "', num2str(useX, '%.15g'), '", '...
                                        '"', num2str(useY, '%.15g'), '", '...
                                        '"', num2str(useZ, '%.15g'), '"']);
        end
        function AddFace(obj, solidname, faceid)
            % Adds a face from a solid by its face id, where the source is mapped to.
            obj.AddToHistory(['.AddFace "', num2str(solidname, '%.15g'), '", '...
                                       '"', num2str(faceid, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the source with the previously made settings.
            obj.AddToHistory(['.Create']);

            % Prepend With Traction and append End With
            obj.history = [ 'With Traction', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Traction'], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the specified traction boundary.
            obj.project.AddToHistory(['Traction.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the specified traction boundary.
            obj.project.AddToHistory(['Traction.Rename "', num2str(oldname, '%.15g'), '", '...
                                                      '"', num2str(newname, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTraction
        history

        name
    end
end

%% Default Settings
% Name('');
% Value('0.0', '0.0', '0.0');
% UseValue('1', '1', '1');
% AddFace('', 0)

%% Example - Taken from CST documentation and translated to MATLAB.
% traction = project.Traction();
%     traction.Reset
%     traction.Name('traction1');
%     traction.Value('1.0', '0.0', '0.0');
%     traction.UseValue('1', '1', '1');
%     traction.AddFace('component1:solid1', '1');
%     traction.Create
