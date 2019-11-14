function obj = PlotTFMap(obj)

mkdir('PCS')
cd('PCS')

% Time window
Half_Dur = int32(obj.WindowLength/2*obj.iEEGBandPass80.fsample);
for i = 1:length(obj.TFMapMatrixLogSmoothed)
    if ~isempty(obj.TFMapMatrixLogSmoothed{i})
        MiddlePoints = floor(size(obj.TFMapMatrixLogSmoothed{i},3)/2) + 1;
        break
    end
end

for i = 1:obj.iEEGBandPass80.nchannels
    if isempty(obj.TFMapMatrixLogSmoothed{i})
        Channel_Dir = obj.iEEGBandPass80.chanlabels{i};
        mkdir(Channel_Dir)
        continue
    end
    Channel_Dir = obj.iEEGBandPass80.chanlabels{i};
    mkdir(Channel_Dir)
    cd(Channel_Dir)
    for j = 1:size(obj.TFMapMatrixLogSmoothed{i},1)
        % for trace
        figure('visible','off');
        Baseline_temp = mean(obj.CandidateHFOsFinalEventsHighPass{i}(j,MiddlePoints - Half_Dur:MiddlePoints + Half_Dur));
        Raw_200ms = obj.CandidateHFOsFinalEventsHighPass{i}(j,MiddlePoints - Half_Dur:MiddlePoints + Half_Dur);
        plot(Raw_200ms - Baseline_temp)
        hold on
        plot(obj.CandidateHFOsFinalEvents80{i}(j,MiddlePoints - Half_Dur:MiddlePoints + Half_Dur))
        axis tight
        grid on
        legend('Raw','Filtered')
        ylabel('Amp (uV)')
        xlabel('Time (ms)')
        xticks(1:round(0.05*obj.iEEGBandPass80.fsample):...
            round((obj.WindowLength) * obj.iEEGBandPass80.fsample+1))
        xticklabels(0:50:(obj.WindowLength)*1000)
        title([Channel_Dir '-' num2str(j) '-' 'Trace'])
        print([Channel_Dir '_' num2str(j) '_' 'Trace'],'-dpng')
        close
        % for time frequency map
        figure('visible','off');
        toplot = squeeze(obj.TFMapMatrixLogSmoothed{i}(j,:,MiddlePoints - Half_Dur:MiddlePoints + Half_Dur));
        imagesc(toplot) %consider using calculation here to save memory
        colormap jet
        axis xy
        ylabel('Frequency (Hz)')
        xlabel('Time (ms)')
        xticks(1:round(0.05*obj.iEEGBandPass80.fsample):...
            round((obj.WindowLength) * obj.iEEGBandPass80.fsample+1))
        xticklabels(0:50:(obj.WindowLength)*1000)
        title([Channel_Dir '-' num2str(j) '-' 'TF'])
        print([Channel_Dir '_' num2str(j) '_' 'TF'],'-dpng')
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
        TrainfileName = [Channel_Dir '_' num2str(j) '_' 'Train'];
        print(TrainfileName,'-dpng','-r0')
        close
    end
    cd ..    
end

end

