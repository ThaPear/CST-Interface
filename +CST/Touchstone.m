%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Touchstone < handle
    properties(SetAccess = protected)
        project
        hTouchstone
        
        filename
        userprefix
        impedance
        frequencyrange
        fmin, fmax
        renormalize
        nsamples
    end
    
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Touchstone object.
        function obj = Touchstone(project, hProject)
            obj.project = project;
            obj.hTouchstone = hProject.invoke('TOUCHSTONE');
            
            obj.Reset();
        end
    end
    
    methods
        function Reset(obj)
            obj.hTouchstone.invoke('Reset');
            
            obj.filename = '';
            obj.userprefix = '';
            obj.impedance = 50;
            obj.frequencyrange = 'Full';
            obj.fmin = 0;
            obj.fmax = 0;
            obj.renormalize = 0;
            obj.nsamples = 0;
        end
        function FileName(obj, filename)
            obj.filename = filename;
            obj.hTouchstone.invoke('FileName', filename);
        end
        function filename = GetFileName(obj)
            filename = obj.hTouchstone.invoke('GetFileName');
        end
        function UserPrefix(obj, userprefix)
            obj.userprefix = userprefix;
            obj.hTouchstone.invoke('UserPrefix', userprefix);
        end
        function Impedance(obj, impedance)
            obj.impedance = impedance;
            obj.hTouchstone.invoke('Impedance', impedance);
        end
        function FrequencyRange(obj, frequencyrange)
            % 'Full' or 'Limited'.
            % Limited requires Fmin and Fmax to be set.
            obj.frequencyrange = frequencyrange;
            obj.hTouchstone.invoke('FrequencyRange', frequencyrange);
        end
        function Fmin(obj, fmin)
            obj.fmin = fmin;
            
            obj.hTouchstone.invoke('Fmin', fmin);
        end
        function Fmax(obj, fmax)
            obj.fmax = fmax;
            
            obj.hTouchstone.invoke('Fmax', fmax);
        end
        function Renormalize(obj, boolean)
            obj.renormalize = boolean;
            
            obj.hTouchstone.invoke('Renormalize', boolean);
        end
        function SetNSamples(obj, nsamples)
            obj.nsamples = nsamples;
            obj.hTouchstone.invoke('SetNSamples', nsamples);
        end
        
        function Write(obj)
            obj.hTouchstone.invoke('Write');
        end
    end
end

% Default settings.
% FileName ("")
% Impedance (50)
% FrequencyRange ("Full")
% Renormalize (True)
% UseARResults (False)
% SetNSamples (0)
