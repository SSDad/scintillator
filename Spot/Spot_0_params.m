% RowCut = 20;
% ColCut = 0;
% NumSpot = 81;
% XL = 80;
% YL = 80;
% 
% %% samples
% MainPath = 'Q:\Goddu\ForArashYao\For ZhenJi\NewData_02242023';
% ImgFolder = 'R10_9spots_3cm_spce2';
% 
% MainPath = 'Q:\Goddu\ForArashYao\For ZhenJi';
% ImgFolder = 'FullEn_9x9_spots_1cmSpace';
% 
% MainPath = 'Q:\Goddu\ForArashYao\For ZhenJi\Spot';
% ImgFolder = '81spots_9x9_1cmSpacing_set3';


%% 
RowCut = 20;
ColCut = 0;
NumSpot = 49;
XL = 60;
YL = 60;

MainPath = 'Q:\Jerry_Liu\Spots\R32_no_mirror';
ImgFolder = 's1 - Copy';

%%
ProcessedDataPath = fullfile(MainPath, ImgFolder, 'ProcessedData');
if ~exist(ProcessedDataPath, 'dir')
    mkdir(ProcessedDataPath);
end
fn_ST = ['SpotTable.mat'];
ffn_ST = fullfile(ProcessedDataPath, fn_ST);

fn_SLP = ['SpotLocationPlot.png'];
ffn_SLP = fullfile(ProcessedDataPath, fn_SLP);


OverlayPath = fullfile(MainPath, ImgFolder, 'SpotOverlay');
if ~exist(OverlayPath, 'dir')
    mkdir(OverlayPath);
end

SpotPath = fullfile(MainPath, ImgFolder, 'Spot');
if ~exist(SpotPath, 'dir')
    mkdir(SpotPath);
end
