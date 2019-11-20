%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%% Warning: Untested                                                   %%% 
%%% Added in case Force needs a different kind of history               %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The force object calculates forces and torques by the maxwell stress tensor for solids, current wires or coils. Please note that the same VBA functions are used for both, local and global coordinates. If the working coordinate system is activated all settings are made in local  coordinates, with the following assignment:
classdef Force < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Force object.
        function obj = Force(project, hProject)
            obj.project = project;
            obj.hForce = hProject.invoke('Force');
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.hForce.invoke('Reset');
        end
        function CalcType(obj, calctype)
            % Select for which simulation type the force calculation should be performed.
            % calctype (enum )
            % meaning
            % "E-Statics" - Force calculation of an electrostatic field
            % "M-Statics" - Force calculation of a magnetostatic  field
            % "Low Frequency" or "LF" - Force calculation of a magnetic field from a low frequency (magnetoquasistatic) simulation
            % "Electroquasistatic" - Force calculation of an electric field from a low frequency (electroquasistatic) simulation
            obj.hForce.invoke('CalcType', calctype);
        end
        function Frequency(obj, frequency)
            % Specify a frequency domain result by its frequency value.
            obj.hForce.invoke('Frequency', frequency);
        end
        function NormalX(obj, xvalue)
            % Sets the x/y/z-component of the axis used for the torque calculation.
            obj.hForce.invoke('NormalX', xvalue);
        end
        function NormalY(obj, yvalue)
            % Sets the x/y/z-component of the axis used for the torque calculation.
            obj.hForce.invoke('NormalY', yvalue);
        end
        function NormalZ(obj, zvalue)
            % Sets the x/y/z-component of the axis used for the torque calculation.
            obj.hForce.invoke('NormalZ', zvalue);
        end
        function OriginX(obj, xvalue)
            % Sets the x/y/zcoordinate of the axis' origin used for the torque calculation.
            obj.hForce.invoke('OriginX', xvalue);
        end
        function OriginY(obj, yvalue)
            % Sets the x/y/zcoordinate of the axis' origin used for the torque calculation.
            obj.hForce.invoke('OriginY', yvalue);
        end
        function OriginZ(obj, zvalue)
            % Sets the x/y/zcoordinate of the axis' origin used for the torque calculation.
            obj.hForce.invoke('OriginZ', zvalue);
        end
        function CoordinateSystem(obj, cosystem)
            % Select for which simulation type the force calculation should be performed.
            % cosystem (enum )
            % meaning
            % "Global" - Global coordinate system
            % "WCS" - Local coordinate system (Working coordinate system)
            obj.hForce.invoke('CoordinateSystem', cosystem);
        end
        function Extend2TouchingShapes(obj, bFlag)
            % This setting concerns only the force computation with tetrahedral solvers and will be ignored otherwise.
            % The force computation method requires objects which are surrounded completely by the background or by objects that are equivalent to the background. If bFlag is True, all shapes connected to a specified solid or coil will be collected into one group and the force on this group will be computed. If no 3d object is specified, all solids and coils will be collected into groups of connected shapes, and the forces will be computed groupwise. If bFlag is False, the force will be computed on the specified object only (or shape by shape), and a warning will be printed if shapes are detected which are not entirely embedded in background or equivalent material.
            % Please note that objects with background (or equivalent) material are ignored by the force computation method unless a source is assigned or the object is the one which was marked by ForceObject for single object force computation.
            % Please see Force and Torque Calculation for further information.
            obj.hForce.invoke('Extend2TouchingShapes', bFlag);
        end
        function ForceObject(obj, name)
            % By default, the forces will be computed on all define objects (or object groups). If only one of the objects is of interest then it's name can be specified here and the force computation will be performed only on the specified object (or, if specified by Extend2TouchingShapes, on the group of shapes connected to the specified object).
            obj.hForce.invoke('ForceObject', name);
        end
        function ComputeForceDensity(obj, bFlag)
            % If bFlag is set True, the distributions of volume and surface force densities as well as nodal forces will be computed and exported. Background material and materials equivalent to it are hereby ignored. These distributions can afterwards be imported by the Structural Mechanics Solver for computation of mechanical deformation.
            obj.hForce.invoke('ComputeForceDensity', bFlag);
        end
        function Start(obj)
            % Starts the force calculation.
            obj.hForce.invoke('Start');
        end
        % Functions
        function double = GetForceX(obj, name, calctype, frequency, force_dc, force_re, force_im)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetForceX''.');
            double = nan;
            return;
            % Get the x/y/z  force-component value of a solid. The paradigm for the name is:
            % name (name) :
            % meaning
            % For solids
            % layername:solidname
            % For coils
            %  coilname
            % For current pathes
            %  wire:pathname
            % The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetForceX', name, calctype, frequency, force_dc, force_re, force_im);
        end
        function double = GetForceY(obj, name, calctype, frequency, force_dc, force_re, force_im)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetForceY''.');
            double = nan;
            return;
            % Get the x/y/z  force-component value of a solid. The paradigm for the name is:
            % name (name) :
            % meaning
            % For solids
            % layername:solidname
            % For coils
            %  coilname
            % For current pathes
            %  wire:pathname
            % The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetForceY', name, calctype, frequency, force_dc, force_re, force_im);
        end
        function double = GetForceZ(obj, name, calctype, frequency, force_dc, force_re, force_im)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetForceZ''.');
            double = nan;
            return;
            % Get the x/y/z  force-component value of a solid. The paradigm for the name is:
            % name (name) :
            % meaning
            % For solids
            % layername:solidname
            % For coils
            %  coilname
            % For current pathes
            %  wire:pathname
            % The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetForceZ', name, calctype, frequency, force_dc, force_re, force_im);
        end
        function double = GetNormalX(obj, calctype, frequency)
            % Get the x/y/z-component of the axis used for the torque calculation.. The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetNormalX', calctype, frequency);
        end
        function double = GetNormalY(obj, calctype, frequency)
            % Get the x/y/z-component of the axis used for the torque calculation.. The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetNormalY', calctype, frequency);
        end
        function double = GetNormalZ(obj, calctype, frequency)
            % Get the x/y/z-component of the axis used for the torque calculation.. The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetNormalZ', calctype, frequency);
        end
        function double = GetOriginX(obj, calctype, frequency)
            % Get the x/y/z-coordinate of the axis' origin used for the torque calculation. The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetOriginX', calctype, frequency);
        end
        function double = GetOriginY(obj, calctype, frequency)
            % Get the x/y/z-coordinate of the axis' origin used for the torque calculation. The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetOriginY', calctype, frequency);
        end
        function double = GetOriginZ(obj, calctype, frequency)
            % Get the x/y/z-coordinate of the axis' origin used for the torque calculation. The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetOriginZ', calctype, frequency);
        end
        function double = GetTorque(obj, name, calctype, frequency, force_dc, force_re, force_im)
            % This function was not implemented due to the double_ref
            % arguments being seemingly impossible to pass from MATLAB.
            warning('Used unimplemented function ''GetTorque''.');
            double = nan;
            return;
            % Get the torque value for a solid. The paradigm for the solid's name is described in the GetForce command. The return value is the absolute torque value. In case of low frequency fields the reference value force_dc returns the DC part and torque_re / torque_im the complex part of the torque.
            double = obj.hForce.invoke('GetTorque', name, calctype, frequency, force_dc, force_re, force_im);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hForce

    end
end

%% Default Settings
% Frequency('0');
% CoordinateSystem('Global');
% NormalX('0');
% NormalY('0');
% NormalZ('1');
% OriginX('0');
% OriginY('0');
% OriginZ('0');

%% Example - Taken from CST documentation and translated to MATLAB.
% force = project.Force();
%     force.NormalX('0');
%     force.NormalY('0');
%     force.NormalZ('1');
%     force.OriginX('0');
%     force.OriginY('0');
%     force.OriginZ('0');
%     force.CalcType('low frequency');
%     force.Frequency('0');
%     force.CoordinateSystem('Global');
%     force.Extend2TouchingShapes('1');
% 
