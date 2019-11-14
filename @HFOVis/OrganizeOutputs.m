function obj = OrganizeOutputs(obj)

mkdir('EDFs')
mkdir('SPMEEG')
mkdir('NIfTIs')
mkdir('Locations')
mkdir('Results')

% EDFs and their related files
EDFs = dir('*.edf');
EDFs = {EDFs.name};
for i = 1:length(EDFs)
    movefile(EDFs{i},'EDFs')
end
movefile('EDFChannels.mat','EDFs')

% SPMEEG and their related files
SPMEEG = dir('*.dat');
SPMEEG = {SPMEEG.name};
for i = 1:length(SPMEEG)
    movefile(SPMEEG{i},'SPMEEG')
    movefile([SPMEEG{i}(1:end - 4) '.mat'],'SPMEEG')
end
movefile('Bipolar_Montage_file.mat','SPMEEG')

% NIfTIs and their related files
NIfTIs = dir('*.nii');
NIfTIs = {NIfTIs.name};
for i = 1:length(NIfTIs)
    movefile(NIfTIs{i},'NIfTIs')
end
movefile('*seg8.mat','NIfTIs')

% Location files
movefile('*.txt','Locations')

% Results files
movefile('*.xlsx','Results')
movefile('ResultsAll.mat','Results')


end

