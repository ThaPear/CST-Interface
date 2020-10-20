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

% Import part file (including sheet metal parts) or an entire assembly from Solid Edge.
classdef SolidEdge < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.SolidEdge object.
        function obj = SolidEdge(project, hProject)
            obj.project = project;
            obj.hSolidEdge = hProject.invoke('SolidEdge');
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
            % Sets the name of the imported file. File can represent either a part  (file extension: par) or a sheet metal part (file extension: psm) or an assembly (file extension: asm).
            obj.AddToHistory(['.FileName "', num2str(filename, '%.15g'), '"']);
            obj.filename = filename;
        end
        function Id(obj, id)
            % A CAD file may be imported more than once into the same project with different settings of import options. In order to improve the performance of structure rebuilds, an intermediate sat file is stored during the import process which allows to quickly re-read the data during rebuilds in case that the original CAD file has not been modified. The naming convention of the intermediate sat file has to be unique for each individual import step. Therefore, in case that the same file is imported more than once or a file with the same name is imported into the project, the Id setting needs to be increased. The Id will then be incorporated into the file name which ensures unique file names for every import.
            obj.AddToHistory(['.Id "', num2str(id, '%.15g'), '"']);
        end
        function Healing(obj, boolean)
            % If set to True structure will be healed after it is imported. Healing checks the imported structure and tries to repair it, if necessary.
            obj.AddToHistory(['.Healing "', num2str(boolean, '%.15g'), '"']);
        end
        function ScaleToUnit(obj, boolean)
            % If set to True the imported model is scaled to the currently active unit. If not activated the import feature uses the source units. In such a case, no scaling occurs.
            obj.AddToHistory(['.ScaleToUnit "', num2str(boolean, '%.15g'), '"']);
        end
        function Curves(obj, boolean)
            % If set to True curves will be imported from the import file.
            obj.AddToHistory(['.Curves "', num2str(boolean, '%.15g'), '"']);
        end
        function ImportAttributes(obj, boolean)
            % If set to True solid names, material names and material color will be read from the import file.
            obj.AddToHistory(['.ImportAttributes "', num2str(boolean, '%.15g'), '"']);
        end
        function ImportCurveAttributes(obj, boolean)
            % If set to True curve names will be read from the import file.
            obj.AddToHistory(['.ImportCurveAttributes "', num2str(boolean, '%.15g'), '"']);
        end
        function Read(obj)
            % Starts the actual import of the file.
            obj.AddToHistory(['.Read']);

            % Prepend With SolidEdge and append End With
            obj.history = [ 'With SolidEdge', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['import SolidEdge: ', obj.filename], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hSolidEdge
        history

        filename
    end
end

%% Default Settings
% FileName('');
% Healing(0)
% ScaleToUnit(0)
% ImportAttributes(0)
% Curves(0)
% ImportCurveAttributes(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% solidedge = project.SolidEdge();
%     solidedge.Reset
%     solidedge.FileName('.\example.par');
%     solidedge.ScaleToUnit(1)
%     solidedge.Id(1)
%     solidedge.Healing(1)
%     solidedge.ImportAttributes(1)
%     solidedge.Curves(1)
%     solidedge.ImportCurveAttributes(1)
%     solidedge.Read
