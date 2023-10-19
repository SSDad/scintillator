clearvars

bMovie = 1;

Spot_0_params;

load(ffn_ST);

ind0 = TT.bS ==0;  % background
FL0 = TT.ffnL(ind0);

ind1 = TT.bS ==1; % bright line
FL1 = TT.ffnL(ind1);

ind2 = TT.bS ==2; % spot
FL2 = TT.ffnL(ind2);
cent = TT.cent(ind2);
cc = cell2mat(cent);
R = TT.rad(ind2);

    hF = figure(11); clf
    hA = axes('Parent', hF);
    I = imread(FL2{1});
    I = I(1+RowCut:end-RowCut, 1+ColCut:end-ColCut);
    hI = imshow(I, [], 'parent', hA); 
    hold(hA, 'on');

    hC = line(nan, nan, 'Marker', 'x', 'Color', 'r', 'LineWidth', 2);
    hO = line(nan, nan, 'Color', 'r', 'LineWidth', 1);
    % hS = scatter(hA, cc(:, 1), cc(:, 2), 'MarkerEdgeColor', 'g');

% movie 
if bMovie
    FL = FL0;
    hA.Title.String = 'File Name';
    for mm = 1:length(FL)

        I = imread(FL{mm});
        I = I(1+RowCut:end-RowCut, 1+ColCut:end-ColCut);
        hI.CData = I;

        set(hC, 'XData', cc(mm, 1), 'YData', cc(mm, 2));
        theta = linspace(0, pi*2, 100);
        xx = cc(mm, 1)+R(mm)*cos(theta);
        yy = cc(mm, 2)+R(mm)*sin(theta);
        set(hO, 'XData', xx, 'YData', yy);



        % cla(hA)
        % imshow(I, [], 'parent', hA);
        % line(hA, cc(mm, 1), cc(mm, 2), 'Marker', '.', 'MarkerSize', 16, 'Color', 'g')

        axis on;
        hA.Title.String = FL{mm};
        hA.Title.Interpreter = 'none';
        pause(0.01)
        %pause(0.2)

    end
end