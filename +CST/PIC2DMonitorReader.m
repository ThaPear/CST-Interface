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

% The Particle Reader objects allow for convenient access to particle monitor data created by the different Particle Studio solvers. They support a set of common methods which are available for all Particle Reader objects. In addition, each object offers some functions which only apply to their specific particle monitor type.
% In order to allow for fast access to the particle data (which can be huge for some monitors), the philosophy of these reader objects is to prevent access to individual particles but to deliver complete arrays with the requested data for all particles at once.
% Internally, the particle data is organized in one or more (time-)frames which consist of one or more samples. The actual number of frames and samples depends on the specific monitor type and settings and can be queried with appropriate functions. When loading monitor data to memory, the objects always process one frame at a time but load all samples at once. However, when requesting data, only the particle data for the currently selected sample (inside the currently loaded frame) is returned.
classdef PIC2DMonitorReader < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.PIC2DMonitorReader object.
        function obj = PIC2DMonitorReader(project, hProject)
            obj.project = project;
            obj.hPIC2DMonitorReader = hProject.invoke('PIC2DMonitorReader');
        end
    end
    %% CST Object functions.
    methods
        %% Common Methods
        % The following methods are available for all Particle Reader objects.
        function Reset(obj)
            % Resets all internal values to their default settings, frees all internally allocated memory. It is recommend to call this command before using the object to ensure proper initialization and after using the object to avoid wasting memory for data which is not needed any more.
            obj.hPIC2DMonitorReader.invoke('Reset');
        end
        function SelectDataSource(obj, tree_path)
            % Selects a data source based on its path in the result tree.
            % Please do not call this method directly. Use the specialized object methods below instead.
            obj.hPIC2DMonitorReader.invoke('SelectDataSource', tree_path);
        end
        function long = GetNFrames(obj)
            % Returns the number of trajectories available.
            long = obj.hPIC2DMonitorReader.invoke('GetNFrames');
        end
        function [tmin, tmax, tstep] = GetFrameInfo(obj, number)
            % Retrieves information about the frame identified by number without loading the particle data. The parameter number can range from 0 to GetNFrames-1. The returned values are the frame minimum and maximum physical time (tmin and tmax) and the frame time step (tstep).
            functionString = [...
                'Dim tmin As Single, tmax As Single, tstep As Single', newline, ...
                'PIC2DMonitorReader.GetFrameInfo(', num2str(number, '%.15g'), ', tmin, tmax, tstep)', newline, ...
            ];
            returnvalues = {'tmin', 'tmax', 'tstep'};
            [tmin, tmax, tstep] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            tmin = str2double(tmin);
            tmax = str2double(tmax);
            tstep = str2double(tstep);
        end
        function SelectFrame(obj, number)
            % Selects a frame as the source for subsequent data request methods such as GetQuantityValues. This call loads the data for all particle inside the frame into memory. The parameter number can range from 0 to GetNFrames-1.
            obj.hPIC2DMonitorReader.invoke('SelectFrame', number);
        end
        function long = GetNSamples(obj)
            % Returns the number of samples available in the current frame.
            % Please do not call this method directly. Use the specialized object methods below instead.
            long = obj.hPIC2DMonitorReader.invoke('GetNSamples');
        end
        function SelectSample(obj, number)
            % Selects a specific sample from the current frame as the source for subsequent data request methods such as GetQuantityValues. The parameter number can range from 0 to GetNSamples-1.
            % Please do not call this method directly. Use the specialized object methods below instead.
            obj.hPIC2DMonitorReader.invoke('SelectSample', number);
        end
        function long = GetNParticles(obj)
            % Returns the number of particles inside the selected sample of the currently loaded frame.
            long = obj.hPIC2DMonitorReader.invoke('GetNParticles');
        end
        function LongArray = GetSourceIDs(obj)
            % Returns an array with all particle source IDs contained in the result data.
            LongArray = obj.hPIC2DMonitorReader.invoke('GetSourceIDs');
        end
        function String = GetSourceName(obj, id)
            % Returns the name of the particle source with the given id. The parameter id must be one of the entries of the array retrieved by the GetSourceIDs method. This information can be used to map particle source IDs retrieved via GetQuantityValues to their respective source name.
            String = obj.hPIC2DMonitorReader.invoke('GetSourceName', id);
        end
        function StringArray = GetQuantityNames(obj)
            % Returns an array with all physical quantities that can be retrieved from the monitor data.
            StringArray = obj.hPIC2DMonitorReader.invoke('GetQuantityNames');
        end
        function long = GetNComponents(obj, quantity)
            % Returns the number of components of the given quantity. The return value is either 3 for vectorial or 1 for scalar quantities. The parameter quantity must be one of the entries of the array retrieved by the GetQuantityNames method.
            long = obj.hPIC2DMonitorReader.invoke('GetNComponents', quantity);
        end
        function SingleArray = GetQuantityValues(obj, quantity, component)
            % Returns an array with the quantity.component values for all particles in the selected sample of the current frame. The array length always corresponds to the result of a call to GetNParticles.
            % The parameter quantity must be one of the entries of the array retrieved by the GetQuantityNames method.
            % The following quantities are available for all monitors:
            % "Position"                  Particle position                   Vectorial
            %                             <function>
            % "Momentum"                  Normed Momentum of the particle     Vectorial
            %                             <function>
            % "ChargeMacro"               Particle macro charge               Scalar
            %                             <function>
            % "Mass"                      Particle (non-macro) mass           Scalar
            %                             <function>
            % "Gamma"                     Lorentz factor                      Scalar
            %                             <function>
            % "Beta"                      Normed particle velocity            Vectorial
            %                             <function>
            % "Velocity"                  Particle velocity                   Vectorial
            %                             <function>
            % "Energy"                    Particle kinetic energy in eV       Scalar
            %                             <function>
            % "Orbital Angle", "Angle"    Orbital angle                       Vectorial
            %                             <function>
            %
            % The different monitors provide several additional quantities. Therefore, it is advisable to always use GetQuantityNames to query the monitor's capabilities.
            % The parameter component can be one of
            % "-1"    ""              "-"             Queries a scalar value such as mass, current, etc.                              Has to be used for scalar quantities, see GetNComponents for more details.
            % "0"     "X"             "X-DIRECTION"   Returns the x-component of a vectorial quantity.                                Only apply to vectorial quantities, see GetNComponents for more details.
            % "1"     "Y"             "Y-DIRECTION"   Returns the y-component of a vectorial quantity.                                ^
            % "2"     "Z"             "Z-DIRECTION"   Returns the z-component of a vectorial quantity.                                ^
            % "3"     "ABS (XYZ)"     "ABSOLUTE"      Returns the norm of a vectorial quantity, i.e.                                  ^
            %                                         <function>
            % "4"     "U"             "U-DIRECTION"   Returns the projection of a vectorial quantity onto a plane's u-direction.      Only apply to vectorial quantities, see GetNComponents for more details, and planar monitors, such as the Particle2DMonitorReader object.
            % "5"     "V"             "V-DIRECTION"   Returns the projection of a vectorial quantity onto a plane's v-direction.      ^
            % "6"     "NORMAL"        "W-DIRECTION"   Returns the projection of a vectorial quantity onto a plane's normal-direction. ^
            % "7"     "ABS (UV)"      "NORM(UV)"      Returns the norm of the in-plane components of a vectorial quantity, i.e.       ^
            %                                         <function>
            %
            % All entries in an individual row of the table above are equivalent. The parameters quantity and component are case-insensitive to allow for more convenient VBA-UI development.
            % Subsequent calls to GetQuantityValues for different quantities retain the particle's order. Thus it is guaranteed, that for example after calling
            %     lstPosX = GetQuantityValues("Position", "x")
            %     lstPosY = GetQuantityValues("Position", "y")
            %     lstPosZ = GetQuantityValues("Position", "z")
            %     lstCurrent = GetQuantityValues("Current", "")
            % the entries
            %     lstPosX(0), lstPosY(0), lstPosZ(0), lstCurrent(0)
            % contain the position and current of the very first particle in the selected sample.
            SingleArray = obj.hPIC2DMonitorReader.invoke('GetQuantityValues', quantity, component);
        end
        function Single = GetQuantityWithReduction(obj, quantity, component, reduction)
            % In addition to retrieving the full list of quantities for all particles, it is possible to perform some immediate reductions on the data set.
            % For information on the parameters quantity and component, please refer to GetQuantityValues.
            % The parameter reduction can be any of (case-insensitive)
            % "min"                       Minimum value of quantity.component across all particles in the selected sample
            %                             <function>
            % "max"                       Maximum value of quantity.component across all particles in the selected sample
            %                             <function>
            % "mean"                      Mean value of quantity.component across all particles in the selected sample
            %                             <function>
            % "total"                     Total sum of quantity.component across all particles in the selected sample
            %                             <function>
            % "deviation", "sigma"        Standard deviation of quantity.component across all particles in the selected sample
            %                             <function>
            % "rms"                       RMS value of quantity.component across all particles in the selected sample
            %                             <function>
            % "norm"                      Norm of the quantity.component vector across all particles in the selected sample
            %                             <function>
            Single = obj.hPIC2DMonitorReader.invoke('GetQuantityWithReduction', quantity, component, reduction);
        end
        function GetGlobalQuantityNames(obj)
            % Returns an array of quantities that can be computed from the available particle data. These quantities are mainly beam quality parameters. Their computation is usually more involved than the reductions available via GetQuantityWithReduction.
            obj.hPIC2DMonitorReader.invoke('GetGlobalQuantityNames');
        end
        function Single = GetGlobalQuantity(obj, quantity, component)
            % Computes and returns the requested global quantity. The parameter quantity must be one of the entries of the array retrieved by the GetGlobalQuantityNames method. For the possible values of the parameter component, refer to GetQuantityValues.
            % Currently, the following global quantities are supported:
            % "Emittance"         Computes the RMS emittance                                  Usually, the components "U" and "V" will be of interest.
            %                     <function>
            % "Envelope"          Computes the beam envelope, i.e. the maximum absolute       The distance can be computed component-wise ("X", "Y", "Z", "U", "V"), circular ("ABS (UV)") or spherical ("ABS (XYZ)").
            %                     distance of all particles from their average position
            %                     <function>
            % "Velocity Spread"   Computes the velocity spread                                Scalar quantity, component must be "".
            %                     <function>
            % "Divergence Angle"  Computes the beam divergence angle                          Scalar quantity, component must be "".
            %                     <function>
            % "Brightness"        Computes the beam brightness                                Scalar quantity, component must be "".
            %                     <function>
            Single = obj.hPIC2DMonitorReader.invoke('GetGlobalQuantity', quantity, component);
        end
        % To simplify access to often-used data, the following convenience methods are available. They are mostly shorthand notations that can also be achieved using an appropriate GetQuantityValues or GetGlobalQuantity call.
        function SingleArray = GetPositionsX(obj)
            % Retrieve the x-, y-, and z-component of all particle positions.
            SingleArray = obj.hPIC2DMonitorReader.invoke('GetPositionsX');
        end
        function SingleArray = GetPositionsY(obj)
            % Retrieve the x-, y-, and z-component of all particle positions.
            SingleArray = obj.hPIC2DMonitorReader.invoke('GetPositionsY');
        end
        function SingleArray = GetPositionsZ(obj)
            % Retrieve the x-, y-, and z-component of all particle positions.
            SingleArray = obj.hPIC2DMonitorReader.invoke('GetPositionsZ');
        end
        function SingleArray = GetMomentaX(obj)
            % Retrieve the x-, y-, and z-component of all particle momenta.
            SingleArray = obj.hPIC2DMonitorReader.invoke('GetMomentaX');
        end
        function SingleArray = GetMomentaY(obj)
            % Retrieve the x-, y-, and z-component of all particle momenta.
            SingleArray = obj.hPIC2DMonitorReader.invoke('GetMomentaY');
        end
        function SingleArray = GetMomentaZ(obj)
            % Retrieve the x-, y-, and z-component of all particle momenta.
            SingleArray = obj.hPIC2DMonitorReader.invoke('GetMomentaZ');
        end
        function SingleArray = GetMacroCharges(obj)
            % Retrieve the macro charges of all particles.
            SingleArray = obj.hPIC2DMonitorReader.invoke('GetMacroCharges');
        end
        function SingleArray = GetParticleIDs(obj)
            % Retrieve the unique IDs of all particles (not available for all monitor types).
            SingleArray = obj.hPIC2DMonitorReader.invoke('GetParticleIDs');
        end
        function SingleArray = GetTimes(obj)
            % Retrieve the collision time of all particles with the monitor (not available for all monitor types).
            SingleArray = obj.hPIC2DMonitorReader.invoke('GetTimes');
        end
        function SingleArray = GetCurrents(obj)
            % Retrieve all particle currents (not available for all monitor types).
            SingleArray = obj.hPIC2DMonitorReader.invoke('GetCurrents');
        end
        function SingleArray = GetMasses(obj)
            % Retrieve all particle masses.
            SingleArray = obj.hPIC2DMonitorReader.invoke('GetMasses');
        end
        function Single = GetEmittance(obj, component)
            % Returns the emittance, see GetGlobalQuantity for details.
            Single = obj.hPIC2DMonitorReader.invoke('GetEmittance', component);
        end
        function Single = GetEnvelope(obj, component)
            % Returns the envelope, see GetGlobalQuantity for details.
            Single = obj.hPIC2DMonitorReader.invoke('GetEnvelope', component);
        end
        function Single = GetVelocitySpread(obj)
            % Returns the beam velocity spread, see GetGlobalQuantity for details.
            Single = obj.hPIC2DMonitorReader.invoke('GetVelocitySpread');
        end
        function Single = GetDivergenceAngle(obj)
            % Returns the beam divergence angle, see GetGlobalQuantity for details.
            Single = obj.hPIC2DMonitorReader.invoke('GetDivergenceAngle');
        end
        function Single = GetBrightness(obj)
            % Returns the beam brightness, see GetGlobalQuantity for details.
            Single = obj.hPIC2DMonitorReader.invoke('GetBrightness');
        end
        %% Particle2DMonitorReader and PIC2DMonitorReader Object
        % Particle2DMonitorReader data only consists of a single frame which is automatically selected. The monitor's planes are represented by the individual samples in the dataset.
        % PIC2DMonitorReader data only consists of a single plane which is automatically selected. However, multiple frames are available.
        % In addition to the common methods, the following methods are available:
        function StringArray = GetMonitorNames(obj)
            % Returns an array with all Particle 2D Monitors that contain result data.
            StringArray = obj.hPIC2DMonitorReader.invoke('GetMonitorNames');
        end
        function SelectMonitor(obj, name)
            % Selects a specific monitor as source for subsequent data request methods such as GetQuantityValues. The parameter name must be one of the entries of the array retrieved by the GetMonitorNames method. This call automatically loads the monitor data to memory and automatically selects the first plane.
            obj.hPIC2DMonitorReader.invoke('SelectMonitor', name);
        end
        function long = GetNPlanes(obj)
            % Returns the number of monitor planes available.
            long = obj.hPIC2DMonitorReader.invoke('GetNPlanes');
        end
        function SelectPlane(obj, number)
            % Selects a specific monitor plane as the source for subsequent data request methods such as GetQuantityValues. The parameter number can range from 0 to GetNPlanes-1.
            obj.hPIC2DMonitorReader.invoke('SelectPlane', number);
        end
        function [xNorm, yNorm, zNorm] = GetNormal(obj)
            % Returns the normal of the selected monitor plane.
            functionString = [...
                'Dim xNorm As Double, yNorm As Double, zNorm As Double', newline, ...
                'PIC2DMonitorReader.GetNormal(xNorm, yNorm, zNorm)', newline, ...
            ];
            returnvalues = {'xNorm', 'yNorm', 'zNorm'};
            [xNorm, yNorm, zNorm] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            xNorm = str2double(xNorm);
            yNorm = str2double(yNorm);
            zNorm = str2double(zNorm);
        end
        function [xNorm, yNorm, zNorm] = GetLocalU(obj)
            % Returns the local (in-plane) coordinate system of the selected plane.
            functionString = [...
                'Dim xNorm As Double, yNorm As Double, zNorm As Double', newline, ...
                'PIC2DMonitorReader.GetLocalU(xNorm, yNorm, zNorm)', newline, ...
            ];
            returnvalues = {'xNorm', 'yNorm', 'zNorm'};
            [xNorm, yNorm, zNorm] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            xNorm = str2double(xNorm);
            yNorm = str2double(yNorm);
            zNorm = str2double(zNorm);
        end
        function [xNorm, yNorm, zNorm] = GetLocalV(obj)
            % Returns the local (in-plane) coordinate system of the selected plane.
            functionString = [...
                'Dim xNorm As Double, yNorm As Double, zNorm As Double', newline, ...
                'PIC2DMonitorReader.GetLocalV(xNorm, yNorm, zNorm)', newline, ...
            ];
            returnvalues = {'xNorm', 'yNorm', 'zNorm'};
            [xNorm, yNorm, zNorm] = obj.project.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            xNorm = str2double(xNorm);
            yNorm = str2double(yNorm);
            zNorm = str2double(zNorm);
        end
        function double = GetPlaneDistance(obj)
            % Returns the distance of the selected plane from the origin.
            double = obj.hPIC2DMonitorReader.invoke('GetPlaneDistance');
        end
        function RemoveOutliers(obj, current_percent)
            % This methods removes outlier particles from the currently selected plane. The parameter current_percent can be any value between 0 and 100. It specifies the percentage of the total current through the plane to be kept. The method first sorts all particles on the plane by their distance to the average position. Then, starting from the most central particles, it runs outwards and accumulates the particle current. As soon as the current reaches the given percentage of the total current, the method terminates and removes all remaining particles. After calling this method, GetNParticles will return the appropriately reduced number of particles and the arrays returned by GetQuantityValues are shorter.
            % Note, that while the original result data files are not modified by this method, the in-memory representation is. Thus, the only way to undo this operation is to reload the monitor from disk again using SelectMonitor and SelectPlane.
            obj.hPIC2DMonitorReader.invoke('RemoveOutliers', current_percent);
        end
        %% CST 2019 Functions.
        function SelectSource(obj, id)
            % Filters the data for subsequent calls to only yield particles that were emitted from the source id. The parameter id must be one of the entries of the array retrieved by the GetSourceIDs method.
            % Calls to SelectDataSource, LoadTrajectoryData, SelectMonitor, SelectSample, SelectFrame, SelectPlane, SelectTrajectory, Reset, etc. will remove the filter and lead to yielding particle data for all sources again.
            obj.hPIC2DMonitorReader.invoke('SelectSource', id);
        end
        function LongArray = GetEmissionIDs(obj)
            % Retrieve the unique IDs of all particle sources and interfaces.
            LongArray = obj.hPIC2DMonitorReader.invoke('GetEmissionIDs');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPIC2DMonitorReader

    end
