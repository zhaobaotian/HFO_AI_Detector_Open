function ChanLabels_New = Deblank_Names(Channel_Labels)
%DEBLANK_NAMES Remove blanks in Channel names
%   Baotian @ Beijing 20180811
ChanLabels_New = cell(length(Channel_Labels),1);
for i = 1:length(Channel_Labels)
    temp = Channel_Labels{i};
    ChanLabels_New{i} = temp(~isspace(Channel_Labels{i}));
end
end

