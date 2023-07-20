%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function     [rMax, cMax] = fun_findBeamPeak(I, bPlot)

[M, N] = size(I);

J = (I-min(I(:)))/range(I(:));

T = graythresh(J);
BW = imbinarize(J,  T*.8);
BW2 = bwareaopen(BW, N*8);

BW2 = imfill(BW2, 'holes');

SE = strel('disk', 8);
BW3 = imdilate(BW2, SE);
BW4 = imerode(BW3, SE);

if bPlot
    hF = figure(11); clf
%     hA(1) = subplot(211);
    hA(1) = axes('Parent', hF);
    imshow(I, [], 'parent', hA(1)); hold on;
%     hA(2) = subplot(212);
%     imshow(BW4, 'parent', hA(2)); hold on;
end

B = bwboundaries(BW4);
xB = B{1}(:, 2);
yB = B{1}(:, 1);
if bPlot
    line(hA(1), xB, yB, 'LineWidth', 1, 'Color', 'g');
%     line(hA(2), xB, yB, 'LineWidth', 2, 'Color', 'g');
end

% r max
rMax = round(mean(yB));
if bPlot
    line(hA(1), [1 N], [rMax rMax], 'Color', 'r')
end
% c max
c2 = max(xB);
c1 = c2-120;
if bPlot
    patch(hA(1), 'XData', [c1 c1 c2 c2], 'YData', [1 M M 1], 'FaceColor', 'c', 'FaceAlpha', 0.1);
end

[~, cm] = max(sum(I(:, c1:c2)));
cMax = cm+c1-1;

if bPlot
    line(hA(1), [cMax cMax], [1 M], 'Color', 'c')
    linkaxes(hA)
end

end