function obj = CalculateThresholds(obj)

obj.ThresholdsALL80  = Amp_threshold(obj.iEEGBandPass80,obj.SDthreshold);

obj.ThresholdsALL250 = Amp_threshold(obj.iEEGBandPass250,obj.SDthreshold);

end

