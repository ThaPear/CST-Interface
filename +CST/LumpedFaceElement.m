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
% Warning: This entire class is undocumented.
% This is a copy of LumpedElement, as the functions called in the history list look to be identical.

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK>

classdef LumpedFaceElement < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.LumpedFaceElement object.
        function obj = LumpedFaceElement(project, hProject)
            obj.project = project;
            obj.hLumpedFaceElement = hProject.invoke('LumpedFaceElement');
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
            % Resets all internal values to their default settings.
            obj.AddToHistory(['.Reset']);

            obj.name = [];
            obj.folder = [];
        end
        function Create(obj)
            % Creates a new element. All necessary settings for this element have to be made previously.
            obj.AddToHistory(['.Create']);

            % Prepend With LumpedFaceElement and append End With
            obj.history = [ 'With LumpedFaceElement', newline, ...
                                obj.history, ...
                            'End With'];
            if(~isempty(obj.folder))
                obj.project.AddToHistory(['define LumpedFaceElement: ', obj.folder, '/', obj.name, ''], obj.history);
            else
                obj.project.AddToHistory(['define LumpedFaceElement: ', obj.name], obj.history);
            end
            obj.history = [];
        end
        function Modify(obj)
            % Modifies an existing element. Only none geometrical settings which were made previously are changed.
            obj.AddToHistory(['.Modify']);

            % Prepend With LumpedFaceElement and append End With
            obj.history = [ 'With LumpedFaceElement', newline, ...
                                obj.history, ...
                            'End With'];
            if(~isempty(obj.folder))
                obj.project.AddToHistory(['modify LumpedFaceElement: ', obj.folder, '/', obj.name, ''], obj.history);
            else
                obj.project.AddToHistory(['modify LumpedFaceElement: ', obj.name], obj.history);
            end
            obj.history = [];
        end
        function SetType(obj, key)
            % Sets the type of the discrete element.
            % enum key
            % meaning
            % "rlcparallel"     -  The discrete element is made out of a parallel circuit of a resistance, an inductance and a capacitance. (default)
            % "rlcserial"       - The discrete element is made out of a parallel circuit of a resistance, an inductance and a capacitance.
            % "diode"           - The discrete element is a diode.
            % "generalcircuit"  -  The discrete element is defined by circuit file.
            obj.AddToHistory(['.SetType "', num2str(key, '%.15g'), '"']);
        end
        function SetName(obj, name)
            % Sets the name of the Lumped Face Element.
            obj.AddToHistory(['.SetName "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Folder(obj, foldername)
            % Sets the name of the folder for the new Lumped Face Element. If the name is empty, then the Lumped Face Element does not belong to a folder.
            obj.AddToHistory(['.Folder "', num2str(foldername, '%.15g'), '"']);
            obj.folder = foldername;
        end
        function SetR(obj, dValue)
            % Defines the value of resistance / inductance / capacitance of the Lumped Face Element.
            obj.AddToHistory(['.SetR "', num2str(dValue, '%.15g'), '"']);
        end
        function SetL(obj, dValue)
            % Defines the value of resistance / inductance / capacitance of the Lumped Face Element.
            obj.AddToHistory(['.SetL "', num2str(dValue, '%.15g'), '"']);
        end
        function SetC(obj, dValue)
            % Defines the value of resistance / inductance / capacitance of the Lumped Face Element.
            obj.AddToHistory(['.SetC "', num2str(dValue, '%.15g'), '"']);
        end
        function SetGs(obj, dValue)
            % Sets the blocking conductivity / reverse current / the temperature in Kelvin for the diode. These methods have only an effect if the .SetType method is set to "diode".
            obj.AddToHistory(['.SetGs "', num2str(dValue, '%.15g'), '"']);
        end
        function SetI0(obj, dValue)
            % Sets the blocking conductivity / reverse current / the temperature in Kelvin for the diode. These methods have only an effect if the .SetType method is set to "diode".
            obj.AddToHistory(['.SetI0 "', num2str(dValue, '%.15g'), '"']);
        end
        function SetT(obj, dValue)
            % Sets the blocking conductivity / reverse current / the temperature in Kelvin for the diode. These methods have only an effect if the .SetType method is set to "diode".
            obj.AddToHistory(['.SetT "', num2str(dValue, '%.15g'), '"']);
        end
        function SetP1(obj, picked, x, y, z)
            % Define the starting / end point of the discrete element. If picked is True, two previously picked points will be used for the coordinates of the start / end point. Otherwise the point will be defined by x / y / z.
            obj.AddToHistory(['.SetP1 "', num2str(picked, '%.15g'), '", '...
                                     '"', num2str(x, '%.15g'), '", '...
                                     '"', num2str(y, '%.15g'), '", '...
                                     '"', num2str(z, '%.15g'), '"']);
        end
        function SetP2(obj, picked, x, y, z)
            % Define the starting / end point of the discrete element. If picked is True, two previously picked points will be used for the coordinates of the start / end point. Otherwise the point will be defined by x / y / z.
            obj.AddToHistory(['.SetP2 "', num2str(picked, '%.15g'), '", '...
                                     '"', num2str(x, '%.15g'), '", '...
                                     '"', num2str(y, '%.15g'), '", '...
                                     '"', num2str(z, '%.15g'), '"']);
        end
        function [x0, y0, z0, x1, y1, z1] = GetCoordinates(obj, name)
            % Queries the start and end point coordinates of a discrete element specified by name.
            functionString = [...
                'Dim x0 As Double, y0 As Double, z0 As Double', newline, ...
                'Dim x1 As Double, y1 As Double, z1 As Double', newline, ...
                'LumpedFaceElement.GetCoordinates("', name, '", x0, y0, z0, x1, y1, z1)', newline, ...
            ];
            returnvalues = {'x0', 'y0', 'z0', 'x1', 'y1', 'z1'};
            [x0, y0, z0, x1, y1, z1] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            x0 = str2double(x0);
            y0 = str2double(y0);
            z0 = str2double(z0);
            x1 = str2double(x1);
            y1 = str2double(y1);
            z1 = str2double(z1);
        end
        function [type, R, L, C, Gs, I0, T, radius] = GetProperties(obj, name)
            % Queries the basic values of the Lumped Face Element with the given name. All other parameters are out-values. Returns false if name do not exists, true otherwise.
            functionString = [...
                'Dim type As String, R As Double, L As Double, C As Double, Gs As Double, I0 As Double, T As Double, radius As Double', newline, ...
                'LumpedFaceElement.GetProperties("', name, '", condX, condY, condZ)', newline, ...
            ];
            returnvalues = {'type', 'R', 'L', 'C', 'Gs', 'I0', 'T', 'radius'};
            [type, R, L, C, Gs, I0, T, radius] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            R = str2double(R);
            L = str2double(L);
            C = str2double(C);
            Gs = str2double(Gs);
            I0 = str2double(I0);
            T = str2double(T);
            radius = str2double(radius);
        end
        function CircuitFileName(obj, filename)
            % Sets the name of the external Spice file to be imported.
            obj.AddToHistory(['.CircuitFileName "', num2str(filename, '%.15g'), '"']);
        end
        function UseRelativePath(obj, flag)
            % Defines if the CircuitFileName is given with a relative or absolute path. In the former case CircuitFileName must specify a location relative to the current project file.
            obj.AddToHistory(['.UseRelativePath "', num2str(flag, '%.15g'), '"']);
        end
        function CircuitId(obj, Id)
            % Set a unique id to identify the local copy of the circuit file.
            obj.AddToHistory(['.CircuitId "', num2str(Id, '%.15g'), '"']);
        end
        function UseCopyOnly(obj, flag)
            % Only the initially copied circuit file in the project folder is used. Any later changes in the external file are ignored.
            obj.AddToHistory(['.UseCopyOnly "', num2str(flag, '%.15g'), '"']);
        end
        function StartLumpedFaceElementNameIteration(obj)
            % Initialize an iterator over all Lumped Face Elements and place it before the first element. Returns the current number of elements in the list.
            obj.AddToHistory(['.StartLumpedFaceElementNameIteration']);
        end
        function [name] = GetNextLumpedFaceElementName(obj)
            % Returns the name of the next available Lumped Face Element. Returns false if there are no other elements, true otherwise. Use GetNextLumpedFaceElementName to initialize the iteration. Example of usage:
            % Dim itemName As String
            % Dim lType As String  Dim valueR As Double
            % Dim valueL As Double
            % Dim valueC As Double
            % Dim valueGs As Double
            % Dim valueIO As Double
            % Dim valueT As Double
            % Dim valueRadius As Double
            % LumpedFaceElement.StartLumpedFaceElementNameIteration()
            % Do While LumpedFaceElement.GetNextLumpedFaceElementName(itemName)
            % If LumpedFaceElement.GetProperties(itemName, lType, valueR, valueL, valueC, valueGs, valueIO, valueT, valueRadius) Then
            % MsgBox ("Test: " & lType & " " & valueR & " " & valueL & " " & valueC & " " & valueGs & " " & valueIO & " " & valueT & " " & valueRadius )
            % Else
            % MsgBox ("Element do not exist")
            % End If
            % Loop
            functionString = [...
                'Dim name As String', newline, ...
                'LumpedFaceElement.GetNextLumpedFaceElementName(name)', newline, ...
            ];
            returnvalues = {'name'};
            [name] = obj.project.RunVBACode(functionString, returnvalues);
        end
        function SetInvert(obj, boolean)
            % Set switch to True to reverse the orientation of the Lumped Face Element. This might be important, if the Lumped Face Element is a diode.
            obj.AddToHistory(['.SetInvert "', num2str(boolean, '%.15g'), '"']);
        end
        function SetMonitor(obj, boolean)
            % If switch is True, current and voltage between start and end point of the Lumped Face Element will be monitored.
            obj.AddToHistory(['.SetMonitor "', num2str(boolean, '%.15g'), '"']);
        end
        function SetRadius(obj, value)
            % Specifies a radius for the Lumped Face Element.
            obj.AddToHistory(['.SetRadius "', num2str(value, '%.15g'), '"']);
        end
        function UseProjection(obj, flag)
            % When this flag is activated then one edge is projected onto the other edge and the face Lumped Face Element is created in between the edge and its projection.
            obj.AddToHistory(['.UseProjection "', num2str(flag, '%.15g'), '"']);
        end
        function ReverseProjection(obj, flag)
            % When this flag is activated then the second picked edge will be projected onto the first picked edge. This flag is only considered when UseProjection is active.
            obj.AddToHistory(['.ReverseProjection "', num2str(flag, '%.15g'), '"']);
        end
        function Wire(obj, wirename)
            % Defines the name of the wire, on which the Lumped Face Element is attached to.
            obj.AddToHistory(['.Wire "', num2str(wirename, '%.15g'), '"']);
        end
        function Position(obj, name)
            % Defines the end of the wire, on which the Lumped Face Element is attached to. Possible values are 'end1' or 'end2'.
            obj.AddToHistory(['.Position "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, sOldName, sNewName)
            % Changes the name of an existing object.
            obj.project.AddToHistory(['LumpedFaceElement.Rename "', num2str(sOldName, '%.15g'), '", '...
                                                                '"', num2str(sNewName, '%.15g'), '"']);
        end
        function Delete(obj, name)
            % Deletes an existing object.
            obj.project.AddToHistory(['LumpedFaceElement.Delete "', num2str(name, '%.15g'), '"']);
        end
        function NewFolder(obj, foldername)
            % Creates a new folder with the given name.
            obj.project.AddToHistory(['LumpedFaceElement.NewFolder "', num2str(foldername, '%.15g'), '"']);
        end
        function DeleteFolder(obj, foldername)
            % Deletes an existing folder and all the containing elements.
            obj.project.AddToHistory(['LumpedFaceElement.DeleteFolder "', num2str(foldername, '%.15g'), '"']);
        end
        function RenameFolder(obj, oldFoldername, newFoldername)
            % Changes the name of an existing folder.
            obj.project.AddToHistory(['LumpedFaceElement.RenameFolder "', num2str(oldFoldername, '%.15g'), '", '...
                                                                      '"', num2str(newFoldername, '%.15g'), '"']);
        end
        function Defaults(obj)
            % SetType ("rlcparallel")
            % SetR (0)
            % SetL (0)
            % SetC (0)
            % SetGs (0)
            % SetT (0)
            % SetP1 (False, 0, 0, 0)
            % SetP2 (False, 0, 0, 0)
            % SetInvert (False)
            % SetMonitor (False)
            % SetRadius (0.0)
            obj.AddToHistory(['.Defaults']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hLumpedFaceElement
        history

        name
        folder
    end
end
