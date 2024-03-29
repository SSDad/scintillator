clearvars

Spot_0_params;

data_ST = load(ffn_ST);
TS = data_ST.TS;

% each location
for n = 1:NumSpot
    ind = (TS.indSite == n);
    T1{n} = TS(ind, :);
    pp = cell2mat(T1{n}.cent);
    centP(n, :) = mean(pp);
    stdx(n) = std(pp(:, 1));
    stdy(n) = std(pp(:, 2));
end
cc = mean(centP);
xx = centP(:, 1)-cc(1);
yy = centP(:, 2)-cc(2);

% dxy
nShift = sqrt(NumSpot);
xxs = sort(xx);
nL = mean(xxs(end-nShift+1:end)) - mean(xxs(1:nShift));
dx = XL/nL;

yys = sort(yy);
mL = mean(yys(end-nShift+1:end)) - mean(yys(1:nShift));
dy = YL/mL;

% center
[~, idx0] = min(xx.^2+yy.^2);
centX = centP(idx0, 1);
centY = centP(idx0, 2);

save(ffn_ST, 'dx', 'dy', 'centX', 'centY', "-append");

% x0
[~, ia] = sort(abs(xx));
indx0 = ia(1:sqrt(NumSpot));
xDev = [];
xx0 = [];
for n = 1:length(indx0)
    m = indx0(n);
    pp = cell2mat(T1{m}.cent);
    xx = (pp(:, 1)-centX)*dx;
    xx0 = [xx0; xx];
    xDev = [xDev; pp(:, 1) - centX];
end
hF = figure(1); clf
hA = axes('parent', hF);
hold(hA, 'on')
plot(xx0, xDev, 'o')

%y0
[~, ia] = sort(abs(yy));
indy0 = ia(1:sqrt(NumSpot));



% SpotLocation.centP = centP;





% center point
% c = mean(centP);
% [idx, dist] = dsearchn(centP, c);
% 
% centX = centP(idx, 1);
% centY = centP(idx, 2);
% %
% xMean = (xx-centX)*dx;
% yMean = (yy-centY)*dy;
% xStd = stdx'*dx;
% yStd = stdy'*dy;
% SpotLocation.T = table(xMean, yMean, xStd, yStd);
% 

% plot all point in mm
hF = figure(2); clf
hA = axes('parent', hF);
hold(hA, 'on')

CLR = rand(NumSpot, 3);
for n = 1:NumSpot
    ind = (TS.indSite == n);
    TT{n} = TS(ind, :);
    pp = cell2mat(TT{n}.cent);
    pp = pp-[centX centY];
    scatter(pp(:, 1)*dx, pp(:, 2)*dy, 12, 'o', 'Color', CLR(n, :))
end
hA.XLabel.String = 'y (mm)';
hA.YLabel.String = 'x (mm)';
axis equal
saveas(hF, ffn_SLP)