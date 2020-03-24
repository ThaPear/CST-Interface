%% Run the previous example.
microstrip_example;

%% Delete the old microstrip.
solid = project.Solid();
solid.Delete('Microstrip:Microstrip');

%% Define the points.
y = linspace(-1,1,100);
x = (sin(pi*y) + sin(3*pi*y))/8;
% plot(y, x);

%% Define a curve along the points.
polygon3d = project.Polygon3D();
    polygon3d.Reset();
    polygon3d.Name('MS');
    polygon3d.Curve('MS');
    polygon3d.Point(0, '-l/2', 'h');
    for(i = 1:length(y))
        polygon3d.Point(x(i), y(i), 'h');
    end
    polygon3d.Point(0, 'l/2', 'h');
    polygon3d.Create();
    
%% Make the microstrip from the curve.
tracefromcurve = project.TraceFromCurve();
    tracefromcurve.Name('Microstrip');
    tracefromcurve.Component('Microstrip');
    tracefromcurve.Material('PEC');
    tracefromcurve.Curve('MS');
    tracefromcurve.Width('w');
    tracefromcurve.DeleteCurve(1);
    tracefromcurve.Create();