clearvars

% bMovie = 0;
bScatter = 1;

Spot_0_params;

load(ffn_ST);

ind2 = TT.bS ==2;
TS = TT(ind2, :);
FL2 = TS.ffnL;
cent = TS.cent;
cc = cell2mat(cent);

ind0 = TT.bS ==0;
TB = TT(ind0, :);


indSite = kmeans(cc, NumSpot, 'MaxIter', 100);

TS = [TS table(indSite)];

if bScatter
    hF = figure(11); clf
    hA = axes('Parent', hF);
    I = imread(FL2{1});
    I = I(1+RowCut:end-RowCut, :);
    imshow(I, [], 'parent', hA); 
    hold(hA, 'on');
%     hS = scatter(hA, cc(:, 1), cc(:, 2),'MarkerEdgeColor', 'c');
    

    CLR = rand(NumSpot, 3);
    CLR = repmat([eye(3); ones(3)-eye(3)], 20, 1);
    for n = 1:NumSpot
        plot(cc(indSite==n, 1), cc(indSite==n, 2), 'Color', CLR(n, :), 'Marker', '.', 'MarkerSize',12, 'Parent', hA);
    end
end

save(ffn_ST, 'TS', 'TB', '-append');