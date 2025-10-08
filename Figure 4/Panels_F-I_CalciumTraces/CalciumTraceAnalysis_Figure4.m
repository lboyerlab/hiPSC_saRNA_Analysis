% Ca trace analysis for figure 4 of saRNA manuscript -- 10/08/2025
%{ 

    Data was manually extracted from timelapses using Fiji ROI selection
    and plotting of z intensity. Files as follows:
        Day 14
          x  1. CGB: jRCaMP1b_Traces.xlsx (need to find date associated, guess is
            7/14/2025)
                > Reformatted into 20250714_Day14_CGB.xlsx (B1-3)
          x  2. CGB: 20250725_jRCaMP1b+puro.xlsx -- 7/25/25
                > Reformatted into 20250725_Day14_CGB.xlsx (B1-3)
          x  3. CDS: 20250724_Day14_0826Analysis.xlsx -- 7/24/25
                > Reformatted into 20250724_Day14_CDS.xlsx (A1 & B1)

        Day 30
          x  1. CGB: 20250730_Day30_CaTraces.xlsx 
                > Reformatted into 20250730_Day30_CGB.xlsx (B1-3)
          x  2. CDS: 20250810_Day30_AmtrakAnalysis.xlsx -- 8/10/25
                > Reformatted into 20250810_Day30_CDS.xlsx (A1-3 & B1-3)
          x  3. CDS: 20250809_Day30_0828Analysis.xlsx -- 8/9/25
                > Reformatted into 20250809_Day30_CDS.xlsx (A1-3 & B1-3)

%}

% clean traces were identified by eye -- sufficient signal and clear trends

%% import cleaned traces as numberical arrays sorted by sheet and sample


filenames_day14 = {'20250714_Day14_CGB.xlsx', '20250725_Day14_CGB.xlsx', '20250724_Day14_CDS.xlsx'};
filenames_day30 = {'20250730_Day30_CGB.xlsx', '20250810_Day30_CDS.xlsx', '20250809_Day30_CDS.xlsx'};

filenames_all = [filenames_day14, filenames_day30];

%% Loading in all data code used commented out and replaced with load command
files = filenames_all;
% allData = cell(numel(files),1);        % cell to hold per-file data

for f = 1:numel(files)
    % get sheet names
    [~,sheetNames] = xlsfinfo(files{f});
    
    % preallocate a cell array for this file
    fileSheets = cell(numel(sheetNames),1);
    
    for s = 1:numel(sheetNames)
        % read numeric data from this sheet
        data = readmatrix(files{f}, 'Sheet', sheetNames{s});
        fileSheets{s} = data;
    end
    
    % allData{f} = fileSheets;   % store all sheets of this file
end
    
%{ 
    allData{f} -- all sheets from fth file
    all data{f}{s} -- numeric matrix from sheet s of file f
%}

%}

%% Contains allData formatted from import code commented out above
load Figure4_CalciumTraceAnalysis.mat

%% Plotting all traces with displayed markers for findpeaks

all_metrics = cell(1,6);
fig_count = 1;
for i = 1:6
    for j = 1:length(allData{i})
        if j>1
            data = allData{i}{j};
            nPairs = floor(size(data,2)/2);
            for p = 1:nPairs
                x = data(:, 2*p-1);
                y = mat2gray(data(:, 2*p)); 
                
                figure(i)
                subplot(length(allData{i})-1, 1, j-1)
                hold on

                metrics = analyzeCaTrace_upsample(x,y,3.33,true); %fps > 30 means no upsampling

                all_metrics{i}{j-1}{p} = metrics;
                title(sprintf('File: %s | Sheet: %s', files{i}, sheetNames{j}), 'Interpreter','none');
                
            end
            
        end
    end
end

%% Plot calculated metrics and perform statistical analysis

metricsCell = all_metrics;

fields = {'NumPeaks','BPM','CV_IBI','RiseTime','DecayT50','dFdt_max'};

figure;
for f = 1:numel(fields)
    [vals, groups] = collectMetric_nested3v2(metricsCell, fields{f});
    
    if strcmp(fields{f}, 'CV_IBI')
        groups(vals==0) = []; % remove CV_IBI of 0 for 2 or fewe peaks
        vals(vals==0) = [];
    end


    subplot(1,numel(fields),f)
    hold on
    
    % boxplot summary
    boxchart(groups, vals, 'BoxFaceAlpha',0.2);  
    
    % swarm of points
    swarmchart(groups, vals, 'filled','MarkerFaceAlpha',0.7)
    
    title(fields{f});
    xlabel('Group');
    ylabel(fields{f});

    %

    % initialize new group vector
    newGroups = zeros(size(groups));
    
    % map 1,2,3 -> 1
    newGroups(ismember(groups, [1 2 3])) = 1;
    
    % map 4,5,6 -> 2
    newGroups(ismember(groups, [4 5 6])) = 2;

    p = kruskalwallis(vals,newGroups, 'off'); % prints p-values in order for each field
    fprintf('Field: %s | p: %f\n', fields{f}, p);

