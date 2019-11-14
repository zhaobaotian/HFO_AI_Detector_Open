function SPMEEG2EDFConvert(D)
% Convert SPM MEEG to edf file
% Edf file will be written on disk
% clear header
% header.numtimeframes = D.nsamples;
% header.samplingrate = D.fsample;
% header.numchannels  = D.nchannels;
% header.channels  = D.chanlabels';
% 
% filename =D.fname;
% data = D(:,:,1);
% lab_write_edf(filename,data,header)

% Make edf header
clear hdr
hdr.Fs = D.fsample;
hdr.nChans = D.nchannels;
hdr.label = D.chanlabels';
hdr.nSamples = D.nsamples;
hdr.nSamplesPre = 0;
hdr.nTrials = 1;
hdr.chanunit = D.units';
hdr.chantype = D.chantype';
% Make data matrix
[data] = D(:,:,1);

filename =[D.fname,'.edf'];
data = D(:,:,1);

write_edf(filename, hdr, data)

end

