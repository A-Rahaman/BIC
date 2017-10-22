function avg_st = BIC_stability(numofSUBs, numofCMPs,original_BicList,lwdings)
sz = size(lwdings);
global minSub;
global minCmp;
global BicList;
global rsampled_BICList;
global BicId;
Ijacc = [];

% Stability Check started
for i = 1:10
%{
    numofSUBs=0;
    numofCMPs=0;
    while(1)
    numofSUBs = randperm(sz(1),1);
    numofCMPs = randperm(sz(2),1);
    if(numofSUBs>=minSub && numofSUBs<= sz(1) && numofCMPs>=minCmp && numofCMPs<=sz(2))
        break;
    end
    end
    %}
    % resampling
    resample{i,1} = randperm(sz(1),numofSUBs);
    resample{i,2} = randperm(sz(2),numofCMPs);
    
    %% Create Components
    comps{length(resample{i,2}),1} = zeros(length(resample{i,2}),1);  %Components Initialization
    CMP_idx = [];
    for j = 1:length(resample{i,2})
        matval = nan(1,sz(1));
        total = 0;
        for k = 1: length(resample{i,1})
            matval(1,resample{i,1}(k)) = lwdings(resample{i,1}(k),resample{i,2}(j)); 
            total = total + lwdings(resample{i,1}(k),resample{i,2}(j)); 
        end
        mean = total/length(resample{i,1});
        ck = find(matval>=mean);
        if(length(ck)>=minSub) % Filter bad components
            %Since we will be doing intersection components with less than 
            %threhold number of subjects is not gonna change the results.
            % So we aren't including them
        CMP_idx(end+1) = resample{i,2}(j);    
        comps{resample{i,2}(j),1} = ck;
        end
    end
    %% Looking for BICs resampled matrix 
    simCM = [];
    simSB = [];
    BicList = {};
    BicId = 1;
    if(length(comps)>=minCmp)
    Search_BIC(CMP_idx,comps,simCM, simSB,1); % Call with resampled components
    end 
    rsampled_BICList{i} = BicList; 
      
    %% Similarity Check with Jaccard Index
        
    bicSub = []; 
    bicComp = [];
    Jacc_cmp = [];
    Jacc_sub = [];
    for l = 1:length(BicList )
        maxJacc_C = 0;
        sJacc_C = [];
        maxJacc_sub = 0;
        sJacc_sub = [];
        for m = 1:length(original_BicList)
            ps = length(intersect(original_BicList{m,1},BicList{l,1}));
            sJacc_sub(end+1) = ps/(length(original_BicList{m,1})+length(BicList{l,1})-ps);
            pc = length(intersect(original_BicList{m,2},BicList{l,2}));
            sJacc_C(end+1) = pc/(length(original_BicList{m,2})+length(BicList{l,2})-pc);
        end
        maxJacc_C = max(sJacc_C);
        %maxJacc_C
        maxJacc_sub = max(sJacc_sub);
        %maxJacc_sub
        bicSub(end+1) = length(BicList{l,1});
        bicComp(end+1) = length(BicList{l,2});
        Jacc_cmp(end+1) = bicComp(end)*maxJacc_C;
        Jacc_sub(end+1) = bicSub(end)*maxJacc_sub;
    end
    
    up = (sum(Jacc_sub))+(sum(Jacc_cmp));
    down = (sum(bicSub))+(sum(bicComp));
    Ijacc(end+1)= up/down;
    fprintf("Ijacc: %f\n",Ijacc(end));
end 
avg_st = sum(Ijacc)/length(Ijacc);
end