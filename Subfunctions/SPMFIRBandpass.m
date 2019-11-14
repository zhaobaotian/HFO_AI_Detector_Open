function [D_80_490] = SPMFIRBandpass(D,prefix,type,order,freq)
%BANDPASS_80_490 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 1 || isempty(D)
    D = spm_eeg_load;
end
if nargin < 2 || isempty(prefix)
    % add prefix to the converted file, by default 'bandp_80_490_'
    prefix = 'bandp_';
end
% NOTE: set the eeg type before you filter
% set parameters
clear S
S.D  = D;
S.band  = 'bandpass';
S.freq  = freq;
%  Optional fields:
S.type  =  type;
S.order = order;
S.prefix = prefix;
D_80_490 = spm_eeg_filter(S); % D is filtered here
end

