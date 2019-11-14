function [HFO_timestamps,Thresholds] = HFO_events_timestamp(D,gap_thresh,HFO_dur_threshold,stdthreshold)
%HFO_events_timestamp calculate timestamps of HFO events
% timestamps is the peak of each cluster

spm('defaults', 'EEG');

if nargin < 1 || isempty(D)
    D = spm_eeg_load;
end
if nargin < 2 || isempty(gap_thresh)
    % add threshold for gaps between filtered signal peaks in ms;
    gap_thresh = 20; % in ms 20 by default
end
if nargin < 3 || isempty(HFO_dur_threshold)
    % add threshold for HFO duration in ms;
    HFO_dur_threshold = 6; % in ms 6 by default
end

Thresholds = Amp_threshold(D,stdthreshold);
% initialize the output
HFO_timestamps = cell(length(D.chanlabels),1);
nChannel = length(D.chanlabels);
gap_thresh_counts = gap_thresh/1000*D.fsample;
HFO_dur_threshold_counts = HFO_dur_threshold/1000*D.fsample;


for i = 1:nChannel
    Signal_temp = abs(D(i,:,1));
    PeakInd = find(Signal_temp >= Thresholds(i));
    ClusterGap = find(diff(PeakInd)>gap_thresh_counts);
    HFO_Events_Matrix = [];
    HFO_counter = 0;
    for j = 1:length(ClusterGap)
        if j == 1
            onset = PeakInd(1);
            offset = PeakInd(ClusterGap(j));
            PeakValue = max(Signal_temp(onset:offset));
            MaxPeakInd = find(Signal_temp(onset:offset)==PeakValue) + onset -1;
            if length(MaxPeakInd) > 1
                MaxPeakInd = MaxPeakInd(1);
            end
        elseif j == length(ClusterGap)
            onset = PeakInd(ClusterGap(j)+1);
            offset = PeakInd(end);
            PeakValue = max(Signal_temp(onset:offset));
            MaxPeakInd = find(Signal_temp(onset:offset)==PeakValue) + onset -1;
            if length(MaxPeakInd) > 1
                MaxPeakInd = MaxPeakInd(1);
            end
        else
            onset = PeakInd(ClusterGap(j)+1);
            offset = PeakInd(ClusterGap(j+1));
            PeakValue = max(Signal_temp(onset:offset));
            MaxPeakInd = find(Signal_temp(onset:offset)==PeakValue) + onset -1;
            if length(MaxPeakInd) > 1
                MaxPeakInd = MaxPeakInd(1);
            end
        end
        if offset - onset > HFO_dur_threshold_counts
            HFO_counter = HFO_counter + 1;
            HFO_Events_Matrix(HFO_counter,:)= [onset MaxPeakInd offset];
        end
    end
    HFO_timestamps{i} = HFO_Events_Matrix;
end

% %% for visulization and mannual check
% Channel_temp = 1;
% timetamps_temp = HFO_timestamps{Channel_temp};
% Signal_temp = D(Channel_temp,113000:114000,1);
% TimeInterval = zeros(D.nsamples,1);
% PeakIndicator = zeros(D.nsamples,1);
% 
% for i = 1:size(timetamps_temp,1)
%     TimeInterval(timetamps_temp(i,1):timetamps_temp(i,3)) = Thresholds(Channel_temp)/2;
% end
% for i = 1:size(timetamps_temp,1)
%     PeakIndicator(timetamps_temp(i,2):timetamps_temp(i,2)+1) = Thresholds(Channel_temp)*2;
% end
% 
% plotECG(D.time,[Signal_temp' repmat(Thresholds(Channel_temp),[D.nsamples 1]) TimeInterval*5 PeakIndicator])
% figure
% plot(D.time(113000:114000),Signal_temp)
% axis tight
% grid on
% xlabel('Time (s)')
% ylabel('Amplitude')
% hold on
% plot(D.time(113000:114000),repmat(Thresholds(Channel_temp),[1 1001]))
% plot(D.time(113000:114000),TimeInterval(113000:114000)*5)
% plot(D.time(113000:114000),repmat(Thresholds(Channel_temp),[1 1001]))
end