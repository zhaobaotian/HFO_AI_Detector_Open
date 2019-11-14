function obj = LoadCNN(obj)

% CNN classifer
obj.NoiseNet        = [obj.MainPath filesep 'Resnet101' filesep 'Noise1.0.net'];
obj.SpikeNet        = [obj.MainPath filesep 'Resnet101' filesep 'Spike1.0.net'];
obj.RippleNet       = [obj.MainPath filesep 'Resnet101' filesep 'Ripple1.0.net'];
obj.FastRippleNet   = [obj.MainPath filesep 'Resnet101' filesep 'FastRipple1.0.net'];

end

