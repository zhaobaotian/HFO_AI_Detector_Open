function obj = WriteNIfTICandidates(obj)

SelectedHFOcountsFinal = obj.HFOCountsCandidates;
SelectedChannelLabels  = obj.SelectedBipolarChannels;
SelectedHFOcountsFinal = (SelectedHFOcountsFinal/max(SelectedHFOcountsFinal)) * 1000;
ContactsPostionsNewijk = obj.SelectedBipolarElectrodeIJK;
Radius = obj.BipolarElectrodeCenterRadius;
infoFST1 = niftiinfo(obj.AnatFile);
T1data = niftiread(infoFST1);

HFOmask = zeros(length(SelectedChannelLabels),size(T1data,1),size(T1data,2),size(T1data,3));
for i = 1:length(SelectedChannelLabels)
    T1data(:,:,:) = 0;
    T1data(ContactsPostionsNewijk(i,1)-Radius:ContactsPostionsNewijk(i,1)+Radius,...
        ContactsPostionsNewijk(i,2)-Radius:ContactsPostionsNewijk(i,2)+Radius,...
        ContactsPostionsNewijk(i,3)-Radius:ContactsPostionsNewijk(i,3)+Radius) = SelectedHFOcountsFinal(i);
    
    HFOmask(i,:,:,:) = T1data;
end

HFOmaskFinal = single(squeeze(sum(HFOmask)))./single(obj.BipolarElectrodeMask);
HFOmaskFinal(isnan(HFOmaskFinal)) = 0;
HFOmaskFinal = int16(HFOmaskFinal);
% % Using SPM function
% Header = spm_vol(obj.AnatFile);
% Header.fname = 'CandidateHFOs.nii';
% Header = rmfield(Header,'pinfo');
% spm_write_vol(Header,HFOmaskFinal)

infoFST1.MultiplicativeScaling = 1;
infoFST1.Datatype = 'int16';
infoFST1.Description = 'CandidateHFOs';
FileName = 'CandidateHFOs';

niftiwrite(HFOmaskFinal,FileName,infoFST1)

% obj.BipolarElectrodesMaskHFOs     = HFOmaskFinal;
obj.CandiadteHFOsFile = [FileName '.nii'];
end

