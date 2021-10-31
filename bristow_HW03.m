% Daniel Bristow
% PHYS 430

% HOMEWORK 3

clear;
close all;

G = 9.8;
L = 9.8;
W = sqrt(G/L);
Q = 0.5;
F_D = 1.2;
OMEGA_D = 2/3;
THETA_INITIAL = 0.2;
DT = 0.04;

NUM_PLOTS = 1;

time = 0:DT:400*2*pi/OMEGA_D;

theta = zeros(length(time),NUM_PLOTS);
omega = zeros(length(time),NUM_PLOTS);

indicies = find(time > 300 * (2*pi/OMEGA_D) & abs(rem(time, 2*pi/OMEGA_D)) < DT/2);

F_D_array = 1.35:0.001:1.5;


figure(1)

hold on

for k = 1 : length(F_D_array)-1
    
    F_D = F_D_array(k);
    
    for i = 1 : length(time)-1
        theta_i = theta(i,1);
        omega_i = omega(i,1);
        t_i = time(1,i);

        [theta_ip1, omega_ip1] = euler_cromer(theta_i, omega_i, t_i, DT, G, L, Q, F_D, OMEGA_D);

        theta(i+1,1) = theta_ip1;
        omega(i+1,1) = omega_ip1;

    end
    
    temp_F_D_array = zeros(size(theta(indicies,1))) + F_D;
    
    plot(temp_F_D_array,theta(indicies,1), 'o')

end

%{

xlim([0 60])

title(strcat('Physical Pendulum: F_D=', num2str(F_D), ' , Q=', num2str(Q), ' , \Omega_D=', num2str(OMEGA_D)))
xlabel('Time (s)')
ylabel('\theta (radians)')


figure(2)

plot(theta(indicies,1),omega(indicies,1), 'o')    

xlim([-4 4])
ylim([-2 1])

title(strcat('Physical Pendulum: F_D=', num2str(F_D), ' , Q=', num2str(Q), ' , \Omega_D=', num2str(OMEGA_D)))
xlabel('\theta (radians)')
ylabel('\omega (radians/s)')

%}

xlim([1.35 1.5])
ylim([1 3])

title(strcat('Physical Pendulum: Q=', num2str(Q), ' , \Omega_D=', num2str(OMEGA_D)))
xlabel('F_D')
ylabel('\theta (radians)')

hold off


function [theta_ip1, omega_ip1] = euler_cromer(theta_i, omega_i, t_i, DT, G, L, Q, F_D, OMEGA_D)

if theta_i < -pi
    
    theta_i = theta_i + 2*pi;
    
else
    if theta_i > pi
        
        theta_i = theta_i - 2*pi;
        
    end
    
end

omega_ip1 = omega_i + ((-G/L)*sin(theta_i) - Q*omega_i + F_D*sin(OMEGA_D*t_i))*DT;
theta_ip1 = theta_i + omega_ip1*DT;

end
