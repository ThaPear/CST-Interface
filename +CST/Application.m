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

% This application object provides methods to open, create and close projects.
classdef Application < handle
    %% CST Interface specific functions.
    methods(Static)
        function cst = GetHandle()
%             persistent cst_handle;
%             if(~isempty(cst_handle))
%                 if(~isa(cst_handle, 'COM.CSTStudio_Application'))
%                     error(['Invalid CST handle of type ', class(cst_handle)]);
%                 end
%                 cst = cst_handle;
%             else
                cst_handle = actxserver('CSTStudio.Application');
                cst = cst_handle;
%             end
        end
    end
    %% CST Object functions.
    methods(Static)
        function project = NewMWS()
            % Creates a new CST MICROWAVE STUDIO project.
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('NewMWS');
            project = CST.Project(hProject);
        end
        function project = NewEMS()
            % Creates a new CST EM STUDIO project.
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('NewEMS');
            project = CST.Project(hProject);
        end
        function project = NewPS()
            % Creates a new CST PARTICLE STUDIO project.
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('NewPS');
            project = CST.Project(hProject);
        end
        function project = NewMPS()
            % Creates a new CST MPHYSICS STUDIO project.
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('NewMPS');
            project = CST.Project(hProject);
        end
        function project = NewCS()
            % Creates a new CST CABLE STUDIO project.
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('NewCS');
            project = CST.Project(hProject);
        end
        function project = NewPCBS()
            % Creates a new CST PCB STUDIO project.
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('NewPCBS');
            project = CST.Project(hProject);
        end
        function dsproject = NewDS()
            % Creates a new CST DESIGN STUDIO project.
            cst = CST.Application.GetHandle();
            hDSProject = cst.invoke('NewDS');
            dsproject = CST.Project(hDSProject);
        end
        function project = OpenFile(filename)
            % Opens a project.
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('OpenFile', filename);
            if(isempty(hProject))
                error('File not found or file is already open.');
            end
            project = CST.Project(hProject);
        end
        function project = Active3D()
            % Offers access to the currently active CST MICROWAVE STUDIO, CST EM STUDIO, CST PARTICLE STUDIO, CST MPHYSICS STUDIO or CST CABLE STUDIO project.
            cst = CST.Application.GetHandle();
            hProject = cst.invoke('Active3D');
            project = CST.Project(hProject);
        end
        function dsproject = ActiveDS()
            % Offers access to the currently active CST DESIGN STUDIO project.
            cst = CST.Application.GetHandle();
            hDSProject  = cst.invoke('ActiveDS');
            dsproject = CST.DS.Project(hDSProject);
        end
        function Quit()
            % Exits the application.
            cst = CST.Application.GetHandle();
            cst.invoke('Quit');
        end
    end
end

%% Example
% project = CST.Application.NewMWS();