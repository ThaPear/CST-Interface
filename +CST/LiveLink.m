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

% This object is used to manage the synchronization of parameters with an external application like used for the parametric imports. Currently the object can not be used to create a parametric import.
classdef LiveLink < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.LiveLink object.
        function obj = LiveLink(project, hProject)
            obj.project = project;
            obj.hLiveLink = hProject.invoke('LiveLink');
        end
    end
    %% CST Object functions.
    methods
        function Synchronize(obj, name)
            % Make sure all parameters of a following CAD import are synchronized with the according external application. The name is the filename without extension and the used import ID separated by an underscore.  Returns false if the given name do not exists.
            obj.hLiveLink.invoke('Synchronize', name);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hLiveLink

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% % Synchronize the parameters of the import
% livelink = project.LiveLink();
%     livelink.Synchronize('Link1_1');
% 
% % Import the model file into cst(normal import)
%     livelink.Reset
%     livelink.Healing('1');
%     livelink.ScaleToUnit('0');
%     livelink.FileName('C:\Users\alexandermarinc\Desktop\SolidworksLink\Link1.SLDPRT');
%     livelink.Id('1');
%     livelink.ImportAttributes('1');
%     livelink.ImportHiddenEntities('0');
%     livelink.Read
