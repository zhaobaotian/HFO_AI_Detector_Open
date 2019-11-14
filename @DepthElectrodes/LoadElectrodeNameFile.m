function obj = LoadElectrodeNameFile(obj)

[filename, path]  = uigetfile('*Name.txt');
obj.ElectrodeNameFile = [path filename];


end

