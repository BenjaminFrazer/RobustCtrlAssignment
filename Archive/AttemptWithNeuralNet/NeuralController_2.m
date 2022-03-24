% Neural Network 
function [out] = NeuralController_2(input,Params)
%     Params.T1 = 0;
%     Params.T2 = 0.2;
%     Params.W1 =+1;
%     Params.W2 =-1;
%     Params.W3 =-1.219;%M2
%     Params.W4 =0.993;%M1
% 
%     input.LS =  1;
%     input.RS = 1;
%% calculate output
ML = (input.LS*Params.W1+input.RS*Params.W3+Params.W5*input.Theta)>Params.T1; %1
MR = (input.RS*Params.W4+input.LS*Params.W2+Params.W6*input.Theta)>Params.T2; %2

%%
out.ML = ML;
out.MR = MR;
end