%% FigS5.m
% Reproduces published Figure S5 panels A-C (CA1 cell-assembly reactivation
% strength, Training vs Test) from the curated source-data workbook only.
%
% Input : manuscript/source_data/FigS5_source_data.xlsx
% Output: manuscript/figures_repro/FigS5_A-C.png
%%

set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultUicontrolFontName', 'Arial');

scriptDir = fileparts(mfilename('fullpath'));
srcPath   = fullfile(scriptDir, '..', 'source_data', 'FigS5_source_data.xlsx');
outDir    = fullfile(scriptDir, '..', 'figures_repro');
if ~exist(outDir, 'dir'), mkdir(outDir); end

T = readtable(srcPath, 'Sheet', 'AssemblyStrength');

treatDisp = unique(T.Treatment, 'stable');
treatLbl  = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};
panelLet  = {'A', 'B', 'C'};

yAll = [T.Training; T.Test];
yLim = [min(yAll) - range(yAll) * 0.06, max(yAll) + range(yAll) * 0.16];

fig = figure('Position', [80 80 1200 460], 'Color', 'w', 'Name', 'Figure S5 A-C');
for t = 1:numel(treatDisp)
    subplot(1, numel(treatDisp), t);
    mask = strcmp(T.Treatment, treatDisp{t});
    train = T.Training(mask); test = T.Test(mask);

    opts = struct('panelLabel', panelLet{t}, 'groupLabel', treatLbl{t}, 'yLim', yLim);
    if t == 1
        opts.yLabel = 'Cell Assembly Strength';
    end
    plot_paired_box(train, test, opts);
end
sgtitle('Figure S5  --  CA1 cell-assembly reactivation strength, Training vs Test', ...
    'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');

outPath = fullfile(outDir, 'FigS5_A-C.png');
saveas(fig, outPath);
close(fig);
fprintf('Saved %s\n', outPath);
