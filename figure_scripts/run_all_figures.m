scripts = {'Fig1','Fig2','Fig3','Fig4','Fig5','FigS1','FigS4','FigS5'};
ok = true(numel(scripts),1);
for i = 1:numel(scripts)
    fprintf('\n===== Running %s =====\n', scripts{i});
    try
        run(scripts{i});
    catch ME
        ok(i) = false;
        fprintf(2, 'FAILED: %s\n%s\n', scripts{i}, getReport(ME, 'extended'));
    end
    close all;
end
fprintf('\n===== SUMMARY =====\n');
for i = 1:numel(scripts)
    fprintf('%-10s %s\n', scripts{i}, ternary(ok(i),'OK','FAILED'));
end
function s = ternary(c,a,b), if c, s=a; else, s=b; end, end
