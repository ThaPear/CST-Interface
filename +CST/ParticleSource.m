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

% The Object is used to create a new Particle Source for the tracking and the PIC solvers.
classdef ParticleSource < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ParticleSource object.
        function obj = ParticleSource(project, hProject)
            obj.project = project;
            obj.hParticleSource = hProject.invoke('ParticleSource');
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
            % Sets the name of the particle source.
            obj.AddToHistory(['.Name "', num2str(name, '%.15g'), '"']);
            obj.name = name;
        end
        function Create(obj)
            % Creates a new particle source. All necessary settings for this object have to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With ParticleSource and append End With
            obj.history = [ 'With ParticleSource', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define ParticleSource: ', obj.name], obj.history);
            obj.history = [];
        end
        function Rename(obj, oldname, newname)
            % Changes the name of an existing particle source.
            obj.project.AddToHistory(['ParticleSource.Rename "', num2str(oldname, '%.15g'), '", '...
                                                            '"', num2str(newname, '%.15g'), '"']);
        end
        function Delete(obj, name)
            % Deletes the particle source with the given name.
            obj.project.AddToHistory(['ParticleSource.Delete "', num2str(name, '%.15g'), '"']);
        end
        function ParticleType(obj, typename)
            % Type of the emitted particles.
            % enum typename   meaning
            % "Userdefined"   a particle which has to  be defined by the charge and mass methods.
            % "Electron"      particle with charge and mass properties of an electron.
            % "Proton"        particle with charge and mass properties of a proton.
            obj.AddToHistory(['.ParticleType "', num2str(typename, '%.15g'), '"']);
        end
        function SourceType(obj, type)
            % Set the source type. Possible values are:
            % Faces
            % SinglePoint
            % Circle
            obj.AddToHistory(['.SourceType "', num2str(type, '%.15g'), '"']);
        end
        function Charge(obj, charge)
            % Value of the charge (C).
            obj.AddToHistory(['.Charge "', num2str(charge, '%.15g'), '"']);
        end
        function Mass(obj, mass)
            % Value of the mass (kg).
            obj.AddToHistory(['.Mass "', num2str(mass, '%.15g'), '"']);
        end
        %% Tracking emission model settings
        function TrkEmissionMode(obj, model)
            % Describes the emission model of the particle source.
            % enum model      meaning
            % "Fixed"         Fixed kinetic emission energy.
            % "Space charge"  Space charge limited emission model.
            % "Thermionic"    Temperature dependent emission model.
            % "Field-induced" Field-induced emission model.
            obj.AddToHistory(['.TrkEmissionMode "', num2str(model, '%.15g'), '"']);
        end
        function TrkKinetic(obj, type, distribution, value, spreadKinetic, spreadAngle, maxwellTemp, maxwellBins)
            % Kinetic settings of the emission model. The kinetic type has to be one of the following values.
            % enum type           meaning
            % "Normed Momentum"   normed momentum
            % "Gamma"             relativistic factor
            % "Beta"              velocity relative to speed of light
            % "Energy"            kinetic particle energy
            % "Temperature"       temperature (instead velocity)
            % "Velocity"          velocity
            % with c = speed of light, q = charge of particle and m0 = initial mass of particle.
            % - The kinetic distribution can be "Uniform" or "Maxwell".
            % - Value is the value for the entered kinetic type.
            % - The kinetic spread has to be specified in percent.
            % - An emission angle distribution can be defined by entering a non-zero angle spread.
            % - If the distribution is set to Maxwell", the Maxwell temperature will be used to calculate the kinetic start settings.
            % - Enter the number of Maxwell bins of the Maxwell distribution.
            obj.AddToHistory(['.TrkKinetic "', num2str(type, '%.15g'), '", '...
                                          '"', num2str(distribution, '%.15g'), '", '...
                                          '"', num2str(value, '%.15g'), '", '...
                                          '"', num2str(spreadKinetic, '%.15g'), '", '...
                                          '"', num2str(spreadAngle, '%.15g'), '", '...
                                          '"', num2str(maxwellTemp, '%.15g'), '", '...
                                          '"', num2str(maxwellBins, '%.15g'), '"']);
        end
        function TrkField(obj, linear, exponential)
            % Defines the linear and the exponential parameters for the field emission model.
            obj.AddToHistory(['.TrkField "', num2str(linear, '%.15g'), '", '...
                                        '"', num2str(exponential, '%.15g'), '"']);
        end
        function TrkFixed(obj, currentParameter, useCurrentDensity)
            % Defines the current of the current density for the fixed emission model. If useCurrentDensity is true, currentParameter  represents a current density. Otherwise, it represents a current.
            obj.AddToHistory(['.TrkFixed "', num2str(currentParameter, '%.15g'), '", '...
                                        '"', num2str(useCurrentDensity, '%.15g'), '"']);
        end
        function TrkOblique(obj, angleTheta, anglePhi)
            % Defines the angles theta and phi for the oblique emission feature in the fixed emission model.
            obj.AddToHistory(['.TrkOblique "', num2str(angleTheta, '%.15g'), '", '...
                                          '"', num2str(anglePhi, '%.15g'), '"']);
        end
        function TrkSCL(obj, calcKineticAuto, emitPotName, emitPotValue, refPotValue, virtualDistance)
            % Defines the model parameters for the space charge limited emission model.
            % - If calcKineticAuto is true, the kinetic start settings will be automatically calculated by the solver (based on the emission model).
            % - Enter the potential names in emitPotName and refPotName. If a name is "User defined", the potential value has to be entered. Otherwise the value must be an empty string.
            % - The last parameter virtualDistance defines the virtual gap extension
            obj.AddToHistory(['.TrkSCL "', num2str(calcKineticAuto, '%.15g'), '", '...
                                      '"', num2str(emitPotName, '%.15g'), '", '...
                                      '"', num2str(emitPotValue, '%.15g'), '", '...
                                      '"', num2str(refPotValue, '%.15g'), '", '...
                                      '"', num2str(virtualDistance, '%.15g'), '"']);
        end
        function TrkTherm(obj, temperature, workFunction, richardsonConst, calcRichardsonConst)
            % Defines the model parameters for the thermionic emission model. If calcRichardsonConst is true, the Richardson constant will be automatically calculated by the solver. The work function has to be entered in eV, the temperature in Kelvin.
            obj.AddToHistory(['.TrkTherm "', num2str(temperature, '%.15g'), '", '...
                                        '"', num2str(workFunction, '%.15g'), '", '...
                                        '"', num2str(richardsonConst, '%.15g'), '", '...
                                        '"', num2str(calcRichardsonConst, '%.15g'), '"']);
        end
        %% Single point source settings
        function UsePick(obj, bPick)
            % Select, if a pick a pick point is used or not.
            obj.AddToHistory(['.UsePick "', num2str(bPick, '%.15g'), '"']);
        end
        function StartPoint(obj, x, y, z)
            % Set the emission point of the particle.
            obj.AddToHistory(['.StartPoint "', num2str(x, '%.15g'), '", '...
                                          '"', num2str(y, '%.15g'), '", '...
                                          '"', num2str(z, '%.15g'), '"']);
        end
        function StartNormal(obj, vx, vy, vz)
            % Set the start normal for the particle.
            obj.AddToHistory(['.StartNormal "', num2str(vx, '%.15g'), '", '...
                                           '"', num2str(vy, '%.15g'), '", '...
                                           '"', num2str(vz, '%.15g'), '"']);
        end
        function StartArea(obj, area)
            % Set the start area to calculate the current density.
            obj.AddToHistory(['.StartArea "', num2str(area, '%.15g'), '"']);
        end
        %% Circular source settings
        function UsePickCircle(obj, bPick)
            % Selects if a pick face or edge is used or not.
            obj.AddToHistory(['.UsePickCircle "', num2str(bPick, '%.15g'), '"']);
        end
        function InvertPickedCircleNormal(obj, bPickInvert)
            % If a pick is used to define the circular source, then this parameter, if true, inverts the source normal.
            obj.AddToHistory(['.InvertPickedCircleNormal "', num2str(bPickInvert, '%.15g'), '"']);
        end
        function CircleCenterPoint(obj, x, y, z)
            % Sets the circle center coordinates.
            obj.AddToHistory(['.CircleCenterPoint "', num2str(x, '%.15g'), '", '...
                                                 '"', num2str(y, '%.15g'), '", '...
                                                 '"', num2str(z, '%.15g'), '"']);
        end
        function CircleNormal(obj, x, y, z)
            % Sets the coordinates of the surface normal.
            obj.AddToHistory(['.CircleNormal "', num2str(x, '%.15g'), '", '...
                                            '"', num2str(y, '%.15g'), '", '...
                                            '"', num2str(z, '%.15g'), '"']);
        end
        function CircleRadius(obj, value)
            % Sets the outer radius of the circular emission area.
            obj.AddToHistory(['.CircleRadius "', num2str(value, '%.15g'), '"']);
        end
        function CircleRadiusInner(obj, value)
            % Sets the inner radius of the circular emission area.
            obj.AddToHistory(['.CircleRadiusInner "', num2str(value, '%.15g'), '"']);
        end
        function CircleRadiusLines(obj, value)
            % Sets the number of concentric equidistant circles lying between the outer and the inner radius, along which the emission points are uniformly distributed.
            obj.AddToHistory(['.CircleRadiusLines "', num2str(value, '%.15g'), '"']);
        end
        function RadialFunction(obj, type)
            % Sets the type of the emitted charge profile as a function of the radius. For non-constant profiles, the command RadialFunctionParameter must be set too. The parameters cscale and c2 are derived automatically by the condition that the emitted current is consistent with the chosen emission model.
            % enum type               Description                             Equation        Parameter 1                     Parameter 2
            % "constant"              Constant as a function of radius.
            % "gaussian_no_offset"    Simple gaussian profile.                <equation>      Standard deviation
            % "polynomial"            Polynomial dependency with offset.      <equation>      Offset (profile value at r=0)   Polynomial degree
            % "gaussian"              Profile used for version prior to 2018.
            %                         Only available via VBA.                 <equation>      Offset (profile value at r=0)   Standard deviation
            obj.AddToHistory(['.RadialFunction "', num2str(type, '%.15g'), '"']);
        end
        function RadialFunctionParameter(obj, index, value)
            % Sets the value of a signle parameter for the type of the radial profile specified via RadialFunction. Index must start from 0. Example of defining a radial profile via VBA:
            % .Radial Function "gaussian_no_offset"
            % .RadialFunctionParameter "0", "1.5"
            obj.AddToHistory(['.RadialFunctionParameter "', num2str(index, '%.15g'), '", '...
                                                       '"', num2str(value, '%.15g'), '"']);
        end
        %% Triangulation settings
        function PECSurface(obj, PEC_Surface)
            % Sets the material type of the emitting surface: True for PEC, False for arbitrary material.
            obj.AddToHistory(['.PECSurface "', num2str(PEC_Surface, '%.15g'), '"']);
        end
        function ScaleTriangularizationToMesh(obj, scale_to_mesh)
            % When scale_to_mesh = True, the density of the emission points is adapted to the computational mesh. For emission models other than "Fixed", it is recommended to set this flag to True".
            obj.AddToHistory(['.ScaleTriangularizationToMesh "', num2str(scale_to_mesh, '%.15g'), '"']);
        end
        function FacetOptions(obj, density, scale)
            % Density can have values between 0 and 90. A density of 0 leads to a coarse triangulation, a value of 90 leads to a fine triangulation. To get very fine triangulations, the scale can be increased. Possible scale values are 1, 10 and 100.
            obj.AddToHistory(['.FacetOptions "', num2str(density, '%.15g'), '", '...
                                            '"', num2str(scale, '%.15g'), '"']);
        end
        function AddFace(obj, name, faceid)
            % Add a new surface of a solid  to a particle source definition.
            obj.AddToHistory(['.AddFace "', num2str(name, '%.15g'), '", '...
                                       '"', num2str(faceid, '%.15g'), '"']);
        end
        %% Particle-in-Cell emission model settings
        function PICEmissionModel(obj, model)
            % Describes the PIC emission model of the particle source.
            % enum model      meaning
            % "Gauss"         Particles are emitted in pulses/bunches of a Gaussian charge distribution..
            % "DC"            Emitted particles form a continuous current.
            % "Field"         Field emission model based on Fowler-Nordheim equations.
            % "Explosive"     Explosive emission model.
            obj.AddToHistory(['.PICEmissionModel "', num2str(model, '%.15g'), '"']);
        end
        function PICEnergy(obj, value, type)
            % Sets the kinetic emission type and its value for the beam emission model. Possible values for the type are:
            % - Normed Momentum
            % - Energy
            % - Gamma
            % - Beta
            % - Velocity
            obj.AddToHistory(['.PICEnergy "', num2str(value, '%.15g'), '", '...
                                         '"', num2str(type, '%.15g'), '"']);
        end
        function PICBunchCharge(obj, value)
            % Sets the bunch charge for the Gaussian emission model.
            obj.AddToHistory(['.PICBunchCharge "', num2str(value, '%.15g'), '"']);
        end
        function PICBunchDefinitionType(obj, type)
            % Sets the state, if the emission bunch is defined in time or space for the Gaussian emission model. Possible values for type are "Time" and "Length".
            obj.AddToHistory(['.PICBunchDefinitionType "', num2str(type, '%.15g'), '"']);
        end
        function PICBunchSigma(obj, value)
            % Sets the variance of the Gaussian pulse for the Gaussian emission model.
            obj.AddToHistory(['.PICBunchSigma "', num2str(value, '%.15g'), '"']);
        end
        function PICBunchCutoffLength(obj, value)
            % Sets the cutoff length of the Gaussian pulse for the Gaussian emission model.
            obj.AddToHistory(['.PICBunchCutoffLength "', num2str(value, '%.15g'), '"']);
        end
        function PICBunchOffset(obj, value)
            % Sets the offset of the Gaussian beam for the Gaussian emission model.
            obj.AddToHistory(['.PICBunchOffset "', num2str(value, '%.15g'), '"']);
        end
        function PICNBunches(obj, value)
            % Sets the number of Gaussian pulses for the Gaussian emission model.
            obj.AddToHistory(['.PICNBunches "', num2str(value, '%.15g'), '"']);
        end
        function PICBunchDistances(obj, value)
            % Sets the distance between two successive Gaussian pulses for the Gaussian emission model.
            obj.AddToHistory(['.PICBunchDistances "', num2str(value, '%.15g'), '"']);
        end
        function DC = PICCurrent(obj, value)
            % Sets the emitted current of the particle source for the DC emission model.
            DC = obj.hParticleSource.invoke('PICCurrent', value);
        end
        function PICEnergyDC(obj, value, type)
            % Sets the kinetic emission type and its value for the DC emission model. Possible values for type are:
            % - Normed Momentum
            % - Energy (eV)
            % - Gamma
            % - Beta
            % - Velocity (m/s)
            % - Temperature (K)
            obj.AddToHistory(['.PICEnergyDC "', num2str(value, '%.15g'), '", '...
                                           '"', num2str(type, '%.15g'), '"']);
        end
        function PICRiseTimeDC(obj, value)
            % Sets the time-span of the rise function, until the steady state current is reached. This applies to the DC emission model.
            obj.AddToHistory(['.PICRiseTimeDC "', num2str(value, '%.15g'), '"']);
        end
        function PICOblique(obj, angleTheta, anglePhi)
            % Sets the angles theta and phi (in degrees) for the oblique emission feature in the DC emission model.
            obj.AddToHistory(['.PICOblique "', num2str(angleTheta, '%.15g'), '", '...
                                          '"', num2str(anglePhi, '%.15g'), '"']);
        end
        function PICEnergyFieldEmission(obj, value, type)
            % Sest the kinetic emission type and its value for the field emission model. Possible values for type are:
            % - Normed Momentum
            % - Energy (eV)
            % - Gamma
            % - Beta
            % - Velocity (m/s)
            % - Temperature (K)
            obj.AddToHistory(['.PICEnergyFieldEmission "', num2str(value, '%.15g'), '", '...
                                                      '"', num2str(type, '%.15g'), '"']);
        end
        function PICScaleFactorFieldEmission(obj, value)
            % Sets the linear parameter for the field emission model.
            obj.AddToHistory(['.PICScaleFactorFieldEmission "', num2str(value, '%.15g'), '"']);
        end
        function PICExpFactorFieldEmission(obj, value)
            % Sets the exponential parameter for the field emission model.
            obj.AddToHistory(['.PICExpFactorFieldEmission "', num2str(value, '%.15g'), '"']);
        end
        %% Queries
        function int = GetNumberOfParticleSources(obj)
            % Returns the number of all defined particle sources.
            int = obj.hParticleSource.invoke('GetNumberOfParticleSources');
        end
        function name = GetNameofParticleSource(obj, index)
            % Returns the name of the particle source with the specified index number.
            name = obj.hParticleSource.invoke('GetNameofParticleSource', index);
        end
        function double = GetCurrent(obj, name)
            % Returns the emitted current of the specified particle source. If the name is chosen to be "All sources" the current of all defined particle sources is returned.
            double = obj.hParticleSource.invoke('GetCurrent', name);
        end
        function double = GetPerveance(obj, name)
            % Returns the perveance of the specified particle source. If the name is chosen to be "All sources" the sum over all perveances of all defined particle sources is returned.
            double = obj.hParticleSource.invoke('GetPerveance', name);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hParticleSource
        history

        name
    end
end

%% Default Settings
% ParticleType('Userdefined');
% Charge(1.602177e-019)
% Mass(9.109390e-031)
% Density(0.8)
% PECSurface(TRUE)
% ScaleTriangularizationToMesh(TRUE)
% EmissionModel('Fixed');
% Energy(0, 'Energy');

%% Example - Taken from CST documentation and translated to MATLAB.
% To illustrate the use of the particle source VBA commands, the following VBA-script is provided. Prior to the particle source creation, a PEC cylinder is created inside a vacuum box. The particle source is defined on one of the faces of the PEC cylinder and the fixed emission model of the tracking solver is used. To test it, open a new CST PARTICLE STUDIO module in the CST STUDIO SUITE, create a new VBA macro, copy the script into it and run the macro.
% 
% % new component: component1
% Component.New('component1');
% 
% % define brick: component1:vacuum_box
% particlesource = project.ParticleSource();
%     particlesource.Reset
%     particlesource.Name('vacuum_box');
%     particlesource.Component('component1');
%     particlesource.Material('Vacuum');
%     particlesource.Xrange('-1', '1');
%     particlesource.Yrange('-1', '1');
%     particlesource.Zrange('-1', '1');
%     particlesource.Create
% 
% % define cylinder: component1:pec_cylinder
%     particlesource.Reset
%     particlesource.Name('pec_cylinder');
%     particlesource.Component('component1');
%     particlesource.Material('PEC');
%     particlesource.OuterRadius('0.5');
%     particlesource.InnerRadius('0.0');
%     particlesource.Axis('z');
%     particlesource.Zrange('-0.5', '0');
%     particlesource.Xcenter('0');
%     particlesource.Ycenter('0');
%     particlesource.Segments('0');
%     particlesource.Create
% 
% % pick face
% Pick.PickFaceFromId('component1:pec_cylinder', '3');
% 
% % define particle source: particle1
%     particlesource.Reset
%     particlesource.Name('particle1');
%     particlesource.ParticleType('electron');
%     particlesource.Charge('-1.602177e-019');
%     particlesource.Mass('9.109390e-031');
%     particlesource.SourceType('Circle');
%     particlesource.UsePickCircle('0');
%     particlesource.CircleCenterPoint('0', '0', '0');
%     particlesource.CircleNormal('0', '0', '1');
%     particlesource.CircleRadius('0.5');
%     particlesource.CircleRadiusInner('0.3');
%     particlesource.CircleRadiusLines('3');
%     particlesource.PECSurface('0');
%     particlesource.RadialFunction('Constant');
%     particlesource.TrkEmissionModel('Fixed');
%     particlesource.TrkKinetic('Energy', 'Uniform', '100', '0', '0', '300', '100');
%     particlesource.TrkFixed('1', '0');
%     particlesource.TrkOblique('0.0', '0.0');
%     particlesource.PICEmissionModel('Gauss');
%     particlesource.PICEnergy('0.0', 'Energy');
%     particlesource.PICBunchCharge('0.0');
%     particlesource.PICBunchDefinitionType('Time');
%     particlesource.PICBunchSigma('0.0');
%     particlesource.PICBunchCutoffLength('0.0');
%     particlesource.PICBunchOffset('0.0');
%     particlesource.PICNBunches('1');
%     particlesource.PICBunchDistances('0.0');
%     particlesource.PICAngleSpreadBunchEmission('0.0');
%     particlesource.PICKineticSpreadBunchEmission('0.0');
%     particlesource.Create
