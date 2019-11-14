function obj = Montage_Avg(obj)
%Montage_Avg Rereferece to the common averaged potentials excluding the bad
%channels
% FORMAT: obj = Montage_Avg(obj)
% Input:
%       obj: Should be bad channel detected and with bad channel labels
% Output:
%       obj: iEEG object loaded with MEEG
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190507
% zhaobaotian0220@foxmail.com

for i = 1:length(obj.iEEG_MEEG)
    AverageChannels = [1:obj.iEEG_MEEG{i}.nchannels];
    BadChannelInd = obj.iEEG_MEEG{i}.badchannels;
    AverageChannels(BadChannelInd) = [];
    [obj.iEEG_MEEG{i},~] = SPM_Manual_Montage(obj.iEEG_MEEG{i},'AvgM',AverageChannels);
    % label bad channel
    obj.iEEG_MEEG{i} = obj.iEEG_MEEG{i}.badchannels([BadChannelInd],1);
    save(obj.iEEG_MEEG{i})
end
end

