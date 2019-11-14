function SPMEEGPlotEvent(D,ChannelIndex,EventFile)

fileID = fopen(EventFile);
MarkersAll = textscan(fileID,'%f32   %s','HeaderLines',1);
fclose(fileID);

TimeAxis = D.time;
Traces = squeeze(D(ChannelIndex,:,1));
Labels = D.chanlabels(ChannelIndex);
Thresholds = rms(Traces);

WinCentersLine = repelem(0,D.nsamples);
DetectTimePoint = round(MarkersAll{1} * D.fsample);

for i = 1:D.nsamples
    if ismember(i,DetectTimePoint)
        WinCentersLine(i) = Thresholds(1)*2;
        WinCentersLine(i+1) = -Thresholds(1)*2;
    end
end
WinCentersLine = WinCentersLine';

% visualization WinCenters
plotECG(TimeAxis,[Traces' WinCentersLine])
end
% D = spm_eeg_load
% EventFile = "A'1- SNR 5dB - #1.txt";