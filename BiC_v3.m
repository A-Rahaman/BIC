
clear
clc
%load T:\mialab\users\mrahaman\biclustering\BIC\Data\lwdings.mat;
load /export/mialab/users/mrahaman/biclustering/BIC/Data/3dataset.mat;
%lwdings = 
%spm_read_vols(spm_vol('T:\mialab\users\mrahaman\example_sMRI_from_ICA\GIG_cobre_sub01_timecourses_ica_s1_.nii'));
sz = size(lwdings);
len = sz(1);

global tol;
global minSub;
global minCmp;
% User given threshold for cluster size
minSub = input('Minimum number of Subjects in a Bicluster:\n');
minCmp = input('Minimum number of Components in a Bicluster:\n');
tol = input('What is the allowable percentage of overlap:\n');

%% Create Components
global BicId;
BicId = 1;
initBicList();
global BicList;
initListofBics();
global ListofBics; 

%global rsampled_BICList;
%rsampled_BICList = {};

col_avg = zeros(sz(1));
SetofCmps = [];
for i =1:sz(2)
col_avg(i) = sum(lwdings(:,i))/sz(1);
hXprssedSubs = find(lwdings(:,i)>=col_avg(i));
if(length(hXprssedSubs)>=minSub)
SetofCmps(end+1) = i;    
components{i,1}= hXprssedSubs;
end
end

%% Searching Biclusters
simC = [];
simS = [];

SbmComps = [1 5 17 30 13 16 7 28 14]; % Big negative components from Navin
permutations = perms(SbmComps);
%length(permutaions)

% Initial Run 
if(length(SbmComps)>=minCmp)
Search_BIC(permutations(1,:),components,simC, simS,1);
ListofBics = BicList;
initBicList();
BicId = 1;
end

% Secondary Run
for perm = 2:2 
if(length(SbmComps)>=minCmp)
Search_BIC(permutations(perm,:),components,simC, simS,1); 
end

% Stability Checking 
len = length(ListofBics);
for b = 1: length(BicList)
for j = 1:len % Becuase We don't wan to compare with new added Bics 
    overlapped_sub = length(intersect(BicList(b).subs,ListofBics(j).subs));
    Xpected_sub_overlap = (80/100) * length(ListofBics(j).subs);
    overlapped_cmp = length(intersect(BicList(b).comps,ListofBics(j).comps));
    Xpected_cmp_overlap = (80/100) * length(ListofBics(j).comps); 
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
%fprintf("Initial iteration has been completed\n");

 %% Stability Check
% numofSUBs=round(0.75*sz(1)); % From the paper the ratio is 0.62 (62% atleast)
% numofCMPs=round(0.75*sz(2));
% st = BIC_stability(numofSUBs, numofCMPs, original_BicList,lwdings);
% fprintf("Stability: %f\n", st);

%%