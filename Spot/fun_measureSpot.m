function [SpotIntensity, xfwhm, yfwhm] = fun_measureSpot(J)

bPlot = 0;

if bPlot
    hF2 = figure; clf
else
    hF2 = figure('Visible', 'off');
end
hA2 = axes('parent', hF2);
imshow(J, [], 'parent', hA2);

% find center
% gauSig = 1;
% R = 50;
% K2 = imgaussfilt(J, gauSig);
% K3 = imbinarize(K2, 0.75);
% K4 = bwareaopen(K3, round(pi*R^2/4));
% BB = bwboundaries(K4);
% line(hA2, BB{1}(:,2), BB{1}(:,1), 'Color', 'r');
% [cent, rad] = fun_findFitCircle(BB{1});
% 
% if bPlot
%     hF = figure(11); clf
%     hB1 = subplot(221, 'parent', hF);
%     imshow(K2, [],  'parent', hB1);
%     hB2 = subplot(222, 'parent', hF);
%     imshow(K3, 'parent', hB2);
%     hB3 = subplot(223, 'parent', hF);
%     imshow(K4, 'parent', hB3);
% end

% [offset] = fun_findPeakBlock(J, 9, 9);
cent = fun_findPeakBlock(J, 9, 9);

% intensity
[mJ, nJ] = size(J);
roi = images.roi.Circle(hA2, 'Center', cent, 'Radius', 10, 'Color', 'g', 'InteractionsAllowed', 'none');
msk = createMask(roi, mJ, nJ);
Imsk = double(J).*double(msk);
SpotIntensity = sum(Imsk(:))/sum(msk(:));
axis on;
line(hA2, cent(1), cent(2), 'Marker', '.', 'Color', 'r', 'MarkerSize', 16);

        % FWHM
        xm = round(cent(1));
        ym = round(cent(2));

        line(hA2, [1 nJ], [ym ym], 'Color', 'm');  % xprof line
        line(hA2, [xm xm], [1 mJ], 'Color', 'c');  % yprof line

       xprof = J(xm, :);
%         RR = 0;
%         junk = J(xm-RR:xm+RR, :);
%         xprof = mean(junk);
        xx = 1:numel(xprof);
        [xSG, xix, yix, xfwhm] = fun_fwhm(xx, double(xprof));

        yprof = J(:, ym);
%         junk = J(:, ym-RR:ym+RR);
%         yprof = mean(junk, 2);
        yy = 1:numel(yprof);
        [ySG, xiy, yiy, yfwhm] = fun_fwhm(yy, double(yprof));

    if bPlot
        hF3 = figure; clf
        hA31 = subplot(211, 'parent', hF3);
        plot(xprof, 'o-', 'parent', hA31); hold on
        plot(xSG, 'm-', 'LineWidth', 3, 'parent', hA31);
        line(hA31, xix, yix)
        axis tight

        hA32 = subplot(212, 'parent', hF3);
        plot(yprof, 'o-', 'parent', hA32); hold on
        plot(ySG, 'c-', 'LineWidth', 3, 'parent', hA32);
        line(hA32, xiy, yiy)
        axis tight
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function    [cent, rad] = fun_findFitCircle(pp)
    warning('off');
    pp = fliplr(pp);
    cent  = mean(pp);
    pgon = polyshape(pp);
    rad = sqrt(area(pgon)/pi);
end

function cent = fun_findPeakBlock(I, mB, nB)
[mI, nI] = size(I);
MM = mI-mB+1;
NN = nI-nB+1;
s = zeros(MM, NN);
for m = 1:MM
    for n = 1:NN
        K = I(m:m+mB-1, n:n+nB-1);
        s(m, n) = sum(K(:));
    end
end

[max_num, idx] = max(s(:));
[Y, X]=ind2sub(size(s), idx);
cent = [X+ceil(nB/2) Y+ceil(mB/2)];

%     J = ones(mB, nB)-rand(mB, nB)/1e6;
% 
%     c = normxcorr2(J, I);
%     [max_c, imax] = max(abs(c(:)));
%     [ypeak, xpeak] = ind2sub(size(c),imax(1));
%     offset = [(xpeak-size(J,2)) (ypeak-size(J,1))];

end


function [ySG, xi, yi, fwhm] = fun_fwhm(x, y)
    SGOrder = 5;
    SGLength = 31;
    ySG = sgolayfilt(double(y), SGOrder, SGLength);

    ymax = max(ySG);
    ymin = min(ySG);
    ym = (ymax+ymin)/2;

    xL = [x(1) x(end)];
    yL = [ym ym];
    [xi, yi] = polyxpoly(xL', yL', x', ySG');

    if numel(xi) == 2
        fwhm = diff(xi);
    else
        fwhm = nan;
    end

end