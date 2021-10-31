%% Homework 5: Waves on a string analysis

% Daniel Bristow
% PHYS 430

clear;
close all;


%% Part 1

c=300;
dx=0.01;
dt=dx/c;
r=c*dt/dx;

L = 1; % End position
T_MAX = dt*1500; % End time

x=0:dx:L;
t=0:dt:T_MAX;

y = zeros(length(x),length(t));

x0=0.3;
k=1000;
y(:,1) = exp(-k*(x-x0).^2);
y(:,2) = exp(-k*(x-x0).^2);

%{
y(1,:)=0;           % Is this necessary? Not really.
y(length(x),:)=0;
%}


figure(1)

plot(x,y(:,2))
title('Ideal String')
xlim([0,L])
ylim([-1,1])
pause(1)

for n = 2:length(t)-1
    
    for i = 2:length(x)-1
        
        y(i,n+1) = 2*(1-r^2)*y(i,n) - y(i,n-1) + r^2*(y(i+1,n) + y(i-1,n));
                
    end
    
    plot(x,y(:,n+1))
    title('Ideal String')
    xlim([0,L])
    ylim([-1,1])
    pause(0.00001)
    
end

%% Part 2

nyquist = 1/(2*dt);

df= nyquist/(length(t)/2-1);

frequency = (1:(length(t)/2-1))*df;

ftX=fft(y(find(x==L/2),:)');

power = abs(ftX(1:floor(length(t)/2 - 1),:).^2);

figure(2)
plot(frequency,power)
title('Ideal String Power Spectrum')
xlabel('Frequency (Hz)')
ylabel('Power')

%% Part 3

eps = 0.00001;

c=300;
dx=0.01;
dt=dx/(4*c);
r=c*dt/dx;

L = 1; % End position
T_MAX = dt*1500; % End time

M = L/dx;

x=0:dx:L;
t=0:dt:T_MAX;

y_real = zeros(length(x),length(t));

x0=0.3;
k=1000;
y_real(:,1) = exp(-k*(x-x0).^2);
y_real(:,2) = exp(-k*(x-x0).^2);

figure(3)

plot(x,y_real(:,2))
title('Realistic String')
xlim([0,L])
ylim([-1,1])
pause(1)

for n = 2:length(t)-1
    
    for i = 2:length(x)-1
        
        if i-2<1
            
            y_real(i,n+1) = (2-2*r^2-6*eps*r^2*M^2)*y_real(i,n) - y_real(i,n-1) + r^2*(1+4*eps*M^2)*(y_real(i+1,n)+y_real(i-1,n)) - eps*r^2*M^2*(y_real(i+2,n)-y_real(i,n));
            
        else
            
            if i+2>length(x)
            
                y_real(i,n+1) = (2-2*r^2-6*eps*r^2*M^2)*y_real(i,n) - y_real(i,n-1) + r^2*(1+4*eps*M^2)*(y_real(i+1,n)+y_real(i-1,n)) - eps*r^2*M^2*(-y_real(i,n)+y_real(i-2,n));
             
            else
                
                y_real(i,n+1) = (2-2*r^2-6*eps*r^2*M^2)*y_real(i,n) - y_real(i,n-1) + r^2*(1+4*eps*M^2)*(y_real(i+1,n)+y_real(i-1,n)) - eps*r^2*M^2*(y_real(i+2,n)+y_real(i-2,n));
                
            end
            
        end
        
    end
    
    plot(x,y_real(:,n+1))
    title('Realistic String')
    xlim([0,L])
    ylim([-1,1])
    pause(0.00001)
    
end

nyquist = 1/(2*dt);

df = nyquist/(length(t)/2-1);

frequency = (1:(length(t)/2-1))*df;

ftX=fft(y_real(find(x==L/2),:)');

power = abs(ftX(1:floor(length(t)/2 - 1),:).^2);

figure(4)
plot(frequency,power)
title('Realistic String Power Spectrum')
xlabel('Frequency (Hz)')
ylabel('Power')
