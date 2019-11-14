function obj = TFTransform(obj)
%TFTransform Time frequency transform using SPM wavelet function
%
% FORMAT: obj = TFTransform(obj)
% Input:
%       obj: iEEG object loaded with properties: iEEG MEEG and HighPassFreq
% Output:
%       obj: iEEG object with high pass filtered iEEG property
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190511
% zhaobaotian0220@foxmail.com

if isempty(obj.iEEG_MEEG)
    error('Please load iEEG_MEEG for TF transform')
end
if isempty(obj.Frequencies)
    warning('Please define frequencies of interest for TF transform, e.g. obj.Frequencies = [1:50]')
    warning('Frequencies of interest are set to log spaced values between 1Hz and 200Hz')
    obj.Frequencies = [1:12, 13:2:20 21:3:36, 40:5:65, 70:10:200]; % Arbitrary, like log spaced but not
    % frequencies
%     obj.Frequencies = [1 1.1 1.3 1.5 1.7 1.9 2.2 2.5 2.8 3.2...
%                        3.6 4.1 4.7 5.4 6.1 7.1 ...
%                        7.9 9 10.2 11.6 ...
%                        13.3 15.1 17.1 19.5 ...
%                        22.2 25.3 28.8 32.8 37.3 ...
%                        42.4 48.3 55 62.5 ...
%                        71.1 81 92.1 104.8 119.3 135.7 154.4 175.7 200]; 
%                        Does not work for fractions, frequencies must be
%                        integers
end

for i = 1:length(obj.iEEG_MEEG)
    clear S
    S.D                 = obj.iEEG_MEEG{i};
    S.channels          = 'All';
    S.frequencies       = obj.Frequencies;
    S.method            = 'morlet';
    S.phase             = 0;
    S.prefix            = [];
    obj.iEEG_MEEG{i}    = spm_eeg_tf(S);
end   
    
end