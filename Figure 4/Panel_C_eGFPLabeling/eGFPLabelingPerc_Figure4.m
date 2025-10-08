% Labeling percent analysis for figure 4 of saRNA manuscript -- 10/08/2025

%{
 from histograms saved in FijiMacro_eGFP_analysis folder, extract the
 histogram, remove missing parts then set threshold (at 25 for present
 analysis) those above are positive for eGFP and below are negative, then
 can get percent from this
%}

T = readtable('4x_A1_71425_nopuro_011.csv'); %replace file name for each .csv
T(any(ismissing(T), 2), :) = [];


%%
inds = unique(T.ROI);

perc = [];
denom = [];
num = [];
for i = 1:length(inds)
    count = T.Count(T.ROI == inds(i));
    dark = count(1:25);
    bright = count(26:end);
    perc(i) = sum(bright)/(sum(dark)+sum(bright));
    num(i) = sum(bright);
    denom(i) = (sum(dark)+sum(bright));
end


