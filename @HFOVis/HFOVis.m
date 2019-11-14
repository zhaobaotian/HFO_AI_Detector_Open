classdef HFOVis < handle
    
    properties
        % MainPath
        MainPath
        % Raw files
        AnatFile
        ElectrodeNameFile
        ElectrodePosFile
        
        % Bipolar information
        BipolarElectrodeName
        BipolarInclusion
        SelectedBipolarChannels
        SelectedBipolarElectrodeIJK
        
        % Sampling rate
        Fsample
        % Duration
        Duration
                
        % Bipolar electrode name and position from text
        BipolarElectrodeNametxt
        BipolarElectrodePostxt
        
        % Electrode Mask
        BipolarElectrodeMask
        BipolarElectrodeMaskFile
        
        % HFOs files
        CandiadteHFOsFile
        QualityHFOsFile
        QualityFRHFOsFile 
        
        
        % HFO information generated from stage2
        % For annotations 
        HFOCandidatesLabels
        HFOCandidatesTimestamps
        
        % For nii visualization
        HFOCountsCandidates
        HFOCountsQualityHFOs
        HFOCountsQualityFRHFOs
        
        % Parameters for the HFOs imaging
        BipolarElectrodeCenterRadius
        
        
    end
    
    methods
        function obj = HFOVis
               obj.BipolarElectrodeCenterRadius = 4;
        end
    end
end

