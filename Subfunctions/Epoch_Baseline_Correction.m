function [HFO_Candidates_Raw_BC] = Epoch_Baseline_Correction(HFO_Candidates_Raw)
%EPOCH_BASELINE_CORRECTION baseline correction for the epoched raw data
HFO_Candidates_Raw_BC = cell(length(HFO_Candidates_Raw),1);
for i = 1:length(HFO_Candidates_Raw)
    HFO_Candidates_Raw_BC{i} = HFO_Candidates_Raw{i} - mean(HFO_Candidates_Raw{i},2);
end
end
% figure
% plot(HFO_Candidates_Raw_BC{i}(141,:)./3)
% hold on
% plot(HFO_Candidates_highpass{i}(141,:))
% axis tight
% grid on
% xlabel('Time (ms)')
% ylabel('Amplitude(uV)')
% legend('Raw(Scaled)','HighPassFiltered')
