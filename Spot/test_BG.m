clearvars

% bMovie = 0;
% bScatter = 1;

Spot_0_params;

OverlayPath = fullfile(MainPath, ImgFolder, 'SpotOverlay');
if ~exist(OverlayPath, 'dir')
    mkdir(OverlayPath);
end

fn_ST = ['SpotInd_', ImgFolder, '.mat'];
load(fn_ST);
ind = TS.indSite;
FL2 = TS.ffnL;

% background
FL0 = TB.ffnL;
for n=1:3
        FL = FL0{n};
        I = imread(FL);
        I = I(1+RowCut:end-RowCut, :);
        II(:,:,n) = I;
end
IB = uint8(mean(II, 3));
clear II

for n = 401:430;
    fn = ['2023-04-23_12-32-21_', num2str(n), '.tif'];
    ffn = fullfile(MainPath, ImgFolder, fn);
    I = imread(ffn);
    II(:,:,n) = I(1+RowCut:end-RowCut, :);
end
IB2 = uint8(mean(II, 3));

hF = figure(1); clf
subplot(211)
imshow(uint8(IB), []);

subplot(212)
imshow(uint8(IB), []);

fn = ['2023-04-23_12-32-21_2514.tif'];
ffn = fullfile(MainPath, ImgFolder, fn);
I = imread(ffn);
I = I(1+RowCut:end-RowCut, :);

hF = figure(2); clf
subplot(211)
imshow(I-IB, []);

subplot(212)
imshow(I-IB2, []);
