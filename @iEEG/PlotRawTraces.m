function obj = PlotRawTraces(obj)
%PlotRawTraces Plot raw iEEG traces of all channels and epoch to check
%activation and noise
%sampling rate
% FORMAT: obj = PlotRawTraces(obj)
% Input:
%       obj:   obj with epoched iEEG data
% Output:
%       obj:   Figures
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190515
% zhaobaotian0220@foxmail.com
if isempty(obj.iEEG_MEEG)
    error('Please convert and load the edf files first')
end

if isempty(obj.EpochWin)
    error('Please define epoch window to plot first')
end

if ~exist('figs')
    mkdir('figs')
end
cd('figs')

for i = 1:length(obj.iEEG_MEEG)
    D = obj.iEEG_MEEG{i};
    SampleInterval = [find(D.time == obj.EpochWin(1)/D.fsample):find(D.time == obj.EpochWin(2)/D.fsample)];
    parfor j = 1:length(D.chanlabels)
        ChannelInd = j;
        Data = squeeze(D(ChannelInd,:,:));
        figure
        plot(D.time(SampleInterval),Data(SampleInterval,:),'Color',[0.5 0.5 0.5]);
        grid on
        hold on
        plot(D.time(SampleInterval),mean(Data(SampleInterval,:),2),'LineWidth',2,'Color','r')
        title([D.chanlabels{j} '_' 'Block_' num2str(i) '_' 'RawTrace'],'Interpreter','none');
        set(gca,'FontSize',14)
        %set(findobj(gca,'type','line'),'linew',4)
        set(gcf,'Position',[0 100 1920 600])
        print([D.chanlabels{j} '_' 'Block_' num2str(i) '_' 'RawTrace'],'-dpng')
        close
    end
end
cd ..
end

