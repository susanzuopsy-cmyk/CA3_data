function plot_paired_box(ax, tr, te, P)
%PLOT_PAIRED_BOX  One panel: Training and Test box plots with every value as a point (Fig 1, 2, 6, S7).
% tr, te  paired values, one per unit (equal length)
% P       a box style of repro_style, plus
%         ylim, ytick, ylabel, title, sig (the mark), seed and jitSD (horizontal jitter of the points)
%         lineCol, lineLW         lines joining each unit's two points, when P.pairLines is true
%         barY                    height of the significance bar; when absent, P.barDown points below the axes top
%                                 or 3 pt above the highest point drawn, whichever is higher
%         omit                    logical, units not drawn: they stay in the box and the mean of the inset
%         inset                   struct with ylim, ytick, label: adds the Test - Training inset
S = repro_style(); k = S.k;
tr = tr(:); te = te(:); n = numel(tr); d = te - tr;
if ~isfield(P, 'omit'), P.omit = false(n, 1); end
drawn = ~P.omit(:);

set(ax, 'Box', P.box, 'XLim', P.xlim, 'YLim', P.ylim, 'YTick', P.ytick, 'XTick', [1 2], ...
    'XTickLabel', {'\color{black}Training', '\color{black}Test'});

% the same generator and order as the printed panels: Training, Test, inset
rng(P.seed, 'twister');
xTr = 1 + P.jitSD * randn(n, 1);
xTe = 2 + P.jitSD * randn(n, 1);

if P.pairLines
    for i = find(drawn)'
        plot(ax, [xTr(i) xTe(i)], [tr(i) te(i)], '-', 'Color', P.lineCol, 'LineWidth', P.lineLW * k, 'Tag', 'pair');
    end
end
draw_box(ax, 1, tr, P);
draw_box(ax, 2, te, P);
scatter(ax, xTr(drawn), tr(drawn), (P.ptD * k)^2, S.cTrain, 'filled', 'MarkerFaceAlpha', P.ptAlpha, ...
    'MarkerEdgeColor', 'none', 'Tag', 'ptsTrain');
scatter(ax, xTe(drawn), te(drawn), (P.ptD * k)^2, S.cTest, 'filled', 'MarkerFaceAlpha', P.ptAlpha, ...
    'MarkerEdgeColor', 'none', 'Tag', 'ptsTest');

if ~isfield(P, 'barY')
    ppu = points_per_unit(ax);
    P.barY = max(P.ylim(2) - P.barDown / ppu, max([tr(drawn); te(drawn)]) + 3 / ppu);
end
add_significance(ax, P.barY, P.sig, P);

ylabel(ax, P.ylabel, 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', P.ylabFS * k, 'Color', S.axcol);
if isfield(P, 'inset')
    xTitle = P.titleDX / P.axW;
else
    xTitle = 0.5;
end
text(ax, xTitle, 1.03, P.title, 'Units', 'normalized', 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', P.titleFS * k, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'k', 'Interpreter', 'none', 'Tag', 'panelTitle');

if isfield(P, 'inset')
    jIn = P.inJit * (2 * rand(n, 1) - 1);
    fig = ancestor(ax, 'figure');
    pos = ax.Position .* [fig.UserData.page fig.UserData.page];
    ai = panel_axes(fig, [pos(1:2) + [P.inDX P.inDY], P.inW, P.inH], '', P.inTickFS, P.inLW);
    ai.Tag = ['inset' ax.Tag(end)];
    set(ai, 'Color', 'w', 'XLim', P.inXLim, 'YLim', P.inset.ylim, 'YTick', P.inset.ytick, 'XTick', 1, ...
        'XTickLabel', {['\color{black}' P.inset.label]});
    plot(ai, P.inXLim, [0 0], '--', 'Color', P.inZeroCol, 'LineWidth', P.inZeroLW * k, 'Tag', 'inZero');
    scatter(ai, 1 + jIn(drawn), d(drawn), (P.inPtD * k)^2, [0 0 0], 'filled', 'MarkerFaceAlpha', P.inPtAlpha, ...
        'MarkerEdgeColor', 'none', 'Tag', 'inPts');
    plot(ai, [1 - P.inMeanHalf 1 + P.inMeanHalf], [mean(d) mean(d)], '-', 'Color', S.cTest, 'LineWidth', P.inMeanLW * k, ...
        'Tag', 'inMean');
end
end
