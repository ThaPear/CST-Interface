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
% Warning: Untested

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK>

% This object offers the possibility to calculate losses and as a result the Q-factor. It uses an H-field from a surface-loss-free solver run for calculation of surface losses. Dielectric losses are taken into account by either using the losses from a lossy solver run or applying the perturbation method in case of loss-free solver run. In both cases, lossy dielectric material properties have to be set before the solver run. For the surface losses, each material which was PEC in the surface-loss-free calculation can be set to a finite conductivity. Applying the calculation method, the losses and Q�s will be calculated for all solids. The losses are summed up for each material and for the total model.
classdef QFactor < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a QFactor object.
        function obj = QFactor(project, hProject)
            obj.project = project;
            obj.hQFactor = hProject.invoke('QFactor');
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
            % Sets all internal values to their defaults and deletes previous results.
            obj.AddToHistory(['.Reset']);
        end
        function Calculate(obj)
            % This method performs the calculation with the given settings. The results can be obtained using the different functions offered by the object.
            obj.AddToHistory(['.Calculate']);

            % Prepend With QFactor and append End With
            obj.history = [ 'With QFactor', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define QFactor'], obj.history);
            obj.history = [];
        end
        function SetHField(obj, sFieldName)
            % Specifies the magnetic field from the loss-free calculation. It is possible to choose 3d eigenmodes (i.e. "Mode 1") or any 3d h-field by their Navigation Tree path (i.e. "2D/3D Results\H-Field\h-field (f=10) [1]"). In case that there does not exist a corresponding electric field monitor, the magnetic and electric energy will be assumed to be identically.
            obj.AddToHistory(['.SetHField "', num2str(sFieldName, '%.15g'), '"']);
        end
        function SetConductivity(obj, name, value)
            % Defines the conductivity / mu to be used in the calculation for a specific material indicated by its name. Choose �**Cond. Enclosure**� to set the value for the background material and/or electric boundaries. The conductivity is set either by a numerical value or to infinity using �PEC�.
            obj.AddToHistory(['.SetConductivity "', num2str(name, '%.15g'), '", '...
                                               '"', num2str(value, '%.15g'), '"']);
        end
        function SetMu(obj, name, value)
            % Defines the conductivity / mu to be used in the calculation for a specific material indicated by its name. Choose �**Cond. Enclosure**� to set the value for the background material and/or electric boundaries. The conductivity is set either by a numerical value or to infinity using �PEC�.
            obj.AddToHistory(['.SetMu "', num2str(name, '%.15g'), '", '...
                                     '"', num2str(value, '%.15g'), '"']);
        end
        function double = GetTotalQ(obj)
            % Returns the value of total Q, Loss or Energy respectively after execution of the calculate method.
            double = obj.hQFactor.invoke('GetTotalQ');
        end
        function double = GetTotalLossRMS(obj)
            % Returns the value of total Q, Loss or Energy respectively after execution of the calculate method.
            double = obj.hQFactor.invoke('GetTotalLossRMS');
        end
        function double = GetTotalEnergy(obj)
            % Returns the value of total Q, Loss or Energy respectively after execution of the calculate method.
            double = obj.hQFactor.invoke('GetTotalEnergy');
        end
        function double = GetQ(obj, name)
            % Returns the value of Q or Loss respectively for an entity name. Supported values are:
            % name parameter
            % Return value
            % solidname ("componentname:solidname")
            % Q/loss of the entered solid
            % material ("materialname")
            % Integrated Q/loss of the entered material
            % **Cond. Enclosure**
            % Q/loss of the bounding box surface
            % **Volume Losses**
            % Integrated Q/loss of all volume losses
            % **Sum of Surface Losses**
            % Integrated Q/loss of all surface losses
            double = obj.hQFactor.invoke('GetQ', name);
        end
        function double = GetLossRMS(obj, name)
            % Returns the value of Q or Loss respectively for an entity name. Supported values are:
            % name parameter
            % Return value
            % solidname ("componentname:solidname")
            % Q/loss of the entered solid
            % material ("materialname")
            % Integrated Q/loss of the entered material
            % **Cond. Enclosure**
            % Q/loss of the bounding box surface
            % **Volume Losses**
            % Integrated Q/loss of all volume losses
            % **Sum of Surface Losses**
            % Integrated Q/loss of all surface losses
            double = obj.hQFactor.invoke('GetLossRMS', name);
        end
        function UseNewMethod(obj, boolean)
            % If switch is False, sets the old method for surface loss calculation.
            obj.AddToHistory(['.UseNewMethod "', num2str(boolean, '%.15g'), '"']);
        end
        function Save3DData(obj, boolean)
            % If switch is True, the calculate method will also save plotable 3D field data into the Navigation Tree under "2D/3D Results\Power Loss Dens".
            obj.AddToHistory(['.Save3DData "', num2str(boolean, '%.15g'), '"']);
        end
        function ASCIIExport(obj, sFileName)
            % This method offers ASCII export of the settings and results concerning the loss and Q-factor calculation into a file specified by sFileName. The data is listed for each solid separately together with the overall amount of the surface losses, the dielectric losses and the total losses.
            obj.AddToHistory(['.ASCIIExport "', num2str(sFileName, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hQFactor
        history

    end
end

%% Default Settings
% SetConductivity( * , '5.8e7');
% SetMu( * , 1.0 )

%% Example - Taken from CST documentation and translated to MATLAB.
% qfactor = project.QFactor();
% .Reset
% .SetHField('2D/3D Results\H-Field\hc05 [1]');
% .SetConductivity('PEC', 8e7)
% .SetMu('PEC', 10)
% .SetConductivity('**Cond. Enclosure**', 'PEC');
% .Calculate
% MsgBox Str$(.GetTotalQ)
% MsgBox Str$(.GetLoss('component1:solid1');)
% MsgBox Str$(.GetLoss('PEC');)
%
