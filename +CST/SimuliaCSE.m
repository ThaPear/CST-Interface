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

% This object offers the possibility to run a co-simulation using Simulia Co-Simulation Engine (CSE).
classdef SimuliaCSE < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.SimuliaCSE object.
        function obj = SimuliaCSE(project, hProject)
            obj.project = project;
            obj.hSimuliaCSE = hProject.invoke('SimuliaCSE');
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
            % Prepend With SimuliaCSE and append End With
            obj.history = [ 'With SimuliaCSE', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define SimuliaCSE settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['SimuliaCSE', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        %% Connection Settings
        function SetCodeName(obj, codename)
            % Defines a code name for the co-simulation client. This name corresponds to the <codeName> attribute in the CSE configuration file.
            obj.AddToHistory(['.SetCodeName "', num2str(codename, '%.15g'), '"']);
        end
        function SetJobName(obj, jobname)
            % Defines a job name for the co-simulation client. This name corresponds to the <componentInstanceName> attribute in the CSE configuration file.
            obj.AddToHistory(['.SetJobName "', num2str(jobname, '%.15g'), '"']);
        end
        function SetDirectorName(obj, hostname)
            % This method defines a name of the host where the CSE director runs.
            obj.AddToHistory(['.SetDirectorName "', num2str(hostname, '%.15g'), '"']);
        end
        function SetDirectorPort(obj, portno)
            % Sets the port number which should be used for connection to the CSE director.
            obj.AddToHistory(['.SetDirectorPort "', num2str(portno, '%.15g'), '"']);
        end
        function SetConnectionTimeout(obj, TimeInS)
            % If during this number of seconds no connection to the CSE director could be established, the client stops and shows the time-out error message.
            obj.AddToHistory(['.SetConnectionTimeout "', num2str(TimeInS, '%.15g'), '"']);
        end
        %% Time Settings
        function SetSimulationDuration(obj, time)
            % Defines the co-simulation duration in currently selected user units.
            obj.AddToHistory(['.SetSimulationDuration "', num2str(time, '%.15g'), '"']);
        end
        function SetMasterClient(obj, name)
            % Specifies, which co-simulation client should be the main responsible for the choice of transient time steps. Possible values of name:
            % "CST"           the CST client selects the time step length based on excitation signals assigned to the solver sources.
            % "Counterpart"   the external client is responsible for selection of the time step length. The time step settings for CST are ignored.
            % "Both"          both CST and external clients submit their proposals for the next time step length, the shortest one is selected.
            obj.AddToHistory(['.SetMasterClient "', num2str(name, '%.15g'), '"']);
        end
        function SetTimeStepAutoSelection(obj, autoselect)
            % This command specifies, whether user settings for the time step length should be utilized ("False"), or automatic settings should be generated ("True").
            obj.AddToHistory(['.SetTimeStepAutoSelection "', num2str(autoselect, '%.15g'), '"']);
        end
        function SetMinTimeStep(obj, timestep)
            % Select the minimum time step length in user units. This signal is ignored if the Master Client is set to "Counterpart" or Autoselection is on.
            obj.AddToHistory(['.SetMinTimeStep "', num2str(timestep, '%.15g'), '"']);
        end
        function SetMaxTimeStep(obj, timestep)
            % Select the maximum time step length in user units. This signal is ignored if the Master Client is set to "Counterpart" or Autoselection is on.
            obj.AddToHistory(['.SetMaxTimeStep "', num2str(timestep, '%.15g'), '"']);
        end
        function SetMaxSignalChange(obj, percent)
            % Use this command to select the relative signal change in percent, according to which the next time step length should be selected. This signal is ignored if the Master Client is set to "Counterpart" or Autoselection is on.
            obj.AddToHistory(['.SetMaxSignalChange "', num2str(percent, '%.15g'), '"']);
        end
        %% Excitation Settings
        % In this section, the VBA commands controlling the change of electromagnetic source values in the course of transient co-simulation are described. Their usage is quite similar to Transient Thermal and MQS solvers.
        function ResetExcitationList(obj)
            % Use this command to reset all the excitation signals assigned to EM sources. The option to define different excitation signals to sources at different frequencies is turned off.
            obj.AddToHistory(['.ResetExcitationList']);
        end
        function SetExcitationsFrequencyDependent(obj, freq_dependent)
            % For the LF frequency-domain electromagnetic solver on the CST side of co-simulation, this command defines whether the solver is started at each step of co-simulation separately for each calculation frequency (freq_dependent = true) or only once for all the frequencies (freq_dependent = false). In the former case the excitation signals can be assigned to electromagnetic sources independently for each frequency.
            obj.AddToHistory(['.SetExcitationsFrequencyDependent "', num2str(freq_dependent, '%.15g'), '"']);
        end
        function ExcitationName(obj, sourcename)
            % For a new excitation being created, specify the source name the excitation signal should be assigned to (e.g.: "currentport1")
            obj.AddToHistory(['.ExcitationName "', num2str(sourcename, '%.15g'), '"']);
        end
        function ExcitationType(obj, exctype)
            % This command specifies the type of the source, to which the excitation signal should be assigned. In the following table, the possible values of exctype are listed:
            % "Current"       The source is a current wire
            % "Voltage"       The source is a voltage wire
            % "Coil"          The source is a single coil
            % "CoilGroup"     The source is a coil group
            % "CurrentPort"   The source is a current port.
            obj.AddToHistory(['.ExcitationType "', num2str(exctype, '%.15g'), '"']);
        end
        function ExcitationShift(obj, timeshift)
            % Use this command to specify a time shift in user units, after which the excitation signal is applied to the signal. If the timeshift has a positive value, the start value of the excitation signal is used for time instants less than timeshift.
            obj.AddToHistory(['.ExcitationShift "', num2str(timeshift, '%.15g'), '"']);
        end
        function ExcitationSignal(obj, signalname)
            % Specify the name of the excitation signal which should be applied to the solver source.
            obj.AddToHistory(['.ExcitationSignal "', num2str(signalname, '%.15g'), '"']);
        end
        function ExcitationActive(obj, active)
            % If active is false, the source is ignored.
            obj.AddToHistory(['.ExcitationActive "', num2str(active, '%.15g'), '"']);
        end
        function CreateExcitationForAllFrequencies(obj)
            % Assign the selected excitation signal to the solver source for all the frequencies at which the calculation is performed. This command can only be used if the command SetExcitationsFrequencyDependent with parameter False has been called.
            obj.AddToHistory(['.CreateExcitationForAllFrequencies']);
        end
        function CreateExcitationForFrequency(obj, frequency)
            % Assign the selected excitation signal to the solver source. This signal will be used for a single calculation frequency. This command can only be used if the command SetExcitationsFrequencyDependent with parameter True has been called.
            obj.AddToHistory(['.CreateExcitationForFrequency "', num2str(frequency, '%.15g'), '"']);
        end
        %% External Tools Settings
        function ResetExternalToolsSettings(obj)
            % Resets the settings which have been made for starting the CSE director and external CSE clients.
            obj.AddToHistory(['.ResetExternalToolsSettings']);
        end
        function RunExternalTools(obj, run)
            % This method defines if the CSE director and/or external CSE clients should be started automatically before the CST client is started.
            obj.AddToHistory(['.RunExternalTools "', num2str(run, '%.15g'), '"']);
        end
        function WorkingDir(obj, dirname)
            % Defines which directory should be used by the CSE director and other clients for loading and saving of information.
            obj.AddToHistory(['.WorkingDir "', num2str(dirname, '%.15g'), '"']);
        end
        function CoSimJobName(obj, jobname)
            % Specifies the job name for the CSE director.
            obj.AddToHistory(['.CoSimJobName "', num2str(jobname, '%.15g'), '"']);
        end
        function CreateNewConfigFile(obj, bCreateNew)
            % If the CSE director should be started, it needs an XML configuration file. This function specifies if this file should be created automatically.
            obj.AddToHistory(['.CreateNewConfigFile "', num2str(bCreateNew, '%.15g'), '"']);
        end
        function XMLConfigFile(obj, filename)
            % Provides the name of the configuration file which should be used by the CSE director. This value is ignored if .CreateNewConfigFile "True" has been specified.
            obj.AddToHistory(['.XMLConfigFile "', num2str(filename, '%.15g'), '"']);
        end
        function SetExternalClient(obj, ext_client)
            % Specifies which external client should be started automatically from the CST environment.
            % Abaqus means that the client settings are defined by .SetAbaqusJobName, .SetAbaqusInputFile and .SetAbaqusCommandLineParams.
            % If CommandLine is selected, the external client is defined by the .AddClientCommandLine setting.
            % None means that no external client should be started automatically. In this case after the CST client and CSE director are started the co-simulation is blocked until the external client is started manually.
            % ext_client: 'Abaqus'
            %             'CommandLine'
            %             'None'
            obj.AddToHistory(['.SetExternalClient "', num2str(ext_client, '%.15g'), '"']);
        end
        function SetAbaqusJobName(obj, jobname)
            % Specifies the job name for the Abaqus client (only considered for .SetExternalClient "Abaqus"). If this value is not set, an error message will be shown and no co-simulation will be started.
            obj.AddToHistory(['.SetAbaqusJobName "', num2str(jobname, '%.15g'), '"']);
        end
        function SetAbaqusInputFile(obj, filename)
            % Here the Abaqus input file can be specified (only considered for .SetExternalClient "Abaqus"). If the input file is located in the working directory and its name (without ".inp") is equal to the Abaqus job name, such file will be found automatically and there's no need to call this function.
            obj.AddToHistory(['.SetAbaqusInputFile "', num2str(filename, '%.15g'), '"']);
        end
        function SetAbaqusCommandLineParams(obj, cl_params)
            % With this function additional command line parameters can be specified for Abaqus (only considered for .SetExternalClient "Abaqus"), such as the number of cpus etc (please refer to Simula Abaqus documentation).
            obj.AddToHistory(['.SetAbaqusCommandLineParams "', num2str(cl_params, '%.15g'), '"']);
        end
        function AddClientCommandLine(obj, commandline)
            % Add a complete command line for each external co-simulation client to be started (only considered for .SetExternalClient "CommandLine").
            obj.AddToHistory(['.AddClientCommandLine "', num2str(commandline, '%.15g'), '"']);
        end
        %% Regions Settings
        function ResetRegions(obj)
            % Removes all the regions.
            obj.AddToHistory(['.ResetRegions']);
        end
        function ResetRegionData(obj)
            % Resets the settings made for creation of a new region.
            obj.AddToHistory(['.ResetRegionData']);
        end
        function RegionFace(obj, SolidName, FaceID)
            % Adds a solid face to the existing list of faces, for which a new region should be created. If the region dimension is 2D, the face will be used for co-simulation, otherwise the whole solid will be used.
            obj.AddToHistory(['.RegionFace "', num2str(SolidName, '%.15g'), '", '...
                                          '"', num2str(FaceID, '%.15g'), '"']);
        end
        function RegionName(obj, name)
            % Defines the name for the new region.
            obj.AddToHistory(['.RegionName "', num2str(name, '%.15g'), '"']);
        end
        function RegionType(obj, type)
            % This method specifies if the newly created region should be defined on a surface or in a volume.
            % type: 'Surface'
            %       'Volume'
            obj.AddToHistory(['.RegionType "', num2str(type, '%.15g'), '"']);
        end
        function CounterpartRegionName(obj, name)
            % Defines the name for the new region in the external client. This command is useful if many different regions exist for field exchange, in this way the CSE director knows where to map the field data to in the external project.
            obj.AddToHistory(['.CounterpartRegionName "', num2str(name, '%.15g'), '"']);
        end
        function CreateRegion(obj)
            % Creates a new regions with previously defined settings.
            obj.AddToHistory(['.CreateRegion']);
        end
        function SetCoordsUnit(obj, gUnit)
            % This methods allows to specify the length unit, into which the mesh node coordinates should be converted for the co-simulation. For the full list of supported values please refer to the Units Object documentation.
            % gUnit: 'm'
            %        'cm'
            %        'mm'
            %        'in'
            %        'etc...'
            obj.AddToHistory(['.SetCoordsUnit "', num2str(gUnit, '%.15g'), '"']);
        end
        %% Fields Settings
        function SetCoSimulationType(obj, cs_type)
            % Specifies, which co-simulation type (and the default set of exchanged fields) has been selected by the user last time.
            % cs_type: 'EM-Thermal'
            %          'EM-Mechanics'
            %          'Custom'
            obj.AddToHistory(['.SetCoSimulationType "', num2str(cs_type, '%.15g'), '"']);
        end
        function ResetFields(obj)
            % Removes all the fields in the list.
            obj.AddToHistory(['.ResetFields']);
        end
        function AddField(obj, direction, FieldType, factor, RegionName)
            % Defines a new field to exchange. Use direction to specify, whether the field should be sent to or received from the CSE director. FieldType defines the type of the field data. factor specifies the value, by which the field values should be multiplied after receiving or before submitting to the CSE client counterpart. RegionName defines, in which region the field should be exchanged (empty string means the whole simulation domain).
            % direction: 'In'
            %            'Out'
            % FieldType: 'Loss'
            %            'Displacement'
            %            'Force'
            obj.AddToHistory(['.AddField "', num2str(direction, '%.15g'), '", '...
                                        '"', num2str(FieldType, '%.15g'), '", '...
                                        '"', num2str(factor, '%.15g'), '", '...
                                        '"', num2str(RegionName, '%.15g'), '"']);
        end
        function AddTemperatureField(obj, direction, unit, RegionName)
            % Defines a new temperature field. Use direction to specify, whether the field should be sent to or received from the CSE director. Unit specifies, which temperature unit is used in the CSE client counterpart. RegionName defines, in which region the temperature field should be exchanged (empty string means the whole simulation domain).
            % direction: 'In'
            %            'Out'
            % unit: 'Celsius'
            %       'Kelvin'
            %       'Fahrenheit'
            obj.AddToHistory(['.AddTemperatureField "', num2str(direction, '%.15g'), '", '...
                                                   '"', num2str(unit, '%.15g'), '", '...
                                                   '"', num2str(RegionName, '%.15g'), '"']);
        end
        function AddLossToSubmitWithFrequency(obj, factor, RegionName, frequency)
            % Defines a new loss field to be submitted to the CSE director. factor specifies the value, by which the loss field values should be multiplied before submitting to the CSE client counterpart. RegionName defines, in which region the field should be exchanged (empty string means the whole simulation domain). frequency is the frequency value in user units, determining which loss field from EM solver output should be selected. The frequency must be defined in the solver settings as well, so the solver could deliver this loss field.
            obj.AddToHistory(['.AddLossToSubmitWithFrequency "', num2str(factor, '%.15g'), '", '...
                                                            '"', num2str(RegionName, '%.15g'), '", '...
                                                            '"', num2str(frequency, '%.15g'), '"']);
        end
        function AddLossToSubmitWithMonitorName(obj, factor, RegionName, MonitorName)
            % Same as previous, but the loss distribution is selected by MonitorName instead of frequency value. This is relevant e.g. for the LF Time Domain Solver (MQS), where the specific time-averaged loss field is identified by its monitor name. A average loss field monitor with this name must exist, otherwise the co-simulation cannot be started.
            obj.AddToHistory(['.AddLossToSubmitWithMonitorName "', num2str(factor, '%.15g'), '", '...
                                                              '"', num2str(RegionName, '%.15g'), '", '...
                                                              '"', num2str(MonitorName, '%.15g'), '"']);
        end
        function long = StartCoSimulation(obj)
            % Starts the co-simulation with the prescribed settings and the currently active mesh. If no mesh is available, a new mesh will be generated. Returns 0 if the co-simulation client run was successful or an error code >0 otherwise.
            long = obj.hSimuliaCSE.invoke('StartCoSimulation');
        end
        %% Deprecated
        function CreateExcitation(obj)
            % Same as CreateExcitationForAllFrequencies.
            obj.AddToHistory(['.CreateExcitation']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hSimuliaCSE
        history
        bulkmode

    end
end

%% Default Settings
% With SimuliaCSE
%      .SetCodeName('cst_job');
%      .SetJobName('cst_job');
%      .SetDirectorName('localhost');
%      .SetDirectorPort('22000');
%      .SetConnectionTimeout('300');
%      .SetSimulationDuration('0');
%      .SetMasterClient('Both');
%      .SetTimeStepAutoSelection('1');
%      .RunExternalTools('0');
%      .ResetRegions
%      .ResetFields
%      .ResetExcitationList
% End With

%% Example - Taken from CST documentation and translated to MATLAB.
% simuliacse = project.SimuliaCSE();
%     simuliacse.SetCodeName('lf_solution');
%     simuliacse.SetJobName('lf_solution');
%     simuliacse.SetDirectorName('localhost');
%     simuliacse.SetDirectorPort('22000');
%     simuliacse.SetConnectionTimeout('120');
%     simuliacse.SetSimulationDuration('1000');
%     simuliacse.ResetRegions
%     simuliacse.ResetRegionData
%     simuliacse.RegionName('region3D');
%     simuliacse.RegionDim('3D');
%     simuliacse.RegionFace('default:import_1_5', '9');
%     simuliacse.RegionFace('default:import_1_4', '19');
%     simuliacse.RegionFace('default:import_1_2', '19');
%     simuliacse.RegionFace('default:import_1_3', '19');
%     simuliacse.RegionFace('default:import_1', '19');
%     simuliacse.RegionFace('default:import_1_1', '19');
%     simuliacse.CreateRegion
%     simuliacse.ResetFields
%     simuliacse.AddLossToSubmitWithFrequency('1e-3', 'region3D', '10000');
%     simuliacse.AddTemperatureField('In', 'Celsius', 'region3D');
