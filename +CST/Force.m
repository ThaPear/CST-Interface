%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Warning: Untested                                                   %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The force object calculates forces and torques by the maxwell stress tensor for solids, current wires or coils. Please note that the same VBA functions are used for both, local and global coordinates. If the working coordinate system is activated all settings are made in local  coordinates, with the following assignment:
classdef Force < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Force object.
        function obj = Force(project, hProject)
            obj.project = project;
            obj.hForce = hProject.invoke('Force');
            obj.history = [];
        end
    end
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function CalcType(obj, calctype)
            % Select for which simulation type the force calculation should be performed.
            % calctype (enum )
            % meaning
            % "E-Statics" - Force calculation of an electrostatic field
            % "M-Statics" - Force calculation of a magnetostatic  field
            % "Low Frequency" or "LF" - Force calculation of a magnetic field from a low frequency (magnetoquasistatic) simulation
            % "Electroquasistatic" - Force calculation of an electric field from a low frequency (electroquasistatic) simulation
            obj.AddToHistory(['.CalcType "', num2str(calctype, '%.15g'), '"']);
            obj.calctype = calctype;
        end
        function Frequency(obj, frequency)
            % Specify a frequency domain result by its frequency value.
            obj.AddToHistory(['.Frequency "', num2str(frequency, '%.15g'), '"']);
            obj.frequency = frequency;
        end
        function NormalX(obj, xvalue)
            % Sets the x/y/z-component of the axis used for the torque calculation.
            obj.AddToHistory(['.NormalX "', num2str(xvalue, '%.15g'), '"']);
            obj.normalx = xvalue;
        end
        function NormalY(obj, yvalue)
            % Sets the x/y/z-component of the axis used for the torque calculation.
            obj.AddToHistory(['.NormalY "', num2str(yvalue, '%.15g'), '"']);
            obj.normaly = yvalue;
        end
        function NormalZ(obj, zvalue)
            % Sets the x/y/z-component of the axis used for the torque calculation.
            obj.AddToHistory(['.NormalZ "', num2str(zvalue, '%.15g'), '"']);
            obj.normalz = zvalue;
        end
        function OriginX(obj, xvalue)
            % Sets the x/y/zcoordinate of the axis' origin used for the torque calculation.
            obj.AddToHistory(['.OriginX "', num2str(xvalue, '%.15g'), '"']);
            obj.originx = xvalue;
        end
        function OriginY(obj, yvalue)
            % Sets the x/y/zcoordinate of the axis' origin used for the torque calculation.
            obj.AddToHistory(['.OriginY "', num2str(yvalue, '%.15g'), '"']);
            obj.originy = yvalue;
        end
        function OriginZ(obj, zvalue)
            % Sets the x/y/zcoordinate of the axis' origin used for the torque calculation.
            obj.AddToHistory(['.OriginZ "', num2str(zvalue, '%.15g'), '"']);
            obj.originz = zvalue;
        end
        function CoordinateSystem(obj, cosystem)
            % Select for which simulation type the force calculation should be performed.
            % cosystem (enum )
            % meaning
            % "Global" - Global coordinate system
            % "WCS" - Local coordinate system (Working coordinate system)
            obj.AddToHistory(['.CoordinateSystem "', num2str(cosystem, '%.15g'), '"']);
            obj.coordinatesystem = cosystem;
        end
        function Extend2TouchingShapes(obj, bFlag)
            % This setting concerns only the force computation with tetrahedral solvers and will be ignored otherwise.
            % The force computation method requires objects which are surrounded completely by the background or by objects that are equivalent to the background. If bFlag is True, all shapes connected to a specified solid or coil will be collected into one group and the force on this group will be computed. If no 3d object is specified, all solids and coils will be collected into groups of connected shapes, and the forces will be computed groupwise. If bFlag is False, the force will be computed on the specified object only (or shape by shape), and a warning will be printed if shapes are detected which are not entirely embedded in background or equivalent material.
            % Please note that objects with background (or equivalent) material are ignored by the force computation method unless a source is assigned or the object is the one which was marked by ForceObject for single object force computation.
            % Please see Force and Torque Calculation for further information.
            obj.AddToHistory(['.Extend2TouchingShapes "', num2str(bFlag, '%.15g'), '"']);
            obj.extend2touchingshapes = bFlag;
        end
        function ForceObject(obj, name)
            % By default, the forces will be computed on all define objects (or object groups). If only one of the objects is of interest then it's name can be specified here and the force computation will be performed only on the specified object (or, if specified by Extend2TouchingShapes, on the group of shapes connected to the specified object).
            obj.AddToHistory(['.ForceObject "', num2str(name, '%.15g'), '"']);
            obj.forceobject = name;
        end
        function ComputeForceDensity(obj, bFlag)
            % If bFlag is set True, the distributions of volume and surface force densities as well as nodal forces will be computed and exported. Background material and materials equivalent to it are hereby ignored. These distributions can afterwards be imported by the Structural Mechanics Solver for computation of mechanical deformation.
            obj.AddToHistory(['.ComputeForceDensity "', num2str(bFlag, '%.15g'), '"']);
            obj.computeforcedensity = bFlag;
        end
        function Start(obj)
            % Starts the force calculation.
            obj.AddToHistory(['.Start']);
            
            % Prepend With Force and append End With
            obj.history = [ 'With Force', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Force'], obj.history);
            obj.history = [];
        end
        % Functions
        function [value, force_dc, force_re, force_im] = GetForceX(obj, name, calctype, frequency)
            % Get the x force-component value of a solid. The paradigm for the name is:
            % name (name)               meaning
            % For solids                layername:solidname
            % For coils                 coilname
            % For current pathes        wire:pathname
            % The enum-type of the field under study is defined in the CalcType command.
            functionString = [...
                'Dim value As Double, force_dc As Double, force_re As Double, force_im As Double', newline, ...
                'value = Force.GetForceX(', name, ', ', calctype, ', ', num2str(frequency, '%.15g'), ', force_dc, force_re, force_im)', newline, ...
            ];
            returnvalues = {'value', 'force_dc', 'force_re', 'force_im'};
            [value, force_dc, force_re, force_im] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            value = str2double(value);
            force_dc = str2double(force_dc);
            force_re = str2double(force_re);
            force_im = str2double(force_im);
        end
        function [value, force_dc, force_re, force_im] = GetForceY(obj, name, calctype, frequency)
            % Get the y force-component value of a solid. The paradigm for the name is:
            % name (name)               meaning
            % For solids                layername:solidname
            % For coils                 coilname
            % For current pathes        wire:pathname
            % The enum-type of the field under study is defined in the CalcType command.
            functionString = [...
                'Dim value As Double, force_dc As Double, force_re As Double, force_im As Double', newline, ...
                'value = Force.GetForceY(', name, ', ', calctype, ', ', num2str(frequency, '%.15g'), ', force_dc, force_re, force_im)', newline, ...
            ];
            returnvalues = {'value', 'force_dc', 'force_re', 'force_im'};
            [value, force_dc, force_re, force_im] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            value = str2double(value);
            force_dc = str2double(force_dc);
            force_re = str2double(force_re);
            force_im = str2double(force_im);
        end
        function [value, force_dc, force_re, force_im] = GetForceZ(obj, name, calctype, frequency)
            % Get the z force-component value of a solid. The paradigm for the name is:
            % name (name)               meaning
            % For solids                layername:solidname
            % For coils                 coilname
            % For current pathes        wire:pathname
            % The enum-type of the field under study is defined in the CalcType command.
            functionString = [...
                'Dim value As Double, force_dc As Double, force_re As Double, force_im As Double', newline, ...
                'value = Force.GetForceZ(', name, ', ', calctype, ', ', num2str(frequency, '%.15g'), ', force_dc, force_re, force_im)', newline, ...
            ];
            returnvalues = {'value', 'force_dc', 'force_re', 'force_im'};
            [value, force_dc, force_re, force_im] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            value = str2double(value);
            force_dc = str2double(force_dc);
            force_re = str2double(force_re);
            force_im = str2double(force_im);
        end
        function double = GetNormalX(obj, calctype, frequency)
            % Get the x/y/z-component of the axis used for the torque calculation. The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetNormalX', calctype, frequency);
            obj.getnormalx.calctype = calctype;
            obj.getnormalx.frequency = frequency;
        end
        function double = GetNormalY(obj, calctype, frequency)
            % Get the x/y/z-component of the axis used for the torque calculation. The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetNormalY', calctype, frequency);
            obj.getnormaly.calctype = calctype;
            obj.getnormaly.frequency = frequency;
        end
        function double = GetNormalZ(obj, calctype, frequency)
            % Get the x/y/z-component of the axis used for the torque calculation. The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetNormalZ', calctype, frequency);
            obj.getnormalz.calctype = calctype;
            obj.getnormalz.frequency = frequency;
        end
        function double = GetOriginX(obj, calctype, frequency)
            % Get the x/y/z-coordinate of the axis' origin used for the torque calculation. The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetOriginX', calctype, frequency);
            obj.getoriginx.calctype = calctype;
            obj.getoriginx.frequency = frequency;
        end
        function double = GetOriginY(obj, calctype, frequency)
            % Get the x/y/z-coordinate of the axis' origin used for the torque calculation. The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetOriginY', calctype, frequency);
            obj.getoriginy.calctype = calctype;
            obj.getoriginy.frequency = frequency;
        end
        function double = GetOriginZ(obj, calctype, frequency)
            % Get the x/y/z-coordinate of the axis' origin used for the torque calculation. The enum-type of the field under study is defined in the CalcType command.
            double = obj.hForce.invoke('GetOriginZ', calctype, frequency);
            obj.getoriginz.calctype = calctype;
            obj.getoriginz.frequency = frequency;
        end
        function [value, force_dc, force_re, force_im] = GetTorque(obj, name, calctype, frequency)
            % Get the torque value for a solid. The paradigm for the solid's name is described in the GetForce command. The return value is the absolute torque value. In case of low frequency fields the reference value force_dc returns the DC part and torque_re / torque_im the complex part of the torque.
            functionString = [...
                'Dim value As Double, force_dc As Double, force_re As Double, force_im As Double', newline, ...
                'value = Force.GetTorque(', name, ', ', calctype, ', ', num2str(frequency, '%.15g'), ', force_dc, force_re, force_im)', newline, ...
            ];
            returnvalues = {'value', 'force_dc', 'force_re', 'force_im'};
            [value, force_dc, force_re, force_im] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            value = str2double(value);
            force_dc = str2double(force_dc);
            force_re = str2double(force_re);
            force_im = str2double(force_im);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hForce
        history

        calctype
        frequency
        normalx
        normaly
        normalz
        originx
        originy
        originz
        coordinatesystem
        extend2touchingshapes
        forceobject
        computeforcedensity
        getnormalx
        getnormaly
        getnormalz
        getoriginx
        getoriginy
        getoriginz
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
