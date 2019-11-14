function [Thresholds] = Amp_threshold(D,std_value)
%AMP_THRESHOLD calculate the amplitude of filtered traces
% five times the median of stds

spm('defaults', 'EEG');

if nargin < 1 || isempty(D)
    D = spm_eeg_load;
end
if nargin < 2 || isempty(std_value)
    % add prefix to the converted file, by default it is 4;
    std_value = 5;
end


% HFO candidates detection using a sliding window
% window length: 100ms
SlidingWinDur = 0.1; % in s
% SlidingWin = SlidingWinDur*D.fsample;
StepLength = 0.1; % in s
DataLength = D.nsamples;
nWindow = length(1:(StepLength * D.fsample):(DataLength - SlidingWinDur * D.fsample));
nChannel = length(D.chanlabels);
StdPool = zeros(nChannel,nWindow);

% Vectorize the algorithm
% Calculating the std pool for each channel
for ChannelIdx = 1:nChannel
    DataForSTD = D(ChannelIdx,1:round(nWindow * SlidingWinDur * D.fsample),1)';
    DataForSTDReshaped = reshape(DataForSTD,[round(SlidingWinDur * D.fsample) nWindow]);
    StdTemp = std(DataForSTDReshaped);
    
    StdPool(ChannelIdx,:) = StdTemp;
end


% % Calculating the std pool for each channel
% for ChannelIdx = 1:nChannel
%     Wind_ind = 0;
%     for i = 1:(StepLength * D.fsample):(DataLength - SlidingWinDur * D.fsample) % slide the window
%         DataInWindow = D(ChannelIdx,i:(SlidingWin+i-1),1); % extract time series data in one window
%         StdTemp = std(DataInWindow);
%         Wind_ind = Wind_ind + 1;
%         StdPool(ChannelIdx,Wind_ind) = StdTemp;
%     end
% end


Thresholds      = zeros(nChannel,1);
nChannel        = size(StdPool,1);

for i = 1:nChannel
    StdPoolTemp = StdPool(i,:);
    Thresholds(i) = median(StdPoolTemp) * std_value;
end
end