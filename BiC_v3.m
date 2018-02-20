clear
clc
%load T:\mialab\users\mrahaman\biclustering\BIC\Data\lwdings.mat;
%load /export/mialab/users/mrahaman/biclustering/BIC/Data/3dataset.mat; % Loadings
load C:\MATLAB_2017a\Codes\biClustering\BIC\BIC\Data\3dataset.mat
load C:\MATLAB_2017a\Codes\biClustering\BIC\BIC\Data\PANSS_sitecorrected.mat
%load /export/mialab/users/mrahaman/biclustering/BIC/Data/PANSS_sitecorrected.mat; % Load PANSS
sz = size(lwdings);
len = sz(1);

global tol;
tol = 20;
global minSub;
minSub = 30;
global minCmp;
minCmp = 3;
% User given threshold for cluster size
% minSub = input('Minimum number of Subjects in a Bicluster:\n');
% minCmp = input('Minimum number of Components in a Bicluster:\n');
% tol = input('What is the allowable percentage of overlap:\n');

%% Create Components
global BicId;
BicId = 1;
initBicList();
global BicList;
initListofBics();
global ListofBics; 

components = {};
col_avg = [];
SetofCmps = [];
for i =1:sz(2)

%Method 2 --
SortedComp = [];
ProcessingComp =[];
hXprssedSubs = [];
SortedComp = sort(lwdings(:,i));
Percentile = (length(SortedComp)*25)/100;
ProcessingComp = lwdings(:,i);
jj =length(SortedComp);

for ii = 1:Percentile
    hXprssedSubs(end+1) = find(ProcessingComp == SortedComp(ii));
    hXprssedSubs(end+1) = find(ProcessingComp == SortedComp(jj));
    jj= jj-1;
end
%--

% --Method 1
%col_avg(i) = mean(abs(lwdings(:,i))); % Sign doesn't matter, Lwding values are important
%hXprssedSubs = find(abs(lwdings(:,i))>=col_avg(i));
%----
if(length(hXprssedSubs)>=minSub)
SetofCmps(end+1) = i;    
components{i,1}= hXprssedSubs;
end
end

% Adding Symptom Socrs as Components

L31 = PANS_pos/mean(PANS_pos);
lwdings(:,31) = L31;
c31 = find(L31>=mean(L31));
L32 = PANS_neg/mean(PANS_neg);
lwdings(:,32) = L32;
c32 = find(L32>=mean(L32));
L33 = PANS_gen/mean(PANS_gen);
lwdings(:,33) = L33;
c33 = find(L33>=mean(L33));


components{i+1,1} = c31;
components{i+2,1} = c32;
components{i+3,1} = c33;

% components{i+1,1} = find(PANS_pos>=mean(PANS_pos));
% components{i+2,1} = find(PANS_neg>=mean(PANS_neg));
% components{i+3,1} = find(PANS_gen>=mean(PANS_gen));

%% Searching Biclusters
simC = [];
simS = [];

%SbmComps = [1 5 17 30 13 16 7 28 14]; % Big negative components from Navin
ComPlusSm = [1 5 17 30 13 16 7 28 14 31 32 33];
%permutations = perms(ComPlusSm);

%length(permutaions)

% Initial Run 
if(length(ComPlusSm)>=minCmp)
%Search_BIC(permutations(1,:),components,simC, simS,1);
Search_BIC(ComPlusSm,components,simC, simS,1);
ListofBics = BicList;
initBicList();

BicId = 1;
fprintf("Permuted Run 1 Completed!: \n");
end
%%

% Secondary Run
for perm = 2:length(permutations) 
if(length(SbmComps)>=minCmp)
fprintf("Permutation %u running... \n", perm);
Search_BIC(permutations(perm,:),components,simC, simS,1); 
end

% Stability Checking 
len = length(ListofBics);
for b = 1: length(BicList)
for j = 1:len % Becuase We don't want to compare with new added Bics 
    overlapped_sub = length(intersect(BicList(b).subs,ListofBics(j).subs));
    Xpected_sub_overlap = (80/100) * max(length(ListofBics(j).subs),length(BicList(b).subs));
    overlapped_cmp = length(intersect(BicList(b).comps,ListofBics(j).comps));
    Xpected_cmp_overlap = (80/100) * max(length(ListofBics(j).comps),length(BicList(b).comps)); 
    if (overlapped_sub >= Xpected_sub_overlap && overlapped_cmp >= Xpected_cmp_overlap)
    ListofBics(j).freq  = ListofBics(j).freq +1;
    BicList(b).freq = -1;
    end
end
if(BicList(b).freq ~= -1)
ListofBics(length(ListofBics)+1) = BicList(b); 
end
end
BicId = 1;
initBicList();
end

fprintf("All the biclusters has been enlisted\n");
%% Get high frequency biclusters 
%{
StableBics = struct('subs',[],'comps',[],'freq',0,'CorrWithAge',0,'CorrWithPositive',0,'CorrWithNegative',0,'CorrWithGeneral',0); 
totalRuns = length(permutations); % Total Permutations 
num = 1;
for i = 1:length(ListofBics)
if(ListofBics(i).freq >= (0.30 * totalRuns))
StableBics(num).subs = ListofBics(i).subs;
StableBics(num).comps = ListofBics(i).comps;
StableBics(num).freq = ListofBics(i).freq;
num = num+1;
end
end
%}


 %% Stability Check
% numofSUBs=round(0.75*sz(1)); % From the paper the ratio is 0.62 (62% atleast)
% numofCMPs=round(0.75*sz(2));
% st = BIC_stability(numofSUBs, numofCMPs, original_BicList,lwdings);
% fprintf("Stability: %f\n", st);

%% Linear Regression
load C:\MATLAB_2017a\Codes\biClustering\BIC\BIC\Data\lwdingsWith33Comps.mat %Loadings
load C:\MATLAB_2017a\Codes\biClustering\BIC\BIC\Data\SMCbiclusters_s30_c3.mat % Biclusters 
load C:\MATLAB_2017a\Codes\biClustering\BIC\BIC\Results\NormalizedSym.mat % L31,L32,L33

%rsquareValues = struct('Positive',0,'Negative',0,'General',0);
Syms = lwdings(:,31:33);
rsValues = []; 
%zeros(length(ListofBics));

for i = 1:length(ListofBics)
BiCs = lwdings(ListofBics(i).subs,ListofBics(i).comps);
mdl = fitlm(BiCs,Syms(ListofBics(i).subs));
rsValues(i) = mdl.Rsquared.Ordinary;
% %Positive
% mdl = fitlm(BiCs,L31(ListofBics(i).subs));
% rsquareValues(i).Positive = mdl.Rsquared.Ordinary;
% % %Negative
% mdlNeg = fitlm(BiCs,L32(ListofBics(i).subs));
% rsquareValues(i).Negative = mdlNeg.Rsquared.Ordinary;
%General
% mdlGen = fitlm(BiCs,L33(ListofBics(i).subs));
% rsquareValues(i).General = mdlGen.Rsquared.Ordinary;
end
%%