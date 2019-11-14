function obj = ReadData(obj)

obj.ElectrodeName = importdata(obj.ElectrodeNameFile);
obj.ElectrodePos = importdata(obj.ElectrodePosFile);

end

