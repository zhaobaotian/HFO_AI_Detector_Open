%% load the file
fname = spm_select();
D = spm_eeg_load(fname);

%% plot traces
plotECG(D.time,squeeze(D(:,:,1)),'AutoStackSignals',D.chanlabels)
plotECG(D.time,squeeze(D(1,:,1)))
figure;
plot(D.time(10000:50000),squeeze(D(1,1:5000,1)))
axis tight
grid on
xlabel('Time (s)')
ylabel('Amplitude')

figure;
plot(D.time(8000:18000),squeeze(D(1,8000:18000,1)))
axis tight
grid on
xlabel('Time (s)')
ylabel('Amplitude')

figure;
plot(D.time(1800:1900),squeeze(D(1,1800:1900,1)),'-o')
axis tight
grid on
xlabel('Time (s)')
ylabel('Amplitude')

% power spectrum
figure
pwelch(squeeze(D(6,1:290000,1)),1000,[],[],1000);

% time frequency map
Sig = squeeze(D(1,1:10000,1));
HanningWin = hann(64*D.fsample/1000);
Noverlap = length(HanningWin) - 1;
frequencies = 1:500;
fsample = D.fsample;
figure;
plot(Sig)
[s,w,t,ps] = spectrogram(Sig,HanningWin,Noverlap,frequencies,fsample,'yaxis');
figure
spectrogram(Sig,HanningWin,Noverlap,frequencies,fsample,'yaxis','MinThreshold',-20)
colormap('jet')
   
%% calculate the phase
Sig = squeeze(D(1,1800:2000,1));
Sig_bandpass = bandpass(Sig,[9 11],2000);
figure
% plot(Sig)

Sig_bandpass_fft = hilbert(Sig_bandpass);
plot(angle(Sig_bandpass_fft))
hold on
plot(Sig_bandpass/200)
axis tight
xlabel('Time')
ylabel('Phase')
legend('Phase','Flitered Signal')
grid on

%% use spm gui to filter
% NOTE: set the eeg type before you filter

%% visualization for inspection
fname_f = spm_select();
D_f = spm_eeg_load(fname_f);
FilteredSignal = squeeze(D_f(4,:,1))';
plotECG(D_f.time,[FilteredSignal])
RawSignal = squeeze(D(4,:,1))';
% plot(RawSignal)
% hold on
% plot(squeeze(D(1,:,1)),'--');
plotECG(D_f.time,[FilteredSignal RawSignal])

%% visualize use by plotECG

plotECG(D_f.time,squeeze(D_f(:,:,1)),'AutoStackSignals',D_f.chanlabels)
plotECG(D_f.time,squeeze(D_f(1,:,1)))
% figure
% plot(squeeze(D(1,:,:)))
% hold on
% plot(squeeze(D_f(1,:,:)))

%% HFO detection using a sliding window
% window length: 100ms
SlidingWinDur = 0.1; % in s
SlidingWin = SlidingWinDur*D_f.fsample;
StepLength = 0.001; % in s
DataLength = D_f.nsamples;
StdPool = [];

%calculating the std pool for each channel
for ChannelIdx = 1%D_f.nchannels
    for i = 1:(StepLength * D_f.fsample):(DataLength - SlidingWinDur * D_f.fsample) % slide the window
        DataInWindow = D_f(ChannelIdx,i:(SlidingWin+i-1),1); % extract time series data in one window
        StdTemp = std(DataInWindow);
        StdPool(ChannelIdx,i) = StdTemp;
    end
end

StdPool_Nonzero = [];
Thresholds      = [];
ThresholdLines  = [];
nChannel = size(StdPool);
nChannel = nChannel(1);
for i = 1:nChannel
    StdPoolTemp = StdPool(i,:);
    StdPoolTemp = StdPoolTemp(StdPoolTemp ~= 0);
    StdPool_Nonzero(i,:) = StdPoolTemp;
    Thresholds(i,:) = median(StdPoolTemp) * 5;
    ThresholdLines(i,:) = repelem(median(StdPoolTemp) * 5,D_f.nsamples)';
end

ThresholdLines = ThresholdLines';

%% visualization for inspection
FilteredSignal = squeeze(D_f(1,:,1))';
plotECG(D_f.time,[FilteredSignal ThresholdLines(:,1)])
RawSignal = squeeze(D(1,:,1))';
plotECG(D_f.time,[FilteredSignal ThresholdLines(:,1) RawSignal])

