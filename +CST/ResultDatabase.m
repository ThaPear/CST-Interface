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

% This object offers access to 0D results, which have been previously created by a simulation run or post-processing step.
classdef ResultDatabase < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.ResultDatabase object.
        function obj = ResultDatabase(project, hProject)
            obj.project = project;
            obj.hResultDatabase = hProject.invoke('ResultDatabase');
        end
    end
    %% CST Object functions.
    methods
        %% The keys values are constructed using the following solvernames as enums:
        % enum solvername     Description
        % "EStatic"           Electrostatic solver
        % "JStatic"           Stationary current solver
        % "MStatic"           Magnetostatic solver
        % "LFSolver"          Low frequency solver
        %
        %% The keys for the available entries, stored in the database are:
        % string key                                                  Description of return value                                                             Supported by
        % "AllSolvers\\Volume\\"+solidname                            Volume of the specified solid.                                                          All available solvers
        % solvername+"\\Solvertime"                                   Total calculation time.                                                                 EStatic
        % solvername+"\\Maxiter"                                      Maximal number of iterations of the iterative solver                                    EStatic
        % solvername+"\\NRuns"                                        Number of required solver runs                                                          EStatic  / LFSolver
        % solvername+"\\Energy"                                       Energy of the computed fields.                                                          EStatic  / MStatic / LFSolver
        % solvername+"\\"+solidname+"\\Energy"                        Energy of the computed fields in the specified solid.                                   EStatic  / MStatic / LFSolver (only for tetrahedral meshes)
        % solvername+"\\Co-Energy"                                    Co-energy of the field                                                                  MStatic
        % solvername+"\\"+solidname+"\\Co-Energy"                     Co-energy of the field in the specified solid                                           MStatic (only for tetrahedral meshes)
        % solvername+"\\"+iFreqIndex+"\\Mag. Energy"                  Magnetic field energy of the requested frequency                                        LFSolver
        % solvername+"\\"+iFreqIndex+"\\"+solidname+"\\Mag. Energy"   Magnetic field energy of the requested frequency in the specified solid                 LFSolver (only for tetrahedral meshes)
        % solvername+"\\"iFreqIndex+"\\El. Energy"                    Electric field energy of the requested frequency                                        LFSolver
        % solvername+"\\"iFreqIndex+"\\"+solidname+"\\El. Energy"     Electric field energy of the requested frequency in the specified solid                 LFSolver (only for tetrahedral meshes)
        % solvername+"\\Loss Power"                                   Ohmic losses of the field (only for stationary current solver)                          JStatic
        % solvername+"\\"+solidname+"\\Loss Power"                    Ohmic losses of the field (only for stationary current solver) in the specified solid   JStatic (only for tetrahedral meshes)
        % solvername+"\\"+inumber+"\\Accuracy"                        Reached accuracy of the inumber'th run of the equation solver.                          EStatic
        % solvername+"\\"+inumber+"\\NIterations"                     Used number of iterations of the inumber'th run of the equation solver.                 EStatic
        % solvername+"\\Force\\NormalX"
        % solvername+"\\Force\\NormalY"
        % solvername+"\\Force\\NormalZ"                               Returns the X/Y/Z component of the torque axes normal.                                  LFSolver / EStatic  / MStatic
        % solvername+"\\Force\\OriginX"
        % solvername+"\\Force\\OriginY"
        % solvername+"\\Force\\OriginZ"                               Returns the X/Y/Z coordinate of the torque axes origin.                                 LFSolver / EStatic  / MStatic
        % solvername+"\\Force\\"+solidname+"\\ForceX"
        % solvername+"\\Force\\"+solidname+"\\ForceY"
        % solvername+"\\Force\\"+solidname+"\\ForceZ"                 Returns the X/Y/Z component of the total force acting on the specified solid (for static calculations only)     EStatic  / MStatic
        % solvername+"\\Force\\"+solidname+"\\Torque"                 Returns the torque value related to the given axes on the specified solid. (for static calculations only)       EStatic  / MStatic
        % solvername+"\\"+coilname+"\\FluxLinkage"                    Returns the flux value of the named coil.                                               MStatic (only for tetrahedral meshes)
        % solvername+"\\Force\\"+solidname+"\\ForceXDC"
        % solvername+"\\Force\\"+solidname+"\\ForceYDC"
        % solvername+"\\Force\\"+solidname+"\\ForceZDC"               Returns the static part of the total force acting on the specified solid (for time-harmonic calculations).      LFSolver
        % solvername+"\\Force\\"+solidname+"\\ForceXAC_re"
        % solvername+"\\Force\\"+solidname+"\\ForceXAC_im"
        % solvername+"\\Force\\"+solidname+"\\ForceYAC_re"
        % solvername+"\\Force\\"+solidname+"\\ForceYAC_im"
        % solvername+"\\Force\\"+solidname+"\\ForceZAC_re"
        % solvername+"\\Force\\"+solidname+"\\ForceZAC_im"            Returns the X/Y/Z component of the real/complex total force acting on the solid.        LFSolver
        % solvername+"\\Force\\"+solidname+"\\TorqueDC"               Returns the static part of the torque value related to the given axes on the specified solid.                   LFSolver
        % solvername+"\\Force\\"+solidname+"\\TorqueAC_re"
        % solvername+"\\Force\\"+solidname+"\\TorqueAC_im"            Returns the real/complex part of the torque value related to the given axes on the specified solid.             LFSolver
        % solvername+"\\"+iFreqIndex+"\\"+SourceName+"\\Current\\Re"
        % solvername+"\\"+iFreqIndex+"\\"+SourceName+"\\Current\\Im"  Complex Part of the current for the specified voltage path.                             LFSolver (Voltage Path)
        % solvername+"\\"+iFreqIndex+"\\"+SourceName+"\\Impedance\\Re"
        % solvername+"\\"+iFreqIndex+"\\"+SourceName"\\Impedance\\Im" Real and imaginary parts of the impedance for the specified voltage path.               LFSolver (Voltage Path)
        % solvername+"\\"+iFreqIndex+SourceName+"\\CoilVRe"
        % solvername+"\\"+iFreqIndex+SourceName+"\\CoilVIm"           Real and imaginary parts of the coil's voltage.                                         LFSolver (Coil, Current Path)
        % solvername+"\\"+iFreqIndex+"\\Total Losses"                 Returns the total losses for the requested frequency                                    LFSolver
        % solvername+"\\"+iFreqIndex+"\\"+solidname+"\\Losses"        Returns the losses in the specified solid for the requested frequency                   LFSolver (only for tetrahedral meshes)
        % solvername+"\\"+iFreqIndex+"\\Frequency"                    Returns the calculation frequency assigned to iFreqIndex                                LFSolver
        % solvername+"\\"+iFreqIndex+SourceName+"\\CurrentPathVRe"
        % solvername+"\\"+iFreqIndex+SourceName+"\\CurrentPathVIm"    Real and imaginary parts of the voltage along the current path.                         LFSolver (Current Path)
        function double = GetDoubleEntry(obj, key)
            % Returns the double value of a result database entry specified by it's key value.
            double = obj.hResultDatabase.invoke('GetDoubleEntry', key);
        end
        function int = GetIntegerEntry(obj, key)
            % Returns the integer value of a result database entry specified by it's key value.
            int = obj.hResultDatabase.invoke('GetIntegerEntry', key);
        end
        function str = GetStringEntry(obj, key)
            % Returns the string value of a result database entry specified by it's key value.
            str = obj.hResultDatabase.invoke('GetStringEntry', key);
        end
        function int = GetNumberOfDoubleEntries(obj)
            % Returns the total number of double entries in the result database.
            int = obj.hResultDatabase.invoke('GetNumberOfDoubleEntries');
        end
        function str = GetDoubleKeyFromIndex(obj, index)
            % Returns the key-string  of a double result entry specified by it's integer index. The index value must be greater or equal zero and smaller than the total number of double result entries (can  be obtained by GetNumberOfDoubleEntries).
            str = obj.hResultDatabase.invoke('GetDoubleKeyFromIndex', index);
        end
        function int = GetNumberOfDoubleEntriesForDir(obj, dirname)
            % Returns the total number of double entries within a subfolder in the result database.
            int = obj.hResultDatabase.invoke('GetNumberOfDoubleEntriesForDir', dirname);
        end
        function double = GetDoubleEntryForDir(obj, subkey, dirname)
            % Returns the double value of a result database entry specified by it's directory name and the remaining subkey value. When combined, directory name and subkey form the reference key together.
            double = obj.hResultDatabase.invoke('GetDoubleEntryForDir', subkey, dirname);
        end
        function str = GetDoubleKeyFromIndexForDir(obj, index, dirname)
            % Returns the subkey-string  of a double result entry specified by it's integer index. The index value must be greater or equal zero and smaller than the total number of double result entries (can  be obtained by GetNumberOfDoubleEntriesForDir).
            str = obj.hResultDatabase.invoke('GetDoubleKeyFromIndexForDir', index, dirname);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hResultDatabase

    end
end

%% Default Settings

%% Example - Taken from CST documentation and translated to MATLAB.
% resultdatabase = project.ResultDatabase();
%     v = resultdatabase.GetDoubleEntry('EStatic\Energy');
%     v = resultdatabase.GetIntegerEntry('MStatic\Maxiter');
%     v = resultdatabase.GetDoubleEntry('LFSolver\1\Frequency'); %returns the frequency of the second defined frequency point
%     v = resultdatabase.GetDoubleEntry('LFSolver\1\Total Losses');  %returns the electromagnetic field losses of the second defined frequency point
%     v = resultdatabase.GetDoubleEntry('LFSolver\0\Frequency');
%     v = ResultDatabase.GetDoubleEntry('LFSolver\0\coil1\CoilVRe');
%
