function obj = TFTransform(obj)

% Parameters
WinLenth = (obj.WindowLength/2 + obj.Buffer) * 2; % In seconds
t = 0:1/obj.iEEGBandPass80.fsample:WinLenth;
freq = 1:500;
% Transform
nChannel = size(obj.CandidateHFOsFinalEventsHighPass,1);
TFMapMatrixRaw = cell(nChannel,1);

for i = 1:nChannel
    if isempty(obj.CandidateHFOsFinalEventsHighPass{i})
        continue
    end
    P = single(morlet_transform(obj.CandidateHFOsFinalEventsHighPass{i}, t, freq));
    TFMapMatrixRaw{i} = P;
end
obj.TFMapMatrixLogSmoothed = TFMapMatrixRaw;

% morlet_transform(tempTrace, t, freq)
% figure('visible','on');
%         tempPower = morlet_transform(tempTrace, t, freq);
%         % Consider using calculation here to save memory
%         % Smooth
%         tempPower = imgaussfilt(squeeze(tempPower));
%         % Log
%         tempPower = squeeze(10*log10(tempPower));        
%         toplot = squeeze(tempPower(:,401:800));
%         % toplot = squeeze(HFO_Candidates_Raw_BC_TF_Log{i}(j,:,:));
%         imagesc(toplot)
%         colormap jet
%         axis xy
% 
% tempTraceR = downsample(tempTrace,2) 
% figure
% plot(tempTraceR)
% 
% figure
% plot(tempTrace)
% Smooth & Log
% Parameter
% SmoothWin = [obj.TFSmoothWin(1) round(obj.TFSmoothWin(2)/2000*obj.iEEGBandPass80.fsample)];
for i = 1:nChannel
    if isempty(obj.TFMapMatrixLogSmoothed{i})
        continue
    end
    for j = 1:size(obj.TFMapMatrixLogSmoothed{i},1)
        % Extract raw power
        RawPower = squeeze(obj.TFMapMatrixLogSmoothed{i}(j,:,:));
        % Smooth
        % smoothRawPower = imgaussfilt(RawPower,SmoothWin);
        smoothRawPower = imgaussfilt(RawPower);
        % Log
        LogSmoothRawPower = 10*log10(smoothRawPower);
        % Reassign
        obj.TFMapMatrixLogSmoothed{i}(j,:,:) = LogSmoothRawPower;
    end
end

end

