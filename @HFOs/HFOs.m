classdef HFOs < handle
    
    properties
        % iEEG object
        iEEGRaw
        iEEGHighPass
        iEEGBandPass80
        iEEGBandPass250
        
        % Thresholds for all channels
        ThresholdsALL80
        ThresholdsALL250
        
        % Envelope of the 80 - 500 filtered signal
        EnvelopeFiltered80
        EnvelopeFiltered250
        
        % CandidateHFOs 80
        CandidateHFOsTimeStamps80
        
        % CandidateHFOs 250
        CandidateHFOsTimeStamps250
        
        % CandidateHFOs Final
        CandidateHFOsTimeStampsFinal
        CandidateHFOsCounts
        CandidateHFOsHFOsLabelsNoise
        CandidateHFOsHFOsLabelsSpike
        CandidateHFOsHFOsLabelsRipple
        CandidateHFOsHFOsLabelsFastRipple
        
        % CandidateHFOs final events
        CandidateHFOsFinalEventsTimeStampsTag
        CandidateHFOsFinalEventsTimeStamps
        CandidateHFOsFinalEvents80
        CandidateHFOsFinalEventsHighPass
                
        % TF maps
        TFMapMatrixLogSmoothed     
        
        % CandidateHFOs final events labels
        CandidateHFOsFinalEventsLabels
        
        % Filter noisy channels after labeling
                
        % Quality HFOs
        CandidateHFOsFinalCounts
        qualityHFOsCounts
        qualityHFOsFRCounts
        
    end
    
    properties % Parameters
        MainPath
        WindowLength
        Buffer
        SDthreshold
        GapThreshold
        
        MergeThreshold80_250
        
        BandPassHigh80
        BandPassHigh250
        FIRorder
        
        HighPass
        IIRorder
        
        % Deep CNN classifer        
        NoiseNet
        SpikeNet
        RippleNet
        FastRippleNet
        
        % For further exclude noisy channels
        ArtHFOsThresh
    end
    
    methods
        function obj = HFOs
            obj.WindowLength    = 0.2;
            obj.Buffer          = 0.2;
            obj.SDthreshold     = 5;
            obj.GapThreshold    = 0.05; % In second 
            obj.MergeThreshold80_250 = 0.05; % In second 
            
            obj.BandPassHigh80  = [80 500];
            obj.BandPassHigh250 = [250 500];
            obj.HighPass        = [8 490];            
            obj.FIRorder        = 64;
            obj.IIRorder        = 1;
            
            obj.ArtHFOsThresh   = 0.4;
            
            % obj.TFSmoothWin     = [2 10];
            
        end
    end
end

