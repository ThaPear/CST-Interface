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

% Defines a new potential on a PEC solid or sheet.
classdef Potential < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Potential object.
        function obj = Potential(project, hProject)
            obj.project = project;
            obj.hPotential = hProject.invoke('Potential');
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
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Name(obj, name)
            % Sets the name of the new potential source.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Value(obj, potentialvalue)
            % Sets  the potential value for a PEC solid which is specified by the face command.
            obj.AddToHistory(['.Value "', num2str(potentialvalue, '%.15g'), '"']);
        end
        function Phase(obj, phasevalue)
            % Sets  the phase value for a potential on a PEC solid. This setting is only considered when an electroquasistatic simulation is performed.
            obj.AddToHistory(['.Phase "', num2str(phasevalue, '%.15g'), '"']);
        end
        function AddFace(obj, solidname, faceid)
            % Selects a face from a solid by its face id, where the source is mapped to.
            obj.AddToHistory(['.AddFace "', num2str(solidname, '%.15g'), '", '...
                                       '"', num2str(faceid, '%.15g'), '"']);
        end
        function Type(obj, type)
            % Specifies the type of the potential. If a perfect electric conductor (PEC) unit has to be maintained at a specific potential, then set the potential type to "Fixed". Alternatively, the PEC unit can be made "Floating" meaning that this the corresponding unit has a constant charge..
            % type: 'Fixed'
            %       'Floating'
            obj.AddToHistory(['.Type "', num2str(type, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the source with the previously made settings.
            obj.AddToHistory(['.Create']);

            % Prepend With Potential and append End With
            obj.history = [ 'With Potential', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Potential: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the specified potential source.
            obj.project.AddToHistory(['Potential.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the specified potential.
            obj.project.AddToHistory(['Potential.Rename "', num2str(oldname, '%.15g'), '", '...
                                                       '"', num2str(newname, '%.15g'), '"']);
        end
        function type = GetType(obj, name)
            % Returns the type ("Fixed" or "Floating") of a potential source with a given name.
            type = obj.hPotential.invoke('GetType', name);
        end
        function potentialvalue = GetValue(obj, name)
            % Returns the value of a potential source with a given name.
            potentialvalue = obj.hPotential.invoke('GetValue', name);
        end
        function phasevalue = GetPhase(obj, name)
            % Returns the phase of a potential source with a given name.
            phasevalue = obj.hPotential.invoke('GetPhase', name);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPotential
        history

        name
    end
end

%% Default Settings
% Value('0');
% Face('', 0)

%% Example - Taken from CST documentation and translated to MATLAB.
% potential = project.Potential();
%     potential.Reset
%     potential.Name('potential1');
%     potential.Value('1');
%     potential.Phase('0');
%     potential.Face('component1:solid1', '1');
%     potential.Type('Fixed');
%     potential.Create
%
