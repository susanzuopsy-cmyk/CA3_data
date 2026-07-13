function plot_paired_box(train, test, opts)
%PLOT_PAIRED_BOX  House-style paired Training/Test panel.
% Box+scatter+paired-line style (Fig1_discrimination_index_stats.m /
% Fig2_SI_animal_averaged.m plotBoxPanel). Draws into the CURRENT axes
% (caller sets up the subplot/axes position first).
%
%   plot_paired_box(train, test, opts)
%
% opts fields (all optional):
%   panelLabel  - e.g. '2B'
%   groupLabel  - e.g. 'Left CA3 inhibition'
%   yLabel      - y-axis label (only drawn if provided)
%   yLim        - [lo hi], shared axis range set by the caller
%   statsLine   - pre-formatted stats string for the title, e.g.
%                 't(69)=-1.59, d=0.65, n=70' (no p-value; house style)
%   diffInset   - true/false, adds a small inset of (Test-Training) per
%                 unit + mean line (off by default; opt in per caller)

    train = train(:); test = test(:);
    n = numel(train);

    boxplot([train, test], 'Labels', {'Training', 'Test'});
    hold on;

    rng(42);
    xTr = 1 + randn(n, 1) * 0.06;
    xTe = 2 + randn(n, 1) * 0.06;
    for i = 1:n
        plot([xTr(i) xTe(i)], [train(i) test(i)], '-', ...
            'LineWidth', 0.5, 'Color', [0.4 0.4 0.4]);
    end
    scatter(xTr, train, 50, 'b', 'filled', 'MarkerFaceAlpha', 0.8, 'MarkerEdgeColor', 'none');
    scatter(xTe, test,  50, 'r', 'filled', 'MarkerFaceAlpha', 0.8, 'MarkerEdgeColor', 'none');

    if isfield(opts, 'yLabel') && ~isempty(opts.yLabel)
        ylabel(opts.yLabel, 'FontSize', 9, 'FontWeight', 'bold');
    end

    titleLines = {};
    top = strtrim(sprintf('%s %s', getopt(opts, 'panelLabel', ''), getopt(opts, 'groupLabel', '')));
    if ~isempty(top)
        titleLines{end+1} = sprintf('%s (n=%d)', top, n); %#ok<AGROW>
    end
    if isfield(opts, 'statsLine') && ~isempty(opts.statsLine)
        titleLines{end+1} = opts.statsLine; %#ok<AGROW>
    end
    if ~isempty(titleLines)
        title(titleLines, 'FontSize', 8.5);
    end

    xlim([0.5, 2.5]);
    if isfield(opts, 'yLim') && ~isempty(opts.yLim)
        ylim(opts.yLim);
    end
    axis square; box off;

    if isfield(opts, 'diffInset') && opts.diffInset
        addDiffInset(train, test);
    end

    hold off;
end

function addDiffInset(train, test)
% Small inset: per-unit Test-Training difference + mean line.
    n = numel(train);
    d = test - train;

    parentAx = gca;
    parentPos = get(parentAx, 'Position');
    % Cap the inset's absolute height (not just a fraction of the parent) so
    % it doesn't grow large enough to crowd the panel title on tall panels,
    % and leave a wider top margin than a pure 34%-of-height inset would.
    insetW = min(parentPos(3) * 0.34, 0.09);
    insetH = min(parentPos(4) * 0.30, 0.07);
    topGap = 0.03;
    insetPos = [parentPos(1) + parentPos(3) - insetW - 0.005, ...
                parentPos(2) + parentPos(4) - insetH - topGap, ...
                insetW, insetH];

    axInset = axes('Position', insetPos);
    hold(axInset, 'on');
    rng(43);
    xJit = 1 + (rand(n, 1) - 0.5) * 0.5;
    scatter(axInset, xJit, d, 10, [0.35 0.35 0.35], 'filled', 'MarkerFaceAlpha', 0.6);
    plot(axInset, [0.7 1.3], [mean(d) mean(d)], '-', 'Color', [0.85 0.20 0.20], 'LineWidth', 1.4);
    yline(axInset, 0, 'k:', 'LineWidth', 0.5);
    set(axInset, 'XTick', [], 'FontSize', 6, 'Box', 'on', 'Tag', 'diffInset');
    ylabel(axInset, '\Delta', 'FontSize', 7);
    hold(axInset, 'off');
    uistack(axInset, 'top');  % boxplot() otherwise leaves it behind the main axes
    % A later panel's main axes (created after this one) still lands on top
    % of this inset in z-order even though they don't overlap spatially in
    % most renderers' compositing -- restack ALL tagged insets in front
    % right away so each one stays visible regardless of loop order.
    restackInsets(ancestor(axInset, 'figure'));

    axes(parentAx); %#ok<LAXES> restore current axes for the caller
end

function restackInsets(fig)
    insetAxes = findall(fig, 'Type', 'axes', 'Tag', 'diffInset');
    for i = 1:numel(insetAxes)
        uistack(insetAxes(i), 'top');
    end
end

function v = getopt(opts, field, default)
    if isfield(opts, field) && ~isempty(opts.(field))
        v = opts.(field);
    else
        v = default;
    end
end
