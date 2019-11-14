function obj = HighPassFilter(obj)


% if obj.iEEGRaw.fsample <= 1000
    prefix           = 'HighPass_';
    type             = 'butterworth';
    order            = obj.IIRorder;
    freq             = obj.HighPass;
    obj.iEEGHighPass = SPMIIRBandpass(obj.iEEGRaw,prefix,type,order,freq);
% else
%     prefix  = 'HighPass_';
%     type    = 'butterworth';
%     order   = obj.IIRorder;
%     freq    = obj.HighPass;
%     
%     obj.iEEGHighPass = SPMIIRHighpass(obj.iEEGRaw,prefix,type,order,freq);
% end

end
% SPMEEG2EDFConvert(obj.iEEGHighPass)
