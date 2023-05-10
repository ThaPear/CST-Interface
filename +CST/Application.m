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
        function hCST = GetHandle(reset)
            persistent hCST_Persistent;
            if(nargin > 0 && reset)
                clear hCST_Persistent;
                return;
            end
            if(~isempty(hCST_Persistent))
                hCST = hCST_Persistent;
                try
                    hCST.invoke('a');
                    fprintf('ERROR: Should not reach this point, assuming CST is unavailable.\n');
                catch err
                    if(contains(err.message, 'Unknown name or named argument'))
                        % The handle is valid, so return it.
                        return;
                    elseif(contains(err.message, 'The RPC server is unavailable'))
                        fprintf('CST was closed. Re-acquiring CST handle...\n');
                        hCST_Persistent = [];
                        % Continue into version selection.
                    else
                        fprintf('Unknown error occurred. CST handle invalid, re-acquiring...\n');
                    end
                end
            end

            % Get the installed CST versions.
            fprintf('Getting available CST versions...\n');
            % Query the system.
            versions = evalc('system(''powershell -command "dir REGISTRY::HKEY_CLASSES_ROOT\CLSID -include PROGID -recurse | foreach {$_.GetValue(\"\")} | Select-String \"CST DESIGN\""'');');
            % Split resulting output.
            versions = strsplit(versions, newline);
            % Remove lines that are not versions.
            versions(cellfun(@length, versions) < 2) = [];
            % Now we have something like the following:
            % {'CST DESIGN ENVIRONMENT_AMD64.Application.2022', 'CST DESIGN ENVIRONMENT_AMD64.Application.2018'}
            if(length(versions) < 1)
                % No versions were found.
                fprintf('No versions found.\nFalling back to default.\n');
                % Fall back to the general way of getting the handle.
                hCST_Persistent = actxserver('CSTStudio.Application');
                hCST = hCST_Persistent;
                return;
            elseif(length(versions) == 1)
                % Only 1 version was found.
                fprintf('Single installed version found, using that one.');
                % Simply use the general way of getting the handle.
                hCST_Persistent = actxserver('CSTStudio.Application');
                hCST = hCST_Persistent;
                return;
            end
            % Only retain the year.
            versions = strrep(versions, 'CST DESIGN ENVIRONMENT_AMD64.Application.', '');
            versions = strrep(versions, ' ', '');
            versions(cellfun(@length, versions) > 4) = [];
            versions = sort(versions);

            versionstr = strcat(versions(1:end-1), {', '});
            versionstr = [versionstr{:}, versions{end}];

            % Request a choice from the user.
            query = ['Please select your preferred version.', newline, ...
                     ['Available versions: ', versionstr, '.'], newline, ...
                     'Add an asterisk (*) to remember your choice.', newline, ...
                     'Call CST.Application.Reset() to change your choice later.'];
            answer = inputdlg(query);

            % Should we remember the choice?
            remember = false;
            if(contains(answer, '*'))
                remember = true;
                answer = strrep(answer, '*', '');
            end

            % Check if the answer matches any of the versions.
            if(length([answer{:}]) < 4 || length([answer{:}]) > 5 || ~any(strcmp(answer, versions)))
                error('Invalid version ''%s''.\nPlease select one of the following versions: ''%s''.', [answer{:}], strrep(versionstr, ', ', ''', '''));
            end
            
            % Construct the string to retrieve the actxserver
            actxstr = ['CST DESIGN ENVIRONMENT_AMD64.Application.', answer{:}];

            % Try to get the desired server.
            try
                if(remember)
                    hCST_Persistent = actxserver(actxstr);
                    hCST = hCST_Persistent;
                else
                    hCST = actxserver(actxstr);
                end
            catch err
                % Couldn't get the given server.
                % Fall back to the general way of getting the handle.
                fprintf('Failed to retrieve given actxserver. Error message: %s.\nFalling back to default.\n', err.message);
                hCST_Persistent = actxserver('CSTStudio.Application');
                hCST = hCST_Persistent;
                return;
            end
        end
        function Reset()
            CST.Application.GetHandle(true);
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
            project = CST.CS.Project(hProject);
        end
        function dsproject = NewDS()
            % Creates a new CST DESIGN STUDIO project.
            hCST = CST.Application.GetHandle();
            hDSProject = hCST.invoke('NewDS');
            dsproject = CST.DS.Project(hDSProject);
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
            warning([newline, ...
                'CST.Application.FileNew is undocumented.', newline, ...
                'Returning raw activeX handle.', newline, ...
                'Recommend using CST.Application.NewMWS.']);
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('FileNew');
        end
        % Found in 'methodsview(CST.Application.GetHandle())'
        function hProject = NewSystemsimulator()
            warning([newline, ...
                'CST.Application.NewSystemsimulator is undocumented.', newline, ...
                'Returning raw activeX handle.']);
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('NewSystemsimulator');
        end
        % Found in 'methodsview(CST.Application.GetHandle())'
        function hProject = NewDesign()
            warning([newline, ...
                'CST.Application.NewDesign is undocumented.', newline, ...
                'Returning raw activeX handle.', newline, ...
                'Recommend using CST.Application.NewDS.']);
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('NewDesign');
        end
        % Found in 'methodsview(CST.Application.GetHandle())'
        function project = NewProject(id)
            % Creates a new project based on the given id.
            % id: 0 = DS
            %     1 = MWS
            %     2 = EM
            %     3 = PS
            %     4 = MPS
            %     5 = CS
            %     6 = DS, Assembly
            % Other values = error: 'Provided id (id) is not supported.'
            hCST = CST.Application.GetHandle();
            hProject = hCST.invoke('NewProject', id);
            switch(id)
                case {0,6}
                    project = CST.DS.Project(hProject);
                case {1,2,3,4,5}
                    project = CST.Project(hProject);
                otherwise
                    error('Provided id (%i) is not supported.', id);
            end
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