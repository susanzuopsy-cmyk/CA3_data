function [fig, S] = new_figure(name, pageW, pageH)
%NEW_FIGURE  White figure window for a page of pageW x pageH points (see repro_style).
S = repro_style();
ppi = get(0, 'ScreenPixelsPerInch');
sizePx = [pageW pageH] * S.k * ppi / 72;
screen = get(0, 'ScreenSize');
if any(sizePx > screen(3:4) - [0 40])
    warning('%s is %d x %d pixels, larger than this %d x %d screen: the saved files may be cut off.', ...
        name, round(sizePx), screen(3:4));
end
fig = figure('Name', name, 'Color', 'w', 'Units', 'pixels', 'Position', [10 40 sizePx], ...
    'Renderer', 'painters', 'InvertHardcopy', 'off', 'PaperPositionMode', 'auto', ...
    'UserData', struct('page', [pageW pageH]));
end
