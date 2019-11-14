function obj = FinalizedEDF(obj)

obj.BipolarWhiteMatterLoc = zeros([length(obj.BipolarElectrodeName) 1]);
WhiteBrainChannels = obj.ElectrodeName(setdiff(find(obj.WhiteMatterLoc),find(obj.OutBrain)));


for i = 1:length(obj.BipolarElectrodeName)
    WhiteBrainChannelsCounter = 0;
    for j = 1:length(WhiteBrainChannels)
        if contains(obj.BipolarElectrodeName{i},WhiteBrainChannels{j})
            WhiteBrainChannelsCounter = WhiteBrainChannelsCounter + 1;
        end
    end
    if WhiteBrainChannelsCounter == 2
        obj.BipolarWhiteMatterLoc(i) = 1;
    end
end

% BipolarRMS for all bipolar channels
LowRMSBipolarChannels = obj.BipolarRMSElectrodeName(find(~obj.BipolarEEGTraceLabel));
obj.BipolarEEGTraceLabelAll = zeros([length(obj.BipolarElectrodeName) 1]);
for i = 1:length(obj.BipolarElectrodeName)
    if contains(obj.BipolarElectrodeName{i},LowRMSBipolarChannels)
        obj.BipolarEEGTraceLabelAll(i) = 1;
    end
end

% Extreme amplitude for all bipolar channels
ExtAmpBipolarChannels = obj.BipolarRMSElectrodeName(find(obj.BipolarEEGTraceExtAmpLabel));
obj.BipolarEEGTraceExtAmpLabelAll = zeros([length(obj.BipolarElectrodeName) 1]);
for i = 1:length(obj.BipolarElectrodeName)
    if contains(obj.BipolarElectrodeName{i},ExtAmpBipolarChannels)
        obj.BipolarEEGTraceExtAmpLabelAll(i) = 1;
    end
end

obj.BipolarInclusion = and(and(~obj.BipolarOutBrain,or(~obj.BipolarWhiteMatterLoc,~obj.BipolarEEGTraceLabelAll)),...
                           ~obj.BipolarEEGTraceExtAmpLabelAll);
% Write the excel file
% Write the channel information in excel
FileName = 'ChannelsInclusion.xlsx';
Titles = {'BipolarChannels','OutBrain','WhiteMatter','LowRMS','ExtremeAmplitude','Inclusion'};

% Write content
xlswrite(FileName,Titles,1,'A1')
xlswrite(FileName,obj.BipolarElectrodeName,1,'A2')
xlswrite(FileName,obj.BipolarOutBrain,1,'B2')
xlswrite(FileName,obj.BipolarWhiteMatterLoc,1,'C2')
xlswrite(FileName,obj.BipolarEEGTraceLabelAll,1,'D2')
xlswrite(FileName,obj.BipolarEEGTraceExtAmpLabelAll,1,'E2')
xlswrite(FileName,single(obj.BipolarInclusion),1,'F2')

% Crop the MEEG using the above information
% Reduce channels
D = obj.iEEG.iEEG_MEEG{1};
clear S
S.D = D;
S.channels = obj.BipolarElectrodeName(obj.BipolarInclusion); 
D = spm_eeg_crop(S);
obj.iEEG.iEEG_MEEG{1} = D;

% Write the final EDF
% You can also use EEGlab GUI to export the EDF file
SPMEEG2EDFConvert(D)

end

