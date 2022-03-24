%%
deadzone = deg2rad(10);


Plane1Points = [...
%  LS       RS          Theta
    0,      0.25,       0;
    1,      0.3,        0;
    1,      1,  -deadzone...
    ];
Plane2Points = [...
    0,          0.25,       0;
    0.3,       1,          0;
    1,          1,   deadzone...
    ];

% ML = (input.LS*Params.W1+input.RS*Params.W3+Params.W5*input.Theta)>Params.T1; %1
% MR = (input.RS*Params.W4+input.LS*Params.W2+Params.W6*input.Theta)>Params.T2; %2
[W1,W3,W5,T1]=Plane_3Points(Plane1Points(1,:),Plane1Points(2,:),Plane1Points(3,:));
[W2,W4,W6,T2]=Plane_3Points(Plane2Points(1,:),Plane2Points(2,:),Plane2Points(3,:));

Params.W1=W1;
Params.W2=W2;
Params.W3=W3;
Params.W4=W4;
Params.W5=W5;
Params.W6=W6;
Params.T1=T1;
Params.T2=T2;
save("Params","Params")
 %a*LS+b*RS+c*Theta=-d

%%
input.RS =1;
input.LS=1;
input.Theta =0;
ML = (input.LS*Params.W1+input.RS*Params.W3+Params.W5*input.Theta)>Params.T1 %1
MR = (input.RS*Params.W4+input.LS*Params.W2+Params.W6*input.Theta)>Params.T2 %2
%% plot 2d plane
theta2plot = input.Theta;
close(figure(1))
figure(1)
hold on
title(sprintf("theta = %.2f",theta2plot))
RS = 0:0.05:1;
Theta= 0;
LS_1 = (T1-RS*W3-theta2plot*W5)/W1;
LS_2 = (T2-RS*W4-theta2plot*W6)/W2;
plot(RS,LS_1,RS,LS_2)
legend({"LW On Bound","RWOnBound"})
grid on 
xlim([0,1])
ylim([0,1])
xlabel("RS")
ylabel("LS")

 %% Plot Plane
close(figure(10))
figure(10)
title("planes")
hold on
%x,y
[RS, LS] = meshgrid(-0:0.1:1,-0:0.1:1);
% RS = [1 -1 -1 1]; % Generate data for x vertices
% LS = [1 1 -1 -1]; % Generate data for y vertices
%z
Theta = -1/W5*(W3*RS + W1*LS - T1); % Solve for z vertices data
mesh(RS, Theta,LS );
set(gca, 'Xdir', 'reverse')

Theta = -1/W6*(W4*RS + W2*LS - T2); % Solve for z vertices data
mesh(RS, Theta, LS);
xlabel("RS")
zlabel("LS")
ylabel("Theta")
xlim([-0,1])
zlim([-0,1])
ylim([-deadzone,deadzone])
grid on