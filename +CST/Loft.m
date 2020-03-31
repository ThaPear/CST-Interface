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

% Creates a solid that connects two surfaces.
classdef Loft < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a Loft object.
        function obj = Loft(project, hProject)
            obj.project = project;
            obj.hLoft = hProject.invoke('Loft');
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
            % Resets all internal settings.
            obj.AddToHistory(['.Reset']);
            
            obj.name = [];
            obj.component = [];
        end
        function Name(obj, objectname)
            % Sets the name of the new Object.
            obj.AddToHistory(['.Name "', num2str(objectname, '%.15g'), '"']);
            obj.name = objectname;
        end
        function Component(obj, componentname)
            % Sets the component for the new Solid. The component must already exist.
            obj.AddToHistory(['.Component "', num2str(componentname, '%.15g'), '"']);
            obj.component = componentname;
        end
        function Material(obj, materialname)
            % Sets the material for the new Solid. The material must already exist.
            obj.AddToHistory(['.Material "', num2str(materialname, '%.15g'), '"']);
        end
        function Tangency(obj, tang)
            % Defines the shape of the connection.
            obj.AddToHistory(['.Tangency "', num2str(tang, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates a new solid. All necessary settings for this element have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With Loft and append End With
            obj.history = [ 'With Loft', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define loft: ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end
        %% Undocumented functions.
        % Found in history list of migrated CST 2014 file in 'define loft'.
        % Possibly equivalent to Loft.Create.
        function CreateNew(obj)
            obj.AddToHistory(['.CreateNew']);
            
            % Prepend With Loft and append End With
            obj.history = [ 'With Loft', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define loft: ', obj.component, ':', obj.name], obj.history);
            obj.history = [];
        end
        % Found in history list of migrated CST 2014 file in 'define loft'.
        function Minimizetwist(obj, boolean)
            obj.AddToHistory(['.Minimizetwist "', num2str(boolean, '%.15g'), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hLoft
        history

        name
        component
    end
end

%% Default Settings
% Material('default');
% Component('default');

%% Example - Taken from CST documentation and translated to MATLAB.
% loft = project.Loft();
%     loft.Reset
%     loft.Name('solid3');
%     loft.Component('component1');
%     loft.Material('Vacuum');
%     loft.Tangency('0.250000');
%     loft.CreateNew
