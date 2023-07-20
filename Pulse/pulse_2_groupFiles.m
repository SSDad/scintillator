clearvars

bPlot_bg = 0;
bPlotS = 0;

pulse_0_params;
ImgPath = fullfile(MainPath, ImgFolder);

datafd = ['ProcImages'];
datafn = ['stat'];
dataPath = fullfile(ImgPath, datafd);
ffn = fullfile(dataPath, datafn);
load(ffn); 


nCL_1 = 4;  % number of CLuster
[tags_1, C_1] = kmeans(s', nCL_1);

% Background (lowest 30)
[~, ind_C] = sort(C_1);
ind_1 = tags_1==ind_C(1); 
FL_1 = ImgFileList(ind_1);
s_1 = s(ind_1);

[~, jnd] = sort(s_1);
nbg = min(numel(jnd), 30);
FL_bg = FL_1(jnd(1:nbg));

if bPlot_bg
    ClusterPlot(s, tags_1, nCL_1, 1);
    ViewImages(2, ImgPath, FL_1, RowCut);
end

jndS = tags_1~= ind_C(1);
FL_S = ImgFileList(jndS);
% jndS = tags_1==ind_C(3);
% FL_S = [FL_S; ImgFileList(jndS)];

dataPath = fullfile(ImgPath, datafd);
datafn = ['FileList'];
ffn = fullfile(dataPath, datafn);
save(ffn, 'FL*')

if bPlotS
    ViewImages(11, ImgPath, FL_S, RowCut);
end


% %% lowest 
% s2 = s(jnd);
% 
% nCL_2 = 4;
% [tags_2, C_2] = kmeans(s2', nCL_2);
% 
% [~, ind_2] = sort(C_2);
% FL_2 = FL_1(tags_2==ind_2(1));
% 
% if bPlot_2
%     ClusterPlot(s2, tags_2, nCL_2, 3);
%     ViewImages(4, SMImgPath, FL_2, RowCut);
% end

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
