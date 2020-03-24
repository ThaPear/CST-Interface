project = CST.Application.NewMWS();
brick = project.Brick();
% Do stuff with Brick
brick.Reset();
brick.Name('brick1');
brick.Component('component1');
brick.Xrange(-1, 1);
brick.Yrange(-1, 1);
brick.Zrange(-1, 1);
brick.Material('PEC');
brick.Create();