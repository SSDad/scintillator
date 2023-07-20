clearvars

bPlot = 1;

SGOrder = 5;
SGLength = 31;

rAvg = 100;
cAvg = 15;
rad = 20;


pulse_0_params;
ImgPath = fullfile(MainPath, ImgFolder);

datafd = ['ProcImages'];
datafn = ['FileList'];
dataPath = fullfile(ImgPath, datafd);
ffn = fullfile(dataPath, datafn);
load(ffn); 

nFrame = numel(FL_S);
Distal90 = cell(nFrame, 1);
HProfWidth90 = cell(nFrame, 1);
HProfWidth80 = cell(nFrame, 1);
HProfWidth70 = cell(nFrame, 1);
VProfPeakLoc = cell(nFrame, 1);
AvgPeakIntensity = cell(nFrame, 1);
ImageFileName = cell(nFrame, 1);

for n = 1:nFrame
    ImageFileName{n} = FL_S(n).name;
    ffn_W{n} = fullfile(dataPath, ImageFileName{n});
end

hF1 = figure('Visible', 'off');
FigNo = hF1.Number;
% hF2 = figure('Visible', 'off');

for iFrame = 1:nFrame
   
 %     iFrame
%     if iFrame == 164
%         junk = 1;
%     end
    
    if mod(iFrame, 10) == 0
        disp(['Reading Image File ', num2str(iFrame), '/', num2str(nFrame)]); 
    end

    I = imread(ffn_W{iFrame});

    [rMax, cMax] = fun_findBeamPeak(I, bPlot); 
    
    rAvgProf = mean(I(rMax-rAvg:rMax+rAvg, :));
    rSG = sgolayfilt(double(rAvgProf), SGOrder, SGLength);

    cAvgProf = mean(I(:, cMax-cAvg:cMax+cAvg), 2);
    cSG = sgolayfilt(double(cAvgProf), SGOrder, SGLength);
    [cSGmax, cSGMaxLoc] = max(cSG);

    % plot
    [mI, nI] = size(I);
    clf(hF1);
    hA(1) = subplot(2,3, [1 2 3], 'parent', hF1);
    hA(2) = subplot(2,3,4, 'parent', hF1);
    hA(3) = subplot(2,3,5, 'parent', hF1);
    hA(4) = subplot(2,3,6, 'parent', hF1);
    hold(hA, "on");
    
    I = imread(ffn_W{1});
    imshow(I, [], 'parent', hA(1));
    
    line(hA(1), [1 nI], [rMax rMax], 'Color', 'r')
    plot(I(rMax, :), 'Parent', hA(2), 'Color', 'r');   
    plot(rAvgProf, 'Parent', hA(2), 'Color', 'c', 'LineWidth', 1)

    plot(rSG, 'Parent', hA(2), 'Color', 'g', 'LineWidth', 2)
%     legend(hA(2), {'Max H Profile', 'Smoothed', 'Avg'}, 'Location', 'north')

    xx = [1 1 nI nI];
    yy = [rMax-rAvg rMax+rAvg rMax+rAvg rMax-rAvg];
    hrP = patch(hA(1), xx, yy, 'c');
    hrP.FaceAlpha = 0.25;

    % circle
    roi = images.roi.Circle(hA(1), 'Center', [cMax rMax], 'Radius', rad, 'Color', 'g', 'InteractionsAllowed', 'none');
    msk = createMask(roi, mI, nI);
    Imsk = I.*uint8(msk);
    avgMax = sum(Imsk(:))/sum(msk(:));

    line(hA(1), [cMax cMax], [1 mI],  'Color', 'r')
    plot(I(:, cMax), 'Parent', hA(3), 'Color', 'r');   
    plot(cAvgProf, 'Parent', hA(3), 'Color', 'c', 'LineWidth', 1)

    plot(cSG, 'Parent', hA(3), 'Color', 'g', 'LineWidth', 2)

%     legend(hA(3), {'Max V Profile', 'Smoothed', 'Avg'})

    yy = [1 mI mI 1];
    xx = [cMax-cAvg cMax-cAvg cMax+cAvg cMax+cAvg];
    hcP = patch(hA(1), xx, yy, 'c');
    hcP.FaceAlpha = 0.25;

    axis(hA, 'tight')
    hA(2).Color = 'k';
    hA(3).Color = 'k';

    % peak
    [ySGmax, idxmax] = max(rSG);
    [ySGmin, idxmin] = min(rSG(idxmax:end));

%     hA2 = axes('Parent', hF2);
    xx = 1:numel(rSG);
    line(hA(4), xx, rSG);
    axis(hA(4), 'tight');
    
    yperc = [.9 .8 .7];
    for n = 1:numel(yperc)
        ym = (ySGmax-ySGmin)*yperc(n)+ySGmin;
        [xi, yi] = polyxpoly(xx, rSG, [1 numel(rSG)], [ym ym]);

        if numel(xi) > 2
            xjunk1 = xi(xi<idxmax);
            xjunk2 = xi(xi>idxmax);
            xi = [xjunk1(end); xjunk2(1)];
        end
        pwidth(n) = abs(diff(xi));
        yi = [ym; ym];

        line(hA(4), xi, yi, 'Marker', 'o');

        if n == 1
            Distal90{iFrame} = max(xi);
        end
    end

  if bPlot
      hF1.Visible = 'on';
%       hF2.Visible = 'on';
  end

% table
HProfWidth90{iFrame} = pwidth(1);
HProfWidth80{iFrame} = pwidth(2);
HProfWidth70{iFrame} = pwidth(3);
VProfPeakLoc{iFrame} = cSGMaxLoc;
AvgPeakIntensity{iFrame} = avgMax;

end

TB= table(ImageFileName, Distal90, HProfWidth90, HProfWidth80, HProfWidth70, VProfPeakLoc, AvgPeakIntensity);

xfn = 'Data.csv';
writetable(TB, fullfile(dataPath, xfn));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function     [rMax, cMax] = fun_findBeamPeak(I, bPlot)

[M, N] = size(I);
BW = imbinarize(I);
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
% c2 = max(xB);
% c1 = c2-120;

[~, cMax] = max(sum(I));
c1 = cMax-60;
c2  = cMax+60;

if bPlot
    patch(hA(1), 'XData', [c1 c1 c2 c2], 'YData', [1 M M 1], 'FaceColor', 'c', 'FaceAlpha', 0.1);
end

% [~, cMax] = max(sum(I(:, c1:c2)));
% cMax = cMax+c1-1;

if bPlot
    line(hA(1), [cMax cMax], [1 M], 'Color', 'c')
    linkaxes(hA)
end

end