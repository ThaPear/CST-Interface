%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Suppress warnings:
% "Use of backets [] is unnecessary. Use parentheses to group, if needed."
%#ok<*NBRAK>
classdef Monitor < handle
    properties(SetAccess = protected)
        project
        hMonitor
        history
        
        name
        fieldtype
        dimension
        planenormal
        planeposition
        domain
        frequency
        tstart, tstep, tend
        usetend
        usesubvolume
        subvolumexmin, subvolumexmax
        subvolumeymin, subvolumeymax
        subvolumezmin, subvolumezmax
        
        coordinates
        monitorvalue
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Monitor object.
        function obj = Monitor(project, hProject)
            obj.project = project;
            obj.hMonitor = hProject.invoke('Monitor');
        end
    end
    
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
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
        function CreateUsingLinearStep(obj, fmin, fmax, step)
            obj.AddToHistory(['.CreateUsingLinearStep "', num2str(fmin), '", '...
                                                     '"', num2str(fmax), '", '...
                                                     '"', num2str(step), '"']);
            
            % Prepend With and append End With
            obj.history = ['With Monitor', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define monitors (using linear step)'], obj.history);
            obj.history = [];
        end
        function CreateUsingLinearSamples(obj, fmin, fmax, nsamples)
            obj.AddToHistory(['.CreateUsingLinearSamples "', num2str(fmin), '", '...
                                                        '"', num2str(fmax), '", '...
                                                        '"', num2str(nsamples), '"']);
            
            % Prepend With and append End With
            obj.history = ['With Monitor', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define monitors (using linear samples)'], obj.history);
            obj.history = [];
        end
        function CreateUsingLogSamples(obj, fmin, fmax, nsamples)
            obj.AddToHistory(['.CreateUsingLogSamples "', num2str(fmin), '", '...
                                                     '"', num2str(fmax), '", '...
                                                     '"', num2str(nsamples), '"']);
            
            % Prepend With and append End With
            obj.history = ['With Monitor', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['define monitors (using logarithmic samples)'], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = '';
            obj.fieldtype = '';
            obj.dimension = 'volume';
            obj.planenormal = 'x';
            obj.planeposition = 0;
            
            obj.domain = 'Frequency';
            obj.tstart = 0.0;
            obj.tstep = 0.0;
            obj.tend = 0.0;
%             obj.repetitionperiod = 0;
            obj.usetend = 0;
%             obj.timeaverage = 0;
%             obj.maxorder = 0;
%             obj.frequencysamples = 21;
%             obj.automaticorder = 0;
%             obj.transientfarfield = 0;
            obj.usesubvolume = 0;
%             obj.exportfarfieldsource = 0;
%             obj.volumesamplingx = [];
%             obj.volumesamplingy = [];
%             obj.volumesamplingz = [];
        end
        function Name(obj, name)
            % Autogenerated if not specified.
            obj.name = name;
            obj.AddToHistory(['.Name "', name, '"']);
        end
        function Rename(obj, oldname, newname)
            obj.project.AddToHistory(['rename monitor: ', oldname, ' to: ', newname],...
                                     ['Monitor.Rename "', oldname, '", "', newname, '"']);
        end
        function Delete(obj, name)
            obj.project.AddToHistory(['delete monitor: ', name],...
                                     ['Monitor.Delete "', name, '"']);
        end
        function FieldType(obj, fieldtype)
            % fieldtype: Efield, Hfield, Powerflow, Current, Powerloss, 
            %            Eenergy, Henergy, Farfield, Fieldsource
            obj.fieldtype = fieldtype;
            
            obj.AddToHistory(['.FieldType "', fieldtype, '"']);
        end
        function Dimension(obj, dimension)
            % dimension: plane, volume
            obj.dimension = dimension;
            
            obj.AddToHistory(['.Dimension "', dimension, '"']);
        end
        function PlaneNormal(obj, planenormal)
            % planenormal: x, y, z
            obj.planenormal = planenormal;
            
            obj.AddToHistory(['.PlaneNormal "', planenormal, '"']);
        end
        function PlanePosition(obj, planeposition)
            % planeposition: The position along the normal.
            obj.planeposition = planeposition;
            
            obj.AddToHistory(['.PlanePosition "', num2str(planeposition), '"']);
        end
        function Domain(obj, domain)
            % domain: Frequency, Time
            obj.domain = domain;
            
            obj.AddToHistory(['.Domain "', domain, '"']);
        end
        function Frequency(obj, frequency)
            obj.frequency = frequency;
            
            obj.AddToHistory(['.Frequency "', num2str(frequency), '"']);
        end
        function Tstart(obj, tstart)
            obj.tstart = tstart;
            
            obj.AddToHistory(['.Tstart "', num2str(tstart), '"']);
        end
        function Tstep(obj, tstep)
            obj.tstep = tstep;
            
            obj.AddToHistory(['.Tstep "', num2str(tstep), '"']);
        end
        function Tend(obj, tend)
            obj.tend = tend;
            
            obj.AddToHistory(['.Tend "', num2str(tend), '"']);
        end
        function UseTend(obj, boolean)
            obj.usetend = boolean;
            
            obj.AddToHistory(['.UseTend "', num2str(boolean), '"']);
        end
        function UseSubVolume(obj, boolean)
            obj.usesubvolume = boolean;
            
            obj.AddToHistory(['.UseSubVolume "', num2str(boolean), '"']);
        end
        function SetSubvolume(obj, xmin, xmax, ymin, ymax, zmin, zmax)
            obj.subvolumexmin = xmin;
            obj.subvolumexmax = xmax;
            obj.subvolumeymin = ymin;
            obj.subvolumeymax = ymax;
            obj.subvolumezmin = zmin;
            obj.subvolumezmax = zmax;
            
            obj.AddToHistory(['.SetSubvolume "', num2str(xmin), '", '...
                                            '"', num2str(xmax), '", '...
                                            '"', num2str(ymin), '", '...
                                            '"', num2str(ymax), '", '...
                                            '"', num2str(zmin), '", '...
                                            '"', num2str(zmax), '"', ]);
        end
        
        function number = GetNumberOfMonitors(obj)
            number = obj.hMonitor.invoke('GetNumberOfMonitors');
        end
        function name = GetMonitorNameFromIndex(obj, index)
            name = obj.hMonitor.invoke('GetMonitorNameFromIndex', index);
        end
        function name = GetMonitorTypeFromIndex(obj, index)
            name = obj.hMonitor.invoke('GetMonitorTypeFromIndex', index);
        end
        function domain = GetMonitorDomainFromIndex(obj, index)
            domain = obj.hMonitor.invoke('GetMonitorDomainFromIndex', index);
        end
        function frequency = GetMonitorFrequencyFromIndex(obj, index)
            frequency = obj.hMonitor.invoke('GetMonitorFrequencyFromIndex', index);
        end
        function tstart = GetMonitorTstartFromIndex(obj, index)
            tstart = obj.hMonitor.invoke('GetMonitorTstartFromIndex', index);
        end
        function tstep = GetMonitorTstepFromIndex(obj, index)
            tstep = obj.hMonitor.invoke('GetMonitorTstepFromIndex', index);
        end
        function tend = GetMonitorTendFromIndex(obj, index)
            tend = obj.hMonitor.invoke('GetMonitorTendFromIndex', index);
        end
        
        % Not defined in the reference, but used in the history list.
        function Coordinates(obj, coordinates)
            % coordinates: structure, calculation, ???
            obj.coordinates = coordinates;
            
            obj.AddToHistory(['.Coordinates "', num2str(coordinates), '"']);
        end
        function MonitorValue(obj, monitorvalue)
            % Is used to set frequency in the history list when creating a
            % single-frequency monitor.
            obj.monitorvalue = monitorvalue;
            
            obj.AddToHistory(['.MonitorValue "', num2str(monitorvalue), '"']);
        end
    end
end

% Default settings.
% FieldType ("Efield")
% Dimension ("Volume")
% PlaneNormal ("x")
% PlanePosition (0.0)
% Domain ("frequency")
% Tstart (0.0)
% Tstep (0.0)
% Tend (0.0)
% UseTend (False)
% MaxOrder (1)
% FrequencySamples (21)
% AutomaticOrder (True)
% TransientFarfield (False)
% UseSubvolume (False)
% ExportFarfieldSource (False)