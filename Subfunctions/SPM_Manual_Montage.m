function [D_ManualM,montage_file] = SPM_Manual_Montage(D,prefix,RefChannels)
%UNTITLED manually select reference channel
%   If 2 or more channels are selected, the selected channels will be
%   averaged as common reference

% initialize spm EEG module
spm('defaults', 'EEG');

if nargin < 1 || isempty(D)
    D = spm_eeg_load;
end
if nargin < 2 || isempty(prefix)
    % add prefix to the converted file, by default 'spmeeg_'
    prefix = 'ManualM_';
end
if nargin < 2 || isempty(RefChannels)
    % add prefix to the converted file, by default 'spmeeg_'
    RefChannels = listdlg('ListString',D.chanlabels,'PromptString','Select Channels for Reference' );
end
Channel_labels_Raw = D.chanlabels;


% Initialize the montage matrix
tra = zeros(length(D.chanlabels));
tra(:,RefChannels) = -1/length(RefChannels);
labelorg = Channel_labels_Raw;
if length(RefChannels) == 1
    labelnew = cellfun(@(x) strcat(x,'-',Channel_labels_Raw{RefChannels}),...
        labelorg,'UniformOutput',0);
elseif length(RefChannels) > 1
    labelnew = cellfun(@(x) strcat(x,'-','Avg',num2str(length(RefChannels))),...
        labelorg,'UniformOutput',0);
end
% create montage matrix
for i = 1:D.nchannels
    tra(i,i) = 1 + tra(i,i);
end

montage.tra = tra;
montage.labelnew = labelnew;
montage.labelorg = labelorg;
spm_eeg_montage_ui(montage)
montage_file = montage;
save('Manual_Montage_file','montage');  

%  fields of S:
S.D = D;
S.montage  = montage;
S.updatehistory  = 1;
S.prefix         = prefix;
D_ManualM = spm_eeg_montage(S);

D_ManualM = chantype(D_ManualM,'all','EEG');
save(D_ManualM)

end

