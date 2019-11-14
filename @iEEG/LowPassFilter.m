function obj = LowPassFilter(obj)
%LowPassFilter Low pass filter the signal, suppose to be done before epoch
% FORMAT: obj = LowPassFilter(obj)
% Input:
%       obj: iEEG object loaded with properties: iEEG MEEG and LowPassFreq
% Output:
%       obj: iEEG object with low pass filtered iEEG property
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190511
% zhaobaotian0220@foxmail.com

if isempty(obj.iEEG_MEEG)
    error('Please load iEEG_MEEG for filter')
end
if isempty(obj.LowPassFreq)
    warning('Please define low pass filter cut off frequency, e.g. obj.LowPassFreq = 300')
    warning('Low pass filter is set to 1/3 sampling rate (Hz)')
    obj.LowPassFreq = floor(obj.iEEG_MEEG{1}.fsample/3);
end

for i = 1:length(obj.iEEG_MEEG)
    clear S
    S.D              = obj.iEEG_MEEG{i};
    S.band           = 'low';
    S.order          = 5;
    S.freq           = obj.LowPassFreq;
    S.prefix         = 'LoPf_';
    obj.iEEG_MEEG{i} = spm_eeg_filter(S);
end

end

