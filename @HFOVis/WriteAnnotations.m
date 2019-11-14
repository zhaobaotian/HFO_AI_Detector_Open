function obj = WriteAnnotations(obj)

% For candidate HFOs
mkdir('Annotations')
cd('Annotations')
for i = 1:length(obj.HFOCandidatesTimestamps)
    if isempty(obj.HFOCandidatesTimestamps{i})
    EventTime = 1;
    EventMarker = repmat('No HFOs detected',[length(EventTime),1]);
    eventFileName = [obj.SelectedBipolarChannels{i} '.txt'];
    writetable(table(EventTime,EventMarker),eventFileName,'Delimiter','\t')
    else
    EventTime = obj.HFOCandidatesTimestamps{i}(:,2)/obj.Fsample;
    % EventMarker = repmat('HFO_Candidates',[length(EventTime),1]);
    EventMarker = char(obj.HFOCandidatesLabels{i});
    eventFileName = [obj.SelectedBipolarChannels{i} '.txt'];
    writetable(table(EventTime,EventMarker),eventFileName,'Delimiter','\t')
    end
end
cd ..

end

