%RUNMODEL - Main code to run robot model for ENG5009 class
%
%   NOTE: Students should only change the code between *---* markers
%
% Syntax: RunModel
%
% Inputs: none
% Outputs: none
% 
% Other m-files required: 
%   Sensor.m
%   WallGeneration.m
%   DynamicalModel.m
%   DrawRobot.m
%
% Author: Dr. Kevin Worrall
% Last revision: 06-01-2021

%% Preamble
close all;
clear all;
clc;
homeDir = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(homeDir,"\..\..\")))

% BF
stateEnum.vForward = 13;
stateEnum.vRotate = 18;
stateEnum.xPos = 19;
stateEnum.yPos = 20;
stateEnum.angHeading = 24;
Controler ="Neural_Final";%"Neural_Custom";% "Neural_Custom";
saveFigPathRel = "Figures";

switch Controler % load in controler 
    case "Neural_Base"
    NeuralParams.T1 = 0;
    NeuralParams.T2 = 0;
    NeuralParams.W1 =-1.4;
    NeuralParams.W2 =1.2;
    NeuralParams.W3 =1.25;
    NeuralParams.W4 =-1;

    case "Neural_Custom"
    Params.T1 = 0.2;%-C1
    Params.T2 = -0.1;%C2
    Params.W1 =-1;
    Params.W2 =1;
    Params.W3 =1.212;%M1
    Params.W4 =-0.595;%M2
    NeuralParams=Params;

    case "Neural_Final"
    Params.T1 = 7.013;%-C1
    Params.T2 = -3.583;%C2
    Params.W1 =-1;
    Params.W2 =1;
    Params.W3 =8.767;%M1
    Params.W4 =-4.479;%-M2
    NeuralParams=Params;
end

%% Simulation setup
% Time
simulationTime_total = 80;           % in seconds *------* YOU CAN CHANGE THIS
stepSize_time = 0.05;               % in seconds 

% Initial states and controls
voltage_left_init = 6;
voltage_right_init = 6;
voltage_left  = voltage_left_init;                  % in volts *------* YOU CAN CHANGE THIS
voltage_right = voltage_right_init;                  % in volts *------* YOU CAN CHANGE THIS
state_initial = zeros(1,24);        % VARIABLES OF IMPORTANCE:
                                    % state_initial(13): forward velocity,    v, m/s
                                    % state_initial(18): rotational velocity, r, rad/s
                                    % state_initial(19): current x-position,  x, m
                                    % state_initial(20): current y-position,  y, m
                                    % state_initial(24): heading angle,       psi, rad
doTurnRight = true;
turnRightTime = 1;
turnRightAngleFinal = pi/2; %turn until we reach this angle

turnLeftTime = 4;
turnLeftAngleFinal = 0; %turn until we reach this angle 
doTurnLeft = false;
% Environment
canvasSize_horizontal = 10;
canvasSize_vertical   = 10;
stepSize_canvas       = 0.01;

% *------------------------------------------*
%  YOU CAN ADD MORE SETUP HERE 
%  (e.g. setup of controller or checkpoints)
% *------------------------------------------*


%% Create Environment
obstacleMatrix = zeros(canvasSize_horizontal / stepSize_canvas, canvasSize_vertical / stepSize_canvas);

% Generate walls
% --> the variable "obstacleMatrix" is updated for each added wall
[wall_1, obstacleMatrix] = WallGeneration( -1,  1, 1.2, 1.2, 'h', obstacleMatrix); 
[wall_2, obstacleMatrix] = WallGeneration( -3, -3,  -2,   2, 'v', obstacleMatrix);
[wall_3, obstacleMatrix] = WallGeneration( -3, -2,  -3,  -3, 'h', obstacleMatrix);

% *---------------------------*
%  YOU CAN ADD MORE WALLS HERE
% *---------------------------*


%% Main simulation
% Initialize simulation 
timeSteps_total = simulationTime_total/stepSize_time;
state = state_initial;
time = 0;
array2write = [0,0];
sensorOutLeft = zeros(timeSteps_total);
sensorOutRight = zeros(timeSteps_total);

% Run simulation
for timeStep = 1:timeSteps_total

    
    % *-------------------------------------*
    %  YOU CAN ADD/CHANGE YOUR CONTROLS HERE
    % *-------------------------------------*
    %[l,r]
    sensorOut = Sensor(state(timeStep,19), state(timeStep,20), state(timeStep,24), obstacleMatrix);
    %make sure we are sending correct data to correct input!
    sensorOutIdxLeft = 1;
    sensorOutIdxRight = 2;
    sensorOutLeft(timeStep) = sensorOut(sensorOutIdxLeft);
    sensorOutRight(timeStep) = sensorOut(sensorOutIdxRight);
    array2write(sensorOutIdxLeft)=sensorOutLeft(timeStep);
    array2write(sensorOutIdxRight)=sensorOutLeft(timeStep);

    NeuralInput.LS = sensorOutLeft(timeStep);
    NeuralInput.RS = sensorOutRight(timeStep);
%     NeuralInput.LS = 1;
%     NeuralInput.RS = 1;
    [out] = NeuralController(NeuralInput,NeuralParams);

    voltage_left = out.ML;
    voltage_right = out.MR;

    % Assign voltage applied to wheels
    voltages = [voltage_left; voltage_left; voltage_right; voltage_right];

    % Run model *** DO NOT CHANGE
    [state_derivative(timeStep,:), state(timeStep,:)] = DynamicalModel(voltages, state(timeStep,:), stepSize_time);   
    
    % Euler intergration *** DO NOT CHANGE
    state(timeStep + 1,:) = state(timeStep,:) + (state_derivative(timeStep,:) * stepSize_time); 
    time(timeStep + 1)    = timeStep * stepSize_time;
    
    % Plot robot on canvas  *------* YOU CAN ADD STUFF HERE
    figure(1); clf; hold on; grid on; axis([-5,5,-5,5]);
    DrawRobot(0.2, state(timeStep,20), state(timeStep,19), state(timeStep,24), 'b');
    plot(wall_1(:,1), wall_1(:,2),'k-');
    plot(wall_2(:,1), wall_2(:,2),'k-'); 
    plot(wall_3(:,1), wall_3(:,2),'k-');
    xlabel('y, m'); ylabel('x, m');
end



%% Plot results
% *----------------------------------*
%  YOU CAN ADD OR CHANGE FIGURES HERE
%  don't forget to add axis labels!
% *----------------------------------*


FigTag="xVy";
thisFileName = fullfile(pwd,saveFigPathRel, strcat(FigTag,Controler));
figure(2); hold on; grid on;title("XY Path Robot taken");axis equal;
plot(state(:,stateEnum.yPos), state(:,stateEnum.xPos));
xlabel("y Position (m)"); ylabel("x Position (m)");
plot(wall_1(:,1), wall_1(:,2),'k-');
plot(wall_2(:,1), wall_2(:,2),'k-');
plot(wall_3(:,1), wall_3(:,2),'k-');
savefig(gcf,thisFileName)
saveas(gcf,strcat(thisFileName,".png"))

FigTag="xVt";
thisFileName = fullfile(pwd,saveFigPathRel, strcat(FigTag,Controler));
figure(3); hold on; grid on;title("Robot X coord Vs time")
plot(time, state(:,stateEnum.xPos));
ylabel("x Position (m)"); xlabel("time (s)");
savefig(gcf,thisFileName)
saveas(gcf,strcat(thisFileName,".png"))

FigTag="psiVt";
thisFileName = fullfile(pwd,saveFigPathRel, strcat(FigTag,Controler));
figure(4); hold on; grid on; title("Robot Heading angle Vs time")
plot(time, state(:,stateEnum.angHeading));
ylabel("Heading Angle (rad)"); xlabel("time (s)");
savefig(gcf,thisFileName)
saveas(gcf,strcat(thisFileName,".png"))
