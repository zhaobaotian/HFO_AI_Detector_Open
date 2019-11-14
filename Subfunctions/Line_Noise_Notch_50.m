function [D_f] = Line_Noise_Notch_50(D,prefix)
%LINE_NOISE_NOTCH_50 bandstop filter of 50Hz and its its higher harmonics
%below 500Hz

% initialize spm EEG module
spm('defaults', 'EEG');

if nargin < 1 || isempty(D)
    D = spm_eeg_load;
end
if nargin < 2 || isempty(prefix)
    % add prefix to the converted file, by default 'spmeeg_'
    prefix = 'Notch50_';
end

for i = 1:9
    % 50Hz and its its higher harmonics below 500Hz
    if i == 9
        S.D  = D;
        S.band  = 'stop';
        S.freq  = [50*i-1 50*i+1];
        S.order = 5;
        S.prefix = prefix;
        D_f = spm_eeg_filter(S); % D is filtered here
    else
        S.D  = D;
        S.band  = 'stop';
        S.freq  = [50*i-1 50*i+1];
        S.order = 5;
        S.prefix = [];
        D_f = spm_eeg_filter(S); % D is filtered here
    end    
end

