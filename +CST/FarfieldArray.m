%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Warning: Untested                                                   %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Defines the antenna array pattern for a farfieldplot based on a single antenna element.
classdef FarfieldArray < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a FarfieldArray object.
        function obj = FarfieldArray(project, hProject)
            obj.project = project;
            obj.hFarfieldArray = hProject.invoke('FarfieldArray');
            obj.history = [];
            obj.bulkmode = 0;
        end
    end
    methods
        function StartBulkMode(obj)
            % Buffers all commands instead of sending them to CST
            % immediately.
            obj.bulkmode = 1;
        end
        function EndBulkMode(obj)
            % Flushes all commands since StartBulkMode to CST.
            obj.bulkmode = 0;
            % Prepend With FarfieldArray and append End With
            obj.history = [ 'With FarfieldArray', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define FarfieldArray settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['FarfieldArray', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal settings to their initial values.
            obj.AddToHistory(['.Reset']);
        end
        function UseArray(obj, bFlag)
            % Activates the array pattern for farfield calculation.
            obj.AddToHistory(['.UseArray "', num2str(bFlag, '%.15g'), '"']);
            obj.usearray = bFlag;
        end
        function Arraytype(obj, type)
            % Sets the type of the array pattern.
            % type can have one of the following values:
            % �rectangular� - A rectangular array pattern (linear: 1D, planar: 2D, cubic: 3D) can be defined by setting the corresponding antenna numbers together with the space and phaseshift information using the methods XSet, YSet, and ZSet. The resulting list is then calculated by SetList. The array setup uses automatically the unit cell geometry and phasing if unit cell or periodic boundaries are active.
            % �edit� - This mode offers the possibility to edit the current antennalist by adding single antenna elements to the list using the method Antenna.
            obj.AddToHistory(['.Arraytype "', num2str(type, '%.15g'), '"']);
            obj.arraytype = type;
        end
        function XSet(obj, number, spaceshift, phaseshift)
            % Defines a linear array pattern in the x,y or z-direction respectively. Thus a linear, planar or cubic antenna array structure may be created.
            % number
            % The number of single antenna elements in x,y or z-direction
            % spaceshift
            % The constant spaceshift between two single antenna elements in x,y or z-direction
            % phaseshift
            % The constant phaseshift between two single antenna elements in x,y or z-direction
            obj.AddToHistory(['.XSet "', num2str(number, '%.15g'), '", '...
                                    '"', num2str(spaceshift, '%.15g'), '", '...
                                    '"', num2str(phaseshift, '%.15g'), '"']);
            obj.xset.number = number;
            obj.xset.spaceshift = spaceshift;
            obj.xset.phaseshift = phaseshift;
        end
        function YSet(obj, number, spaceshift, phaseshift)
            % Defines a linear array pattern in the x,y or z-direction respectively. Thus a linear, planar or cubic antenna array structure may be created.
            % number
            % The number of single antenna elements in x,y or z-direction
            % spaceshift
            % The constant spaceshift between two single antenna elements in x,y or z-direction
            % phaseshift
            % The constant phaseshift between two single antenna elements in x,y or z-direction
            obj.AddToHistory(['.YSet "', num2str(number, '%.15g'), '", '...
                                    '"', num2str(spaceshift, '%.15g'), '", '...
                                    '"', num2str(phaseshift, '%.15g'), '"']);
            obj.yset.number = number;
            obj.yset.spaceshift = spaceshift;
            obj.yset.phaseshift = phaseshift;
        end
        function ZSet(obj, number, spaceshift, phaseshift)
            % Defines a linear array pattern in the x,y or z-direction respectively. Thus a linear, planar or cubic antenna array structure may be created.
            % number
            % The number of single antenna elements in x,y or z-direction
            % spaceshift
            % The constant spaceshift between two single antenna elements in x,y or z-direction
            % phaseshift
            % The constant phaseshift between two single antenna elements in x,y or z-direction
            obj.AddToHistory(['.ZSet "', num2str(number, '%.15g'), '", '...
                                    '"', num2str(spaceshift, '%.15g'), '", '...
                                    '"', num2str(phaseshift, '%.15g'), '"']);
            obj.zset.number = number;
            obj.zset.spaceshift = spaceshift;
            obj.zset.phaseshift = phaseshift;
        end
        function SetList(obj)
            % Calculates a complete list of single antenna elements based on the specified array configuration and transfers these settings to the farfield plotter.
            obj.AddToHistory(['.SetList']);
        end
        function DeleteList(obj)
            % Deletes the current list of single antenna elements defining the array pattern.
            obj.AddToHistory(['.DeleteList']);
        end
        function Antenna(obj, x, y, z, amplitude, phase)
            % Defines the properties of a single antenna element. This method is only applicable in the editing mode set by Arraytype.
            % x
            % The x-position of the single antenna element in space
            % y
            % The y-position of the single antenna element in space
            % z
            % The z-position of the single antenna element in space
            % amplitude
            % The amplitude value of the single antenna element
            % phase
            % The phase value of the single antenna element
            obj.AddToHistory(['.Antenna "', num2str(x, '%.15g'), '", '...
                                       '"', num2str(y, '%.15g'), '", '...
                                       '"', num2str(z, '%.15g'), '", '...
                                       '"', num2str(amplitude, '%.15g'), '", '...
                                       '"', num2str(phase, '%.15g'), '"']);
            obj.antenna.x = x;
            obj.antenna.y = y;
            obj.antenna.z = z;
            obj.antenna.amplitude = amplitude;
            obj.antenna.phase = phase;
        end
        function AddAntennaItem(obj, sfile, x, y, z, alpha, beta, gamma, A, phase)
            % Loads an antenna farfield from sfile and adds it to the combine list.
            obj.AddToHistory(['.AddAntennaItem "', num2str(sfile, '%.15g'), '", '...
                                              '"', num2str(x, '%.15g'), '", '...
                                              '"', num2str(y, '%.15g'), '", '...
                                              '"', num2str(z, '%.15g'), '", '...
                                              '"', num2str(alpha, '%.15g'), '", '...
                                              '"', num2str(beta, '%.15g'), '", '...
                                              '"', num2str(gamma, '%.15g'), '", '...
                                              '"', num2str(A, '%.15g'), '", '...
                                              '"', num2str(phase, '%.15g'), '"']);
            obj.addantennaitem.sfile = sfile;
            obj.addantennaitem.x = x;
            obj.addantennaitem.y = y;
            obj.addantennaitem.z = z;
            obj.addantennaitem.alpha = alpha;
            obj.addantennaitem.beta = beta;
            obj.addantennaitem.gamma = gamma;
            obj.addantennaitem.A = A;
            obj.addantennaitem.phase = phase;
        end
        function AddAntennaItemA(obj, sfile, x, y, z, z1, z2, z3, x1, x2, x3, A, phase)
            % The command is similar to AddAntennaItem, but the orientation is specified by the antenna frame z-axis and x-axis in global coordinates.
            % The following table summarizes the antenna parameters:
            % x, y, z
            % Position of the antenna in space
            % alpha, beta, gamma
            % Orientation of the antenna in Euler-x angles
            % z1, z2, z3
            % Antenna frame z-axis in global coordinate
            % x1, x2, x3
            % Antenna frame x-axis in global coordinate
            % A
            %  Amplitude of the antenna emission
            % Phase
            %  Phase of the antenna emission
            obj.AddToHistory(['.AddAntennaItemA "', num2str(sfile, '%.15g'), '", '...
                                               '"', num2str(x, '%.15g'), '", '...
                                               '"', num2str(y, '%.15g'), '", '...
                                               '"', num2str(z, '%.15g'), '", '...
                                               '"', num2str(z1, '%.15g'), '", '...
                                               '"', num2str(z2, '%.15g'), '", '...
                                               '"', num2str(z3, '%.15g'), '", '...
                                               '"', num2str(x1, '%.15g'), '", '...
                                               '"', num2str(x2, '%.15g'), '", '...
                                               '"', num2str(x3, '%.15g'), '", '...
                                               '"', num2str(A, '%.15g'), '", '...
                                               '"', num2str(phase, '%.15g'), '"']);
            obj.addantennaitema.sfile = sfile;
            obj.addantennaitema.x = x;
            obj.addantennaitema.y = y;
            obj.addantennaitema.z = z;
            obj.addantennaitema.z1 = z1;
            obj.addantennaitema.z2 = z2;
            obj.addantennaitema.z3 = z3;
            obj.addantennaitema.x1 = x1;
            obj.addantennaitema.x2 = x2;
            obj.addantennaitema.x3 = x3;
            obj.addantennaitema.A = A;
            obj.addantennaitema.phase = phase;
        end
        function ClearAntennaItems(obj)
            % Clears the antenna combine list.   
            obj.AddToHistory(['.ClearAntennaItems']);
        end
        function SetNormalizeAntennas(obj, bflag)
            % Activates the normalization of all antennas  to 1 W(peak) stimulated power before the execution of the combine command. The user specified amplitudes are  applied to the scaled farfields.
            obj.AddToHistory(['.SetNormalizeAntennas "', num2str(bflag, '%.15g'), '"']);
            obj.setnormalizeantennas = bflag;
        end
        function SetCombineFrequency(obj, frequency)
            % Sets the frequency of the combined antenna. All antennas in the combine list must have the same frequency, otherwise the consistent combination of the antennas is not possible.
            obj.AddToHistory(['.SetCombineFrequency "', num2str(frequency, '%.15g'), '"']);
            obj.setcombinefrequency = frequency;
        end
        function SetCombineReferenceAxes(obj, z1, z2, z3, x1, x2, x3)
            % Sets the theta reference axis (z1, z2, z3) and the phi reference axis (x1, x2, x3) of the combined antenna.
            obj.AddToHistory(['.SetCombineReferenceAxes "', num2str(z1, '%.15g'), '", '...
                                                       '"', num2str(z2, '%.15g'), '", '...
                                                       '"', num2str(z3, '%.15g'), '", '...
                                                       '"', num2str(x1, '%.15g'), '", '...
                                                       '"', num2str(x2, '%.15g'), '", '...
                                                       '"', num2str(x3, '%.15g'), '"']);
            obj.setcombinereferenceaxes.z1 = z1;
            obj.setcombinereferenceaxes.z2 = z2;
            obj.setcombinereferenceaxes.z3 = z3;
            obj.setcombinereferenceaxes.x1 = x1;
            obj.setcombinereferenceaxes.x2 = x2;
            obj.setcombinereferenceaxes.x3 = x3;
        end
        function SetCombineReferenceOrigin(obj, p1, p2, p3)
            % Sets the phase reference origin (p1, p2, p3) of the combined antenna.
            obj.AddToHistory(['.SetCombineReferenceOrigin "', num2str(p1, '%.15g'), '", '...
                                                         '"', num2str(p2, '%.15g'), '", '...
                                                         '"', num2str(p3, '%.15g'), '"']);
            obj.setcombinereferenceorigin.p1 = p1;
            obj.setcombinereferenceorigin.p2 = p2;
            obj.setcombinereferenceorigin.p3 = p3;
        end
        function ExecuteCombine(obj, sfile, stepInDegree)
            % Combines all antennas from the combine list to a single antenna. The new antenna data is sampled with stepInDegree and written to sfile. No further scaling is applied to the combined field.
            % %% Queries
            % GetCombinePowerRatio double
            % Returns the ratio of the actual emitted power to the integrated input power of all antennas from the combine list. A strong deviation from unity indicates a non-negligible interaction of the antennas.
            obj.AddToHistory(['.ExecuteCombine "', num2str(sfile, '%.15g'), '", '...
                                              '"', num2str(stepInDegree, '%.15g'), '"']);
            obj.executecombine.sfile = sfile;
            obj.executecombine.stepInDegree = stepInDegree;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hFarfieldArray
        history
        bulkmode

        usearray
        arraytype
        xset
        yset
        zset
        antenna
        addantennaitem
        addantennaitema
        setnormalizeantennas
        setcombinefrequency
        setcombinereferenceaxes
        setcombinereferenceorigin
        executecombine
    end
end

%% Default Settings
% UseArray(0)
% Arraytype('rectangular');
% XSet(1, 0.0, 0.0)
% YSet(1, 0.0, 0.0)
% ZSet(1, 0.0, 0.0)
% SetCombineFrequency(-1.0)
% SetCombineReferenceAxes(0, 0, 1, 1, 0, 0)
% SetCombineReferenceOrigin(0, 0, 0)
% SetNormalizeAntennas(1)

%% Example - Taken from CST documentation and translated to MATLAB.
% % The first example defines a linear antenna array:
% 
%  With FarfieldArray
%     farfieldarray.Reset
%     farfieldarray.UseArray(1)
%     farfieldarray.Arraytype('rectangular');
%     farfieldarray.ZSet(2, 2.5, 90)
%     farfieldarray.SetList
%     farfieldarray.Arraytype('edit');
%     farfieldarray.Antenna(0, 0, 0, 1.0, 0.0)
%  End With
% 
% % The second example combines two antennas with different orientation and position:
% 
% farfieldarray = project.FarfieldArray();
% ResultPath = GetProjectPath('Result');                 % Assume that the farfield files are in the result folder
% .ClearAntennaItems()
% .SetCombineFrequency(100.0)
% .AddAntennaItem(ResultPath +('farfield_1.ffp', 0.0, -1.0, 0.0, 0,   0, 30.0, 1.0, 90.0)
% .AddAntennaItem(ResultPath +('farfield_2.ffp', 0.0,  1.0, 0.0, 0, -30,  0.0, 1.0,  0.0)
% .ExecuteCombine(ResultPath +('combined_ff.ffp', 5.0)  % Store the combined antenna in the result folder
% MsgBox('Actual Power / Power Sum =(' & .GetCombinePowerRatio()
% 
% % The third example combines antennas to a finite-size array of unit cells with seven times seven elements:
% 
% .SetCombineFrequency(100.0)
% .SetNormalizeAntennas(0)
% .SetUnitCellArray('farfield_1.ffp', 7, 7)
% .ExecuteCombine('combined_ff.ffp', 5.0)
% 
% 
% % The fourth example sets the farfield origin:
% 
% NewOriginX = -100
% NewOriginY = 300
% NewOriginZ = 400
% 
% Frequency = 30.0
% 
% MonitorName =('farfield(f=30)');
% 
% ResultPath = GetProjectPath('Result');
% .ClearAntennaItems()
% .SetCombineFrequency(Frequency)
% .AddAntennaItemA(ResultPath + MonitorName +('2D_1.ffp', 0,0,0, 0,0,1,1,0,0, 1, 0)
% .SetCombineReferenceOrigin( NewOriginX, NewOriginY ,NewOriginZ )
% .ExecuteCombine(ResultPath +('MovedOrigin.ffp', 1.0)
% 
% % Add to result tree
% .Name('Farfields\MovedOrigin');
% .File ResultPath +('MovedOrigin.ffp');
% .Type('Farfield');
% .Add
