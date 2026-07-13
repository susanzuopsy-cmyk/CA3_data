function plot_meanSEM_lines(train, test, opts)
%PLOT_MEANSEM_LINES  House-style mean+/-SEM + individual-line panel.
% Matches the actual published Fig3/Fig4 style: "thick black line, mean +/-
% SEM; thin gray lines, individual mice/cells". Draws into the CURRENT axes.
%
%   plot_meanSEM_lines(train, test, opts)
%
% opts fields (all optional): panelLabel, groupLabel, yLabel, yLim, statsLine

    train = train(:); test = test(:);
    n = numel(train);

    hold on;
    for i = 1:n
        plot([1 2], [train(i) test(i)], '-', 'Color', [0.65 0.65 0.65], 'LineWidth', 0.5);
    end

    mTr = mean(train); mTe = mean(test);
    sTr = std(train) / sqrt(n); sTe = std(test) / sqrt(n);
    plot([1 2], [mTr mTe], '-', 'Color', 'k', 'LineWidth', 2);
    errorbar([1 2], [mTr mTe], [sTr sTe], 'k', 'LineStyle', 'none', ...
        'LineWidth', 2, 'CapSize', 8);

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

    xlim([0.5 2.5]);
    xticks([1 2]); xticklabels({'Training', 'Test'});
    if isfield(opts, 'yLim') && ~isempty(opts.yLim)
        ylim(opts.yLim);
    end
    axis square; box off;
    hold off;
end

function v = getopt(opts, field, default)
    if isfield(opts, field) && ~isempty(opts.(field))
        v = opts.(field);
    else
        v = default;
    end
end
