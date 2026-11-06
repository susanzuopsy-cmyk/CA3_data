function ax = panel_axes(fig, pos, letter, tickFS, lineWidth)
%PANEL_AXES  Axes at pos = [x y width height] on the page (points), with the panel letter at its top left.
% An empty letter gives an axes without a letter (the inset of a panel).
S = repro_style();
page = fig.UserData.page;
ax = axes(fig, 'Units', 'normalized', 'Position', pos ./ [page page], 'FontName', S.font, 'FontWeight', 'bold', ...
    'FontSize', tickFS * S.k, 'LineWidth', lineWidth * S.k, 'XColor', S.axcol, 'YColor', S.axcol, 'Color', 'none', ...
    'Box', 'off', 'TickDir', 'in', 'TickLength', [0.01 0.025], 'Layer', 'top', 'TickLabelInterpreter', 'tex', ...
    'XLimMode', 'manual', 'YLimMode', 'manual');
hold(ax, 'on');
if ~isempty(letter)
    ax.Tag = ['panel' letter];
    annotation(fig, 'textbox', [(pos(1) - 52) / page(1), (pos(2) + pos(4) + 10) / page(2), 30 / page(1), 24 / page(2)], ...
        'String', letter, 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', 18 * S.k, 'EdgeColor', 'none', ...
        'Margin', 0, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'Tag', 'panelLetter');
end
end
