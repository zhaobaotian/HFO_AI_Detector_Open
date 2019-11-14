function obj = BinaryBrainMask(obj)

ExtractedBrain = niftiinfo(obj.StrippedBrain);

Brain = niftiread(ExtractedBrain);

BiBrain = Brain;
BiBrain(Brain ~= 0) = 1;

niftiwrite(BiBrain,'BrainMask.nii',ExtractedBrain)

obj.BrainMask = 'BrainMask.nii';

end

