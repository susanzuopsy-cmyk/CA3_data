%% Fig5.m
% Figure 5, panels C-H: coupling preference during object-directed approaches, Training and Test.
%   C-E  theta-high gamma; F-H  theta-low gamma. Each point is one approach (Training and Test are not paired).
% Box plots; marks from the Statistics sheet (one-tailed Wilcoxon rank-sum test on approaches; panel D of the
% figure also reports the mixed-effects model, whose values are in the same sheet).
% The horizontal position of the points is random. The printed panels used an unseeded generator, so the points
% here have the same values and the same jitter width as printed, but not the same horizontal offsets.
%
% Input : ../source_data/Fig5_source_data_20261105.xlsx
% Output: ../figures_repro/Fig5_C-H.{png,pdf,fig}

bands  = {'theta_high_gamma', 'theta_low_gamma'};
heads  = {'Theta - high gamma', 'Theta - low gamma'};
treat  = {'CTRL', 'LCA3', 'RCA3'};
cond   = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};
barY   = [0.732 0.677 0.661; 0.844 0.774 0.769];   % significance bars, as printed
seed0  = 500;                                      % jitter of panel i uses seed0 + i
jitW   = 0.15;                                     % full width of the uniform jitter, as printed
colX = [75 300 525]; rowY = [350 45]; axW = 161.25; axH = 198;

src = fullfile(fileparts(mfilename('fullpath')), '..', 'source_data', 'Fig5_source_data_20261105.xlsx');
T  = readtable(src, 'Sheet', 'ApproachDelta');
St = readtable(src, 'Sheet', 'Statistics', 'VariableNamingRule', 'preserve');

[fig, S] = new_figure('Figure 5 C-H', 720, 620);
k = S.k;
boxStyle = struct('boxW', 0.56, 'capW', 0.28, 'boxCol', 'k', 'boxLW', 0.5, 'medLW', 1, 'whLW', 0.5, 'capLW', 0.5, ...
    'whStyle', '-', 'whiskerToFence', true);
st = struct('sigX', [1 2], 'sigLW', 2, 'sigCol', S.axcol, 'sigFS', 16, 'nsFS', 14, 'sigDY', -0.5, 'nsDY', 3.2);
for b = 1:2
    inBand = strcmp(T.Band, bands{b});
    pad = 0.10 * (max(T.Delta(inBand)) - min(T.Delta(inBand)));
    yl = [min(T.Delta(inBand)) - pad, max(T.Delta(inBand)) + pad];   % shared by the band's three panels
    for t = 1:3
        i = 3 * (b - 1) + t; letter = char('C' + i - 1);
        sel = inBand & strcmp(T.Treatment, treat{t});
        tr = T.Delta(sel & strcmp(T.Session, 'Training'));
        te = T.Delta(sel & strcmp(T.Session, 'Test'));
        ax = panel_axes(fig, [colX(t), rowY(b), axW, axH], letter, 12, 0.5);
        set(ax, 'Box', 'on', 'Color', 'w', 'XLim', [0.5 2.5], 'YLim', yl, 'YTick', -0.8:0.2:0.8, 'XTick', [1 2], ...
            'XTickLabel', {'\color{black}Training', '\color{black}Test'}, 'XGrid', 'on', 'YGrid', 'on', 'GridAlpha', 0.15);
        ax.XAxis.FontSize = 14 * k;
        rng(seed0 + i, 'twister');
        scatter(ax, 1 + jitW * (rand(numel(tr), 1) - 0.5), tr, (3.74 * k)^2, S.cTrain, 'filled', 'MarkerFaceAlpha', 0.35, ...
            'MarkerEdgeColor', 'none', 'Tag', 'ptsTrain');
        scatter(ax, 2 + jitW * (rand(numel(te), 1) - 0.5), te, (3.74 * k)^2, S.cTest, 'filled', 'MarkerFaceAlpha', 0.35, ...
            'MarkerEdgeColor', 'none', 'Tag', 'ptsTest');
        draw_box(ax, 1, tr, boxStyle);
        draw_box(ax, 2, te, boxStyle);
        plot(ax, [0.5 2.5], [0 0], '--', 'Color', [0.4 0.4 0.4 0.7], 'LineWidth', k, 'Tag', 'zeroLine');
        add_significance(ax, barY(b, t), significance_mark(St.("p (as in the figure)")(strcmp(St.panel, letter))), st);
        ylabel(ax, '(Const - Mov)/(Const + Mov)', 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 12 * k, 'Color', 'k');
        text(ax, 0.5, 1.02, cond{t}, 'Units', 'normalized', 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 14 * k, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Tag', 'panelTitle');
        if t == 2
            text(ax, 0.5, 1.13, heads{b}, 'Units', 'normalized', 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 16 * k, ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Tag', 'sectionHead');
        end
    end
end
save_figure(fig, 'Fig5_C-H');
