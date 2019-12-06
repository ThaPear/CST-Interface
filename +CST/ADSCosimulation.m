%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Warning: Untested                                                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% In addition to its tight integration into the CST DESIGN ENVIRONMENT, CST MICROWAVE STUDIO also features strong interfaces to Keysight ADS�. Besides the �static� link option offering the possibility to use pre-computed S-parameter data in ADS circuit simulations, the �co-simulation� alternative enables ADS to launch CST MICROWAVE STUDIO in order to automatically calculate required data. All information is then stored together with the CST MICROWAVE STUDIO model in order to avoid unnecessary repetitions of lengthy EM simulations.
classdef ADSCosimulation < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a ADSCosimulation object.
        function obj = ADSCosimulation(project, hProject)
            obj.project = project;
            obj.hADSCosimulation = hProject.invoke('ADSCosimulation');
            obj.history = [];
            obj.bulkmode = 0;
        end
    end
    methods
        function StartBulkMode(obj)
            % Buffers all commands instead of sending them to CST
            % immediately.
            obj.bulkmode = 1;
        end
        function EndBulkMode(obj)
            % Flushes all commands since StartBulkMode to CST.
            obj.bulkmode = 0;
            % Prepend With ADSCosimulation and append End With
            obj.history = [ 'With ADSCosimulation', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ADSCosimulation settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['ADSCosimulation', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function EnableCoSimulation(obj, flag)
            % This method enables the ADS Co-Simulation. Whenever the calculation of new S-parameter data is required, the co-simulation interface will then automatically launch CST MICROWAVE STUDIO.
            obj.AddToHistory(['.EnableCoSimulation "', num2str(flag, '%.15g'), '"']);
            obj.enablecosimulation = flag;
        end
        function UseInterpolation(obj, flag)
            % This option specifies whether the S-parameter data may be interpolated or not. If this option deactivated, the S-parameters will be directly calculated for every requested parameter combination. If the interpolation feature is activated, the interpolation is done on a regular grid of so called anchor points, which can be independently controlled for each parameter using the ParameterInformation method.
            obj.AddToHistory(['.UseInterpolation "', num2str(flag, '%.15g'), '"']);
            obj.useinterpolation = flag;
        end
        function SolverType(obj, type)
            % Select here the solver type (transient or frequency domain) which will be used for the calculation if CST MICROWAVE STUDIO is automatically launched.
            % type: 'transient'
            %       'frequency domain'
            obj.AddToHistory(['.SolverType "', num2str(type, '%.15g'), '"']);
            obj.solvertype = type;
        end
        function Description(obj, description)
            % Specify here a description text which will later be shown in the ADS library browser.
            obj.AddToHistory(['.Description "', num2str(description, '%.15g'), '"']);
            obj.description = description;
        end
        function ParameterInformation(obj, parametername, use, type, NominalValue, StepSize)
            % This method offers the possibility to define certain information for a specific parameter, which is determined by its parametername.
            % The parameter can be controlled from within ADS if its use flag is set. This allows you to hide parameters from being visible in the ADS component options.
            % Furthermore each parameter needs to have a type assigned to it in order to properly handle potentially different unit settings in CST MICROWAVE STUDIO and ADS. Please make sure to specify the correct type according to the physical meaning of the parameter, e.g. type Length for a radius parameter.
            % The following types are supported:
            % "None" - The parameter does not have a unit (no scaling)
            % "Length" - The parameter is related to a length (scaling by length units)
            % "Temperature" - The parameter is related to a temperature (scaling by temperature units)
            % "Voltage" - The parameter is related to a voltage (scaling by voltage units)
            % "Current" - The parameter is related to a current (scaling by current units)
            % "Resistance" - The parameter is related to a resistance (scaling by resistance units)
            % "Conductance" - The parameter is related to a conductance (scaling by conductance units)
            % "Capacitance" - The parameter is related to a capacitance (scaling by capacitance units)
            % "Inductance" - The parameter is related to a inductance (scaling by inductance units)
            % "Frequency" - The parameter is related to a frequency (scaling by frequency units)
            % "Time" - The parameter is related to a time (scaling by time units)
            % If the Useinterpolation method is activated the NominalValue and the StepSize defines an equidistant grid of so called anchor points for the interpolation of S-parameter data. The NominalValue defines some kind of reference point from which the grid is spanned using the StepSize value as distance between two anchor points. These values can be  independently specified for each parameter.
            % Whenever a new data point is requested, the two closest neighboring anchor points are determined and their contributions to the requested sample are calculated. Based on this information the requested S-parameters can then be obtained by linear interpolation.
            obj.AddToHistory(['.ParameterInformation "', num2str(parametername, '%.15g'), '", '...
                                                    '"', num2str(use, '%.15g'), '", '...
                                                    '"', num2str(type, '%.15g'), '", '...
                                                    '"', num2str(NominalValue, '%.15g'), '", '...
                                                    '"', num2str(StepSize, '%.15g'), '"']);
            obj.parameterinformation.parametername = parametername;
            obj.parameterinformation.use = use;
            obj.parameterinformation.type = type;
            obj.parameterinformation.NominalValue = NominalValue;
            obj.parameterinformation.StepSize = StepSize;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hADSCosimulation
        history
        bulkmode

        enablecosimulation
        useinterpolation
        solvertype
        description
        parameterinformation
    end
end

%% Default Settings
% EnableCoSimulation(0)
% UseInterpolation(1)
% SolverType('Transient');

%% Example - Taken from CST documentation and translated to MATLAB.
% adscosimulation = project.ADSCosimulation();
% .EnableCoSimulation(1)
% .UseInterpolation(1)
% .SolverType('transient');
% .Description('Co-Sim Coaxial Connector');
% .ParameterInformation('radius', 1, 'Length', 200, 50)
% 
