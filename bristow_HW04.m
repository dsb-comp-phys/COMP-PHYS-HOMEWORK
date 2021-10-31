% Daniel Bristow
% PHYS 430

% HOMEWORK 4

clear;
close all;

%% Constants and Arrays

N = 1000; % Number of intervals in integral (integer at least 2)
NUM_THETA = 12; % Number of theta plotted

G = 9.8;
L = 9.8;

D_THETA = (pi/4)/(NUM_THETA-1);
THETA_MIN = 0;
THETA_MAX = pi/4;
theta_array = THETA_MIN : D_THETA : THETA_MAX;
a_array = sin(theta_array/2);

DX = (pi/2)/(N-1);
X_MIN = 0;
X_MAX = pi/2;
x_array = X_MIN : DX : X_MAX;

k_integrand_array = zeros(length(a_array),N);

for j = 1:length(a_array)
    
    k_integrand_array(j,:) = (1-(a_array(j)^2).*sin(x_array)).^(-1/2);
    
end

%% Trapezoidal Loop

t_trapz_loop = zeros(size(a_array));

for k = 1:length(a_array)
    
    trapz_array = zeros(size(x_array));

    for j = 1:length(x_array)

        if x_array(j) == X_MIN || x_array(j) == X_MAX

            trapz_array(j) = (1/2)*k_integrand_array(k,j);

        else

            trapz_array(j) = k_integrand_array(k,j);

        end

    end

    trapz_array = trapz_array*DX;

    t_trapz_loop(k) = 4*sqrt(L/G)*sum(trapz_array);

end

%% Built-in Trapezoidal

% We verify that our trapezoidal loop is correct with the built-in function
% Eelemets of t_trapz_loop are equal to respective elements of t_trapz_func

t_trapz_func = zeros(size(a_array));

for k = 1:length(a_array)
        
    t_trapz_func(k) = 4*sqrt(L/G)*trapz(x_array, k_integrand_array(k,:));
    
end


%% Simpson's Rule

% Understanding the Romberg table helps to develop this loop
% Refer to (E.12)

simpson_k_integrand_array = zeros(length(a_array),(length(x_array)-1));

for k = 1:length(a_array)
   
    for j = 1:(length(x_array)-1)
        
        r_jp1_1 = k_integrand_array(k,j+1);
        r_j_1 = k_integrand_array(k,j);
        
        r_jp1_2 = r_jp1_1 + (r_jp1_1-r_j_1)/3;
        
        simpson_k_integrand_array(k,j)= r_jp1_2;
    
    end
    
end

simpson_array = simpson_k_integrand_array*DX;

t_simpson_loop = zeros(size(simpson_array));

for k = 1:length(a_array)
    
    t_simpson_loop(k,:) = 4*sqrt(L/G)*sum(simpson_array(k,:));
    
end

%% Comparison of Methods (Plot)

% We find that in the case where theta is 0, the period is 2pi

figure (1)

hold on

plot(theta_array, t_trapz_loop)
plot(theta_array, t_simpson_loop)

title(strcat('Nonlinear (Undamped Undriven) Oscillator (G=L) (N=', num2str(N), ')'))
xlabel('\theta (radians)')
ylabel('T (seconds)')

legend("Trapezoidal", "Simpson's")

hold off
