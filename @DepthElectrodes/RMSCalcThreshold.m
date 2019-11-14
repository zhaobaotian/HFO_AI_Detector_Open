function obj = RMSCalcThreshold(obj)


%% Exclude out brain bipolar channels
OutBrainChannels = obj.ElectrodeName(find(obj.OutBrain));
OutBrainChannelsCounter = 1;
OutBrainInd = [];
for i = 1:length(obj.BipolarElectrodeName)
    if contains(obj.BipolarElectrodeName{i},OutBrainChannels)
        OutBrainBipChannels{OutBrainChannelsCounter} = obj.BipolarElectrodeName{i};
        OutBrainChannelsCounter = OutBrainChannelsCounter + 1;
        OutBrainInd = [OutBrainInd i];
    end
end
RawElectrodeInd = [1:length(obj.BipolarElectrodeName)];
ChannelIndINBrain = setdiff(RawElectrodeInd,OutBrainInd);

obj.BipolarOutBrain = zeros([length(obj.BipolarElectrodeName),1]);
obj.BipolarOutBrain(OutBrainInd) = 1;

% Reduce channels
D = obj.iEEG.iEEG_MEEG{1};
clear S
S.D = D;
S.channels = obj.BipolarElectrodeName(ChannelIndINBrain); 
D = spm_eeg_crop(S);
obj.iEEG.iEEG_MEEG{1} = D;

obj.BipolarRMSElectrodeName = D.chanlabels';
%% Caculate RMS
% RMS threshold
for i = 1:D.nchannels
    % Demean first
    tempTrace = D(i,:,1) - mean(D(i,:,1));
    obj.BipolarRMS(i) = rms(tempTrace);
end
obj.BipolarRMS = obj.BipolarRMS';
%% Threshold RMS and label channels
RMSThreshold = prctile(obj.BipolarRMS,obj.WhiteMatterRMSThreshold*100);
for i = 1:D.nchannels
    if obj.BipolarRMS(i) > RMSThreshold
        obj.BipolarEEGTraceLabel(i) = 1;
    elseif obj.BipolarRMS(i) <= RMSThreshold
        obj.BipolarEEGTraceLabel(i) = 0;
    end
end
obj.BipolarEEGTraceLabel = obj.BipolarEEGTraceLabel';
end
