% Delta F/F_0 calculations for figure 3 -- 10/08/2025

%% Import traces as a cell array of numeric arrays with time as column 1 and signal as column 2

% uncomment the trace to load, labeled by cell type and sensor type

traces = struct2cell(load('NeuronCaTraces_06102025.mat'));
%traces = struct2cell(load('20250629_CM_jR_RepTraces.mat'));
%traces = struct2cell(load('20250629_CM_A5_RepTraces.mat'));
%traces = struct2cell(load('20251008_Neuron_A5.mat'));

traces = traces{1};

%% set parameters
%   window_size  - size of the sliding window in samples (e.g., 1000)
%   percentile   - percentile to use (e.g., 10 for 10th percentile)

window_size = 100;
percentile = 10;

% Iterate through cell array
figure(1) % normalized traces
hold on

figure(2) % raw trace and F0 calculation
hold on

for i = 1:length(traces)
    trace = traces{i}(:,2);
    trace_f0 = estimate_f0(trace, window_size, percentile);
    figure(1)
    plot(traces{i}(:,1), (trace-trace_f0)./trace_f0) % make negative for ASAP5

    figure(2)
    plot(traces{i}(:,1), trace)
    plot(traces{i}(:,1), trace_f0)
end

%%
function f0 = estimate_f0(trace, window_size, percentile)
% Estimate F0 baseline using sliding percentile
% Inputs:
%   trace        - 1D array of fluorescence values
%   window_size  - size of the sliding window in samples (e.g., 1000)
%   percentile   - percentile to use (e.g., 10 for 10th percentile)
% Output:
%   f0           - estimated baseline F0 over time

n = length(trace);
half_window = floor(window_size / 2);
f0 = zeros(size(trace));

for i = 1:n
    start_idx = max(i - half_window, 1);
    end_idx = min(i + half_window, n);
    window = trace(start_idx:end_idx);
    f0(i) = prctile(window, percentile);
end

end
