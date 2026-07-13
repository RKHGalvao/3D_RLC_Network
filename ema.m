function [Yema_dB, Yema_deg, sigma] = ema(Nx, Ny, Nz, fr, fl, fc, omega, initialRoot)

% initialRoot = 1, 2, or 3

R = 1;
L = 0.02;
C = 0.5;

N = length(omega);

j = sqrt(-1);

for i = 1:N
    
    w = omega(i);
    
    sigmaR = 1/R;
    sigmaL = 1./(j*w*L);
    sigmaC = j*w*C;
    d = 3;

    a = (d-1)^2;
    b = (d-1)*( fr*(sigmaL + sigmaC - (d-1)*sigmaR) + fl*(sigmaR + sigmaC - (d-1)*sigmaL) + fc*(sigmaL + sigmaR - (d-1)*sigmaC) );
    c = fr*( sigmaL*sigmaC - (d-1)*(sigmaL + sigmaC)*sigmaR ) + fl*( sigmaR*sigmaC - (d-1)*(sigmaR + sigmaC)*sigmaL ) + fc*( sigmaL*sigmaR - (d-1)*(sigmaL + sigmaR)*sigmaC );
    d = -sigmaR*sigmaL*sigmaC;

    p = roots([a b c d]);
    sigma1(i) = p(1);
    sigma2(i) = p(2);
    sigma3(i) = p(3);
      
    if i == 1
        %%%%%%%%%%%%%%%%%%%
        % Choose the root %
        %%%%%%%%%%%%%%%%%%%
        switch initialRoot
            case 1
                sigma(i) = sigma1(i); 
            case 2
                sigma(i) = sigma2(i);
            case 3
                sigma(i) = sigma3(i);
            otherwise
                error('initialRoot should be 1, 2, or 3.')
        end
    else
        e(1) = abs(sigma1(i) - sigma(i-1));
        e(2) = abs(sigma2(i) - sigma(i-1));
        e(3) = abs(sigma3(i) - sigma(i-1));
        [~,indexmin] = min(e);
        switch indexmin
          case 1
            sigma(i) = sigma1(i);
          case 2
            sigma(i) = sigma2(i);
          case 3
            sigma(i) = sigma3(i);
        end
    end
end

% series/ parallel association of the conductances
Yema_dB = 20*log10(abs(sigma*(Ny*Nz)/(Nx+1)));
Yema_deg = 180*phase(sigma)/pi;
