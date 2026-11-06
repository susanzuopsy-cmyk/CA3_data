%% Fig4.m
% Figure 4, panels A-I: spike-LFP gamma phase locking (modulation index, MI) of CA1 pyramidal cells.
%   A-C  low gamma; D-F  high gamma; G-I  ratio of low- to high-gamma phase locking.
% Thin lines: individual cells. Thick line: group mean. Marks from the Statistics sheet
% (two-tailed paired t-test in A-F, two-tailed Wilcoxon signed-rank test in G-I).
%
% Input : ../source_data/Fig4_source_data_20261105.xlsx
% Output: ../figures_repro/Fig4_A-I.{png,pdf,fig}

metrics = {'logMIlow', 'logMIhigh', 'r'};
ylabs   = {'log(MI) - low gamma', 'log(MI) - high gamma', 'log(MI_{low}/MI_{high})'};
treat   = {'CTRL', 'LCA3', 'RCA3'};
cond    = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};
ylims   = {[-4.5 -0.4], [-3.5 -0.5], [-2.5 1.0]};
yticks  = {-4.5:0.5:-0.5, -3.5:0.5:-0.5, -2.5:0.5:1};
barDown = [14.3 20.4 28.4];     % bars of a row: this far below the axes top (pt), as printed
colX = [75 355 635]; rowY = [570 300 35]; axW = 193.5; axH = 204.13;

% each row's colours, as in the figure
cellCol  = [0 0 0 0.251; 0 0 0 0.251; 0.451 0.451 0.451 0.302];
meanCol  = [0 0 0; 0 0 0; 0.102 0.102 0.102];
markerTr = [0 0.073 0.865; 0 0 1; 0 0 1];

src = fullfile(fileparts(mfilename('fullpath')), '..', 'source_data', 'Fig4_source_data_20261105.xlsx');
T  = readtable(src, 'Sheet', 'GammaMI');
St = readtable(src, 'Sheet', 'Statistics', 'VariableNamingRule', 'preserve');

[fig, S] = new_figure('Figure 4 A-I', 860, 815);
k = S.k;
st = struct('sigX', [1 2], 'sigLW', 2, 'sigCol', S.axcol, 'sigFS', 18, 'nsFS', 14, 'sigDY', -2.4, 'nsDY', 5.9);
for row = 1:3
    for t = 1:3
        letter = char('A' + 3 * (row - 1) + t - 1);
        sel = strcmp(T.Metric, metrics{row}) & strcmp(T.Treatment, treat{t});
        tr = T.Training(sel); te = T.Test(sel);
        ax = panel_axes(fig, [colX(t), rowY(row), axW, axH], letter, 12, 0.5);
        set(ax, 'Box', 'on', 'Color', 'w', 'XLim', [0.6 2.4], 'YLim', ylims{row}, 'YTick', yticks{row}, 'XTick', [1 2], ...
            'XTickLabel', {'\color{black}Training', '\color{black}Test'});
        ax.XAxis.FontSize = 14 * k;
        if row == 3
            plot(ax, [0.6 2.4], [0 0], ':', 'Color', 'k', 'LineWidth', 0.7 * k, 'Tag', 'zeroLine');
        end
        for i = 1:numel(tr)
            plot(ax, [1 2], [tr(i) te(i)], '-', 'Color', cellCol(row, :), 'LineWidth', 0.5 * k, 'Tag', 'cell');
        end
        plot(ax, [1 2], [mean(tr) mean(te)], '-', 'Color', meanCol(row, :), 'LineWidth', 2.4 * k, 'Tag', 'meanLine');
        scatter(ax, 1, mean(tr), (9.6 * k)^2, markerTr(row, :), 'filled', 'MarkerFaceAlpha', 0.3, 'MarkerEdgeColor', 'none', 'Tag', 'meanTrain');
        scatter(ax, 2, mean(te), (9.6 * k)^2, [1 0 0], 'filled', 'MarkerFaceAlpha', 0.3, 'MarkerEdgeColor', 'none', 'Tag', 'meanTest');
        add_significance(ax, ylims{row}(2) - barDown(row) / points_per_unit(ax), ...
            significance_mark(St.("p (as in the figure)")(strcmp(St.panel, letter))), st);
        ylabel(ax, ylabs{row}, 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 14 * k, 'Color', 'k');
        if row == 1
            text(ax, 0.5, 1.08, cond{t}, 'Units', 'normalized', 'FontName', S.font, 'FontWeight', 'bold', ...
                'FontSize', 16 * k, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Tag', 'panelTitle');
        end
    end
end
save_figure(fig, 'Fig4_A-I');
