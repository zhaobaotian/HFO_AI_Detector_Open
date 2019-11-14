function obj = BaseLineCorrectiEEG(obj)

obj.iEEGRaw = Meeg_Baseline_Correction(obj.iEEGRaw);

end

