function obj = Montage_Bip(obj)
%Montage_Bip Make bipolar montage after renaming
% FORMAT: obj = Montage_Bip(obj)
% Input:
%       obj: Shoule be renamed before making bipolar montage
% Output:
%       obj: iEEG object loaded with MEEG and bipolar montaged
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190507
% zhaobaotian0220@foxmail.com

% Should check the number of electrode and contact before and after making
% bipolar montage...

for i = 1:length(obj.iEEG_MEEG)
    S = obj.iEEG_MEEG{i};
    obj.iEEG_MEEG{i} = SPM_bipolar_montage(S,'BipM_');
end
end

