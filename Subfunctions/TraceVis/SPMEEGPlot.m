function SPMEEGPlot(D,ChannelIndex)

TimeAxis = D.time;
Traces = squeeze(D(ChannelIndex,:,1));
Labels = D.chanlabels(ChannelIndex);
plotECG(TimeAxis,Traces,'AutoStackSignals',Labels)

end
