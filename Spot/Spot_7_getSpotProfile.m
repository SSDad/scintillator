clearvars

Spot_0_params;

% fn_SI = ['SpotInd_', ImgFolder, '.mat'];
% data_SI = load(fn_SI);
% TS = data_SI.TS;

% SpotTable
fn_ST = ['SpotTable_', ImgFolder, '.mat'];
load(fn_ST);
ind2 = TT.bS ==2;
ImgFile = TT.ffnL(ind2);
cent = TT.cent(ind2);
cc = cell2mat(cent);
NumSpot = numel(ImgFile);

% dxdy
procpath = fullfile(MainPath, ImgFolder, 'ProcessedData');
ffn = fullfile(procpath, 'SpotLocationMat.mat');
% save(ffn, 'centP', '*Mean', '*Std', 'dx', 'dy');
load(ffn);

% SpotProfile
spotpath = fullfile(MainPath, ImgFolder, 'Spot');
if ~exist(spotpath, 'dir')
    mkdir(spotpath);
end

% each spot
A = 100;  % crop size
SpotIntensity = nan(NumSpot, 1);
xfwhm = nan(NumSpot, 1);
yfwhm = nan(NumSpot, 1);

parfor n = 1:NumSpot
    if mod(n, 10) == 0
        disp(['Processing ', num2str(n), '/', num2str(NumSpot), '...']);
    end

    I = imread(ImgFile{n});
    I = I(1+RowCut:end-RowCut, 1+ColCut:end-ColCut);

    % save image
    [~, fn, ~] = fileparts(ImgFile{n});
    ffn = fullfile(spotpath, [fn, '.tif']);
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

TB = table(ImgFile, xcent, ycent, SpotIntensity, xfwhm, yfwhm);
spotpath = fullfile(MainPath, ImgFolder, 'ProcessedData');
ffn = fullfile(spotpath, 'SpotMeasure.csv');
writetable(TB, ffn);