
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
% if(length(SetofCmps)>=minCmp)
% Search_BIC(SetofCmps,components,simC, simS,1);

SbmComps = [1 5 17 30 13 16 7 28 14]; % Big negative components from Navin
permutations = perms(SbmComps);
run = 0;
%length(permutaions) 
for perm = 1:2 
if(length(SbmComps)>=minCmp)
Search_BIC(run,permutations(perm,:),components,simC, simS,1); % Should send BicID
run = 1;
end
fprintf("Secondary Run\n");
end
fprintf("Initial iteration has been completed\n");

 %% Stability Check
% numofSUBs=round(0.75*sz(1)); % From the paper the ratio is 0.62 (62% atleast)
% numofCMPs=round(0.75*sz(2));
% st = BIC_stability(numofSUBs, numofCMPs, original_BicList,lwdings);
% fprintf("Stability: %f\n", st);

%%