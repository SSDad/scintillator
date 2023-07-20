clearvars

% bMovie = 0;
bScatter = 1;

Spot_0_params;

fn_ST = ['SpotTable_', ImgFolder, '.mat'];
load(fn_ST);

ind2 = TT.bS ==2;
TS = TT(ind2, :);
FL1 = TS.ffnL;
cent = TS.cent;
cc = cell2mat(cent);

ind0 = TT.bS ==0;
TB = TT(ind0, :);

NumLoc = 81;
indSite = kmeans(cc, NumLoc, 'MaxIter', 100);

TS = [TS table(indSite)];

if bScatter
    hF = figure(11); clf
    hA = axes('Parent', hF);
    I = imread(FL1{1});
    I = I(1+RowCut:end-RowCut, :);
    imshow(I, [], 'parent', hA); 
    hold(hA, 'on');
    hS = scatter(hA, cc(:, 1), cc(:, 2),'MarkerEdgeColor', 'c');
    

    CLR = rand(NumLoc, 3);
    CLR = repmat([eye(3); ones(3)-eye(3)], 20, 1);
    for n = 1:NumLoc
        plot(cc(indSite==n, 1), cc(indSite==n, 2), 'Color', CLR(n, :), 'Marker', '.', 'MarkerSize',12, 'Parent', hA);
    end
end

fn_ST = ['SpotInd_', ImgFolder, '.mat'];
% save(fn_ST, 'TS', 'TB');