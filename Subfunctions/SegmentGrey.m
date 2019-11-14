function SegmentGrey(anat,MainPath)
% List of open inputs
% Segment: Volumes - cfg_files
nrun = 1; % enter the number of runs here
jobfile = {[MainPath filesep 'Subfunctions' filesep 'SegmentGrey_job.m']};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(1, nrun);
for crun = 1:nrun
    inputs{1, crun} = cellstr(anat); % Segment: Volumes - cfg_files
end
spm('defaults', 'PET');
spm_jobman('run', jobs, inputs{:});

end