%% calculate the envelope of the signal using Hilbert transform
Envelope = envelope(D_f(1,:,1),10,'peak')'; % the number in the middle 
EnvelopeNeg = envelope(-D_f(1,:,1),10,'peak')';
% e.g. 10 in this case controls the smoothness of the envelope, 
% this can be arbitrary, so inspect the figure

% % Another envelope method
% Envelope = envelope(D_f(1,:,1),1000,'analytic')'; % the number in the middle 
% EnvelopeNeg = envelope(-D_f(1,:,1),1000,'analytic')';
% % envelope(z,50,'analytic')

EnvelopeNeg = - EnvelopeNeg;



%% visualization for inspection of the envelope
plotECG(D_f.time,[FilteredSignal ThresholdLines(:,1) Envelope RawSignal])
plotECG(D_f.time,[FilteredSignal ThresholdLines(:,1) Envelope EnvelopeNeg])
%% extract the candidate pool
% there will be one SPM object for each channel
% Make the envelop Binary for filtering 
% find the max in the envolope and center them

% Binarize the envelope
EnvelopeBinary = Envelope;
EnvelopeBinary(EnvelopeBinary < Thresholds(1)) = 0;
EnvelopeBinary(EnvelopeBinary >= Thresholds(1)) = 1;
plotECG(D_f.time,[FilteredSignal Envelope EnvelopeBinary ThresholdLines(:,1)])

% Find the middle point of each cluster and epoch
% Append a zero in the end to avoid EnvelopeBinary end up with 1
EnvelopeBinaryZeroPaddle = [EnvelopeBinary;0];
EnvelopeBinaryDiff = diff(EnvelopeBinaryZeroPaddle);
OnsetWins = find(EnvelopeBinaryDiff == 1);
OffsetWins = find(EnvelopeBinaryDiff == -1);
WinCenters = round((OnsetWins + OffsetWins)/2);

WinCentersLine = repelem(0,DataLength);
for i = 1:DataLength
    if ismember(i,WinCenters)
        WinCentersLine(i) = Thresholds(1)*2;
        WinCentersLine(i+1) = -Thresholds(1)*2;
    end
end
WinCentersLine = WinCentersLine';

% visualization WinCenters
plotECG(D_f.time,[FilteredSignal ThresholdLines(:,1) Envelope WinCentersLine RawSignal])
plotECG(D_f.time,[FilteredSignal ThresholdLines(:,1) Envelope WinCentersLine*2])

% Take out the epoch candidates in a 256ms window centered by HFO centers
% for single channel for example

%% extract those windows under the envelope, window length may vary
for i = 1:length(WinCenters)
    HFOPoolShortTemp = [RawSignal(OnsetWins(i):OffsetWins(i)) - mean(RawSignal(OnsetWins(i):OffsetWins(i))),...
        FilteredSignal(OnsetWins(i):OffsetWins(i)) - mean(FilteredSignal(OnsetWins(i):OffsetWins(i)))];
    % raw data with zero-crossing numbers larger than 10 were considered artifacts
    if length(find(diff(HFOPoolShortTemp(:,1) > 0)~=0)+1) > 10
        SeiveFlag(i,1) = 0;
    else
        SeiveFlag(i,1) = 1;
    end
    % The threshold-crossing number of the filtered data should be no less
    % than eight times to ensure at least four successive peaks standing out from the background.
    if length(find(diff(HFOPoolShortTemp(:,2) > Thresholds)~=0)+1) > 8 ||...
            length(find(diff(-HFOPoolShortTemp(:,2) > Thresholds)~=0)+1) > 8
        SeiveFlag(i,2) = 1;
    else
        SeiveFlag(i,2) = 0;
    end 
end

% find those filtered index and the shared values
TenZeroCrossingIdx = find(SeiveFlag(:,1));
EightPeakIdx = find(SeiveFlag(:,2));
WinCentersFilteredIdx = intersect(TenZeroCrossingIdx,EightPeakIdx);

% this is the filtered centers for use later
WinCentersFiltered = WinCenters(WinCentersFilteredIdx);


WinCentersFilteredCutIdx = find(WinCentersFiltered > 128*D.fsample/1000 & ...
    DataLength - WinCentersFiltered > 128*D.fsample/1000 );
WinCentersFilteredCut = WinCentersFiltered(WinCentersFilteredCutIdx);

