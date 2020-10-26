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

% NOTE: This object was introduced in CST 2020.
% This object is used to create a new lid object or a new opening for the multifluid support of the Conjugate Heat Transfer Solver.
% Lids should close a fluid domain. A lid which is not related to a fluid domain will be ignored in the simulation.
% Openings should be surrounded by background material and not be associated to fluid domains.
classdef InteriorBoundary < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.InteriorBoundary object.
        function obj = InteriorBoundary(project, hProject)
            obj.project = project;
            obj.hInteriorBoundary = hProject.invoke('InteriorBoundary');
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
            % Resets all internal settings of the interior boundary (lid or opening) to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function Name(obj, name)
            % Specifies the name of the interior boundary. Each lid and each opening must have a unique name
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
        end
        function AddFace(obj, solidname, faceid)
            % Defines a face inside the calculation domain. For openings, the face should be surrounded by background. A lid face should close a fluid domain cavity.
            % It might be necessary to define multiple lids in order to completely close a fluid domain. Mind that fluid domains which are not completely closed by lids are not supported.
            % Each face belonging to the interior boundary must be specified by its faceid of the solid with name solidname.
            obj.AddToHistory(['.AddFace "', num2str(solidname, '%.15g'), '", '...
                                       '"', num2str(faceid, '%.15g'), '"']);
        end
        function Set(obj, what, parameters)
            % Defines the parameters of the interior opening. The following settings are available:
            % "BoundaryType" or "Boundary Type"       The boundary type considered only for lids and ignored for openings. Openings are always "open".
            %                                         The boundary type is passed as second parameter, e.g. .Set "BoundaryType", "wall: isothermal".
            %         Available boundary types are:
            %         "open"                                  The flow temperature or temperature gradient and the flow velocity, gauge pressure or volume flow rate can be set.
            %                                                 The opening emissivity is set to one.
            %         "wall: isothermal"                      Heat can pass this type of boundary, but the temperature is constant.
            %         "wall: adiabatic"                       No heat flow passes this boundary condition. The temperature distribution is not constant.
            %
            % "Temperature"                           This setting is ignored by lids of type "wall: adiabatic". The second parameter specifies the way in which the temperature is prescribed.
            %         Available types are:
            %         "unset"                                 Supported only for open boundary types. In this case the flow temperature gradient is zero.
            %         "ambient"                               The ambient temperature, which is set in the solver parameter settings, will be used for the fluid.
            %         "fixed"                                 A user-defined fixed value can be assigned to the fluid. In this case two further parameters are required: string value, enum unit, where unit is either "Kelvin" or "Celsius" or "Fahrenheit".
            %
            % "WallfFlow" or  "Wall Flow"             This setting is relevant only for lids with boundary type "wall: adiabatic" or "wall: isothermal". A slip or no-slip boundary condition can be applied to a lid to describe the flow behavior at the wall. The slip boundary condition sets the tangential velocity gradient to zero at the wall which implies that the flow encounters no friction at the wall and thus doesn't slow down. Conversely, the no-slip boundary condition sets the tangential velocity to zero at the wall which implies that the wall friction slows down the flow. The no-slip boundary condition is typically used to model a physical wall.
            %                                         This wall flow boundary condition is passed as a second parameter, e.g. .Set "WallFlow", "no-slip".
            %
            % "Emissivity"                            This setting is considered only for lids with boundary type "wall: isothermal". For other boundary types default values will be used according to the table below. Please note that radiation properties are used only when radiation is turned on in the CHT Solver Parameters.
            %                                         The emissivity value is passed as a second parameter, e.g. .Set "Radiation", "0.8".
            %         "wall: isothermal"                      The emissivity is set to the value specified by the user.  The wall temperature value is used as the reference temperature.
            %         "wall: adiabatic"                       The emissivity is set to 0.
            %         "open"                                  The radiation temperature define in the CHT Solver Parameters is used as the reference temperature.
            %
            % "Velocity"                              This setting is considered only for openings or lids with boundary type "open". The settings for "Velocity", "Pressure" and "VolumeFlowRate" are exclusive. The last settings wins over the others.
            %                                         With further parameters, the veloctiy vector and a unit ("m/s" or "km/h") can be specified, e.g. .Set "Velocity", "0", "0", "10", "km/h".
            % "Pressure"                              This setting is considered only for openings or lids with boundary type "open". The settings for "Velocity", "Pressure" and "VolumeFlowRate" are exclusive. The last settings wins over the others.
            %                                         With further parameters, the fluid gauge pressure at the interior boundary can be set to a fixed value and the corresponding unit ("atm", "bar", "Pa", "psi"), e.g. .Set "Pressure", "5", "bar".
            % "VolumeFlowRate" or "Volume Flow Rate"  This setting is considered only for openings or lids with boundary type "open". The settings for "Velocity", "Pressure" and "VolumeFlowRate" are exclusive. The last settings wins over the others.
            %                                         With further parameters, the volume flow rate (and optionally its unit "m^3/h" or "m3/h") can be specified, e.g. .Set "VolumeFlowRate", "1", "m3/h".
            obj.AddToHistory(['.Set "', num2str(what, '%.15g'), '", '...
                                   '"', num2str(parameters, '%.15g'), '"']);
        end
        function Create(obj, type)
            % Creates the interior boundary with its previously made settings. It has to be specified which type of interior boundary is created:
            % "Opening"   Define an interior opening. An opening should be surrounded by background.
            % "Lid"       Define a lid. A lid should close a fluid domain.
            obj.AddToHistory(['.Create "', num2str(type, '%.15g'), '"']);

            % Prepend With InteriorBoundary and append End With
            obj.history = [ 'With InteriorBoundary', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define InteriorBoundary'], obj.history);
            obj.history = [];
        end
        function Delete(obj, type, name)
            % Deletes the interior boundary of the specified type ("Opening" or "Lid") with the given name.
            obj.project.AddToHistory(['InteriorBoundary.Delete "', num2str(type, '%.15g'), '", '...
                                                              '"', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, type, oldname, newname)
            % Renames the interior boundary of the specified type ("Opening" or "Lid") with the given oldname to the defined newname.
            obj.project.AddToHistory(['InteriorBoundary.Rename "', num2str(type, '%.15g'), '", '...
                                                              '"', num2str(oldname, '%.15g'), '", '...
                                                              '"', num2str(newname, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hInteriorBoundary
        history

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% interiorboundary = project.InteriorBoundary();
%     interiorboundary.Reset
%     interiorboundary.Name('lid_outlet');
%     interiorboundary.AddFace('Background:lid_outlet', '3');
%     interiorboundary.Set('BoundaryType', 'open');
%     interiorboundary.Set('Temperature', 'unset');
%     interiorboundary.Set('Pressure', '0.0', 'Pa');
%     interiorboundary.Create('Lid');
%
%     interiorboundary.Reset
%     interiorboundary.Name('flow_condition');
%     interiorboundary.AddFace('Background:opening_inlet', '3');
%     interiorboundary.Set('Temperature', 'Fixed', '16', 'Celsius');
%     interiorboundary.Set('VolumeFlowRate');', '0.19', 'm3/h');
%     interiorboundary.Create('Opening');
%
%
