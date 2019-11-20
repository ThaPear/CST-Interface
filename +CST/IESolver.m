%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%% Warning: Untested                                                   %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This object together with the FDSolver Object controls the integral equation solver and multilayer solver.
classdef IESolver < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a IESolver object.
        function obj = IESolver(project, hProject)
            obj.project = project;
            obj.hIESolver = hProject.invoke('IESolver');
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
            % Prepend With IESolver and append End With
            obj.history = [ 'With IESolver', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define IESolver settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['IESolver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all previously made settings concerning the solver to the default values.
            obj.AddToHistory(['.Reset']);
        end
        function SetAccuracySetting(obj, key)
            % This command makes it easy to control the solver accuracy. Please see below a description of the sets. If a predefined set (Low, Medium or High) is used, the specific user-defined settings in the IESolver and FDSolver objects are ignored for the settings mentioned below. For Medium and High only the changes from one level below are listed.
            % Custom:
            % Settings from the IESolver and FDSolver objects are used.
            % Low Accuracy:
            % First order,
            % Single precision,
            % Disabled low frequency stabilization,
            % PEC solid handling: CFIE ,
            % Matrix type: Auto,
            % MLFMM Accuracy: Low,
            % Minimum Box size: 0.20 lambda,
            % ACA accuracy: 0.0001,
            % Iterative solver stopping criteria: 1e-3
            % Medium:
            % PEC solid handling: alternative CFIE,
            % MLFMM Accuracy: Medium,
            % Minimum Box size: 0.3 lambda,
            % High:
            % Double precision,
            % MLFMM Accuracy: High,
            % Minimum Box size: 0.50 lambda,
            % UseFastFrequencySweep  ( bool flag )
            % Activates (flag = True) or deactivates (flag = False) the broadband frequency sweep for the solver.
            % key: 'Custom'
            %      'Low'
            %      'Medium'
            %      'High'
            obj.AddToHistory(['.SetAccuracySetting "', num2str(key, '%.15g'), '"']);
            obj.setaccuracysetting = key;
        end
        function UseIEGroundPlane(obj, flag)
            % Activates (flag = True) or deactivates (flag = False) the infinite ground plane formulation for an electric boundary condition at ZMin.
            obj.AddToHistory(['.UseIEGroundPlane "', num2str(flag, '%.15g'), '"']);
            obj.useiegroundplane = flag;
        end
        function SetRealGroundMaterialName(obj, name)
            % Specifies the material of the real ground for an open boundary condition at ZMin. If no material is specified (name = ""), real ground plane calculation is deactivated.
            obj.AddToHistory(['.SetRealGroundMaterialName "', num2str(name, '%.15g'), '"']);
            obj.setrealgroundmaterialname = name;
        end
        function CalcFarFieldInRealGround(obj, flag)
            % Activates (flag = True) or deactivates (flag = False) calculation of the far field in the real ground.
            obj.AddToHistory(['.CalcFarFieldInRealGround "', num2str(flag, '%.15g'), '"']);
            obj.calcfarfieldinrealground = flag;
        end
        function RealGroundModelType(obj, key)
            % Sets the model type for real ground (only relevant in the presence of objects touching the real ground plane).
            % Auto:
            % The model type is determined automatically taking into account the material properties of the real ground.
            % Type 1:
            % This model type is well suited for a real ground material with low electrical conductivity (low imaginary part of the permittivity).
            % Type 2:
            % This model type is well suited for a real ground material with high electrical conductivity (high imaginary part of the permittivity). This model type may also lead to be a better solver convergence compared to "Type 1".
            % key: 'Auto'
            %      'Type 1'
            %      'Type 2'
            obj.AddToHistory(['.RealGroundModelType "', num2str(key, '%.15g'), '"']);
            obj.realgroundmodeltype = key;
        end
        function PreconditionerType(obj, key)
            % Sets the preconditioner type.
            % key: 'Auto'
            %      'Type 1'
            %      'Type 2'
            %      'Type 3'
            obj.AddToHistory(['.PreconditionerType "', num2str(key, '%.15g'), '"']);
            obj.preconditionertype = key;
        end
        function LowFrequencyStabilization(obj, flag)
            % This option controls the low frequency stabilization for the iterative and direct MoM solver. If enabled the accuracy for electrically small models or models with small triangles compared to the wavelength will increase.
            obj.AddToHistory(['.LowFrequencyStabilization "', num2str(flag, '%.15g'), '"']);
            obj.lowfrequencystabilization = flag;
        end
        function LowFrequencyStabilizationML(obj, flag)
            % This Multilayer solver option controls the low frequency stabilization for the iterative and direct MoM solver. If enabled the accuracy for electrically small models or models with small triangles compared to the wavelength will increase.
            obj.AddToHistory(['.LowFrequencyStabilizationML "', num2str(flag, '%.15g'), '"']);
            obj.lowfrequencystabilizationml = flag;
        end
        function Multilayer(obj, flag)
            % Activates (flag = True) or deactivates (flag = False) the multilayer solver.
            obj.AddToHistory(['.Multilayer "', num2str(flag, '%.15g'), '"']);
            obj.multilayer = flag;
        end
        function SetiMoMACC_I(obj, value)
            % This accuracy determines the accuracy of the Iterative MoM system matrix for the Integral equation solver. A lower accuracy leads to lower memory requirement but also to a lower accuracy.
            obj.AddToHistory(['.SetiMoMACC_I "', num2str(value, '%.15g'), '"']);
            obj.setimomacc_i = value;
        end
        function SetiMoMACC_M(obj, value)
            % This accuracy determines the accuracy of the Iterative MoM system matrix for the Multilayer solver. A lower accuracy leads to lower memory requirement but also to a lower accuracy.
            obj.AddToHistory(['.SetiMoMACC_M "', num2str(value, '%.15g'), '"']);
            obj.setimomacc_m = value;
        end
        function SetCFIEAlpha(obj, value)
            % If the option UseCFIEForCPECIntEq is enabled and the CFIE alpha is set to 1 the Electric Field Integral Equation will be used. This is an option if you are sure there will be no spurious resonances inside the PEC solids e.g. for electrically small PEC solids. The default value is 0.5.
            obj.AddToHistory(['.SetCFIEAlpha "', num2str(value, '%.15g'), '"']);
            obj.setcfiealpha = value;
        end
        function DeembedExternalPorts(obj, flag)
            % Activates the automatic deembedding of external ports as multipin ports.
            obj.AddToHistory(['.DeembedExternalPorts "', num2str(flag, '%.15g'), '"']);
            obj.deembedexternalports = flag;
        end
        function IgnoreBC_XY_And_Set_To_Open(obj, flag)
            % This command is used to control the handling of boundary conditions in x- and y-direction for the Multilayer Solver.  If flag is set to "True" the boundary conditions in x- and y-directions will be set to open. If flag is set to "False" the boundary conditions in x- and y-directions will be set as defined with the methods of the Boundary Object.
            obj.AddToHistory(['.IgnoreBC_XY_And_Set_To_Open "', num2str(flag, '%.15g'), '"']);
            obj.ignorebc_xy_and_set_to_open = flag;
        end
        function ModeTrackingCMA(obj, flag)
            % Activates automatic mode tracking for the characteristic mode analysis.
            obj.AddToHistory(['.ModeTrackingCMA "', num2str(flag, '%.15g'), '"']);
            obj.modetrackingcma = flag;
        end
        function NumberOfModesCMA(obj, nModes)
            % Specifies the number of modes for the characteristic mode analysis.
            obj.AddToHistory(['.NumberOfModesCMA "', num2str(nModes, '%.15g'), '"']);
            obj.numberofmodescma = nModes;
        end
        function StartFrequencyCMA(obj, value)
            % Specifies the frequency for sorting of the modes according to their modal significance for the characteristic mode analysis. If this value has not been specified before (value = "-1.0"), the minimal frequency of the simulation frequency range is chosen.
            obj.AddToHistory(['.StartFrequencyCMA "', num2str(value, '%.15g'), '"']);
            obj.startfrequencycma = value;
        end
        function SetAccuracySettingCMA(obj, key)
            % Specifies the accuracy settings for the characteristic mode analysis. Please see below a description of the sets.
            % Default:
            % Default settings are used.
            % Custom:
            % Settings from the IESolver and FDSolver objects are used.
            % FrequencySamplesCMA ( int nSamples )
            % Specifies the number of samples for the characteristic mode analysis with mode tracking. By default (nSamples = "0") this number is determined automatically.
            % key: 'Default'
            %      'Custom'
            obj.AddToHistory(['.SetAccuracySettingCMA "', num2str(key, '%.15g'), '"']);
            obj.setaccuracysettingcma = key;
        end
        function SetMemSettingCMA(obj, key)
            % Sets the memory setting for the characteristic mode analysis with mode tracking. By default ("Auto") the memory setting is determined automatically taking into account the available main memory.
            % key: 'Auto'
            %      'Low'
            %      'Medium'
            %      'High'
            obj.AddToHistory(['.SetMemSettingCMA "', num2str(key, '%.15g'), '"']);
            obj.setmemsettingcma = key;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hIESolver
        history
        bulkmode

        setaccuracysetting
        useiegroundplane
        setrealgroundmaterialname
        calcfarfieldinrealground
        realgroundmodeltype
        preconditionertype
        lowfrequencystabilization
        lowfrequencystabilizationml
        multilayer
        setimomacc_i
        setimomacc_m
        setcfiealpha
        deembedexternalports
        ignorebc_xy_and_set_to_open
        modetrackingcma
        numberofmodescma
        startfrequencycma
        setaccuracysettingcma
        setmemsettingcma
    end
end

%% Default Settings
% SetAccuracySetting(('Low'); )
% UseFastFrequencySweep ( 0 )
% UseIEGroundPlane ( 0 )
% SetRealGroundMaterialName((''); )
% CalcFarFieldInRealGround( 0 )
% RealGroundModelType(('Auto'); )
% PreconditionerType(('Auto'); )
% LowFrequencyStabilization( 0 )
% LowFrequencyStabilizationML( 1 )
% Multilayer( FALSE )
% SetiMoMACC_I( 0.0001 )
% SetiMoMACC_M( 0.0001 )
% SetCFIEAlpha( 0.5 )
% DeembedExternalPorts( 0 )
% IgnoreBC_XY_And_Set_To_Open( 1 )
% ModeTrackingCMA( 1 )
% NumberOfModesCMA( 3 )
% StartFrequencyCMA( -1.0 )
% SetAccuracySettingCMA(('Default'); )
% FrequencySamplesCMA( 0 )
% SetMemSettingCMA(('Auto'); )
%  
