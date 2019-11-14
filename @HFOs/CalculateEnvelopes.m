function obj = CalculateEnvelopes(obj)

% For [80 500] envelope
EnvelopePara80 = round(15/1000*obj.iEEGBandPass80.fsample);
for i = 1:obj.iEEGBandPass80.nchannels
    obj.EnvelopeFiltered80(i,:) = envelope(abs(obj.iEEGBandPass80(i,:,1)),EnvelopePara80,'peak')';
    % the number in the middle
    % e.g. 10 in this case controls the smoothness of the envelope,
    % this can be arbitrary and depending on the frequency band and sampling
    % rate    
end


% For [250 500] envelope
EnvelopePara250 = round(6/1000*obj.iEEGBandPass80.fsample);
for i = 1:obj.iEEGBandPass250.nchannels
    obj.EnvelopeFiltered250(i,:) = envelope(abs(obj.iEEGBandPass250(i,:,1)),EnvelopePara250,'peak')';    
end

end

