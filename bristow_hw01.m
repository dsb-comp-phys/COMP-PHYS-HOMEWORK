% Daniel Bristow
% PHYS 430

% In-Class Activity 2: Euler Method Exponential Decay 1/21/21

N_URANIUM_INITIAL = 100;
TAU = 1; % time constant (seconds)
DT = 0.05; % time interval (seconds)
time1 = 0:DT:DT*200;
n_uranium_array = zeros(1,length(time1));






% Euler's method: DT = 0.05
n_uranium_array(1,1) = N_URANIUM_INITIAL;

for i = 1 : length(n_uranium_array)-1
    
    n_uranium_array(1,i+1) = n_uranium_array(1,i) - DT * (n_uranium_array(1,i)/TAU);
    
end

% Analytical solution 
n_analytical = N_URANIUM_INITIAL * exp(-time1/TAU);

error_dif_1 = n_analytical - n_uranium_array;





% Plot
figure(1)
plot(time1,n_analytical)

hold on

plot(time1,n_uranium_array)

title('Analytical Solution versus Euler''s Method: DT=0.05')
xlabel('Time (seconds)')
ylabel('Value')

legend('Analytical Solution', 'Euler''s Method')

hold off






% Euler's method: DT = 0.1
DT = 0.1; % time interval (seconds)
time2 = 0:DT:DT*200;
n_uranium_array(1,1) = N_URANIUM_INITIAL;

for i = 1 : length(n_uranium_array)-1
    
    n_uranium_array(1,i+1) = n_uranium_array(1,i) - DT * (n_uranium_array(1,i)/TAU);
    
end

% Analytical solution 
n_analytical = N_URANIUM_INITIAL * exp(-time2/TAU);

% Error difference
error_dif_2 = n_analytical - n_uranium_array;






% Plot
figure(2)
plot(time2,n_analytical)

hold on

plot(time2,n_uranium_array)

title('Analytical Solution versus Euler''s Method: DT=0.1')
xlabel('Time (seconds)')
ylabel('Value')

legend('Analytical Solution', 'Euler''s Method')

hold off





% Plot
figure(3)
plot(time1,error_dif_1)

hold on

plot(time2,error_dif_2)

title('Error Difference Between Analytical Solution and Euler''s Method')
xlabel('Time (seconds)')
ylabel('Error Difference')

legend('DT=0.05', 'DT=0.1')

hold off
