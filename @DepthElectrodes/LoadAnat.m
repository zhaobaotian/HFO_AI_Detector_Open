function obj = LoadAnat(obj)

[filename, path]  = uigetfile('*.nii');
obj.AnatFile = [path filename];

end

