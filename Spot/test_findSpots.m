clearvars

bPlot = 0;

Spot_0_params;
ImgPath = fullfile(MainPath, ImgFolder);
ImgFileList = dir(fullfile(ImgPath, '*.tif'));

% sort file name
FNL = {ImgFileList.name}';
for n = 1:numel(FNL)
    fn_ST = FNL{n};
    k1 = strfind(fn_ST, '_');
    k2 = strfind(fn_ST, '.');
    fni(n) = str2double(fn_ST(k1(end)+1:k2-1));
end

[~, ind] = sort(fni);
ImgFileList = ImgFileList(ind);
ffnL = fullfile(ImgPath, {ImgFileList.name}');

NumFile = length(ImgFileList);
bS = true(NumFile, 1);
cent = cell(NumFile, 1);
rad = nan(NumFile, 1);

thR = 0.8;
gauSig = 1;

se = strel('disk', 5);
R = 50;

NumJ = 2;
II = [];
for n = 1:NumFile
    if mod(n, 10) == 0
        display(['Processing ', num2str(n), '/', num2str(NumFile)]);
    end

    I = imread(ffnL{n});
    [mI nI] = size(I);
    J1 = I(1+RowCut:end-RowCut, :);
    J2 = imgaussfilt(J1, gauSig);

    BW1 = imbinarize(J2, 'adaptive');
    BW2 = bwareaopen(BW1, round(pi*R^2/2));

    NumBW = 4;
    if any(BW2, 'all')
        BW3 = bwareafilt(BW2, 1);  % keep the largest one
        BW4 = imdilate(BW3, se);
        
        % find centroid
        [B, L] = bwboundaries(BW4);
        [cent{n}, rad(n)] = fun_findFitCircle(B{1});

    else   % no spot
        bS(n) = 0; 
        NumBW = 2;
    end

%     if bPlot
%         hF = figure(n); clf
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
%         axis(hA, 'on');
%         linkaxes(hA);
%     
%         if bS(n)
%             line(hA(m+mm), B{1}(:, 2), B{1}(:, 1), 'Color', 'r', 'LIneWidth', 2)
%             viscircles(hA(1), cent{n}, rad(n), 'LIneWidth', 1);
%         end
%     end
end

TT = table(ffnL, bS, cent, rad);
fn_ST = ['SpotTable_', ImgFolder, '.mat'];
save(fn_ST, 'TT');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function    [cent, rad] = fun_findFitCircle(pp)
    warning('off');
    pp = fliplr(pp);
    cent  = mean(pp);
    pgon = polyshape(pp);
    rad = sqrt(area(pgon)/pi);
end
