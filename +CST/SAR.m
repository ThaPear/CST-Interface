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

% The Specific Absorption Rate (SAR) is defined as the time derivative of the incremental energy (dW) absorbed by an incremental mass (dm) contained in a volume element (dV) of a given mass density (r). The SAR calculation is done as a post-processing step after the simulation, based on a previously defined power loss density monitor.
classdef SAR < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.SAR object.
        function obj = SAR(project, hProject)
            obj.project = project;
            obj.hSAR = hProject.invoke('SAR');
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
            % Resets all internal values to their default settings.
            obj.AddToHistory(['.Reset']);

            obj.label = [];
        end
        function PowerlossMonitor(obj, sName)
            % Defines the power loss density monitor that is used for the SAR calculation.
            obj.AddToHistory(['.PowerlossMonitor "', num2str(sName, '%.15g'), '"']);
        end
        function AverageWeight(obj, dValue)
            % Local SAR values refer to a certain volume element, specified by an averaged weight value. Here a cuboid volume is used to calculate the averaged tissue weight, which must be between 0.0001g and 5000g. Default is 10g.
            obj.AddToHistory(['.AverageWeight "', num2str(dValue, '%.15g'), '"']);
        end
        function Volume(obj, xmin, xmax, ymin, ymax, zmin, zmax)
            % Specifies the volume for which the SAR calculation is performed.
            obj.AddToHistory(['.Volume "', num2str(xmin, '%.15g'), '", '...
                                      '"', num2str(xmax, '%.15g'), '", '...
                                      '"', num2str(ymin, '%.15g'), '", '...
                                      '"', num2str(ymax, '%.15g'), '", '...
                                      '"', num2str(zmin, '%.15g'), '", '...
                                      '"', num2str(zmax, '%.15g'), '"']);
        end
        function SetLabel(obj, sName)
            % Sets the label for the SAR result files and tree entry.
            obj.AddToHistory(['.SetLabel "', num2str(sName, '%.15g'), '"']);
            obj.label = sName;
        end
        function SetOption(obj, option)
            % Can set options before executing calculation. Available options are:
            % - "no subvolume": does not use any subvolume specification
            % - "use subvolume for statistics"
            % - "subvolume only": limits the SAR calculation on the user defined volume to save execution time.
            % - "rescale double": The results are scaled to the specified input power value in W.
            % - "no rescale"
            % - "scale accepted": Define accepted power as reference.
            % - "scale stimulated": Define stimulated power as reference.
            % - "volaccuracy <value>": Sets the fractional accuracy of the averaging volume to <value>.
            % - "use ar results": The balance from an AR-filter calculation is used, if corresponding results are available.
            % - "no ar results": The standard balance is used.
            % The averaging method can be set by the name as seen in the specials dialog.
            obj.AddToHistory(['.SetOption "', num2str(option, '%.15g'), '"']);
        end
        function double = GetValue(obj, name)
            % Takes the name of a SAR calculation result (as in the SAR dialog box) as a string and delivers the corresponding value. (always rms)
            % - "stimulation"
            % - "accepted"
            % - "volume"
            % - "tissue volume"
            % - "tissue mass"
            % - "power"
            % - "average power"
            % - "total sar"
            % - "point sar"
            % - "max sar"
            % - "max sar x"
            % - "max sar y"
            % - "max sar z"
            % - "avg vol min x"
            % - "avg vol min y"
            % - "avg vol min z"
            % - "avg vol max x"
            % - "avg vol max y"
            % - "avg vol max z"
            % - "sel volume"
            % - "sel tissue volume"
            % - "sel tissue mass"
            % - "sel power"
            % - "sel average power"
            % - "sel total sar"
            % - "sel point sar"
            % - "sel max sar"
            % - "sel max sar x"
            % - "sel max sar y"
            % - "sel max sar z"
            double = obj.hSAR.invoke('GetValue', name);
        end
        function Create(obj)
            % Executes the SAR calculation. All necessary settings have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With SAR and append End With
            obj.history = [ 'With SAR', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define SAR: ', obj.label], obj.history);
            obj.history = [];
        end
        function Load(obj)
            % Loads the SAR result file previously specified by SetLabel. Use GetValue to query the desired result value.
            obj.AddToHistory(['.Load']);

            % Prepend With SAR and append End With
            obj.history = [ 'With SAR', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['load SAR: ', obj.label], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hSAR
        history

        label
    end
end

%% Default Settings
% AverageWeight(10)
% SetOption('IEEE C95.3');
% SetOption('no rescale');
% SetOption('no subvolume');
% SetOption('volaccuracy 0.05');

%% Example - Taken from CST documentation and translated to MATLAB.
% sar = project.SAR();
% sar.Reset();
% sar.PowerlossMonitor('loss(f=1.8) [pw]');
% sar.AverageWeight(8)
% sar.SetOption('CST C95.3');
% sar.SetOption('rescale 1.0');
% sar.SetOption('scale accepted');
% sar.Create();
% disp(num2str(sar.GetValue('max sar')));
%
