function obj = RenameChan(obj,AmpType)
%RenameChan Rename mislabeled channel names, NOT the trigger labels
% FORMAT: obj = RenameChan(obj,AmpType)
% Input:
%       AmpType:  Data collection EEG amplifier, possible input:
%                 'NK':     for Nihon Kohden EEG amplifier
%                 'Others':  will call a renaming GUI for manually correct any mislabels
% Output:
%       obj:      iEEG object with renamed meeg object
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190505
% zhaobaotian0220@foxmail.com

if nargin < 1 || isempty(obj.iEEG_MEEG)
    error('Please convert and load the edf files first')
end

if nargin < 2 || isempty(AmpType)
    warning('Please set proper amplifier type, e.g. NK, Others')
    AmpType = 'NK';
    disp('Amplifier type set to "NK"')
end

switch AmpType
    case 'NK' % For Nihon Kohden EEG amplifier
        for i = 1:length(obj.iEEG_MEEG)
            meeg_temp = obj.iEEG_MEEG{i};
            Channel_Labels_Raw = meeg_temp.chanlabels';
            Channel_Labels_New = Deblank_Names(Channel_Labels_Raw);
            Pattern = '-Ref';
            Channel_Labels_New = Remove_Name_Pattern(Channel_Labels_New,Pattern);
            Channel_Labels_New = cellfun(@(x) x(3+1:end),Channel_Labels_New,'UniformOutput',false);
            meeg_temp = struct(meeg_temp);
            for j = 1:length(Channel_Labels_New)
                meeg_temp.channels(j).label = Channel_Labels_New{j};
            end
            meeg_temp = meeg(meeg_temp);
            save(meeg_temp);
            obj.iEEG_MEEG{i} = meeg_temp;
        end
    case 'Others'
        % Under construction ...
        % Call the rename GUI for manually correct any mislabels
        Channel_Renaming_UI
end

end


