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

% This object offers the possibility to calculate a sensitivity analysis for the defined parameters.
classdef SensitivityAnalysis < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.SensitivityAnalysis object.
        function obj = SensitivityAnalysis(project, hProject)
            obj.project = project;
            obj.hSensitivityAnalysis = hProject.invoke('SensitivityAnalysis');
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
        function ResetParameterList(obj)
            % Resets the sensitivity analysis parameter list. All sensitivity analysis parameter items will be deleted from the list.
            obj.AddToHistory(['.ResetParameterList']);
            obj.nparams = 0;
        end
        function Parameter(obj, parametername, active)
            % Defines a sensitivity analysis parameter with a parametername. Acitve identifies whether the parameter is used for the sensitivity analysis.
            obj.AddToHistory(['.Parameter "', num2str(parametername, '%.15g'), '", '...
                                         '"', num2str(active, '%.15g'), '"']);
            obj.nparams = obj.nparams + 1;
        end
        function NumberOfFrequencySamples(obj, value)
            % Sets the number of frequency values used while running the sensitivity analysis for time domain. The default is currently 21. Increasing this value might improve the accuracy of the sensitivity analysis. (This applies only to the time domain solver).
            obj.AddToHistory(['.NumberOfFrequencySamples "', num2str(value, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the sensitivity analysis parameter items and adds them to the sensitivity analysis parameter list. All necessary settings for the parameters have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With SensitivityAnalysis and append End With
            obj.history = [ 'With SensitivityAnalysis', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define SensitivityAnalysis with ', num2str(obj.nparams, '%.15g'), ' parameters'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hSensitivityAnalysis
        history

        nparams
    end
end

%% Default Settings

%% Example - Taken from CST documentation and translated to MATLAB.
% sensitivityanalysis = project.SensitivityAnalysis();
%     sensitivityanalysis.ResetParameterList
%     sensitivityanalysis.Parameter('facedistance_1', '1');
%     sensitivityanalysis.Parameter('faceradius_1', '1');
%     sensitivityanalysis.Create
