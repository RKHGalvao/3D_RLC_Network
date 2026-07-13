function [Yema_dB, Yema_deg, cost] = ema_main(Ynet_dB,w,fr,fl,fc,Nx,Ny,Nz)

% Inputs:
% Ynet_dB --> Magnitude of the admittance obtained with the descriptor model (in dB)
% w --> Frequency array
% fr, fl, fc --> Fractions of resistors, inductors and capacitors
% Nx, Ny, Nz --> Network dimensions
%
% Outputs:
% Yema_dB --> EMA magnitude (in dB)
% Yema_deg --> EMA phase (in deg)
% cost --> cost associated to the difference between Ynet_dB and Yema_dB

% For each root
costRoot = zeros(1,3);
for initialRoot = 1:3
    [Yema_dB{initialRoot}, Yema_deg{initialRoot}] = ema(Nx, Ny, Nz, fr, fl, fc, w, initialRoot);
    if ( (min(Yema_deg{initialRoot}) < -91) || (max(Yema_deg{initialRoot}) > 91) )
        costRoot(initialRoot) = Inf; % Exclusion criterion based on phase (with 1 deg tolerance)
    else
        % Calculate cost
        costRoot(initialRoot) = sum(abs((Ynet_dB - Yema_dB{initialRoot})));  
    end
end
[cost, initialRootBest] = min(costRoot);
Yema_dB = Yema_dB{initialRootBest};
Yema_deg = Yema_deg{initialRootBest};
