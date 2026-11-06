function save_figure(fig, name)
%SAVE_FIGURE  Save a figure to ../figures_repro as .png (300 dpi), .pdf (vector, fonts embedded) and .fig.
outDir = fullfile(fileparts(mfilename('fullpath')), '..', 'figures_repro');
if ~exist(outDir, 'dir'), mkdir(outDir); end
base = fullfile(outDir, name);
print(fig, [base '.png'], '-dpng', '-r300');
exportgraphics(fig, [base '.pdf'], 'ContentType', 'vector', 'BackgroundColor', 'none');
savefig(fig, [base '.fig']);
fprintf('Saved %s.{png,pdf,fig}\n', name);
end
