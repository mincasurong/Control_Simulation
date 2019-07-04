clear all; clc; close all;

%% Initialize
syms s; s=tf('s'); % Let s in s-domain

%% System Modeling
G=(s+3)/(s+1)/(s^2+13*s+30)/(s+7);
G=zpk(G); % System Modeling

%% Model analysis
figure('color','w'); pzmap(G);   drawnow; % Pole-zero Map
figure('color','w'); impulse(G); drawnow; % System Impulse Response
figure('color','w'); step(G);    drawnow; % System Step Response
figure('color','w'); rlocus(G);  drawnow; % Root locus

w=logspace(-4,4,100);                  % Frequency Setting
figure('color','w'); bode(G,w);    grid on; drawnow;% Bode plot
figure('color','w'); nyquist(G,w); grid on; drawnow;% Bode plot
%% Controller
Kp=100; Kd=0;    % P gain & D gain
C=Kd*s + Kp; % PD controller

%% Closed Loop Transfer Function
Gclosed=feedback(C*G,1);               % Closed loop transfer function
figure('color','w'); pzmap(Gclosed);   % Pole-zero Map
title('Pole zero location of Closed loop TF');  drawnow; 


%% Closed Loop Simulation
% Low freq
t=0:0.001:5; % Simluation Time
r=sin(3*t)+1.5*sin(4.3*t)+3.1*sin(5.1*t); % Reference 
[y,t]=lsim(Gclosed,r,t); % Linear time varying simulation

figure('color','w'); % Graph
plot(t,y); ylabel('Position (m)'); xlabel('time (sec)');
title('Simulation of the closed loop transfer function');  drawnow; 

%% Graphical Simulation
N=length(t);
figure('color','w');
for k=1:50:N;
    % Moving Block
    subplot(211);
    plot([r(k)-2 r(k)+2],[0 0],'r','linewidth',2); hold on;
    plot([r(k)-2 r(k)+2],[0.5 0.5],'r','linewidth',2); hold on;
    plot([r(k)+2 r(k)+2],[0 0.5],'r','linewidth',2); hold on;
    plot([r(k)-2 r(k)-2],[0 0.5],'r','linewidth',2); hold on;
    plot([y(k)-2 y(k)+2],[0 0],'b:','linewidth',2); hold on;
    plot([y(k)-2 y(k)+2],[0.5 0.5],'b:','linewidth',2); hold on;
    plot([y(k)+2 y(k)+2],[0 0.5],'b:','linewidth',2); hold on;
    plot([y(k)-2 y(k)-2],[0 0.5],'b:','linewidth',2); hold on;
    plot([-10 10],[0 0],'k');
    title(sprintf('Desired Position: %.3f (m). Actual Position: %.3f (m). Error: %.3f (m)',r(k),y(k),r(k)-y(k)))
    axis([-10 10 -1 2]);
    ylabel('y-axis'); xlabel('x-axis');     drawnow;
    hold off;
    
    % Graph
    subplot(212);
    plot(t(1:k),r(1:k),'r','linewidth',2); hold on;
    plot(t(1:k),y(1:k),'b:','linewidth',2);
    ylabel('Position (m)'); xlabel('time (sec)') 
    axis([0 t(end) -10 10]);     drawnow;
    hold off;
end
legend('Referece (r)','Output (y)')