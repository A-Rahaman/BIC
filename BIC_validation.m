function validity = BIC_validation(simSub,simCmp)
%disp("Validation Started\n");
global tol;
global BicId;
global BicList;
validity = 1;

%% For the first run
    %if (run == 0)
    
    for cl =1:BicId-1
    overlapped_sub = length(intersect(BicList(cl).subs,simSub));
    %allowed_sub_overlap = (tol/100) * length(BicList(cl).subs);
    allowed_sub_overlap = (tol/100) * length(simSub);
    overlapped_cmp = length(intersect(BicList(cl).comps,simCmp));
    %allowed_cmp_overlap = (tol/100) * length(BicList(cl).comps);
    allowed_cmp_overlap = (tol/100) * length(simCmp);
    
    if (overlapped_sub <= allowed_sub_overlap || overlapped_cmp <= allowed_cmp_overlap)
        validity = validity * 1;
        
    else
        validity = validity * 0;
        break;
    end
    end
    %end
    %% From the second permuted run
    %{
    if(run == 1) 
    fprintf("Secondary Run\n");
    for cl =1:BicId-1
    overlapped_sub = length(intersect(BicList(cl).subs,simSub));
    %allowed_sub_overlap = (5/100) * length(BicList(cl).subs);
    Xpected_sub_overlap = (80/100) * length(simSub);
    overlapped_cmp = length(intersect(BicList(cl).comps,simCmp));
    %allowed_cmp_overlap = (5/100) * length(BicList(cl).comps);
    Xpected_cmp_overlap = (80/100) * length(simCmp); 
    
    if (overlapped_sub >= Xpected_sub_overlap && overlapped_cmp >= Xpected_cmp_overlap)
        % iNCREASSE THE FREQUENCEY
        BicList(cl).freq = BicList(cl).freq +1;
        validity = validity * 0;
        fprintf("Frequency increased to :%u\n",BicList(cl).freq);
        break;
    else
        validity = validity * 1;
        %fprintf("Unique\n");
    end    
    end
    end
    %}
   %
end
