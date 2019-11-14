function obj = LabelExtremeAmpChans(obj)

D = obj.iEEG.iEEG_MEEG{1};
% D = spm_eeg_load;

AmpThreshold    = obj.ExtremeAmpThreshold;
AmpThresholdDur = obj.ExtremeAmpDurThreshold * D.fsample;

for i = 1:D.nchannels
    % Zero pad the data
    tempTrace = [0 abs(D(i,:,1)) 0];
    OnsetInd  = find(diff(tempTrace > AmpThreshold) == 1);
    OffsetInd = find(diff(tempTrace > AmpThreshold) == -1);
    tempDur = max((OffsetInd - OnsetInd));
    
    if isempty(tempDur)
        tempDur = 0;
    end
    
    if tempDur >= AmpThresholdDur
        obj.BipolarEEGTraceExtAmpLabel(i) = 1;
    elseif tempDur < AmpThresholdDur
        obj.BipolarEEGTraceExtAmpLabel(i) = 0;
    end
end

obj.BipolarEEGTraceExtAmpLabel = obj.BipolarEEGTraceExtAmpLabel';

end

