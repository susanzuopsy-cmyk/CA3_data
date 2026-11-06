%% FigS2.m
% Figure S2, panels B-D: z-scored firing of CA3 pyramidal neurons around ligand administration (panel A is histology).
%   B  mean +/- SEM over neurons: DCZ inhibition, SALB inhibition
%   C  heat maps of the neurons in B, one row per neuron, in workbook order; colours saturate at z = +/-3
%   D  mean +/- SEM over neurons: DCZ control, SALB control
% The figure carries no statistical test.
%
% Input : ../source_data/FigS2_source_data_20261106.xlsx
% Output: ../figures_repro/FigS2_B-D.{png,pdf,fig}

sheets  = {'DCZ_inhibition', 'SALB_inhibition', 'DCZ_control', 'SALB_control'};
labels  = {'DCZ inhibition', 'SALB inhibition', 'DCZ control', 'SALB control'};
lineCol = [43 67 155; 77 173 179; 65 65 65; 127 66 153] / 255;
barZ    = -3:3;                                   % printed colour bar
barRGB  = [63 83 165; 91 96 173; 173 170 213; 254 254 254; 238 170 173; 227 86 85; 222 26 29] / 255;
xTicks  = -20:10:50;
xLab    = 'Time align to injection (min)';
yLab    = 'z (each neuron vs its own baseline)';
pageW = 1495; pageH = 325; rowY = 55; axH = 230;
lineX = [75 1165]; lineW = 300;                   % panels B and D
heatX = [470 800]; heatW = 250;                   % the two maps of panel C
keyY  = {[0.82 0.60], [-1.42 -1.64]};             % key rows of B and D

src = fullfile(fileparts(mfilename('fullpath')), '..', 'source_data', 'FigS2_source_data_20261106.xlsx');
Z = cell(1, 4);
for i = 1:4
    T = readtable(src, 'Sheet', sheets{i}, 'VariableNamingRule', 'preserve');
    vars = T.Properties.VariableNames;
    names = vars(startsWith(vars, {'t-', 't+'})); % the bin columns, t-19 to t+59
    Z{i} = T{:, names};
end
t = cellfun(@(s) str2double(s(2:end)), names);    % 't-19' -> -19: bin centres, min

[fig, S] = new_figure('Figure S2 B-D', pageW, pageH);
k = S.k;
text_opts = {'FontName', S.font, 'FontWeight', 'bold', 'Color', S.axcol};

% B and D: mean +/- SEM
letters = 'BD';
for p = 1:2
    ax = panel_axes(fig, [lineX(p), rowY, lineW, axH], letters(p), 14, 0.5);
    set(ax, 'XLim', [-20 60], 'YLim', [-2 1], 'XTick', xTicks, 'YTick', -2:0.5:1, 'YTickLabel', {'-2', '', '-1', '', '0', '', '1'});
    for q = 1:2
        c = 2 * (p - 1) + q;
        n = size(Z{c}, 1);
        m = mean(Z{c}, 1);
        e = std(Z{c}, 0, 1) / sqrt(n);
        patch(ax, [t, fliplr(t)], [m + e, fliplr(m - e)], lineCol(c, :), 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'Tag', 'sem');
        plot(ax, t, m, '-', 'Color', lineCol(c, :), 'LineWidth', 2 * k, 'Tag', 'mean');
        plot(ax, [11 19], keyY{p}([q q]), '-', 'Color', lineCol(c, :), 'LineWidth', 2 * k, 'Tag', 'keyLine');
        text(ax, 21, keyY{p}(q), sprintf('%s (n = %d)', labels{c}, n), text_opts{:}, 'FontSize', 12 * k, 'Tag', 'keyText');
    end
    plot(ax, [-20 60], [0 0], 'k:', 'LineWidth', 0.6 * k, 'Tag', 'zeroLine');
    plot(ax, [0 0], [-2 1], '-', 'Color', S.axcol, 'LineWidth', 1.4 * k, 'Tag', 'injection');
    xlabel(ax, xLab, text_opts{:}, 'FontSize', 14 * k);
    ylabel(ax, yLab, text_opts{:}, 'FontSize', 14 * k);
end

% C: heat maps of the neurons in B
cmap = interp1(barZ, barRGB, linspace(-3, 3, 64));
for p = 1:2
    n = size(Z{p}, 1);
    ax = panel_axes(fig, [heatX(p), rowY, heatW, axH], repmat('C', 1, p == 1), 14, 0.5);
    if p == 2, ax.Tag = 'panelC2'; end
    imagesc(ax, 'XData', t, 'YData', 1:n, 'CData', Z{p}, 'Tag', 'heat');
    colormap(ax, cmap);
    set(ax, 'CLim', [-3 3], 'XLim', [-20 60], 'YLim', [0.5 n + 0.5], 'YDir', 'reverse', 'XTick', xTicks, 'YTick', []);
    plot(ax, [0 0], [0.5 n + 0.5], '-', 'Color', S.axcol, 'LineWidth', 1.4 * k, 'Tag', 'injection');
    xlabel(ax, xLab, text_opts{:}, 'FontSize', 14 * k);
    text(ax, 0.5, 1.04, sprintf('%s (n = %d)', labels{p}, n), 'Units', 'normalized', text_opts{:}, 'FontSize', 16 * k, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Tag', 'panelTitle');
    bar = panel_axes(fig, [heatX(p) + heatW + 10, rowY, 15, axH], '', 12, 0.5);
    bar.Tag = sprintf('colourBar%d', p);
    imagesc(bar, 'XData', [0 1], 'YData', [-3 3], 'CData', linspace(-3, 3, 64)', 'Tag', 'barImage');
    colormap(bar, cmap);
    set(bar, 'CLim', [-3 3], 'XLim', [0 1], 'YLim', [-3 3], 'XTick', [], 'YTick', barZ, 'YAxisLocation', 'right', 'Box', 'on');
    ylabel(bar, 'z', text_opts{:}, 'FontSize', 14 * k);
end
save_figure(fig, 'FigS2_B-D');
