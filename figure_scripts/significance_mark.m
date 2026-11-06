function s = significance_mark(p)
%SIGNIFICANCE_MARK  The mark printed for a p value.
if p < 0.001
    s = '***';
elseif p < 0.01
    s = '**';
elseif p < 0.05
    s = '*';
else
    s = 'n.s.';
end
end
