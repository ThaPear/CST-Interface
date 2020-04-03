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

% Import a HFSS project.
classdef HFSS < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.HFSS object.
        function obj = HFSS(project, hProject)
            obj.project = project;
            obj.hHFSS = hProject.invoke('HFSS');
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
        function FilenameHFSS(obj, filename)
            % Sets the name of the hfss file.
            obj.AddToHistory(['.FilenameHFSS "', num2str(filename, '%.15g'), '"']);
            obj.filename = filename;
        end
        function FilenameSM3(obj, filename)
            % Sets the name of the sm3 file.
            obj.AddToHistory(['.FilenameSM3 "', num2str(filename, '%.15g'), '"']);
        end
        function Filename(obj, filename)
            % Sets the name of the sat file produced by the import.
            obj.AddToHistory(['.Filename "', num2str(filename, '%.15g'), '"']);
        end
        function Read(obj)
            % Starts the import of the selected files.
            obj.AddToHistory(['.Read']);
            
            % Prepend With HFSS and append End With
            obj.history = [ 'With HFSS', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define HFSS; ', obj.filename], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hHFSS
        history

        filename
    end
end

%% Default Settings
% FilenameHFSS('');
% FilenameSM3('');
% FilenameSM3('');

%% Example - Taken from CST documentation and translated to MATLAB.
% hfss = project.HFSS();
%     hfss.Reset
%     hfss.FilenameHFSS('*my_model.hfss');
%     hfss.FilenameSM3('*my_model.sm3');
%     hfss.Filename('*my_model.sat');
%     hfss.Read
% 
