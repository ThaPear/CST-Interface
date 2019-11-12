%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CST Interface                                                       %%%
%%% Author: Alexander van Katwijk                                       %%%
%%% Co-Author: Cyrus Tirband                                            %%%
%%%                                                                     %%%
%%% File Author: Alexander van Katwijk                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use this object to configure the Floquet ports of an infinite array's unit cell. Whenever unit cell boundaries are combined with open boundaries at Zmin or Zmax, the open boundary is realized by a Floquet mode waveguide port (this allows for instance to excite plane waves, which are the fundamental Floquet modes TE(0,0) and TM(0,0)). The FloquetPort object collects methods to manipulate the modes of all Floquet ports. The following information applies to the general purpose Frequency Domain solvers.
classdef FloquetPort < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.FloquetPort object.
        function obj = FloquetPort(project, hProject)
            obj.project = project;
            obj.hFloquetPort = hProject.invoke('FloquetPort');
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
            % Prepend With FloquetPort and append End With
            obj.history = [ 'With FloquetPort', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define FloquetPort settings'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['FloquetPort', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal values to their default settings.
            obj.AddToHistory(['.Reset']);
        end
        function Port(obj, position)
            % This methods is called before any other method in order to specify the Floquet port to which subsequent calls refer. The argument is either "Zmin" or "Zmax".
            % position: 'zmin'
            %           'zmax'
            obj.AddToHistory(['.Port "', num2str(position, '%.15g'), '"']);
            obj.port = position;
        end
        function AddMode(obj, type, order_x, order_yprime)
            % Adds a single Floquet mode to this port. The mode is specified by its type (TE for transversal electric field with respect to the port's plane, and TM for transversal magnetic field), and its signed integer order numbers along the unit cell lattice vectors. The order numbers need to be zero for LCP and RCP modes (also see SetUseCircularPolarization). Note that it is not necessary to specify all Floquet modes explicitly by calling this method unless a fully customized list of modes is required.
            % type: 'TE'
            %       'TM'
            %       'LCP'
            %       'RCP'
            obj.AddToHistory(['.AddMode "', num2str(type, '%.15g'), '", '...
                                       '"', num2str(order_x, '%.15g'), '", '...
                                       '"', num2str(order_yprime, '%.15g'), '"']);
            obj.addmode.type = type;
            obj.addmode.order_x = order_x;
            obj.addmode.order_yprime = order_yprime;
        end
        function SetUseCircularPolarization(obj, flag)
            % If this flag is set to True, left and right circularly polarized waves (LCP, RCP) will be excited instead of the linearly polarized TE(0,0) and TM(0,0) modes.
            obj.AddToHistory(['.SetUseCircularPolarization "', num2str(flag, '%.15g'), '"']);
            obj.setusecircularpolarization = flag;
        end
        function SetPolarizationIndependentOfScanAnglePhi(obj, value, flag)
            % The polarization of the Floquet modes is usually given implicitly as a function of the scan angle phi. If the flag is set to True, the fundamental modes TE(0,0) and TM(0,0) will be linearily combined such that the resulting first mode's polarization is aligned to the given value (in degrees, with respect to the u-axis of the port, as for waveguide ports.)
            obj.AddToHistory(['.SetPolarizationIndependentOfScanAnglePhi "', num2str(value, '%.15g'), '", '...
                                                                        '"', num2str(flag, '%.15g'), '"']);
            obj.setpolarizationindependentofscananglephi.value = value;
            obj.setpolarizationindependentofscananglephi.flag = flag;
        end
        function SetDialogFrequency(obj, value)
            % The sorting of the Floquet modes (e.g. by decreasing beta) depends on frequency as well as the scan angles theta and phi. As the modes should not change their order while a frequency sweep is performed, the frequency at which the modes are sorted needs to be fixed by calling this method. Pass an empty string to sort the modes at the uppermost frequency. Calling this method affects all Floquet ports.
            obj.AddToHistory(['.SetDialogFrequency "', num2str(value, '%.15g'), '"']);
            obj.setdialogfrequency = value;
        end
        function SetDialogMediaFactor(obj, value)
            % The preview calculation of alpha and beta can be adapted to a specific material by calling this method. Pass an empty string to perform the calculations in the current background material. For different materials, pass the square root of the relative permittivity times the square root of the relative permeability as the value. Calling this method affects the preview for all Floquet ports.
            obj.AddToHistory(['.SetDialogMediaFactor "', num2str(value, '%.15g'), '"']);
            obj.setdialogmediafactor = value;
        end
        function SetDialogTheta(obj, value)
            % The sorting of the Floquet modes (e.g. by decreasing beta) depends on frequency as well as the scan angles theta and phi. As the modes should not change their order while a frequency sweep is performed, the theta at which the modes are sorted needs to be fixed by calling this method. Calling this method affects all Floquet ports.
            obj.AddToHistory(['.SetDialogTheta "', num2str(value, '%.15g'), '"']);
            obj.setdialogtheta = value;
        end
        function SetDialogPhi(obj, value)
            % The sorting of the Floquet modes (e.g. by decreasing beta) depends on frequency as well as the scan angles theta and phi. As the modes should not change their order while a frequency sweep is performed, the phi at which the modes are sorted needs to be fixed by calling this method. Calling this method affects all Floquet ports.
            obj.AddToHistory(['.SetDialogPhi "', num2str(value, '%.15g'), '"']);
            obj.setdialogphi = value;
        end
        function SetDialogMaxOrderX(obj, value)
            % The number of Floquet modes which need to be considered depends on the size of the Floquet port in terms of wavelength. When the modes are not explicitly defined by calling AddMode, their maximum order needs to be specified. SetDialogMaxOrderX defines the range of the Floquet modes' first order number by means of its magnitude. For example, if "2" is passed as an argument, the Floquet modes (-2,*), (-1,*), (0,*), (1,*), and (2,*) will be considered. When an empty string is passed to this method, the maximum order is determined automatically from the size of the Floquet port in terms of the wavelength at the sorting frequency. Calling this method affects all Floquet ports.
            obj.AddToHistory(['.SetDialogMaxOrderX "', num2str(value, '%.15g'), '"']);
            obj.setdialogmaxorderx = value;
        end
        function SetDialogMaxOrderYPrime(obj, value)
            % The number of Floquet modes which need to be considered depends on the size of the Floquet port in terms of wavelength. When the modes are not explicitly defined by calling AddMode, their maximum order needs to be specified. SetDialogMaxOrderYPrime defines the range of the Floquet modes' second order number by means of its magnitude. For example, if "2" is passed as an argument, the Floquet modes (*,-2), (*,-1), (*,0), (*,1), and (*,2) will be considered. When an empty string is passed to this method, the maximum order is determined automatically from the size of the Floquet port in terms of the wavelength at the sorting frequency. Calling this method affects all Floquet ports.
            obj.AddToHistory(['.SetDialogMaxOrderYPrime "', num2str(value, '%.15g'), '"']);
            obj.setdialogmaxorderyprime = value;
        end
        function SetCustomizedListFlag(obj, flag)
            % The flag should be set to True whenever modes are explicitly defined by calling AddMode. Otherwise, the Floquet modes are assigned automatically based on the arguments passed to SetDialogMaxOrderX and SetDialogMaxOrderYPrime.
            obj.AddToHistory(['.SetCustomizedListFlag "', num2str(flag, '%.15g'), '"']);
            obj.setcustomizedlistflag = flag;
        end
        function SetNumberOfModesConsidered(obj, value)
            % As the number of Floquet modes specified for the given Floquet port might be much larger than the number of modes which are actually required for the given structure, this method defines how many modes to consider during the simulation. Note that the number of modes to consider is larger than or equal to the number of modes to excite.
            obj.AddToHistory(['.SetNumberOfModesConsidered "', num2str(value, '%.15g'), '"']);
            obj.setnumberofmodesconsidered = value;
        end
        function SetSortCode(obj, code)
            % Specifies how to sort the list of Floquet modes (unless it has been customized). The modes can be sorted by their type, their propagation constants alpha and beta, or by their order numbers. A plus in front of the sort code refers to the default order (for instance sort by decreasing beta), while a minus indicates a reversal of the sorting (for instance sort by increasing beta). Calling this method affects all Floquet ports. The default sort code is "+beta/pw", which means sorting by decreasing beta, but with the fundamental Floquet modes, which are the regular plane waves (pw), at the first place, regardless of their beta.
            % code: '+beta/pw'
            %       '+beta'
            %       '-beta'
            %       '+alpha'
            %       '-alpha'
            %       '+te'
            %       '-te'
            %       '+tm'
            %       '-tm'
            %       '+orderx'
            %       '-orderx'
            %       '+ordery'
            %       '-ordery'
            obj.AddToHistory(['.SetSortCode "', num2str(code, '%.15g'), '"']);
            obj.setsortcode = code;
        end
        function SetDistanceToReferencePlane(obj, value)
            % Defines the phase deembedding distance for the Floquet port. The Frequency Domain solver with tetrahedral mesh will then calculate the S-parameters as if the Floquet port were placed at the given distance to the reference plane. The value is negative if the new reference plane is inside the structure.
            obj.AddToHistory(['.SetDistanceToReferencePlane "', num2str(value, '%.15g'), '"']);
            obj.setdistancetoreferenceplane = value;
        end
        function int = GetNumberOfModes(obj)
            % Returns the number of modes specified for the currently selected port. This number is less than or equal to the number of modes to consider during the calculation, which is returned by GetNumberOfModesConsidered.
            int = obj.hFloquetPort.invoke(['GetNumberOfModes']);
        end
        function bool = FirstMode(obj)
            % Initializes an iteration over all modes of the currently selected Floquet port. The method returns False if there are no modes associated with the port.
            bool = obj.hFloquetPort.invoke(['FirstMode']);
        end
        function bool = GetMode(obj, type, order_x, order_yprime)
            % Use this method in combination with FirstMode and NextMode to get the parameters of the currently selected port's modes: their types (TE or TM, as well as RCP or LCP for circular polarized fundamental modes), and their order numbers.
            bool = obj.hFloquetPort.invoke(['GetMode "', num2str(type, '%.15g'), '", '...
                                                    '"', num2str(order_x, '%.15g'), '", '...
                                                    '"', num2str(order_yprime, '%.15g'), '"']);
            obj.getmode.type = type;
            obj.getmode.order_x = order_x;
            obj.getmode.order_yprime = order_yprime;
        end
        function bool = NextMode(obj)
            % The method moves the port mode iteration to the next mode of the currently selected Floquet port, or returns False if there are no more modes.
            bool = obj.hFloquetPort.invoke(['NextMode']);
        end
        function int = GetNumberOfModesConsidered(obj)
            % Returns the number of modes considered for the currently selected port.
            int = obj.hFloquetPort.invoke(['GetNumberOfModesConsidered']);
        end
        function bool = IsPortAtZmin(obj)
            % Returns if the selected port is located at zmin.
            bool = obj.hFloquetPort.invoke(['IsPortAtZmin']);
        end
        function bool = IsPortAtZmax(obj)
            % Returns if the selected port is located at zmax.
            bool = obj.hFloquetPort.invoke(['IsPortAtZmax']);
        end
        function bool = GetModeNameByNumber(obj, name, number)
            % Use this method to get a mode's name by specifying its number, which refers to the currently active mode order, as defined by the current sorting mode. While the order of the modes may change with frequency and scan angle, their names naturally remain constant.
            bool = obj.hFloquetPort.invoke(['GetModeNameByNumber "', num2str(name, '%.15g'), '", '...
                                                                '"', num2str(number, '%.15g'), '"']);
            obj.getmodenamebynumber.name = name;
            obj.getmodenamebynumber.number = number;
        end
        function bool = GetModeNumberByName(obj, number, name)
            % Use this method to get a mode's number, which corresponds to the currently active mode order, by specifying the mode's name.
            bool = obj.hFloquetPort.invoke(['GetModeNumberByName "', num2str(number, '%.15g'), '", '...
                                                                '"', num2str(name, '%.15g'), '"']);
            obj.getmodenumberbyname.number = number;
            obj.getmodenumberbyname.name = name;
        end
        function ForceLegacyPhaseReference(obj, flag)
            % If this flag is set to True, the phase reference for the Floquet port modes is the smallest x- and y-coordinate of the Floquet ports and thus of the unit cell. This is the legacy behavior for versions older than 2017. The new default is the xy-center of the bounding box, with gives more symmetric modes at phase Zero.
            obj.AddToHistory(['.ForceLegacyPhaseReference "', num2str(flag, '%.15g'), '"']);
            obj.forcelegacyphasereference = flag;
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hFloquetPort
        history
        bulkmode

        port
        addmode
        setusecircularpolarization
        setpolarizationindependentofscananglephi
        setdialogfrequency
        setdialogmediafactor
        setdialogtheta
        setdialogphi
        setdialogmaxorderx
        setdialogmaxorderyprime
        setcustomizedlistflag
        setnumberofmodesconsidered
        setsortcode
        setdistancetoreferenceplane
        getmode
        getmodenamebynumber
        getmodenumberbyname
        forcelegacyphasereference
    end
end

%% Default Settings
% Port('Zmin');
% SetUseCircularPolarization(0)
% SetPolarizationIndependentOfScanAnglePhi(0.0, 0)
% SetDialogFrequency('');
% SetDialogMediaFactor('');
% SetDialogTheta(0)
% SetDialogPhi(0)
% SetDialogMaxOrderX('');
% SetDialogMaxOrderYPrime('');
% SetCustomizedListFlag(0)
% SetNumberOfModesConsidered(18)
% SetSortCode('+beta/pw');
% SetDistanceToReferencePlane(0)
% ForceLegacyPhaseReference(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% % Specify the modes for the Floquet port at Zmax
% floquetport = project.FloquetPort();
%     floquetport.SetDialogFrequency(5)
%     floquetport.SetDialogTheta(60)
%     floquetport.SetDialogPhi(0)
%     floquetport.SetDialogMaxOrderX(1)
%     floquetport.SetDialogMaxOrderYPrime(1)
%     floquetport.SetSortCode('+beta');
%     floquetport.SetCustomizedListFlag(0)
%     floquetport.Port('Zmax');
%     floquetport.SetNumberOfModesConsidered(2)
% 
% % Get the mode number of the plane waves TE(0,0) and TM(0,0)
% project.Dim iTE As Long
% project.Dim iTM As Long
%     floquetport.Port('Zmax');
%     floquetport.GetModeNumberByName(iTE, 'TE(0,0)');
%     floquetport.GetModeNumberByName(iTM, 'TM(0,0)');
% 
% % Specify the phase deembedding distance for the Floquet ports at Zmin and Zmax
%     floquetport.Port('Zmin');
%     floquetport.SetDistanceToReferencePlane(-10)
%     floquetport.Port('Zmax');
%     floquetport.SetDistanceToReferencePlane(-10)
% 
