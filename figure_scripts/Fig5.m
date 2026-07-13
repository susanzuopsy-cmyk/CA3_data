%% Fig5.m
% Reproduces published Figure 5 panels C-H (approach-axis theta-gamma
% coupling preference delta, Training vs Test, trial-level unpaired) from
% the curated source-data workbook only. Box+jittered-scatter style
% (unpaired, since Training and Test have different trial counts -- no
% connecting lines).
%
% Input : manuscript/source_data/Fig5_source_data.xlsx
% Output: manuscript/figures_repro/Fig5_C-H.png
%%

set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultUicontrolFontName', 'Arial');

scriptDir = fileparts(mfilename('fullpath'));
srcPath   = fullfile(scriptDir, '..', 'source_data', 'Fig5_source_data.xlsx');
outDir    = fullfile(scriptDir, '..', 'figures_repro');
if ~exist(outDir, 'dir'), mkdir(outDir); end

T = readtable(srcPath, 'Sheet', 'ApproachDelta');

bands     = {'theta_high_gamma', 'theta_low_gamma'};
bandLbl   = {'\theta-high-\gamma \delta', '\theta-low-\gamma \delta'};
treatDisp = {'CTRL', 'LCA3', 'RCA3'};
treatLbl  = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};
panelLet  = {'C', 'D', 'E'; 'F', 'G', 'H'};

fig = figure('Position', [60 60 1080 720], 'Color', 'w', 'Name', 'Figure 5 C-H');
for b = 1:2
    bMask = strcmp(T.Band, bands{b});
    yAll = T.Delta(bMask);
    yLim = [min(yAll) - range(yAll) * 0.08, max(yAll) + range(yAll) * 0.10];
    for t = 1:3
        subplot(2, 3, (b - 1) * 3 + t);
        mask = bMask & strcmp(T.Treatment, treatDisp{t});
        train = T.Delta(mask & strcmp(T.Session, 'Training'));
        test  = T.Delta(mask & strcmp(T.Session, 'Test'));

        opts = struct('panelLabel', panelLet{b, t}, 'groupLabel', treatLbl{t}, 'yLim', yLim);
        if t == 1
            opts.yLabel = bandLbl{b};
        end
        plotUnpairedBox(train, test, opts);
    end
end
sgtitle('Figure 5  --  Approach-axis theta-gamma coupling preference \delta, Training vs Test', ...
    'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');

outPath = fullfile(outDir, 'Fig5_C-H.png');
saveas(fig, outPath);
close(fig);
fprintf('Saved %s\n', outPath);

function plotUnpairedBox(train, test, opts)
% Unpaired box + jittered scatter (Training blue, Test red), no connecting
% lines -- trial-level, unequal Training/Test counts.
    n1 = numel(train); n2 = numel(test);
    grp = [repmat({'Training'}, n1, 1); repmat({'Test'}, n2, 1)];
    boxplot([train; test], grp, 'Labels', {'Training', 'Test'}, 'Symbol', '');
    hold on;
    rng(42);
    xTr = 1 + randn(n1, 1) * 0.08;
    xTe = 2 + randn(n2, 1) * 0.08;
    scatter(xTr, train, 16, 'b', 'filled', 'MarkerFaceAlpha', 0.35, 'MarkerEdgeColor', 'none');
    scatter(xTe, test,  16, 'r', 'filled', 'MarkerFaceAlpha', 0.35, 'MarkerEdgeColor', 'none');
    yline(0, 'k:', 'LineWidth', 0.5);

    if isfield(opts, 'yLabel') && ~isempty(opts.yLabel)
        ylabel(opts.yLabel, 'FontSize', 9, 'FontWeight', 'bold');
    end
    title(sprintf('%s  %s (n=%d/%d)', opts.panelLabel, opts.groupLabel, n1, n2), 'FontSize', 8.5);
    xlim([0.5 2.5]);
    if isfield(opts, 'yLim') && ~isempty(opts.yLim)
        ylim(opts.yLim);
    end
    axis square; box off; hold off;
end
