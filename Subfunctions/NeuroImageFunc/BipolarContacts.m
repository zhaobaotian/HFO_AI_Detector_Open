function [labelnewVert,ContactsNewPos] = BipolarContacts(NameFile,PosFile)

ContactsRawNames = importdata(NameFile);
ContactsRawPos   = importdata(PosFile);

% Find element which is not number in each label
Channel_labels_Init = cellfun(@(x) cell2mat(regexp(x,'[^0-9]','match')),ContactsRawNames,'UniformOutput',0);
Electrode_num = length(unique(Channel_labels_Init));
[Electrode_Name,~,b] = unique(Channel_labels_Init,'stable');
% Make new contact names
labelorg = ContactsRawNames;
labelnew = cell(length(labelorg)-Electrode_num,1)';

% Initialize the montage matrix
tra = zeros(length(ContactsRawNames) - Electrode_num,length(ContactsRawNames));
% create montage matrix
Channel_ind_new = 1;
for i = 1:Electrode_num
    Electrode_Contacts = length(b(b == i));
    for j = 1:Electrode_Contacts-1
        name1 = strcat(Electrode_Name{i},num2str(j));
        name2 = strcat(Electrode_Name{i},num2str(j+1));
        labelnew{1,Channel_ind_new}=sprintf('%s-%s',name1,name2);
        % locate this two channels
        [~,Locb1] = ismember(name1,ContactsRawNames);
        [~,Locb2] = ismember(name2,ContactsRawNames);
        tra(Channel_ind_new,Locb1) = 1;
        tra(Channel_ind_new,Locb2) = -1;
        Channel_ind_new = Channel_ind_new + 1;
    end
end
labelnewVert = labelnew';
% Write the new bipolar name files
fileID = fopen(['Bipolar_' NameFile],'w');
fprintf(fileID,'%s\n',labelnew{:});
fclose(fileID);

% Calculate the coordinates of the middle point
for i = 1:length(labelnew)
    AInd = find(tra(i,:) == 1);
    BInd = find(tra(i,:) == -1);
    
    A = ContactsRawPos(AInd,:);
    B = ContactsRawPos(BInd,:);
    ContactsNewPos(i,:) = (A + B)./2;
end

% Double check
if length(labelnew) ~= size(ContactsNewPos,1)
    error('Bipolar label and coordinates does not match!')
end
ContactsNewPosVert = ContactsNewPos';
% Write the new position files
fileID = fopen(['Bipolar_' PosFile],'w');
fprintf(fileID,'%f %f %f\n',ContactsNewPosVert);
fclose(fileID);

end

