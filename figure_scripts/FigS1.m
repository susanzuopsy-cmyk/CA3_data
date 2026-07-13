%% FigS1.m
% Reproduces published Figure S1 panels A-D (normalized session-change in
% locomotion, across treatments) from the curated source-data workbook
% only. Single-group jittered-scatter + mean+/-SEM style, matching the
% published panel style (across-treatment design, not within-treatment
% paired).
%
% Input : manuscript/source_data/FigS1_source_data.xlsx
% Output: manuscript/figures_repro/FigS1_A-D.png
%%

set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultUicontrolFontName', 'Arial');

scriptDir = fileparts(mfilename('fullpath'));
srcPath   = fullfile(scriptDir, '..', 'source_data', 'FigS1_source_data.xlsx');
outDir    = fullfile(scriptDir, '..', 'figures_repro');
if ~exist(outDir, 'dir'), mkdir(outDir); end

treatments = {'CTRL', 'LCA3', 'RCA3'};

panels = {
    'A', 'TravelDistance_behavioral', 'Total Distance (m)';
    'B', 'MeanSpeed_behavioral',      'Mean Speed (cm/s)';
    'C', 'TotalDistance_ephys',       'Total Distance (m)';
    'D', 'MeanSpeed_ephys',           'Mean Speed (cm/s)';
};

fig = figure('Position', [80 80 1000 900], 'Color', 'w', 'Name', 'Figure S1 A-D');
for i = 1:size(panels, 1)
    subplot(2, 2, i);
    T = readtable(srcPath, 'Sheet', panels{i, 2});
    dataByGroup = cell(1, 3);
    for t = 1:3
        dataByGroup{t} = T.NormalizedDelta(strcmp(T.Treatment, treatments{t}));
    end
    opts = struct('panelLabel', panels{i, 1}, ...
        'yLabel', {{panels{i, 3}, 'Norm. change (Test-Training)/(Test+Training)'}});
    plot_normalized_delta_group(dataByGroup, treatments, opts);
end
sgtitle('Figure S1  --  Normalized session-change in locomotion, across treatments', ...
    'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');

outPath = fullfile(outDir, 'FigS1_A-D.png');
saveas(fig, outPath);
close(fig);
fprintf('Saved %s\n', outPath);
