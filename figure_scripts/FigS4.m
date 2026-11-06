%% FigS4.m
% Figure S4, panels A-D: normalized session change in locomotion, (Test - Training)/(Test + Training).
%   A-B  behavioral cohort; C-D  electrophysiology cohort.
% Each dot is one mouse; squares and error bars are mean +/- SEM. No panel carries a significance mark: the
% repeated-measures ANOVA across conditions (Statistics sheet) is not significant in any panel.
%
% Input : ../source_data/FigS4_source_data_20261105.xlsx
% Output: ../figures_repro/FigS4_A-D.{png,pdf,fig}

sheets = {'TravelDistance_behavioral', 'MeanSpeed_behavioral', 'TotalDistance_ephys', 'MeanSpeed_ephys'};
titles = {'Total Travel Distance', 'Moving Speed', 'Total Travel Distance', 'Moving Speed'};
dash   = char(8212);
ylabs  = {['Total Distance (m) ' dash ' Normalized'], ['Mean Speed (cm/s) ' dash ' Normalized']};
yticks = {-0.4:0.2:0.8, -0.4:0.2:0.8, -0.4:0.1:0.4, -0.4:0.1:0.3};
treat  = {'CTRL', 'LCA3', 'RCA3'};
xlabs  = {'Control', 'LCA3 inhibition', 'RCA3 inhibition'};
colX = [80 440]; rowY = [490 110]; axW = 225.75; axH = 269.25;

src = fullfile(fileparts(mfilename('fullpath')), '..', 'source_data', 'FigS4_source_data_20261105.xlsx');

[fig, S] = new_figure('Figure S4 A-D', 750, 800);
k = S.k;
for i = 1:4
    T = readtable(src, 'Sheet', sheets{i});
    ax = panel_axes(fig, [colX(mod(i - 1, 2) + 1), rowY(ceil(i / 2)), axW, axH], char('A' + i - 1), 14, 0.5);
    span = max(T.NormalizedDelta) - min(T.NormalizedDelta);
    set(ax, 'XLim', [0.4 3.6], 'YLim', [min(T.NormalizedDelta) - 0.08 * span, max(T.NormalizedDelta) + 0.66 * span], ...
        'YTick', yticks{i}, 'XTick', 1:3, 'XTickLabel', strcat('\color{black}', xlabs), 'XTickLabelRotation', -30);
    for g = 1:3
        d = T.NormalizedDelta(strcmp(T.Treatment, treat{g}));
        rng(g * 7, 'twister');                         % jitter as printed: 0.09 SD
        x = g + 0.09 * randn(numel(d), 1);
        errorbar(ax, g, mean(d), std(d) / sqrt(numel(d)), 'k', 'LineWidth', 1.8 * k, 'CapSize', 10 * k, 'Tag', 'sem');
        plot(ax, g, mean(d), 's', 'MarkerSize', 9 * k, 'MarkerFaceColor', S.cTreatDark(g, :), 'MarkerEdgeColor', 'none', 'Tag', 'mean');
        scatter(ax, x, d, (7.21 * k)^2, S.cTreat(g, :), 'filled', 'MarkerFaceAlpha', 0.75, 'MarkerEdgeColor', 'none', ...
            'Tag', sprintf('pts%d', g));
    end
    plot(ax, [0.4 3.6], [0 0], '--', 'Color', [0.4 0.4 0.4], 'LineWidth', 0.9 * k, 'Tag', 'zeroLine');
    ylabel(ax, {ylabs{mod(i - 1, 2) + 1}, '(Test-Training)/(Test+Training)'}, 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 14 * k, 'Color', S.axcol);
    text(ax, 0.5, 1.03, titles{i}, 'Units', 'normalized', 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 16 * k, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Tag', 'panelTitle');
end
save_figure(fig, 'FigS4_A-D');
