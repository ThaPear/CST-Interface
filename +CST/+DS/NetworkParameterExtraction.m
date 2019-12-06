%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine an equivalent SPICE circuit which has the same behavior at the ports as the simulation model. This command represents the "Spice Extraction" in the "Signal Post-Processing" ribbon.
classdef NetworkParameterExtraction < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.DS.Project can create a NetworkParameterExtraction object.
        function obj = NetworkParameterExtraction(dsproject, hDSProject)
            obj.dsproject = dsproject;
            obj.hNetworkParameterExtraction = hDSProject.invoke('NetworkParameterExtraction');
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal values to their default settings.
            obj.hNetworkParameterExtraction.invoke('Reset');
        end
        function TaskName(obj, task)
            % Sets the task to be used for the network parameter extraction.
            obj.hNetworkParameterExtraction.invoke('TaskName', task);
        end
        function BlockName(obj, block)
            % Sets the block for which the network parameter extraction should run. An empty block name selects the whole circuit.
            obj.hNetworkParameterExtraction.invoke('BlockName', block);
        end
        function Calculate(obj)
            % Starts the network parameter extraction with the previously made settings.
            obj.hNetworkParameterExtraction.invoke('Calculate');
        end
        %% Methods for Model Order Reduction (MOR) Based Extraction
        function CircuitFileName(obj, fileName)
            % Sets the filename of the resulting SPICE netlist based on model order reduction to fileName.
            obj.hNetworkParameterExtraction.invoke('CircuitFileName', fileName);
        end
        function filename = GetCircuitFileName(obj)
            % Returns the filename of the resulting SPICE netlist based on model order reduction.
            filename = obj.hNetworkParameterExtraction.invoke('GetCircuitFileName');
        end
        function EnsureOutOfBandPassivity(obj, bFlag)
            % If bFlag is True, passivity for frequency values out of the given band is ensured, otherwise not.
            obj.hNetworkParameterExtraction.invoke('EnsureOutOfBandPassivity', bFlag);
        end
        function UseARFilterResults(obj, bFlag)
            % If this method is activated the MOR method uses S-parameter data based on AR-Filter results if available.
            obj.hNetworkParameterExtraction.invoke('UseARFilterResults', bFlag);
        end
        function Accuracy(obj, value)
            % Specifies the acceptable error value for the S-parameter approximation.
            % Please note: The accuracy can be violated after performing the passivity step which is activated using the EnsureOutOfBandPassivity method.
            obj.hNetworkParameterExtraction.invoke('Accuracy', value);
        end
        function EnhanceAccuracyAtDC(obj, bFlag)
            % If bFlag is True, the MOR puts a higher emphasis on DC to improve the steady-state behavior of the model. Note that the overall accuracy of the model might be decreased when enforcing a high accuracy at DC. Note also that it might be not possible to achieve a high accuracy at DC if the input data has strong passivity violations at DC.
            obj.hNetworkParameterExtraction.invoke('EnhanceAccuracyAtDC', bFlag);
        end
        function InitalNumberOfPoles(obj, number)
            % Specifies the initial number of poles considered by the MOR scheme.
            obj.hNetworkParameterExtraction.invoke('InitalNumberOfPoles', number);
        end
        function MaximumNumberOfPoles(obj, number)
            % Specifies the maximum number of poles considered by the MOR scheme.
            obj.hNetworkParameterExtraction.invoke('MaximumNumberOfPoles', number);
        end
        function NumberOfPolesIncrement(obj, increment)
            % Specifies the increment in the number of poles between iterations considered by the MOR scheme.
            obj.hNetworkParameterExtraction.invoke('NumberOfPolesIncrement', increment);
        end
        function ErrorNorm(obj, norm)
            % Specifies the type of error norm to be applied by the MOR. The maximum norm considers the maximum error within the frequency range of interest while the L2 norm averages the error. .
            % norm: 'Max'
            %       'L2'
            obj.hNetworkParameterExtraction.invoke('ErrorNorm', norm);
        end
        function DifferentialNetlist(obj, bFlag)
            % Specifies whether the netlist should be written with differential ports
            obj.hNetworkParameterExtraction.invoke('DifferentialNetlist', bFlag);
        end
        function NetlistFormat(obj, format)
            % Specifies the output format of the netlist. "Berkeley SPICE" uses standard Berkeley SPICE notation with controlled sources while "HSPICE" uses Laplace formulation of the fitted Y parameter.
            % : 'Berkeley SPICE'
            %   'HSPICE'
            obj.hNetworkParameterExtraction.invoke('NetlistFormat', format);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hNetworkParameterExtraction

    end
end

%% Default Settings
%  
% ' defaults for model order reduction based network parameter extraction
% EnsureOutOfBandPassivity(1)
% UseARFilterResults(0)
% Accuracy('1e-2');
% InitalNumberOfPoles(10)
% NetlistFormat('Berkeley SPICE');

%% Example - Taken from CST documentation and translated to MATLAB.
% % start a MOR based network extraction
% 
% networkparameterextraction = dsproject.NetworkParameterExtraction();
% .TaskName('SParam1');
% .CircuitFileName('my_netlist.net');
% .EnsureOutOfBandPassivity(0)
% .UseARFilterResults(0)
% .Accuracy('1e-2');
% .InitalNumberOfPoles(10)
% .DifferentialNetlist(1)
% .NetlistFormat('HSPICE');
% .Calculate
% 
