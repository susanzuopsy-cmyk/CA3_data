function plot_normalized_delta_group(dataByGroup, groupLabels, opts)
%PLOT_NORMALIZED_DELTA_GROUP  House-style single-group scatter + mean+/-SEM.
% Matches the published Fig S1 style (OLT_speed_distance_stats_v3.m /
% Fig_S1cd_ephys_locomotion_stats.m plotNormalizedDeltaGroup): jittered dots
% per treatment group + mean+/-SEM square, since the underlying design is
% across-treatment on a normalized delta, not a within-treatment pair.
% Draws into the CURRENT axes.
%
%   plot_normalized_delta_group(dataByGroup, groupLabels, opts)
%
% dataByGroup - cell array {1 x nGroups}, each a column vector of per-mouse
%               normalized-delta values
% groupLabels - cell array {1 x nGroups} of treatment names (x-tick labels)
% opts fields (all optional): panelLabel, groupLabel (title), yLabel, yLim

    colors_grp = [0.50 0.50 0.50; 0.25 0.55 0.85; 0.85 0.35 0.25];
    nG = numel(dataByGroup);

    hold on;
    yAll = [];
    for g = 1:nG
        d = dataByGroup{g}; d = d(~isnan(d));
        if isempty(d), continue; end
        yAll = [yAll; d]; %#ok<AGROW>
        rng(g * 7);
        xJit = g + randn(numel(d), 1) * 0.09;
        m = mean(d); sem = std(d) / sqrt(numel(d));
        colIdx = mod(g - 1, size(colors_grp, 1)) + 1;
        errorbar(g, m, sem, 'k-', 'LineWidth', 1.8, 'CapSize', 10);
        plot(g, m, 's', 'MarkerSize', 9, 'MarkerFaceColor', colors_grp(colIdx, :) * 0.65, ...
             'MarkerEdgeColor', 'none');
        scatter(xJit, d, 52, colors_grp(colIdx, :), 'filled', ...
                'MarkerFaceAlpha', 0.75, 'MarkerEdgeColor', 'none');
    end
    plot([0.4, nG + 0.6], [0, 0], 'k--', 'LineWidth', 0.9, 'Color', [0.4 0.4 0.4]);

    xticks(1:nG); xticklabels(groupLabels);
    if isfield(opts, 'yLabel') && ~isempty(opts.yLabel)
        ylabel(opts.yLabel, 'FontSize', 9, 'FontWeight', 'bold');
    end
    top = strtrim(sprintf('%s %s', getopt(opts, 'panelLabel', ''), getopt(opts, 'groupLabel', '')));
    if ~isempty(top)
        title(top, 'FontSize', 10);
    end

    xlim([0.4, nG + 0.6]);
    if isfield(opts, 'yLim') && ~isempty(opts.yLim)
        ylim(opts.yLim);
    elseif ~isempty(yAll)
        ySpan = max(yAll) - min(yAll);
        if ySpan < eps, ySpan = 1; end
        ylim([min(yAll) - ySpan * 0.08, max(yAll) + ySpan * 0.12]);
    end
    box off; hold off;
end

function v = getopt(opts, field, default)
    if isfield(opts, field) && ~isempty(opts.(field))
        v = opts.(field);
    else
        v = default;
    end
end
