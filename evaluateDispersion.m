clear, clc, close all

disp('Please uncomment the dataset to be processed.')

load dataset1.mat
% load dataset2.mat
% load dataset3.mat

% Conversion from cell array to standard array format
Ynet_dB_array = Ynet_dB{1};
Ynet_deg_array = Ynet_deg{1};
for i = 2:Nrealizations
    Ynet_dB_array = [Ynet_dB_array;Ynet_dB{i}];
    Ynet_deg_array = [Ynet_deg_array;Ynet_deg{i}];
end

Ynet_dB_mean = mean(Ynet_dB_array);
Ynet_dB_dev = Ynet_dB_array - repmat(Ynet_dB_mean,Nrealizations,1);
NdB_dev = size(Ynet_dB_dev,1)*size(Ynet_dB_dev,2);
RMSdB_dev = sqrt( sum(sum(Ynet_dB_dev.^2)) / NdB_dev )

Ynet_deg_mean = mean(Ynet_deg_array);
Ynet_deg_dev = Ynet_deg_array - repmat(Ynet_deg_mean,Nrealizations,1);
Ndeg_dev = size(Ynet_deg_dev,1)*size(Ynet_deg_dev,2);
RMSdeg_dev = sqrt( sum(sum(Ynet_deg_dev.^2)) / Ndeg_dev )

semilogx(w,abs(Ynet_dB_dev)),grid
figure
semilogx(w,abs(Ynet_deg_dev)),grid

% Evaluation of the EMA error
[Yema_dB, Yema_deg] = ema_main(Ynet_dB_mean,w,fr,fl,fc,Nx,Ny,Nz);

Yema_dB_dev = Yema_dB - Ynet_dB_mean;
RMS_ema_dB_dev = sqrt( sum(Yema_dB_dev.^2) / length(w) )

Yema_deg_dev = Yema_deg - Ynet_deg_mean;
RMS_ema_deg_dev = sqrt( sum(Yema_deg_dev.^2) / length(w) )
