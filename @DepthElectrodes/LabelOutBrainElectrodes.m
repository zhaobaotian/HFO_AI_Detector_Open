function obj = LabelOutBrainElectrodes(obj)
% Transform the coordinates
% !!! Make sure the T1 is the same as the one in Branvisa database !!! %

% transform the NEW coordiantes to slice coordinate system
infoFST1 = niftiinfo(obj.AnatFile);
M_FS = infoFST1.Transform.T';

% % Read contacts name
% ContactsName = obj.ElectrodeName;

% Read contacts raw coordinates
ContactsPos = obj.ElectrodePos;
ContactsPos(:,4) = 1;


ContactsPostionsNewijk = zeros(size(ContactsPos,1),4);

for i = 1:size(ContactsPos,1)
    ContactsPostionsNewijk(i,:) = inv(M_FS)*ContactsPos(i,:)';
end

ContactsPostionsNewijk = ContactsPostionsNewijk(:,1:3);
ContactsPostionsNewijk = round(ContactsPostionsNewijk);

obj.ContactsPostionsIJK = ContactsPostionsNewijk;

BrainMask = niftiread(obj.BrainMask);
for i = 1:length(obj.ElectrodeName)
    if BrainMask(ContactsPostionsNewijk(i,1),ContactsPostionsNewijk(i,2),ContactsPostionsNewijk(i,3)) == 1
        obj.OutBrain(i) = 0;
    elseif BrainMask(ContactsPostionsNewijk(i,1),ContactsPostionsNewijk(i,2),ContactsPostionsNewijk(i,3)) == 0
        obj.OutBrain(i) = 1;
    end
end

obj.OutBrain = obj.OutBrain';

end

