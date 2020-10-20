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

% Defines 3D or 2D field monitors. Each monitor stores the field values either for a specified frequency or for a set of time samples. There are different kinds of monitors: magnetic and electric field or energy monitors as well as farfield, power flow and current monitors.
classdef Monitor < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Monitor object.
        function obj = Monitor(project, hProject)
            obj.project = project;
            obj.hMonitor = hProject.invoke('Monitor');
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
            % Resets all internal values to their default settings.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
            obj.fieldtype = [];
            obj.domain = [];
            obj.frequency = [];
            obj.tstart = [];
            obj.tstep = [];
            obj.tend = [];
        end
        function Name(obj, monitorName)
            % Sets the name of the monitor.
            obj.AddToHistory(['.Name "', num2str(monitorName, '%.15g'), '"']);
            obj.name = monitorName;
        end
        function Rename(obj, oldName, newName)
            % Renames the monitor named oldName to newName.
            obj.project.AddToHistory(['Monitor.Rename "', num2str(oldName, '%.15g'), '", '...
                                                     '"', num2str(newName, '%.15g'), '"']);
        end
        function Delete(obj, monitorName)
            % Deletes the monitor named monitorName.
            obj.project.AddToHistory(['Monitor.Delete "', num2str(monitorName, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the monitor with the previously applied settings.
            % Used for single-frequency monitors and time-domain monitors.
            if(isempty(obj.name))
                if(strcmp(obj.domain, 'Time'))
                    if(~isempty(obj.tend) && obj.tend); tend = num2str(obj.tend); else; tend = 'end'; end %#ok<PROP>
                    obj.Name([obj.fieldtype, ' (t=', num2str(obj.tstart), '..', tend, '(', num2str(obj.tstep), '))']); %#ok<PROP>
                else
                    obj.Name([obj.fieldtype, ' (f=', num2str(obj.frequency), ')']);
                end
            end

            obj.AddToHistory(['.Create']);

            % Prepend With and append End With
            obj.history = ['With Monitor', newline, obj.history, 'End With'];
            if(strcmp(obj.domain, 'Time'))
                obj.project.AddToHistory(['define time monitor: ', obj.name], obj.history);
            else
                obj.project.AddToHistory(['define monitor: ', obj.name], obj.history);
            end
            obj.history = [];
        end
        function FieldType(obj, fType)
            % Sets what field is to be monitored.
            % fType can have one of the following values:
            % 'Efield'                    The electric field will be monitored.
            % 'Hfield'                    The magnetic field and the surface current will be monitored.
            % 'Powerflow'                 The Pointing vector will be monitored.
            % 'Current'                   The current density will be monitored.
            % 'Powerloss'                 The power loss density will be monitored.
            % 'Eenergy'                   The electric energy density will be monitored.
            % 'Henergy'                   The magnetic energy density will be monitored.
            % 'Farfield'                  A monitor for the farfield will be created.
            % 'Fieldsource'               A monitor for the field source will be created.
            % 'Spacecharge'               The space charge density, e.g. due to charged particles, will be monitored.
            % 'Particlecurrentdensity'    The particle current density will be monitored.
            obj.AddToHistory(['.FieldType "', num2str(fType, '%.15g'), '"']);
            obj.fieldtype = fType;
        end
        function Dimension(obj, monitorType)
            % This option decides to monitor the fields only on a cutting plane or for the entire calculation volume.
            % monitorType: 'plane'
            %              'volume'
            obj.AddToHistory(['.Dimension "', num2str(monitorType, '%.15g'), '"']);
        end
        function PlaneNormal(obj, plane)
            % Defines the normal direction of the monitor plane. This method only applies if the fields are to be monitored on a two dimensional plane. Otherwise this setting has no effect.
            % plane: 'x'
            %        'y'
            %        'z'
            obj.AddToHistory(['.PlaneNormal "', num2str(plane, '%.15g'), '"']);
        end
        function PlanePosition(obj, pos)
            % Defines the position of the two dimensional monitor. This method only applies if the fields are to be monitored on a two dimensional plane. Otherwise this setting has no effect.
            obj.AddToHistory(['.PlanePosition "', num2str(pos, '%.15g'), '"']);
        end
        function Domain(obj, monitorDomain)
            % Defines whether the monitor stores time-domain or frequency-domain information. In case of a farfield monitor type, the setting "time" refers to a broadband farfield monitor offering both frequency and transient farfield information.
            % monitorDomain: 'frequency'
            %                'time'
            obj.AddToHistory(['.Domain "', num2str(monitorDomain, '%.15g'), '"']);
            obj.domain = monitorDomain;
        end
        function Frequency(obj, freq)
            % Sets the frequency for frequency domain monitor to freq.
            obj.AddToHistory(['.Frequency "', num2str(freq, '%.15g'), '"']);
            obj.frequency = freq;
        end
        function Tstart(obj, startTime)
            % Sets starting time for a time domain monitor to startTime.
            % In case of transient solver the command is also available for frequency domain monitors. The frequency monitor recording will be started at startTime.
            obj.AddToHistory(['.Tstart "', num2str(startTime, '%.15g'), '"']);
            obj.tstart = startTime;
        end
        function Tstep(obj, timeStep)
            % Sets the time increment for a time domain monitor to timeStep.
            obj.AddToHistory(['.Tstep "', num2str(timeStep, '%.15g'), '"']);
            obj.tstep = timeStep;
        end
        function Tend(obj, stopTime)
            % Sets the end time for a time domain monitor to stopTime.
            obj.AddToHistory(['.Tend "', num2str(stopTime, '%.15g'), '"']);
            obj.tend = stopTime;
        end
        function UseTend(obj, bFlag)
            % If bFlag is True the time domain monitor stops storing the results when the end time set with Tend is reached. Otherwise the monitor will continue until the simulation stops.
            obj.AddToHistory(['.UseTend "', num2str(bFlag, '%.15g'), '"']);
        end
        function TimeAverage(obj, bFlag)
            % Setting bFlag to True allows the calculation of averaged values over time for a powerloss time domain monitor (Domain "time" and FieldType "Powerloss"). By default the monitor is integrated over time and averaged by its number of sample steps. The duration and sample step of the integration is defined by setting the values Tstart, Tstep, Tend and UseTend. However, with the command RepetitionPeriod it is possible to define a specific time interval to normalize the monitor result.
            % Please note that this averaged powerloss time monitor can be further used for an averaged SAR calculation as well as an imported source field for the thermal solver of CST MPHYSICS STUDIO.
            obj.AddToHistory(['.TimeAverage "', num2str(bFlag, '%.15g'), '"']);
        end
        function RepetitionPeriod(obj, timeperiod)
            % The value timeperiod defines the time interval which is used for normalization of the averaged powerloss monitor (activated by the flag TimeAverage). In case this value is set to zero, the time interval of the monitor (defined by  Tstart, Tstep, Tend and UseTend) is used instead.
            obj.AddToHistory(['.RepetitionPeriod "', num2str(timeperiod, '%.15g'), '"']);
        end
        function AutomaticOrder(obj, bFlag)
            % Setting for broadband farfield monitors: The solver automatically determines the necessary degree of polynomials used to represent the farfield in terms of spherical waves. If bFlag is set "False" this automatic determination is disabled and a reduced maximum order can be set by applying the method MaxOrder below.
            obj.AddToHistory(['.AutomaticOrder "', num2str(bFlag, '%.15g'), '"']);
        end
        function MaxOrder(obj, nOrder)
            % Setting for broadband farfield monitors: If the automatic order detection is disabled by calling the method AutomaticOrder with "False" the solver will reduce the calculated maximum order to nOrder to save memory and computation time.
            obj.AddToHistory(['.MaxOrder "', num2str(nOrder, '%.15g'), '"']);
        end
        function FrequencySamples(obj, nSamples)
            % Setting for broadband farfield monitors: Choose a number of equidistant frequency samples between Fmin and Fmax where frequency domain farfields are calculated. Results for any frequencies in between are interpolated to obtain broadband farfield information. For a more accurate interpolation over the frequency band increase this value e.g. to "31". An odd number assures that the result at mid frequency is not interpolated.
            obj.AddToHistory(['.FrequencySamples "', num2str(nSamples, '%.15g'), '"']);
        end
        function TransientFarfield(obj, bFlag)
            % Setting for broadband farfield monitors: This method activates the additional calculation of transient farfield information which can be displayed afterwards in the post-processing. Note that in order to accurately obtain time domain farfields the computational effort is higher than for broadband farfields only.
            obj.AddToHistory(['.TransientFarfield "', num2str(bFlag, '%.15g'), '"']);
        end
        function Accuracy(obj, accuracy)
            % Setting for broadband farfield monitors: Defines the desired accuracy of the farfield. Together with the Fmax and the size of the structure it determines the number of modes required to represent the farfield. Note that leaving out higher order terms by choosing a lower accuracy is equivalent to low pass filtering the farfield solution. This saves memory and computation time. However, the farfield result has usually less detail.
            % accuracy: '1e-3'
            %           '1e-4'
            %           '1e-5'
            obj.AddToHistory(['.Accuracy "', num2str(accuracy, '%.15g'), '"']);
        end
        function Origin(obj, originType)
            % The broadband farfield monitor is based on an expansion of the farfield in terms of spherical waves. By default the origin of the spherical wave expansion is the center of the bounding box.
            % originType can have one of the following values:
            % 'bbox'  The center of the bounding box of the structure.
            % 'zero'  Origin of coordinate system.
            % 'free'  Any desired point defined by UserOrigin
            obj.AddToHistory(['.Origin "', num2str(originType, '%.15g'), '"']);
        end
        function UserOrigin(obj, x, y, z)
            % Setting for broadband farfield monitors: Sets origin of the spherical wave expansion if the origin type is set to free.
            % Please note: x, y, and z must be double values here. Any expression is not allowed.
            obj.AddToHistory(['.UserOrigin "', num2str(x, '%.15g'), '", '...
                                          '"', num2str(y, '%.15g'), '", '...
                                          '"', num2str(z, '%.15g'), '"']);
        end
        function FrequencyRange(obj, fmin, fmax)
            % Sets the frequency range for field source monitors.
            obj.AddToHistory(['.FrequencyRange "', num2str(fmin, '%.15g'), '", '...
                                              '"', num2str(fmax, '%.15g'), '"']);
        end
        function UseSubvolume(obj, bFlag)
            % If bFlag is true, then the field monitor uses the subvolume which has to be defined in SetSubvolume. Otherwise the bounding box is used.
            % Please note that this method is only available for field source monitors, single frequency farfield/RCS monitors and electric or magnetic field monitors. Furthermore, this subvolume specification is currently not supported by frequency domain solvers.
            obj.AddToHistory(['.UseSubvolume "', num2str(bFlag, '%.15g'), '"']);
        end
        function SetSubvolume(obj, xmin, xmax, ymin, ymax, zmin, zmax)
            % Sets the subvolume of the field monitor. Please note that this method is only available for field source monitors, single frequency farfield/RCS monitors and electric or magnetic field monitors.
            obj.AddToHistory(['.SetSubvolume "', num2str(xmin, '%.15g'), '", '...
                                            '"', num2str(xmax, '%.15g'), '", '...
                                            '"', num2str(ymin, '%.15g'), '", '...
                                            '"', num2str(ymax, '%.15g'), '", '...
                                            '"', num2str(zmin, '%.15g'), '", '...
                                            '"', num2str(zmax, '%.15g'), '"']);
        end
        function InvertOrientation(obj, bFlag)
            % Inverts orientation for field source monitors.
            obj.AddToHistory(['.InvertOrientation "', num2str(bFlag, '%.15g'), '"']);
        end
        function ExportFarfieldSource(obj, bFlag)
            % Activates the automatic generation of a farfield source from the corresponding farfield monitor after a solver run. All farfield source exports from the same excitation are collected into a single broadband farfield source file.
            obj.AddToHistory(['.ExportFarfieldSource "', num2str(bFlag, '%.15g'), '"']);
        end
        %% Queries
        function long = GetNumberOfMonitors(obj)
            % Returns the total number of defined monitors in the current project.
            long = obj.hMonitor.invoke('GetNumberOfMonitors');
        end
        function name = GetMonitorNameFromIndex(obj, index)
            % Returns the name of the monitor with regard to the index in the internal monitor list .
            name = obj.hMonitor.invoke('GetMonitorNameFromIndex', index);
        end
        function monType = GetMonitorTypeFromIndex(obj, index)
            % Returns the type of the monitor with regard to the index in the internal monitor list.
            % monType can have one of the following values; depending on 2D or 3D monitors a suffix is added to the string in format of  " 2D" or " 3D", respectively:
            % 'E-Field 3D', 'E-Field 2D'      The electric field has been monitored.
            % 'H-Field 3D', 'H-Field 2D'      The magnetic field and the surface current has been monitored.
            % 'Powerflow 3D'                  The Pointing vector has been monitored.
            % 'Current 3D'                    The current density has been monitored.
            % 'Loss density 3D'               The power loss density has been monitored.
            % 'E-Energy 3D'                   The electric energy density has been monitored.
            % 'H-Energy 3D'                   The magnetic energy density has been monitored.
            % 'SAR 3D'                        A monitor for the SAR calculation has been created.
            % 'Farfield'                      A farfield monitor has been created.
            % 'Fieldsource'                   A field source monitor has been created.
            % 'Adaption 3D'                   A monitor for the grid adaption has been created.
            % 'Spcace charge density 3D'      A monitor for the space charge density has been created.
            % 'Particle current density 3D'   A monitor for the particle current density has been created.
            monType = obj.hMonitor.invoke('GetMonitorTypeFromIndex', index);
        end
        function domain = GetMonitorDomainFromIndex(obj, index)
            % Returns the monitor domain with regard to the index in the internal monitor list.
            % domain: 'frequency'
            %         'time'
            %         'static'
            domain = obj.hMonitor.invoke('GetMonitorDomainFromIndex', index);
        end
        function double = GetMonitorFrequencyFromIndex(obj, index)
            % Returns the frequency value of a frequency domain monitor with regard to the index in the internal monitor list.
            double = obj.hMonitor.invoke('GetMonitorFrequencyFromIndex', index);
        end
        function double = GetMonitorTstartFromIndex(obj, index)
            % Returns the start time of a time domain monitor with regard to the index in the internal monitor list.
            double = obj.hMonitor.invoke('GetMonitorTstartFromIndex', index);
        end
        function double = GetMonitorTstepFromIndex(obj, index)
            % Returns the time increment value of a time domain monitor with regard to the index in the internal monitor list.
            double = obj.hMonitor.invoke('GetMonitorTstepFromIndex', index);
        end
        function double = GetMonitorTendFromIndex(obj, index)
            % Returns the end time of a time domain monitor with regard to the index in the internal monitor list.
            double = obj.hMonitor.invoke('GetMonitorTendFromIndex', index);
        end
        function Export(obj, exportType, excitationName, filePath, bFlag)
            % Exports or converts field source monitor files in other formats. More details and examples can be found here.
            % exportType,: 'nfs'
            obj.AddToHistory(['.Export "', num2str(exportType, '%.15g'), '", '...
                                      '"', num2str(excitationName, '%.15g'), '", '...
                                      '"', num2str(filePath, '%.15g'), '", '...
                                      '"', num2str(bFlag, '%.15g'), '"']);
        end
        function SetSubVolumeSampling(obj, x, y, z)
            % Sets the subvolume sampling of the field monitor. Please note that this method only affects subvolume monitors for I-, A- and M-Solver. Can be used during definition of a monitor. This command is only written to the history if any sampling setting has been applied.
            obj.AddToHistory(['.SetSubVolumeSampling "', num2str(x, '%.15g'), '", '...
                                                    '"', num2str(y, '%.15g'), '", '...
                                                    '"', num2str(z, '%.15g'), '"']);
        end
        function V = GetSubVolumeSampling(obj, monitorName)
            % Returns a three dimensional vector of subvolume setting (x, y, z) set by the command SetSubVolumeSampling(...). See also Example.
            V = obj.hMonitor.invoke('GetSubVolumeSampling', monitorName);
        end
        function ChangeSubVolumeSampling(obj, monitorName, x, y, z)
            % Sets the subvolume sampling of the field monitor specified by the name. Please note that this method is only available for subvolume monitors for I-, A- and M-Solver. Can be used after definition of a monitor. No history item will be created.
            obj.AddToHistory(['.ChangeSubVolumeSampling "', num2str(monitorName, '%.15g'), '", '...
                                                       '"', num2str(x, '%.15g'), '", '...
                                                       '"', num2str(y, '%.15g'), '", '...
                                                       '"', num2str(z, '%.15g'), '"']);
        end
        function ChangeSubVolumeSamplingToHistory(obj, monitorName, x, y, z)
            % Enters the command ChangeSubVolumeSampling(  name monitorName, double x,  double y, double z) to the history. Can be used after definition of a monitor.
            obj.AddToHistory(['.ChangeSubVolumeSamplingToHistory "', num2str(monitorName, '%.15g'), '", '...
                                                                '"', num2str(x, '%.15g'), '", '...
                                                                '"', num2str(y, '%.15g'), '", '...
                                                                '"', num2str(z, '%.15g'), '"']);
        end
        %% Undocumented functions
        % Found in history list.
        function CreateUsingLinearStep(obj, fmin, fmax, step)
            obj.AddToHistory(['.CreateUsingLinearStep "', num2str(fmin, '%.15g'), '", '...
                                                     '"', num2str(fmax, '%.15g'), '", '...
                                                     '"', num2str(step, '%.15g'), '"']);

            % Prepend With and append End With
            obj.history = ['With Monitor', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define monitors (using linear step)'], obj.history);
            obj.history = [];
        end
        % Found in history list.
        function CreateUsingLinearSamples(obj, fmin, fmax, nsamples)
            obj.AddToHistory(['.CreateUsingLinearSamples "', num2str(fmin, '%.15g'), '", '...
                                                        '"', num2str(fmax, '%.15g'), '", '...
                                                        '"', num2str(nsamples, '%.15g'), '"']);

            % Prepend With and append End With
            obj.history = ['With Monitor', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define monitors (using linear samples)'], obj.history);
            obj.history = [];
        end
        % Found in history list.
        function CreateUsingLogSamples(obj, fmin, fmax, nsamples)
            obj.AddToHistory(['.CreateUsingLogSamples "', num2str(fmin, '%.15g'), '", '...
                                                     '"', num2str(fmax, '%.15g'), '", '...
                                                     '"', num2str(nsamples, '%.15g'), '"']);

            % Prepend With and append End With
            obj.history = ['With Monitor', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define monitors (using logarithmic samples)'], obj.history);
            obj.history = [];
        end
        % Found in history list.
        function Coordinates(obj, coordinates)
            % coordinates: structure, calculation, ???
            obj.AddToHistory(['.Coordinates "', num2str(coordinates, '%.15g'), '"']);
        end
        % Found in history list.
        function MonitorValue(obj, monitorvalue)
            % Is used to set frequency when creating a single-frequency monitor.
            obj.AddToHistory(['.MonitorValue "', num2str(monitorvalue, '%.15g'), '"']);
        end
        % Found in history list.
        function SetSubvolumeOffset(obj, x0, y0, z0, x1, y1, z1)
            obj.AddToHistory(['.SetSubvolumeOffset "', num2str(x0, '%.15g'), '", '...
                                                  '"', num2str(y0, '%.15g'), '", '...
                                                  '"', num2str(z0, '%.15g'), '", '...
                                                  '"', num2str(x1, '%.15g'), '", '...
                                                  '"', num2str(y1, '%.15g'), '", '...
                                                  '"', num2str(z1, '%.15g'), '"']);
        end
        % Found in history list.
        function SetSubvolumeOffsetType(obj, type)
            % type: 'FractionOfWavelength'
            obj.AddToHistory(['.SetSubvolumeOffsetType "', num2str(type, '%.15g'), '"']);
        end
        % Found in history list in 'define farfield monitor: farfield (broadband)'
        function Samples(obj, samples)
            % Appears to give the number of samples of the broadband monitor.
            obj.AddToHistory(['.Samples "', num2str(samples, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hMonitor
        history

        name
        fieldtype
        domain
        frequency
        tstart
        tstep
        tend
    end
end

%% Default Settings
% FieldType('Efield');
% Dimension('Volume');
% PlaneNormal('x');
% PlanePosition(0.0)
% Domain('frequency');
% Tstart(0.0)
% Tstep(0.0)
% Tend(0.0)
% RepetitionPeriod(0.0)
% UseTend(0)
% TimeAverage(0)
% MaxOrder(1)
% FrequencySamples(21)
% AutomaticOrder(1)
% TransientFarfield(0)
% UseSubvolume(0)
% ExportFarfieldSource(0)
% SetSubVolumeSampling(');', '', '');

%% Example - Taken from CST documentation and translated to MATLAB.
% % creates a frequency domain electric field monitor for the entire calculation domain
% monitor = project.Monitor();
%     monitor.Reset
%     monitor.Name('e-field(f=2.5)');
%     monitor.Dimension('Volume');
%     monitor.Domain('Frequency');
%     monitor.FieldType('Efield');
%     monitor.Frequency(2.5)
%     monitor.Create
%
% % creates a time domain magnetic field monitor for the plane y=37.3
%     monitor.Reset
%     monitor.Name('My magnetic field monitor');
%     monitor.Dimension('Plane');
%     monitor.Domain('Time');
%     monitor.FieldType('Hfield');
%     monitor.Tstart(1.0)
%     monitor.Tstep(0.015)
%     monitor.Tend(1.7)
%     monitor.UseTend(1)
%     monitor.PlaneNormal('y');
%     monitor.PlanePosition('37.3');
%     monitor.Create
%
% % creates a 2D subvolume frequency domain electric field monitor(with sub sampling for I-, A- and M-Solver)
%     monitor.Reset
%     monitor.Name('e-field(f=0.80;z=30)');
%     monitor.Dimension('Volume');
%     monitor.Domain('Frequency');
%     monitor.FieldType('Efield');
%     monitor.Frequency('0.8');
%     monitor.UseSubvolume('1');
%     monitor.Coordinates('Calculation');
%     monitor.SetSubvolume('-140', '140', '-100', '100', '-90', '90');
%     monitor.SetSubvolumeOffset('0.0', '0.0', '0.0', '0.0', '0.0', '0.0');
%     monitor.PlaneNormal('x');
%     monitor.PlanePosition('0');
%     monitor.SetSubVolumeSampling('10', '6', '6');
%     monitor.Create
%
% %Example for getting the sub volume sampling rate
% Dim V As Variant
% V = Monitor.GetSubVolumeSampling('e-field(f=0.80;z=30)');
%
% Debug.Print V(0)
% Debug.Print V(1)
% Debug.Print V(2)
%
%
