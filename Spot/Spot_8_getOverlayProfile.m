clearvars
bPlot = 0;
Spot_0_params;

load(ffn_ST);
centP = SpotLocation.centP;

A = 100; % crop size
SpotIntensity = nan(NumSpot, 1);
xfwhm = nan(NumSpot, 1);
yfwhm = nan(NumSpot, 1);
for n = 1:NumSpot
    disp(['Processing ', num2str(n), '/', num2str(NumSpot), '...']);

    ffn = fullfile(OverlayPath, ['SpotOverlayMat_', num2str(n), '.mat']);
    DL = load(ffn);
    J = DL.J;
    rect = [centP(n, 1)-A centP(n, 2)-A A*2 A*2];
    C = imcrop(J, rect);

    if bPlot
        hF = figure(999); clf
        imshow(J, []);
        hold on
        rectangle('Position', rect, 'EdgeColor', 'r')
    end

    [SpotIntensity(n), xf, yf] = fun_measureSpot(C);
    xfwhm(n) = xf*dx;
    yfwhm(n) = yf*dy;
end
% xcent = xMean;
% ycent = yMean;

% TB = table(xcent, ycent, SpotIntensity, xfwhm, yfwhm);
% savepath = fullfile(MainPath, ImgFolder, 'ProcessedData');
% ffn = fullfile(savepath, 'OverlayMeasure.csv');
% writetable(TB, ffn);