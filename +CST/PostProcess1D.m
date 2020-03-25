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

% This object offers the possibility to apply  post-processing on 1D results.
classdef PostProcess1D < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.PostProcess1D object.
        function obj = PostProcess1D(project, hProject)
            obj.project = project;
            obj.hPostProcess1D = hProject.invoke('PostProcess1D');
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal values to their default settings.
            obj.hPostProcess1D.invoke('Reset');
        end
        function ApplyTo(obj, applyTarget)
            % Set the target data the post-processing should be applied to.
            % applyTarget: 'S-parameter'
            %              'Probes'
            %              'Monitors'
            obj.hPostProcess1D.invoke('ApplyTo', applyTarget);
        end
        function AddOperation(obj, operationType)
            % Add a post-processing operation to the PostProcess1D object. All added operations will be performed when calling the Run method.
            % operationType: 'Time Window'
            %                'AR-Filter'
            %                'Phase Deembedding'
            %                'Renormalization'
            %                'VSWR'
            %                'YZ-matrices'
            %                'Exclude Port Modes'
            obj.hPostProcess1D.invoke('AddOperation', operationType);
        end
        function SetDeembedDistance(obj, portName, distance)
            % Specify distance for phase deembedding for the port with port number portName.
            obj.hPostProcess1D.invoke('SetDeembedDistance', portName, distance);
        end
        function SetRenormImpedance(obj, portName, modeName, impedance)
            % Set the renormalization impedance for the specified port mode to impedance.
            obj.hPostProcess1D.invoke('SetRenormImpedance', portName, modeName, impedance);
        end
        function SetRenormImpedanceOnAllPorts(obj, impedance)
            % Set the renormalization impedance for all port modes to impedance.
            obj.hPostProcess1D.invoke('SetRenormImpedanceOnAllPorts', impedance);
        end
        function SetUnnormImpedanceOnAllPorts(obj)
            % Reset the renormalization impedance for all ports to its' original values.
            obj.hPostProcess1D.invoke('SetUnnormImpedanceOnAllPorts');
        end
        function SetConsiderPortMode(obj, portName, modeName, flag)
            % Set the flag if the specified port mode should be considered for post-processing or otherwise if it should be excluded. Please note, that if the specified port has the single-ended option switched on then all modes for this port are set to flag.
            obj.hPostProcess1D.invoke('SetConsiderPortMode', portName, modeName, flag);
        end
        function Run(obj)
            % Applies the desired 1D post-processing operations on the selected target data.
            % Note: a full set of operations can be applied only to S-parameters. For other types of data, only the AR-filter is useful.
            obj.hPostProcess1D.invoke('Run');
        end
        function ActivateOperation(obj, operationType, flag)
            % Activates a post-processing operation for later processing. All activated operations will be performed after a solver run. Please note, that currently only VSWR and YZ-matrices are supported with this command.
            % flag: 'VSWR'
            %       'YZ-matrices'
            obj.project.AddToHistory(['PostProcess1D.ActivateOperation "', operationType, '", "', num2str(flag, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPostProcess1D

    end
end

%% Default Settings
% SetUnnormImpedanceOnAllPorts

%% Example - Taken from CST documentation and translated to MATLAB.
% postprocess1d = project.PostProcess1D();
%     % *** S-parameter post-processing ***
%     postprocess1d.Reset();
%     postprocess1d.ApplyTo('S-parameter');
%     postprocess1d.SetDeembedDistance(1, 5.0)
%     postprocess1d.SetDeembedDistance(2, 10.0)
%     postprocess1d.SetDeembedDistance(3, 10.0)
%     postprocess1d.SetDeembedDistance(4, 5.0)
%     postprocess1d.AddOperation('Phase Deembedding');
%     postprocess1d.SetRenormImpedance(1, 1, 7500.0)
%     postprocess1d.SetRenormImpedance(2, 1, 5000.0)
%     postprocess1d.SetRenormImpedance(3, 1, 5000.0)
%     postprocess1d.SetRenormImpedance(4, 1, 7500.0)
%     postprocess1d.AddOperation('Renormalization');
%     postprocess1d.SetConsiderPortMode(1, 1, 1)
%     postprocess1d.SetConsiderPortMode(2, 1, 1)
%     postprocess1d.SetConsiderPortMode(3, 1, 0)
%     postprocess1d.SetConsiderPortMode(4, 1, 0)
%     postprocess1d.AddOperation('Exclude Port Modes');
%     postprocess1d.AddOperation('VSWR');
%     postprocess1d.Run();
%     % *** Probe signal post-processing ***
%     postprocess1d.Reset();
%     postprocess1d.ApplyTo('Probes');
%     postprocess1d.AddOperation('AR-filter');
%     postprocess1d.Run();
% 
