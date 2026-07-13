clear, clc, close all
 
% dataset1.mat
% - Nx = 19, Ny = 10, Nz = 12
% - fR = 0.2, fL = 0.4, fC = 0.4
% - 10 networks
% 
% dataset2.mat
% - Nx = 39, Ny = 10, Nz = 24
% - fR = 0.2, fL = 0.4, fC = 0.4
% - 10 networks
% 
% dataset3.mat
% - Nx = 79, Ny = 20, Nz = 24
% - fR = 0.2, fL = 0.4, fC = 0.4
% - 10 networks
% 
% dataset4.mat
% - Nx = 79, Ny = 20, Nz = 24
% - fR = 0.3, fL = 0.35, fC = 0.35
% - Single network
% 
% dataset5.mat
% - Nx = 79, Ny = 20, Nz = 24
% - fR = 0.2, fL = 0.2, fC = 0.6
% - Single network
% 
% dataset6.mat
% - Nx = 79, Ny = 20, Nz = 24
% - fR = 0.2, fL = 0.6, fC = 0.2
% - Single network

% mag_db, phase_deg: Magnitude (dB) and Phase (deg) of the network 
% admittance (current/voltage), including the source resistance Rs.

option = input('Choose dataset (1 - 6): ');

switch option
    case 1
        load dataset1
        Nx = 19; Ny = 10; Nz = 12;
        fR = 0.2; fL = 0.4; fC = 0.4;
        ylow = 20; yhigh = 60; yl = 55;
        legend1 = '(a)'; legend2 = '(b)';
    case 2
        load dataset2
        Nx = 39; Ny = 10; Nz = 24;
        fR = 0.2; fL = 0.4; fC = 0.4;
        ylow = 20; yhigh = 60; yl = 55;
        legend1 = '(c)'; legend2 = '(d)';
    case 3
        load dataset3
        Nx = 79; Ny = 20; Nz = 24;
        fR = 0.2; fL = 0.4; fC = 0.4;
        ylow = 20; yhigh = 60; yl = 55;
        legend1 = '(e)'; legend2 = '(f)';
    case 4
        load dataset4
        Nx = 79; Ny = 20; Nz = 24;
        fR = 0.3; fL = 0.35; fC = 0.35;
        ylow = 20; yhigh = 60; yl = 55;
        legend1 = '(a)'; legend2 = '(b)';
    case 5
        load dataset5
        Nx = 79; Ny = 20; Nz = 24;
        fR = 0.2; fL = 0.2; fC = 0.6;
        ylow = -20; yhigh = 60; yl = 50;
        legend1 = '(a)'; legend2 = '(b)';
    case 6
        load dataset6
        Nx = 79; Ny = 20; Nz = 24;
        fR = 0.2; fL = 0.6; fC = 0.2;
        ylow = 0; yhigh = 80; yl = 70;
        legend1 = '(c)'; legend2 = '(d)';
end

Ynet_dB_array = Ynet_dB{1};
Ynet_deg_array = Ynet_deg{1};
for i = 2:Nrealizations
    Ynet_dB_array = [Ynet_dB_array;Ynet_dB{i}];
    Ynet_deg_array = [Ynet_deg_array;Ynet_deg{i}];
end

figure(1), h = semilogx(w,Ynet_dB_array,'k'); hold on
set(h,'LineWidth',1)
figure(2), h = semilogx(w,Ynet_deg_array,'k'); hold on
set(h,'LineWidth',1)

figure(1)
xlabel('Frequency \omega')
ylabel('Magnitude (dB)')
grid
set(gca,'FontSize',14)
ylim([ylow yhigh])
text(8,yl,legend1,'FontSize',14)

figure(2)
xlabel('Frequency \omega')
ylabel('Phase (deg)')
grid
set(gca,'FontSize',14,'YTick',-90:45:90)
ylim([-100 100])
text(8,75,legend2,'FontSize',14)

% EMA calculations

Ynet_dB_mean = mean(Ynet_dB_array);
[Yema_dB, Yema_deg] = ema_main(Ynet_dB_mean,w,fr,fl,fc,Nx,Ny,Nz);
figure(1), h = semilogx(w,Yema_dB,'b'); hold on
set(h,'LineWidth',1)
figure(2), h = semilogx(w,Yema_deg,'b'); hold on
set(h,'LineWidth',1)
