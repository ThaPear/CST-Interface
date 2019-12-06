%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Warning: Untested                                                   %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine an equivalent SPICE circuit which has the same behavior at the ports as the simulation model. This command represents the "Spice Extraction" in the "Signal Post-Processing" ribbon. Two different methods exist for this task. The "transmission line model" (TL) is based on a fixed topology of a network of parallel and coupled transmission lines. The other more general method is based on a "model order reduction" (MOR) and does not assume any fixed topology. The drawback of the latter approach, however, is that the derived SPICE circuit elements do not allow any physical interpretation.
classdef NetworkParameterExtraction < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a NetworkParameterExtraction object.
        function obj = NetworkParameterExtraction(project, hProject)
            obj.project = project;
            obj.hNetworkParameterExtraction = hProject.invoke('NetworkParameterExtraction');
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
        function Method(obj, extractionMethod)
            % Selects the method to be used when running network parameter extraction.
            % extractionMethod: 'TransmissionLine'
            %                   'MOR'
            obj.AddToHistory(['.Method "', num2str(extractionMethod, '%.15g'), '"']);
            obj.method = extractionMethod;
        end
        function enum = GetMethod(obj)
            % Returns the currently set method for extracting network parameters.
            enum = obj.hNetworkParameterExtraction.invoke('GetMethod');
        end
        function Calculate(obj)
            % Starts the network parameter extraction with the previously made settings.
            obj.AddToHistory(['.Calculate']);
            
            % Prepend With NetworkParameterExtraction and append End With
            obj.history = [ 'With NetworkParameterExtraction', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define NetworkParameterExtraction'], obj.history);
            obj.history = [];
        end
        %% Methods for Transmission Line (TL) Based Extraction
        function AddWire(obj, number, portA, modeA, portB, modeB)
            % Define a wire element between two ports to obtain the network parameters. The number denotes the number of the wire. The wire starts at port  portA (modeA) and ends at port portB (modeB).
            % Please note: all arguments must be long value here. Any expression is not allowed.
            obj.AddToHistory(['.AddWire "', num2str(number, '%.15g'), '", '...
                                       '"', num2str(portA, '%.15g'), '", '...
                                       '"', num2str(modeA, '%.15g'), '", '...
                                       '"', num2str(portB, '%.15g'), '", '...
                                       '"', num2str(modeB, '%.15g'), '"']);
            obj.addwire.number = number;
            obj.addwire.portA = portA;
            obj.addwire.modeA = modeA;
            obj.addwire.portB = portB;
            obj.addwire.modeB = modeB;
        end
        function SetFrequency(obj, freq)
            % Defines the extraction frequency for the network parameter model. The calculated network model is most accurate at this frequency.
            % Please note: freq must be a double value here. Any expression is not allowed.
            obj.AddToHistory(['.SetFrequency "', num2str(freq, '%.15g'), '"']);
            obj.setfrequency = freq;
        end
        function SetNCascades(obj, number)
            % Defines how many network elements are cascaded to approximate the input/output behavior of the simulated structure.
            % Please note: number must be a long integer value here. Any expression is not allowed.
            obj.AddToHistory(['.SetNCascades "', num2str(number, '%.15g'), '"']);
            obj.setncascades = number;
        end
        function SetLimitCoupling(obj, bFlag, limit)
            % If activated (bFlag is True) the coupling between wires is limited if a certain minimum coupling value is not reached. Then coupling elements between these wires will be omitted. Enable or disable this behavior here and set the limit value.
            obj.AddToHistory(['.SetLimitCoupling "', num2str(bFlag, '%.15g'), '", '...
                                                '"', num2str(limit, '%.15g'), '"']);
            obj.setlimitcoupling.bFlag = bFlag;
            obj.setlimitcoupling.limit = limit;
        end
        function SetKeepTopology(obj, bFlag, minR, minG, minL, minC, minK)
            % if bFlag is True the topology of the extracted network will not be changed even if some elements have values close to 0. Those elements with values lower than a given limit will be set to this limit. Set the limit using the minR, minG, minL, minC and minK parameters. MinR, minG, minL, minC and minK set the limits for the resistance in Ohms, the transconductance in S the inductance in H, the capacitance in F and the couling respectively.
            obj.AddToHistory(['.SetKeepTopology "', num2str(bFlag, '%.15g'), '", '...
                                               '"', num2str(minR, '%.15g'), '", '...
                                               '"', num2str(minG, '%.15g'), '", '...
                                               '"', num2str(minL, '%.15g'), '", '...
                                               '"', num2str(minC, '%.15g'), '", '...
                                               '"', num2str(minK, '%.15g'), '"']);
            obj.setkeeptopology.bFlag = bFlag;
            obj.setkeeptopology.minR = minR;
            obj.setkeeptopology.minG = minG;
            obj.setkeeptopology.minL = minL;
            obj.setkeeptopology.minC = minC;
            obj.setkeeptopology.minK = minK;
        end
        function GenerateSubCircuit(obj, bFlag)
            %  If bFlag is True the resulting SPICE netlist of the transmission line based network parameter extraction is enclosed in a sub-circuit. The sub-circuit begins with the ".subckt" statement and ends with the ".ends" statement.
            obj.AddToHistory(['.GenerateSubCircuit "', num2str(bFlag, '%.15g'), '"']);
            obj.generatesubcircuit = bFlag;
        end
        function CreateNetList(obj, fileName)
            % Creates a netlist file with the name fileName for SPICE simulation after the transmission line based calculation (performed by the method Calculate) has finished.
            obj.AddToHistory(['.CreateNetList "', num2str(fileName, '%.15g'), '"']);
            obj.createnetlist = fileName;
        end
        %% Queries Concerning Settings for TL
        function long = GetNWires(obj)
            % Returns the number of defined wires
            long = obj.hNetworkParameterExtraction.invoke('GetNWires');
        end
        function long = GetWireId(obj, index)
            % Returns the id of the wire. Index is a number between 0 and n-1, where n is the number of defined wires as returned by GetNWires.
            long = obj.hNetworkParameterExtraction.invoke('GetWireId', index);
            obj.getwireid = index;
        end
        function long = GetWirePortA(obj, index)
            % Returns the port number where the wire starts (GetWirePortA) or ends (GetWirePortB) respectively. Index is a number between 0 and n-1, where n is the number of defined wires as returned by GetNWires. Id is the identification number of a wire. It can be determined using the GetWireId method.
            long = obj.hNetworkParameterExtraction.invoke('GetWirePortA', index);
            obj.getwireporta = index;
        end
        function long = GetWirePortB(obj, index)
            % Returns the port number where the wire starts (GetWirePortA) or ends (GetWirePortB) respectively. Index is a number between 0 and n-1, where n is the number of defined wires as returned by GetNWires. Id is the identification number of a wire. It can be determined using the GetWireId method.
            long = obj.hNetworkParameterExtraction.invoke('GetWirePortB', index);
            obj.getwireportb = index;
        end
        function long = GetWirePortAFromId(obj, id)
            % Returns the port number where the wire starts (GetWirePortA) or ends (GetWirePortB) respectively. Index is a number between 0 and n-1, where n is the number of defined wires as returned by GetNWires. Id is the identification number of a wire. It can be determined using the GetWireId method.
            long = obj.hNetworkParameterExtraction.invoke('GetWirePortAFromId', id);
            obj.getwireportafromid = id;
        end
        function long = GetWirePortBFromId(obj, id)
            % Returns the port number where the wire starts (GetWirePortA) or ends (GetWirePortB) respectively. Index is a number between 0 and n-1, where n is the number of defined wires as returned by GetNWires. Id is the identification number of a wire. It can be determined using the GetWireId method.
            long = obj.hNetworkParameterExtraction.invoke('GetWirePortBFromId', id);
            obj.getwireportbfromid = id;
        end
        function long = GetWireModeA(obj, index)
            % Returns the mode number of the port where the wire starts  (GetWireModeA) or ends (GetWireModeB) respectively. Index is a number between 0 and n-1, where n is the number of defined wires as returned by GetNWires. Id is the identification number of a wire. It can be determined using the GetWireId method.
            long = obj.hNetworkParameterExtraction.invoke('GetWireModeA', index);
            obj.getwiremodea = index;
        end
        function long = GetWireModeB(obj, index)
            % Returns the mode number of the port where the wire starts  (GetWireModeA) or ends (GetWireModeB) respectively. Index is a number between 0 and n-1, where n is the number of defined wires as returned by GetNWires. Id is the identification number of a wire. It can be determined using the GetWireId method.
            long = obj.hNetworkParameterExtraction.invoke('GetWireModeB', index);
            obj.getwiremodeb = index;
        end
        function long = GetWireModeAFromId(obj, id)
            % Returns the mode number of the port where the wire starts  (GetWireModeA) or ends (GetWireModeB) respectively. Index is a number between 0 and n-1, where n is the number of defined wires as returned by GetNWires. Id is the identification number of a wire. It can be determined using the GetWireId method.
            long = obj.hNetworkParameterExtraction.invoke('GetWireModeAFromId', id);
            obj.getwiremodeafromid = id;
        end
        function long = GetWireModeBFromId(obj, id)
            % Returns the mode number of the port where the wire starts  (GetWireModeA) or ends (GetWireModeB) respectively. Index is a number between 0 and n-1, where n is the number of defined wires as returned by GetNWires. Id is the identification number of a wire. It can be determined using the GetWireId method.
            long = obj.hNetworkParameterExtraction.invoke('GetWireModeBFromId', id);
            obj.getwiremodebfromid = id;
        end
        function double = GetFrequency(obj)
            % Returns the extraction frequency for the network parameter model. The calculated network model is most accurate at this frequency.
            double = obj.hNetworkParameterExtraction.invoke('GetFrequency');
        end
        function long = GetNCascade(obj)
            % Returns how many cascaded network elements have been used to approximate the input/output behavior of the simulated structure.
            long = obj.hNetworkParameterExtraction.invoke('GetNCascade');
        end
        %% Queries Concerning Results for TL
        function double = GetRFromId(obj, id)
            % Returns the calculated resistance R, conductance G, or inductance L of the transmission line based network parameter model respectively. It is specified by the identity number id of the corresponding wire.
            double = obj.hNetworkParameterExtraction.invoke('GetRFromId', id);
            obj.getrfromid = id;
        end
        function double = GetGFromId(obj, id)
            % Returns the calculated resistance R, conductance G, or inductance L of the transmission line based network parameter model respectively. It is specified by the identity number id of the corresponding wire.
            double = obj.hNetworkParameterExtraction.invoke('GetGFromId', id);
            obj.getgfromid = id;
        end
        function double = GetLFromId(obj, id)
            % Returns the calculated resistance R, conductance G, or inductance L of the transmission line based network parameter model respectively. It is specified by the identity number id of the corresponding wire.
            double = obj.hNetworkParameterExtraction.invoke('GetLFromId', id);
            obj.getlfromid = id;
        end
        function double = GetCFromId(obj, id1, id2)
            % Returns the calculated capacitance C of the transmission line based network parameter model. It is specified by the identity number of the corresponding wires id1 and id2. In case that both identity numbers are identically the self capacitance of the network element results, in case of two different numbers the mutual capacitance between two elements.
            double = obj.hNetworkParameterExtraction.invoke('GetCFromId', id1, id2);
            obj.getcfromid.id1 = id1;
            obj.getcfromid.id2 = id2;
        end
        function double = GetKFromId(obj, id1, id2)
            % Returns the calculated mutual inductance K of the transmission line based network parameter model. It is specified by the identity number of the two corresponding wires id1 and id2.
            double = obj.hNetworkParameterExtraction.invoke('GetKFromId', id1, id2);
            obj.getkfromid.id1 = id1;
            obj.getkfromid.id2 = id2;
        end
        %% Methods for Model Order Reduction (MOR) Based Extraction
        function CircuitFileName(obj, fileName)
            % Sets the filename of the resulting SPICE netlist based on model order reduction to fileName.
            obj.AddToHistory(['.CircuitFileName "', num2str(fileName, '%.15g'), '"']);
            obj.circuitfilename = fileName;
        end
        function filename = GetCircuitFileName(obj)
            % Returns the filename of the resulting SPICE netlist based on model order reduction.
            filename = obj.hNetworkParameterExtraction.invoke('GetCircuitFileName');
        end
        function EnsureOutOfBandPassivity(obj, bFlag)
            % If bFlag is True passivity for frequency values out of the given band is ensured, otherwise not.
            obj.AddToHistory(['.EnsureOutOfBandPassivity "', num2str(bFlag, '%.15g'), '"']);
            obj.ensureoutofbandpassivity = bFlag;
        end
        function UseARFilterResults(obj, bFlag)
            % If this method is activated the MOR method uses S-parameter data based on AR-Filter results if available.
            obj.AddToHistory(['.UseARFilterResults "', num2str(bFlag, '%.15g'), '"']);
            obj.usearfilterresults = bFlag;
        end
        function Accuracy(obj, value)
            % Specifies the maximum error value for the S-parameter approximation.
            % Please note: The accuracy can be violated after performing the passivity step which is activated using the EnsureOutOfBandPassivity method.
            obj.AddToHistory(['.Accuracy "', num2str(value, '%.15g'), '"']);
            obj.accuracy = value;
        end
        function InitalNumberOfPoles(obj, number)
            % Specifies the initial number of poles considered by the MOR scheme.
            obj.AddToHistory(['.InitalNumberOfPoles "', num2str(number, '%.15g'), '"']);
            obj.initalnumberofpoles = number;
        end
        function MaximumNumberOfPoles(obj, number)
            % Specifies the maximum number of poles considered by the MOR scheme.
            obj.AddToHistory(['.MaximumNumberOfPoles "', num2str(number, '%.15g'), '"']);
            obj.maximumnumberofpoles = number;
        end
        function ApplyCouplingThreshold(obj, bFlag)
            % If bFlag is True, the MOR neglects all S-Parameters below a certain threshold. This may save computation time and memory, especially, if the network has many ports.
            obj.AddToHistory(['.ApplyCouplingThreshold "', num2str(bFlag, '%.15g'), '"']);
            obj.applycouplingthreshold = bFlag;
        end
        function CouplingThreshold(obj, value)
            % Specifies the threshold in dB below which S-Parameters Sij are neglected by the MOR. This may save computation time and memory, especially, if the network has many ports. The threshold is activated by the ApplyCouplingThreshold method.
            obj.AddToHistory(['.CouplingThreshold "', num2str(value, '%.15g'), '"']);
            obj.couplingthreshold = value;
        end
        function DifferentialNetlist(obj, bFlag)
            % Specifies whether the netlist should be written with differential ports
            obj.AddToHistory(['.DifferentialNetlist "', num2str(bFlag, '%.15g'), '"']);
            obj.differentialnetlist = bFlag;
        end
        function NetlistFormat(obj, format)
            % Specifies the output format of the netlist. "Berkeley SPICE" uses standard Berkeley SPICE notation with controlled sources while "HSPICE" uses Laplace formulation of the fitted Y parameter.
            % : 'Berkeley SPICE'
            %   'HSPICE'
            obj.AddToHistory(['.NetlistFormat "', num2str(format, '%.15g'), '"']);
            obj.netlistformat = format;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hNetworkParameterExtraction
        history

        method
        addwire
        setfrequency
        setncascades
        setlimitcoupling
        setkeeptopology
        generatesubcircuit
        createnetlist
        getwireid
        getwireporta
        getwireportb
        getwireportafromid
        getwireportbfromid
        getwiremodea
        getwiremodeb
        getwiremodeafromid
        getwiremodebfromid
        getrfromid
        getgfromid
        getlfromid
        getcfromid
        getkfromid
        circuitfilename
        ensureoutofbandpassivity
        usearfilterresults
        accuracy
        initalnumberofpoles
        maximumnumberofpoles
        applycouplingthreshold
        couplingthreshold
        differentialnetlist
        netlistformat
    end
end

%% Default Settings
% Method('TransmissionLine');
%  
% ' defaults for transmission line based network parameter extraction
% SetFrequency(0.0)
% SetNCascades(1)
% SetLimitCoupling(0, 60.0)
% SetKeepTopology(0, 1e-30, 1e-30, 1e-30, 1e-30, 1e-30)
% GenerateSubCircuit(0)
%  
% ' defaults for model order reduction based network parameter extraction
% EnsureOutOfBandPassivity(1)
% UseARFilterResults(0)
% Accuracy('1e-2');
% InitalNumberOfPoles(10)
% NetlistFormat('Berkeley SPICE');

%% Example - Taken from CST documentation and translated to MATLAB.
% Example for TL
% % start a transmission line based network extraction
% 
% networkparameterextraction = project.NetworkParameterExtraction();
% .Method('TransmissionLine');
% .SetFrequency(0.9)
% .SetNCascades(3)
% .SetLimitCoupling(1, 30.0)
% .SetKeepTopology(0, 1e-30, 1e-30, 1e-30, 1e-30, 1e-30)
% .GenerateSubCircuit(1)
% .Calculate
% Example for MOR
% % start a MOR based network extraction
% 
% .Method('MOR');
% .CircuitFileName('my_netlist.net');
% .EnsureOutOfBandPassivity(0)
% .UseARFilterResults(0)
% .Accuracy('1e-2');
% .InitalNumberOfPoles(10)
% .DifferentialNetlist(1)
% .NetlistFormat('HSPICE');
% .Calculate
% 
