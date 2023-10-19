clearvars

Spot_0_params;

load(ffn_ST);
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
IB = mean(II, 3);

hF = figure(1); clf
hA = axes('parent', hF);
hI = imshow(IB, [], 'Parent', hA);
hA.Title.String = 'Background';

NumLoc = numel(unique(ind));
for n = 1:NumLoc
    disp(['Loc ', num2str(n), '/', num2str(NumLoc)]);
    jnd = find(ind == n);
    parfor m = 1:numel(jnd)
        FL = FL2{jnd(m)};
        I = imread(FL);
        I = I(1+RowCut:end-RowCut, :);
        II(:,:,m) = double(I)-IB;
    end
    J = sum(II, 3);
    clear II
    ffn = fullfile(OverlayPath, ['SpotOverlayMat_', num2str(n), '.mat']);
    save(ffn, 'J');

    hI.CData = J;
    hA.CLim = [min(J(:)) max(J(:))];
    hA.Title.String = [num2str(n)];

    ffn = fullfile(OverlayPath, ['SpotOverlay_', num2str(n), '.png']);
    saveas(hF, ffn);

end