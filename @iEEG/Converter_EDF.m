function obj = Converter_EDF(obj,filename_full,index_to_keep,prefix,Trigger)
%Converter_EDF Convert edf files to SPM meeg object
% FORMAT: obj = Converter_EDF(filename,index_to_keep,prefix)
% Input:
%       filename_full:   Full file name (with path) of the edf file
%                        needed to be converted, multiple edf files should
%                        be stored in different cells.
%       index_to_keep:   Useful channels you want to keep, could be 'all'
%                        if you want to save all channels.
%       prefix:          Prefix of the converted file, default: 'spmeeg_'
%       Trigger:         Indicate if this edf file is trigger channel
% Output:
%       obj:             iEEG object loaded with MEEG
% --------------------------------------------------------------
% THIENC, Tiantan Human Intracranial Electrophysiology & Neuroscience Center

% Baotian Zhao 20190505
% zhaobaotian0220@foxmail.com

if nargin < 2 || isempty(filename_full)
    [filename, path]       = uigetfile('*.edf','Please select edf file to convert','MultiSelect','on');
    if ischar(filename)
        filename_full      = [path filename];
    elseif iscell(filename)
        filename_full = cellfun(@(x) [path x],filename,'UniformOutput',false);
    else
        error('Please select proper EDF files')
    end
end

if nargin < 3 || isempty(index_to_keep)
    % read edf header using function in field trip
    if ischar(filename_full)
        edf_header         = ft_read_header(filename_full);
    elseif iscell(filename)
        edf_header         = ft_read_header(filename_full{1});
    end
    [index_to_keep,~]  = listdlg('ListString',edf_header.label,'PromptString',...
        'Select Channels to Keep');
end

if nargin < 4 || isempty(prefix)
    % add prefix to the converted file, by default 'spmeeg_'
    prefix             = 'spmeeg_';
end

if nargin < 5 || isempty(Trigger)
    % add prefix to the converted file, by default 'spmeeg_'
    Trigger            = 0;
end

if Trigger
    prefix             = 'DC_';
end

% save the channel index for further use
save('EDFChannels.mat','index_to_keep')


if ischar(filename_full)
    edf_header = ft_read_header(filename_full);
    % convert the data
    S.dataset = filename_full;
    S.mode    = 'continuous';
    if strcmp(index_to_keep,'all')
        S.channels = 'all';
    else
        S.channels = edf_header.label(index_to_keep);
    end
    [filepath,name,ext] = fileparts(filename_full);
    cd(filepath)
    filename   = [name,ext];
    S.outfile  = [prefix filename];
    if ~Trigger
        obj.iEEG_MEEG{1}   = spm_eeg_convert(S);
    elseif Trigger
        obj.Trigger_MEEG{1}   = spm_eeg_convert(S);
    end
    disp('-------------------------------')
    disp('--------- MEEG loaded ---------')
end

if iscell(filename_full)
    for i = 1:length(filename_full)
        edf_header = ft_read_header(filename_full{i});
        % convert the data
        S.dataset = filename_full{i};
        S.mode    = 'continuous';
        if strcmp(index_to_keep,'all')
            S.channels = 'all';
        else
            S.channels = edf_header.label(index_to_keep);
        end
        [filepath,name,ext] = fileparts(filename_full{i});
        cd(filepath)
        filename    = [name,ext];
        S.outfile   = [prefix filename];
        D           = spm_eeg_convert(S);
        if ~Trigger
            obj.iEEG_MEEG{i} = D;
        elseif Trigger
            obj.Trigger_MEEG{i} = D;
        end
    end
    disp('-------------------------------')
    disp('--------- MEEG loaded ---------')
end
end

