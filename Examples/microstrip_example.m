project = CST.Application.NewMWS();

%% Set project units.
units = project.Units();
    units.Geometry('mm');
    units.Frequency('GHz');
% The rest of the units are fine by default.
% You generally only have to specify the things that you would normally adjust yourself.

%% Set background material.
% Set background material to normal instead of PEC.
material = project.Material();
    material.Reset();
    material.Type('Normal');
    material.ChangeBackgroundMaterial();

%% Define frequency range.
% Note that any number passed from MATLAB is automatically converted to string.
% As such, it does not matter if functions are called with numbers or with strings.
solver = project.Solver();
solver.FrequencyRange('12', '32');
% solver.FrequencyRange(12, 32);

%% Set the boundaries.
boundary = project.Boundary();
    boundary.Xmin('open');
    boundary.Xmax('open');
    boundary.Ymin('open');
    boundary.Ymax('open');
    boundary.Zmin('open');
    boundary.Zmax('expanded open');
% The rest of the settings are fine by default.
% Alternatively, I've made the following function:
% boundary.AllBoundaries('open', 'open', ...       % X
%                        'open', 'open', ...       % Y
%                        'open', 'expanded open'); % Z

%% Define substrate material.
material = project.Material();
    material.Reset();
    material.Name('Substrate');
    material.Epsilon(2.2);
    material.Transparency(50);
    material.Create();
% The rest of the settings are fine by default.

%% Create microstrip structure.
% Make the microstrip parametric.
project.StoreParameter('dx', 3);
project.StoreParameter('w', 0.3);
project.StoreParameter('h', 0.127);
project.StoreParameter('l', 2.5);

brick = project.Brick();
    % Substrate
    brick.Reset();
    brick.Name('Substrate');
    brick.Component('Microstrip');
    brick.Material('Substrate');
    brick.Xrange('-dx/2', 'dx/2');
    brick.Yrange('-l/2', 'l/2');
    brick.Zrange('0', 'h');
    brick.Create();
    % Ground plane
    brick.Reset();
    brick.Name('GroundPlane');
    brick.Component('Microstrip');
    brick.Material('PEC');
    brick.Xrange('-dx/2', 'dx/2');
    brick.Yrange('-l/2', 'l/2');
    brick.Zrange('0', '0');
    brick.Create();
    % Microstrip
    brick.Reset();
    brick.Name('Microstrip');
    brick.Component('Microstrip');
    brick.Material('PEC');
    brick.Xrange('-w/2', 'w/2');
    brick.Yrange('-l/2', 'l/2');
    brick.Zrange('h', 'h');
    brick.Create();

%% Define the ports.
% Copied from the history list.
% To show the number of superfluous entries, I have kept them as comments.
port = project.Port();
    port.Reset();
    port.PortNumber('1');
    port.Label('');
    % port.Folder('');
    port.NumberOfModes('1');
    % port.AdjustPolarization('False');
    % port.PolarizationAngle('0.0');
    % port.ReferencePlaneDistance('0');
    % port.TextSize('50');
    % port.TextMaxLimit('1');
    port.Coordinates('Free');
    port.Orientation('ymin');
    port.PortOnBound('True');
    % port.ClipPickedPortToBound('False');
    port.Xrange('-6*w/2', '6*w/2');
    port.Yrange('-l/2', '-l/2');
    port.Zrange('0', '6*h');
    % port.XrangeAdd('0.0', '0.0');
    % port.YrangeAdd('0.0', '0.0');
    % port.ZrangeAdd('0.0', '0.0');
    % port.SingleEnded('False');
    % port.WaveguideMonitor('False');
    port.Create();

port = project.Port();
    port.Reset();
    port.PortNumber('2');
    port.Label('');
    port.NumberOfModes('1');
    port.Coordinates('Free');
    port.Orientation('ymax');
    port.PortOnBound('True');
    port.Xrange('-6*w/2', '6*w/2');
    port.Yrange('l/2', 'l/2');
    port.Zrange('0', '6*h');
    port.Create();

%% Set up the frequency solver.
% Note that in the history list this is given as:
% ChangeSolverType "HF Frequency Domain" 
% The Project object is assumed to be global in the history list, 
% so if functions are called directly, they require the project object.
project.ChangeSolverType('HF Frequency Domain');

fdsolver = project.FDSolver();
    fdsolver.ResetSampleIntervals('all');
    % Add a single mesh adaptation sample at fmesh.
    fdsolver.AddSampleInterval(29, '', 1, 'Single', 1); % Mesh at 29 GHz.
    fdsolver.AddSampleInterval(12, 32, 0.25 * (32-12) + 1, 'Equidistant', 0); % 1 sample per 4 GHz.
    fdsolver.AddSampleInterval('', '', '', 'Automatic', 0); % Automatic samples to ensure accuracy.
