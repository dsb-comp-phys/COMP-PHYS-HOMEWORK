% Daniel Bristow
% PHYS 430

% HOMEWORK 3


clear;
close all;

M = 1; % Mass
DT = 0.04; % Time interval
G = 9.8; % gravitational acceleration
L = 1; % Length of pendulum

THETA_INITIAL = 0.2;
OMEGA_INITIAL = 0;

T_INITIAL = 0;
T_FINAL = 10;

time = T_INITIAL:DT:T_FINAL;

MAX = length(time)-1;

LAST = 4; % Number of columns

theta = zeros(length(time),3);
omega = zeros(length(time),3);

theta(1,1:4) = THETA_INITIAL;

% Differences between numerical methods and analytical solution
[m,n] = size(theta);
difference = zeros(m,n-1);

% Analytical Solution (Last column) (What's going on with omega here?)
theta(:,LAST) = THETA_INITIAL*cos(sqrt(G/L)*time(1,:));
omega(:,LAST) = -THETA_INITIAL*sqrt(G/L)*sin(sqrt(G/L)*time(1,:));


% Euler Method (First column)
for i = 1 : MAX
    theta_i = theta(i,1);
    omega_i = omega(i,1);
    
    [theta_ip1, omega_ip1] = euler(theta_i, omega_i, DT, G, L);
    
    theta(i+1,1) = theta_ip1;
    omega(i+1,1) = omega_ip1;
    
    difference(i+1,1) = abs(theta(i+1,1)-theta(i+1,LAST));
    
end


% Euler-Cromer Method (Second column)
for i = 1 : MAX
    theta_i = theta(i,2);
    omega_i = omega(i,2);
    
    [theta_ip1, omega_ip1] = euler_cromer(theta_i, omega_i, DT, G, L);
    
    theta(i+1,2) = theta_ip1;
    omega(i+1,2) = omega_ip1;
    
    difference(i+1,2) = abs(theta(i+1,2)-theta(i+1,LAST));
    
end


% Euler-Cromer Method (Third column)
for i = 1 : MAX
    theta_i = theta(i,3);
    omega_i = omega(i,3);
    
    [theta_ip1, omega_ip1] = rk2(theta_i, omega_i, DT, G, L);
    
    theta(i+1,3) = theta_ip1;
    omega(i+1,3) = omega_ip1;
    
    difference(i+1,3) = abs(theta(i+1,3)-theta(i+1,LAST));
    
end


% Mean differences (RK2, third column, is the most accurate)
mean_difference = mean(difference);


% Energy
engery = (1/2)*M*(L^2)*(omega.*omega) + M*G*L*(1-cos(theta));



% Theta Plot

figure(1)

hold on

plot(time,theta(:,1))
plot(time,theta(:,2))
plot(time,theta(:,3))
plot(time,theta(:,4))

title('Simple Harmonic Oscilator Pendulumn Angle')
xlabel('Time (seconds)')
ylabel('Theta (radians)')

legend('Euler', 'Euler-Cromer', 'RK2', 'Analytical')

hold off



% Energy Plot

figure(2)

hold on

plot(time,engery(:,1))
plot(time,engery(:,2))
plot(time,engery(:,3))
plot(time,engery(:,4))

title('Simple Harmonic Oscilator Pendulumn Energy')
xlabel('Time (seconds)')
ylabel('Energy (joules)')

legend('Euler', 'Euler-Cromer', 'RK2', 'Analytical')

hold off


% Phase Plots

figure(3)

hold on

plot(theta(:,2),omega(:,2))
plot(theta(:,3),omega(:,3))
plot(theta(:,4),omega(:,4))

title('Simple Harmonic Oscilator Pendulumn Phase Plots')
xlabel('\theta (radians)')
ylabel('\omega (radians/s)')

legend('Euler-Cromer', 'RK2', 'Analytical')

hold off



%{

I HAVE HAD ISSUES WITH UNDERSTANDING THIS THE ODE45 FUNCTION BEFORE AND AM 
STILL FINDING THIS SECTION OF THE HOMEWORK TO BE UNCLEAR. I AM GIVING UP 
FOR NOW,BUT AM LEAVING WHAT I HAVE ATTEMPTED.

I do not know how to use y(1) and y(2) in the pend function.




t45 = time;

y = zeros(size(length(t45),2));



[t45,y] = ode45(@pend,[T_INITIAL,T_FINAL],[THETA_INITIAL;OMEGA_INITIAL]);


function dydt=pend(t,y)

w = -THETA_INITIAL*sqrt(G/L)*sin(sqrt(G/L)*t);

dwdt = -THETA_INITIAL*(G/L)*cos(sqrt(G/L)*t);

dydt = [w;dwdt];

end

%}


function [theta_ip1, omega_ip1] = euler(theta_i, omega_i, DT, G, L)

omega_ip1 = omega_i - (G/L)*theta_i*DT;
theta_ip1 = theta_i + omega_i*DT;

end


function [theta_ip1, omega_ip1] = euler_cromer(theta_i, omega_i, DT, G, L)

omega_ip1 = omega_i - (G/L)*theta_i*DT;
theta_ip1 = theta_i + omega_ip1*DT;

end


function [theta_ip1, omega_ip1] = rk2(theta_i, omega_i, DT, G, L)

theta_prime = theta_i + (1/2)*omega_i*DT;
omega_prime = omega_i - (1/2)*(G/L)*theta_i*DT;

theta_ip1 = theta_i + omega_prime*DT;
omega_ip1 = omega_i - (G/L)*theta_prime*DT;

end
