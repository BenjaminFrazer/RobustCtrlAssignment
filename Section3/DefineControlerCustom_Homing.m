clear colisCont
close all

bias = 0.02;

    %%
colisCont = mamfis('Name',"Collision Aviodance");

%% inputs
colisCont = addInput(colisCont,[0,1.1],'Name',"distL");
colisCont = addInput(colisCont,[0,1.1],'Name',"distR");
colisCont = addInput(colisCont,[-pi,pi],'Name',"angle");

colisCont = addMF(colisCont,"distL","trapmf", [-10 -10 0.15 0.6+bias],'Name',"TooClose");
% colisCont = addMF(colisCont,"distL","trapmf", [0.05 0.2+bias 0.5+bias 0.7+bias],'Name',"Close");
colisCont = addMF(colisCont,"distL","trapmf", [0.5+bias 0.9 1.1 2],'Name',"Far");
colisCont = addMF(colisCont,"distL","trapmf", [0.15+bias 0.5+bias 0.7+bias 0.9],'Name',"Near");

colisCont = addMF(colisCont,"distR","trapmf", [-10 -10 0.15 0.6],'Name',"TooClose");
% colisCont = addMF(colisCont,"distR","trapmf", [0.05 0.2 0.5 0.7],'Name',"Close");
colisCont = addMF(colisCont,"distR","trapmf", [0.5 0.9 1.1 2],'Name',"Far");
colisCont = addMF(colisCont,"distR","trapmf", [0.15 0.5 0.7 0.9],'Name',"Near");

colisCont = addMF(colisCont,"angle","trapmf", [-2*pi -pi -pi/4 -pi/32],'Name',"TargetLeft");
colisCont = addMF(colisCont,"angle","trapmf", [pi/32 pi/4 pi 2*pi],'Name',"TargetRight");
colisCont = addMF(colisCont,"angle","trimf", [-pi/16 0 pi/16],'Name',"TargetCenter");


%% outputs
colisCont = addOutput(colisCont,[-10,10],'Name','powerL');
colisCont = addOutput(colisCont,[-10,10],'Name','powerR');

colisCont = addMF(colisCont,"powerL","trimf", [-4 0 4],'Name',"Off");
colisCont = addMF(colisCont,"powerR","trimf", [-4 0 4],'Name',"Off");

colisCont = addMF(colisCont,"powerL","trapmf", [-20 -10 -5 0],'Name',"Rev");
colisCont = addMF(colisCont,"powerL","trapmf", [5 10 10 20],'Name',"Fwd");
colisCont = addMF(colisCont,"powerL","trimf", [0 5 10],'Name',"FwdSlw");

colisCont = addMF(colisCont,"powerR","trapmf", [-20 -10 -5 0],'Name',"Rev");
colisCont = addMF(colisCont,"powerR","trapmf", [5 10 10 20],'Name',"Fwd");
colisCont = addMF(colisCont,"powerR","trimf", [0 5 10],'Name',"FwdSlw");

%% Rules
colisCont = addRule(colisCont,"distL==Near & distR==Far => powerL=Fwd, powerR=Off (1)");
colisCont = addRule(colisCont,"distL==Far & distR==Near => powerL=Off, powerR=Fwd (1)");

colisCont = addRule(colisCont,"distL==Near & distR==TooClose => powerL=Rev, powerR=Fwd (1)");
% colisCont = addRule(colisCont,"distL==Far & distR==TooClose => powerL=Rev, powerR=Fwd (1)");
colisCont = addRule(colisCont,"distL==TooClose & distR==Near => powerL=Fwd, powerR=Rev (1)");
% colisCont = addRule(colisCont,"distL==TooClose & distR==Far => powerL=Fwd, powerR=Rev (1)");

colisCont = addRule(colisCont,"distL==Far & distR==Far & angle==TargetRight => powerL=Fwd, powerR=Rev (1)");
colisCont = addRule(colisCont,"distL==Far & distR==Far & angle==TargetLeft => powerL=Rev, powerR=Fwd (1)");

colisCont = addRule(colisCont,"distL==Far & distR==Far & angle==TargetCenter=> powerL=Fwd, powerR=Fwd (1)");

save("colisCont_custom.mat","colisCont")

%% defuzzification
colisCont.DefuzzificationMethod = 'centroid';

%% Results
% PowerOut = evalfis(colisCont,temp2test);
% table(temp2test,PowerOut)
% opt = gensurfOptions('OutputIndex',2);
%  gensurf(colisCont,opt)
% colisCont.Rules
plotmf(colisCont,'input',1)
% ruleview(colisCont)
