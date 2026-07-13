%% Fig2.m
% Reproduces published Figure 2 panels A-K from the curated source-data
% workbook only.
%   A-I : spatial information, Training vs Test, 3x3 grid
%         (rows = All cells / Left CA1 / Right CA1; cols = CTRL/LCA3/RCA3)
%   J-K : proportion of cells with higher SI at Test, Left CA1 (J) / Right
%         CA1 (K), each a row of 3 pies (CTRL/LCA3/RCA3)
%
% Input : manuscript/source_data/Fig2_source_data.xlsx
% Output: manuscript/figures_repro/Fig2_A-K.png
%%

set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultUicontrolFontName', 'Arial');

scriptDir = fileparts(mfilename('fullpath'));
srcPath   = fullfile(scriptDir, '..', 'source_data', 'Fig2_source_data.xlsx');
outDir    = fullfile(scriptDir, '..', 'figures_repro');
if ~exist(outDir, 'dir'), mkdir(outDir); end

Tsi   = readtable(srcPath, 'Sheet', 'SpatialInformation');
Tprop = readtable(srcPath, 'Sheet', 'SIProportion');

subsets   = {'all', 'LCA1', 'RCA1'};
subsetLbl = {'All cells', 'Left CA1', 'Right CA1'};
treatDisp = {'CTRL', 'LCA3', 'RCA3'};
treatLbl  = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};
panelLet  = {'A', 'B', 'C'; 'D', 'E', 'F'; 'G', 'H', 'I'};

yAll = [Tsi.Training; Tsi.Test];
yLim = [min(yAll) - range(yAll) * 0.06, max(yAll) + range(yAll) * 0.16];

fig = figure('Position', [40 20 1120 1760], 'Color', 'w', 'Name', 'Figure 2 A-K');
sgtitle('Figure 2  --  Spatial information (A-I) and SI-increase proportion (J-K)', ...
    'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');

%% ----- A-I: spatial information 3x3 grid -----
colX = [0.08 0.39 0.70]; wp = 0.27;
rowY = [0.71 0.49 0.27]; hp = 0.165;
for s = 1:3
    for t = 1:3
        axes('Position', [colX(t), rowY(s), wp, hp]); %#ok<LAXES>
        mask = strcmp(Tsi.Treatment, treatDisp{t});
        if ~strcmp(subsets{s}, 'all')
            mask = mask & strcmp(Tsi.Hemisphere, subsets{s});
        end
        train = Tsi.Training(mask); test = Tsi.Test(mask);

        opts = struct('panelLabel', panelLet{s, t}, 'groupLabel', treatLbl{t}, ...
            'yLim', yLim, 'diffInset', false);
        if t == 1
            opts.yLabel = {subsetLbl{s}, 'Spatial Information (bits/spike)'};
        end
        plot_paired_box(train, test, opts);
    end
end

%% ----- J-K: SI-increase proportion, 2x3 pie grid -----
colUp   = [0.20 0.45 0.80];
colDown = [0.95 0.80 0.25];
colXp = [0.30 0.50 0.70]; wpie = 0.15;
rowYp = [0.155 0.055];    hpie = 0.085;
rowLet = {'J', 'K'};
hUp = gobjects(1); hDown = gobjects(1);
for h = 1:2
    hemi = subsets{h + 1}; % LCA1, RCA1
    for t = 1:3
        ax = axes('Position', [colXp(t), rowYp(h), wpie, hpie]); %#ok<LAXES>
        row = strcmp(Tprop.Hemisphere, hemi) & strcmp(Tprop.Treatment, treatDisp{t});
        pu = Tprop.Proportion(row); nUp = Tprop.N_up(row); nTot = Tprop.N_total(row);
        ph = pie(ax, [pu, 1 - pu]);
        set(ph(1), 'FaceColor', colUp,   'EdgeColor', 'w', 'LineWidth', 1);
        set(ph(3), 'FaceColor', colDown, 'EdgeColor', 'w', 'LineWidth', 1);
        set(ph(2), 'FontSize', 8, 'FontWeight', 'bold');
        set(ph(4), 'FontSize', 8, 'FontWeight', 'bold');
        if h == 1 && t == 1, hUp = ph(1); hDown = ph(3); end
        if h == 1, title(ax, treatLbl{t}, 'FontSize', 9, 'FontWeight', 'bold'); end
        text(ax, 0, -1.32, sprintf('%d/%d cells', nUp, nTot), ...
            'HorizontalAlignment', 'center', 'FontSize', 7, 'Color', [0.3 0.3 0.3]);
    end
    annotation('textbox', [0.005, rowYp(h) + hpie/2 - 0.03, 0.10, 0.06], ...
        'String', sprintf('%s  %s', rowLet{h}, subsetLbl{h + 1}), 'EdgeColor', 'none', ...
        'FontSize', 10, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end
lg = legend([hUp hDown], {'Higher SI at Test', 'Lower SI at Test'}, ...
    'Orientation', 'horizontal', 'FontSize', 9, 'Box', 'off');
lg.Position = [0.5 - 0.16, 0.008, 0.32, 0.02];

outPath = fullfile(outDir, 'Fig2_A-K.png');
saveas(fig, outPath);
close(fig);
fprintf('Saved %s\n', outPath);
