clear all; close all; clc;

%% Initialization
L=  0.7;       % Length (m)
g = 9.81;      % Gravitational Acc
m = 5;         % weight (kg)
t = linspace(0,10,10000); % Time: 0~10 sec, 10000 data
T = 10/10000;
theta=zeros(10000,1);     % Angle
dq=zeros(10000,1);        % Angular Vel
ddq=zeros(10000,1);       % Angular Acc

%% External Torque
tau = 5*sin(pi*t);

%% Inverse dynamics
theta(1) = 50*pi/180; % Initial condition

for k=1:10000-1
    ddq(k+1) = (tau(k) - m*g*L*theta(k))/(m*L^2);
    dq(k+1) = dq(k) + ddq(k+1)*T; % Integration
    theta(k+1) = theta(k) + dq(k+1)*T;    % Integration 
end


%% Figure
figure('color','w');
theta = theta*180/pi;
subplot(211);
plot(t,theta,'b','linewidth',2); % Graph of time vs angle
ylabel('\theta (deg)'); % Name of y axis
xlabel('time(sec)'); % Name of x axis
title('Simple pendulum Inverse dynamcis')

subplot(212);
plot(t,tau,'b','linewidth',2); % Graph of time vs angle
ylabel('\tau (Nm)'); % Name of y axis
xlabel('time(sec)'); % Name of x axis
title('Simple pendulum Inverse dynamcis')


%% Animation
x = L*sin(theta*pi/180); y = -L*cos(theta*pi/180);
Animation_Speed = 10;

figure('color','w');
for k=1:Animation_Speed:10000
    plot(x(1:k),y(1:k),'c.','linewidth',2); hold on;
    plot(x(k),y(k),'bo','markersize',30,'linewidth',2); hold on;
    plot([0 x(k)],[0 y(k)],'r','linewidth',5);
    axis([-1 1 -1 1])
    drawnow;
    hold off;
end