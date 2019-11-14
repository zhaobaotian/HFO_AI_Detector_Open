function [D_HighPass] = SPMIIRHighpass(D,prefix,type,order,freq)

clear S
S.D  = D;
S.band  = 'high';
S.freq  = freq;
%  Optional fields:
S.type  = type;
S.order = order;
S.prefix = prefix;
D_HighPass = spm_eeg_filter(S); % D is filtered here

end