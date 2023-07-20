clearvars

Spot_0_params;

% fn_SI = ['SpotInd_', ImgFolder, '.mat'];
% data_SI = load(fn_SI);
% TS = data_SI.TS;

savepath = fullfile(MainPath, ImgFolder, 'ProcessedData');
ffn = fullfile(savepath, 'SpotLocationMat.mat');
% save(ffn, 'centP', '*Mean', '*Std');
load(ffn);

OverlayPath = fullfile(MainPath, ImgFolder, 'SpotOverlay');
A = 100;
SpotIntensity = nan(NumSpot, 1);
xfwhm = nan(NumSpot, 1);
yfwhm = nan(NumSpot, 1);
for n = 7%1:NumSpot
    disp(['Processing ', num2str(n), '/', num2str(NumSpot), '...']);

    ffn = fullfile(OverlayPath, ['SpotOverlayMat_', num2str(n), '.mat']);
    DL = load(ffn);
    J = DL.J;
    rect = [centP(n, 1)-A centP(n, 2)-A A*2 A*2];
    C = imcrop(J, rect);

    [SpotIntensity(n), xf, yf] = fun_measureSpot(C);
    xfwhm(n) = xf*dx;
    yfwhm(n) = yf*dy;
end
xcent = xMean;
ycent = yMean;

TB = table(xcent, ycent, SpotIntensity, xfwhm, yfwhm);
savepath = fullfile(MainPath, ImgFolder, 'ProcessedData');
ffn = fullfile(savepath, 'OverlayMeasure.csv');
% writetable(TB, ffn);