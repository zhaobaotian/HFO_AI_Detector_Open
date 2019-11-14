function SpatialNorm(anat,resample,MainPath)
% List of open inputs
% Normalise: Estimate & Write: Image to Align - cfg_files
% Normalise: Estimate & Write: Images to Write - cfg_files
nrun = 1; % enter the number of runs here
jobfile = {[MainPath filesep 'Subfunctions' filesep 'SpatialNorm_job.m']};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(2, nrun);
for crun = 1:nrun
    inputs{1, crun} = cellstr(anat); % Normalise: Estimate & Write: Image to Align - cfg_files
    inputs{2, crun} = cellstr(resample); % Normalise: Estimate & Write: Images to Write - cfg_files
end
spm('defaults', 'PET');
spm_jobman('run', jobs, inputs{:});

end