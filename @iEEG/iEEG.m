classdef iEEG < handle
    properties                   % Subject Specific Information
        SubID             char   % Subject ID, e.g. PT001
        Age               double % Subject age
        Gender            char   % Subject gender
        ChanInUse         double % iEEG channels
        % BadChan           double % Bad Channels, can be noisy or out of brain etc.
        PathoChan         double % Pathological channels where seizure onsets (Index)
        DCChan            double % DC channel indicates the triggers of events (Index)
        nElectrodes       double % Number of intracranial electrodes
        nContacts         double % Number of contacts in total
    end
    properties                   % Paradigm related parameters
        MainSubFolder     char   % Main subject folder for a specific paradigm
        iEEG_MEEG         cell   % MEEG object of SPM, coule be cells if there are 2 or more blocks
        Trigger_MEEG      cell   % MEEG containing trigger channel/channels
        matFile           cell   % .mat file including the behavior data and timestamps from PTB
        TaskName          char   % Name of the cognitive task
        LineNoise         double % Line noise, 50Hz in China
        
        HighPassFreq      double % High pass filter cutoff frequency
        LowPassFreq       double % Low pass filter cutoff frequency
        BandPassFreq      double % Band pass filter cutoff frequencies
        
        nSessions         double % How many times you repeat one task on one patient
        nBlock            double % The number of block of one task
        nTrialsEachBlock  double % The number of trails in one block
        nTrialsTotal      double % nSessions * nBlock * nTrialsEachBlock
        
        HeaderTriggers    double % Number of TTL triggers precedes event triggers, default: 0
        TailTriggers      double % Number of TTL triggers following event triggers, default: 0
        DCTriggers        cell   % Timestamps read from DC channels in vector
        MatTriggers       cell   % Timestamps read from behavior mat data
        EpochWin          double % Epoch time window, e.g. [-500, 1500]
        
        BehaviorData             % Behavior data object
        
        ConditionList1    cell   % Condition list 1
        ConditionList2    cell   % Condition list 2
        ConditionList3    cell   % Condition list 3
        
        Conditions1       cell   % Conditions 1
        Conditions2       cell   % Conditions 2
        Conditions3       cell   % Conditions 3
        
        Frequencies       double % Frequencies used during time frequency transform
    end
    methods
        function obj = iEEG()
            if ~exist('spm','file') % Check the path of SPM
                error('Please add SPM folder first')
            end
            spm('defaults','EEG') % Initialize SPM EEG module
        end
        function disp(obj)
            disp('iEEG preprocessing pipeline object')
        end
        function Frequency = get.Frequencies(obj)
            if isempty(obj.Frequencies)
                disp(' - Delta          : 1-3 Hz  ')
                disp(' - Theta          : 4-7 Hz  ')
                disp(' - Alpha          : 8-12 Hz ')
                disp(' - Beta1          : 13-20 Hz')
                disp(' - Beta2          : 21-35 Hz')
                disp(' - Gamma          : 36-69 Hz')
                disp(' - HFB            : 70-170 Hz')
                disp(' - RippleBand     : 80-250Hz')
                disp(' - FastRippleBand : 250-500Hz')
            end
            Frequency = obj.Frequencies;
        end
        
    end
end