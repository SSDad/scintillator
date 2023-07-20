clearvars

Spot_0_params;

fn_SI = ['SpotInd_', ImgFolder, '.mat'];
data_SI = load(fn_SI);
TS = data_SI.TS;

% each location
for n = 1:81
    ind = (TS.indSite == n);
    T{n} = TS(ind, :);
    pp = cell2mat(T{n}.cent);
    centP(n, :) = mean(pp);
    stdx(n) = std(pp(:, 1));
    stdy(n) = std(pp(:, 2));
end
xx = centP(:, 1);
yy = centP(:, 2);

% dxy
xxs = sort(xx);
nL = mean(xxs(end-8:end)) - mean(xxs(1:9));
dx = XL/nL;

yys = sort(yy);
mL = mean(yys(end-8:end)) - mean(yys(1:9));
dy = YL/mL;

% center point
c = mean(centP);
[idx, dist] = dsearchn(centP, c);

centX = centP(idx, 1);
centY = centP(idx, 2);
%
xMean = (xx-centX)*dx;
yMean = (yy-centY)*dy;
xStd = stdx'*dx;
yStd = stdy'*dy;
TB = table(xMean, yMean, xStd, yStd);

savepath = fullfile(MainPath, ImgFolder, 'ProcessedData');
if ~exist(savepath, 'dir')
    mkdir(savepath);
end
TBffn = fullfile(savepath, 'SpotLocation.csv');
writetable(TB, TBffn);

ffn = fullfile(savepath, 'SpotLocationMat.mat');
save(ffn, 'cent*', '*Mean', '*Std', 'dx', 'dy');

% plot all point in mm
hF = figure(2); clf
hA = axes('parent', hF);
hold(hA, 'on')

CLR = rand(81, 3);
for n = 1:81
    ind = (TS.indSite == n);
    T{n} = TS(ind, :);
    pp = cell2mat(T{n}.cent);
    pp = pp-[centX centY];
    scatter(pp(:, 1)*dx, pp(:, 2)*dy, 12, 'o', 'Color', CLR(n, :))
end
axis equal
Figffn = fullfile(savepath, 'SpotPlot.png');
saveas(hF, Figffn)



% allP = cell2mat(TS.cent);
% allX = allP(:, 1);
% allY = allP(:, 2);
% allX = (allX-centX)*dx;
% allY = (allY-centY)*dy;
% 
% hF = figure(2); clf
% scatter(allX, allY, 12, 'o')
% axis tight equal
% Figffn = fullfile(savepath, 'SpotPlot.png');
% saveas(hF, Figffn)
