%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Defines a waveguide port object. Waveguide ports are used to feed the calculation domain with power and to absorb the returning power. For each waveguide port, time signals and S-Parameters will be recorded during a solver run. In practice the port can be substituted by a longitudinal homogeneous waveguide connected to the structure. You will need at least one port (either waveguide port or discrete port) or a plane wave excitation source to feed the structure, before starting a solver run.
classdef Port < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Port object.
        function obj = Port(project, hProject)
            obj.project = project;
            obj.hPort = hProject.invoke('Port');
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
        function Delete(obj, portnumber)
            % Deletes an existing port.
            obj.AddToHistory(['.Delete "', num2str(portnumber, '%.15g'), '"']);
            obj.delete = portnumber;
            
            % Prepend With Port and append End With
            obj.history = [ 'With Port', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['delete port: ', num2str(portnumber)], obj.history);
            obj.history = [];
        end
        function Rename(obj, oldportnumber, newportnumber)
            % Changes the number of a port
            obj.AddToHistory(['.Rename "', num2str(oldportnumber, '%.15g'), '", '...
                                      '"', num2str(newportnumber, '%.15g'), '"']);
            obj.rename.oldportnumber = oldportnumber;
            obj.rename.newportnumber = newportnumber;
            
            % Prepend With Port and append End With
            obj.history = [ 'With Port', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['rename port: ', num2str(oldportnumber), ' to ', num2str(newportnumber)], obj.history);
            obj.history = [];
        end
        function RenameLabel(obj, portnumber, label)
            % Changes the label of the port with the given number
            obj.AddToHistory(['.RenameLabel "', num2str(portnumber, '%.15g'), '", '...
                                           '"', num2str(label, '%.15g'), '"']);
            obj.renamelabel.portnumber = portnumber;
            obj.renamelabel.label = label;
            
            % Prepend With Port and append End With
            obj.history = [ 'With Port', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['rename port: ', num2str(portnumber), ' to ', num2str(label)], obj.history);
            obj.history = [];
        end
        function int = StartPortNumberIteration(obj)
            % This function resets the counter for an iteration loop over all defined ports and returns the total number of the ports. The port numbers are successively available by using the GetNextportNumber method.
            int = obj.hPort.invoke('StartPortNumberIteration');
        end
        function int = StartSParaPortNumberIteration(obj)
            % Similar to the method above, this function resets the counter for an iteration loop but restricts the loop to S-parameter ports only. Consequently, it  returns the total number of S-parameter ports. The port numbers are successively available by using the GetNextportNumber method.
            int = obj.hPort.invoke('StartSParaPortNumberIteration');
        end
        function int = GetNextPortNumber(obj)
            % This function successively returns the portnumber of the next port, looping over all defined ports. The counter for the iteration loop can be reset using the StartPortNumberIteration method.
            int = obj.hPort.invoke('GetNextPortNumber');
        end
        %% Port Creation / Modification
        function int = LoadContentForModify(obj)
            % If you want to modify an existing port with the Modify command, the first step is, to load the properties of that port. Then you may use methods to change particular settings and call Modify in the end. Loading the content first is mandatory for flawless operation of port modification even if all properties will be overwritten by the Port Settings and Mode Settings commands.
            int = obj.hPort.invoke('LoadContentForModify');
        end
        function Create(obj)
            % Creates a new or modifies an existing waveguide port.
            % Please note, that all necessary settings have to be made previously before calling one of these commands.
            % This also implies that the following Port and Mode Settings in the Port Creation / Modification section cannot be used separately, but only for port creation or modification.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Port and append End With
            obj.history = [ 'With Port', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define port: ', num2str(obj.portnumber)], obj.history);
            obj.history = [];
        end
        function Modify(obj)
            % Creates a new or modifies an existing waveguide port.
            % Please note, that all necessary settings have to be made previously before calling one of these commands.
            % This also implies that the following Port and Mode Settings in the Port Creation / Modification section cannot be used separately, but only for port creation or modification.
            obj.AddToHistory(['.Modify']);
            
            % Prepend With Port and append End With
            obj.history = [ 'With Port', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['modify port: ', num2str(obj.portnumber)], obj.history);
            obj.history = [];
        end
        %% Port Settings
        function PortNumber(obj, portnumber)
            % Chooses the waveguide port by its number.
            obj.AddToHistory(['.PortNumber "', num2str(portnumber, '%.15g'), '"']);
            obj.portnumber = portnumber;
        end
        function Label(obj, label)
            % Sets the label of the port.
            obj.AddToHistory(['.Label "', num2str(label, '%.15g'), '"']);
            obj.label = label;
        end
        function NumberOfModes(obj, modenumber)
            % Sets the number of modes for the waveguide port.
            obj.AddToHistory(['.NumberOfModes "', num2str(modenumber, '%.15g'), '"']);
            obj.numberofmodes = modenumber;
        end
        function Orientation(obj, key)
            % This method defines the orientation, i.e. the direction of excitation, of the waveguide port. "xmin" means that the port is located at the lower x-boundary of the calculation domain and feeds the structure in positive x-direction. This excitation direction is also valid for internal ports, determined by the PortOnBound method.
            %   
            % key = {"xmin", "xmax", "ymin", "ymax", "zmin", "zmax"}
            %   
            % Coordinates ( enum {"Free", "Full", "Picks"} key )
            % This method determines how the transversal expansion of a waveguide port is defined.
            %   
            % key can have one of  the following values:
            % Free
            % The transversal plane of the port is defined by the free input of the dimensions (Xrange, Yrange, Zrange).
            % Full
            % The full plane of the calculation domain will work as the waveguide port.
            % Picks
            % The transversal plane of the port is defined by selected pickpoints.
            obj.AddToHistory(['.Orientation "', num2str(key, '%.15g'), '"']);
            obj.orientation = key;
        end
        function Xrange(obj, xmin, xmax)
            % In case that the transversal  Coordinates of the waveguide port are defined as "Free", these methods determine the range in each direction in global (x, y, z) coordinates.
            obj.AddToHistory(['.Xrange "', num2str(xmin, '%.15g'), '", '...
                                      '"', num2str(xmax, '%.15g'), '"']);
            obj.xrange.xmin = xmin;
            obj.xrange.xmax = xmax;
        end
        function Yrange(obj, ymin, ymax)
            % In case that the transversal  Coordinates of the waveguide port are defined as "Free", these methods determine the range in each direction in global (x, y, z) coordinates.
            obj.AddToHistory(['.Yrange "', num2str(ymin, '%.15g'), '", '...
                                      '"', num2str(ymax, '%.15g'), '"']);
            obj.yrange.ymin = ymin;
            obj.yrange.ymax = ymax;
        end
        function Zrange(obj, zmin, zmax)
            % In case that the transversal  Coordinates of the waveguide port are defined as "Free", these methods determine the range in each direction in global (x, y, z) coordinates.
            obj.AddToHistory(['.Zrange "', num2str(zmin, '%.15g'), '", '...
                                      '"', num2str(zmax, '%.15g'), '"']);
            obj.zrange.zmin = zmin;
            obj.zrange.zmax = zmax;
        end
        function XrangeAdd(obj, xminadd, xmaxadd)
            % In case that the transversal  Coordinates of the waveguide port are defined by selected pickpoints, these methods allow to extend the resulting range in each direction in global (x, y, z) coordinates if the port is axis aligned. If the port is tilted in any way, ZrangeAdd shall only contain "0" values, while XrangeAdd and YrangeAdd are thought to be in port local coordinates. (A coordinate system with u and v is shown, XrangeAdd defines the additionell range in u-direction, whereas YrangeAdd specifies the v-direction additions.)
            obj.AddToHistory(['.XrangeAdd "', num2str(xminadd, '%.15g'), '", '...
                                         '"', num2str(xmaxadd, '%.15g'), '"']);
            obj.xrangeadd.xminadd = xminadd;
            obj.xrangeadd.xmaxadd = xmaxadd;
        end
        function YrangeAdd(obj, yminadd, ymaxadd)
            % In case that the transversal  Coordinates of the waveguide port are defined by selected pickpoints, these methods allow to extend the resulting range in each direction in global (x, y, z) coordinates if the port is axis aligned. If the port is tilted in any way, ZrangeAdd shall only contain "0" values, while XrangeAdd and YrangeAdd are thought to be in port local coordinates. (A coordinate system with u and v is shown, XrangeAdd defines the additionell range in u-direction, whereas YrangeAdd specifies the v-direction additions.)
            obj.AddToHistory(['.YrangeAdd "', num2str(yminadd, '%.15g'), '", '...
                                         '"', num2str(ymaxadd, '%.15g'), '"']);
            obj.yrangeadd.yminadd = yminadd;
            obj.yrangeadd.ymaxadd = ymaxadd;
        end
        function ZrangeAdd(obj, zminadd, zmaxadd)
            % In case that the transversal  Coordinates of the waveguide port are defined by selected pickpoints, these methods allow to extend the resulting range in each direction in global (x, y, z) coordinates if the port is axis aligned. If the port is tilted in any way, ZrangeAdd shall only contain "0" values, while XrangeAdd and YrangeAdd are thought to be in port local coordinates. (A coordinate system with u and v is shown, XrangeAdd defines the additionell range in u-direction, whereas YrangeAdd specifies the v-direction additions.)
            obj.AddToHistory(['.ZrangeAdd "', num2str(zminadd, '%.15g'), '", '...
                                         '"', num2str(zmaxadd, '%.15g'), '"']);
            obj.zrangeadd.zminadd = zminadd;
            obj.zrangeadd.zmaxadd = zmaxadd;
        end
        function PortOnBound(obj, flag)
            % This method decides if the port is located on the boundaries of the calculation domain (flag = True) or could be located inside the calculation domain due to its normal position definition (Xrange, Yrange or Zrange method) (flag = False). This method is not relevant for picked ports, since here the location is determined by the picked face.
            obj.AddToHistory(['.PortOnBound "', num2str(flag, '%.15g'), '"']);
            obj.portonbound = flag;
        end
        function ClipPickedPortToBound(obj, flag)
            % In case of a picked port this method decides if the port  plane should be located  on the boundaries of the calculation domain (flag = True) or should be defined correspondent to the pick information (flag = False). In general this method should not be used, since the intention is to locate the port due to its pick information.
            obj.AddToHistory(['.ClipPickedPortToBound "', num2str(flag, '%.15g'), '"']);
            obj.clippickedporttobound = flag;
        end
        function TextSize(obj, value)
            obj.AddToHistory(['.TextSize "', num2str(value, '%.15g'), '"']);
            obj.textsize = value;
        end
        function ChangeTextSize(obj, portnumber, value)
            % Determines the textsize of the labeling of a new created or an existing waveguide port, specified by its portnumber. The relative textsize can be defined as an integer value between 1 and 100.
            obj.AddToHistory(['.ChangeTextSize "', num2str(portnumber, '%.15g'), '", '...
                                              '"', num2str(value, '%.15g'), '"']);
            obj.changetextsize.portnumber = portnumber;
            obj.changetextsize.value = value;
        end
        function TextMaxLimit(obj, flag)
            % If set to zero the port label may exceed the size of the port depending on TextSize. Otherwise the label textsize will be fitted until the label is completely within the boundary of the port.
            obj.AddToHistory(['.TextMaxLimit "', num2str(flag, '%.15g'), '"']);
            obj.textmaxlimit = flag;
        end
        function ReferencePlaneDistance(obj, dist)
            % Sets the distance to the reference plane. The S-Parameters will then be calculated (phase deembedded) related to this reference plane. A negative distance corresponds to a reference plane inside the structure, a  positive distance to an outside located plane.
            obj.AddToHistory(['.ReferencePlaneDistance "', num2str(dist, '%.15g'), '"']);
            obj.referenceplanedistance = dist;
        end
        %% Mode Settings
        function AddPotentialNumerically(obj, modeset, potential, upos, vpos)
            % This method adds and defines a new potential setting to a specific modeset of a multipin waveguide port. The location of the potential can be defined either numerically (upos, vpos) or by selecting a PEC solid face or edge in the port plane, determined by its corresponding name and face_id or edge_id.
            %   
            % The potential can have one of  the following values:
            % Positive
            % Defines a positive electrical potential setting.
            % Negative
            % Defines a negative electrical potential setting.
            % potential,: 'Positive'
            %             'Negative'
            obj.AddToHistory(['.AddPotentialNumerically "', num2str(modeset, '%.15g'), '", '...
                                                       '"', num2str(potential, '%.15g'), '", '...
                                                       '"', num2str(upos, '%.15g'), '", '...
                                                       '"', num2str(vpos, '%.15g'), '"']);
            obj.addpotentialnumerically.modeset = modeset;
            obj.addpotentialnumerically.potential = potential;
            obj.addpotentialnumerically.upos = upos;
            obj.addpotentialnumerically.vpos = vpos;
        end
        function AddPotentialPicked(obj, modeset, potential, name, face_id)
            % This method adds and defines a new potential setting to a specific modeset of a multipin waveguide port. The location of the potential can be defined either numerically (upos, vpos) or by selecting a PEC solid face or edge in the port plane, determined by its corresponding name and face_id or edge_id.
            %   
            % The potential can have one of  the following values:
            % Positive
            % Defines a positive electrical potential setting.
            % Negative
            % Defines a negative electrical potential setting.
            % potential,: 'Positive'
            %             'Negative'
            obj.AddToHistory(['.AddPotentialPicked "', num2str(modeset, '%.15g'), '", '...
                                                  '"', num2str(potential, '%.15g'), '", '...
                                                  '"', num2str(name, '%.15g'), '", '...
                                                  '"', num2str(face_id, '%.15g'), '"']);
            obj.addpotentialpicked.modeset = modeset;
            obj.addpotentialpicked.potential = potential;
            obj.addpotentialpicked.name = name;
            obj.addpotentialpicked.face_id = face_id;
        end
        function AddPotentialEdgePicked(obj, modeset, potential, name, fedge_id)
            % This method adds and defines a new potential setting to a specific modeset of a multipin waveguide port. The location of the potential can be defined either numerically (upos, vpos) or by selecting a PEC solid face or edge in the port plane, determined by its corresponding name and face_id or edge_id.
            %   
            % The potential can have one of  the following values:
            % Positive
            % Defines a positive electrical potential setting.
            % Negative
            % Defines a negative electrical potential setting.
            % potential,: 'Positive'
            %             'Negative'
            obj.AddToHistory(['.AddPotentialEdgePicked "', num2str(modeset, '%.15g'), '", '...
                                                      '"', num2str(potential, '%.15g'), '", '...
                                                      '"', num2str(name, '%.15g'), '", '...
                                                      '"', num2str(fedge_id, '%.15g'), '"']);
            obj.addpotentialedgepicked.modeset = modeset;
            obj.addpotentialedgepicked.potential = potential;
            obj.addpotentialedgepicked.name = name;
            obj.addpotentialedgepicked.fedge_id = fedge_id;
        end
        function AdjustPolarization(obj, flag)
            % Switch that decides if the polarization of the electric field should be adjusted or not. This method works together with the PolarizationAngle method.
            % Note: Only works if two or more degenerated modes exists.
            obj.AddToHistory(['.AdjustPolarization "', num2str(flag, '%.15g'), '"']);
            obj.adjustpolarization = flag;
        end
        function PolarizationAngle(obj, angle)
            % If you have activated the AdjustPolarization switch, here the polarization angle can be defined.
            obj.AddToHistory(['.PolarizationAngle "', num2str(angle, '%.15g'), '"']);
            obj.polarizationangle = angle;
        end
        function PortImpedanceAndCalibration(obj, flag)
            % This switch activates the enhanced impedance and calibration evaluation for the port, based on the definition of corresponding reference lines. The lines are defined with help of the AddLineByPoint, AddLineByFace or AddLineByBoundary method and assigned to the mode with the AddModeLine method.
            obj.AddToHistory(['.PortImpedanceAndCalibration "', num2str(flag, '%.15g'), '"']);
            obj.portimpedanceandcalibration = flag;
        end
        function AddModeLineByPoint(obj, linenumber, xstart, ystart, zstart, xend, yend, zend, reverse)
            % Adds a new line with a given linenumber to the port mode description. xstart / ystart / zstart defines the start point  and xend / yend / zend the end point. Afterwards the defined line can be used as an impedance, calibration or polarization reference with help of the AddModeLine method. The reverse flag toggles the start and end point.
            obj.AddToHistory(['.AddModeLineByPoint "', num2str(linenumber, '%.15g'), '", '...
                                                  '"', num2str(xstart, '%.15g'), '", '...
                                                  '"', num2str(ystart, '%.15g'), '", '...
                                                  '"', num2str(zstart, '%.15g'), '", '...
                                                  '"', num2str(xend, '%.15g'), '", '...
                                                  '"', num2str(yend, '%.15g'), '", '...
                                                  '"', num2str(zend, '%.15g'), '", '...
                                                  '"', num2str(reverse, '%.15g'), '"']);
            obj.addmodelinebypoint.linenumber = linenumber;
            obj.addmodelinebypoint.xstart = xstart;
            obj.addmodelinebypoint.ystart = ystart;
            obj.addmodelinebypoint.zstart = zstart;
            obj.addmodelinebypoint.xend = xend;
            obj.addmodelinebypoint.yend = yend;
            obj.addmodelinebypoint.zend = zend;
            obj.addmodelinebypoint.reverse = reverse;
        end
        function AddModeLineByFace(obj, linenumber, xstart, ystart, zstart, name, face_id, reverse)
            % Adds a new line with a given linenumber to the port mode description. xstart / ystart / zstart defines the start point. The end point is determined by the nearest point on the face face_id of the solid name. The face needs to be a planar face on the port plane . Afterwards the defined line can be used as an impedance, calibration or polarization reference with help of the AddModeLine method. The reverse flag toggles the start and end point.
            obj.AddToHistory(['.AddModeLineByFace "', num2str(linenumber, '%.15g'), '", '...
                                                 '"', num2str(xstart, '%.15g'), '", '...
                                                 '"', num2str(ystart, '%.15g'), '", '...
                                                 '"', num2str(zstart, '%.15g'), '", '...
                                                 '"', num2str(name, '%.15g'), '", '...
                                                 '"', num2str(face_id, '%.15g'), '", '...
                                                 '"', num2str(reverse, '%.15g'), '"']);
            obj.addmodelinebyface.linenumber = linenumber;
            obj.addmodelinebyface.xstart = xstart;
            obj.addmodelinebyface.ystart = ystart;
            obj.addmodelinebyface.zstart = zstart;
            obj.addmodelinebyface.name = name;
            obj.addmodelinebyface.face_id = face_id;
            obj.addmodelinebyface.reverse = reverse;
        end
        function AddModeLineByBoundary(obj, linenumber, xstart, ystart, zstart, position, reverse)
            % Adds a new line with a given linenumber to the port mode description. xstart / ystart / zstart defines the start point. The end point is determined by the port boundary at position. The line will be perpendicular on the port boundary. Afterwards the defined line can be used as an impedance, calibration or polarization reference with help of the AddModeLine method. The reverse flag toggles the start and end point.
            % position,: 'Umin'
            %            'Umax'
            %            'Vmin'
            %            'Vmax'
            obj.AddToHistory(['.AddModeLineByBoundary "', num2str(linenumber, '%.15g'), '", '...
                                                     '"', num2str(xstart, '%.15g'), '", '...
                                                     '"', num2str(ystart, '%.15g'), '", '...
                                                     '"', num2str(zstart, '%.15g'), '", '...
                                                     '"', num2str(position, '%.15g'), '", '...
                                                     '"', num2str(reverse, '%.15g'), '"']);
            obj.addmodelinebyboundary.linenumber = linenumber;
            obj.addmodelinebyboundary.xstart = xstart;
            obj.addmodelinebyboundary.ystart = ystart;
            obj.addmodelinebyboundary.zstart = zstart;
            obj.addmodelinebyboundary.position = position;
            obj.addmodelinebyboundary.reverse = reverse;
        end
        function AddModeLine(obj, modenumber, impedance_linenumber, calibration_linenumber, polarization_linenumber)
            % This method assigns previously defined lines to a port mode, specified by its modenumber, and are used as references for the evaluation of the impedance, calibration and polarization of the mode. The lines are indicated by their linenumber and can be represented by only one or even three different lines. All of them have to be defined previously by using the AddLineByPoint, AddLineByFace or AddLineByBoundary method.
            obj.AddToHistory(['.AddModeLine "', num2str(modenumber, '%.15g'), '", '...
                                           '"', num2str(impedance_linenumber, '%.15g'), '", '...
                                           '"', num2str(calibration_linenumber, '%.15g'), '", '...
                                           '"', num2str(polarization_linenumber, '%.15g'), '"']);
            obj.addmodeline.modenumber = modenumber;
            obj.addmodeline.impedance_linenumber = impedance_linenumber;
            obj.addmodeline.calibration_linenumber = calibration_linenumber;
            obj.addmodeline.polarization_linenumber = polarization_linenumber;
        end
        function SetEstimation(obj, portnumber, value)
            % Defines an estimation of the propagation constant for the mode calculation of a waveguide port, specified by its portname. A positive value refers to the propagation constant beta, a negative value to the damping constant alpha. This method is necessary only for some special application cases, normally it need not to be used.
            % Note: The made setting is only valid for one solver run and will not be stored in the project files.
            obj.AddToHistory(['.SetEstimation "', num2str(portnumber, '%.15g'), '", '...
                                             '"', num2str(value, '%.15g'), '"']);
            obj.setestimation.portnumber = portnumber;
            obj.setestimation.value = value;
        end
        function SingleEnded(obj, flag)
            % This method offers the possibility to automatically recalculate the scattering parameters as a post-processing step due to previously defined single-ended multipin ports. Consequently during setup of the multipin definition a separate mode set has to be created for each of the inner conductors, i.e. one (usually the outermost) conductor remains undefined representing the ground conductor.
            % Note: All ports has to be defined as single-ended type in this way, otherwise the simulation can not be started. By applying single-ended port mode calculation the solvers automatically activate renormalization to fixed impedance, however, the impedance value itself can be modified in the corresponding solver dialog box before starting the simulation.
            obj.AddToHistory(['.SingleEnded "', num2str(flag, '%.15g'), '"']);
            obj.singleended = flag;
        end
        function Shield(obj, key)
            % The boundary of the waveguide port is treated as a perfectly shielding (PEC) frame when calling this method with key = "PEC".
            % key: 'none'
            %      'PEC'
            obj.AddToHistory(['.Shield "', num2str(key, '%.15g'), '"']);
            obj.shield = key;
        end
        %% Queries
        function double = GetFrequency(obj, portnumber, modenumber)
            % Returns the calculation frequency of a port mode, specified by its portnumber and modenumber.
            % For homogeneous waveguide port modes this function returns the frequency for which the modes have been calculated. If there are multiple mode evaluation frequencies at an inhomogeneous port the center frequency of the chosen frequency range is returned.
            % Note: The given frequency also corresponds to the calculated port parameters as the propagation constant beta, the damping constant alpha and the different impedance values.
            double = obj.hPort.invoke('GetFrequency', portnumber, modenumber);
            obj.getfrequency.portnumber = portnumber;
            obj.getfrequency.modenumber = modenumber;
        end
        function double = GetFcutoff(obj, portnumber, modenumber)
            % In case of a TE or TM mode, this function returns the Cutoff Frequency for the port mode, specified by its portnumber and modenumber.
            double = obj.hPort.invoke('GetFcutoff', portnumber, modenumber);
            obj.getfcutoff.portnumber = portnumber;
            obj.getfcutoff.modenumber = modenumber;
        end
        function enum = GetModeType(obj, portnumber, modenumber)
            % This function returns the mode type of  the port mode, specified by its portnumber and modenumber.
            %   
            % The return type can have one of the following values:
            % TE
            % Mode with a transverse electric field
            % TM
            % Mode with a transverse magnetic field
            % TEM
            % Mode with a transverse electromagnetic field
            % QTEM
            % Mode with a quasi-transverse electromagnetic field
            % UNDEF
            % Unknown mode type.
            % DAMPED
            % Currently not used.
            % "PLANE WAVE"
            % Plane wave mode type
            % "FLOQUET"
            % Floquet mode type
            enum = obj.hPort.invoke('GetModeType', portnumber, modenumber);
            obj.getmodetype.portnumber = portnumber;
            obj.getmodetype.modenumber = modenumber;
        end
        function double = GetBeta(obj, portnumber, modenumber)
            % This function returns the beta value (equivalent to the propagation constant) of  the port mode, specified by its portnumber and modenumber. It is calculated at the frequency returned by GetFrequency method.
            double = obj.hPort.invoke('GetBeta', portnumber, modenumber);
            obj.getbeta.portnumber = portnumber;
            obj.getbeta.modenumber = modenumber;
        end
        function double = GetAlpha(obj, portnumber, modenumber)
            % This function returns the alpha value (equivalent to the damping constant) of  the port mode, specified by its portnumber and modenumber. It is calculated at the frequency returned by GetFrequency method.
            double = obj.hPort.invoke('GetAlpha', portnumber, modenumber);
            obj.getalpha.portnumber = portnumber;
            obj.getalpha.modenumber = modenumber;
        end
        function double = GetAccuracy(obj, portnumber, modenumber)
            % This function returns the accuracy of the eigenmode calculation of  the port mode, specified by its portnumber and modenumber.
            double = obj.hPort.invoke('GetAccuracy', portnumber, modenumber);
            obj.getaccuracy.portnumber = portnumber;
            obj.getaccuracy.modenumber = modenumber;
        end
        function double = GetWaveImpedance(obj, portnumber, modenumber)
            % This function returns the wave impedance of  the port mode, specified by its portnumber and modenumber.
            double = obj.hPort.invoke('GetWaveImpedance', portnumber, modenumber);
            obj.getwaveimpedance.portnumber = portnumber;
            obj.getwaveimpedance.modenumber = modenumber;
        end
        function double = GetLineImpedance(obj, portnumber, modenumber)
            % This function returns the line impedance of  the port mode, specified by its portnumber and modenumber. Please note, that this method is only reasonable for "TEM" or "Quasi TEM" mode types, otherwise the return value is zero.
            double = obj.hPort.invoke('GetLineImpedance', portnumber, modenumber);
            obj.getlineimpedance.portnumber = portnumber;
            obj.getlineimpedance.modenumber = modenumber;
        end
        function double = GetLineImpedanceBroadByIndex(obj, portnumber, modenumber, index)
            % This function returns the line impedance of  the port mode, specified by its portnumber and modenumber. The impedance value is given at a specific frequency, either determined by the frequency value itself or a corresponding index. Please note, that this method is only reasonable for "TEM" or "Quasi TEM" mode types, otherwise the return value is zero.
            double = obj.hPort.invoke('GetLineImpedanceBroadByIndex', portnumber, modenumber, index);
            obj.getlineimpedancebroadbyindex.portnumber = portnumber;
            obj.getlineimpedancebroadbyindex.modenumber = modenumber;
            obj.getlineimpedancebroadbyindex.index = index;
        end
        function double = GetLineImpedanceBroadByFreq(obj, portnumber, modenumber, frequency)
            % This function returns the line impedance of  the port mode, specified by its portnumber and modenumber. The impedance value is given at a specific frequency, either determined by the frequency value itself or a corresponding index. Please note, that this method is only reasonable for "TEM" or "Quasi TEM" mode types, otherwise the return value is zero.
            double = obj.hPort.invoke('GetLineImpedanceBroadByFreq', portnumber, modenumber, frequency);
            obj.getlineimpedancebroadbyfreq.portnumber = portnumber;
            obj.getlineimpedancebroadbyfreq.modenumber = modenumber;
            obj.getlineimpedancebroadbyfreq.frequency = frequency;
        end
        function enum = GetType(obj, portnumber)
            % This function returns the type of an existing port, specified by its portnumber.
            enum = obj.hPort.invoke('GetType', portnumber);
            obj.gettype = portnumber;
        end
        function int = GetNumberOfModes(obj, portnumber)
            % This function returns the number of modes of an existing port, specified by its portnumber.
            int = obj.hPort.invoke('GetNumberOfModes', portnumber);
            obj.getnumberofmodes = portnumber;
        end
        function [orientation, xmin, xmax, ymin, ymax, zmin, zmax] = GetPortMeshLocation(obj, portnumber)
            % This function returns the mesh line location of an existing port, specified by its portnumber.
            %    
            % The reference values have the following meaning:
            % orientation           0 (xmin), 1 (xmax), 2 (ymin), 3 (ymax), 4 (zmin), 5(zmax), correspondent to the Orientation method.
            % ixmin / ixmax         The min / max  meshline number in x-direction.
            % iymin / iymax         The min / max  meshline number in y-direction.
            % izmin / izmax         The min / max  meshline number in z-direction.
            functionString = [...
                'Dim orientation As Long, xmin As Long, xmax As Long, ymin As Long, ymax As Long, zmin As Long, zmax As Long', newline, ...
                'Port.GetPortMeshLocation(', num2str(portnumber), ', orientation, xmin, xmax, ymin, ymax, zmin, zmax)', newline, ...
            ];
            returnvalues = {'orientation', 'xmin', 'xmax', 'ymin', 'ymax', 'zmin', 'zmax'};
            [orientation, xmin, xmax, ymin, ymax, zmin, zmax] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            orientation = str2double(orientation);
            xmin = str2double(xmin);
            xmax = str2double(xmax);
            ymin = str2double(ymin);
            ymax = str2double(ymax);
            zmin = str2double(zmin);
            zmax = str2double(zmax);
        end
        function [orientation, xmin, xmax, ymin, ymax, zmin, zmax] = GetPortMeshCoordinates(obj, portnumber)
            % This function returns the mesh line coordinates in local units of an existing port, specified by its portnumber.
            %    
            % The reference values have the following meaning:
            % orientation           0 (xmin), 1 (xmax), 2 (ymin), 3 (ymax), 4 (zmin), 5(zmax), correspondent to the Orientation method.
            % dxmin / dxmax         The min / max mesh location in x-direction.
            % dymin / dymax         The min / max mesh location in y-direction.
            % dzmin / dzmax         The min / max mesh location in z-direction.
            functionString = [...
                'Dim orientation As Long', newline, ...
                'Dim xmin As Double, xmax As Double, ymin As Double, ymax As Double, zmin As Double, zmax As Double', newline, ...
                'Port.GetPortMeshCoordinates(', num2str(portnumber), ', orientation, xmin, xmax, ymin, ymax, zmin, zmax)', newline, ...
            ];
            returnvalues = {'orientation', 'xmin', 'xmax', 'ymin', 'ymax', 'zmin', 'zmax'};
            [orientation, xmin, xmax, ymin, ymax, zmin, zmax] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            orientation = str2double(orientation);
            xmin = str2double(xmin);
            xmax = str2double(xmax);
            ymin = str2double(ymin);
            ymax = str2double(ymax);
            zmin = str2double(zmin);
            zmax = str2double(zmax);
        end
        function [xcenter, ycenter, zcenter] = GetPortCenterCoordinates(obj, portnumber)
            % This function returns the center point of a waveguide or discrete port, specified by its portnumber.
            functionString = [...
                'Dim xcenter As Double, ycenter As Double, zcenter As Double', newline, ...
                'Port.GetPortCenterCoordinates(', num2str(portnumber), ', xcenter, ycenter, zcenter)', newline, ...
            ];
            returnvalues = {'xcenter', 'ycenter', 'zcenter'};
            [xcenter, ycenter, zcenter] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            xcenter = str2double(xcenter);
            ycenter = str2double(ycenter);
            zcenter = str2double(zcenter);
        end
        function [faceporttype, sizevalue1, sizevalue2] = GetFacePortTypeAndSize(obj, portnumber)
            % This function returns characteristic values of the discrete face port of a special
            % geometry type (enumerated by faceporttype).
            % The size value parameters  have the following meaning:
            % faceporttype      type                            sizevalue1                  sizevalue2 
            % 0                 unknown                         ---                         ---
            % 1                 rectangular                     width                       length
            % 2                 barrel shaped / cylindrical     radius                      length
            % 3                 coaxial                         radius of excited edge      radius of ground edge
            functionString = [...
                'Dim faceporttype As Long', newline, ...
                'Dim sizevalue1 As Double, sizevalue2 As Double', newline, ...
                'Port.GetFacePortTypeAndSize(', num2str(portnumber), ', faceporttype, sizevalue1, sizevalue2)', newline, ...
            ];
            returnvalues = {'faceporttype', 'sizevalue1', 'sizevalue2'};
            [faceporttype, sizevalue1, sizevalue2] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            faceporttype = str2double(faceporttype);
            sizevalue1 = str2double(sizevalue1);
            sizevalue2 = str2double(sizevalue2);
        end
        function string = GetLabel(obj, portnumber)
            % This function returns the label of the port.
            string = obj.hPort.invoke('GetLabel', portnumber);
            obj.getlabel = portnumber;
        end
        %% Undocumented functions.
        % Found in history list upon creating a waveguide port.
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);
        end
        % Found in history list upon creating a waveguide port.
        function Coordinates(obj, coords)
            % coords: Picks, Full
            obj.AddToHistory(['.Coordinates "', coords, '"']);
        end
        % Found in history list upon creating a waveguide port.
        function Folder(obj, folder)
            obj.AddToHistory(['.Folder "', folder, '"']);
        end
        % Found in history list upon creating a waveguide port.
        function WaveguideMonitor(obj, boolean)
            obj.AddToHistory(['.WaveguideMonitor "', num2str(boolean, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPort
        history

        delete
        rename
        renamelabel
        portnumber
        label
        numberofmodes
        orientation
        xrange
        yrange
        zrange
        xrangeadd
        yrangeadd
        zrangeadd
        portonbound
        clippickedporttobound
        textsize
        changetextsize
        textmaxlimit
        referenceplanedistance
        addpotentialnumerically
        addpotentialpicked
        addpotentialedgepicked
        adjustpolarization
        polarizationangle
        portimpedanceandcalibration
        addmodelinebypoint
        addmodelinebyface
        addmodelinebyboundary
        addmodeline
        setestimation
        singleended
        shield
        getfrequency
        getfcutoff
        getmodetype
        getbeta
        getalpha
        getaccuracy
        getwaveimpedance
        getlineimpedance
        getlineimpedancebroadbyindex
        getlineimpedancebroadbyfreq
        gettype
        getnumberofmodes
        getportmeshlocation
        getportmeshcoordinates
        getportcentercoordinates
        getfaceporttypeandsize
        getlabel
    end
end

%% Default Settings
% Label(');');
% NumberOfModes(1)
% AdjustPolarization(0)
% PolarizationAngle(0.0)
% ReferencePlaneDistance(0.0)
% TextSize(50)
% Coordinates('Free');
% Orientation('zmin');
% PortOnBound(0)
% ClipPickedPortToBound(0)
% Xrange(0.0, 0.0)
% Yrange(0.0, 0.0)
% Zrange(0.0, 0.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% port = project.Port();
%     port.Reset
%     port.PortNumber(1)
%     port.NumberOfModes(2)
%     port.AdjustPolarization(0)
%     port.PolarizationAngle(0.0)
%     port.ReferencePlaneDistance(-5)
%     port.TextSize(50)
%     port.Coordinates('Free');
%     port.Orientation('zmax');
%     port.PortOnBound(0)
%     port.ClipPickedPortToBound(0)
%     port.Xrange(-1, 1)
%     port.Yrange(-0.3, 0.2)
%     port.Zrange(1.1, 1.1)
%     port.Create
% 
%     port.Reset
%     port.PortNumber(2)
%     port.ReferencePlaneDistance(0)
%     port.TextSize(50)
%     port.Coordinates('Full');
%     port.Orientation('zmin');
%     port.PortOnBound(1)
%     port.ClipPickedPortToBound(0)
%     port.Xrange(-9.2, 9.2)
%     port.Yrange(-9.2, 9.2)
%     port.Zrange(0.0, 0.0)
%     port.AddPotentialNumerically(1, 'Positive', -2.0, 0.0)
%     port.AddPotentialNumerically(1, 'Positive', 2.0, 0.0)
%     port.AddPotentialNumerically(2, 'Positive', -2.0, 0.0)
%     port.AddPotentialNumerically(2, 'Negative', 2.0, 0.0)
%     port.Create
