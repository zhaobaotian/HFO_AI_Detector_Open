function [D_BipM,montage_file] = SPM_bipolar_montage(D,prefix)
%SPM_BIPOLAR_MONTAGE make bipolar montage for the MEEG object
% Baotian @ Beijing 20180821

% initialize spm EEG module
spm('defaults', 'EEG');

if nargin < 1 || isempty(D)
    D = spm_eeg_load;
end
if nargin < 2 || isempty(prefix)
    % add prefix to the converted file, by default 'spmeeg_'
    prefix = 'BipM_';
end

%Create bipolar for HFO and spike detection
Channel_labels_Raw = D.chanlabels;
% Find element which is not number in each label
% Channel_labels_Init = cellfun(@(x) cell2mat(regexp(x,'[^0-9]','match')),Channel_labels_Raw);
Channel_labels_Init = cellfun(@(x) cell2mat(regexp(x,'[^0-9]','match')),Channel_labels_Raw,'UniformOutput',0);
Electrode_num = length(unique(Channel_labels_Init));
[Electrode_Name,~,b] = unique(Channel_labels_Init,'stable');
% Initialize the montage matrix
tra = zeros(length(D.chanlabels) - Electrode_num,length(D.chanlabels));
labelorg = Channel_labels_Raw;
labelnew = cell(length(labelorg)-Electrode_num,1)';
% create montage matrix
Channel_ind_new = 1;
for i = 1:Electrode_num
    Electrode_Contacts = length(b(b == i));
    for j = 1:Electrode_Contacts-1
        name1 = strcat(Electrode_Name{i},num2str(j));
        name2 = strcat(Electrode_Name{i},num2str(j+1));
        labelnew{1,Channel_ind_new}=sprintf('%s-%s',name1,name2);
        % locate this two channels
        [~,Locb1] = ismember(name1,Channel_labels_Raw);
        [~,Locb2] = ismember(name2,Channel_labels_Raw);
        tra(Channel_ind_new,Locb1) = 1;
        tra(Channel_ind_new,Locb2) = -1;
        Channel_ind_new = Channel_ind_new + 1;
    end
end
montage.tra = tra;
montage.labelnew = labelnew;
montage.labelorg = labelorg;
% spm_eeg_montage_ui(montage)
montage_file = montage;
save('Bipolar_Montage_file','montage');

%  fields of S:
S.D = D;
S.montage  = montage;
S.updatehistory  = 1;
S.prefix         = prefix;
D_BipM = spm_eeg_montage(S);

D_BipM = chantype(D_BipM,'all','EEG');
save(D_BipM)

end

