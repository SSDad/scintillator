function [bS, cent, rad] = fun_findSpot(J1)

thR = 0.8;
gauSig = 1;
se = strel('disk', 5);
R = 50;

bS = 0;
cent = [];
rad = nan;

    % remove bright lines
    a = sum(J1, 2);
    ind = find((a-mean(a))>std(a)*6);
    JJ = J1;
    if ~isempty(ind)
        JJ(ind, :) = nan;
        ML = false(size(JJ));
        ML(ind, :) = true;
        JJ = fillmissing(JJ, 'nearest', 'MissingLocations', ML);
        bS = 1;
    end

    J2 = imgaussfilt(JJ, gauSig);
    BW1 = imbinarize(J2, 'adaptive');
    BW2 = bwareaopen(BW1, round(pi*R^2/2));
    NumJ = 2;
    NumBW = 2;
    if any(BW2, 'all')
        BW3 = bwareafilt(BW2, 1);  % keep the largest one
        BW4 = imdilate(BW3, se);
        
        %  circularity
        [B, L] = bwboundaries(BW4);
        stats = regionprops(L,"Circularity", "Centroid", 'Area');

        if stats(1).Circularity > 0.5
            cent = stats(1).Centroid;
            rad = sqrt(stats(1).Area/pi);
            % [cent{n}, rad(n)] = fun_findFitCircle(B{1});
            bS = 2;
            NumBW = 4;
        else
            bS = 1; 
        end
    end

% %% plot
%     hF = figure(1); clf
%         for m = 1:NumJ
%             hA(m) = subplot(ceil((NumJ+NumBW)/2), 2, m, 'Parent', hF);
%             Z = eval(['J', num2str(m)]);
%             imshow(Z, [], 'parent', hA(m));
%         end
%         for mm = 1:NumBW
%             hA(m+mm) = subplot(ceil((NumJ+NumBW)/2), 2, m+mm, 'Parent', hF);
%             ZZ = eval(['BW', num2str(mm)]);
%             imshow(ZZ, 'parent', hA(m+mm));
%         end
%         % axis(hA, 'on');
%         linkaxes(hA);
% 
%         if bS == 2
%             line(hA(m+mm), B{1}(:, 2), B{1}(:, 1), 'Color', 'r', 'LIneWidth', 2)
%             viscircles(hA(1), cent, rad, 'LIneWidth', 1);
%         end
%     end
% 
%     a = 1;