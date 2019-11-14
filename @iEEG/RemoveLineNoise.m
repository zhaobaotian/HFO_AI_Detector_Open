function obj = RemoveLineNoise(obj,LineNoise,MaxFrequency)
%RemoveLineNoise Notch filter the line noise and its harmonics until 1/3
%sampling rate
% FORMAT: obj = RemoveLineNoise(obj,LineNoise)
% Input:
%       LineNoise:    50Hz for Chinese data.
%       MaxFrequency: Max frequency of the frequency band of interest.
% Output:
%       obj:        Line removed object
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190505
% zhaobaotian0220@foxmail.com

if isempty(obj.iEEG_MEEG)
    error('Please convert and load the edf files first')
end

if nargin < 2 || isempty(LineNoise)
    warning('Please set proper amplifier type, e.g. NK, Others')
    LineNoise = 50;
    disp('Line noise set to 50Hz')
end

if nargin < 3 || isempty(MaxFrequency)
    warning('Please set proper max frequency')
    MaxFrequency = obj.iEEG_MEEG{1}.fsample/3;
    disp('Max frequency set to 1/3 of sampling rate')
end

MaxIteration = floor(MaxFrequency/LineNoise);
% Notch filter each file for all possible line noise and harmonics 
for i = 1:length(obj.iEEG_MEEG)
    for j = 1:MaxIteration
        S.D              = obj.iEEG_MEEG{i};
        S.band           = 'stop';
        S.freq           = [50*j-3 50*j+3];
        S.order          = 3;
        S.prefix         = 'f';
        
        D = spm_eeg_filter(S);
        obj.iEEG_MEEG{i} = D;
    end
end
end

