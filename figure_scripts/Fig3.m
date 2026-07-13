%% Fig3.m
% Reproduces published Figure 3 panels A-I (Z-scored CA1 LFP band power,
% Training vs Test) from the curated source-data workbook only. Mean+/-SEM
% + thin individual-mouse-line style, matching the published panel style.
%
% Input : manuscript/source_data/Fig3_source_data.xlsx
% Output: manuscript/figures_repro/Fig3_A-I.png
%%

set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
set(0, 'DefaultUicontrolFontName', 'Arial');

scriptDir = fileparts(mfilename('fullpath'));
srcPath   = fullfile(scriptDir, '..', 'source_data', 'Fig3_source_data.xlsx');
outDir    = fullfile(scriptDir, '..', 'figures_repro');
if ~exist(outDir, 'dir'), mkdir(outDir); end

T = readtable(srcPath, 'Sheet', 'BandPower');

bands     = {'theta', 'low_gamma', 'high_gamma'};
bandLbl   = {'Theta', 'Low-gamma', 'High-gamma'};
treatDisp = {'CTRL', 'LCA3', 'RCA3'};
treatLbl  = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};
panelLet  = {'A', 'B', 'C'; 'D', 'E', 'F'; 'G', 'H', 'I'};

yAll = [T.Training_z; T.Test_z];
yLim = [min(yAll) - range(yAll) * 0.08, max(yAll) + range(yAll) * 0.10];

fig = figure('Position', [60 40 1080 1000], 'Color', 'w', 'Name', 'Figure 3 A-I');
for b = 1:3
    for t = 1:3
        subplot(3, 3, (b - 1) * 3 + t);
        mask = strcmp(T.Band, bands{b}) & strcmp(T.Treatment, treatDisp{t});
        train = T.Training_z(mask); test = T.Test_z(mask);

        opts = struct('panelLabel', panelLet{b, t}, 'groupLabel', treatLbl{t}, 'yLim', yLim);
        if t == 1
            opts.yLabel = {bandLbl{b}, 'Z-score'};
        end
        plot_meanSEM_lines(train, test, opts);
    end
end
sgtitle('Figure 3  --  Z-scored CA1 LFP band power, Training vs Test', ...
    'FontName', 'Arial', 'FontSize', 12, 'FontWeight', 'bold');

outPath = fullfile(outDir, 'Fig3_A-I.png');
saveas(fig, outPath);
close(fig);
fprintf('Saved %s\n', outPath);
