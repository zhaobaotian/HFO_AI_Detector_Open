classdef DepthElectrodes < handle
    
    properties
        MainPath
        subPath
        % Raw files
        AnatFile
        ElectrodeNameFile
        ElectrodePosFile
        
        % Electrode data
        ElectrodeName
        ElectrodePos
        ContactsPostionsIJK
        BipolarElectrodeName
        
        BipolarRMSElectrodeName
        
        ElectrodeGreyVoxel
        ElectrodeGreyPercentage
        
        BipolarRMS
        
        % Brain masks
        StrippedBrain
        BrainMask
        GreyMask
                
        % iEEG obj
        iEEG
        
        % Labels for single contact
        OutBrain
        WhiteMatterLoc
        
        % Labels for bipolar channels
        BipolarOutBrain
        BipolarWhiteMatterLoc
        BipolarEEGTraceLabel
        BipolarEEGTraceLabelAll
        
        BipolarEEGTraceExtAmpLabel
        BipolarEEGTraceExtAmpLabelAll
        
        BipolarInclusion
        
    end
    properties  % Properties for parameters
        GreyMatterThreshold
        WhiteMatterPercentageThreshold
        WhiteMatterRMSThreshold
        
        ExtremeAmpThreshold
        ExtremeAmpDurThreshold
        
        ElectrodeRadius
        
    end
    
    methods
        function obj = DepthElectrodes
            obj.MainPath                         = 'D:\HFO_AI_Detector';
            obj.subPath                          = 'D:\1.HFO_Data\Zhuli';
            obj.GreyMatterThreshold              = 0.4;
            obj.WhiteMatterPercentageThreshold   = 0.3;
            obj.WhiteMatterRMSThreshold          = 0.35;
            
            obj.ExtremeAmpThreshold              = 2000; % In uV
            obj.ExtremeAmpDurThreshold           = 0.5;    % In second
            
            obj.ElectrodeRadius                  = 1;            
        end
    end
end

