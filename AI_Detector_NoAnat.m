%% Path
clear
DetectorPath = 'D:\HFO_AI_Detector';
SPMPath      = 'D:\spm12_7219';
subPath      = 'I:\PT061_Onset';
%
addpath(genpath(DetectorPath))
addpath(SPMPath)
cd(subPath)
% tic

%% Stage1: Channel selection
% Initialize
Elec = DepthElectrodes;
Elec.MainPath = DetectorPath;
Elec.subPath = subPath;
try
    load('EDFChannels.mat')
    Elec.LoadEDF([],index_to_keep);
catch
    Elec.LoadEDF([],[]);
end
disp('-------------Inputs loaded-------------')

% Process iEEG
Elec.iEEGPreprocessingRMS;
% Label extreme amplitude channels
Elec.LabelExtremeAmpChans;
disp('--Extreme amplitude channels labeled---')
% Finalize data
SPMEEG2EDFConvert(Elec.iEEG.iEEG_MEEG{1})
disp('------------EDF file saved-------------')
% Delete temp files
Elec.DeleteTempFiles;
disp('-----------Temp files deleted----------')

%%
HFO = HFOs;
HFO.MainPath = Elec.MainPath;
HFO.iEEGRaw = Elec.iEEG.iEEG_MEEG{1};
%
HFO.BaseLineCorrectiEEG;
HFO.BandPassFilterHigh;
HFO.HighPassFilter;
%
disp('--------Calculating thresholds---------')
HFO.CalculateThresholds;
disp('--------Calculating envelopes----------')
HFO.CalculateEnvelopes;
disp('-------Finding >80Hz timestamps--------')
HFO.FindHFOTimeStamps80;
disp('-------Finding >250Hz timestamps-------')
HFO.FindHFOTimeStamps250;
HFO.MergeHFOTimeStamps;
disp('---------HFOs timestamps merged--------')
HFO.ExtractEvents;
disp('---------HFOs events extracted---------')


% Plot Final TF map using parallal computation
disp('------------Plotting TF maps-----------')
D_filtered               = HFO.iEEGBandPass80;
HFO_Candidates_Raw_BC    = HFO.CandidateHFOsFinalEventsHighPass;
HFO_Candidates_highpass  = HFO.CandidateHFOsFinalEvents80;
WindowLength             = HFO.WindowLength;

Plot_Final(D_filtered,HFO_Candidates_Raw_BC,HFO_Candidates_highpass,WindowLength)
% Labeling events with deep CNN
disp('---Classifying and labeling events-----')
HFO.LoadCNN;
HFO.ClassifyEvents;
HFO.LabelEvents;
HFO.EliminateNoiseHFOChannels;


%% Stage3: Results visualization

HFOV = HFOVis;
HFOV.MainPath                = Elec.MainPath;
HFOV.SelectedBipolarChannels = Elec.BipolarElectrodeName;

HFOV.HFOCandidatesTimestamps = HFO.CandidateHFOsFinalEventsTimeStamps;
HFOV.HFOCandidatesLabels     = HFO.CandidateHFOsFinalEventsLabels;

HFOV.Fsample                 = HFO.iEEGRaw.fsample;
% Duration in minutes
HFOV.Duration                = (HFO.iEEGRaw.nsamples / HFO.iEEGRaw.fsample) / 60;

% HFOs counts results
HFOV.HFOCountsCandidates     = HFO.CandidateHFOsFinalCounts;
HFOV.HFOCountsQualityHFOs    = HFO.qualityHFOsCounts;
HFOV.HFOCountsQualityFRHFOs  = HFO.qualityHFOsFRCounts;

% Write candidates annotations
HFOV.WriteAnnotations;
disp('----------Annotations Written----------')

% Save results
HFOV.SaveResults
HFO.EnvelopeFiltered80               = [];
HFO.EnvelopeFiltered250              = [];
HFO.CandidateHFOsFinalEvents80       = [];
HFO.CandidateHFOsFinalEventsHighPass = [];
save('ResultsAll.mat','Elec','HFO','HFOV')
disp('----------------ALL DONE----------------')

%%





