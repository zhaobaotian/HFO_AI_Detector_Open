function obj = EliminateNoiseHFOChannels(obj)

% Eleminate Channels when candidate HFOs noise rate > 40%
D = obj.iEEGBandPass80;
Channeldir = D.chanlabels';
obj.qualityHFOsCounts        = [];
obj.qualityHFOsFRCounts      = [];
obj.CandidateHFOsFinalCounts = [];

for i = 1:length(Channeldir)
    if isempty(obj.CandidateHFOsFinalEventsTimeStamps{i})
        obj.qualityHFOsCounts(i)          = 0;
        obj.qualityHFOsFRCounts(i)        = 0;
        obj.CandidateHFOsFinalCounts(i)   = 0;
        continue
    elseif ~isempty(obj.CandidateHFOsFinalEventsTimeStamps{i})
        TotalHFOsCandidates = length(obj.CandidateHFOsFinalEventsLabels{i});
        NoiseInd = obj.CandidateHFOsHFOsLabelsNoise{i};
        OtherInd = and(~obj.CandidateHFOsHFOsLabelsNoise{i},...
            and(and(~obj.CandidateHFOsHFOsLabelsSpike{i},...
            ~obj.CandidateHFOsHFOsLabelsRipple{i}),...
            ~obj.CandidateHFOsHFOsLabelsFastRipple{i}));
        SpikeInd = and(~obj.CandidateHFOsHFOsLabelsNoise{i},...
            and(and(~obj.CandidateHFOsHFOsLabelsFastRipple{i},...
            ~obj.CandidateHFOsHFOsLabelsRipple{i}),...
            obj.CandidateHFOsHFOsLabelsSpike{i}));
        FRInd    = and(~obj.CandidateHFOsHFOsLabelsNoise{i},obj.CandidateHFOsHFOsLabelsFastRipple{i});
        
        NoiseOtherInd = or(NoiseInd,OtherInd);
        NoiseOtherCounts = sum(NoiseOtherInd);
        
        obj.CandidateHFOsFinalCounts(i) = TotalHFOsCandidates;
        
        if NoiseOtherCounts / TotalHFOsCandidates >= obj.ArtHFOsThresh
            obj.qualityHFOsCounts(i) = 0;
            obj.qualityHFOsFRCounts(i) = 0;
        elseif NoiseOtherCounts / TotalHFOsCandidates < obj.ArtHFOsThresh
            obj.qualityHFOsCounts(i) = TotalHFOsCandidates - sum(NoiseInd) ...
                - sum(OtherInd) - sum(SpikeInd);
            obj.qualityHFOsFRCounts(i) = sum(FRInd);
        end
    end
    
end
obj.qualityHFOsCounts        = obj.qualityHFOsCounts';
obj.qualityHFOsFRCounts      = obj.qualityHFOsFRCounts';
obj.CandidateHFOsFinalCounts = obj.CandidateHFOsFinalCounts';
end

