function draw_box(ax, x, v, st)
%DRAW_BOX  Box at x: 25th, 50th and 75th percentiles; whiskers to the most extreme value within 1.5 x IQR.
% With st.whiskerToFence, whiskers stop at the smaller of the extreme value and the 1.5 x IQR limit (Fig 5).
S = repro_style(); k = S.k;
q = prctile(v, [25 50 75]);
iq = q(3) - q(1);
if isfield(st, 'whiskerToFence') && st.whiskerToFence
    lo = max(min(v), q(1) - 1.5 * iq);
    hi = min(max(v), q(3) + 1.5 * iq);
else
    lo = min(v(v >= q(1) - 1.5 * iq));
    hi = max(v(v <= q(3) + 1.5 * iq));
end
w = st.boxW / 2; c = st.capW / 2; id = sprintf('%d', round(x));
plot(ax, [x x], [q(3) hi], st.whStyle, 'Color', 'k', 'LineWidth', st.whLW * k, 'Tag', ['whiskerUp' id]);
plot(ax, [x x], [lo q(1)], st.whStyle, 'Color', 'k', 'LineWidth', st.whLW * k, 'Tag', ['whiskerLo' id]);
plot(ax, [x - c x + c], [hi hi], '-', 'Color', 'k', 'LineWidth', st.capLW * k, 'Tag', ['capUp' id]);
plot(ax, [x - c x + c], [lo lo], '-', 'Color', 'k', 'LineWidth', st.capLW * k, 'Tag', ['capLo' id]);
plot(ax, [x - w x + w x + w x - w x - w], [q(1) q(1) q(3) q(3) q(1)], '-', 'Color', st.boxCol, ...
    'LineWidth', st.boxLW * k, 'Tag', ['box' id]);
plot(ax, [x - w x + w], [q(2) q(2)], '-', 'Color', 'k', 'LineWidth', st.medLW * k, 'Tag', ['median' id]);
end
