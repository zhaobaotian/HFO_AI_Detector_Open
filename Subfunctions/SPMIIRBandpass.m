function [D_HighPass] = SPMIIRBandpass(D,prefix,type,order,freq)

clear S
S.D  = D;
S.band  = 'bandpass';
S.freq  = freq;
%  Optional fields:
S.type  = type;
S.order = order;
S.prefix = prefix;
D_HighPass = spm_eeg_filter(S); % D is filtered here

end