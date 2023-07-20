clearvars

bPlot = 1;

SGOrder = 5;
SGLength = 31;

rAvg = 100;
cAvg = 15;
rad = 20;

pusle_0_params;
ImgPath = fullfile(MainPath, ImgFolder);

datafd = ['ProcImages'];
datafn = ['FileList'];
dataPath = fullfile(ImgPath, datafd);
ffn = fullfile(dataPath, datafn);
load(ffn); 

fn_sumI = 'sumI.mat';
ffn_sumI = fullfile(dataPath, fn_sumI);

if exist(ffn_sumI, 'file')
    load(ffn_sumI);
else        

    nFrame = numel(FL_S);
    ImageFileName = cell(nFrame, 1);
    
    iFrame = 1;
    ImageFileName{iFrame} = FL_S(iFrame).name;
    ffn_W{iFrame} = fullfile(dataPath, ImageFileName{iFrame});
    J = imread(ffn_W{iFrame});
    [M, N] = size(J);
    II = uint8(zeros(M, N, nFrame));
    
    parfor iFrame = 1:nFrame
        if mod(iFrame, 10) == 0
            disp(['Reading Image File ', num2str(iFrame), '/', num2str(nFrame)]); 
        end
        ImageFileName{iFrame} = FL_S(iFrame).name;
        ffn_W{iFrame} = fullfile(dataPath, ImageFileName{iFrame});
        II(:,:,iFrame) = imread(ffn_W{iFrame});
    end
    IS = sum(II, 3);
    save(ffn_sumI, 'IS');

end

[rMax, cMax] = fun_findBeamPeak(IS, bPlot); 

    rAvgProf = mean(IS(rMax-rAvg:rMax+rAvg, :));
    rSG = sgolayfilt(double(rAvgProf), SGOrder, SGLength);
    rSGN = (rSG-min(rSG))/range(rSG);

    xfn = 'avgHProfile.csv';
    writematrix([rAvgProf' rSG' rSGN'], fullfile(dataPath, xfn));

if bPlot
    figure(1), clf
%     plot(rAvgProf, '-.'); hold on
    plot(rSGN, 'LineWidth', 2); hold on
    axis tight
end






% hF1 = figure('Visible', 'off');
% FigNo = hF1.Number;
% % hF2 = figure('Visible', 'off');
% 
% for iFrame = 1:nFrame
%    
% %     iFrame
% %     if iFrame == 338
% %         junk = 1;
% %     end
%     
% 
%     I = imread(ffn_W{iFrame});
% 
%     [rMax, cMax] = fun_findBeamPeak(I, bPlot); 
%     
%     rAvgProf = mean(I(rMax-rAvg:rMax+rAvg, :));
%     rSG = sgolayfilt(double(rAvgProf), SGOrder, SGLength);
% 
%     cAvgProf = mean(I(:, cMax-cAvg:cMax+cAvg), 2);
%     cSG = sgolayfilt(double(cAvgProf), SGOrder, SGLength);
%     [cSGmax, cSGMaxLoc] = max(cSG);
% 
%     % plot
%     [mI, nI] = size(I);
%     clf(hF1);
%     hA(1) = subplot(2,3, [1 2 3], 'parent', hF1);
%     hA(2) = subplot(2,3,4, 'parent', hF1);
%     hA(3) = subplot(2,3,5, 'parent', hF1);
%     hA(4) = subplot(2,3,6, 'parent', hF1);
%     hold(hA, "on");
%     
%     I = imread(ffn_W{1});
%     imshow(I, [], 'parent', hA(1));
%     
%     line(hA(1), [1 nI], [rMax rMax], 'Color', 'r')
%     plot(I(rMax, :), 'Parent', hA(2), 'Color', 'r');   
%     plot(rAvgProf, 'Parent', hA(2), 'Color', 'c', 'LineWidth', 1)
% 
%     plot(rSG, 'Parent', hA(2), 'Color', 'g', 'LineWidth', 2)
% %     legend(hA(2), {'Max H Profile', 'Smoothed', 'Avg'}, 'Location', 'north')
% 
%     xx = [1 1 nI nI];
%     yy = [rMax-rAvg rMax+rAvg rMax+rAvg rMax-rAvg];
%     hrP = patch(hA(1), xx, yy, 'c');
%     hrP.FaceAlpha = 0.25;
% 
%     % circle
%     roi = images.roi.Circle(hA(1), 'Center', [cMax rMax], 'Radius', rad, 'Color', 'g', 'InteractionsAllowed', 'none');
%     msk = createMask(roi, mI, nI);
%     Imsk = I.*uint8(msk);
%     avgMax = sum(Imsk(:))/sum(msk(:));
% 
%     line(hA(1), [cMax cMax], [1 mI],  'Color', 'r')
%     plot(I(:, cMax), 'Parent', hA(3), 'Color', 'r');   
%     plot(cAvgProf, 'Parent', hA(3), 'Color', 'c', 'LineWidth', 1)
% 
%     plot(cSG, 'Parent', hA(3), 'Color', 'g', 'LineWidth', 2)
% 
% %     legend(hA(3), {'Max V Profile', 'Smoothed', 'Avg'})
% 
%     yy = [1 mI mI 1];
%     xx = [cMax-cAvg cMax-cAvg cMax+cAvg cMax+cAvg];
%     hcP = patch(hA(1), xx, yy, 'c');
%     hcP.FaceAlpha = 0.25;
% 
%     axis(hA, 'tight')
%     hA(2).Color = 'k';
%     hA(3).Color = 'k';
% 
%     % peak
%     [ySGmax, idxmax] = max(rSG);
%     [ySGmin, idxmin] = min(rSG(idxmax:end));
% 
% %     hA2 = axes('Parent', hF2);
%     xx = 1:numel(rSG);
%     line(hA(4), xx, rSG);
%     axis(hA(4), 'tight');
%     
%     yperc = [.9 .8 .7];
%     for iFrame = 1:numel(yperc)
%         ym = (ySGmax-ySGmin)*yperc(iFrame)+ySGmin;
%         [xi, yi] = polyxpoly(xx, rSG, [1 numel(rSG)], [ym ym]);
% 
%         if numel(xi) > 2
%             xjunk1 = xi(xi<idxmax);
%             xjunk2 = xi(xi>idxmax);
%             xi = [xjunk1(end); xjunk2(1)];
%         end
%         pwidth(iFrame) = abs(diff(xi));
%         yi = [ym; ym];
% 
%         line(hA(4), xi, yi, 'Marker', 'o');
% 
%         if iFrame == 1
%             Distal90{iFrame} = max(xi);
%         end
%     end
% 
%   if bPlot
%       hF1.Visible = 'on';
% %       hF2.Visible = 'on';
%   end
% 
% % table
% HProfWidth90{iFrame} = pwidth(1);
% HProfWidth80{iFrame} = pwidth(2);
% HProfWidth70{iFrame} = pwidth(3);
% VProfPeakLoc{iFrame} = cSGMaxLoc;
% AvgPeakIntensity{iFrame} = avgMax;
% 
% end
% 
% TB= table(ImageFileName, Distal90, HProfWidth90, HProfWidth80, HProfWidth70, VProfPeakLoc, AvgPeakIntensity);
% 
% xfn = 'Data.csv';
% writetable(TB, fullfile(dataPath, xfn));


