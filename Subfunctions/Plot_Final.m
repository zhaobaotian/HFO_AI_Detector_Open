function Plot_Final(D_filtered,HFO_Candidates_Raw_BC,HFO_Candidates_highpass,WindowLength)

nChannels     = D_filtered.nchannels;
ChannelLabels = D_filtered.chanlabels;
fsample       = D_filtered.fsample;

% Parameters
t        = 0:1/fsample:1;
freq     = 1:500;
fc       = 1;
FWHM_tc  = 3;

% SmoothWin = [SmoothWin(1) round(SmoothWin(2)/2000*fsample)];

mkdir('PCS')
cd('PCS')

% Time window
Half_Dur = int32(WindowLength/2*fsample);
for i = 1:length(HFO_Candidates_Raw_BC)
    if ~isempty(HFO_Candidates_Raw_BC{i})
        MiddlePoints = floor(size(HFO_Candidates_Raw_BC{i},2)/2) + 1;
        break
    end
end


parfor i = 1:nChannels
    if isempty(HFO_Candidates_Raw_BC{i})
        Channel_Dir = ChannelLabels{i};
        mkdir(Channel_Dir)
        continue
    end
    Channel_Dir = ChannelLabels{i};
    mkdir(Channel_Dir)
    cd(Channel_Dir)
    for j = 1:size(HFO_Candidates_Raw_BC{i},1)
        % for trace
        figure('visible','off');
        Baseline_temp = mean(HFO_Candidates_Raw_BC{i}(j,MiddlePoints - Half_Dur:MiddlePoints + Half_Dur));
        Raw_200ms = HFO_Candidates_Raw_BC{i}(j,MiddlePoints - Half_Dur:MiddlePoints + Half_Dur);
        plot(Raw_200ms - Baseline_temp)
        hold on
        plot(HFO_Candidates_highpass{i}(j,MiddlePoints - Half_Dur:MiddlePoints + Half_Dur))
        axis tight
        grid on
        legend('Raw','Filtered')
        ylabel('Amp (uV)')
        xlabel('Time (ms)')
        
        xticks(1:round(0.05 * fsample):...
            round((WindowLength) * fsample+1))
        xticklabels(0:50:(WindowLength)*1000)

        title([Channel_Dir '-' num2str(j,'%06d') '-' 'Trace'])
        print([Channel_Dir '_' num2str(j,'%06d') '_' 'Trace'],'-dpng')
        close
        % for time frequency map
        figure('visible','on');
        tempPower = morlet_transform(HFO_Candidates_Raw_BC{i}(j,:), t, freq, fc, FWHM_tc);
        %consider using calculation here to save memory
        % Smooth
        % tempPower = imgaussfilt(tempPower,SmoothWin);
        tempPower = imgaussfilt(squeeze(tempPower));
        % Log
        tempPower = 10*log10(tempPower);        
        toplot = tempPower(:,MiddlePoints - Half_Dur:MiddlePoints + Half_Dur);
        % toplot = squeeze(HFO_Candidates_Raw_BC_TF_Log{i}(j,:,:));
        imagesc(toplot)
        colormap jet
        axis xy
        ylabel('Frequency (Hz)')
        xlabel('Time (ms)')
        
        xticks(1:round(0.05 * fsample):...
            round((WindowLength) * fsample + 1))
        xticklabels(0:50:(WindowLength)*1000)
        
        title([Channel_Dir '-' num2str(j,'%06d') '-' 'TF'])
        print([Channel_Dir '_' num2str(j,'%06d') '_' 'TF'],'-dpng')
        close
        % for training 224*224 resolution for GoogLeNet
        figure('visible','off');
        imagesc(toplot)
        colormap jet
        axis xy
        axis off
        box off
        set(gca,'position',[0 0 1 1],'units','normalized')
        truesize(gcf,[224 224])
        TrainfileName = [Channel_Dir '_' num2str(j,'%06d') '_' 'Train'];
        print(TrainfileName,'-dpng','-r0')
        close
    end
    cd ..
end
cd ..
end

