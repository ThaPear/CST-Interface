%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%% Warning: Untested                                                   %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Defines the settings for the Ar-filter. Ar-filters may be applied to time signals at the ports, probe signals or current and voltage monitor signals. You may define different settings for port, probe and monitor signals. An Ar-filter run can be started by using the PostProcess1D object.
classdef Arfilter < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Arfilter object.
        function obj = Arfilter(project, hProject)
            obj.project = project;
            obj.hArfilter = hProject.invoke('Arfilter');
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
            % Prepend With Arfilter and append End With
            obj.history = [ 'With Arfilter', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define Arfilter settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['Arfilter', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function SetType(obj, type)
            % Sets the type of signals the AR-filter settings are applied to.
            % type: 's-parameter'
            %       'probe'
            %       'monitor'
            obj.AddToHistory(['.SetType "', num2str(type, '%.15g'), '"']);
            obj.settype = type;
        end
        function SetFirstTime(obj, time)
            % The first time step (in seconds) from which filter determination starts.
            obj.AddToHistory(['.SetFirstTime "', num2str(time, '%.15g'), '"']);
            obj.setfirsttime = time;
        end
        function SetSkip(obj, skip)
            % The number of time steps which will be skipped after an AR-filter has been found and before the next filter will be determined.
            obj.AddToHistory(['.SetSkip "', num2str(skip, '%.15g'), '"']);
            obj.setskip = skip;
        end
        function SetMaxFrq(obj, fMax)
            % Because the time signals will be low pass filtered within the AR calculation process, the maximum frequency of the low pass filter need to be specified here (usually : 1,2 * fmax (from the Frequency dialog box)).
            obj.AddToHistory(['.SetMaxFrq "', num2str(fMax, '%.15g'), '"']);
            obj.setmaxfrq = fMax;
        end
        function SetMaxOrder(obj, order)
            % Sets the number of recursive filter elements. Higher order filters usually deliver more accurate results, but the calculation time increases parabolically with the number of filter elements (max. 100 elements).
            obj.AddToHistory(['.SetMaxOrder "', num2str(order, '%.15g'), '"']);
            obj.setmaxorder = order;
        end
        function SetWindowLength(obj, length)
            % This method sets the length of the analyzed time interval relative to the maximum number of elements. E.g. with maximum order of filter 40 and a window length of 2.0 the number of analyzed time samples is 40 * 2.0 = 80.
            obj.AddToHistory(['.SetWindowLength "', num2str(length, '%.15g'), '"']);
            obj.setwindowlength = length;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hArfilter
        history
        bulkmode

        settype
        setfirsttime
        setskip
        setmaxfrq
        setmaxorder
        setwindowlength
    end
end

%% Default Settings
% SetSkip(10)
% SetMaxOrder(40)
% SetWindowLength(2.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% arfilter = project.Arfilter();
%     arfilter.SetType('s-parameter');
%     arfilter.SetFirstTime(0.1777274577508)
%     arfilter.SetSkip(10)
%     arfilter.SetMaxFrq('fMax * 1.2');
%     arfilter.SetMaxOrder(40)
%     arfilter.SetWindowLength(2.0)  
% 
% 
