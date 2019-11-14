function obj = DeleteTempFiles(obj)
FilesToDelete1 = dir('f*.dat');
FilesToDelete2 = dir('f*.mat');

delete(FilesToDelete1.name)
delete(FilesToDelete2.name)

end

