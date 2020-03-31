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
        function hCST = GetHandle()
%             persistent hCST_Persistent;
%             if(~isempty(hCST_Persistent))
%                 if(~isa(hCST_Persistent, 'COM.CSTStudio_Application'))
%                     error(['Invalid CST handle of type ', class(hCST_Persistent)]);
%                 end
%             else
                hCST_Persistent = actxserver('CSTStudio.Application');
                hCST = hCST_Persistent;
%             end
        end
    end
    %% CST Object functions.
    methods(Static)
        function project = NewMWS()
            % Creates a new CST MICROWAVE STUDIO project.
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('NewMWS');
            project = CST.Project(hProject);
        end
        function project = NewEMS()
            % Creates a new CST EM STUDIO project.
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('NewEMS');
            project = CST.Project(hProject);
        end
        function project = NewPS()
            % Creates a new CST PARTICLE STUDIO project.
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('NewPS');
            project = CST.Project(hProject);
        end
        function project = NewMPS()
            % Creates a new CST MPHYSICS STUDIO project.
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('NewMPS');
            project = CST.Project(hProject);
        end
        function project = NewCS()
            % Creates a new CST CABLE STUDIO project.
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('NewCS');
            project = CST.Project(hProject);
        end
        function project = NewPCBS()
            % Creates a new CST PCB STUDIO project.
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('NewPCBS');
            project = CST.Project(hProject);
        end
        function dsproject = NewDS()
            % Creates a new CST DESIGN STUDIO project.
            hCST = CST.Application.GetHandle();
            hDSProject = hCST.invoke('NewDS');
            dsproject = CST.Project(hDSProject);
        end
        function project = OpenFile(filepath)
            % Opens a project.
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('OpenFile', filepath);
            if(isempty(hProject))
                error(['Could not open CST file ''%s''.\n', ...
                       'This could be due to it being open already or due to an incorrect path.\n', ...
                       'To force open the file, use CST.Application.CloseProject(filepath) first.'], filepath);
            end
            project = CST.Project(hProject);
        end
        function project = Active3D()
            % Offers access to the currently active CST MICROWAVE STUDIO, CST EM STUDIO, CST PARTICLE STUDIO, CST MPHYSICS STUDIO or CST CABLE STUDIO project.
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('Active3D');
            project = CST.Project(hProject);
        end
        function dsproject = ActiveDS()
            % Offers access to the currently active CST DESIGN STUDIO project.
            hCST = CST.Application.GetHandle();
            hDSProject  = hCST.invoke('ActiveDS');
            dsproject = CST.DS.Project(hDSProject);
        end
        function Quit()
            % Exits the application.
            hCST = CST.Application.GetHandle();
            hCST.invoke('Quit');
        end
        %% Undocumented functions.
        % Found in 'methodsview(CST.Application.GetHandle())'
        function hProject = FileNew()
            warning('\nCST.Application.FileNew is undocumented.\nReturning raw activeX handle.');
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('FileNew');
        end
        % Found in 'methodsview(CST.Application.GetHandle())'
        function hProject = NewSystemsimulator()
            warning('\nCST.Application.NewSystemsimulator is undocumented.\nReturning raw activeX handle.');
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('NewSystemsimulator');
        end
        % Found in 'methodsview(CST.Application.GetHandle())'
        function hProject = NewDesign()
            warning('\nCST.Application.NewDesign is undocumented.\nReturning raw activeX handle.\nRecommend using CST.Application.NewDS.%s', '');
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('NewDesign');
        end
        % Found in 'methodsview(CST.Application.GetHandle())'
        function hProject = NewProject(id)
            % Creates a new project based on the given id.
            % id: 0,6 = DS
            %     1   = MWS
            %     2   = EM
            %     3   = PS
            %     4   = MPS
            %     5   = CS
            % Other values = error: 'No manager implemented so far. Be patient.'
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('NewProject', id);
        end
        % Found in 'methodsview(CST.Application.GetHandle())'
        function OpenDesign(filepath)
            % Switches the view in CST to the given design.
            % If the design is not open, CST will open it.
            % Can use Active3D or ActiveDS to get the appropriate handle.
            hCST = CST.Application.GetHandle();
            hCST.invoke('OpenDesign', filepath);
        end
        % Found in 'methodsview(CST.Application.GetHandle())'
        function CloseProject(filepath)
            % Closes the specified project (requires full path).
            hCST = CST.Application.GetHandle();
            hCST.invoke('CloseProject', filepath);
        end
    end
end

%% Example
% project = CST.Application.NewMWS();