clear; clc;
%load /export/mialab/users/mrahaman/biclustering/BIC/Data/3dataset.mat; % Loadings
load C:/MATLAB_2017a/Codes/biClustering/BIC/BIC/Data/3dataset.mat; % Loadings
load C:\MATLAB_2017a\Codes\biClustering\BIC\BIC\Results\StableBics_30.mat %.mat
load C:\MATLAB_2017a\Codes\biClustering\BIC\BIC\Data\DataInfo.mat
load C:\MATLAB_2017a\Codes\biClustering\BIC\BIC\Data\PANSS_sitecorrected.mat
load C:\MATLAB_2017a\Codes\biClustering\BIC\BIC\Results\Correlations.mat


% We can Plot Subs Vs Mean Loading Paramters
A = {};
%for i = 1: length(StableBics)
 %   mLP =[];
  %  p = lwdings(StableBics(i).subs,StableBics(i).comps);
    %for j = 1:length(StableBics(i).subs)
    %We can Plot Subs Vs Mean Loading Paramters
    % mean(p(j,:))
    %mLP(j) = mean(p(j,:));
    %end
    
    %A{i} = [PANS_pos(StableBics(i).subs) PANS_neg(StableBics(i).subs) PANS_gen(StableBics(i).subs)];
    %A{i} = [StableBics(i).subs PANS_neg(StableBics(i).subs)];
    %A{i} = [StableBics(i).subs PANS_gen(StableBics(i).subs)];
    %A{i} = [StableBics(i).subs];
    %A{i} = [StableBics(i).subs DataInfo(StableBics(i).subs,2)];
%end

%coRRpos = corr(mLP',PANS_pos(StableBics(i).subs));
%h =figure;
%imagesc(coRRpos);colorbar;
%title('Corr')
%xlabel('pos')
%ylable('mLP')


for u = 1:length(Correlations)
    A{u} = [Correlations(u).Positive Correlations(u).Negative Correlations(u).General]; 
end

newA = vertcat(A{:});                   %Concatenating all matrices inside A vertically
%newB = vercat()

%newA = [(Correlations.Positive)' (Correlations.Negative)' (Correlations.General)'];
numcolors = numel(A);                   %Number of matrices equals number of colors
colourRGB = jet(numcolors);             %Generating colours to be used using jet colormap
colourtimes = cellfun(@(x) size(x,1),A);%Determining num of times each colour will be used
colourind = zeros(size(newA,1),1);      %Zero matrix with length equals num of points
colourind([1 cumsum(colourtimes(1:end-1))+1]) = 1;
colourind = cumsum(colourind);          %Linear indices of colours for newA

%scatter3(newA(:,1), t1(:,1), t1(:,1), [] , colourRGB(colourind,:),'filled');

%scatter(newA(:,1), newA(:,2),100,colourRGB(colourind,:),'filled');
%However if you want to specify the size of the circles as well as in your
%original question which you mistakenly wrote for color, use the following line instead:
scatter3(newA(:,1), newA(:,2), newA(:,3), 100 , colourRGB(colourind,:),'filled');
grid on;
view(3);                                %view in 3d plane 
colormap(colourRGB);                    %using the custom colormap of the colors we used
%Adjusting the position of the colorbar ticks
caxis([1 numcolors]);
%axis = [0 5 1 382];
colorbar('YTick',[1+0.5*(numcolors-1)/numcolors:(numcolors-1)/numcolors:numcolors],...
    'YTickLabel', num2str([1:numcolors]'), 'YLim', [1 numcolors]);
title('Correlations');
xlabel('mLP vs PANSS-Positive') % x-axis label
ylabel('mLP vs PANSS-Negative') % y-axis label
zlabel('mLP vs PANSS-General')

