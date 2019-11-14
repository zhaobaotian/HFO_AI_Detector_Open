function obj = LabelWhiteMatterElectrodes(obj)

% Transform the coordinates
% !!! Make sure the T1 is the same as the one in Branvisa database !!! %
infoFST1 = niftiinfo(obj.GreyMask);
ContactsPostionsNewijk = obj.ContactsPostionsIJK;

GreyMask = niftiread(infoFST1);

Radius = obj.ElectrodeRadius;
WholeVoxel = (Radius*2 + 1)^3;


for i = 1:length(obj.ElectrodeName)
    Voxels = GreyMask(ContactsPostionsNewijk(i,1)-Radius:ContactsPostionsNewijk(i,1)+Radius,...
        ContactsPostionsNewijk(i,2)-Radius:ContactsPostionsNewijk(i,2)+Radius,...
        ContactsPostionsNewijk(i,3)-Radius:ContactsPostionsNewijk(i,3)+Radius);
    obj.ElectrodeGreyVoxel(i) = sum(sum(sum(Voxels)));
    obj.ElectrodeGreyPercentage(i) = sum(sum(sum(Voxels)))/WholeVoxel;
end

obj.ElectrodeGreyPercentage = obj.ElectrodeGreyPercentage';
obj.ElectrodeGreyVoxel = obj.ElectrodeGreyVoxel';

% Judge the white matter location using threshold
for i = 1:length(obj.ElectrodeName)
    if obj.ElectrodeGreyPercentage(i) <= obj.WhiteMatterPercentageThreshold
        obj.WhiteMatterLoc(i) = 1;
    elseif obj.ElectrodeGreyPercentage(i) > obj.WhiteMatterPercentageThreshold
        obj.WhiteMatterLoc(i) = 0;
    end
end
obj.WhiteMatterLoc = obj.WhiteMatterLoc';

end
