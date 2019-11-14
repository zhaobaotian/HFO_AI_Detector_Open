function obj = LoadEDF(obj,filename_full,index_to_keep)

obj.iEEGRaw = iEEG;
obj.iEEGRaw.Converter_EDF(filename_full,index_to_keep)
obj.iEEGRaw = obj.iEEGRaw.iEEG_MEEG{1};

end

