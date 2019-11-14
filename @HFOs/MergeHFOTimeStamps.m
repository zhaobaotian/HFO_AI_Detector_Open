function obj = MergeHFOTimeStamps(obj)

MergeThreshold = obj.MergeThreshold80_250; % Second

obj.CandidateHFOsTimeStampsFinal = cell(obj.iEEGBandPass80.nchannels,1);
for i = 1:obj.iEEGBandPass80.nchannels
    if isempty(obj.CandidateHFOsTimeStamps80{i}) && isempty(obj.CandidateHFOsTimeStamps250{i})
        obj.CandidateHFOsTimeStampsFinal{i} = [];
    elseif ~isempty(obj.CandidateHFOsTimeStamps80{i}) && isempty(obj.CandidateHFOsTimeStamps250{i})
        obj.CandidateHFOsTimeStampsFinal{i} = obj.CandidateHFOsTimeStamps80{i};
    elseif isempty(obj.CandidateHFOsTimeStamps80{i}) && ~isempty(obj.CandidateHFOsTimeStamps250{i})
        obj.CandidateHFOsTimeStampsFinal{i} = obj.CandidateHFOsTimeStamps250{i};
    elseif ~isempty(obj.CandidateHFOsTimeStamps80{i}) && ~isempty(obj.CandidateHFOsTimeStamps250{i})
        HFO250Ind = [];
        CandidateHFOsTimeStampsFinalMatrix = [];
        for j = 1:size(obj.CandidateHFOsTimeStamps80{i},1)
            TimeDiff = abs(obj.CandidateHFOsTimeStamps80{i}(j,2) - obj.CandidateHFOsTimeStamps250{i}(:,2))/obj.iEEGBandPass80.fsample;
            if min(TimeDiff) <= MergeThreshold
                tempHFO250Ind = min(find(TimeDiff == min(TimeDiff)));
                HFO250Ind     = [HFO250Ind tempHFO250Ind];
                tempHFO250    = obj.CandidateHFOsTimeStamps250{i}(tempHFO250Ind,:);
                CandidateHFOsTimeStampsFinalCenter = round(mean([obj.CandidateHFOsTimeStamps80{i}(j,2) tempHFO250(2)]));
                CandidateHFOsTimeStampsFinalOnset  = min([obj.CandidateHFOsTimeStamps80{i}(j,1) tempHFO250(1)]);
                CandidateHFOsTimeStampsFinalOffset = max([obj.CandidateHFOsTimeStamps80{i}(j,3) tempHFO250(3)]);
                CandidateHFOsTimeStampsFinalDur    = CandidateHFOsTimeStampsFinalOffset - CandidateHFOsTimeStampsFinalOnset;
            elseif min(TimeDiff) > MergeThreshold
                CandidateHFOsTimeStampsFinalCenter = obj.CandidateHFOsTimeStamps80{i}(j,2);
                CandidateHFOsTimeStampsFinalOnset  = obj.CandidateHFOsTimeStamps80{i}(j,1);
                CandidateHFOsTimeStampsFinalOffset = obj.CandidateHFOsTimeStamps80{i}(j,3);
                CandidateHFOsTimeStampsFinalDur    = obj.CandidateHFOsTimeStamps80{i}(j,4);
            end
            CandidateHFOsTimeStampsFinalMatrix(j,:) = [CandidateHFOsTimeStampsFinalOnset CandidateHFOsTimeStampsFinalCenter CandidateHFOsTimeStampsFinalOffset CandidateHFOsTimeStampsFinalDur];
        end
        % Insert the rest HFO250
        HFO250Rest = setdiff([1:size(obj.CandidateHFOsTimeStamps250{i}(:,2),1)],HFO250Ind);
        if ~isempty(HFO250Rest)
            CandidateHFOsTimeStampsFinalMatrix = [CandidateHFOsTimeStampsFinalMatrix; obj.CandidateHFOsTimeStamps250{i}(HFO250Rest,:)];
            CandidateHFOsTimeStampsFinalMatrix = sortrows(CandidateHFOsTimeStampsFinalMatrix,2);
        end
        obj.CandidateHFOsTimeStampsFinal{i} = CandidateHFOsTimeStampsFinalMatrix;
    end
end

SelectedHFOcounts = obj.CandidateHFOsTimeStampsFinal;
SelectedHFOcounts = cellfun(@size,SelectedHFOcounts,'UniformOutput',0);
SelectedHFOcounts = cell2mat(SelectedHFOcounts);
obj.CandidateHFOsCounts = SelectedHFOcounts(:,1);

end

% % Write the time stamps 80
% channel = 79
% EventTime = obj.CandidateHFOsTimeStamps80{channel}(:,1)/obj.iEEGBandPass80.fsample;
% EventMarker = repmat('HFO80',[length(EventTime),1]);
% eventFileName = ['Detected_80.txt'];
% Duration = obj.CandidateHFOsTimeStamps80{channel}(:,4)/obj.iEEGBandPass80.fsample
% writetable(table(EventTime,Duration,EventMarker),eventFileName,'Delimiter','\t')
% 
% % Write the time stamps 250
% EventTime = obj.CandidateHFOsTimeStamps250{channel}(:,1)/obj.iEEGBandPass80.fsample;
% EventMarker = repmat('HFO250',[length(EventTime),1]);
% eventFileName = ['Detected_250.txt'];
% Duration = obj.CandidateHFOsTimeStamps250{channel}(:,4)/obj.iEEGBandPass80.fsample
% writetable(table(EventTime,Duration,EventMarker),eventFileName,'Delimiter','\t')
% 
% % Write the time stamps final
% EventTime = obj.CandidateHFOsTimeStampsFinal{channel}(:,1)/obj.iEEGBandPass80.fsample;
% EventMarker = repmat('Final',[length(EventTime),1]);
% eventFileName = ['Final.txt'];
% Duration = obj.CandidateHFOsTimeStampsFinal{channel}(:,4)/obj.iEEGBandPass80.fsample
% writetable(table(EventTime,Duration,EventMarker),eventFileName,'Delimiter','\t')
% 
% % Write the time stamps 80
% channel = 79
% EventTime = obj.CandidateHFOsTimeStamps80{channel}(:,2)/obj.iEEGBandPass80.fsample;
% EventMarker = repmat('HFO80',[length(EventTime),1]);
% eventFileName = ['Detected_80.txt'];
% Duration = obj.CandidateHFOsTimeStamps80{channel}(:,4)/obj.iEEGBandPass80.fsample
% writetable(table(EventTime,EventMarker),eventFileName,'Delimiter','\t')
% 
% % Write the time stamps 250
% EventTime = obj.CandidateHFOsTimeStamps250{channel}(:,2)/obj.iEEGBandPass80.fsample;
% EventMarker = repmat('HFO250',[length(EventTime),1]);
% eventFileName = ['Detected_250.txt'];
% Duration = obj.CandidateHFOsTimeStamps250{channel}(:,4)/obj.iEEGBandPass80.fsample
% writetable(table(EventTime,EventMarker),eventFileName,'Delimiter','\t')
% 
% % Write the time stamps final
% EventTime = obj.CandidateHFOsTimeStampsFinal{channel}(:,2)/obj.iEEGBandPass80.fsample;
% EventMarker = repmat('Final',[length(EventTime),1]);
% eventFileName = ['Final.txt'];
% Duration = obj.CandidateHFOsTimeStampsFinal{channel}(:,4)/obj.iEEGBandPass80.fsample
% writetable(table(EventTime,EventMarker),eventFileName,'Delimiter','\t')
