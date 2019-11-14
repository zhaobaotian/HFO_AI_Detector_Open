function obj = LoadEDF(obj,filename_full,index_to_keep)

obj.iEEG = iEEG;
obj.iEEG.Converter_EDF(filename_full,index_to_keep)

end

