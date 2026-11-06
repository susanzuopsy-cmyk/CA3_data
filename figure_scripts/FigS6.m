%% FigS6.m
% Figure S6, panels A-C: sensitivity of spatial information to speed thresholds and place-cell selection.
%   A  speed threshold applied in each session; lines join one animal's Training and Test sessions
%   B  change in spatial information, Test - Training, left CA1 under left CA3 inhibition, at three speed
%      criteria (mean +/- SEM over the 68 cells); marks from the Statistics sheet (one-tailed mixed-model p)
%   C  place-cell counts under two criteria, the sheet's columns 'Training or Test' and 'Training only':
%      Training or Test for control cells, Training only for drug-condition cells
%
% Input : ../source_data/FigS6_source_data_20261105.xlsx
% Output: ../figures_repro/FigS6_A-C.{png,pdf,fig}

treat     = {'control', 'left CA3 inhibition', 'right CA3 inhibition'};
lineCol   = [0.45 0.47 0.47; 0.19 0.34 0.66; 0.50 0.12 0.09];
barCol    = [0.53 0.66 0.84];
countCol  = {[0.88 0.88 0.88], [0.78 0.84 0.94], [0.97 0.75 0.69]; ...   % Training or Test
             [0.69 0.69 0.69], [0.53 0.66 0.84], [0.91 0.44 0.34]};      % Training only
criteria  = {'25th percentile', '2 cm/s', '3 cm/s'};
critLabel = {'25th pct', '2 cm/s', '3 cm/s'};
colX = [70 400 730]; rowY = 32; axW = 230; axH = 215;

src = fullfile(fileparts(mfilename('fullpath')), '..', 'source_data', 'FigS6_source_data_20261105.xlsx');
Thr = readtable(src, 'Sheet', 'SpeedThresholds', 'VariableNamingRule', 'preserve');
SI  = readtable(src, 'Sheet', 'SpatialInformation', 'VariableNamingRule', 'preserve');
Cnt = readtable(src, 'Sheet', 'PlaceCellCounts', 'VariableNamingRule', 'preserve');
St  = readtable(src, 'Sheet', 'Statistics', 'VariableNamingRule', 'preserve');

