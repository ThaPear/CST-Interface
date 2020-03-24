%% Start the simulation.
% Note that MATLAB waits for the simulation to finish and is unresponsive during the simulation.
fdsolver.Start();

%% Export results as Touchstone.
exportfilename = [cd, '\Export\sparameters'];
touchstone = project.Touchstone();
    touchstone.Reset();
    touchstone.Impedance(50);
    touchstone.Renormalize(1);
    touchstone.FileName(exportfilename);
    touchstone.Write();

%% Import touchstone results.
sparams = sparameters([exportfilename, '.s2p']);
f = sparams.Frequencies;
S = sparams.Parameters;
s11 = squeeze(S(1,1,:));

figure;
subplot(121);
    plot(f/1e9, 20*log10(abs(s11)));

%% Export microstrip impedance.
project.SelectTreeItem('1D Results\Port Information\Line Impedance\1(1)');
plot1d = project.Plot1D();
    plot1d.PlotView('real'); % Real part.
asciiexport = project.ASCIIExport();
    asciiexport.Reset();
    asciiexport.FileName([exportfilename, '.txt']);
    asciiexport.Execute();

%% Import txt results
fileID = fopen([exportfilename, '.txt']);
fgetl(fileID); fgetl(fileID); % Skip header lines.
data = fscanf(fileID, '%g');
data = reshape(data, 2, []);
f = data(1,:);
z = data(2,:);

subplot(122);
    plot(f, z);