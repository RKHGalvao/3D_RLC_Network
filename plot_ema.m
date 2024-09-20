function plot_ema(NX, NY, NZ, fR, fL, fC, rootNumber)

R = 1;
L = 0.02;
C = 0.5;

N = 1000;
omega = logspace(-1,3,N);
j = sqrt(-1);

for i = 1:N
    
    w = omega(i);
    
    sigmaR = 1/R;
    sigmaL = 1./(j*w*L);
    sigmaC = j*w*C;
    d = 3;

    a = (d-1)^2;
    b = (d-1)*( fR*(sigmaL + sigmaC - (d-1)*sigmaR) + fL*(sigmaR + sigmaC - (d-1)*sigmaL) + fC*(sigmaL + sigmaR - (d-1)*sigmaC) );
    c = fR*( sigmaL*sigmaC - (d-1)*(sigmaL + sigmaC)*sigmaR ) + fL*( sigmaR*sigmaC - (d-1)*(sigmaR + sigmaC)*sigmaL ) + fC*( sigmaL*sigmaR - (d-1)*(sigmaL + sigmaR)*sigmaC );
    d = -sigmaR*sigmaL*sigmaC;

    p = roots([a b c d]);
    sigma1(i) = p(1);
    sigma2(i) = p(2);
    sigma3(i) = p(3);
      
    if i == 1
        switch rootNumber
            case 1
                sigma(i) = sigma1(i);
            case 2
                sigma(i) = sigma2(i);
            case 3
                sigma(i) = sigma1(i);
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

figure(1)
hold on
h = semilogx(omega,20*log10(abs(sigma*(NY*NZ)/(NX+1))),'b');
set(h,'LineWidth',2)

figure(2)
hold on
h = semilogx(omega,180*angle(sigma)/pi,'b');
set(h,'LineWidth',2)