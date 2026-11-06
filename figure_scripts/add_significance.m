function add_significance(ax, y, mark, st)
%ADD_SIGNIFICANCE  Bar at height y (data units) from st.sigX(1) to st.sigX(2), with its mark above it.
% st: the style fields sigX, sigLW, sigCol, sigFS, nsFS, sigDY, nsDY of repro_style (lengths in points).
S = repro_style();
plot(ax, st.sigX, [y y], '-', 'Color', st.sigCol, 'LineWidth', st.sigLW * S.k, 'Tag', 'sigBar');
if strcmp(mark, 'n.s.'), fs = st.nsFS; dy = st.nsDY; else, fs = st.sigFS; dy = st.sigDY; end
text(ax, mean(st.sigX), y + dy / points_per_unit(ax), mark, 'FontName', S.font, 'FontWeight', 'bold', 'FontSize', fs * S.k, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'baseline', 'Color', 'k', 'Interpreter', 'none', 'Tag', 'sigText');
end
