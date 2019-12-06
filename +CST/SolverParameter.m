%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object controls the model simplification settings for a specific solver.
classdef SolverParameter < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a SolverParameter object.
        function obj = SolverParameter(project, hProject)
            obj.project = project;
            obj.hSolverParameter = hProject.invoke('SolverParameter');
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
            % Prepend With SolverParameter and append End With
            obj.history = [ 'With SolverParameter', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define SolverParameter settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['SolverParameter', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function SolverType(obj, solverkey, meshkey)
            % The settings below apply to the solver which is specified by the solverkey:
            % "Transient solver"
            % "Frequency domain solver"
            % "Asymptotic solver"
            % "Eigenmode solver"
            % "Electrostatics solver"
            % "Magnetostatic solver"
            % "LF Frequency domain solver"
            % "LF Frequency domain solver (EQS)"
            % "Stationary current solver"
            % "Particle tracking solver"
            % "PIC solver"
            % "Thermal solver"
            % "Integral equation solver"
            % "Multilayer solver"
            % "LF Time domain solver (MQS)"
            % "LF Time domain solver (EQS)"
            % "Thermal transient solver"
            %  "Structural mechanics solver"
            % "Wakefield solver"
            % The following values are allowed for the meshkey:
            % "Hexahedral"
            % "Tetrahedral"
            % "Surface"
            obj.AddToHistory(['.SolverType "', num2str(solverkey, '%.15g'), '", '...
                                          '"', num2str(meshkey, '%.15g'), '"']);
            obj.solvertype.solverkey = solverkey;
            obj.solvertype.meshkey = meshkey;
        end
        function IgnoreLossyMetals(obj, flag)
            % Do not consider losses of metal materials during a simulation run.
            obj.AddToHistory(['.IgnoreLossyMetals "', num2str(flag, '%.15g'), '"']);
            obj.ignorelossymetals = flag;
        end
        function IgnoreLossyDielectrics(obj, flag)
            % Do not consider losses of normal materials during a simulation run.
            obj.AddToHistory(['.IgnoreLossyDielectrics "', num2str(flag, '%.15g'), '"']);
            obj.ignorelossydielectrics = flag;
        end
        function IgnoreLossyMetalsForWires(obj, flag)
            % Neglect losses of metal materials for wires during a simulation run.
            obj.AddToHistory(['.IgnoreLossyMetalsForWires "', num2str(flag, '%.15g'), '"']);
            obj.ignorelossymetalsforwires = flag;
        end
        function IgnoreNonlinearMaterials(obj, flag)
            % Neglect nonlinear material settings and simulate all materials as linear (normal).
            obj.AddToHistory(['.IgnoreNonlinearMaterials "', num2str(flag, '%.15g'), '"']);
            obj.ignorenonlinearmaterials = flag;
        end
        function UseThinWireModel(obj, flag)
            % Use infinite thin wires mapped to the mesh during a simulation run.
            % UseZeroWireRadius (bool flag  )
            % Do not consider a radius greater zero wires during a simulation run.
            obj.AddToHistory(['.UseThinWireModel "', num2str(flag, '%.15g'), '"']);
            obj.usethinwiremodel = flag;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hSolverParameter
        history
        bulkmode

        solvertype
        ignorelossymetals
        ignorelossydielectrics
        ignorelossymetalsforwires
        ignorenonlinearmaterials
        usethinwiremodel
    end
end

%% Default Settings
% SolverType('', '');
% IgnoreLossyMetals('0');
% IgnoreLossyDielectrics('0');
% IgnoreLossyMetalsForWires('0');
% UseThinWireModel('0');
% UseZeroWireRadius('0');

%% Example - Taken from CST documentation and translated to MATLAB.
% % Settings for the T-Solver
% solverparameter = project.SolverParameter();
%     solverparameter.SolverType('Transient solver', 'Hexahedral');
%     solverparameter.IgnoreLossyMetals('0');
%     solverparameter.IgnoreLossyDielectrics('1');
%     solverparameter.IgnoreLossyMetalsForWires('0');
%     solverparameter.UseThinWireModel('0');
%     solverparameter.UseZeroWireRadius('0');
