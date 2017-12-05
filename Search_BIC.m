function Bic = Search_BIC(CMP_idx,components,simC,simS,start)

% Search biclusters by building different subsets of components
% Input:
% run = a flag that indicates whether it is first run (run = 0) or not (run =1) 
% For the first run, Ovrlap_filter is > 80% for second it is > 90%
% CMP_idx = Set of components. For example [1 3 5 8 9 6] 
% components = The cell array of components where each component is a set of subjects
% simC = set of components in a BIC
% simS = set of subjects in a BIC
% start = A tracker of the component that being used to create the subset 
% by munna Dated: 4/Aug/2017

%% Write bicluster

global BicList;
global BicId;
global minSub;
global minCmp;
if(length(simS)>=minSub && length(simC)>=minCmp)
    
if(BicId == 1) % Checking for first cluster
BicList(BicId).subs = simS;
BicList(BicId).comps = simC;
BicList(BicId).freq = 1;
%fprintf("biCluster# %u is done\n",BicId);      
BicId = BicId+1;
else
    v = BIC_validation(simS,simC);
    if(v == 1)
     %fprintf("Adding biCluster# %u to the list....\n",BicId);      
     BicList(BicId).subs = simS;
     BicList(BicId).comps = simC;
     BicList(BicId).freq = 1;
     BicId = BicId+1;
    end
end
end
%% Generate Subsets of Components
for i = start:length(CMP_idx)
    if(components{CMP_idx(i),1}~= 0)
    if(isempty(simC))
        % Handle the base case!! Do something at first iteration of simCmp 
        comm = [];
        %fprintf("ENTERED IN fOR LOOP\n",i);
        simC(end+1)= CMP_idx(i);
        comm = union(comm,components{simC(end),1});
        simC(end) = [];
    else
        comm = components{simC(1),1};
        for j = 1:length(simC)
        comm = intersect(comm,components{simC(j),1});
        %fprintf("Secondary Iteration\n");
        end
    end
    
    simS = intersect(comm,components{CMP_idx(i),1});
    if(length(simS)>=minSub)
        %fprintf("Enough Subjects\n");
        simC(end+1)= CMP_idx(i);
        %fprintf("Enough components %u\n",length(simC));
        Search_BIC(CMP_idx,components,simC,simS,i+1);
        simC(end) = [];
    end
    end
end
%% End of recursion
end