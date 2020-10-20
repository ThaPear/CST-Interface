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

% The object is used to select or browse result file map items.
% If treepath is empty, then the current tree selection is loaded.
classdef ResultMap < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ResultMap object.
        function obj = ResultMap(project, hProject, treepath)
            obj.project = project;
            obj.hResultMap = hProject.invoke('ResultMap', treepath);
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their initial values.
            obj.hResultMap.invoke('Reset');
        end
        function Load(obj, sResultFileMapFile)
            % Load the result map data.
            obj.hResultMap.invoke('Load', sResultFileMapFile);
        end
        function BOOL = IsValid(obj)
            % Checks if a valid result map data is loaded.
            BOOL = obj.hResultMap.invoke('IsValid');
        end
        function String = GetContentDescription(obj)
            % Returns a description of the result map type.
            % "Invalid"                   Result map is not valid.
            % "Hex-Portmodes"             Port mode (hexahedral mesh)
            % "Tet-Portmodes"             Port mode (tetrahedral mesh)
            % "Hex-3DMonitor"             3D vector field monitor (hexahedral mesh)
            % "Tet-3DMonitor"             3D vector field monitor (tetrahedral mesh)
            % "Hex-ScalarMonitor"         Scalar field monitor  (hexahedral mesh)
            % "Tet-ScalarMonitor"         Scalar field monitor (tetrahedral mesh)
            % "Hex-SurfaceField"          Surface vector field  (hexahedral mesh)
            % "Tet-SurfaceField"          Surface vector field  (tetrahedral mesh)
            % "Int-SurfaceField"          Surface vector field  (surface mesh)
            % "Hex-SurfaceScalarField"    Scalar surface field  (hexahedral mesh)
            % "Tet-SurfaceScalarField"    Scalar surface field  (tetrahedral mesh)
            % "Int-SurfaceScalarField"    Scalar surface field  (surface mesh)
            % "S-Linear"                  S-Parameter result (linear scaling)
            % "S-dB"                      S-Parameter result (log. scale)
            % "arg(S)"                    S-Parameter result (phase)
            % "Residual"                  Residual result
            String = obj.hResultMap.invoke('GetContentDescription');
        end
        function Integer = GetItemCount(obj)
            % Returns the number of available result items.
            Integer = obj.hResultMap.invoke('GetItemCount');
        end
        function String = GetItemFilename(obj, id)
            % Returns the filename of item at position 'id'.
            String = obj.hResultMap.invoke('GetItemFilename', id);
        end
        function String = GetItemParameters(obj, id)
            % Returns the parameters and values of the item at position 'id'. The return string has the following form: 'name1=value1;name2=value2'
            String = obj.hResultMap.invoke('GetItemParameters', id);
        end
        function BeginSearch(obj)
            % Resets the search for the matching results.
            obj.hResultMap.invoke('BeginSearch');
        end
        function AddSearchParameter(obj, sParam, sValue, sTolerance)
            % Define the search for the result according to a specific value of the result map parameter within a given tolerance.
            % Only result items which match all search parameters are returned.
            obj.hResultMap.invoke('AddSearchParameter', sParam, sValue, sTolerance);
        end
        function Integer = FindItem(obj)
            % Returns the id of the first item matching all search parameters.
            Integer = obj.hResultMap.invoke('FindItem');
        end
        function SelectItem(obj, iItem)
            % Selected a result item specified by the integer id given. Use FindItem to obtain the id.
            obj.hResultMap.invoke('SelectItem', iItem);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hResultMap

    end
end

%% Default Settings

%% Example - Taken from CST documentation and translated to MATLAB.
% Dim count As Long
% Dim i As Integer
% Debug.Clear
% resultmap = project.ResultMap();
% If .IsValid Then
%
% % Write filenames and parameters to the debug output window
% count = .GetItemCount()
%
% For i = 1 To count
% Debug.Print .GetItemFilename(i)
% Debug.Print .GetItemParameters(i)
% Next i
%
% % Search for an item at 9 GHz
% .BeginSearch
% .AddSearchParameter('Frequency', 9e9, 1
% i = .FindItem
%
% If 0 < i Then
% .SelectItem i
% MsgBox('Result item was found at 9 GHz.');
% Else
% MsgBox('No result item was found at 9 GHz.');
% End If
% Else
% MsgBox('Result map is invalid, or none has been selected.');
% End If
