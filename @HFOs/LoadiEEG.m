function [obj] = LoadiEEG(obj,SPMEEG)

if nargin < 2 || isempty(SPMEEG)
    SPMEEG = spm_select();
end

obj.iEEGRaw = spm_eeg_load(SPMEEG);

end

