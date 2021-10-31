clear;
close all;

k_b = 1;    % Boltzmann constant

% Set the desired values
T_MAX = 5;
T_STEP = 0.01;

T = 0:T_STEP:T_MAX;

J=1;            % Exchange constant

SumM = zeros(1,length(T)); % Sum of magnetizations per temperature
SumE = zeros(1,length(T)); % Sum of energies per temperature
SumE2 = zeros(1,length(T));

% Initialize all spins s_i
L = 10;
N = L^2;

% Loop of temperature
for k=1:length(T)
    
    s = ones(L);    % Lattice

    % Preform the desired number of Monte Carlo sweeps through the lattice
    nsweeps = 1000;
    
    for sweep = 1:nsweeps
        
        E = 0;  % Energy of sweep

        % For a given sweep, loop through the L rows and L columns
        for i=1:L
        
            % For a given sweep, loop through the L columns
            for j=1:L
    
                % Calculate E_flip
                
                % NOTE THE PERIODIC BOUNDARY CONDITIONS
                
                % Current Location (at)
                s_at = s(i,j);
                
                % Up Neighbor
                if i == 1
                    s_up = s(L,j);
                else
                    s_up = s(i-1,j);
                end
                
                % Down Neighbor
                if i == L
                    s_down = s(1,j);
                else
                    s_down = s(i+1,j);
                end
                
                % Left Neighbor
                if j == 1
                    s_left = s(i,L);
                else
                    s_left = s(i,j-1);
                end
                
                % Right Neighbor
                if j == L
                    s_right = s(i,1);
                else
                    s_right = s(i,j+1);
                end
                
                % Finally, we calculate.
                E_1 = -J*(-s_at)*(s_up + s_down + s_left + s_right);
                E_2 = -J*s_at*(s_up + s_down + s_left + s_right);
                E_flip = E_1 - E_2;
                
                % Now for the Monte Carlo step.
                
                flip = false;
                
                if E_flip <= 0    
                    
                    s(i,j) = -s(i,j); % flip spin
                    flip = true;
                    
                else
        
                    % generate a uniform random number r between 0 and 1
                    % and compare it with exp(-E_flip/(k_b*T))
                    
                    r = rand();
                    
                    boltz = exp(-E_flip/(k_b*T(k))); % Boltzman factor
                    
                    if r<=boltz
                        
                        s(i,j) = -s(i,j); % flip spin
                        flip = true;
                        
                    end
                               
                end
                
                % Energy
                if flip
                    E = E + E_1;
                else
                    E = E + E_2;
                end
                    
            end     % columns
            
        end     % rows
    
        % Magnetization of sweep
        M = sum(sum(s));
        
        % Add magnetization of sweep
        SumM(k) = SumM(k) + abs(M);
        
        % Add energy of sweep
        SumE(k) = SumE(k) + E;
        SumE2(k) = SumE2(k) + E^2;
        
    end     % sweeps
    
    SumM(k) = SumM(k)/nsweeps/N;
    SumE(k) = SumE(k)/nsweeps/(2*N);
    SumE2(k) = SumE2(k)/nsweeps/(2*N)^2;
        
    % SURFACE PLOT
    if rem(T(k)*100,100)==0
        figure(T(k)+1)
        imagesc(s)
        colorbar
        title(['Lattice (kT=', num2str(k_b*T(k)), ')'])
        xlabel('x')
        ylabel('y')
        pbaspect([1 1 1])
        xticks([1 2 3 4 5 6 7 8 9 10])
        yticks([1 2 3 4 5 6 7 8 9 10])
    end

end     % temperature

% Store (and/ or plot) the recorded thermodynaic quantities.

figure(7)
plot(T,SumM)
title('Magnetization')
xlabel('Temperature')
ylabel('\langlem\rangle')

figure(8)
plot(T,SumE)
title('Energy')
xlabel('Temperature')
ylabel('\langleE\rangle')

Cp = (SumE2 - (SumE).^2)./((k_b*T).^2);

figure(9)
plot(T,Cp)
title('Specific Heat (using equation)')
xlabel('Temperature')
ylabel('C_P')

figure(10)
plot(0:T_STEP:T_MAX-T_STEP,(diff(SumE)./diff(T))/nsweeps)
title('Specific Heat (using diff())')
xlabel('Temperature')
ylabel('C_P')