%% HFOPool: 
%        1st demension: epoch index
%        2nd demension: raw data in a 256ms window
%        3rd demension: first is raw, second is filtered
% epoch and extract the data and baseline correction for those epoched data

for i = 1:length(WinCentersFilteredCut)
    HFOPool(i,:,:) = [RawSignal(WinCentersFilteredCut(i) - 128*D.fsample/1000:WinCentersFilteredCut(i) + 128*D.fsample/1000) - ...
    mean(RawSignal(WinCentersFilteredCut(i) - 128*D.fsample/1000:WinCentersFilteredCut(i) + 128*D.fsample/1000)),...
    FilteredSignal(WinCentersFilteredCut(i) - 128*D.fsample/1000:WinCentersFilteredCut(i) + 128*D.fsample/1000) - ...
    mean(FilteredSignal(WinCentersFilteredCut(i) - 128*D.fsample/1000:WinCentersFilteredCut(i) + 128*D.fsample/1000))];
end

% % without baseline correction
% for i = 1:length(WinCentersCut)
% HFOPool(i,:,:) = [RawSignal(WinCentersCut(i) - 128*D.fsample/1000:WinCentersCut(i) + 128*D.fsample/1000),...
%     FilteredSignal(WinCentersCut(i) - 128*D.fsample/1000:WinCentersCut(i) + 128*D.fsample/1000)];
% end

% visualize those epoches
% for i = 1:50
% figure;
% plot(squeeze(HFOPool(i,:,1)))
% hold on
% plot(squeeze(HFOPool(i,:,2)))
% axis tight
% end

%% Time¨CFrequency analysis and denoising %%
% short time fourier transform of the filtered events for each event

