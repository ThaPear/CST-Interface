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

% This command offers the option to create an ADS® parametric component based  on the current project.
classdef ADSComponentExport < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ADSComponentExport object.
        function obj = ADSComponentExport(project, hProject)
            obj.project = project;
            obj.hADSComponentExport = hProject.invoke('ADSComponentExport');
        end
    end
    %% CST Object functions.
    methods
        function AddCurrentSparameterToMdifFile(obj)
            % This command stored the currently calculated S-parameters together with the current structure parameters in the "<projectname>^sparameters.mdf" data file. This file may contain a collection of various S-parameter results for several structure parameter combinations. All data stored in this file can later be accessed from within the ADS schematic by using the corresponding component. Other parameter settings within this range will then be interpolated between the given data points, parameter settings outside this range will be extrapolated accordingly.
            obj.hADSComponentExport.invoke('AddCurrentSparameterToMdifFile');
        end
        function SetDescription(obj, description)
            % Sets the description text of the ADS schematic component. This text will be used when the component is created the next time.
            obj.hADSComponentExport.invoke('SetDescription', description);
        end
        function SetParameterType(obj, parametername, type)
            % This command sets the type of a parameter. This information is required to correctly consider different unit settings in CST MICROWAVE STUDIO and ADS. Once the type of the parameter is known, the actual values are scaled accordingly.
            % type can have one of  the following values:
            % "String"        The parameter is an arbitrary string (no scaling)
            % "Unitless"      The parameter does not have a unit (no scaling)
            % "Frequency"     The parameter is related to a frequency (scaling by frequency units)
            % "Resistance"    The parameter is related to a resistance (scaling by resistance units)
            % "Conductance"   The parameter is related to a conductance (scaling by conductance units)
            % "Inductance"    The parameter is related to a inductance (scaling by inductance units)
            % "Capacitance"   The parameter is related to a capacitance (scaling by capacitance units)
            % "Length"        The parameter is related to a length (scaling by length units)
            % "Time"          The parameter is related to a time (scaling by time units)
            % "Angle"         The parameter is related to an angle (scaling by angular units)
            % "Power"         The parameter is related to a power (scaling by power units)
            % "Voltage"       The parameter is related to a voltage (scaling by voltage units)
            % "Current"       The parameter is related to a current (scaling by current units)
            % "Distance"      The parameter is related to a distance (scaling by distance units)
            % "Temperature"   The parameter is related to a temperature (scaling by temperature units)
            % "dB"            The parameter is related to a dB value (no scaling)
            obj.hADSComponentExport.invoke('SetParameterType', parametername, type);
        end
        function ExportADSComponent(obj)
            % This command creates the ADS component in the design kit by using the previously made settings concerning description and parameter types.
            obj.hADSComponentExport.invoke('ExportADSComponent');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hADSComponentExport

    end
end

%% Default Settings
% SetDescription(');<ADS component name> Component');
% SetParameterType(');*', 'Unitless');

%% Example - Taken from CST documentation and translated to MATLAB.
% Storing currently calculated S-parameters in the data file for later use within the component. The data is stored together with the current parameter settings which allows for a parametric data access from within the ADS schematic.
% 
% adscomponentexport = project.ADSComponentExport();
%     adscomponentexport.AddCurrentSparameterToMdifFile
% 
% Automatically creating an ADS component from within a VBA script:
% 
%  With ADSComponentExport
%     adscomponentexport.SetDescription('Magic Tee 4 Port Rectangular Waveguide');
%     adscomponentexport.SetParameterType('waveguide_width', 'Length');
%     adscomponentexport.SetParameterType('waveguide_height', 'Length');
%     adscomponentexport.ExportADSComponent
% 
