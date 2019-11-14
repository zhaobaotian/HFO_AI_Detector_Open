function obj = LoadElectrodePosFile(obj)

[filename, path]  = uigetfile('*Pos.txt');
obj.ElectrodePosFile = [path filename];

end

