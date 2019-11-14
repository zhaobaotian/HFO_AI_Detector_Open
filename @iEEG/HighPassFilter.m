function obj = HighPassFilter(obj)
%HighPassFilter High pass filter the signal, suppose to be done before
%epoch. Can be used to remove some trend etc.
% FORMAT: obj = HighPassFilter(obj)
% Input:
%       obj: iEEG object loaded with properties: iEEG MEEG and HighPassFreq
% Output:
%       obj: iEEG object with high pass filtered iEEG property
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190511
% zhaobaotian0220@foxmail.com

if isempty(obj.iEEG_MEEG)
    error('Please load iEEG_MEEG for filter')
end
if isempty(obj.HighPassFreq)
    warning('Please define high pass filter cut off frequency, e.g. obj.HighPassFreq = 1')
    warning('Low pass filter is set to 1Hz')
    obj.HighPassFreq = 1;
end

for i = 1:length(obj.iEEG_MEEG)
    clear S
    S.D              = obj.iEEG_MEEG{i};
    S.band           = 'high';
    S.order          = 3;
    S.freq           = obj.HighPassFreq;
    S.prefix         = 'HiPf_';
    obj.iEEG_MEEG{i} = spm_eeg_filter(S);
end
end

