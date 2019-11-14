function [D_highpass] = SPMHighPass(D,prefix,type,order,freq)

% NOTE: set the eeg type before you filter
% set parameters
S.D  = D;
S.band  = 'high';
S.freq  = freq;
%  Optional fields:
S.type  =  type;
S.order = order;
S.prefix = prefix;

D_highpass = spm_eeg_filter(S); % D is filtered here
end