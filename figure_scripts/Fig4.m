%% Fig4.m
% Reproduces published Figure 4 panels A-I (spike-LFP gamma phase-locking
% MI / ratio, Training vs Test) from the curated source-data workbook only.
% Mean+/-SEM + thin individual-cell-line style, matching the published
% panel style.
%
% Input : manuscript/source_data/Fig4_source_data.xlsx
% Output: manuscript/figures_repro/Fig4_A-I.png
%%

set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultUicontrolFontName', 'Arial');

scriptDir = fileparts(mfilename('fullpath'));
srcPath   = fullfile(scriptDir, '..', 'source_data', 'Fig4_source_data.xlsx');
outDir    = fullfile(scriptDir, '..', 'figures_repro');
if ~exist(outDir, 'dir'), mkdir(outDir); end

T = readtable(srcPath, 'Sheet', 'GammaMI');

metrics   = {'logMIlow', 'logMIhigh', 'r'};
metricLbl = {'log MI (low-\gamma)', 'log MI (high-\gamma)', 'r = log(MI_{low}/MI_{high})'};
treatDisp = {'CTRL', 'LCA3', 'RCA3'};
treatLbl  = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};
panelLet  = {'A', 'B', 'C'; 'D', 'E', 'F'; 'G', 'H', 'I'};

fig = figure('Position', [60 40 1080 1000], 'Color', 'w', 'Name', 'Figure 4 A-I');
for m = 1:3
    mMask = strcmp(T.Metric, metrics{m});
    yAll = [T.Training(mMask); T.Test(mMask)];
    yLim = [min(yAll) - range(yAll) * 0.08, max(yAll) + range(yAll) * 0.10];
    for t = 1:3
        subplot(3, 3, (m - 1) * 3 + t);
        mask = mMask & strcmp(T.Treatment, treatDisp{t});
        train = T.Training(mask); test = T.Test(mask);

        opts = struct('panelLabel', panelLet{m, t}, 'groupLabel', treatLbl{t}, 'yLim', yLim);
        if t == 1
            opts.yLabel = metricLbl{m};
        end
        plot_meanSEM_lines(train, test, opts);
    end
end
sgtitle('Figure 4  --  Spike-LFP gamma phase-locking, Training vs Test', ...
    'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');

outPath = fullfile(outDir, 'Fig4_A-I.png');
saveas(fig, outPath);
close(fig);
fprintf('Saved %s\n', outPath);
