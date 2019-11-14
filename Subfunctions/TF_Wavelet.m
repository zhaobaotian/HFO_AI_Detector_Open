function [HFO_Candidates_Raw_BC_TF] = TF_Wavelet(HFO_Candidates_Raw_BC,fs)
%TF_WAVELET time frequency transform using wavelet 1:500Hz
t = 0:1/fs:0.5;
freq = 1:500;
HFO_Candidates_Raw_BC_TF = cell(length(HFO_Candidates_Raw_BC),1);
parfor i = 1:length(HFO_Candidates_Raw_BC)
    if isempty(HFO_Candidates_Raw_BC{i})
        continue
    end
P = morlet_transform(HFO_Candidates_Raw_BC{i}, t, freq);
HFO_Candidates_Raw_BC_TF{i} = P;
end
% 
% for i = 1:100
% figure
% imagesc(10*log10(squeeze(P(i,:,:))'))
% axis xy
% colormap jet
% end

% figure
% plot(HFO_Candidates_Raw_BC{4}(70,:))
% hold on
% plot(HFO_Candidates_highpass{4}(70,:))
% axis tight
% 
% plocECG(D_filtered(15,:,:))
