%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  
classdef CircuitProbe < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.DS.Project)
        % Only CST.DS.Project can create a CircuitProbe object.
        function obj = CircuitProbe(dsproject, hDSProject)
            obj.dsproject = dsproject;
            obj.hCircuitProbe = hDSProject.invoke('CircuitProbe');
        end
    end
    %% CST Object functions.
    methods
        %% General Methods
        function Create(obj)
            % Creates a new probe. All necessary settings for this connection have to be made previously.
            obj.hCircuitProbe.invoke('Create');
        end
        function Delete(obj)
            % Deletes a probe. All necessary settings for this connection have to be made previously.
            obj.hCircuitProbe.invoke('Delete');
        end
        function bool = DoesExist(obj)
            % Checks if a probe with the currently defined properties already exists.
            bool = obj.hCircuitProbe.invoke('DoesExist');
        end
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.hCircuitProbe.invoke('Reset');
        end
        %% Identification
        function Name(obj, probename)
            % Sets the name of a probe before calling Create. Furthermore, this method can be used to select an existing probe of your model prior of calling queries.
            obj.hCircuitProbe.invoke('Name', probename);
        end
        function LinkName(obj, linkname)
            % Sets the name of a probe link before calling Create. Furthermore, this method can be used to select an existing probe link of your model prior of calling queries.
            obj.hCircuitProbe.invoke('LinkName', linkname);
        end
        function ReferenceLinkName(obj, probename)
            % Sets the name of a reference link of a differential probe before calling Create. Furthermore, this method can be used to select an existing differential probe using its reference link of your model prior of calling queries.
            obj.hCircuitProbe.invoke('ReferenceLinkName', probename);
        end
        %% Getter
        function name = GetName(obj)
            % Returns the name of the probe with the currently defined properties.
            name = obj.hCircuitProbe.invoke('GetName');
        end
        function name = GetLinkName(obj)
            % Returns the link name of the probe with the currently defined properties.
            name = obj.hCircuitProbe.invoke('GetLinkName');
        end
        function name = GetReferenceLinkName(obj)
            % Returns the name of the reference link of the differential probe with the currently defined properties.
            name = obj.hCircuitProbe.invoke('GetReferenceLinkName');
        end
        function int = GetType(obj)
            % Returns the type of the probe with the currently defined properties. The following int values are returned:
            % 0: No probe
            % 1: normal probe
            % 2: differential probe
            int = obj.hCircuitProbe.invoke('GetType');
        end
        %% Setter
        function SetName(obj, probename)
            % Modifies the name of an existing probe.
            obj.hCircuitProbe.invoke('SetName', probename);
        end
        function SetNodeFromBlockPort(obj, blockname, portname, directioninwards, referencepin)
            % Sets the probe's location by the specification of a block's port or its associated reference pin. Furthermore, the probe's direction must be given.
            obj.hCircuitProbe.invoke('SetNodeFromBlockPort', blockname, portname, directioninwards, referencepin);
        end
        %% Iteration
        function int = StartProbeNameIteration(obj)
            % Resets the iterator for the probes and returns the number of probes.
            int = obj.hCircuitProbe.invoke('StartProbeNameIteration');
        end
        function name = GetNextProbeName(obj)
            % Returns the next probe's name. Call StartProbeNameIteration before the first call of this method.
            name = obj.hCircuitProbe.invoke('GetNextProbeName');
        end
        %% Positioning
        function int = GetLabelPositionX(obj)
            % Returns the horizontal position of the center point of the label of the probe with the currently defined properties.
            int = obj.hCircuitProbe.invoke('GetLabelPositionX');
        end
        function int = GetLabelPositionY(obj)
            % Returns the vertical position of the center point of the label of the probe with the currently defined properties.
            int = obj.hCircuitProbe.invoke('GetLabelPositionY');
        end
        function bool = NormalDirection(obj)
            % Returns True if the direction of the probe with the currently defined properties is normal.
            bool = obj.hCircuitProbe.invoke('NormalDirection');
        end
        function ChangeDirection(obj)
            % Changes a probe's direction, i.e. the current is considered with opposite sign.
            obj.hCircuitProbe.invoke('ChangeDirection');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hCircuitProbe

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% % Get link names
% Dim sLinkName1 As String % link name of normal probe 1
% Dim sLinkName2 As String % link name of probe
% Dim sLinkName3 As String % reference link name of probe
% circuitprobe = project.CircuitProbe();
% .Reset
% .EndComponents('P', '1', '1', 'B', 'Block1', '1'); % link between external port 1 and Block1-Pin1
% sLinkName1 = .GetName()
% 
% .Reset
% .EndComponents('P', '2', '1', 'B', 'Block1', '2'); % link between external port 2 and Block1-Pin2
% sLinkName2 = .GetName()
% 
% .Reset
% .EndComponents('P', '3', '1', 'B', 'Block1', '3'); % link between external port 3 and Block1-Pin3
% sLinkName3 = .GetName()
% 
% %Create a new normal probe
% .Reset
% .Name('Probe1');
% .LinkName sLinkName1
% .Create % Create normal probe %Probe1% on link sLinkName1
% 
% %Create a new differential probe
% .Reset
% .Name('DiffProbe');
% .LinkName sLinkName2
% .ReferenceLinkName sLinkName3
% .Create % Create differential probe %DiffProbe% between links sLinkName2 and sLinkName3
% 
% %Modify an existing probe
% .Reset
% .Name('Probe1');
% .SetName('NormalProbe'); % Rename
% .ChangeDirection % Change probe direction
% 