% % from article
% The STFT was computed in a 256 ms segment starting 128 ms
% before the center of HFO and extending 128 ms after it. The
% Fourier transform was computed in a 64 ms Hanning window
% which was shifted sample by sample to create a time¨C
% frequency map.
for i = 1:86%:length(length(WinCentersFilteredCut)
    i = 4;
    Sig = HFOPool(i,:,1);
    HanningWin = hann(64*D.fsample/1000);
    Noverlap = length(HanningWin) - 1;
    frequencies = 1:500;
    fsample = D.fsample;
    figure;
   plot(Sig)
   [s,w,t,ps] = spectrogram(Sig,HanningWin,Noverlap,frequencies,fsample,'yaxis');
   figure
   spectrogram(Sig,HanningWin,Noverlap,frequencies,fsample,'yaxis')
   colormap('jet')

   % use threshold to keep 95% energy
   % Calculate the 95% percentile energy threshold from ps
   NormPs = 10*log10(ps + eps);
   NormPsVector = reshape(NormPs,[],1);
   PercentThreshold = prctile(NormPsVector,5);
   figure;
   spectrogram(Sig,HanningWin,Noverlap,frequencies,fsample,'MinThreshold',PercentThreshold,'yaxis');
   colormap('jet')
   [sThresh,w,t,psThresh] = spectrogram(Sig,HanningWin,Noverlap,frequencies,fsample,'MinThreshold',PercentThreshold,'yaxis');
end
%% pile the HFOs
    figure;
    x_axis = 0:0.5:256;
    To_plot = [1:11 13:28 30 31 33:43 46:55 58:86];
    EEG_data = []
for i = To_plot%:length(length(WinCentersFilteredCut)
    %     i = 4;
%     figure
    Sig = HFOPool(i,:,1);
    plot(x_axis,Sig,'Color', [0.7,0.7,0.7])
    axis tight
    grid on
    hold on
    EEG_data = [EEG_data; Sig];
end

plot(x_axis,mean(EEG_data),'Color',[0 0.45 0.74],'LineWidth',2)
xlabel('Time (ms)');
ylabel('Amplitude');

for i = 1:5%:length(length(WinCentersFilteredCut)
    %     i = 4;
    figure
    Sig = HFOPool(i,:,1);
    plot(x_axis,Sig,'LineWidth',1.5)
    axis tight
    grid on
    hold on
    xlabel('Time (ms)');
    ylabel('Amplitude');
end

for i = 1:5%:length(length(WinCentersFilteredCut)
    
    Sig = HFOPool(i,:,1);
    HanningWin = hann(64*D.fsample/1000);
    Noverlap = length(HanningWin) - 1;
    frequencies = 1:500;
    fsample = D.fsample;
    figure
    spectrogram(Sig,HanningWin,Noverlap,frequencies,fsample,'yaxis');
    colormap('jet')
end


EEG_data_TF = [];
counter_tem = 1;
for i = To_plot%:length(length(WinCentersFilteredCut)

    Sig = HFOPool(i,:,1);
    Sig = HFOPool(i,:,1);
    HanningWin = hann(64*D.fsample/1000);
    Noverlap = length(HanningWin) - 1;
    frequencies = 1:500;
    fsample = D.fsample;
    [s,w,t,ps] = spectrogram(Sig,HanningWin,Noverlap,frequencies,fsample,'yaxis');
    EEG_data_TF(:,:,counter_tem) = ps;
    counter_tem = counter_tem + 1;
end
ps_mean = mean(EEG_data_TF,3);
   % for visualization
   figure
   imagesc(t*1000,w,(10*log10(ps_mean)),[-40,25])
   set(gca,'Ydir','normal')
   colormap('jet')
   colorbar

ylabel('Frequency (Hz)');
xlabel('Time (ms)');
   % do the threshold manually
%    for i = 1:length(NormPsVector)
%        if NormPs(i) <  PercentThreshold
%           psThresh(i) = 0;
%        else 
%           psThresh(i) = ps(i);
%        end
%    end
%    
%    NormPsThreshold = 10*log10(psThresh + eps);
%    figure
%    imagesc(NormPsThreshold,[-40,25]) % plus eps to avoid log10(0)
%    set(gca,'Ydir','normal')
% %    imagesc(psThresh,[-40,25])
%    colormap jet

%%
% % ps is the power spectrum
% % convert raw power to decibel(db)
% NormPs = 10*log10(ps + eps);
% figure
% imagesc(NormPs) % plus eps to avoid log10(0)
% set(gca,'Ydir','normal')
% colormap jet

% % denoise and preserve 90% percent energy (in decibel)
% DenoiseThresh
% quantile(NormPs,0.9)

% figure
% plot(mean(NormPs,2))
% 
% figure
% subplot(3,1,1)
% plot(HFOPool(i,:,1))
% title('Raw')
% grid on
% axis tight
% subplot(3,1,2)
% plot(HFOPool(i,:,2))
% title('Filtered')
% grid on
% axis tight
% subplot(3,1,3)
% 
% figure
% imagesc(log(ps))
% 
% imagesc(flipud(10*log(abs(s)/2)))
% set(gca,'Ydir','normal')
% xticks('auto')
% xticklabels(t(50:50:350)*1000)
% colormap jet
% 
% plot(flipud(mean(flipud(abs(s)),2)))
% title('TFmap')
% colormap('jet')

%% for TF map normalization/rescale illustration
% imtool(flipud(abs(s)))
% imtool(flipud(10log(abs(s))))
% plotECG(D_f.time,[EnvelopeBinary])
%% test the filter
%Create bipolar for HFO and spike detection
fprintf('%s\n','---- Creating bipolar montage ----')
for d=1:size(eeg,2)-1
    
    name1 = join(regexp(string(D.channels(d).label),'[a-z]','Match','ignorecase'),'');
    name2 = join(regexp(string(D.channels(d+1).label),'[a-z]','Match','ignorecase'),'');
    chanNames{d}=D.channels(d).label;
    
    if strcmp(name1,name2)
        eeg_bi(:,z)=eeg(:,d)-eeg(:,d+1);
        chan{1,z}=sprintf('%s-%s',chanNames{d},D.channels(d+1).label);
        z=z+1;
    else
        continue
    end
end
chanNames{d+1}=D.channels(d+1).label;


% 64 order FIR fileter
eeg = Signal;
b = fir1(64,[80 (fs/2)-20]/(fs/2));
a = 1;
input_filtered = filtfilt(b,a,eeg);

% n = size(input_filtered,2);
% for i = 1:n
%     [v(:,i),th] = get_threshold(input_filtered(:,i),round(100*fs/1000),0.5,'std',5);
%     try
%         timestamp{i}(:,1) = find_event(input_filtered(:,i),th,2,1);
%         timestamp{i}(:,2) = i;
%     catch
%         continue;
%     end
% end
% T = cat(1,timestamp{:});
% [~,I] = sort(T(:,1));
% event.timestamp = T(I,:);
% [alligned,allignedIndex,K] = getaligneddata(eeg_bi,event.timestamp(:,1),[-round(150*fs/1000) round(150*fs/1000)]);
% event.timestamp=event.timestamp(logical(K),:);
% ttlN = size(alligned,3);














