function [Ynet_dB, Ynet_deg] = simulation_3D_RLC(Nx,Ny,Nz,fr,fl,fc,Nrealizations,w)

% [Ynet_dB, Ynet_deg] = simulation_3D_RLC(Nx,Ny,Nz,fr,fl,fc,Nrealizations,w)
%
% Input arguments:
% Network dimensions: Nx, Ny, Nz
% Fraction of components: fr, fl, fc
% Number of network realizations: Nrealizations
% Frequency array (rad/time unit): w
%
% Output arguments (cell arrays containing the results for each realization):
% Ynet_dB: Magnitude of the network admittance in dB, without the source resistance
% phase_deg: Phase of the network admittance in degrees, without the source resistance

if abs((fr + fl + fc) - 1) > eps
    error('Please ensure that fr + fl + fc = 1.')
end

% Initializes the random number generator
rand('state',0) 

% Network size
l = Nz; % Number of layers (Nz)
r = Nx; % Number of rows in each layer (excluding the source node) (Nx)
c = Ny; % Number of columns in each layer (Ny)

% Resistance and Capacitance values

Rs = 0.001;
R = 1; % Resistance
Cap = 0.5; % Capacitance
Lind = 0.02; % Inductance

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Adjacency matrix W %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
NBlayer = c*(r+1) + r*(c-1); % Number of branches in each layer
NNlayer = r*c; % Number of nodes in each layer

NB = 1 + l*NBlayer + (l-1)*NNlayer; % Total number of branches in the network (including the source and the branches connecting consecutive layers)
NN = 1 + l*NNlayer; % Total number of nodes in the network (not including the ground)

W = sparse(NN,NB);

% Source node
W(1,1) = -1;

% Building block for the remaining parts of the adjacency matrix 

I = speye(c);
T = toeplitz([1;-1;sparse(c-2,1)],[1 sparse(1,c-2)]);

% Gamma, Lambda, Pi matrices
Gamma = [ones(1,c) sparse(1,NBlayer-c)];

Lambda = sparse(NNlayer,NBlayer);
for i = 1:r % ith row of nodes
    init_row = 1 + (i-1)*c;
    init_col = 1 + (i-1)*(2*c-1);
    fin_row = init_row + c-1;
    fin_col = init_col + 3*c-2;
    Lambda([init_row:fin_row],[init_col:fin_col]) = [-I T I];
end

Pi = I;
for i = 2:r % ith row of nodes
    Pi = blkdiag(Pi,I);
end

% Final assembly of the W matrix

% Gamma matrices
aux = repmat(Gamma,1,l);
W(1,2:1+l*NBlayer) = aux;

% Lambda matrices
aux = [];
for i=1:l % ith layer
    aux = blkdiag(aux,Lambda);
end
W(2:end,2:1+l*NBlayer) = aux;

% Pi matrices
aux = sparse(NN-1, NB-l*NBlayer-1);
for i = 1:l-1 % ith layer
    init_row = 1 + (i-1)*NNlayer;
    init_col = 1 + (i-1)*NNlayer;
    fin_row = init_row + 2*NNlayer - 1;
    fin_col = init_col + NNlayer - 1;
    aux(init_row:fin_row,init_col:fin_col) = [Pi;-Pi];
end

W(2:end,2+l*NBlayer:end) = aux;
aux = [];

for realization = 1:Nrealizations
    
    % Randomization of the network branches (with exception of source branch)
    index = 1 + randperm(NB-1);
    P = sparse(NB,NB); % Permutation matrix
    P(1,1) = 1;
    for i = 1:(NB-1)
        P(i+1,index(i)) = 1;
    end
    index = [];
    
    %%%%%%%%%%%%%%%%%%%%%%
    %%% State equation %%%
    %%%%%%%%%%%%%%%%%%%%%%
    NR = round(fr*(NB-1)); % Number of resistors (excluding the source)
    NL = round(fl*(NB-1)); % Number of inductors
    NC = NB - 1 - NR - NL; % Number of capacitors

    % M matrix
    aux = sparse(1+NR+NL+NC, 1+NR+NL+NC);
    aux(1,1) = -Rs;
    aux(2:NR+1,2:NR+1) = -R*speye(NR);
    
    M = sparse(NN+NB,NB+NN);
    M(NN+1:end,1:NB) = aux;
    aux = W*P;
    M(1:NN,1:NB) = aux;
    M(NN+1:end, NB+1:end) = aux';
    aux = [];

    Mis = M(:,1);
    Mir = M(:,2:(NR+1));
    Mil = M(:,(NR+2):(NR+NL+1));
    Mvcp = M(:,(NR+NL+2):(NR+NL+NC+1));
    Me = M(:,(NR+NL+NC+2):end);

    % Descriptor system: E dx/dt = Ax + Bu, y = Cx + Du
    E = [sparse(NN+NB,NR+1) [sparse(NN+NR+1,NL);-Lind*speye(NL);sparse(NC,NL)] Cap*Mvcp sparse(NN+NB,NN)];
    A = [-Mis -Mir -Mil [sparse(NN+NR+NL+1,NC);speye(NC)] -Me];
    B = [sparse(NN,1);-1;sparse(NR+NL+NC,1)];
    C = [1 sparse(1,NR+NL+NC+NN)];
    D = 0;
 
    j = sqrt(-1);
    for iw = 1:length(w)

        AUX = sparse(j*w(iw)*E-A);
        GG = C*(AUX\B) + D;

        mag(iw) = abs(GG);
        phase_angle(iw) = (angle(GG))*180/pi; % Phase in deg
        
    end

    mag_db{realization} = 20*log10(mag);
    phase_deg{realization} = phase_angle;

end

for i = 1:Nrealizations
    Yabs = 10.^(mag_db{i}/20);
    j = sqrt(-1);
    Y = Yabs.*(cosd(phase_deg{i}) + j*sind(phase_deg{i}));
    Ynet = Y./(1 - Rs*Y); % Network admittance, without the source resistance
    Ynet_dB{i} = 20*log10(abs(Ynet));
    Ynet_deg{i} = 180*phase(Ynet)/pi;
end
