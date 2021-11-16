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

% Lumped elements can be used to include electronic components such as resistors, inductances, capacitances and diodes into the simulation.
classdef LumpedElement < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.LumpedElement object.
        function obj = LumpedElement(project, hProject)
            obj.project = project;
            obj.hLumpedElement = hProject.invoke('LumpedElement');
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
            % (2020) For the definition of a multipin lumped element (typemultipingroupspice or multipingrouptouchstone) use the CreateMultipin method.
            obj.AddToHistory(['.Create']);

            % Prepend With LumpedElement and append End With
            obj.history = [ 'With LumpedElement', newline, ...
                                obj.history, ...
                            'End With'];
            if(~isempty(obj.folder))
                obj.project.AddToHistory(['define LumpedElement: ', obj.folder, '/', obj.name, ''], obj.history);
            else
                obj.project.AddToHistory(['define LumpedElement: ', obj.name], obj.history);
            end
            obj.history = [];
        end
        function Modify(obj)
            % Modifies an existing element. Only none geometrical settings which were made previously are changed.
            obj.AddToHistory(['.Modify']);

            % Prepend With LumpedElement and append End With
            obj.history = [ 'With LumpedElement', newline, ...
                                obj.history, ...
                            'End With'];
            if(~isempty(obj.folder))
                obj.project.AddToHistory(['modify LumpedElement: ', obj.folder, '/', obj.name, ''], obj.history);
            else
                obj.project.AddToHistory(['modify LumpedElement: ', obj.name], obj.history);
            end
            obj.history = [];
        end
        function SetType(obj, key)
            % Sets the type of the discrete element.
            % enum key                           meaning
            % "rlcparallel"                      The discrete element is made out of a parallel circuit of a resistance, an inductance and a capacitance. (default)
            % "rlcserial"                        The discrete element is made out of a parallel circuit of a resistance, an inductance and a capacitance.
            % "diode"                            The discrete element is a diode.
            % "generalcircuit"                   The discrete element is defined by circuit file.
            % (2020) "spicecircuit"              The discrete element is defined by circuit file with Spice format (typical extensions are *.cir, *.net).
            % (2020) "touchstone"                The discrete element is defined by circuit file with Touchstone format (typical extensions are *.ts, *.s*p).
            % (2020) "multipingroupitem"         The discrete element is a multipin sub-element to be connected to a multipin lumped element (with type "multipingroupspice" or multipingrouptouchstone").
            % (2020) "multipingroupspice"        The discrete element is a multipin lumped element defined by circuit file with Spice format (typical extensions are *.cir, *.net).
            % (2020) "multipingrouptouchstone"   The discrete element is a multipin lumped element defined by circuit file with Touchstone format (typical extensions are *.ts, *.s*p).

            obj.AddToHistory(['.SetType "', num2str(key, '%.15g'), '"']);
        end
        function SetName(obj, name)
            % Sets the name of the lumped element.
            obj.AddToHistory(['.SetName "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Folder(obj, foldername)
            % Sets the name of the folder for the new lumped element. If the name is empty, then the lumped element does not belong to a folder.
            obj.AddToHistory(['.Folder "', num2str(foldername, '%.15g'), '"']);
            obj.folder = foldername;
        end
        function SetR(obj, dValue)
            % Defines the value of resistance / inductance / capacitance of the lumped element.
            obj.AddToHistory(['.SetR "', num2str(dValue, '%.15g'), '"']);
        end
        function SetL(obj, dValue)
            % Defines the value of resistance / inductance / capacitance of the lumped element.
            obj.AddToHistory(['.SetL "', num2str(dValue, '%.15g'), '"']);
        end
        function SetC(obj, dValue)
            % Defines the value of resistance / inductance / capacitance of the lumped element.
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
        function [boolean, x0, y0, z0, x1, y1, z1] = GetCoordinates(obj, name)
            % Queries the start and end point coordinates of a discrete element specified by name.
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim x0 As Double, y0 As Double, z0 As Double', newline, ...
                'Dim x1 As Double, y1 As Double, z1 As Double', newline, ...
                'bool = LumpedElement.GetCoordinates("', name, '", x0, y0, z0, x1, y1, z1)', newline, ...
            ];
            returnvalues = {'bool', 'x0', 'y0', 'z0', 'x1', 'y1', 'z1'};
            [boolean, x0, y0, z0, x1, y1, z1] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            boolean = str2double(boolean);
            x0 = str2double(x0);
            y0 = str2double(y0);
            z0 = str2double(z0);
            x1 = str2double(x1);
            y1 = str2double(y1);
            z1 = str2double(z1);
        end
        function [boolean, type, R, L, C, Gs, I0, T, radius] = GetProperties(obj, name)
            % Queries the basic values of the Lumped Element with the given name. All other parameters are out-values. Returns false if name do not exists, true otherwise.
            functionString = [...
                'Dim bool As Boolean, type As String, R As Double, L As Double, C As Double, Gs As Double, I0 As Double, T As Double, radius As Double', newline, ...
                'bool = LumpedElement.GetProperties("', name, '", condX, condY, condZ)', newline, ...
            ];
            returnvalues = {'bool', 'type', 'R', 'L', 'C', 'Gs', 'I0', 'T', 'radius'};
            [boolean, type, R, L, C, Gs, I0, T, radius] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            boolean = str2double(boolean);
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
            % (2020) Sets the name of the external Spice or Touchstone file to be imported for the spicecircuit, touchstone, multipingroupspice and multipingrouptouchstone element type.
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
        function StartLumpedElementNameIteration(obj)
            % Initialize an iterator over all Lumped Elements and place it before the first element. Returns the current number of elements in the list.
            obj.AddToHistory(['.StartLumpedElementNameIteration']);
        end
        function [boolean, name] = GetNextLumpedElementName(obj)
            % Returns the name of the next available Lumped Element. Returns false if there are no other elements, true otherwise. Use GetNextLumpedElementName to initialize the iteration. Example of usage:
            % Dim itemName As String
            % Dim lType As String  Dim valueR As Double
            % Dim valueL As Double
            % Dim valueC As Double
            % Dim valueGs As Double
            % Dim valueIO As Double
            % Dim valueT As Double
            % Dim valueRadius As Double
            % LumpedElement.StartLumpedElementNameIteration()
            % Do While LumpedElement.GetNextLumpedElementName(itemName)
            % If LumpedElement.GetProperties(itemName, lType, valueR, valueL, valueC, valueGs, valueIO, valueT, valueRadius) Then
            % MsgBox ("Test: " & lType & " " & valueR & " " & valueL & " " & valueC & " " & valueGs & " " & valueIO & " " & valueT & " " & valueRadius )
            % Else
            % MsgBox ("Element do not exist")
            % End If
            % Loop
            functionString = [...
                'Dim bool As Boolean', newline, ...
                'Dim name As String', newline, ...
                'bool = LumpedElement.GetNextLumpedElementName(name)', newline, ...
            ];
            returnvalues = {'bool, name'};
            [boolean, name] = obj.project.RunVBACode(functionString, returnvalues);
        end
        function SetInvert(obj, boolean)
            % Set switch to True to reverse the orientation of the lumped element. This might be important, if the lumped element is a diode.
            obj.AddToHistory(['.SetInvert "', num2str(boolean, '%.15g'), '"']);
        end
        function SetMonitor(obj, boolean)
            % If switch is True, current and voltage between start and end point of the lumped element will be monitored.
            obj.AddToHistory(['.SetMonitor "', num2str(boolean, '%.15g'), '"']);
        end
        function SetRadius(obj, value)
            % Specifies a radius for the lumped element.
            obj.AddToHistory(['.SetRadius "', num2str(value, '%.15g'), '"']);
        end
        function UseProjection(obj, flag)
            % When this flag is activated then one edge is projected onto the other edge and the face lumped element is created in between the edge and its projection.
            obj.AddToHistory(['.UseProjection "', num2str(flag, '%.15g'), '"']);
            obj.useprojection = flag;
        end
        function ReverseProjection(obj, flag)
            % When this flag is activated then the second picked edge will be projected onto the first picked edge. This flag is only considered when UseProjection is active.
            obj.AddToHistory(['.ReverseProjection "', num2str(flag, '%.15g'), '"']);
            obj.reverseprojection = flag;
        end
        function Wire(obj, wirename)
            % Defines the name of the wire, on which the lumped element is attached to.
            obj.AddToHistory(['.Wire "', num2str(wirename, '%.15g'), '"']);
        end
        function Position(obj, name)
            % Defines the end of the wire, on which the lumped element is attached to. Possible values are 'end1' or 'end2'.
            obj.AddToHistory(['.Position "', num2str(name, '%.15g'), '"']);
        end
        function Rename(obj, sOldName, sNewName)
            % Changes the name of an existing object.
            obj.project.AddToHistory(['LumpedFaceElement.Rename "', num2str(sOldName, '%.15g'), '", '...
                                                                '"', num2str(sNewName, '%.15g'), '"']);
        end
        function Delete(obj, name)
            % Deletes an existing object.
            obj.project.AddToHistory(['LumpedElement.Delete "', num2str(name, '%.15g'), '"']);
        end
        function NewFolder(obj, foldername)
            % Creates a new folder with the given name.
            obj.project.AddToHistory(['LumpedElement.NewFolder "', num2str(foldername, '%.15g'), '"']);
        end
        function DeleteFolder(obj, foldername)
            % Deletes an existing folder and all the containing elements.
            obj.project.AddToHistory(['LumpedElement.DeleteFolder "', num2str(foldername, '%.15g'), '"']);
        end
        function RenameFolder(obj, oldFoldername, newFoldername)
            % Changes the name of an existing folder.
            obj.project.AddToHistory(['LumpedElement.RenameFolder "', num2str(oldFoldername, '%.15g'), '", '...
                                                                  '"', num2str(newFoldername, '%.15g'), '"']);
        end
        %% CST 2020 Functions.
        function CreateMultipin(obj)
            % Creates a new multipin lumped element. All necessary settings for this element have to be made previously. For the definition of elements other than multipin (typemultipingroupspice or multipingrouptouchstone) use the Create method.
            obj.AddToHistory(['.CreateMultipin']);
        end
        function ConnectMultipinElementPinToSubElement(obj, multipin_name, circuit_pin_name, multipin_sub_element_name)
            % Connect a circuit pin of a multipin lumped element (typemultipingroupspice or multipingrouptouchstone) to a multipin sub-element (typemultipingroupitem).
            obj.AddToHistory(['.ConnectMultipinElementPinToSubElement "', num2str(multipin_name, '%.15g'), '", '...
                                                                     '"', num2str(circuit_pin_name, '%.15g'), '", '...
                                                                     '"', num2str(multipin_sub_element_name, '%.15g'), '"']);
        end
        function ConnectMultipinElementPinToShort(obj, multipin_name, circuit_pin_name)
            % Define a circuit pin of a multipin lumped element (typemultipingroupspice or multipingrouptouchstone) be connected to the ideal circuit ground (ConnectMultipinElementPinToShort method) or to be kept floating (ConnectMultipinElementPinToOpen method).
            obj.AddToHistory(['.ConnectMultipinElementPinToShort "', num2str(multipin_name, '%.15g'), '", '...
                                                                '"', num2str(circuit_pin_name, '%.15g'), '"']);
        end
        function ConnectMultipinElementPinToOpen(obj)
            % Define a circuit pin of a multipin lumped element (typemultipingroupspice or multipingrouptouchstone) be connected to the ideal circuit ground (ConnectMultipinElementPinToShort method) or to be kept floating (ConnectMultipinElementPinToOpen method).
            obj.AddToHistory(['.ConnectMultipinElementPinToOpen']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hLumpedElement
        history

        name
        folder
    end
end

%% Default Settings
% SetType('rlcparallel');
% SetR(0)
% SetL(0)
% SetC(0)
% SetGs(0)
% SetT(0)
% SetP1(0, 0, 0, 0)
% SetP2(0, 0, 0, 0)
% SetInvert(0)
% SetMonitor(0)
% SetRadius(0.0)
%
