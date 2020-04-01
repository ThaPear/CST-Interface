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

% This object is used to bend a planar sheet on a solid shape.
classdef Bending < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Bending object.
        function obj = Bending(project, hProject)
            obj.project = project;
            obj.hBending = hProject.invoke('Bending');
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
        function ParamSweepAndOptimizerChecksResult(obj, boolean)
            % To activate a check routine performed during a parameter sweep or optimizer calculation. The check verifies whether the sheets are entirely bent on the solid.
            obj.AddToHistory(['.ParamSweepAndOptimizerChecksResult "', num2str(boolean, '%.15g'), '"']);
        end
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);
            
            obj.sheet = [];
            obj.solid = [];
        end
        function Sheet(obj, sheetname)
            % Sets the name of the sheet to bend..
            obj.AddToHistory(['.Sheet "', num2str(sheetname, '%.15g'), '"']);
            obj.sheet = sheetname;
        end
        function Solid(obj, solidname)
            % Sets the name of the solid to bend on.
            obj.AddToHistory(['.Solid "', num2str(solidname, '%.15g'), '"']);
            obj.solid = solidname;
        end
        function Faces(obj, list)
            % Sets the list of faces to bend on. The faces are specified by the face ids. For example: "10,9,8,7".
            if(any(isnumeric(list)))
                % Convert MATLAB array to correct string format.
                list = strcat(strsplit(num2str(a)), ',');
                list = [list{:}];
                list = list(1:end-1);
            end
            obj.AddToHistory(['.Faces "', num2str(list, '%.15g'), '"']);
        end
        function Bend(obj)
            % Performs the bending operation.
            obj.AddToHistory(['.Bend']);
            
            % Prepend With Bending and append End With
            obj.history = [ 'With Bending', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Bending: ', obj.sheet, ' on ', obj.solid], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hBending
        history

        sheet
        solid
    end
end

%% Default Settings
% Sheet('');
% Solid('');
% Faces('');

%% Example - Taken from CST documentation and translated to MATLAB.
% bending = project.Bending();
% bending.Reset
% bending.Sheet('component1:sheet');
% bending.Solid('component2:solid1');
% bending.Faces('10,9,8,7');
% bending.Bend