[fig, S] = new_figure('Figure S6 A-C', 980, 295);
k = S.k;
tickFS = 14; labFS = 13; titleFS = 16;
sayTitle = @(ax, s) text(ax, 0.5, 1.04, s, 'Units', 'normalized', 'FontName', S.font, 'FontWeight', 'bold', ...
    'FontSize', titleFS * k, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Tag', 'panelTitle');

%% A: applied speed thresholds
ax = panel_axes(fig, [colX(1), rowY, axW, axH], 'A', tickFS, 0.5);
set(ax, 'XLim', [0.8 2.2], 'YLim', [0 4.86], 'YTick', 0:0.5:4.5, 'XTick', [1 2], ...
    'XTickLabel', {'\color{black}Training', '\color{black}Test'});
thr = Thr.("Applied threshold (cm/s)");
for t = 1:3
    inT = strcmp(Thr.Treatment, treat{t});
    mice = unique(Thr.Mouse(inT), 'stable');
    for m = 1:numel(mice)
        rows = inT & strcmp(Thr.Mouse, mice{m});
        y = [thr(rows & strcmp(Thr.Session, 'Training')), thr(rows & strcmp(Thr.Session, 'Test'))];
        plot(ax, [1 2], y, '-o', 'Color', lineCol(t, :), 'LineWidth', 1.1 * k, 'MarkerSize', 3.5 * k, ...
            'MarkerFaceColor', lineCol(t, :), 'MarkerEdgeColor', 'none', 'Tag', ['session' num2str(t)]);
    end
end
plot(ax, [0.8 2.2], [2 2], '--', 'Color', 'k', 'LineWidth', k, 'Tag', 'fixedThreshold');
text(ax, 2.22, 2, '2 cm/s', 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 10 * k, 'VerticalAlignment', 'middle', 'Tag', 'fixedLabel');
ylabel(ax, 'applied speed threshold (cm/s)', 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', labFS * k, 'Color', S.axcol);
sayTitle(ax, 'Speed threshold');

%% B: change in spatial information at three speed criteria
ax = panel_axes(fig, [colX(2), rowY, axW, axH], 'B', tickFS, 0.5);
set(ax, 'XLim', [0.4 3.6], 'YLim', [-0.60806538798 0.06], 'YTick', -0.6:0.1:0, 'XTick', 1:3, ...
    'XTickLabel', strcat('\color{black}', critLabel));
rowsB = St(strcmp(St.panel, 'B'), :);
for c = 1:3
    d = SI.(['Test, ' criteria{c}]) - SI.(['Training, ' criteria{c}]);
    m = mean(d); e = std(d) / sqrt(numel(d));
    bar(ax, c, m, 0.62, 'FaceColor', barCol, 'EdgeColor', 'none', 'ShowBaseLine', 'off', 'Tag', 'meanBar');
    errorbar(ax, c, m, e, 'LineStyle', 'none', 'Color', [0.12 0.12 0.12], 'LineWidth', 0.8 * k, 'CapSize', 5 * k, 'Tag', 'sem');
    p = rowsB.("p (as in the figure)")(contains(rowsB.measure, criteria{c}));
    text(ax, c, m - e - 0.025, significance_mark(p), 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 12 * k, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'Tag', 'sigText');
end
plot(ax, [0.4 3.6], [0 0], 'k-', 'LineWidth', 0.6 * k, 'Tag', 'zeroLine');
plot(ax, [0.6 3.4], [-0.531 -0.531], 'k-', 'LineWidth', 1.2 * k, 'Tag', 'selectionLine');
text(ax, 2, -0.565, 'Training-only selection', 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 10 * k, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Tag', 'selectionLabel');
ylabel(ax, [char(916) ' spatial information (bits/spike)'], 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', labFS * k, 'Color', S.axcol);
sayTitle(ax, 'Left CA1, left CA3 inhibition');

%% C: place-cell counts
ax = panel_axes(fig, [colX(3), rowY, axW, axH], 'C', tickFS, 0.5);
set(ax, 'XLim', [0.5 3.5], 'YLim', [0 220], 'YTick', 0:20:200, 'XTick', 1:3, ...
    'XTickLabel', {'\color{black}CTRL', '\color{black}Left CA3', '\color{black}Right CA3'});
for t = 1:3
    n = [Cnt.("Training or Test")(strcmp(Cnt.Treatment, treat{t})), Cnt.("Training only")(strcmp(Cnt.Treatment, treat{t}))];
    for j = 1:2
        x = t + (j - 1.5) * 0.38;
        bar(ax, x, n(j), 0.34, 'FaceColor', countCol{j, t}, 'EdgeColor', 'none', 'ShowBaseLine', 'off', 'Tag', 'countBar');
        text(ax, x, n(j) + 3, num2str(n(j)), 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 10 * k, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Tag', 'countLabel');
    end
end
keyName = {'Training or Test', 'Training only'}; keyCol = {[0.84 0.84 0.84], [0.60 0.60 0.60]};
for j = 1:2
    y = 205 - 13 * (j - 1);
    patch(ax, 1.3 + [0 0.35 0.35 0], y + [-5 -5 5 5], keyCol{j}, 'EdgeColor', 'none', 'Tag', 'keyPatch');
    text(ax, 1.7, y, keyName{j}, 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 10 * k, 'VerticalAlignment', 'middle', 'Tag', 'keyLabel');
end
ylabel(ax, 'place cells', 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', labFS * k, 'Color', S.axcol);
sayTitle(ax, 'Place-cell counts');

save_figure(fig, 'FigS6_A-C');
