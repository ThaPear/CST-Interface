%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef PostProcess1D < handle
    properties(SetAccess = protected)
        project
        hPostProcess1D
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.PostProcess1D object.
        function obj = PostProcess1D(project, hProject)
            obj.project = project;
            obj.hPostProcess1D = hProject.invoke('PostProcess1D');
        end
    end
    
    methods
        function Reset(obj)
            obj.hPostProcess1D.invoke('Reset');
        end
        function ApplyTo(obj, target)
            % target: S-parameter, Probes, Monitors
            obj.hPostProcess1D.invoke('ApplyTo', target);
        end
        function AddOperation(obj, operationtype)
            % operationtype: Time Window, AR-Filter, Phase Deembedding,
            %                Renormalization, VSWR, YZ-matrices, 
            %                Exclude Port Modes
            obj.hPostProcess1D.invoke('AddOperation', operationtype);
        end
        function SetDeembedDistance(obj, portnumber, distance)
            obj.hPostProcess1D.invoke('SetDeembedDistance', portnumber, distance);
        end
        function SetRenormImpedance(obj, portnumber, modenumber, impedance)
            obj.hPostProcess1D.invoke('SetRenormImpedance', portnumber, modenumber, impedance);
        end
        function SetRenormImpedanceOnAllPorts(obj, impedance)
            obj.hPostProcess1D.invoke('SetRenormImpedanceOnAllPorts', impedance);
        end
        function SetUnnormImpedanceOnAllPorts(obj)
            obj.hPostProcess1D.invoke('SetUnnormImpedanceOnAllPorts');
        end
        function SetConsiderPortMode(obj, portnumber, modenumber, boolean)
            obj.hPostProcess1D.invoke('SetConsiderPortMode', portnumber, modenumber, boolean);
        end
        function Run(obj)
            obj.hPostProcess1D.invoke('Run');
        end
        function ActivateOperation(obj, operationtype, boolean)
            % operationtype: VSWR, YZ-matrices
            obj.project.AddToHistory(['PostProcess1D.ActivateOperation "', operationtype, '", "', num2str(boolean), '"']);
        end
    end
end
