function [HFO_Candidates_Raw_BC_TF_Log] = Log_Power(HFO_Candidates_Raw_BC_TF)
%LOG_POWER calculate the log power of the raw energy
%   log10(RawPower)

nChannels = length(HFO_Candidates_Raw_BC_TF);
HFO_Candidates_Raw_BC_TF_Log = cell(nChannels,1);

for i = 1:nChannels
HFO_Candidates_Raw_BC_TF_Log{i} = log10(HFO_Candidates_Raw_BC_TF{i});
end

% log10(ans)
% figure
% imagesc(squeeze(ans(1,:,:)))
% colormap jet
% axis xy