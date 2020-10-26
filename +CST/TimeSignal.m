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

% Methods
classdef TimeSignal < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.TimeSignal object.
        function obj = TimeSignal(project, hProject)
            obj.project = project;
            obj.hTimeSignal = hProject.invoke('TimeSignal');
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
        end
        function Name(obj, signalName)
            % Sets the name of the time signal.
            obj.AddToHistory(['.Name "', num2str(signalName, '%.15g'), '"']);
        end
        function Id(obj, id)
            % Sets a unique identifier for the imported ASCII signal data. Therefore signals pointing to the same imported data (e.g. created via transform and copy) share the same id. Please use GetNextId to retrieve a free id.
            obj.AddToHistory(['.Id "', num2str(id, '%.15g'), '"']);
        end
        function Rename(obj, oldName, newName, problemType)
            % Renames the time signal named oldName to newName. The third parameter characterizes the problem type to which the signal belongs. Admissible values for problemType are "High Frequency" or "Low Frequency".
            obj.project.AddToHistory(['TimeSignal.Rename "', num2str(oldName, '%.15g'), '", '...
                                                        '"', num2str(newName, '%.15g'), '", '...
                                                        '"', num2str(problemType, '%.15g'), '"']);
        end
        function Delete(obj, signalName, problemType)
            % Deletes an existing time signal named signalName. The second parameter characterizes the problem type to which the signal belongs. Admissible values for problemType are "High Frequency" or "Low Frequency".
            obj.project.AddToHistory(['TimeSignal.Delete "', num2str(signalName, '%.15g'), '", '...
                                                        '"', num2str(problemType, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the time signal with the previously applied settings.
            obj.AddToHistory(['.Create']);

            % Prepend With TimeSignal and append End With
            obj.history = [ 'With TimeSignal', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define TimeSignal'], obj.history);
            obj.history = [];
        end
        function FileName(obj, name)
            % name specifies the ASCII signal file and path.
            obj.AddToHistory(['.FileName "', num2str(name, '%.15g'), '"']);
        end
        function UseCopyOnly(obj, flag)
            % The ASCII signal file is copied once into the project folder. Hence changes of the originally imported file do not affect the defined signal.
            obj.AddToHistory(['.UseCopyOnly "', num2str(flag, '%.15g'), '"']);
        end
        function Fmin(obj, fmin)
            % Sets the frequency range for a Gaussian excitation function. To ensure accurate results the signal's frequency range has to fit inside the project's frequency range.
            obj.AddToHistory(['.Fmin "', num2str(fmin, '%.15g'), '"']);
        end
        function Fmax(obj, fmax)
            % Sets the frequency range for a Gaussian excitation function. To ensure accurate results the signal's frequency range has to fit inside the project's frequency range.
            obj.AddToHistory(['.Fmax "', num2str(fmax, '%.15g'), '"']);
        end
        function Ttotal(obj, ttotal)
            % Sets the total duration of the time signal.
            % This setting is used for the "Rectangular", "Smooth step", "Sine step" and "User" defined signal and ignored for "Gaussian" impulses and for "Import" signal types.
            obj.AddToHistory(['.Ttotal "', num2str(ttotal, '%.15g'), '"']);
        end
        function Trise(obj, trise)
            % Sets the duration in which the time signal rises to its maximum. This setting is used only for the "Rectangular" signal type.
            obj.AddToHistory(['.Trise "', num2str(trise, '%.15g'), '"']);
        end
        function Thold(obj, thold)
            % Sets the duration in which the time signal holds its maximum value. This setting is used only for the "Rectangular" signal type.
            obj.AddToHistory(['.Thold "', num2str(thold, '%.15g'), '"']);
        end
        function Tfall(obj, tfall)
            % Sets the duration in which the time signal falls from its maximum value to zero. This setting is used only for the "Rectangular" signal type.
            obj.AddToHistory(['.Tfall "', num2str(tfall, '%.15g'), '"']);
        end
        function Voffset(obj, voffset)
            % Sets the vertical offset of the time signal. This setting is used only for the sine function (signal type "Sine").
            obj.AddToHistory(['.Voffset "', num2str(voffset, '%.15g'), '"']);
        end
        function AmplitudeRisePercent(obj, amplituderisepercent)
            % Sets the amplitude rise (in per cent notation) of the time signal, which completely defines the slope and grow rate of the signal together with the Trise parameter. This setting is used only for the smooth step function (signal type "Smooth step").
            obj.AddToHistory(['.AmplitudeRisePercent "', num2str(amplituderisepercent, '%.15g'), '"']);
        end
        function RiseFactor(obj, risefactor)
            % Sets the duration in which the time signal rises to its maximum. This setting is used only for the "Smooth step" and "Sine step" signal type.
            obj.AddToHistory(['.RiseFactor "', num2str(risefactor, '%.15g'), '"']);
        end
        function ChirpRate(obj, chirp_rate)
            % Sets the rate of frequency increase (or decrease, if negative) to define a linearly varying instantaneous frequency. The chirp rate is therefore expressed in frequency unit / time unit. This setting is used only for the "Sine step" signal type.
            obj.AddToHistory(['.ChirpRate "', num2str(chirp_rate, '%.15g'), '"']);
        end
        function Frequency(obj, frq)
            % Sets the frequency of the sine function (depending on the predefined frequency unit). This setting is used only for signal type "Sine", "Sine step".
            obj.AddToHistory(['.Frequency "', num2str(frq, '%.15g'), '"']);
        end
        function Phase(obj, phase)
            % Sets the phase of the sine step function.
            obj.AddToHistory(['.Phase "', num2str(phase, '%.15g'), '"']);
        end
        function Amplitude(obj, amplitude)
            % Sets the amplitude of the double exponential function.
            obj.AddToHistory(['.Amplitude "', num2str(amplitude, '%.15g'), '"']);
        end
        function StartAmplitude(obj, astart)
            % Sets the start and end amplitude of the exponential step function. This type is available only for low frequency simulations.
            obj.AddToHistory(['.StartAmplitude "', num2str(astart, '%.15g'), '"']);
        end
        function EndAmplitude(obj, aend)
            % Sets the start and end amplitude of the exponential step function. This type is available only for low frequency simulations.
            obj.AddToHistory(['.EndAmplitude "', num2str(aend, '%.15g'), '"']);
        end
        function SignalType(obj, sType)
            % Sets the type of the signal.
            % sType can have one of the following values:
            % "Gaussian" - Gaussian excitation function within the given frequency range: Please note that for proper broadband S-Parameter calculations the Gaussian pulse should always be used. To ensure accurate results the signal's frequency range has to fit inside the project's frequency range. Relevant only for high frequency calculations.
            % "Rectangular" - Rectangular excitation function: Please note that for proper broadband S-Parameter calculations the Gaussian pulse should always be used. To ensure accurate results the signal's timing settings has to fit inside the project's frequency range.
            % "Sine step" - Sine function with smoothed transition phase from 0 to maximum amplitude value. A signal in which the instantaneous frequency linearly varies with time (linear chirp) is also possible specifying the chirp rate (CR), i.e. the rate of frequency increase (or decrease, if negative).
            % "Sine" - Sine function.
            % "Smooth step" - Smoothed step (with controlled slope) excitation function: Please note that for proper broadband S-Parameter calculations the Gaussian pulse should always be used. To ensure accurate results the signal's timing settings has to fit inside the project's frequency range.
            % "Constant" - Constant excitation function: This signal type yields the same constant value at each time point.
            % "Double exponential" - Enables you to define a double exponential excitation using the following expression.
            %                        f (t) = A (exp (-t / B) - exp (-t / C))
            % "Impulse" - Enables you to define an impulse excitation.
            %             A highest required output frequency (Fmax) should be specified to define the shape of this signal.
            %             This signal is centred about zero. It starts at t = -6.25 / Fmax and ends at 6.25 / Fmax. Outside this range, the signal is zero.
            % "User" - User defined excitation function: A user defined function can be created by writing a VBA-function with the name ExcitationFunction inside a file named Projectname\Model\3D\signal_name.usf for an arbitrary signal name or Projectname\Model\3D\Model.usf for the reference signal name. Please note that for proper broadband S-Parameter calculations the Gaussian pulse should always be used. To ensure accurate results the signal's timing settings has to fit inside the project's frequency range.
            % "Import" - Import of an ASCII table: The ASCII file containing a table of time and signal values has to be stored in a file named Projectname\Model\3D\signal_name.isf.
            obj.AddToHistory(['.SignalType "', num2str(sType, '%.15g'), '"']);
        end
        function MinUserSignalSamples(obj, minsamples)
            % Sets the minimum number of samples to be generated for the user defined excitation function. This number should be a positive one and smaller (for algorithmic reason) than 30000.
            obj.AddToHistory(['.MinUserSignalSamples "', num2str(minsamples, '%.15g'), '"']);
        end
        function Periodic(obj, bPeriodic)
            % Relevant only for imported ASCII tables. Set bPeriodic to True to apply the imported ASCII table periodically.
            obj.AddToHistory(['.Periodic "', num2str(bPeriodic, '%.15g'), '"']);
        end
        function ProblemType(obj, sType)
            % Specifies the application where the signal belongs to.
            % sType can have the value "High Frequency" or "Low Frequency".
            obj.AddToHistory(['.ProblemType "', num2str(sType, '%.15g'), '"']);
        end
        function ExcitationSignalAsReference(obj, signalName, problemType)
            % Selects the given excitation signal signalName als default / reference signal for all following simulations. The second parameter characterizes the problem type to which the signal belongs. Admissible values for problemType are "High Frequency" or "Low Frequency".
            obj.AddToHistory(['.ExcitationSignalAsReference "', num2str(signalName, '%.15g'), '", '...
                                                           '"', num2str(problemType, '%.15g'), '"']);
        end
        function ExcitationSignalResample(obj, signalName, tmin, tmax, tstep, problemType)
            % Generates a signal file Projectname\Results\signalName.sig within the adressed time intervall sampled with the given timestep tstep. The last parameter characterizes the problem type to which the signal belongs. Admissible values for problemType are "High Frequency" or "Low Frequency".
            obj.AddToHistory(['.ExcitationSignalResample "', num2str(signalName, '%.15g'), '", '...
                                                        '"', num2str(tmin, '%.15g'), '", '...
                                                        '"', num2str(tmax, '%.15g'), '", '...
                                                        '"', num2str(tstep, '%.15g'), '", '...
                                                        '"', num2str(problemType, '%.15g'), '"']);
        end
        function integer = GetNextId(obj)
            % Returns the next free unique ID to for a new signal source.
            integer = obj.hTimeSignal.invoke('GetNextId');
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hTimeSignal
        history

    end
end

%% Default Settings
% Ttotal(0.0)
% Trise(0.0)
% Thold(0.0)
% Tfall(0.0)
% Fmin(0.0)
% Fmax(0.0)
% Voffset(0.0)
% AmplitudeRisePercent(0.0)
% ChirpRate(0.0)
% RiseFactor(0.0)
% Frequency(5.0)

%% Example - Taken from CST documentation and translated to MATLAB.
% % creates a Gaussian excitation function
% timesignal = project.TimeSignal();
%     timesignal.Reset
%     timesignal.Name('GaussianSignal');
%     timesignal.SignalType('Gaussian');
%     timesignal.ProblemType('High Frequency');
%     timesignal.Fmin('0.0');
%     timesignal.Fmax('1000.0');
%     timesignal.Create
%
% % creates a(rectangular) step function
%     timesignal.Reset
%     timesignal.Name('signal1');
%     timesignal.SignalType('Rectangular');
%     timesignal.ProblemType('High Frequency');
%     timesignal.Ttotal('2.0');
%     timesignal.Trise('0.0');
%     timesignal.Thold('1.0');
%     timesignal.Tfall('0.0');
%     timesignal.Create
%
% % creates a sine function with frequency f=3.0 and vertical offset v=1.0
%     timesignal.Reset
%     timesignal.Name('sine_signal');
%     timesignal.SignalType('Sine');
%     timesignal.ProblemType('Low Frequency');
%     timesignal.Ttotal('10.0');
%     timesignal.Voffset('1.0');
%     timesignal.Frequency('3.0');
%     timesignal.Create
%
% % creates a sine step function with frequency f=3.0
%     timesignal.Reset
%     timesignal.Name('mysignal');
%     timesignal.SignalType('Sine step');
%     timesignal.ProblemType('High Frequency');
%     timesignal.Ttotal('10.0');
%     timesignal.Phase('90');
%     timesignal.Frequency('3.0');
%     timesignal.RiseFactor('5');
%     timesignal.Create
%
% % creates a smoothed step function with 80% rise amplitude
%     timesignal.Reset
%     timesignal.Name('mysignal');
%     timesignal.SignalType('Smooth step');
%     timesignal.ProblemType('High Frequency');
%     timesignal.Ttotal('10.0');
%     timesignal.AmplitudeRisePercent('80.0');
%     timesignal.RiseFactor('2');
%     timesignal.Create
%
% % creates a user-defined excitation function
%     timesignal.Reset
%     timesignal.Name('mysignal');
%     timesignal.SignalType('User');
%     timesignal.ProblemType('Low Frequency');
%     timesignal.Ttotal('2.0');
%     timesignal.Create
%
% % creates an imported excitation function
%     timesignal.Reset
%     timesignal.Name('imported_signal');
%     timesignal.SignalType('Import');
%     timesignal.ProblemType('High Frequency');
%     timesignal.Create
%
