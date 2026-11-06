%% FigS8.m
% Figure S8, panels A-B: Training-to-Test change in low- and high-gamma power under two normalizations.
%   A  cross-band z-score; B  log-transformed absolute power.
% Bars: mean +/- SEM over the seven animals; points: individual animals. Marks from the Statistics sheet
% (two-tailed paired t-test); as in the figure, only significant bars carry a mark.
%
% Input : ../source_data/FigS8_source_data_20261105.xlsx
% Output: ../figures_repro/FigS8_A-B.{png,pdf,fig}

sheets = {'CrossBandZ', 'LogAbsolutePower'};
titles = {'Cross-band z-score', 'Log absolute power'};
ylabs  = {[char(916) ' cross-band z-score'], [char(916) ' log absolute power']};
ylims  = {[-0.42 0.384], [-1.12 1.024]};
yticks = {-0.4:0.1:0.3, -1:0.2:1};
bands  = {'low gamma', 'high gamma'};
treat  = {'control', 'left CA3 inhibition', 'right CA3 inhibition'};
xlabs  = {'CTRL', 'Left CA3', 'Right CA3', 'CTRL', 'Left CA3', 'Right CA3'};
barCol = [0.69 0.69 0.69; 0.53 0.66 0.84; 0.91 0.44 0.34];
seed0  = 20261334;                                % jitter of panel i uses seed0 + i, as printed
colX = [75 505]; rowY = 75; axW = 320; axH = 230;

src = fullfile(fileparts(mfilename('fullpath')), '..', 'source_data', 'FigS8_source_data_20261105.xlsx');
St = readtable(src, 'Sheet', 'Statistics', 'VariableNamingRule', 'preserve');

[fig, S] = new_figure('Figure S8 A-B', 860, 345);
k = S.k;
for i = 1:2
    T = readtable(src, 'Sheet', sheets{i}, 'VariableNamingRule', 'preserve');
    letter = char('A' + i - 1);
    rowsP = St(strcmp(St.panel, letter), :);
    ax = panel_axes(fig, [colX(i), rowY, axW, axH], letter, 14, 0.5);
    set(ax, 'XLim', [0.4 6.6], 'YLim', ylims{i}, 'YTick', yticks{i}, 'XTick', 1:6, ...
        'XTickLabel', strcat('\color{black}', xlabs), 'XTickLabelRotation', 30);
    rng(seed0 + i, 'twister');
    x = 0;
    for b = 1:2
        for t = 1:3
            x = x + 1;
            v = T.Change(strcmp(T.Band, bands{b}) & strcmp(T.Treatment, treat{t}));
            m = mean(v); e = std(v) / sqrt(numel(v));
            bar(ax, x, m, 0.62, 'FaceColor', barCol(t, :), 'EdgeColor', 'none', 'ShowBaseLine', 'off', 'Tag', 'meanBar');
            errorbar(ax, x, m, e, 'LineStyle', 'none', 'Color', [0.12 0.12 0.12], 'LineWidth', 0.8 * k, 'CapSize', 4 * k, 'Tag', 'sem');
            scatter(ax, x + 0.22 * (rand(numel(v), 1) - 0.5), v, (3.5 * k)^2, [0.4 0.4 0.4], 'filled', 'MarkerFaceAlpha', 0.8, ...
                'MarkerEdgeColor', 'none', 'Tag', 'pts');
            p = rowsP.("p (as in the figure)")(contains(rowsP.measure, bands{b}) & strcmp(rowsP.treatment, treat{t}));
            mark = significance_mark(p);
            if ~strcmp(mark, 'n.s.')
                gap = 0.05 * diff(ylims{i});
                if m > 0, y = max(v) + gap; else, y = min(v) - gap; end
                text(ax, x, y, mark, 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 14 * k, ...
                    'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Tag', 'sigText');
            end
        end
    end
    plot(ax, [0.4 6.6], [0 0], 'k-', 'LineWidth', 0.6 * k, 'Tag', 'zeroLine');
    yText = ylims{i}(1) + 0.09 * diff(ylims{i});
    text(ax, 2, yText, ['low ' char(947)], 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 10 * k, 'HorizontalAlignment', 'center', 'Tag', 'bandLabel');
    text(ax, 5, yText, ['high ' char(947)], 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 10 * k, 'HorizontalAlignment', 'center', 'Tag', 'bandLabel');
    ylabel(ax, ylabs{i}, 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 14 * k, 'Color', S.axcol);
    text(ax, 0.5, 1.04, titles{i}, 'Units', 'normalized', 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 16 * k, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Tag', 'panelTitle');
end
save_figure(fig, 'FigS8_A-B');
