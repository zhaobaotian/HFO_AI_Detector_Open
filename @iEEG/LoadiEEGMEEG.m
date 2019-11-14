function obj = LoadiEEGMEEG(obj)
%LoadiEEGMEEG Load iEEG object
% FORMAT: obj = LoadiEEGMEEG(obj)
% Input:
%       obj:  iEEG object need to load iEEG_MEEG
% Output:
%       obj:  iEEG object loaded with iEEG_MEEG
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190507
% zhaobaotian0220@foxmail.com

if ~isempty(obj.iEEG_MEEG)
    warning('iEEG_MEEG is not empty and will be erased and reloaded')
end

obj.iEEG_MEEG = [];
[filename, path]       = uigetfile('*.mat','Please select MEEG mat file to load','MultiSelect','on');
if ischar(filename)
    filename_full      = [path filename];
    obj.iEEG_MEEG{1} = spm_eeg_load(filename_full);
elseif iscell(filename)
    filename_full = cellfun(@(x) [path x],filename,'UniformOutput',false);
    for i = 1:length(filename_full)
        obj.iEEG_MEEG{i} = spm_eeg_load(filename_full{i});
    end   
else
    error('Please select proper MEEG mat files')
end
end