end

%% Default Settings

%% Example - Taken from CST documentation and translated to MATLAB.
% % Get some result data from the PIC position monitor and prints it into one text file per frame
% % Attention: this can produce a huge amount of data
% Sub Main
% Dim lstMonitors() As String
% lstMonitors = PICPositionMonitorReader.GetMonitorNames()
% % for simplicity, we just select the very first monitor found
% Dim sMonitorName As String
% sMonitorName = lstMonitors(0)
% PICPositionMonitorReader.SelectMonitor(sMonitorName)
%
% Dim iFrame As Long
% For iFrame=0 To PICPositionMonitorReader.GetNFrames()-1
% Dim sFileName As String
% sFileName = sMonitorName +(' - Frame'); + Format(iFrame, '000'); +('.txt');
%
% Open sFileName For Output As #1
% PICPositionMonitorReader.SelectFrame(iFrame)
%
% Dim lstPosX() As Single, lstPosY() As Single, lstMomentum() As Single
% lstPosX = PICPositionMonitorReader.GetQuantityValues('Position', 'X');
% lstPosY = PICPositionMonitorReader.GetQuantityValues('Position', 'Y');
% lstMomentum = PICPositionMonitorReader.GetQuantityValues('Momentum', 'ABS(XYZ)');
%
% Dim iParticle As Long
% For iParticle = 0 To PICPositionMonitorReader.GetNParticles()-1
% Print #1, iParticle;('('; lstPosX(iParticle);('('; lstPosY(iParticle);('('; lstMomentum(iParticle);('('
% Next
%
% Close #1
% Next
% End Sub
%
