function obj = SaveResults(obj)

% Write the excel file
% Write the channel information in excel
FileName = 'HFOsCounts.xlsx';
Titles = {'BipolarChannels',...
    'CandidatesHFOsCounts','CandidatesHFOsFreq(/min)',...
    'qualityHFOsCounts','qualityHFOsFreq(/min)',...
    'qualityFRHFOsCounts','qualityFRHFOsFreq(/min)'};

% Write content
xlswrite(FileName,Titles,1,'A1')
xlswrite(FileName,obj.SelectedBipolarChannels,1,'A2')

xlswrite(FileName,obj.HFOCountsCandidates,1,'B2')
xlswrite(FileName,obj.HFOCountsCandidates/obj.Duration,1,'C2')

xlswrite(FileName,obj.HFOCountsQualityHFOs,1,'D2')
xlswrite(FileName,obj.HFOCountsQualityHFOs/obj.Duration,1,'E2')

xlswrite(FileName,obj.HFOCountsQualityFRHFOs,1,'F2')
xlswrite(FileName,obj.HFOCountsQualityFRHFOs/obj.Duration,1,'G2')

end

