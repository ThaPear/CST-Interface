%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  
classdef ExternalPort < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.DS.Project)
        % Only CST.DS.Project can create a ExternalPort object.
        function obj = ExternalPort(dsproject, hDSProject)
            obj.dsproject = dsproject;
            obj.hExternalPort = hDSProject.invoke('ExternalPort');
        end
    end
    %% CST Object functions.
    methods
        function Create(obj)
            % Creates a new external port.
            obj.hExternalPort.invoke('Create');
        end
        function Delete(obj)
            % Deletes the currently selected external port.
            obj.hExternalPort.invoke('Delete');
        end
        function bool = DoesExist(obj)
            % Checks if an external port with the currently selected number already exists.
            bool = obj.hExternalPort.invoke('DoesExist');
        end
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.hExternalPort.invoke('Reset');
        end
        %% Identification
        function Name(obj, portname)
            % Sets the name of an external port before calling Create. Furthermore, this method can be used to select an existing external port of your model. The name must either be an integer number or of the form "n(m)", where n is the integer number of the port and m is the mode index. The latter form is used for higher order mode ports.
            obj.hExternalPort.invoke('Name', portname);
        end
        function Number(obj, portnumber)
            % Sets the number of an external port before calling Create. Furthermore, this method can be used to select an existing external port of your model.
            obj.hExternalPort.invoke('Number', portnumber);
        end
        %% Getter
        function int = GetNumber(obj)
            % Returns the external port's number.
            int = obj.hExternalPort.invoke('GetNumber');
        end
        %% Setter
        function SetName(obj, portname)
            % Modifies the name of an existing external port. The name must either be an integer number or of the form "n(m)", where n is the integer number of the port and m is the mode index. The latter form is used for higher order mode ports.
            obj.hExternalPort.invoke('SetName', portname);
        end
        function SetNumber(obj, portnumber)
            % Modifies the number of an existing external port.
            obj.hExternalPort.invoke('SetNumber', portnumber);
        end
        function SetHigherOrderMode(obj, higher, mode)
            % Switches on/off the higher order mode naming convention for an external port.
            obj.hExternalPort.invoke('SetHigherOrderMode', higher, mode);
        end
        function SetImpedanceType(obj, type)
            % Sets the external port's impedance type. This setting must be called for already existing ports.
            % type = 0
            % block dependent
            % type = 1
            % fixed value
            % type = 2
            % file dependent
            obj.hExternalPort.invoke('SetImpedanceType', type);
        end
        function SetImpedance(obj, value)
            % Sets a value to the port's  fixed real impedance property. Call "SetImpedanceType(1)" to use this impedance in the simulation. This setting must be called for already existing ports.
            obj.hExternalPort.invoke('SetImpedance', value);
        end
        function SetComplexImpedance(obj, re, im)
            % Sets the real and the imaginary values to the port's  fixed complex impedance property. Call "SetImpedanceType(1)" to use this impedance in the simulation. This setting must be called for already existing ports.
            obj.hExternalPort.invoke('SetComplexImpedance', re, im);
        end
        function SetImpedanceFileName(obj, filename)
            % Sets the file name of a "s1p" touchstone file, specifying a frequency dependent port impedance. The file may contain either impedances, admittances or reflection coefficients. Call "SetImpedanceType(2)" to use this impedance in the simulation. This setting must be called for already existing ports.
            obj.hExternalPort.invoke('SetImpedanceFileName', filename);
        end
        function SetLocalUnitForImpedance(obj, unit)
            % Sets the given impedance unit for the external port's impedance, i.e. the impedance's value will not refer to the project's global unit any more but to this local unit.
            obj.hExternalPort.invoke('SetLocalUnitForImpedance', unit);
        end
        function SetGlobalUnitForImpedance(obj)
            % Sets the global impedance unit for the external port's impedance.
            obj.hExternalPort.invoke('SetGlobalUnitForImpedance');
        end
        function SetDifferential(obj, differential)
            % Makes the external port a differential port, i.e. its reference pin can be accessed.
            obj.hExternalPort.invoke('SetDifferential', differential);
        end
        %% Iteration
        function int = StartPortNameIteration(obj)
            % Resets the iterator for external ports and returns the number of external ports.
            int = obj.hExternalPort.invoke('StartPortNameIteration');
        end
        function name = GetNextPortName(obj)
            % Returns the next external port's name. Call StartPortNameIteration before the first call of this method.
            name = obj.hExternalPort.invoke('GetNextPortName');
        end
        %% Positioning
        function Position(obj, x, y)
            % Specifies the position of the external port. This setting must be made before calling Create. Furthermore, it can be used to modify an external port's position. Possible values are 0 < x, y <100000, i.e. (50000, 50000) is the center of the schematic. It is always ensured that the external port is aligned with the grid, therefore the specified position might get adjusted slightly.
            obj.hExternalPort.invoke('Position', x, y);
        end
        function Rotate(obj, angle)
            % Rotates the external port by the given angle in degrees around its center point. If this setting is made before calling Create, the angle is only stored. The rotation will then be done in Create.
            obj.hExternalPort.invoke('Rotate', angle);
        end
        function Move(obj, x, y)
            % Moves an external port by the given offset. Note that the schematic size is given by 0 < x, y <100000. Use Position to specify a certain location. It is always ensured that the external port is aligned with the grid, therefore the specified offset might get adjusted slightly.
            obj.hExternalPort.invoke('Move', x, y);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hExternalPort

    end
end

%% Default Settings
% Position(50000, 50000)

%% Example - Taken from CST documentation and translated to MATLAB.
% %Create an external port
% 
% externalport = dsproject.ExternalPort();
% .Reset
% .Number(1)
% .Position(50000, 50000)
% .Create
% .SetImpedanceType 1 % Set fixed impedance
% .SetImpedance 50
% 
% %Modify an existing external port%s position
% 
% .Reset
% .Number(1)
% .Position(57000, 50500) % Move to absolute position(57000, 50500)
% .Move(7000, 500) % Move by offset(7000, 500) relative to old position
% 
% 
