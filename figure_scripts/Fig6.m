%% Fig6.m
% Figure 6, panels A-C: CA1 cell-assembly reactivation strength in the Training and Test sessions.
% Box plots; lines join each assembly's two sessions; marks from the Statistics sheet (two-tailed Wilcoxon
% signed-rank test).
%
% Input : ../source_data/Fig6_source_data_20261105.xlsx
% Output: ../figures_repro/Fig6_A-C.{png,pdf,fig}

treat = {'CTRL', 'LCA3', 'RCA3'};
cond  = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};
ylim6 = [4.6056295 78.9];          % shared by the three panels
seed  = 42;                        % jitter of the points, as printed: 0.1 SD, Training then Test
jitSD = 0.1;
colX = [60 355 650]; axW = 240; axH = 297; rowY = 35;

src = fullfile(fileparts(mfilename('fullpath')), '..', 'source_data', 'Fig6_source_data_20261105.xlsx');
T  = readtable(src, 'Sheet', 'AssemblyStrength');
St = readtable(src, 'Sheet', 'Statistics', 'VariableNamingRule', 'preserve');

[fig, S] = new_figure('Figure 6 A-C', 905, 375);
for t = 1:3
    letter = char('A' + t - 1);
    sel = strcmp(T.Treatment, treat{t});
    P = S.boxPaired;
    P.seed = seed; P.jitSD = jitSD; P.lineCol = [0.502 0.502 0.502 0.302]; P.lineLW = 0.5;
    P.ylim = ylim6; P.ytick = 10:10:70; P.ylabel = 'Cell Assembly Strength';
    P.title = sprintf('%s (n = %d)', cond{t}, nnz(sel));
    P.sig = significance_mark(St.("p (as in the figure)")(strcmp(St.panel, letter)));
    P.barDown = 32.03; P.sigX = [0.99867 1.97692];
    ax = panel_axes(fig, [colX(t), rowY, axW, axH], letter, P.tickFS, P.axLW);
    plot_paired_box(ax, T.Training(sel), T.Test(sel), P);
end
save_figure(fig, 'Fig6_A-C');
