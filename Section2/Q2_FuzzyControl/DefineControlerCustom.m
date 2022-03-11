clear colisCont
close all
if ~exist("bias","var")
bias = 0;
end
    %%
colisCont = mamfis('Name',"Collision Aviodance");

%% inputs
colisCont = addInput(colisCont,[0,1.1],'Name',"distL");
colisCont = addInput(colisCont,[0,1.1],'Name',"distR");

colisCont = addMF(colisCont,"distL","trapmf", [-10 -10 0.25+bias 0.45+bias],'Name',"TooClose");
colisCont = addMF(colisCont,"distL","trapmf", [0.2+bias 0.4+bias 0.5+bias 0.7+bias],'Name',"Close");
colisCont = addMF(colisCont,"distL","trapmf", [0.5+bias 0.9+bias 1.1 2],'Name',"Near");

colisCont = addMF(colisCont,"distR","trapmf", [-10 -10 0.25 0.45],'Name',"TooClose");
colisCont = addMF(colisCont,"distR","trapmf", [0.2 0.4 0.5 0.7],'Name',"Close");
colisCont = addMF(colisCont,"distR","trapmf", [0.5 0.9 1.1 2],'Name',"Near");

%% outputs
colisCont = addOutput(colisCont,[-10,10],'Name','powerL');
colisCont = addOutput(colisCont,[-10,10],'Name','powerR');

colisCont = addMF(colisCont,"powerL","trimf", [-4 0 4],'Name',"Off");
colisCont = addMF(colisCont,"powerR","trimf", [-4 0 4],'Name',"Off");

colisCont = addMF(colisCont,"powerL","trapmf", [-20 -10 -5 0],'Name',"Rev");
colisCont = addMF(colisCont,"powerL","trapmf", [0 5 10 20],'Name',"Fwd");

colisCont = addMF(colisCont,"powerR","trapmf", [-20 -10 -5 0],'Name',"Rev");
colisCont = addMF(colisCont,"powerR","trapmf", [0 5 10 20],'Name',"Fwd");

%% Rules
colisCont = addRule(colisCont,"distL==Near & distR==Near => powerL=Fwd, powerR=Fwd (1)");
colisCont = addRule(colisCont,"distL==Near & distR==Close => powerL=Off, powerR=Fwd (1)");
colisCont = addRule(colisCont,"distL==Near & distR==TooClose => powerL=Rev, powerR=Fwd (1)");
colisCont = addRule(colisCont,"distL==Close & distR==Near => powerL=Fwd, powerR=Off (1)");
% colisCont = addRule(colisCont,"distL==Close & distR==Close => powerL=Rev, powerR=Rev (1)"); % causing oscilation??
colisCont = addRule(colisCont,"distL==Close & distR==TooClose => powerL=Rev, powerR=Fwd (1)");
colisCont = addRule(colisCont,"distL==TooClose & distR==Near => powerL=Fwd, powerR=Rev (1)");
colisCont = addRule(colisCont,"distL==TooClose & distR==Close => powerL=Fwd, powerR=Rev (1)");
colisCont = addRule(colisCont,"distL==TooClose & distR==TooClose => powerL=Rev, powerR=Rev (1)");

save("colisCont_custom.mat","colisCont")

%% defuzzification
colisCont.DefuzzificationMethod = 'centroid';

%% Results
% PowerOut = evalfis(colisCont,temp2test);
% table(temp2test,PowerOut)
% opt = gensurfOptions('OutputIndex',2);
%  gensurf(colisCont,opt)
% colisCont.Rules
% %plotmf(colisCont,'input',1)
ruleview(colisCont)
