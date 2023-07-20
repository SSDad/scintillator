clearvars

fd1 = 'Q:\Goddu\ForArashYao\Rang20cmand15cmPlans';

fd2 = 'Rang15cmGrid1mm';
fn_R15 = 'R15_avgHProfile.csv';

% fd2 = 'Rang20cmGrid1mm';
% fn_R15 = 'R20_avgHProfile.csv';

%% params
bPlot = 1;

RowCut = 4;

SGOrder = 5;
SGLength = 31;

rAvg = 100;
cAvg = 15;
rad = 20;

dd = 0.1554;
%% read dose
FL = dir(fullfile(fd1, fd2, 'RD*.dcm'));
ffn = fullfile(FL(1).folder, FL(1).name);

[DS, dsInfo] = fun_readDose(ffn);

Dose = squeeze(single(DS));

%% view dose
[M, N, P] = size(Dose);

yp = round(M/4);
xp =  round(N/2);
zp = round(P/2);

I{1} = Dose(:, :, zp);
I{2} = squeeze(Dose(:, xp, :));
I{3} = squeeze(Dose(yp, :, :));

xLB = 'xzz';
yLB = 'yyx';
TT{1} = ['z = ', num2str(zp)];
TT{2} = ['x = ', num2str(xp)];
TT{3} = ['y = ', num2str(yp)];
figure(1), clf
for n = 1:3
    subplot(2, 2, n)
    imshow(I{n}, []);
    axis on
    xlabel(xLB(n));
    ylabel(yLB(n));
    title(TT{n});
end

%% dose profile
I = sum(Dose, 3);
figure(2), clf
imshow(I, [])

IS = I';
IS = IS(RowCut+1:end-RowCut, :);

[rMax, cMax] = fun_findBeamPeak(IS, bPlot); 

    rAvgProf = mean(IS(rMax-rAvg:rMax+rAvg, :));
    rSG = sgolayfilt(double(rAvgProf), SGOrder, SGLength);
    rSGN = (rSG-min(rSG))/range(rSG);

xx1  = (0:length(rSG)-1)*dsInfo.dy;

fn = 'Plan.csv';
fd = fullfile(fd1, fd2, 'Profile');
if ~exist(fd, 'dir')
    mkdir(fd);
end
ffn = fullfile(fd, fn);
writematrix([xx1' rSGN'], ffn);

xq = 0:dd:xx1(end);
vq = interp1(xx1, rSGN, xq);

fn = 'PlanInterp.csv';
ffn = fullfile(fd, fn);
writematrix([xq' vq'], ffn);

%% scintillator
csvdata = csvread(fn_R15);
plan = csvdata(:, 3);
xx2 = (0:size(csvdata, 1)-1)*dd;

fn = 'Scintillator.csv';
ffn = fullfile(fd, fn);
writematrix([xx2' plan], ffn);

%%
if bPlot
    figure(3), clf
%     plot(rAvgProf, '-.'); hold on
%     subplot(211)
    plot(xq, vq, 'bo', 'LineWidth', 2, 'Color', 'b'); hold on
    
%     axis tight

%     subplot(212)
    plot(xx2, plan, 'rd', 'LineWidth', 2, 'Color', 'r'); hold on
    axis tight
    
    legend({'Plan', 'Sintillator'})

end
