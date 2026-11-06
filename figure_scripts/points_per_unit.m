function ppu = points_per_unit(ax)
%POINTS_PER_UNIT  Page points per y data unit of an axes.
fig = ancestor(ax, 'figure');
ppu = ax.Position(4) * fig.UserData.page(2) / diff(ax.YLim);
end
