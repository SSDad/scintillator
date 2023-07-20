clearvars

bPlot = 1;
pulse_0_params;
ImgPath = fullfile(MainPath, ImgFolder);
ImgFileList = dir(fullfile(ImgPath, '*.tif'));

% sort file name
FNL = {ImgFileList.name}';
for n = 1:numel(FNL)
    fn = FNL{n};
    k1 = strfind(fn, '_');
    k2 = strfind(fn, '.');
    fni(n) = str2double(fn(k1(end)+1:k2-1));
end

[~, ind] = sort(fni);
ImgFileList = ImgFileList(ind);

nFile = length(ImgFileList);
tic
parfor n = 1:nFile
    if mod(n, 10) == 0
        disp(['Read Image ', num2str(n), '/', num2str(nFile)]);
    end

    ffn = fullfile(ImgPath, ImgFileList(n).name);
    I = imread(ffn);
    I = I(1+RowCut:end-RowCut, :);
    s(n) = std(single(I), 0, 'all');

    [junk] = sort(I(:));
    s1 = sum(junk(end-9:end));
    s2 = sum(junk(1:10));
    snr(n) = (s1-s2)/s(n);
end
toc

datafd = ['ProcImages'];
datafn = ['stat'];
dataPath = fullfile(ImgPath, datafd);
if ~exist(dataPath, 'dir')
    mkdir(dataPath);
end
ffn = fullfile(dataPath, datafn);
save(ffn, 's', 'snr', 'Img*', '*Path'); 

if bPlot
    figure(1), clf
    subplot(211)
    plot(s, 'o')
    title('std')

    subplot(212)
    plot(snr, 'o')
    title('snr')
end