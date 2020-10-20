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

% Defines a new charge source on a solid or sheet.
classdef Charge < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Charge object.
        function obj = Charge(project, hProject)
            obj.project = project;
            obj.hCharge = hProject.invoke('Charge');
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
        function Value(obj, chargevalue)
            % Sets  the total charge or charge density, depending if valuetype "Integral" or "Density" was chosen.
            obj.AddToHistory(['.Value "', num2str(chargevalue, '%.15g'), '"']);
        end
        function ValueType(obj, type)
            % Specify if the charge value is defined as an integral type or a density type.
            % type: 'Integral'
            %       'Density'
            obj.AddToHistory(['.ValueType "', num2str(type, '%.15g'), '"']);
        end
        function Face(obj, solidname, faceid)
            % Selects a face from a solid by its face id, where the source is mapped to.
            obj.AddToHistory(['.Face "', num2str(solidname, '%.15g'), '", '...
                                    '"', num2str(faceid, '%.15g'), '"']);
        end
        function Type(obj, type)
            % Select one of the following types:
            % "PEC"       Charge source on a perfect electric conductor.
            % "Volume"    Homogeneous volume charge on a dielectric body.
            % "Surface"   Homogeneous suface charge on a dielectric body.
            obj.AddToHistory(['.Type "', num2str(type, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the source with the previously made settings.
            obj.AddToHistory(['.Create']);

            % Prepend With Charge and append End With
            obj.history = [ 'With Charge', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Charge: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the specified charge source.
            obj.project.AddToHistory(['Charge.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the specified charge.
            obj.project.AddToHistory(['Charge.Rename "', num2str(oldname, '%.15g'), '", '...
                                                    '"', num2str(newname, '%.15g'), '"']);
        end
        function type = GetType(obj, name)
            % Returns the type ("PEC", "Volume" or "Surface") of a charge source with a given name.
            type = obj.hCharge.invoke('GetType', name);
        end
        function type = GetValueType(obj, name)
            % Returns the value type ("Integral" or "Density") of a charge source with a given name.
            type = obj.hCharge.invoke('GetValueType', name);
        end
        function chargevalue = GetValue(obj, name)
            % Returns the value of a charge source with a given name.
            chargevalue = obj.hCharge.invoke('GetValue', name);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCharge
        history

        name
    end
end

%% Default Settings
% Value('0');
% ValueType('Integral');
% Type('PEC');
% Face('', 0)

%% Example - Taken from CST documentation and translated to MATLAB.
% charge = project.Charge();
%     charge.Reset
%     charge.Name('charge1');
%     charge.Value('0');
%     charge.Face('component1:solid2', '1');
%     charge.Type('PEC');
%     charge.Create
