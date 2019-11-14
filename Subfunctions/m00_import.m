function EEG = m00_import(file_name)
% this function is used to import .m00 file exported from Neuroworkbench,
% when you export data from the NeuroworkBench, export as ASCII format so
% that you can get the .m00 file, remember to selected the clip you are
% interested in.
EEG = importdata(file_name);
EEG.data = EEG.data';
EEG.labels = EEG.colheaders';
EEG = rmfield(EEG,'colheaders');
header = EEG.textdata(1,1);
header = cell2mat(header);
header = deblank(header);
header = regexp(header, '\s+', 'split');
for i = 1:length(header)
    eval(['header',num2str(i), '=', 'char(','header(i)',')']); % convert cell to string
end
EEG.TimePoints = str2double(header1(cell2mat(regexp(header(1),'TimePoints=','end')) + 1:length(char(header(1))))); % locate and extract the number using regular expression; 
EEG.Channels = str2double(header2(cell2mat(regexp(header(2),'Channels=','end')) + 1:length(char(header(2))))); % locate and extract channel numbers
EEG.SamplingInterval = str2double(header4(cell2mat(regexp(header(4),'=','end')) + 1:length(char(header(4))))); % sampling intervel in ms
EEG.Recording_time = header6(cell2mat(regexp(header(6),'Time=','end')) + 1:length(char(header(6)))); % recording time point
EEG.srate = 1 / (EEG.SamplingInterval / 1000);
EEG = rmfield(EEG,'textdata');
%% delete the unrelevant channels like ECG & EEG
label_pattern = '[a-zA-Z]{1,2}.*[0-9]{1,2}.[a-zA-Z]{1,2}.*[0-9]{1,2}';
channel_in_use = [];
for i = 1:length(EEG.labels)
    if regexp(EEG.labels{i},label_pattern,'start') == 1;
        channel_in_use = [channel_in_use i];
    else
        channel_in_use = channel_in_use;
    end
end
% write the correct EEG data
EEG.data = EEG.data(channel_in_use,:);
EEG.labels = EEG.labels(channel_in_use);
EEG.Channels = length(channel_in_use);
end