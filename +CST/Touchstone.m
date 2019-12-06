%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This command offers Touchstone file compatible export for the S-parameters. The extensions of the exported files names are specified by ”.sNp” where N stands for the number of ports in your model (e.g. ”.s3p”).
classdef Touchstone < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Touchstone object.
        function obj = Touchstone(project, hProject)
            obj.project = project;
            obj.hTouchstone = hProject.invoke('Touchstone');
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets the export options to the default.
            obj.hTouchstone.invoke('Reset');
        end
        function FileName(obj, filename)
            % Sets the name of the exported file.
            obj.hTouchstone.invoke('FileName', filename);
        end
        function string = GetFileName(obj)
            % Returns the full filename of the stored touchstone file including the automatically generated extension.
            string = obj.hTouchstone.invoke('GetFileName');
        end
        function UserPrefix(obj, name)
            % Set prefix for the S-parameter input files. The expected filename will be i.e. "project^prefix^a1(1)1(1).sig". Renormalization is disabled in this case. Use this before ".Write". Prefix will be reset to "" after ".Write".
            obj.hTouchstone.invoke('UserPrefix', name);
        end
        function Impedance(obj, impedance)
            % The Touchstone file contains a fixed reference impedance. During the export process the S-parameters will be automatically normed to the impedance specified by this method.
            obj.hTouchstone.invoke('Impedance', impedance);
        end
        function FrequencyRange(obj, type)
            % Sets the Frequency range to "Full" or "Limited".
            % type can have one of  the following values:
            % "Full" - Full frequency range export
            % "Limited" - Limited frequency range export. This requires Fmin and Fmax to be set.
            obj.hTouchstone.invoke('FrequencyRange', type);
        end
        function Fmin(obj, fmin)
            % Sets the minimum for the frequency range. This is required if you want to export a limited frequency range.
            obj.hTouchstone.invoke('Fmin', fmin);
        end
        function Fmax(obj, fmax)
            % Sets the maximum for the frequency range. This is required if you want to export a limited frequency range.
            obj.hTouchstone.invoke('Fmax', fmax);
        end
        function Renormalize(obj, boolean)
            % This method offers the possibility to disable the automatic normalization to the reference impedance. The export data is automatically renormed to the specified reference impedance (switch = True), or is written as it is without renorming (switch = False).
            obj.hTouchstone.invoke('Renormalize', boolean);
        end
        function UseARResults(obj, boolean)
            % Use this method to export the S-parameter results provided by the AR-Filter analysis (switch = True).
            obj.hTouchstone.invoke('UseARResults', boolean);
        end
        function SetNSamples(obj, samples)
            % Sets the maximum number of samples stored in the touchstone file.
            obj.hTouchstone.invoke('SetNSamples', samples);
        end
        function Write(obj)
            % Performs the export.
            obj.hTouchstone.invoke('Write');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTouchstone

    end
end

%% Default Settings
% FileName('');
% Impedance(50)
% FrequencyRange('Full');
% Renormalize(1)
% UseARResults(0)
% SetNSamples(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% touchstone = project.Touchstone();
%     touchstone.Reset
%     touchstone.FileName('.\example');
%     touchstone.Impedance(50)
%     touchstone.FrequencyRange('Full');
%     touchstone.Renormalize(1)
%     touchstone.UseARResults(0)
%     touchstone.SetNSamples(100)
%     touchstone.Write
% 
