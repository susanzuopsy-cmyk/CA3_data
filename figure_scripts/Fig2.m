%% Fig2.m
% Figure 2: CA1 place-cell spatial information.
%   A-I  Training and Test, with the per-cell Test - Training difference in the inset
%        (rows: all cells, left CA1, right CA1; columns: control, left CA3, right CA3 inhibition)
%   J-K  proportion of cells with higher spatial information at Test, left CA1 (J) and right CA1 (K)
% Marks from the Statistics sheet (one-tailed Wilcoxon signed-rank test).
%
% Input : ../source_data/Fig2_source_data_20261105.xlsx
% Output: ../figures_repro/Fig2_A-K.{png,pdf,fig}

treat  = {'CTRL', 'LCA3', 'RCA3'};
cond   = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};
hemi   = {'', 'LCA1', 'RCA1'};
group  = {'All', 'LCA1', 'RCA1'};
seed0  = 20261109;                 % jitter of panel k uses seed0 + k
colX = [60 440 820]; rowY = [775 503 231];

src = fullfile(fileparts(mfilename('fullpath')), '..', 'source_data', 'Fig2_source_data_20261105.xlsx');
T  = readtable(src, 'Sheet', 'SpatialInformation');
Tp = readtable(src, 'Sheet', 'SIProportion');
St = readtable(src, 'Sheet', 'Statistics', 'VariableNamingRule', 'preserve');

[fig, S] = new_figure('Figure 2 A-K', 1170, 1030);
for k = 1:9
    row = ceil(k / 3); t = k - 3 * (row - 1); letter = char('A' + k - 1);
    sel = strcmp(T.Treatment, treat{t});
    if row > 1, sel = sel & strcmp(T.Hemisphere, hemi{row}); end
    P = S.boxInset;
    P.seed = seed0 + k;
    P.ylim = [0 6.612]; P.ytick = 1:6; P.ylabel = 'Spatial Information (bits/spike)';
    P.inset = struct('ylim', [-4.7 4.7], 'ytick', -4:4, 'label', 'Test-Training');
    P.title = sprintf('%s - %s cells (n = %d)', cond{t}, group{row}, nnz(sel));
    P.sig = significance_mark(St.("p (as in the figure)")(strcmp(St.panel, letter)));
    ax = panel_axes(fig, [colX(t), rowY(row), P.axW, P.axH], letter, P.tickFS, P.axLW);
    plot_paired_box(ax, T.Training(sel), T.Test(sel), P);
end

% J-K: one block of three pies per hemisphere, then the shared key
for h = 1:2
    pUp = zeros(1, 3);
    for t = 1:3
        pUp(t) = Tp.Proportion(strcmp(Tp.Hemisphere, hemi{h + 1}) & strcmp(Tp.Treatment, treat{t}));
    end
    draw_pies(fig, S, 40 + 560 * (h - 1), pUp, cond, {'Left CA1', 'Right CA1'}, h);
end
draw_key(fig, S);
save_figure(fig, 'Fig2_A-K');

function draw_pies(fig, S, x0, pUp, cond, heads, h)
Q = S.pie; k = S.k; page = fig.UserData.page; y0 = 34;
for t = 1:3
    cx = x0 + Q.pitch * (t - 0.5);
    ax = axes(fig, 'Units', 'normalized', 'Position', [cx - Q.d / 2, y0, Q.d, Q.d] ./ [page page], 'Visible', 'off', ...
        'Tag', sprintf('pie%s%d', char('I' + h), t));
    hold(ax, 'on'); axis(ax, 'equal'); set(ax, 'XLim', [-1 1], 'YLim', [-1 1]);
    up = round(100 * pUp(t)); down = 100 - up;
    a1 = linspace(pi / 2, pi / 2 + 2 * pi * pUp(t), 200);      % counter-clockwise from 12 o'clock
    a2 = linspace(pi / 2 + 2 * pi * pUp(t), pi / 2 + 2 * pi, 200);
    patch(ax, [0 cos(a1) 0], [0 sin(a1) 0], Q.cUp, 'EdgeColor', 'w', 'LineWidth', k, 'Tag', 'sliceUp');
    patch(ax, [0 cos(a2) 0], [0 sin(a2) 0], Q.cDown, 'EdgeColor', 'w', 'LineWidth', k, 'Tag', 'sliceDown');
    pct = {sprintf('%d%%', up), sprintf('%d%%', down)}; mid = [mean(a1([1 end])), mean(a2([1 end]))];
    for j = 1:2
        text(ax, 0.52 * cos(mid(j)), 0.52 * sin(mid(j)), pct{j}, 'Color', 'w', 'FontName', S.font, 'FontWeight', 'bold', ...
            'FontSize', Q.pctFS * k, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Tag', 'pct');
    end
    text(ax, 0, 1.24, cond{t}, 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', Q.titleFS * k, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'baseline', 'Interpreter', 'none', 'Tag', 'pieTitle');
    if t == 2
        text(ax, 0, 1.58, heads{h}, 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', Q.headFS * k, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'baseline', 'Interpreter', 'none', 'Tag', 'pieHead');
    end
end
annotation(fig, 'textbox', [(x0 - 26) / page(1), 186 / page(2), 30 / page(1), 24 / page(2)], 'String', char('I' + h), ...
    'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 18 * k, 'EdgeColor', 'none', 'Margin', 0, 'Tag', 'panelLetter');
end

function draw_key(fig, S)
Q = S.pie; page = fig.UserData.page;
ax = axes(fig, 'Units', 'normalized', 'Position', [0 0 1 1], 'Visible', 'off', 'XLim', [0 page(1)], 'YLim', [0 page(2)], 'Tag', 'key');
hold(ax, 'on');
x = [415 610]; y = 8; label = {'Higher SI at Test', 'Lower SI at Test'}; col = {Q.cUp, Q.cDown};
for j = 1:2
    patch(ax, x(j) + [0 Q.legPatch(1) Q.legPatch(1) 0], y + [0 0 Q.legPatch(2) Q.legPatch(2)], col{j}, 'EdgeColor', 'none');
    text(ax, x(j) + Q.legPatch(1) + 4, y + Q.legPatch(2) / 2, label{j}, 'FontName', S.font, 'FontWeight', 'bold', ...
        'FontSize', Q.legFS * S.k, 'VerticalAlignment', 'middle');
end
end
