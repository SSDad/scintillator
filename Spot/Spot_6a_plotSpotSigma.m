clearvars

Spot_0_params;

ffn = fullfile(SpotPath, 'SpotMeasure.csv');
TB = readtable(ffn);

% xSigma
hF = figure(1); clf
scatter(1:height(TB), TB.xSigma, 'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5)

xlabel('Pulse #')
ylabel('X-Sigma (mm)')
title('Spot Sigma - X')
axis tight

ffn = fullfile(SpotPath, 'xSigma.png');
saveas(hF, ffn);

% ySigma
hF = figure(2); clf
scatter(1:height(TB), TB.ySigma, 'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5)

xlabel('Pulse #')
ylabel('Y-Sigma (mm)')
title('Spot Sigma - Y')
axis tight

ffn = fullfile(SpotPath, 'ySigma.png');
saveas(hF, ffn);