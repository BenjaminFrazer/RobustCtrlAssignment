clc
addpath("\..\")
load('tipper.mat')
tipper = readfis('tipper'); % create a variable name and assign your fis file to it
tableHeadings = ["Service","Food","CalculatedTip"];
tableTypes = ["uint8","uint8","double"];
tab = table('size',[3,length(tableHeadings)],'VariableNames',tableHeadings,'VariableTypes',tableTypes);

tab.Service = [5,7,10]';
tab.Food = [5,8,2]';

%% centroid Defuzzification
tipper.DefuzzificationMethod = "centroid";
tabCentroid = tab;
for i = 1:height(tabCentroid)
   thisInput = [tabCentroid.Service(i),tabCentroid.Food(i)];
   tabCentroid.CalculatedTip(i) = evalfis(tipper, thisInput);% depending on MATLAB version
end
fprintf("%s Defuzzification Results \n",tipper.DefuzzificationMethod)
disp(tabCentroid)

%% Mean of Maximum Defuzzification
tipper.DefuzzificationMethod = "mom";
tabMeanOfMax = tab;
for i = 1:height(tabMeanOfMax)
   thisInput = [tabMeanOfMax.Service(i),tabMeanOfMax.Food(i)];
   tabMeanOfMax.CalculatedTip(i) = evalfis(tipper, thisInput);% depending on MATLAB version
end
fprintf("%s Defuzzification Results \n",tipper.DefuzzificationMethod)
disp(tabMeanOfMax)

%% Bisector Defuzzification
tipper.DefuzzificationMethod = "bisector";
tabBisector = tab;
for i = 1:height(tabBisector)
   thisInput = [tabBisector.Service(i),tabBisector.Food(i)];
   tabBisector.CalculatedTip(i) = evalfis(tipper, thisInput);% depending on MATLAB version
end
fprintf("%s Defuzzification Results \n",tipper.DefuzzificationMethod)
disp(tabBisector)