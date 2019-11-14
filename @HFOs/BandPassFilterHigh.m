function obj = BandPassFilterHigh(obj)


if obj.iEEGRaw.fsample <= 1000
    prefix  = 'BpHi80_';
    type    = 'fir';
    order   = obj.FIRorder;
    freq    = [obj.BandPassHigh80(1) obj.BandPassHigh80(2) - 5];
    
    obj.iEEGBandPass80 = SPMFIRBandpass(obj.iEEGRaw,prefix,type,order,freq);
    
    prefix  = 'BpHi250_';
    type    = 'fir';
    order   = obj.FIRorder;
    freq    = [obj.BandPassHigh250(1) obj.BandPassHigh250(2) - 5];
    
    obj.iEEGBandPass250 = SPMFIRBandpass(obj.iEEGRaw,prefix,type,order,freq);
    
else
    prefix  = 'BpHi80_';
    type    = 'fir';
    order   = obj.FIRorder;
    freq    = obj.BandPassHigh80;
    
    obj.iEEGBandPass80 = SPMFIRBandpass(obj.iEEGRaw,prefix,type,order,freq);
    
    prefix  = 'BpHi250_';
    type    = 'fir';
    order   = obj.FIRorder;
    freq    = obj.BandPassHigh250;
    
    obj.iEEGBandPass250 = SPMFIRBandpass(obj.iEEGRaw,prefix,type,order,freq);
end

end

