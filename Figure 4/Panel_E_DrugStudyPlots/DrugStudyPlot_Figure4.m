% Open dialog to select multiple files
[fileNames, pathName] = uigetfile({'*.csv;*.txt;*.dat','Data Files (*.csv, *.txt, *.dat)'}, ...
                                  'Select Data Files', ...
                                  'MultiSelect', 'on');

% Handle single vs multiple selection
if ischar(fileNames)
    fileNames = {fileNames};  % Convert to cell array if only one file selected
end

% Initialize cell array to hold data
dataCells = cell(1, numel(fileNames));

% Loop through each selected file
for i = 1:numel(fileNames)
    fullPath = fullfile(pathName, fileNames{i});
    try
        data = readmatrix(fullPath);  % More robust than load()
    catch
        warning('Could not read file: %s', fileNames{i});
        continue;
    end

    % Convert to column vector if needed
    if isvector(data)
        dataCells{i} = data(:);  % Force column
    elseif size(data, 2) == 1
        dataCells{i} = data;
    elseif size(data, 1) == 1
        dataCells{i} = data';  % Transpose row to column
    else
        warning('File "%s" has more than one column — storing full matrix.', fileNames{i});
        dataCells{i} = data;  % Keep whole matrix if not 1D
    end
end

% Optional: convert to matrix if all vectors are same length
try
    dataMatrix = cell2mat(dataCells');  % Each file's data becomes one column
    disp('Loaded data into matrix (each column = one file).');
catch
    warning('Not all data vectors are the same length. Data kept in cell array.');
end

%%
for i = 1:length(dataCells)
    figure(i)
    hold on
    
    traces = dataCells{1,i};
    for j = 2:length(traces(1,:))
        subplot(length(traces(1,:))-1, 1, j-1)
        plot(traces(:,j))
        set(gca, 'XTickLabel', [], 'YTickLabel', [])
        xlabel('')
        ylabel('')

    end
    
end

%% Plotting

A1_0 = [15
8
2
15
19
16
9
6
21
30
17
14
5];

A1_30 = [4
11
13
12
5
27
10
7
5
8
8
4
3
4
4
4
23
23
23
23];

A2_0 = [23
15
25
19
26
15
11
17
19
8
10
9
10
11
16
22
7
9
25
17];

A2_30 = [5
4
4
4
3
4
4
3
3
4
3
5
2
2];

A3_0 = [10
19
13
23
10
10
4
6
5
10
4
10
17
6
8
4
11
2
5];

A3_30 = [46
25
25
56
26
55
70
44
30
20
41
22
28
46
23
26
21
20
24
24
28
31
34];

%%
A1_0_bpm = 2*A1_0;
A1_30_bpm = 2*A1_30;
A2_0_bpm = 2*A2_0;
A2_30_bpm = 2*A2_30;
A3_0_bpm = 2*A3_0;
A3_30_bpm = 2*A3_30;
%%
figure
hold on
swarmchart(ones(1,length(A1_0_bpm)), A1_0_bpm)
bar(1, mean(A1_0_bpm))
errorbar(1, mean(A1_0_bpm), std(A1_0_bpm))

swarmchart(2*ones(1,length(A1_30_bpm)), A1_30_bpm)
bar(2, mean(A1_30_bpm))
errorbar(2, mean(A1_30_bpm), std(A1_30_bpm))

% propanolol
swarmchart(4*ones(1,length(A2_0_bpm)), A2_0_bpm)
bar(4, mean(A2_0_bpm))
errorbar(4,mean(A2_0_bpm), std(A2_0_bpm))

swarmchart(5*ones(1,length(A2_30_bpm)), A2_30_bpm)
bar(5, mean(A2_30_bpm))
errorbar(5,mean(A2_30_bpm), std(A2_30_bpm))

% isopreteranol
swarmchart(7*ones(1,length(A3_0_bpm)), A3_0_bpm)
bar(7, mean(A3_0_bpm))
errorbar(7, mean(A3_0_bpm), std(A3_0_bpm))

swarmchart(8*ones(1,length(A3_30_bpm)), A3_30_bpm)
bar(8, mean(A3_30_bpm))
errorbar(8, mean(A3_30_bpm), std(A3_30_bpm))

%%
[h1, p1] = ttest2(A1_0_bpm, A1_30_bpm);
[h2, p2] = ttest2(A2_0_bpm, A2_30_bpm);
[h3, p3] = ttest2(A3_0_bpm, A3_30_bpm);