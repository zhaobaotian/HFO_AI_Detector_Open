function SPMEEGPlotThreshold(D,ChannelIndex,ThresholdFilter)

TimeAxis = D.time;
Traces = squeeze(D(ChannelIndex,:,1));
Labels = D.chanlabels(ChannelIndex);

ThresholdLine = repelem(ThresholdFilter,D.nsamples)';
% visualization WinCenters
plotECG(TimeAxis,[Traces' ThresholdLine])
end