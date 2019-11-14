function obj = DownSampling(obj,NewSamplingRate)
%DownSampling Down sample iEEG Data
% FORMAT: obj = DownSampling(obj,NewSampling)
% Input:
%       NewSampling:     New sampling rate, 1000Hz by default
% Output:
%       obj:             iEEG object.
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190505
% zhaobaotian0220@foxmail.com
if nargin < 2 || isempty(NewSamplingRate)
    NewSamplingRate = 1000;
end

if obj.iEEG_MEEG{1}.fsample < NewSamplingRate
    error('Raw sampling rate should be larger than new sampling rate')
end

% Down sample the iEEG data
if isempty(obj.iEEG_MEEG) && isempty(obj.Trigger_MEEG)
    error('Please convert and/or load the iEEG and/or trigger data first')
end

if ~isempty(obj.iEEG_MEEG)
    for i = 1:length(obj.iEEG_MEEG)
        % Down sample the iEEG data
        S.D              = obj.iEEG_MEEG{i};
        S.fsample_new    = NewSamplingRate;
        D                = spm_eeg_downsample(S);
        obj.iEEG_MEEG{i} = D;
    end
end
if ~isempty(obj.Trigger_MEEG)
    for i = 1:length(obj.Trigger_MEEG)
        % Down sample the trigger data
        S.D                 = obj.Trigger_MEEG{i};
        S.fsample_new       = NewSamplingRate;
        D                   = spm_eeg_downsample(S);
        obj.Trigger_MEEG{i} = D;
    end
end
end

