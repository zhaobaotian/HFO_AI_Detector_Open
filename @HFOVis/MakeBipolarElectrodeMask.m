function obj = MakeBipolarElectrodeMask(obj)

% Find the positions of all bipolar centers
[~,NameFile,NameFileExt] = fileparts(obj.ElectrodeNameFile);
[~,PosFile,PosFileExt]  = fileparts(obj.ElectrodePosFile);

NameFile = [NameFile NameFileExt];
PosFile = [PosFile PosFileExt];
[obj.BipolarElectrodeNametxt,obj.BipolarElectrodePostxt] = BipolarContacts(NameFile,PosFile);

% Include only those selected channels
SelectedChannelLabels = obj.BipolarElectrodeName(obj.BipolarInclusion);
for i = 1:length(SelectedChannelLabels)
    location = find(contains(obj.BipolarElectrodeNametxt,SelectedChannelLabels{i}));
    SelectedChannelPos(i,:) = obj.BipolarElectrodePostxt(location,:);    
end

% Make the mask
% !!! Make sure the T1 is the same as the one in Branvisa database !!! %
% transform the NEW coordiantes to slice coordinate system
infoFST1 = niftiinfo(obj.AnatFile);
M_FS = infoFST1.Transform.T';

% Read contacts raw coordinates
ContactsPos = SelectedChannelPos;
ContactsPos(:,4) = 1;

ContactsPostionsNewijk = zeros(size(ContactsPos,1),4);

for i = 1:size(ContactsPos,1)
    ContactsPostionsNewijk(i,:) = inv(M_FS)*ContactsPos(i,:)';
end

ContactsPostionsNewijk = ContactsPostionsNewijk(:,1:3);
ContactsPostionsNewijk = round(ContactsPostionsNewijk);

obj.SelectedBipolarElectrodeIJK = ContactsPostionsNewijk;

T1data = niftiread(infoFST1);

Radius = obj.BipolarElectrodeCenterRadius;

BipolarMask = zeros(length(SelectedChannelLabels),size(T1data,1),size(T1data,2),size(T1data,3));
for i = 1:length(SelectedChannelLabels)
    T1data(:,:,:) = 0;
    T1data(ContactsPostionsNewijk(i,1)-Radius:ContactsPostionsNewijk(i,1)+Radius,...
        ContactsPostionsNewijk(i,2)-Radius:ContactsPostionsNewijk(i,2)+Radius,...
        ContactsPostionsNewijk(i,3)-Radius:ContactsPostionsNewijk(i,3)+Radius) = 1;
    
    BipolarMask(i,:,:,:) = T1data;
end

% sum the masks and write nifti
BipolarMask = squeeze(sum(BipolarMask));
infoFST1.MultiplicativeScaling = 1;
BipolarMask = int16(BipolarMask);

BinaryBipolarMask = BipolarMask;
BinaryBipolarMask(BinaryBipolarMask > 1) = 1;
FileName = 'BipolarElectrodesMask';
niftiwrite(BinaryBipolarMask,FileName,infoFST1)
% % Using SPM function
% Header = spm_vol(obj.AnatFile)
% Header.fname = 'BipolarElectrodesMaskSPM.nii';
% rmfield(Header,'pinfo')
% spm_write_vol(Header,BinaryBipolarMask)

obj.BipolarElectrodeMask     = BipolarMask;
obj.BipolarElectrodeMaskFile = [FileName '.nii'];

end
