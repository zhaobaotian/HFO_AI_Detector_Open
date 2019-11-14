function [HFO_Candidates_Raw,HFO_Candidates_highpass] = ROI_Extaction_500ms(D_Raw,D_filtered,HFO_timestamps)
%ROI_EXTACTION_500MS to extract 500ms ROI centered by the peak

spm('defaults', 'EEG');

if nargin < 1 || isempty(D_Raw)
    D_Raw = spm_eeg_load;
end
if nargin < 2 || isempty(D_filtered)
    D_filtered = spm_eeg_load;
end
if nargin < 3 || isempty(HFO_timestamps)
   error('please input HFO time stamps data')
end

HFO_Candidates_highpass = cell(length(D_filtered.chanlabels),1);
HFO_Candidates_Raw = cell(length(D_Raw.chanlabels),1);
nChannel = D_filtered.nchannels;
Half_Dur = 0.25*D_filtered.fsample;

for i = 1:nChannel
    HFO_events_num = size(HFO_timestamps{i},1);
    Signal_temp = D_filtered(i,:,1);
    Signal_temp_Raw = D_Raw(i,:,1);
    HFO_counter = 0;
    HFO_TimeSeries = [];
    HFO_TimeSeries_Raw = [];
    for j = 1:HFO_events_num
        if HFO_timestamps{i}(j,2) < Half_Dur || D_filtered.nsamples-HFO_timestamps{i}(j,2) < Half_Dur
            continue
        else
            HFO_counter = HFO_counter + 1;
            HFO_TimeSeries(HFO_counter,:) = Signal_temp(int32(HFO_timestamps{i}(j,2)-Half_Dur):int32(HFO_timestamps{i}(j,2)+Half_Dur));
            HFO_TimeSeries_Raw(HFO_counter,:) = Signal_temp_Raw(int32(HFO_timestamps{i}(j,2)-Half_Dur):int32(HFO_timestamps{i}(j,2)+Half_Dur));
        end
    end
HFO_Candidates_highpass{i} = HFO_TimeSeries;
HFO_Candidates_Raw{i} = HFO_TimeSeries_Raw;
end

end

