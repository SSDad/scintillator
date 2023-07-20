clearvars

bPlot_1 = 1;
bPlot_2 = 0;
bPlotS = 1;
RowCut = 4;

pulse_0_params;
ImgPath = fullfile(MainPath, ImgFolder);
datafd = ['ProcImages'];
datafn = ['stat'];
dataPath = fullfile(ImgPath, datafd);
ffn = fullfile(dataPath, datafn);
load(ffn)
% save(ffn, 's', 'snr', 'Img*', '*Path'); 


nCL_1 = 4;  % number of CLuster
[tags_1, C_1] = kmeans(s', nCL_1);

[~, ind_1] = sort(C_1);
jnd = tags_1==ind_1(1); % Background
FL_1 = ImgFileList(jnd);

if bPlot_1
    ClusterPlot(s, tags_1, nCL_1, 1);
%     ViewImages(2, SMImgPath, FL_1, RowCut);
end

jndS = tags_1==ind_1(4);
FLS = ImgFileList(jndS);
if bPlotS
    ViewImages(11, ImgPath, FLS, RowCut);
end




%% lowest 
s2 = s(jnd);

nCL_2 = 4;
[tags_2, C_2] = kmeans(s2', nCL_2);

[~, ind_2] = sort(C_2);
FL_2 = FL_1(tags_2==ind_2(1));

if bPlot_2
    ClusterPlot(s2, tags_2, nCL_2, 3);
    ViewImages(4, ImgPath, FL_2, RowCut);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ClusterPlot(s, tags, nCL, iFig)
    CLR = rand(nCL, 3);
    c = CLR(tags, :);
    xx = 1:length(s);
    figure(iFig), clf
    sc = scatter(xx, s, 36, c);
    sc.LineWidth = 1;
end

function ViewImages(iFig, SMImgPath, FL, RowCut)
    hF = figure(iFig); clf
    hA = axes('Parent', hF);
    hA.Title.String = 'File Name';
    for mm = 1:length(FL)
        ffn = fullfile(SMImgPath, FL(mm).name);
        I = imread(ffn);
        I = I(1+RowCut:end-RowCut, :);
        cla(hA)
        imshow(I, [], 'parent', hA);
        hA.Title.String = FL(mm).name;
        hA.Title.Interpreter = 'none';
        pause(0.1)
    end
end
