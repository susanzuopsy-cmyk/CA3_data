%% Fig3.m
% Figure 3, panels A-I: z-scored CA1 LFP band power in the Training and Test sessions (N = 7 mice per group).
% Thin grey lines: individual mice. Thick black line: mean +/- SEM. Marks from the Statistics sheet
% (two-tailed paired t-test); as in the figure, only significant panels carry a mark.
%
% Input : ../source_data/Fig3_source_data_20261105.xlsx
% Output: ../figures_repro/Fig3_A-I.{png,pdf,fig}

bands  = {'theta', 'low_gamma', 'high_gamma'};
ylabs  = {'Theta Z-Score', 'Low Gamma Z-Score', 'High Gamma Z-Score'};
treat  = {'CTRL', 'LCA3', 'RCA3'};
cond   = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};
ylims  = {[0 1.4], [0 1.4], [0 1.4]; [-1.2 0], [-1.2 0], [-1.2 0]; [-1 0], [-1.2 0], [-1.2 0]};   % as printed
barY   = [NaN NaN NaN; -0.214 NaN -0.203; -0.211 NaN -0.200];                                     % as printed
colX = [80 420 760]; rowY = [505 275 40]; axW = 251.25; axH = 189.75;

src = fullfile(fileparts(mfilename('fullpath')), '..', 'source_data', 'Fig3_source_data_20261105.xlsx');
T  = readtable(src, 'Sheet', 'BandPower');
St = readtable(src, 'Sheet', 'Statistics', 'VariableNamingRule', 'preserve');

[fig, S] = new_figure('Figure 3 A-I', 1040, 745);
st = struct('sigX', [1 2], 'sigLW', 2, 'sigCol', S.axcol, 'sigFS', 18, 'nsFS', 14, 'sigDY', -1.5, 'nsDY', 4.4);
for b = 1:3
    for t = 1:3
        letter = char('A' + 3 * (b - 1) + t - 1);
        sel = strcmp(T.Band, bands{b}) & strcmp(T.Treatment, treat{t});
        ax = panel_axes(fig, [colX(t), rowY(b), axW, axH], letter, 14, 0.5);
        set(ax, 'XLim', [0.5 2.5], 'YLim', ylims{b, t}, 'YTick', ylims{b, t}(1):0.2:ylims{b, t}(2), 'XTick', [1 2], ...
            'XTickLabel', {'\color{black}Training', '\color{black}Test'}, 'XGrid', 'on', 'YGrid', 'on', 'GridAlpha', 0.15);
        plot_mouse_lines(ax, T.Training_z(sel), T.Test_z(sel), S);
        mark = significance_mark(St.("p (as in the figure)")(strcmp(St.panel, letter)));
        if ~strcmp(mark, 'n.s.'), add_significance(ax, barY(b, t), mark, st); end
        ylabel(ax, ylabs{b}, 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 14 * S.k, 'Color', S.axcol);
        if b == 1
            text(ax, 0.5, 1.05, cond{t}, 'Units', 'normalized', 'FontName', S.font, 'FontWeight', 'bold', ...
                'FontSize', 16 * S.k, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Tag', 'panelTitle');
        end
    end
end
save_figure(fig, 'Fig3_A-I');

function plot_mouse_lines(ax, tr, te, S)
k = S.k; n = numel(tr);
for i = 1:n
    plot(ax, [1 2], [tr(i) te(i)], '-', 'Color', [0.702 0.702 0.702], 'LineWidth', k, 'Tag', 'mouse');
end
scatter(ax, ones(n, 1), tr, (3.54 * k)^2, [0.219 0.258 1], 'filled', 'MarkerFaceAlpha', 0.3, 'MarkerEdgeColor', 'none', 'Tag', 'ptsTrain');
scatter(ax, 2 * ones(n, 1), te, (3.54 * k)^2, [1 0 0], 'filled', 'MarkerFaceAlpha', 0.3, 'MarkerEdgeColor', 'none', 'Tag', 'ptsTest');
errorbar(ax, [1 2], [mean(tr) mean(te)], [std(tr) std(te)] / sqrt(n), 'k', 'LineWidth', 2 * k, 'CapSize', 6 * k, ...
    'Marker', 'o', 'MarkerSize', 4 * k, 'MarkerFaceColor', 'k', 'Tag', 'meanSEM');
end
