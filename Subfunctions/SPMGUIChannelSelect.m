function DSelectedChannel = SPMGUIChannelSelect(D)

% read edf header using function in field trip
edf_header = D.chanlabels';
[index_to_keep,~] = listdlg('ListString',edf_header,'PromptString','Select Channels to Keep' );
ChannelToKeep = edf_header(index_to_keep);

clear S
S.D = D;
S.channels = ChannelToKeep; 
DSelectedChannel = spm_eeg_crop(S);

end

