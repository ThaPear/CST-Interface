cst = actxserver('CSTStudio.Application');
project = cst.invoke('NewMWS');
brick = project.invoke('Brick');
% Do stuff with Brick
brick.invoke('Reset');
brick.invoke('Name', 'brick1');
brick.invoke('Component', 'component1');
brick.invoke('Xrange', -1, 1);
brick.invoke('Yrange', -1, 1);
brick.invoke('Zrange', -1, 1);
brick.invoke('Material', 'PEC');
brick.invoke('Create');