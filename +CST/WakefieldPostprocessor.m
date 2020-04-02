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

% This Object is used to compute secondary results from previously computed wake-functions.
classdef WakefieldPostprocessor < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.WakefieldPostprocessor object.
        function obj = WakefieldPostprocessor(project, hProject)
            obj.project = project;
            obj.hWakefieldPostprocessor = hProject.invoke('WakefieldPostprocessor');
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
        end
        function Resultname(obj, name)
            % Name for the new post-processing result.
            obj.AddToHistory(['.Resultname "', num2str(name, '%.15g'), '"']);
        end
        function UseFFT(obj, bool, flag)
            % Allows to use a FFT instead of a DFT for the fourier transformation of the wake signals. The FFT is much faster but less flexible than the DFT.
            obj.AddToHistory(['.UseFFT "', num2str(bool, '%.15g'), '", '...
                                      '"', num2str(flag, '%.15g'), '"']);
        end
        function ParticleBeam(obj, name)
            % Selects a wake-function for a certain particle beam source.
            obj.AddToHistory(['.ParticleBeam "', num2str(name, '%.15g'), '"']);
        end
        function Fmin(obj, value)
            % Sets the minimum frequency value for a wake-impedance spectrum calculation. Only active if UseFFT is set to "False".
            obj.AddToHistory(['.Fmin "', num2str(value, '%.15g'), '"']);
        end
        function Fmax(obj, value)
            % Sets the maximum frequency value for a wake-impedance spectrum calculation. Only active if UseFFT is set to "False".
            obj.AddToHistory(['.Fmax "', num2str(value, '%.15g'), '"']);
        end
        function FrequencySteps(obj, steps)
            % Sets the number of frequency samples for a wake-impedance calculation. Only active if UseFFT is set to "False".
            obj.AddToHistory(['.FrequencySteps "', num2str(steps, '%.15g'), '"']);
        end
        function Filter(obj, type)
            % Sets the type of pre-filtering for a wake impedance calculation. Currently "None" and "Cos2" is available.
            obj.AddToHistory(['.Filter "', num2str(type, '%.15g'), '"']);
        end
        function FilterParameter(obj, parameterindex, value)
            % Sets the filter parameters for a certain type of pre-filter.
            %   
            % Filtertype  Parameters
            % None        ---
            % Cos2        #1: The rolloff-factor with a range from 0 to 1.
            % Note: The parameter-index must be equal or larger than one.
            obj.AddToHistory(['.FilterParameter "', num2str(parameterindex, '%.15g'), '", '...
                                               '"', num2str(value, '%.15g'), '"']);
        end
        function Calculate(obj, calculationtype)
            % Sets the type of the wake post-processing step. Currently only "ImpedanceSpectrum" is available.
            obj.AddToHistory(['.Calculate "', num2str(calculationtype, '%.15g'), '"']);
            
            % Prepend With WakefieldPostprocessor and append End With
            obj.history = [ 'With WakefieldPostprocessor', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define WakefieldPostprocessor'], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hWakefieldPostprocessor
        history

    end
end

%% Default Settings
% ResultName('');
% ParticleBeam('');
% Fmin('');
% Fmax('');
% FrequencySteps('1000');
% Filter('None');

%% Example - Taken from CST documentation and translated to MATLAB.
% wakefieldpostprocessor = project.WakefieldPostprocessor();
%     wakefieldpostprocessor.Reset
%     wakefieldpostprocessor.ResultName('FirstResonance');
%     wakefieldpostprocessor.Fmin('1.3e9');
%     wakefieldpostprocessor.Fmax('1.35e9');
%     wakefieldpostprocessor.FrequencySteps('2000');
%     wakefieldpostprocessor.Filter('Cos2');
%     wakefieldpostprocessor.FilterParameter('1', '0.2');
%     wakefieldpostprocessor.Calculate('ImpedanceSpectrum');
% 
