function obj = ClassifyEvents(obj)

% Load CNNs
load(obj.NoiseNet,'-mat');
NoiseNet = trainedGN;

load(obj.SpikeNet,'-mat');
SpikeNet = trainedGN;

load(obj.RippleNet,'-mat');
RippleNet = trainedGN;

load(obj.FastRippleNet,'-mat');
FastRippleNetNet = trainedGN;


cd('PCS')

D = obj.iEEGBandPass80;
Channeldir = D.chanlabels';

obj.CandidateHFOsHFOsLabelsNoise = cell(length(D.chanlabels),1);
obj.CandidateHFOsHFOsLabelsSpike = cell(length(D.chanlabels),1);
obj.CandidateHFOsHFOsLabelsRipple = cell(length(D.chanlabels),1);
obj.CandidateHFOsHFOsLabelsFastRipple = cell(length(D.chanlabels),1);

for i = 1:length(Channeldir)
    fprintf(1, 'Now Classifying %s\n', Channeldir{i});
    cd(Channeldir{i})
    filePattern = '*Train.png'; % Change to whatever pattern you need.
    Candidates_Images = dir(filePattern);
    Candidates_Images = {Candidates_Images.name};
    if isempty(Candidates_Images)
        cd ..
        continue
    elseif ~isempty(Candidates_Images)
        mkdir('Classify')
        for j = 1:length(Candidates_Images)
            copyfile(Candidates_Images{j},'Classify')
        end
        allImages  = imageDatastore('Classify');
        % load CNN net: Noise
        [YPredN,~] = classify(NoiseNet,allImages,'ExecutionEnvironment','cpu');
        obj.CandidateHFOsHFOsLabelsNoise{i} = YPredN == 'Noi';
        
        % load CNN net: Spike   
        [YPredS,~] = classify(SpikeNet,allImages,'ExecutionEnvironment','cpu');
        obj.CandidateHFOsHFOsLabelsSpike{i} = YPredS == 'S';
        
        % load CNN net: Ripple     
        [YPredR,~] = classify(RippleNet,allImages,'ExecutionEnvironment','cpu');
        obj.CandidateHFOsHFOsLabelsRipple{i} = YPredR == 'R';
        
        % load CNN net: FastRipple        
        [YPredFR,~] = classify(FastRippleNetNet,allImages,'ExecutionEnvironment','cpu');
        obj.CandidateHFOsHFOsLabelsFastRipple{i} = YPredFR == 'FR';        
        
    end
    cd ..
end
cd ..
end
