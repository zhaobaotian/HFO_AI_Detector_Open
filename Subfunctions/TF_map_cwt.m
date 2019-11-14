%% Obtain a time-frequency plot of this signal using the CWT.
% for i = 1:100
D_M_notch = spm_eeg_load;

for i = 1:50
    Channel = 4;
    fs = D_M_notch.fsample;
    Signal = D_M_notch(Channel,2.3*2000:2.8*2000,1);
    figure
    plot(Signal)
    figure
    cwt(Signal,'amor',fs,'ExtendSignal',true,'FrequencyLimits',[1 500])
    colormap('jet')
end
[cfs,f] = cwt(Signal,'amor',fs,'ExtendSignal',true,'FrequencyLimits',[1 500]);
figure
colormap jet
imagesc((10*log10(abs(cfs))))

figure
imagesc(((abs(cfs))))
hold on
plot(-Signal/25+30,'w','LineWidth',1.5)
colormap jet
yticks(1:5:length(f))
yticklabels(round(f(1:5:length(f))))
xticks(51:50:401)
xticklabels(25:25:200)
ylabel('Hz');
xlabel('time(ms)')

%% use brainstorm function
x = Signal;
t = 0:0.0005:0.2;
freq = 1:500;
P = morlet_transform(x, t, freq);
figure;
imagesc(10*log10(squeeze(P)') - 10*log10(mean(mean(P))))
axis xy
colormap jet

figure
histogram(P,'BinWidth',50)

figure
compensate = 1:500;
imagesc(((squeeze(P).*compensate)'))
axis xy
colormap jet

hold on
plot(Signal/2.5+250,'k','LineWidth',1.5)
colormap jet
yticks(1:50:500)
yticklabels(1:50:500)
xticks(51:50:401)
xticklabels(25:25:200)
ylabel('Hz');
xlabel('time(ms)')

figure
to_plot = (10*log10(squeeze(mean(P)))).*compensate';
figure
to_plot = (10*log10(squeeze(mean(P))));
plot(to_plot)
%%
map = squeeze(bspower.TF(4,:,:))
figure
imagesc(map')
axis xy
colormap jet
%%
figure
hist(10*log10(abs(cfs)))

figure
cfs(abs(cfs)<2) = eps;
imagesc((10*log10(abs(cfs))))
hold on
plot(-Signal/25+30,'w','LineWidth',1.5)
colormap jet
yticks(1:5:length(f))
yticklabels(round(f(1:5:length(f))))
xticks(51:50:401)
xticklabels(25:25:200)
ylabel('Hz');
xlabel('time(ms)')
caxis([0 20])

figure
contourf((10*log10(abs(cfs))))
axis ij

HanningWin = hann(32*fs/1000);
Noverlap = length(HanningWin) - 1;
frequencies = 80:500;
fsample = fs;
figure
spectrogram(Signal,HanningWin,Noverlap,frequencies,fsample,'yaxis');
colormap('jet')



D_f = spm_eeg_load()
Signal_filtered_spm = D_f(Channel,1:10000,1);
figure
plot(Signal)
hold on
plot(Signal_filtered_spm)
plot(input_filtered)
% figure
% subplot(2,1,1)
% plot(signal)
% axis tight
% subplot(2,1,2)
% cwt(signal,fs,'amor')
% plot(f)
plot(Signal)

[cfs,f] = cwt(Signal,'amor',fs,'ExtendSignal',true,'FrequencyLimits',[1 500]);
figure
colormap jet
imagesc(((abs(cfs))))
figure
subplot(2,1,1)
plot(Signal)
axis tight
subplot(2,1,2)
colormap jet
imagesc(((abs(cfs))))
yticks(1:5:length(f))
yticklabels(f(1:5:length(f)))


contourf((10*log10(abs(cfs))))
yticks(1:length(f))
yticklabels(f)
figure
plot(Signal)

% end
% %% compare cwt and spm
% Signal = D(1,1:2000,1);
% [cfs,f] = cwt(Signal,'amor',fs,'ExtendSignal',true,'FrequencyLimits',[1 500]);
% figure
% colormap jet
% imagesc(((abs(cfs))))
% yticks(1:length(f))
% yticklabels(f)
% imagesc((abs(cfs))) 
% 
% filename = spm_select()
% D_tf = spm_eeg_load(filename)
% data = squeeze(D_tf(1,:,:,1))
% figure
% imagesc(flipud(10*log10(data)))
% colormap jet
% 
% helperCWTTimeFreqPlot(cfs,signal,f,'surf','CWT of Signal','Seconds','Hz')
% 
% %% Obtain a time-frequency plot of this signal using the OLD CWT. 
% Scales = 1:50;
% wavemngr('read')
% 
% [coefs,sgram] = cwt(signal,Scales,'morl','scal')
% imagesc(coefs)
% 
% 
% %% test
% load vonkoch
% vonkoch=vonkoch(1:510); 
% len = length(vonkoch);
% cw1 = cwt(vonkoch,1:32,'morl','plot'); 
% title('Continuous Transform, absolute coefficients.') 
% ylabel('Scale')
% [cw1,sc] = cwt(vonkoch,1:32,'sym2','scal');
% title('Scalogram') 
% ylabel('Scale')















