function obj = BandPassFilter(obj)
%BandPassFilter High pass filter the signal, suppose to be done before
%epoch. Can be used to show responses of different frequency bands
% FORMAT: obj = BandPassFilter(obj)
% Input:
%       obj: iEEG object loaded with properties: iEEG MEEG and BandPassFreq
% Output:
%       obj: iEEG object with band pass filtered iEEG property
% --------------------------------------------------------------
% - Delta          : 1-3 Hz
% - Theta          : 4-7 Hz
% - Alpha          : 8-12 Hz
% - Beta1          : 13-29 Hz
% - Beta2          : 30-39 Hz
% - Gamma          : 40-69 Hz
% - HFB            : 70-170 Hz
% - RippleBand     : 80-250Hz
% - FastRippleBand : 250-500Hz
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190511
% zhaobaotian0220@foxmail.com

if isempty(obj.iEEG_MEEG)
    error('Please load iEEG_MEEG for filter')
end
if isempty(obj.BandPassFreq)
    disp(' - Delta          : 1-3 Hz  ')
    disp(' - Theta          : 4-7 Hz  ')
    disp(' - Alpha          : 8-12 Hz ')
    disp(' - Beta1          : 13-20 Hz')
    disp(' - Beta2          : 21-35 Hz')
    disp(' - Gamma          : 36-69 Hz')
    disp(' - HFB            : 70-170 Hz')
    disp(' - RippleBand     : 80-250Hz')
    disp(' - FastRippleBand : 250-500Hz')
    error('Please define band pass filter cut off frequencies, e.g. obj.BandPassFreq = [70 170]')
end

for i = 1:length(obj.iEEG_MEEG)
    clear S
    S.D              = obj.iEEG_MEEG{i};
    S.band           = 'bandpass';
    S.order          = 5;
    S.freq           = obj.BandPassFreq;
    S.prefix         = num2str(obj.BandPassFreq);
    obj.iEEG_MEEG{i} = spm_eeg_filter(S);
end
end
