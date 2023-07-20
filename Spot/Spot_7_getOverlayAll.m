clearvars

Spot_0_params;

OverlayPath = fullfile(MainPath, ImgFolder, 'SpotOverlay');
for n = 1%:25%NumSpot
    disp(['Processing ', num2str(n), '/', num2str(NumSpot), '...']);

    ffn = fullfile(OverlayPath, ['SpotOverlayMat_', num2str(n), '.mat']);
    DL = load(ffn);
    JJ(:,:,n) = DL.J;
end

hF = figure(1); clf
imshow(sum(JJ, 3), []);