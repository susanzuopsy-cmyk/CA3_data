%% FigS7.m
% Figure S7, panels A-F: CA1 place-cell sparsity (A-C) and field coherence (D-F), Training and Test, with the
% per-cell Test - Training difference in the inset. Marks from the Statistics sheet (one-tailed Wilcoxon signed-rank
% test in A-C, one-tailed paired t-test in D-F).
% Panel F: one cell (MM006, TT8, cell 1; Test coherence 3.21) lies above the plotted range and is not drawn in the
% panel or its inset. It is included in n, in the box plot, in the mean of the inset and in the test.
%
% Input : ../source_data/FigS7_source_data_20261105.xlsx
% Output: ../figures_repro/FigS7_A-F.{png,pdf,fig}

treat = {'CTRL', 'LCA3', 'RCA3'};
cond  = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};
sheet = {'Sparsity', 'FieldCoherence'};
ylab  = {'Sparsity', 'Field Coherence (z)'};
ylims = {[0.0047 1.0354], [-1.8 1.8]};
yticks = {0.1:0.1:1, -1.5:0.5:1.5};
inLim  = {[-0.7177 0.7177], [-3 1.6]};
inTick = {-0.6:0.2:0.6, -3:1};
seed0 = 20261209;                  % jitter of panel k uses seed0 + k
colX = [60 440 820]; rowY = [322 48];

src = fullfile(fileparts(mfilename('fullpath')), '..', 'source_data', 'FigS7_source_data_20261105.xlsx');
St = readtable(src, 'Sheet', 'Statistics', 'VariableNamingRule', 'preserve');

[fig, S] = new_figure('Figure S7 A-F', 1170, 600);
for r = 1:2
    T = readtable(src, 'Sheet', sheet{r});
    for t = 1:3
        k = 3 * (r - 1) + t; letter = char('A' + k - 1);
        sel = strcmp(T.Treatment, treat{t});
        P = S.boxInset;
        P.seed = seed0 + k;
        P.ylim = ylims{r}; P.ytick = yticks{r}; P.ylabel = ylab{r};
        P.inset = struct('ylim', inLim{r}, 'ytick', inTick{r}, 'label', 'Test-Training');
        P.title = sprintf('%s - All cells (n = %d)', cond{t}, nnz(sel));
        P.sig = significance_mark(St.("p (as in the figure)")(strcmp(St.panel, letter)));
        if strcmp(letter, 'F')
            P.omit = strcmp(T.Mouse(sel), 'MM006') & strcmp(T.tetrode(sel), 'TT8') & T.CellID(sel) == 1;
        end
        ax = panel_axes(fig, [colX(t), rowY(r), P.axW, P.axH], letter, P.tickFS, P.axLW);
        plot_paired_box(ax, T.Training(sel), T.Test(sel), P);
    end
end
save_figure(fig, 'FigS7_A-F');
