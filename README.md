simulation_3D_RLC: Evaluates the network admittance using a descriptor model.

plot_graphs.m loads the MATLAB datasets and plot the admittance graphs.

ema_main.m obtains the EMA admittance (dB magnitude and deg phase) using an expected profile to choose the suitable root in the calculations.

ema.m performs the EMA calculations.

evaluateDispersion.m calculates the dispersion RMS metrics and EMA error (in dB magnitude and deg phase) for datasets 1, 2, and 3. Please uncomment the dataset to be processed in the code.

dataset1.mat
- Nx = 19, Ny = 10, Nz = 12
- fR = 0.2, fL = 0.4, fC = 0.4
- 10 networks

dataset2.mat
- Nx = 39, Ny = 10, Nz = 24
- fR = 0.2, fL = 0.4, fC = 0.4
- 10 networks

dataset3.mat
- Nx = 79, Ny = 20, Nz = 24
- fR = 0.2, fL = 0.4, fC = 0.4
- 10 networks

dataset4.mat
- Nx = 79, Ny = 20, Nz = 24
- fR = 0.3, fL = 0.35, fC = 0.35
- Single network

dataset5.mat
- Nx = 79, Ny = 20, Nz = 24
- fR = 0.2, fL = 0.2, fC = 0.6
- Single network

dataset6.mat
- Nx = 79, Ny = 20, Nz = 24
- fR = 0.2, fL = 0.6, fC = 0.2
- Single network
