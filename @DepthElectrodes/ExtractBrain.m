function obj = ExtractBrain(obj)
% Brain extraction using ROBEX
ROBEX = [obj.MainPath,filesep,'Externals\ROBEX\ROBEX.exe'];
ROBEXFolder = [obj.MainPath,filesep,'Externals\ROBEX\'];
copyfile(obj.AnatFile,ROBEXFolder) 
cd(ROBEXFolder)

[~,Filename,ext] = fileparts(obj.AnatFile);

system([ROBEX,' ',[Filename ext],' ','Stripped_',Filename,ext])
delete([Filename ext])

Stripped = dir('Stripped_*.nii');


movefile(Stripped.name,obj.subPath)
cd(obj.subPath)
obj.StrippedBrain = Stripped.name;
disp('---------------Brain Extraction DONE!-------------')

end
