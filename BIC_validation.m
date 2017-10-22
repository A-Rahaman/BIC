function validity = BIC_validation(simSub,simCmp)
%disp("Validation Started\n");
global tol;
global BicId;
global BicList;
temp = 0;
% Checking overlap with old clusters
    for cl =1:BicId-1
    overlapped_sub = length(intersect(BicList{cl,1},simSub));
    allowed_sub_overlap = (tol/100) * length(BicList{cl,1});
    overlapped_cmp = length(intersect(BicList{cl,2},simCmp));
    allowed_cmp_overlap = (tol/100) * length(BicList{cl,2}); 
    
    if (overlapped_sub <= allowed_sub_overlap || overlapped_cmp <= allowed_cmp_overlap)
        temp = temp +1;
    end
    end
    % New cluster doesn't overlap with any of older
    if temp == (BicId-1)
       validity = 1;
    else
        validity = 0;
    end
end