tempcont = mamfis('Name',"AC controller");
%% tempratures 2 test
temp2test = [9;13.1;26.5;20];
%% inputs
tempcont = addInput(tempcont,[5,32],'Name',"temp");

tempcont = addMF(tempcont,"temp","trapmf", [4 5 12 14],'Name',"TooCold");
tempcont = addMF(tempcont,"temp","trapmf", [12 14 16 18],'Name',"Cold");
tempcont = addMF(tempcont,"temp","trapmf", [16 18 22 24],'Name',"Comfortable");
tempcont = addMF(tempcont,"temp","trapmf", [22 24 26 28],'Name',"Warm");
tempcont = addMF(tempcont,"temp","trapmf", [26 28 32 35],'Name',"Hot");

%% outputs
tempcont = addOutput(tempcont,[-20,20],'Name','power');

tempcont = addMF(tempcont,"power","trapmf", [-22 -20 -12 -8],'Name',"HighPowerCool");
tempcont = addMF(tempcont,"power","trapmf", [-12 -8 -6 -2],'Name',"LowPowerCool");
tempcont = addMF(tempcont,"power","trapmf", [-6 -2 2 6],'Name',"off");
tempcont = addMF(tempcont,"power","trapmf", [2 6 8 12],'Name',"LowPowerWarm");
tempcont = addMF(tempcont,"power","trapmf", [8 12 20 22],'Name',"HighPowerWarm");

%% Rules
tempcont = addRule(tempcont,"If temp is TooCold then power is HighPowerWarm");
tempcont = addRule(tempcont,"If temp is Cold then power is LowPowerWarm");
tempcont = addRule(tempcont,"If temp is Comfortable then power is off");
tempcont = addRule(tempcont,"If temp is Warm then power is LowPowerCool");
tempcont = addRule(tempcont,"If temp is Hot then power is HighPowerCool");

%% defuzzification
tempcont.DefuzzificationMethod = 'centroid';

%% Results
PowerOut = evalfis(tempcont,temp2test);
table(temp2test,PowerOut)
gensurf(tempcont)
tempcont.Rules
plotmf(tempcont,'input',1)
ruleview(tempcont)