clearvars

bPlotS = 0;
pulse_0_params;
ImgPath = fullfile(MainPath, ImgFolder);

datafd = ['ProcImages'];
datafn = ['FileList'];
dataPath = fullfile(ImgPath, datafd);
ffn = fullfile(dataPath, datafn);
load(ffn); 

% background
nbg = numel(FL_bg);
parfor n = 1:nbg
    ffn = fullfile(FL_bg(n).folder, FL_bg(n).name);
    I = imread(ffn);
    IIB(:,:,n) = I(1+RowCut:end-RowCut, :);
end
Ibg = uint8(mean(IIB, 3)); % average
fn_bg = 'AvgBG.tif';
ffn_bg = fullfile(dataPath, fn_bg);
imwrite(Ibg, ffn_bg);

% signal
ns = numel(FL_S);

for n = 1:ns
    fn_S{n} = FL_S(n).name;
    ffn_S{n} = fullfile(FL_S(n).folder, fn_S{n});
    ffn_W{n} = fullfile(dataPath, fn_S{n});
end

tic
parfor n = 1:ns
    if mod(n, 10) == 0
        disp(['Writing Image ', num2str(n), '/', num2str(ns)]);
    end

    I = imread(ffn_S{n});
    I = I(1+RowCut:end-RowCut, :);
    I = I - Ibg;
    imwrite(I, ffn_W{n});
end
toc

% view images
if bPlotS
    hF = figure(1); clf
    hA = axes('Parent', hF);
    hA.Title.String = 'File Name';
    for n = 1:length(ffn_W)
        I = imread(ffn_W{n});
        cla(hA)
        imshow(I, [], 'parent', hA);
        hA.Title.String = fn_S(n);
        hA.Title.Interpreter = 'none';
        pause(0.1)
    end
end
