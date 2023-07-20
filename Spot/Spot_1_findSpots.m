clearvars

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
bS = zeros(NumFile, 1);
cent = cell(NumFile, 1);
rad = nan(NumFile, 1);

II = [];
parfor n = 1:NumFile
    if mod(n, 10) == 0
        display(['Processing ', num2str(n), '/', num2str(NumFile)]);
    end

    I = imread(ffnL{n});
   J = I(1+RowCut:end-RowCut, 1+ColCut:end-ColCut);

    [bS(n), cent{n}, rad(n)] = fun_findSpot(J);
end

TT = table(ffnL, bS, cent, rad);
fn_ST = ['SpotTable_', ImgFolder, '.mat'];
save(fn_ST, 'TT');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function    [cent, rad] = fun_findFitCircle(pp)
%     warning('off');
%     pp = fliplr(pp);
%     cent  = mean(pp);
%     pgon = polyshape(pp);
%     rad = sqrt(area(pgon)/pi);
% end