end


%%
function metrics = analyzeCaTrace_upsample(t, y, fps, doPlot)
% Analyze one calcium trace (normalized 0–1) 
% t = time vector (s), y = trace, fps = frames per sec
% doPlot = true/false

    if nargin < 4
        doPlot = false;
    end

    % --- Upsample if fps too low (<30 fps) ---
    if fps < 30
        upFactor = ceil(30/fps);  % e.g. 9 fps -> upsample ~4x
        t_hi = linspace(t(1), t(end), numel(t)*upFactor);
        y_hi = interp1(t, y, t_hi, 'pchip');  % smoother than linear
        t = t_hi; 
        y = y_hi;
        fps = fps * upFactor;
    end

    % --- Peak detection ---
    [pks, locs] = findpeaks(y, t, 'MinPeakProminence', 0.2, 'MinPeakDistance',0.3);
    numPeaks = numel(pks);

    % --- BPM and IBI ---
    if numPeaks > 1
        IBIs = diff(locs);
        BPM = mean(60 ./ IBIs); % average of BPM for each IBI
        CV_IBI = std(IBIs) / mean(IBIs);
    else
        IBIs = NaN; BPM = NaN; CV_IBI = NaN;
    end

    % --- Rise time (10–90%) and decay (T50) for largest peak ---
    if ~isempty(pks)
        [~, maxIdx] = max(pks);
        peakLoc = locs(maxIdx);
        peakAmp = pks(maxIdx);

        % Baseline = min before the peak
        base = min(y(t < peakLoc));
        F10 = base + 0.1*(peakAmp - base);
        F90 = base + 0.9*(peakAmp - base);
        F50 = base + 0.5*(peakAmp - base);

        i10 = find(y(1:find(t==peakLoc,1)) >= F10, 1, 'first');
        i90 = find(y(1:find(t==peakLoc,1)) >= F90, 1, 'first');
        if ~isempty(i10) && ~isempty(i90)
            riseTime = t(i90) - t(i10);
        else
            riseTime = NaN;
        end

        % Decay T50
        i50 = find(y(find(t==peakLoc,1):end) <= F50, 1, 'first');
        if ~isempty(i50)
            decayT50 = t(find(t==peakLoc,1) + i50 - 1) - peakLoc;
        else
            decayT50 = NaN;
        end
    else
        riseTime = NaN; decayT50 = NaN;
    end

    % --- Derivative feature ---
    dFdt_max = max(diff(y)./diff(t));

    % --- Package into struct ---
    metrics = struct( ...
        'NumPeaks', numPeaks, ...
        'BPM', BPM, ...
        'CV_IBI', CV_IBI, ...
        'RiseTime', riseTime, ...
        'DecayT50', decayT50, ...
        'dFdt_max', dFdt_max);

    % --- Optional plot ---
    if doPlot
        if length(pks) <=2
            plot(t,y,'r') % red line for fewer than 2 peaks
        else
            plot(t,y,'k')
        end
        
        plot(locs,pks, 'o')
        
        xlabel('Time (s)'); ylabel('Normalized F/F')
    end
end

%%
function [allVals, groupIdx] = collectMetric_nested3v2(metricsCell, fieldname)
% collectMetric_nested3: Extract a metric from a 3-level nested cell array of structs
%
% Inputs:
%   metricsCell - 3-level nested cell array
%   fieldname   - string, name of struct field to extract
%
% Outputs:
%   allVals     - numeric vector of metric values
%   groupIdx    - vector of outer group indices (same length as allVals)

    allVals = [];
    groupIdx = [];

    for i = 1:numel(metricsCell)              % outermost cell
        secondLevel = metricsCell{i};
        for j = 1:numel(secondLevel)          % second-level cell array
            thirdLevel = secondLevel{j};      % should be a cell array of structs
            for k = 1:numel(thirdLevel)       % loop structs
                S = thirdLevel{k};
                if isfield(S, fieldname) && ~isempty(S.(fieldname))
                    vals = S.(fieldname)(:);  % force into column vector
                    allVals = [allVals; vals]; %#ok<AGROW>
                    groupIdx = [groupIdx; repmat(i, numel(vals), 1)]; %#ok<AGROW>
                end
            end
        end
    end
end
