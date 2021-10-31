%% Homework 7: Cream in your Coffee Diffusion Part 2

% Daniel Bristow
% PHYS 430

%% Problem 7.15

clear;
close all;

Num_walkers = 400;  % DO NOT CHANGE!
Time_steps = 10001; % Also used 3001 here (true time minus 1)
x = zeros(Num_walkers,Time_steps);
y = zeros(Num_walkers,Time_steps);

w=1;

%{
Mean square should be linear until a particle hits the bounds, then should
get smaller.
%}

for j = -9:10

    for i = -9:10

        x(w,1) = i;
        y(w,1) = j;
        
        w=w+1;
            
    end
    
end

%figure (1)
%{
plot(x(:,1),y(:,1),'.')
xlim([-100,100])
ylim([-100,100])
pbaspect([1 1 1])
xlabel('x')
ylabel('y')
xticks([-100,-75,-50,-25,0,25,50,75,100])
yticks([-100,-75,-50,-25,0,25,50,75,100])
title('Cream in coffee t=0')
pause(0.5)
grid on
%}

%{
Pxy = hist3([x(:,1),y(:,1)],'edges',{-100:25:100 -100:25:100});
Pxy = Pxy./Num_walkers;

hist3([x(:,1),y(:,1)],'CdataMode','auto','edges',{-100:25:100 -100:25:100})
xlabel('x')
ylabel('y')
title('Cream in coffee t=0')
%colormap('hot') % Change color scheme
colorbar
caxis([0 121])
view(2)
pause(0.5)
%}

%{
S=zeros(1,10001);

for i=1:length(Pxy)-1
    
    for j=1:length(Pxy)-1
        
        if Pxy(i,j) ~= 0
            
            S(1) = S(1) - Pxy(i,j)*log(Pxy(i,j));
        
        end
            
    end
    
end
%}

number_of_particles = 400*ones(1,Time_steps);
escaped_particles = 0;

for w=1:Num_walkers    
    
    for t=1:Time_steps-1
   
        num = rand();
        p = rand();

        if p <= 0.25
            if x(w,t) == 100
                % HERE IS THE HOLE: -25<=y<=25 on the right edge.
                if y(w,t) >= -25 && y(w,t) <= 25
                    escaped_particles = escaped_particles + 1;
                    for i = t:Time_steps-1
                        number_of_particles(1,i+1) = number_of_particles(1,i+1) - 1;
                    end
                    break
                else
                    x(w, t+1) = x(w, t) - 1;     
                end
            else
                x(w, t+1) = x(w, t) + 1;
            end
            
            y(w, t+1) = y(w, t);

        elseif p > 0.25 && p <= 0.5
            if x(w,t) == -100
                x(w, t+1) = x(w, t) + 1;
            else
                x(w, t+1) = x(w, t) - 1;
            end
            
            y(w, t+1) = y(w, t);

        elseif p > 0.5 && p <= 0.75
            x(w, t+1) = x(w, t);
            
            if y(w, t) == 100
                y(w, t+1) = y(w, t) - 1;
            else
                y(w, t+1) = y(w, t) + 1;
            end

        else
            x(w, t+1) = x(w, t);
            
            if y(w, t) == -100
                y(w, t+1) = y(w, t) + 1;
            else
                y(w, t+1) = y(w, t) - 1;
            end
            
        end
        
        %r_squared(w,t+1)= (x(w,t+1))^2+(y(w,t+1))^2;
            
    end
    
    %{
    Pxy = hist3([x(:,t+1),y(:,t+1)],'edges',{-100:25:100 -100:25:100});
    Pxy = Pxy./Num_walkers;
    
    for i=1:length(Pxy)-1
    
        for j=1:length(Pxy)-1
            
            if Pxy(i,j) ~= 0
        
                S(t+1) = S(t+1) - Pxy(i,j)*log(Pxy(i,j));
        
            end
                
        end
    
    end
    %}
    
    %{
    if rem(t,1000)==0
        %{
        plot(x(:,t+1),y(:,t+1),'.')
        xlim([-100,100])
        ylim([-100,100])
        pbaspect([1 1 1])
        xlabel('x')
        ylabel('y')
        xticks([-100,-75,-50,-25,0,25,50,75,100])
        yticks([-100,-75,-50,-25,0,25,50,75,100])
        title(['Cream in coffee t=', num2str(t)])
        pause(0.5)
        grid on
        %}
        
        hist3([x(:,t+1),y(:,t+1)],'CdataMode','auto','edges',{-100:25:100 -100:25:100})
        xlabel('x')
        ylabel('y')
        title(['Cream in coffee t=', num2str(t)])
        %colormap('hot') % Change color scheme
        colorbar
        caxis([0 121])
        view(2)
        pause(0.5)
        
    end
    %}
    
            
end

%mean_sqr_dis = (1/w)*sum(r_squared);

time = (1:Time_steps)-1;

figure(1)

plot(time,number_of_particles)
hold on
fitanswer = fit(time',number_of_particles','exp2');
plot(fitanswer)
xlim([0,Time_steps-1])
xlabel('Time')
ylabel('Number of Particles')
title('Time versus Number of Particles')

%figure(2)
%{
plot(time,mean_sqr_dis)
hold on
fitanswer = fit(time',mean_sqr_dis','poly1');
plot(fitanswer)
xlim([0,Time_steps-1])
xlabel('Time')
ylabel('Mean-Squared Displacement')
title(['Mean-Squared Displacement versus Time (t_{max}=', num2str(Time_steps-1), ')'])
hold off
%}

%{
plot(time,S)
xlabel('Time')
ylabel('Entropy')
title(['Entropy versus time'])
%}

%{
figure(3)
plot(x(:,1),y(:,1),'.')
xlim([-100,100])
ylim([-100,100])
pbaspect([1 1 1])
xlabel('x')
ylabel('y')
title(['Cream in coffee t=0'])
pause(0.5)
grid on

figure(4)
plot(x(:,1001),y(:,1001),'.')
xlim([-100,100])
ylim([-100,100])
pbaspect([1 1 1])
xlabel('x')
ylabel('y')
title(['Cream in coffee t=1000'])
pause(0.5)
grid on

figure(5)
plot(x(:,2001),y(:,2001),'.')
xlim([-100,100])
ylim([-100,100])
pbaspect([1 1 1])
xlabel('x')
ylabel('y')
title(['Cream in coffee t=2000'])
pause(0.5)
grid on

figure(6)
plot(x(:,3001),y(:,3001),'.')
xlim([-100,100])
ylim([-100,100])
pbaspect([1 1 1])
xlabel('x')
ylabel('y')
title(['Cream in coffee t=3000'])
pause(0.5)
grid on


%}

%{
% Not sure about this (for the last part) (from HW6).
a=(mean(x.*y,'all')-mean(x,'all')*mean(y,'all'))/(mean(x.^2,'all')-mean(x,'all'))^2;
b=(mean(x.^2,'all')*mean(y,'all')-mean(x,'all')*mean(x.*y,'all'))/mean(x.^2,'all')-(mean(x,'all'))^2;

disp(a)
disp(b)
%}
