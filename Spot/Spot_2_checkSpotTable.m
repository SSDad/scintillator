clearvars

% RowCut = 0;
% ColCut = 0;

bMovie = 1;

Spot_0_params;

fn_ST = ['SpotTable_', ImgFolder, '.mat'];
load(fn_ST);

ind0 = TT.bS ==0;
FL0 = TT.ffnL(ind0);

ind1 = TT.bS ==1;
FL1 = TT.ffnL(ind1);

ind2 = TT.bS ==0;
FL2 = TT.ffnL(ind2);
cent = TT.cent(ind2);
cc = cell2mat(cent);

    hF = figure(11); clf
    hA = axes('Parent', hF);
    I = imread(FL2{1});
    I = I(1+RowCut:end-RowCut, 1+ColCut:end-ColCut);
    hI = imshow(I, [], 'parent', hA); 
    hold(hA, 'on');
    % hS = scatter(hA, cc(:, 1), cc(:, 2), 'MarkerEdgeColor', 'g');

% movie 
if bMovie
    FL = FL2;
    hA.Title.String = 'File Name';
    for mm = 1:length(FL)

        I = imread(FL{mm});
        I = I(1+RowCut:end-RowCut, 1+ColCut:end-ColCut);
        hI.CData = I;
        % cla(hA)
        % imshow(I, [], 'parent', hA);

        % line(hA, cc(mm, 1), cc(mm, 2), 'Marker', '.', 'MarkerSize', 16, 'Color', 'g')

        axis on;
        hA.Title.String = FL{mm};
        hA.Title.Interpreter = 'none';
        pause(0.2)

    end
end