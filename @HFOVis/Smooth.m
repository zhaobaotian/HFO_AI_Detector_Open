function obj = Smooth(obj)

spm_smooth(obj.BipolarElectrodeMaskFile,'S4_BipolarElectrodesMask.nii',[4 4 4])
spm_smooth(obj.CandiadteHFOsFile,'S4_CandidateHFOs.nii',[4 4 4])
spm_smooth(obj.QualityHFOsFile,'S4_QualityHFOs.nii',[4 4 4])
spm_smooth(obj.QualityFRHFOsFile,'S4_QualityFRHFOs.nii',[4 4 4])

end

