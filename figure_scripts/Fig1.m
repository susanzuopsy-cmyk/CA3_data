%% Fig1.m
% Reproduces published Figure 1 panels C-H (object-location discrimination
% index, Training vs Test) from the curated source-data workbook only.
%
% Input : manuscript/source_data/Fig1_source_data.xlsx
% Output: manuscript/figures_repro/Fig1_C-H.png
%%

set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultUicontrolFontName', 'Arial');

scriptDir = fileparts(mfilename('fullpath'));
srcPath   = fullfile(scriptDir, '..', 'source_data', 'Fig1_source_data.xlsx');
outDir    = fullfile(scriptDir, '..', 'figures_repro');
if ~exist(outDir, 'dir'), mkdir(outDir); end

T = readtable(srcPath, 'Sheet', 'DiscriminationIndex');

panels = {
    'C', 'behavioral', 'CTRL', 'Control';
    'D', 'behavioral', 'LCA3', 'Left CA3 inhibition';
    'E', 'behavioral', 'RCA3', 'Right CA3 inhibition';
    'F', 'ephys',      'CTRL', 'Control';
    'G', 'ephys',      'LCA3', 'Left CA3 inhibition';
    'H', 'ephys',      'RCA3', 'Right CA3 inhibition';
};

% Shared y-range per cohort
behavVals = [T.Training(strcmp(T.Cohort, 'behavioral')); T.Test(strcmp(T.Cohort, 'behavioral'))];
ephysVals = [T.Training(strcmp(T.Cohort, 'ephys'));      T.Test(strcmp(T.Cohort, 'ephys'))];
yLimBehav = cohortYLim(behavVals);
yLimEphys = cohortYLim(ephysVals);

fig = figure('Position', [60 60 1080 720], 'Color', 'w', 'Name', 'Figure 1 C-H');
for i = 1:size(panels, 1)
    subplot(2, 3, i);
    letter = panels{i, 1}; cohort = panels{i, 2}; treat = panels{i, 3}; grpLabel = panels{i, 4};

    mask = strcmp(T.Cohort, cohort) & strcmp(T.Treatment, treat);
    train = T.Training(mask); test = T.Test(mask);

    if strcmp(cohort, 'behavioral'), yLim = yLimBehav; else, yLim = yLimEphys; end

    opts = struct('panelLabel', letter, 'groupLabel', grpLabel, 'yLim', yLim);
    if i == 1 || i == 4
        opts.yLabel = 'Discrimination index';
    end
    plot_paired_box(train, test, opts);
end
sgtitle('Figure 1  --  Object-location discrimination index, Training vs Test', ...
    'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');

outPath = fullfile(outDir, 'Fig1_C-H.png');
saveas(fig, outPath);
close(fig);
fprintf('Saved %s\n', outPath);

function yLim = cohortYLim(vals)
    yMin = min(vals); yMax = max(vals); ySpan = yMax - yMin;
    yLim = [yMin - ySpan * 0.08, yMax + ySpan * 0.10];
end
