function run_all_figures()
%RUN_ALL_FIGURES  Draw every figure from the source-data workbooks into ../figures_repro.
addpath(fileparts(mfilename('fullpath')));
scripts = {'Fig1', 'Fig2', 'Fig3', 'Fig4', 'Fig5', 'Fig6', 'FigS2', 'FigS4', 'FigS6', 'FigS7', 'FigS8'};
ok = true(size(scripts));
for i = 1:numel(scripts)
    fprintf('\n===== Running %s =====\n', scripts{i});
    try
        run_one(scripts{i});
    catch ME
        ok(i) = false;
        fprintf(2, 'FAILED: %s\n%s\n', scripts{i}, getReport(ME, 'extended'));
    end
    close all;
end
fprintf('\n===== SUMMARY =====\n');
for i = 1:numel(scripts)
    if ok(i), status = 'OK'; else, status = 'FAILED'; end
    fprintf('%-10s %s\n', scripts{i}, status);
end
if ~all(ok), error('%d of %d figures failed.', nnz(~ok), numel(ok)); end
end

function run_one(name)
% each script runs in its own workspace
run(name);
end
