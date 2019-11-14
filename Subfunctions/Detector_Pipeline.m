spm('defaults', 'EEG');
% Data conversion ----------------------------
fprintf('%s\n','---- Creating bipolar montage ----')
D = edf_converter_GUI;
clear D;
% Channel rename -----------------------------
Channel_Renaming_UI

% Bipolar montage
[D,~] = SPM_bipolar_montage;

% baseline correction of the whole time series
[D] = Meeg_Baseline_Correction(D);

% line noise filter
[D] = Line_Noise_Notch_50(D);

% bandpass filter from 80 to 490
[D] = Bandpass_80_490(D);

%% HFO detection using a sliding window


signal_temp = D(4,:,1)';
Envelope = envelope_su(signal_temp,D.fsample);
% visualization for inspection of the envelope
plotECG(D.time,[signal_temp Envelope])
evelope_mean = mean(Envelope);
evelope_std = std(Envelope);
threshold_5sd = evelope_std*5;
threshold_5sd_line = repmat(threshold_5sd,D.nsamples,1);
threshold_mean_line = repmat(evelope_mean,D.nsamples,1);
plotECG(D.time,[signal_temp Envelope threshold_mean_line ThresholdLines])

