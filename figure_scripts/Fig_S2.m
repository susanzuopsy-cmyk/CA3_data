%% Read figure data
clear; clc;

T = readtable('FigS2_source_data.csv');

%% Separate data
SALB = T(strcmp(T.Inhibition,'SALB'),:);
DCZ  = T(strcmp(T.Inhibition,'DCZ'),:);

%% MATLAB default blue
blue = [0 0.4470 0.7410];

figure('Color','w','Position',[300 100 700 700]);

%% ==========================
% SALB
% ==========================
subplot(2,1,1)

errorbar( ...
    SALB.Time_min,...
    SALB.Mean_FR_Hz,...
    SALB.SEM_FR_Hz,...
    'Color',blue,...
    'LineWidth',1.5);

xlim([0 50])
ylim([0 2])

xlabel('Time after injection min')
ylabel('Raw firing rate Hz')
title('SALB inhibition')

box off
set(gca,...
    'FontSize',11,...
    'LineWidth',1,...
    'TickDir','out');

%% ==========================
% DCZ
% ==========================
subplot(2,1,2)

errorbar( ...
    DCZ.Time_min,...
    DCZ.Mean_FR_Hz,...
    DCZ.SEM_FR_Hz,...
    'Color',blue,...
    'LineWidth',1.5);

xlim([0 50])
ylim([0 0.7])

xlabel('Time after injection min')
ylabel('Raw firing rate Hz')
title('DCZ inhibition')

box off
set(gca,...
    'FontSize',11,...
    'LineWidth',1,...
    'TickDir','out');

%% Save if desired
savefig('Fig_s2.fig');
print(gcf,'-dpng','-r300','fig_s2.png');