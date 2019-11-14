function obj = MakeGreyMatterMask(obj)

% Segment grey matter
SegmentGrey(obj.AnatFile,obj.MainPath)

% Binary the probability grey mask
Nifti = dir('c1*.nii');
Nifti = Nifti.name;
threshold = obj.GreyMatterThreshold;
prefix = 'gmsk';
ThreshBinaryMask(Nifti,threshold,prefix)

greyMask = dir('gmsk*.nii');
obj.GreyMask = greyMask.name;

end

