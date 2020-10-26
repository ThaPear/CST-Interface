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

% This object is used to specify a domain (cavity) for a (not explicitly modeled) fluid for the Conjugate Heat Transfer Solver.
% If a fluid domain is not closed, each open part must be closed by a lid.
classdef FluidDomain < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.FluidDomain object.
        function obj = FluidDomain(project, hProject)
            obj.project = project;
            obj.hFluidDomain = hProject.invoke('FluidDomain');
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
            % Resets all internal settings of the fluid domain to their default values.
            obj.AddToHistory(['.Reset']);
        end
        function Name(obj, name)
            % Specifies the name of the fluid domain. Each fluid domain must have a unique name.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
        end
        function CavityMaterial(obj, materialname)
            % Specifies the material of fluid inside the fluid domain. The materialname should be a name of a material that exists in the active project.
            obj.AddToHistory(['.CavityMaterial "', num2str(materialname, '%.15g'), '"']);
        end
        function AddFace(obj, solidname, faceid)
            % Defines a face inside the fluid domain cavity. For a complex cavities, consisting of multiple connected solids, it is sufficient to specify only one interior face.
            % In order to define multiple disjoint domains with the same properties, multiple faces can be defined.
            % Each face describing the fluid domain must be specified by its faceid of the solid with name solidname.
            obj.AddToHistory(['.AddFace "', num2str(solidname, '%.15g'), '", '...
                                       '"', num2str(faceid, '%.15g'), '"']);
        end
        function InvertNormal(obj, flag)
            % Usually, the fluid domain is considered the domain into which the normal vector of the picked face is pointing. In general, this is the background material side of the face.
            % In order to change this direction, i.e. the side of the picked face, the flag should be set True.
            % default: value = False
            obj.AddToHistory(['.InvertNormal "', num2str(flag, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the fluid domain with its previously made settings.
            obj.AddToHistory(['.Create']);

            % Prepend With FluidDomain and append End With
            obj.history = [ 'With FluidDomain', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define FluidDomain'], obj.history);
            obj.history = [];
        end
        function Delete(obj, name)
            % Deletes the fluid domain with the given name.
            obj.AddToHistory(['.Delete "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the fluid domain with the given oldname to the defined newname.
            obj.AddToHistory(['.Rename "', num2str(oldname, '%.15g'), '", '...
                                      '"', num2str(newname, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hFluidDomain
        history

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% fluiddomain = project.FluidDomain();
%     fluiddomain.Reset
%     fluiddomain.Name('fluiddomain_water');
%     fluiddomain.CavityMaterial('Water');
%     fluiddomain.AddFace('component1:pipe', '352');
%     fluiddomain.InvertNormal('0');
%     fluiddomain.Create
%
%
