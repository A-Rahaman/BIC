function validity = BIC_validation(run, simSub,simCmp)
%disp("Validation Started\n");
global tol;
global BicId;
global BicList;
%temp = 0;
validity = 1;
% Checking overlap with old Biclusters
    %% For the first run
    if (run == 0)
    for cl =1:BicId-1
    overlapped_sub = length(intersect(BicList{cl,1},simSub));
    allowed_sub_overlap = (tol/100) * length(BicList{cl,1});
    overlapped_cmp = length(intersect(BicList{cl,2},simCmp));
    allowed_cmp_overlap = (tol/100) * length(BicList{cl,2}); 
    
    if (overlapped_sub <= allowed_sub_overlap || overlapped_cmp <= allowed_cmp_overlap)
        %temp = temp +1;
        validity = validity * 1;
    else
        validity = validity * 0;
        break;
    end
    end
    end
    %% From the second permuted run
    if(run == 1) 
    for cl =1:BicId-1
    overlapped_sub = length(intersect(BicList{cl,1},simSub));
    allowed_sub_overlap = (5/100) * length(BicList{cl,1});
    overlapped_cmp = length(intersect(BicList{cl,2},simCmp));
    allowed_cmp_overlap = (5/100) * length(BicList{cl,2}); 
    if (overlapped_sub >= allowed_sub_overlap && overlapped_cmp >= allowed_cmp_overlap)
        % iNCREASSE THE FREQUENCEY
        BicList(cl).frequency = BicList(cl).frequency +1;
        validity = validity * 0;
        break;
    else
        validity = validity * 1;
    end    
    end
    end
    %%
    % New bicluster shouldn't be overlapped significantly with olders
    %if temp == (BicId-1)
     %  validity = 1;
    %else
     %   validity = 0;
    %end
    end
