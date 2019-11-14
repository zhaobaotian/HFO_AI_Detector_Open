function ThreshBinaryMask(Nifti,threshold,prefix)

% Read information from volumes
RawMaskinfo = spm_vol(Nifti);
RawMask = spm_read_vols(RawMaskinfo);

% Threshold the raw mask
ThreshMask = RawMask > threshold;
% Rename the new mask file
RawMaskinfo.fname = [prefix num2str(threshold) RawMaskinfo.fname];

% Write the binary Mask in disk
RawInfor = niftiinfo(Nifti);
RawMat = niftiread(RawInfor);
RawMat(:,:,:) = ThreshMask;
RawInfor.MultiplicativeScaling = 1;
niftiwrite(RawMat,RawMaskinfo.fname,RawInfor)

end

