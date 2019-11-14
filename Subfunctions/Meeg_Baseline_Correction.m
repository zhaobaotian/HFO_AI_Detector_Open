function [D_BC] = Meeg_Baseline_Correction(D,prefix)
%MEEG_BASELINE_CORRECTION baseline correction for the whole time series
%also known as DC offset

% initialize spm EEG module
spm('defaults', 'EEG');

if nargin < 1 || isempty(D)
    D = spm_eeg_load;
end
if nargin < 2 || isempty(prefix)
    % add prefix to the converted file, by default 'spmeeg_'
    prefix = 'bc_';
end

S.D = D;
S.prefix = prefix;
D_BC = spm_eeg_bc(S);
end

