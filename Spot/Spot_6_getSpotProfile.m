clearvars

Spot_0_params;

% SpotTable
load(ffn_ST);

ImgFile = TS.ffnL;
cent = TS.cent;
cc = cell2mat(cent);
NSpot = numel(ImgFile);

% each spot
A = 100;  % crop size
SpotIntensity = nan(NSpot, 1);
xfwhm = nan(NSpot, 1);
yfwhm = nan(NSpot, 1);

parfor n = 1:NSpot
    if mod(n, 10) == 0
        disp(['Processing ', num2str(n), '/', num2str(NSpot), '...']);
    end

    I = imread(ImgFile{n});
    I = I(1+RowCut:end-RowCut, 1+ColCut:end-ColCut);

    % save image
    [~, fn, ~] = fileparts(ImgFile{n});
    ffn = fullfile(SpotPath, [fn, '.tif']);
    imwrite(I, ffn);

    % crop
    rect = [cc(n, 1)-A cc(n, 2)-A A*2 A*2];
    C = imcrop(I, rect);

    [SpotIntensity(n), xf, yf] = fun_measureSpot(C);
    xfwhm(n) = xf*dx;
    yfwhm(n) = yf*dy;
end
xcent = (cc(:, 1)-centX)*dx;
ycent = (cc(:, 2)-centY)*dy;
xSigma = xfwhm/2.3548;
ySigma = yfwhm/2.3548;
TB = table(ImgFile, xcent, ycent, SpotIntensity, xfwhm, yfwhm, xSigma, ySigma);
ffn = fullfile(SpotPath, 'SpotMeasure.csv');
writetable(TB, ffn);