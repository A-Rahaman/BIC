clear
clc
load lwdings.mat;
%lwdings = 
%spm_read_vols(spm_vol('T:\mialab\users\mrahaman\example_sMRI_from_ICA\GIG_cobre_sub01_timecourses_ica_s1_.nii'));
sz = size(lwdings);
len = sz(1);

global tol;
global minSub;
global minCmp;
% User given threshold for cluster size
minSub = input('What is the cluster size? MinimumSubs:\n');
minCmp = input('What is the cluster size? MinimumComps:\n');
tol = input('What is the allowable percentage of overlap:\n');
global BicId;
BicId = 1;
global BicList;
BicList = {};
global rsampled_BICList;
rsampled_BICList = {};

col_avg = zeros(sz(1));
SetofCmps = [];
for i =1:sz(2)
col_avg(i) = sum(lwdings(:,i))/sz(1);
hXprssedSubs = find(lwdings(:,i)>=col_avg(i));
%components {i,1} = i;
if(length(hXprssedSubs)>=minSub)
SetofCmps(end+1) = i;    
components{i,1}= hXprssedSubs;
end
end

%% Search_BIC Calling
simC = [];
simS = [];
if(length(SetofCmps)>=minCmp)
Search_BIC(SetofCmps,components,simC, simS,1);
original_BicList = BicList;
fprintf("Main run is completed\n");
end

%% Stability Check
%{
numofSUBs=round(0.75*sz(1));
numofCMPs=round(0.75*sz(2));
st = BIC_stability(numofSUBs, numofCMPs, original_BicList,lwdings);
fprintf("Stability: %f\n", st);
%}
%%