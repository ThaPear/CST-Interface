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

% Defines a new rigid body motion object.
classdef RigidBodyMotion < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.RigidBodyMotion object.
        function obj = RigidBodyMotion(project, hProject)
            obj.project = project;
            obj.hRigidBodyMotion = hProject.invoke('RigidBodyMotion');
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

            obj.name = [];
        end
        function Name(obj, name)
            % Sets the name of the new rigid body motion object that will be edited or created. Each rigid body motion object name must have a unique name.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Rename(obj, oldname, newname)
            % Rename the specified rigid body motion object.
            obj.project.AddToHistory(['RigidBodyMotion.Rename "', num2str(oldname, '%.15g'), '", '...
                                                             '"', num2str(newname, '%.15g'), '"']);
        end
        function Set(obj, keyword, value)
            % The following keywords are supported:
            % Keyword                             Arguments
            % Type                                string type ("Rotation" or "Translation")
            %                                     Sets the motion type.
            % Active                              bool state (True or False)
            %                                     Activates or deactivates the object for further calculations.
            % AxisOrigin                          double x, double y, double z
            %                                     A point found on the rotation axis (is ignored for translation)
            % AxisNormal                          double x, double y, double z
            %                                     The direction of the rotation axis (for rotation) or the moving direction (for translation)
            % UVector                             double x, double y, double z
            %                                     The direction of the normal to the polygon definition plane for rotation and of the U Axis in the gap polygon definition plane for translation
            % MotionSamples                       double from, double to, int samples
            %                                     Specifies the motion details. For rotations, the start and stop angle should be specified in the from and to values. The number of samples describes the number of positions that will be calculated.
            % MotionDefType                       string type ("Constant speed", "Signal" or "Equation")
            %                                     Sets movement definition motion type.
            % MotionSignal                        name signal
            %                                     The name of the signal used to define the movement
            % MotionSpeed                         double speed
            %                                     The constant motion angular speed (in rpm) or the velocity (in m/s)
            % MotionShift                         double shift
            %                                     The constant motion initial shift (angle in degree for rotation, distance in m for translation)
            % PeriodicityType                     string type  ("Periodic" or "Antiperiodic")
            %                                     Defines the periodicity type of the touched boundaries for the translation
            % MotionEquationCoefficientMass       double mass
            %                                     The mass (translation) or the moment of inertia (rotation) for the motion type "Equation"
            % MotionEquationCoefficientDamping    double damping
            %                                     The damping constant for the motion type "Equation"
            % MotionEquationCoefficientSpring     double spring
            %                                     The spring constant for the motion type "Equation"
            % MotionEquationCoefficientExtForce   double external_force
            %                                     The external force (translation) or torque (rotation) for the motion type "Equation"
            % MotionEquationInitialPosition       double initial_position
            %                                     The initial gap position (angle or displacement) for the motion type "Equation"
            % MotionEquationInitialSpeed          double initial_speed
            %                                     The initial speed (velocity or rotational speed) for the motion type "Equation"
            % (2014) RotationCenter               double x, double y, double z
            %                                     Relevant only for the motion type "Rotation". Specifies the center of the rotor in global coordinates.
            % (2014) WCSOrigin                    double origin_x, double origin_y, double origin_z
            % (2014) WCSNormal                    double normal_x, double normal_y, double normal_z
            % (2014) WCSUVector                   double uvector_x, double uvector_y, double uvector_z
            %                                     Set the origin, the normal (W axis) and the U axis of the coordinate system which is taken as the base for the definition of the translation or rotation axis or the rotation center. All coordinates are specified in global coordinates.
            %                                     For rotations, the rotation center is prescribed by the origin of this coordinate system, whereas the rotation axis corresponds to the U axis. For translations, the translation axis is defined by the W axis (normal) of this coordinate system.


            obj.AddToHistory(['.Set "', num2str(keyword, '%.15g'), '", '...
                                   '"', num2str(value, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the rigid body motion object with the previously made settings.
            obj.AddToHistory(['.Create']);

            % Prepend With RigidBodyMotion and append End With
            obj.history = [ 'With RigidBodyMotion', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define RigidBodyMotion: ', obj.name], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the specified rigid body motion object.
            obj.project.AddToHistory(['RigidBodyMotion.Delete "', num2str(name, '%.15g'), '"']);
        end
        function SetActiveGapItem(obj, name)
            % The specified name must be composed of the corresponding rigid body motion object name, a colon, and the name of the gap item that shall be deleted. Then the named gap item of the given motion object will be selected as the active one. Each motion object can have only one active gap item. However, it could be meaningful, e.g. for testing purposes like mesh generation, to define multiple gap items. If not gap item is set active, then the first one will be set active automatically.
            obj.AddToHistory(['.SetActiveGapItem "', num2str(name, '%.15g'), '"']);
        end
        function DeleteGapItem(obj, name)
            % The specified name must be composed of the corresponding rigid body motion object name, a colon, and the name of the gap item that shall be deleted. For example, the command
            % RigidBodyMotion.DeleteGapItem "MyRotation:MyGap"
            % deletes the gap item MyGap from the rigid body motion object MyRotation.
            obj.AddToHistory(['.DeleteGapItem "', num2str(name, '%.15g'), '"']);
        end
        function RenameGapItem(obj, oldname, newname)
            % Renames the specified gap item. Either name (oldname and newname) must be composed of the corresponding rigid body motion object name, a colon, and the name of the gap item that shall be renamed. For example, the command
            % RigidBodyMotion.RenameGapItem "MyRotation:MyGap", "MyRotation:Gap2"
            % renames the gap item MyGap of the rigid body motion object MyRotation to Gap2. The rigid body motion object name must be identical for the new and the old name.
            obj.AddToHistory(['.RenameGapItem "', num2str(oldname, '%.15g'), '", '...
                                             '"', num2str(newname, '%.15g'), '"']);
        end
        % These are implemented differently below due to the history list
        % code not playing nice with these kinds of functions.
        % function value = Get(obj, keyword)
        %     % Returns the value of the setting specified by keyword for the rigid body motion object which is previously declared with the Name command. Available keywords are listed above in the description of the Set command.
        %     value = obj.hRigidBodyMotion.invoke('Get', keyword);
        % end
        % function str = GetStr(keyword)
        %     % Returns the string value of the setting specified by keyword for the rigid body motion object which is previously declared with the Name command. Available keywords are listed above in the description of the Set command.
        %     value = obj.hRigidBodyMotion.invoke('GetStr', keyword);
        % end
        function value = Get(obj, rbmName, keyword)
            % Returns the value of the setting specified by keyword for the rigid body motion object name. Available keywords are listed above in the description of the Set command.
            obj.hRigidBodyMotion.invoke('Name', rbmName);
            value = obj.hRigidBodyMotion.invoke('Get', keyword);
        end
        function str = GetStr(obj, rbmName, keyword)
            % Returns the string value of the setting specified by keyword for the rigid body motion object name. Available keywords are listed above in the description of the Set command.
            obj.hRigidBodyMotion.invoke('Name', rbmName);
            str = obj.hRigidBodyMotion.invoke('GetStr', keyword);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hRigidBodyMotion
        history

        name
    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% rigidbodymotion = project.RigidBodyMotion();
%     rigidbodymotion.Reset
%     rigidbodymotion.Name('Rotation1');
%     rigidbodymotion.Set('Type', 'Rotation');
%     rigidbodymotion.Set('AxisOrigin',('0.0',('0.0',('0.0');
%     rigidbodymotion.Set('AxisNormal',('0.0',('0.0',('1.0');
%     rigidbodymotion.Set('UVector',('1.0',('0.0',('0.0');
%     rigidbodymotion.Set('Active',  1
%     rigidbodymotion.Set('MotionSamples',('0',('0',('2');
%     rigidbodymotion.Set('MotionDefType',('Constant Speed');
%     rigidbodymotion.Set('MotionSignal',('[Reference]');
%     rigidbodymotion.Set('MotionSpeed',('1.0');
%     rigidbodymotion.Set('MotionShift',('0.0');
%     rigidbodymotion.Set('PeriodicityType',('periodic');
%     rigidbodymotion.Set('MotionEquationCoefficientMass',('1.0');
%     rigidbodymotion.Set('MotionEquationCoefficientDamping',('0.0');
%     rigidbodymotion.Set('MotionEquationCoefficientSpring',('0.0');
%     rigidbodymotion.Set('MotionEquationCoefficientExtForce',('0.0');
%     rigidbodymotion.Set('MotionEquationInitialPosition',('0.0');
%     rigidbodymotion.Set('MotionEquationInitialSpeed',('0.0');
%     rigidbodymotion.Create
%
