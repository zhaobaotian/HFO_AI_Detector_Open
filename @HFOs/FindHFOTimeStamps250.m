function obj = FindHFOTimeStamps250(obj)

D = obj.iEEGBandPass250;
Thresholds = obj.ThresholdsALL250;
OnOffsetThreshold = Thresholds/obj.SDthreshold*3;

% initialize the output
obj.CandidateHFOsTimeStamps250 = cell(length(D.chanlabels),1);
nChannel = D.nchannels;
gap_thresh_counts = obj.GapThreshold*D.fsample;
DurThreshold = 6; % ms

for i = 1:nChannel
    Signal_temp = abs(D(i,:,1));
    PeakInd = find(Signal_temp >= Thresholds(i));
    ClusterGap = find(diff(PeakInd)>gap_thresh_counts);
    HFO_Events_Matrix = [];
    HFO_counter = 0;
    for j = 1:length(ClusterGap)
        if j == 1
            onset5 = PeakInd(1);
            offset5 = PeakInd(ClusterGap(j));
            
            OnsetVect = Signal_temp(1:onset5) > OnOffsetThreshold(i);
            onset3 = max(find(~OnsetVect));
            OffsetVect = Signal_temp(offset5:end) > OnOffsetThreshold(i);
            offset3 = min(find(~OffsetVect)) + offset5;
            
            PeakValue = max(Signal_temp(onset5:offset5));
            MaxPeakInd = find(Signal_temp(onset5:offset5)==PeakValue) + onset5 -1;
            if length(MaxPeakInd) > 1
                MaxPeakInd = MaxPeakInd(1);
            end
        elseif j == length(ClusterGap)
            onset5 = PeakInd(ClusterGap(j)+1);
            offset5 = PeakInd(end);
            
            OnsetVect = Signal_temp(1:onset5) > OnOffsetThreshold(i);
            onset3 = max(find(~OnsetVect));
            OffsetVect = Signal_temp(offset5:end) > OnOffsetThreshold(i);
            offset3 = min(find(~OffsetVect)) + offset5;
            
            PeakValue = max(Signal_temp(onset5:offset5));
            MaxPeakInd = find(Signal_temp(onset5:offset5)==PeakValue) + onset5 -1;
            if length(MaxPeakInd) > 1
                MaxPeakInd = MaxPeakInd(1);
            end
        else
            onset5 = PeakInd(ClusterGap(j)+1);
            offset5 = PeakInd(ClusterGap(j+1));
            
            OnsetVect = Signal_temp(1:onset5) > OnOffsetThreshold(i);
            onset3 = max(find(~OnsetVect));
            OffsetVect = Signal_temp(offset5:end) > OnOffsetThreshold(i);
            offset3 = min(find(~OffsetVect)) + offset5;
            
            PeakValue = max(Signal_temp(onset5:offset5));
            MaxPeakInd = find(Signal_temp(onset5:offset5)==PeakValue) + onset5 -1;
            if length(MaxPeakInd) > 1
                MaxPeakInd = MaxPeakInd(1);
            end
        end
        % Zero cross threshold positive or negative
        if (offset3 - onset3) / D.fsample * 1000 >= DurThreshold
            HFO_counter = HFO_counter + 1;
            HFO_Events_Matrix(HFO_counter,:)= [onset3 MaxPeakInd offset3 offset3 - onset3];            
        end
    end    
    obj.CandidateHFOsTimeStamps250{i} = HFO_Events_Matrix;
end


end

