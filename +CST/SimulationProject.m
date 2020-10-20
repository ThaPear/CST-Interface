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

% Allows to manage and create simulation projects.
classdef SimulationProject < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.SimulationProject object.
        function obj = SimulationProject(dsproject, hDSProject)
            obj.dsproject = dsproject;
            obj.hSimulationProject = hDSProject.invoke('SimulationProject');
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all settings to the default values. Call this before doing any specific settings for simulation project creation, otherwise the values of the last simulation poject created in the currently running instance will be used.
            obj.hSimulationProject.invoke('Reset');
        end
        function Open(obj, name)
            % Opens an existing simulation project specified by its name.
            obj.hSimulationProject.invoke('Open', name);
        end
        function Close(obj, name, discard)
            % Closes an open simulation project specified by its name. The discard flag specifies whether potentially unsaved project modifications shall be ignored.
            obj.hSimulationProject.invoke('Close', name, discard);
        end
        function Delete(obj, name)
            % Deletes an existing simulation project specified by its name. The simulation project must not be currently open.
            obj.hSimulationProject.invoke('Delete', name);
        end
        function Rename(obj, oldname, newname)
            % Renames an existing simulation project.
            obj.hSimulationProject.invoke('Rename', oldname, newname);
        end
        function Run(obj, name)
            % Runs the solver associated with an existing simulation project specified by its name.
            obj.hSimulationProject.invoke('Run', name);
        end
        function ResetComponents(obj)
            % Resets all stored information for component types. Components without a valid type will not be considered during the creation of a new simulation project.
            obj.hSimulationProject.invoke('ResetComponents');
        end
        function SetComponent(obj, name, type)
            % Sets the type of a component specified by its name. Currently, the following types are supported:
            % "3D"            Use the 3D representation of this component when creating the simulation project. If the component does not have a 3D model associated with it, the SCHEMATIC representation will be automatically chosen.
            % "SCHEMATIC"     Use the schematic (circuit) representation of this component when creating the simulation project.
            obj.hSimulationProject.invoke('SetComponent', name, type);
        end
        function SetAllComponents(obj, type)
            % Sets the type of all components. Please refer to the documentation of the SetComponent function for a description of the available types.
            obj.hSimulationProject.invoke('SetAllComponents', type);
        end
        function SetPort(obj, name, type)
            % Sets the type of a port specified by its name. Currently, only the type "SCHEMATIC" is supported for ports.
            obj.hSimulationProject.invoke('SetPort', name, type);
        end
        function SetAllPorts(obj, type)
            % Sets the type of all ports. Currently, only the type "SCHEMATIC" is supported for ports.
            obj.hSimulationProject.invoke('SetAllPorts', type);
        end
        function SetSolverType(obj, type)
            % Sets the solver type which will then be associated with the simulation project. This solver will be called whenever the simulation project gets updated as a result of a simulation task execution. In addition, this solver type will also be started by the Run function. This function is only valid during simulation project creation (in between Create and EndCreation calls).
            % Currently, the follwing solver types are supported: CANVAS, HF_TLM, HF_EIGENMODE, HF_ASYMPTOTIC, HF_TRANSIENT, HF_FREQUENCYDOMAIN, NETWORKEXTRACTION, STATIC_ESTATIC, THERMAL_STATIONARY, THERMAL_TRANSIENT, MECHANICAL, STATIC_JSTATIC, STATIC_MSTATIC, LF_FULLWAVE, LF_EQS, LF_MQS, PARTICLE_TRACKING, LF_MQSTRANSIENT, PARTICLE_ESTATIC, PARTICLE_MSTATIC, PARTICLE_WAKEFIELD, PARTICLE_PIC, HF_INTEGRALEQUATION, HF_MULTILAYER, PARAMETERSWEEP.
            obj.hSimulationProject.invoke('SetSolverType', type);
        end
        function SetTemplateName(obj, name)
            % Sets the name of a project template which will be used to adjust the default settings when a new simulation project is created.
            obj.hSimulationProject.invoke('SetTemplateName', name);
        end
        function SetUseAssemblyInformation(obj, use)
            % Sets whether assembly (layout) placement information shall be taken into account if available when creating a new simulation project. The default setting for this flag is true which means that the assembly information will be used.
            obj.hSimulationProject.invoke('SetUseAssemblyInformation', use);
        end
        function LoadReferenceDataFromBlock(obj, name)
            % Sets the name of a schematic block which will be used for inheriting non-geometric settings to the newly created simulation project. The block name must be specified with a preceding "Block: ", for instance "Block: MWSSCHEM1". Settings can also be inherited from other simulation projects by adding a preceding  "SP: ", followed by the name of the simulation project, e.g. "SP: SP1".
            % Please note that the reference data will only be actually used for creating a new simulation project if the SetUseReferenceData function gets called previously with the argument "true".
            % This function must be called before Create is called.
            obj.hSimulationProject.invoke('LoadReferenceDataFromBlock', name);
        end
        function SetReferenceCategoryUse(obj, name, used)
            % Once a reference block or project has been specified by the LoadReferenceDataFromBlock function, the inheritance of a particular type of settings can be turned on or off. This function allows you to set a flag whether a category name shall be used (true) or not (false).
            % Currently, the following categories are supported:
            %     Analytic Source Fields
            %     Antenna Array Settings
            %     Background Material
            %     Boundary Conditions
            %     Excitation Signals
            %     Frequency Range
            %     Global Mesh Settings
            %     Magnetic Source Field
            %     Monitors
            %     Plane Wave
            %     Post-Processing
            %     Project Templates
            %     Result Templates
            %     Sensitivity Information
            %     Solver Settings
            %     Subvolume Settings
            obj.hSimulationProject.invoke('SetReferenceCategoryUse', name, used);
        end
        function SetUseReferenceData(obj, use)
            % Sets whether reference data which was previously loaded by calling LoadReferenceDataFromBlock shall be taken into account when creating a new simulation project. The default setting for this flag is false which means that the reference data information will not be used.
            % This function must be called before Create is called.
            obj.hSimulationProject.invoke('SetUseReferenceData', use);
        end
        function SetUseReferenceBlockCoordinateSystem(obj, use)
            % Sets whether the reference block's coordinate system shall be used for creating the simulation project. If this option is selected, the location of the reference block's geometry will stay the same as in the original model.
            obj.hSimulationProject.invoke('SetUseReferenceBlockCoordinateSystem', use);
        end
        function SetLinkGeometry(obj, link)
            % This options sets whether the simulation project's geometry shall be automatically updated whenever the reference model changes. Turning off this option de-couples the corresponding simulation project from the reference model.
            obj.hSimulationProject.invoke('SetLinkGeometry', link);
        end
        function Create(obj, type, name)
            % This function creates a new simulation project of the given type and with the specified name. Once this function got called, handles to the new project's 3D modeler or the corresponding schematic can be retrieved by using the functions Get3D and GetSchematic. The simulation project creation is finally ended by calling the function EndCreation.
            % Currently, the following project types are supported: MWS, EMS, PS, MPS, DS.
            obj.hSimulationProject.invoke('Create', type, name);
        end
        function EndCreation(obj)
            % This function ends the creation of a new simulation project. The Get3D and GetSchematic functions are no longer valid afterwards.
            obj.hSimulationProject.invoke('EndCreation');
        end
        function bool = InteractiveTypeDefinitionMode(obj)
            % This function starts an interactive mode for defining component types. The mode can be ended by choosing either "Cancel block type definition" (function return value = false) or by choosing "End block type definition" (function return value = true).
            % Queries
            bool = obj.hSimulationProject.invoke('InteractiveTypeDefinitionMode');
        end
        function bool = DoesExist(obj, name)
            % Check whether a simulation project with the given name exists. The function returns true if the simulation project exists and false otherwise.
            bool = obj.hSimulationProject.invoke('DoesExist', name);
        end
        function bool = IsOpen(obj, name)
            % Check whether a simulation project with the given name is currently open. The function returns true if the simulation project is open and false otherwise.
            bool = obj.hSimulationProject.invoke('IsOpen', name);
        end
        function name = GetNewProjectName(obj)
            % Get a valid name for creating a new simulation project. The function ensures that no simulation project currently exists with the given name.
            name = obj.hSimulationProject.invoke('GetNewProjectName');
        end
        function project = Get3D(obj)
            % Get the COM handle to the 3D modeler for the newly created simulation project This handle can be used for sending commands to the corresponding VBA engine. This function is only valid during simulation project creation (in between Create and EndCreation calls).
            hProject = obj.hSimulationProject.invoke('Get3D');
            project = CST.Project(hProject);
        end
        function dsproject = GetSchematic(obj)
            % Get the COM handle to the schematic for the newly created simulation project This handle can be used for sending commands to the corresponding VBA engine. This function is only valid during simulation project creation (in between Create and EndCreation calls).
            hDSProject = obj.hSimulationProject.invoke('GetSchematic');
            dsproject = CST.DS.Project(hDSProject);
        end
        function int = StartSimulationProjectIteration(obj)
            % This function initializes the iteration over currently available simulation projects and returns the number of simulation projects. The simulation project names can then be retrieved by subsequent calls to GetNextSimulationProjectName.
            int = obj.hSimulationProject.invoke('StartSimulationProjectIteration');
        end
        function name = GetNextSimulationProjectName(obj)
            % This function returns the next simulation project name during an iteration over all available simulation projects. The StartSimulationProjectIteration needs to be called first in order to initialize the iteration. The function indicates the end of the list of simulation projects by returning an empty string.
            name = obj.hSimulationProject.invoke('GetNextSimulationProjectName');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject
        hSimulationProject

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% Dim sName As String
% sName = SimulationProject.GetNewProjectName
%
% simulationproject = project.SimulationProject();
%     simulationproject.ResetComponents
%     simulationproject.SetAllComponents('3D');
%     simulationproject.SetAllPorts('SCHEMATIC');
%     If(.InteractiveTypeDefinitionMode) Then
%         .Create('MWS', sName
%         .SetSolverType('HF_TRANSIENT');
%         .Get3D.AddToHistory('define frequency range', 'Solver.FrequencyRange('');0.0');', '');10');');('
%     simulationproject.EndCreation
%     End If
%
