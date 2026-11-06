%% Fig1.m
% Figure 1, panels C-H: discrimination index in the Training and Test sessions.
%   C-E  behavioral cohort; F-H  electrophysiology cohort.
% Box plots; lines join each mouse's two sessions; marks from the Statistics sheet (one-tailed paired t-test).
%
% Input : ../source_data/Fig1_source_data_20261105.xlsx
% Output: ../figures_repro/Fig1_C-H.{png,pdf,fig}

letters = 'CDEFGH';
cohort  = {'behavioral', 'behavioral', 'behavioral', 'ephys', 'ephys', 'ephys'};
treat   = {'CTRL', 'LCA3', 'RCA3', 'CTRL', 'LCA3', 'RCA3'};
titles  = {'Control', 'Left CA3 inhibition', 'Right CA3 inhibition'};
barY    = [1.069 1.000 1.000 0.965 0.988 1.050];   % significance bars, as printed
seed    = 42;                                      % jitter of the points, as printed: 0.06 SD, Training then Test
jitSD   = 0.06;
colX = [80 390 700]; rowY = [335 40]; side = 220.5;

src = fullfile(fileparts(mfilename('fullpath')), '..', 'source_data', 'Fig1_source_data_20261105.xlsx');
T  = readtable(src, 'Sheet', 'DiscriminationIndex');
St = readtable(src, 'Sheet', 'Statistics', 'VariableNamingRule', 'preserve');

[fig, S] = new_figure('Figure 1 C-H', 960, 600);
for i = 1:6
    mask = strcmp(T.Cohort, cohort{i}) & strcmp(T.Treatment, treat{i});
    inCohort = strcmp(T.Cohort, cohort{i});
    P = S.boxPaired;
    P.seed = seed; P.jitSD = jitSD; P.lineCol = [0.4 0.4 0.4]; P.lineLW = 0.5;
    P.ylim = cohort_ylim([T.Training(inCohort); T.Test(inCohort)]); P.ytick = -0.8:0.2:1;
    P.ylabel = 'Discrimination index'; P.title = titles{mod(i - 1, 3) + 1};
    P.sig = significance_mark(St.("p (as in the figure)")(strcmp(St.panel, letters(i))));
    P.barY = barY(i); P.sigLW = 1.0; P.sigCol = 'k'; P.sigFS = 21; P.nsFS = 18; P.sigDY = -5; P.nsDY = 3.5;
    ax = panel_axes(fig, [colX(mod(i - 1, 3) + 1), rowY(ceil(i / 3)), side, side], letters(i), P.tickFS, P.axLW);
    plot_paired_box(ax, T.Training(mask), T.Test(mask), P);
end
save_figure(fig, 'Fig1_C-H');

function yl = cohort_ylim(v)
% y-limits shared by a cohort's three panels: its range plus a margin
span = max(v) - min(v);
yl = [min(v) - 0.08 * span, max(v) + 0.10 * span];
end
