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

% The object is used to consider imported temperature fields for the mechanical solver.
classdef MechFieldSettings < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.MechFieldSettings object.
        function obj = MechFieldSettings(project, hProject)
            obj.project = project;
            obj.hMechFieldSettings = hProject.invoke('MechFieldSettings');
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
        function ResetAll(obj)
            % Deletes all previously made definitions.
            obj.project.AddToHistory(['MechFieldSettings.ResetAll']);
        end
        function Reset(obj)
            % Resets the recently made settings for Name, Factor  and Active to the default values.
            obj.AddToHistory(['.Reset']);
        end
        function Name(obj, name)
            % Sets the name of the new import-definition. This name must be equal to the name of the field import.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
        end
        function Factor(obj, factor)
            % Allows to scale the imported field with a constant value.
            obj.AddToHistory(['.Factor "', num2str(factor, '%.15g'), '"']);
        end
        function Active(obj, flag)
            % Allows to activate or deactivate the definition for a certain field import.
            obj.AddToHistory(['.Active "', num2str(flag, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the import-definition with the previously made settings.
            obj.AddToHistory(['.Create']);
            
            % Prepend With MechFieldSettings and append End With
            obj.history = [ 'With MechFieldSettings', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define MechFieldSettings'], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the specified import-definition.
            obj.AddToHistory(['.Delete "', num2str(name, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hMechFieldSettings
        history

    end
end

%% Default Settings
% Name('');
% Factor('1.0');
% Active('0');

%% Example - Taken from CST documentation and translated to MATLAB.
% mechfieldsettings = project.MechFieldSettings();
%     mechfieldsettings.ResetAll
%     mechfieldsettings.Reset
%     mechfieldsettings.Name('temperature');
%     mechfieldsettings.Factor('1.0');
%     mechfieldsettings.Active('1');
%     mechfieldsettings.Create
