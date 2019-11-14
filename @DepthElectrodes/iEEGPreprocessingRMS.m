function obj = iEEGPreprocessingRMS(obj)
%% Preprocessing the iEEG data

% rename channels
obj.iEEG.RenameChan

% Remove line noise
obj.iEEG.RemoveLineNoise(50,490)

% Bipolar montage
obj.iEEG.Montage_Bip
obj.BipolarElectrodeName = obj.iEEG.iEEG_MEEG{1}.chanlabels';

end

