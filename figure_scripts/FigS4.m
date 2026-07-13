%% FigS4.m
% Reproduces published Figure S4 panels A-F (CA1 place-cell sparsity and
% field coherence, Training vs Test, all-cells only) from the curated
% source-data workbook only.
%   A-C : sparsity     (CTRL / LCA3 / RCA3)
%   D-F : field coherence (CTRL / LCA3 / RCA3)
%
% Input : manuscript/source_data/FigS4_source_data.xlsx
% Output: manuscript/figures_repro/FigS4_A-F.png
%%

set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultUicontrolFontName', 'Arial');

scriptDir = fileparts(mfilename('fullpath'));
srcPath   = fullfile(scriptDir, '..', 'source_data', 'FigS4_source_data.xlsx');
outDir    = fullfile(scriptDir, '..', 'figures_repro');
if ~exist(outDir, 'dir'), mkdir(outDir); end

treatDisp = {'CTRL', 'LCA3', 'RCA3'};
treatLbl  = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};

rows = {
    'Sparsity',       {'A', 'B', 'C'}, 'Sparsity';
    'FieldCoherence', {'D', 'E', 'F'}, 'Field Coherence (z)';
};

fig = figure('Position', [60 40 1080 900], 'Color', 'w', 'Name', 'Figure S4 A-F');
sgtitle('Figure S4  --  Place-cell sparsity (A-C) and field coherence (D-F), Training vs Test', ...
    'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');

colX = [0.08 0.39 0.70]; wp = 0.27;
rowY = [0.56 0.10]; hp = 0.36;
for r = 1:size(rows, 1)
    T = readtable(srcPath, 'Sheet', rows{r, 1});
    panelLet = rows{r, 2};
    yAll = [T.Training; T.Test];
    yLim = [min(yAll) - range(yAll) * 0.06, max(yAll) + range(yAll) * 0.16];
    for t = 1:3
        axes('Position', [colX(t), rowY(r), wp, hp]); %#ok<LAXES>
        mask = strcmp(T.Treatment, treatDisp{t});
        train = T.Training(mask); test = T.Test(mask);

        opts = struct('panelLabel', panelLet{t}, 'groupLabel', treatLbl{t}, ...
            'yLim', yLim, 'diffInset', false);
        if t == 1
            opts.yLabel = rows{r, 3};
        end
        plot_paired_box(train, test, opts);
    end
end

outPath = fullfile(outDir, 'FigS4_A-F.png');
saveas(fig, outPath);
close(fig);
fprintf('Saved %s\n', outPath);
