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

% Use this object to define a field source for the simulation.
classdef FieldSource < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.FieldSource object.
        function obj = FieldSource(project, hProject)
            obj.project = project;
            obj.hFieldSource = hProject.invoke('FieldSource');
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
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
        end
        function Name(obj, name)
            % Specifies the name for the current distribution.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function FileName(obj, name)
            % Specifies the name of the field source data file. Available for import are CST MICROWAVE STUDIO FSM files (*.fsm), CST MICROWAVE STUDIO hexanhedral field monitors (*.m3d), CST MPHYSICS STUDIO displacement files (*.fic), CST CABLE STUDIO / CST PCB STUDIO RSD files (*.rsd), or Sigrity® NFD files (*.nfd).
            obj.AddToHistory(['.FileName "', num2str(name, '%.15g'), '"']);
        end
        function Delete(obj, name)
            % Deletes an existing field source, which is specified by the name.
            obj.project.AddToHistory(['FieldSource.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Id(obj, uniqueID)
            % Set the unique ID of the field source which was generated using GetNextId.
            obj.AddToHistory(['.Id "', num2str(uniqueID, '%.15g'), '"']);
        end
        function integer = GetNextId(obj)
            % Returns the next free unique ID for a new field source. The filename has to be set and match the filename of the new field source. Set filename with FileName.
            integer = obj.hFieldSource.invoke('GetNextId');
        end
        function DeleteAll(obj)
            % Delete all field sources.
            obj.project.AddToHistory(['FieldSource.DeleteAll']);
        end
        function Rename(obj, oldname, newname)
            % Renames an existing field source from oldname to newname.
            obj.project.AddToHistory(['FieldSource.Rename "', num2str(oldname, '%.15g'), '", '...
                                                         '"', num2str(newname, '%.15g'), '"']);
        end
        function Read(obj)
            % Activates the import, which has to be previously specified using the FileName method. This method is used for the following file types:  *.rsd, *.fsm, and *.nfd.
            obj.AddToHistory(['.Read']);

            % Prepend With FieldSource and append End With
            obj.history = [ 'With FieldSource', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define FieldSource: ', obj.name], obj.history);
            obj.history = [];
        end
        %% Methods: Field Import
        function ProjectPath(obj, path)
            % Specifies the project the field import is taken from. This may be an absolute path (UseRelativePath is set to "False") or a path relative to the current project file (UseRelativePath is set to "True").
            obj.AddToHistory(['.ProjectPath "', num2str(path, '%.15g'), '"']);
        end
        function UseRelativePath(obj, flag)
            % Defines if the ProjectPath is given with a relative or absolute path. In the former case ProjectPath must specify a location relative to the current project file.
            obj.AddToHistory(['.UseRelativePath "', num2str(flag, '%.15g'), '"']);
        end
        function ResultSubDirectory(obj, dirname)
            % Specifies the name of the subdirectory within the Result directory where the solver results can be found. For example, IR-Drop solver writes the archive with thermal losses into Result\IRDROPRESULTS. In this case, the name of subdirectory must be specified by .ResultSubDirectory "IRDROPRESULTS".
            obj.AddToHistory(['.ResultSubDirectory "', num2str(dirname, '%.15g'), '"']);
        end
        function SourceName(obj, FieldType)
            % Defines which field should be imported from the project specified by ProjectPath. The value of FieldType must be "Temperature", "Displacement", "Force Density", "Nodal Forces" or "Thermal Losses".
            obj.AddToHistory(['.SourceName "', num2str(FieldType, '%.15g'), '"']);
        end
        function FieldMonitorName(obj, name)
            % If the project specified by ProjectPath contains a transient thermal solution, use this command to specify the monitor from which the distribution should be imported. name may have the following values:
            % ”Initial Solution”                      the initial temperature distribution is imported.
            % ”Stationary Solution”                   if the source project contains a solution made by the stationary thermal solver, this solution will be imported.
            % Name of a 3D temperature monitor        one of the temperature distributions saved by this monitor is imported. The time frame is then specified in TimeValue or by UseLastTimeFrame.
            obj.AddToHistory(['.FieldMonitorName "', num2str(name, '%.15g'), '"']);
        end
        function TimeValue(obj, time)
            % If a single temperature field is imported from a transient temperature monitor specified in FieldMonitorName, use this command to specify from which time point the temperature distribution must be imported. Parameter time must be specified in seconds. This command is ignored if UseLastTimeFrame is set to "True".
            obj.AddToHistory(['.TimeValue "', num2str(time, '%.15g'), '"']);
        end
        function UseLastTimeFrame(obj, flag)
            % If a single temperature field is imported from a transient temperature monitor specified in FieldMonitorName, use this command to select the last frame saved by the monitor.
            obj.AddToHistory(['.UseLastTimeFrame "', num2str(flag, '%.15g'), '"']);
        end
        function UseCopyOnly(obj, flag)
            % Defines if the internal copy of the field import should be used only. If this setting is activated, the imported field is not updated anymore, even if it has been changed in the source project.
            obj.AddToHistory(['.UseCopyOnly "', num2str(flag, '%.15g'), '"']);
        end
        function CreateFieldImport(obj)
            % Creates a temperature, displacement, thermal loss or static force field import from a project, which needs to be specified with the ProjectPath method.
            obj.AddToHistory(['.CreateFieldImport']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hFieldSource
        history

        name
    end
end

%% Default Settings
%

%% Example - Taken from CST documentation and translated to MATLAB.
% % Obtain a free unique ID for('test.rsd');
% Dim sID as String
%
% fieldsource = project.FieldSource();
%     fieldsource.Reset
%     fieldsource.FileName('test.rsd');
%     fsID = .GetNextId
%     fieldsource.Reset
%
% % Define a field source with an evaluated ID
%     fieldsource.Reset
%     fieldsource.Name('CD1');
%     fieldsource.FileName('test.rsd');
%     fieldsource.Id('42');
%     fieldsource.Read
%
% % Import a single(final) temperature distribution from a transient thermal project
%     fieldsource.Reset
%     fieldsource.Name('field1');
%     fieldsource.Id('59');
%     fieldsource.ProjectPath('Thermal TD.cst');
%     fieldsource.UseRelativePath('1');
%     fieldsource.SourceName('Temperature');
%     fieldsource.FieldMonitorName('temp(t=0.0..end(100))');
%     fieldsource.UseLastTimeFrame('1');
%     fieldsource.UseCopyOnly('0');
%     fieldsource.CreateFieldImport
%
% %Delete the FieldSource
%     fieldsource .Delete('CD1');
