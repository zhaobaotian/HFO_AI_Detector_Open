function obj = SelectChannels(obj)

% Reduce channels

D = obj.iEEGRaw.iEEG_MEEG{1};
D = SPMGUIChannelSelect(D);
obj.iEEGRaw.iEEG_MEEG{1} = D;

% Write the final EDF
% You can also use EEGlab GUI to export the EDF file
SPMEEG2EDFConvert(D)

end

