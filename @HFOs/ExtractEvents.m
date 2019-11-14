function obj = ExtractEvents(obj)

obj.CandidateHFOsFinalEvents80 = cell(obj.iEEGBandPass80.nchannels,1);
obj.CandidateHFOsFinalEventsHighPass = cell(obj.iEEGHighPass.nchannels,1);
obj.CandidateHFOsFinalEventsTimeStampsTag = cell(obj.iEEGHighPass.nchannels,1);
obj.CandidateHFOsFinalEventsTimeStamps = cell(obj.iEEGHighPass.nchannels,1);

Half_Dur = round((obj.WindowLength/2 + obj.Buffer)*obj.iEEGBandPass80.fsample);

for i = 1:obj.iEEGBandPass80.nchannels
    HFO_events_num = size(obj.CandidateHFOsTimeStampsFinal{i},1);
    Signal_temp = obj.iEEGBandPass80(i,:,1);
    Signal_temp_Raw = obj.iEEGHighPass(i,:,1);
    HFO_counter = 0;
    HFO_TimeSeries = [];
    HFO_TimeSeries_Raw = [];
    for j = 1:HFO_events_num
        if obj.CandidateHFOsTimeStampsFinal{i}(j,2) < Half_Dur || (obj.iEEGBandPass80.nsamples - obj.CandidateHFOsTimeStampsFinal{i}(j,2)) < Half_Dur
            obj.CandidateHFOsFinalEventsTimeStampsTag{i}(j) = 0;
            continue
        else
            obj.CandidateHFOsFinalEventsTimeStampsTag{i}(j) = 1;
            HFO_counter = HFO_counter + 1;
            HFO_TimeSeries(HFO_counter,:) = Signal_temp(int32(obj.CandidateHFOsTimeStampsFinal{i}(j,2)-Half_Dur):int32(obj.CandidateHFOsTimeStampsFinal{i}(j,2)+Half_Dur));
            HFO_TimeSeries_Raw(HFO_counter,:) = Signal_temp_Raw(int32(obj.CandidateHFOsTimeStampsFinal{i}(j,2)-Half_Dur):int32(obj.CandidateHFOsTimeStampsFinal{i}(j,2)+Half_Dur));
        end
    end
    obj.CandidateHFOsFinalEventsTimeStamps{i} = obj.CandidateHFOsTimeStampsFinal{i}(find(obj.CandidateHFOsFinalEventsTimeStampsTag{i}),:);
    % Baseline correction when assign
    obj.CandidateHFOsFinalEvents80{i}       = HFO_TimeSeries - mean(HFO_TimeSeries,2);
    obj.CandidateHFOsFinalEventsHighPass{i} = HFO_TimeSeries_Raw - mean(HFO_TimeSeries_Raw,2);
end

end


