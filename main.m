clear; close all; clc;
addpath Simullink/ plots/ functions/ data/ control/ constraints/

% [za_dot, za, phi_dot, phi, zf_dot, zf, zm_dot, zm]
T = @(params) [ 0,  1,   0, -params.lf,  0, -1,  0,  0;  % x1 = za - lf*phi - zf
      0,  0,   0,   0,  0,  1,  0,  0;  % x2 = zf
      1,  0, -params.lf,   0,  0,  0,  0,  0;  % x3 = dza - lf*dphi
      0,  0,   0,   0,  1,  0,  0,  0;  % x4 = dzf
      0,  1,   0,  params.lm,  0,  0,  0, -1;  % x5 = za + lm*phi - zm
      0,  0,   0,   0,  0,  0,  0,  1;  % x6 = zm
      1,  0,  params.lm,   0,  0,  0,  0,  0;  % x7 = dza + lm*dphi
      0,  0,   0,   0,  0,  0,  1,  0]; % x8 = dzm

% init. gains
Kinf = zeros(2,8);


params = struct();

% Masses and Inertia
params.M     = 22000;      
params.Mf    = 130;        
params.Mm    = 260;        
params.Iphi  = 165000;     

% Geometric Distances
params.lf    = 3.76;      
params.lm    = 1.94;       

% Stiffness Coefficients
params.kaf   = 673000;     
params.kam   = 408000;    
params.kfr   = 1590000;    
params.kmr   = 1590000;    

params.caf_base = 143000; 
params.cam_base = 625000;
params.cfr_base = 4060;
params.cmr_base = 4060;

% Noise
noise.A = 0.5;  % height of the runway bump
noise.l = 2.5;  % length of the runway bump
noise.V = 20;   % taxiing velocity of the aircraft
noise.duration = noise.l / noise.V;

% init state
x0 = [0.18 -0.11 0.12 0.15 -0.15 0.11 0.11 0.11]' * 10^-1;

[za_0, phi_0, zf_0, zm_0, dza_0, dphi_0, dzf_0, dzm_0] = state2physical(x0,params);

simout = sim("Simullink/nlmodel.slx");
t = simout.state.Time; 
x = simout.state.Data; 

load("data/linSys.mat");
A_sys = T(params) * linsys1.A / T(params);   
B_sys = T(params) * linsys1.B;
C_sys = linsys1.C / T(params);        
D_sys = zeros(2,2);

sysLinearized = ss(A_sys,B_sys,C_sys,D_sys);
load("data/equilibrium.mat");
eq = physical2state(8.3052e-05, 1.3885e-04, -1.3050e-04, 7.1839e-05,0,0,0,0,params);
[ylinearized,~,xlinearized] = initial(sysLinearized,x0,t);

[A,B,C,D,B2,C1,D12] = buildLinear(params);
sys = ss(A,B,C,D);
[ylinear,~,xlinear] = initial(sys,x0,t);

% Stability 
eigs = eigs(A);

if all(real(eigs) < 0)
    disp('The linearized system is asymptotically stable.');
else
    disp('The linearized system is unstable.');
end

system = LinearSys(A,B,C,D);
P = system.lyapStab;

% Reachability and Controllability/ Observability and Detectability
Wr = gram(sys,"c");
Wo = gram(sys,"o");

isdefined(Wr,"positive");
isdefined(Wo,"positive");

%%
% Constraints, Hinf control
az_max     = 80.0;    
aphi_max   = 40.0;    
x_strut_max = 0.04;   
v_fuse_max  = 0.15;   
xmax       = 0.10;    
umax       = 60e3;   
v_wheel_max = 0.80;

W_acc = diag([1/az_max, 1/aphi_max]);

C1_norm  = [W_acc * C1; 
            1/x_strut_max, 0, 0, 0, 0, 0, 0, 0;   % Penalize front strut bounce x1
            0, 0, 0, 0, 1/x_strut_max, 0, 0, 0;   % Penalize main strut bounce x5
            0, 0, 1/v_fuse_max, 0, 0, 0, 0, 0;    % Penalize front fuselage vel x3
            0, 0, 0, 0, 0, 0, 1/v_fuse_max, 0;    % Penalize main fuselage vel x7
            0, 1/xmax, 0, 0, 0, 0,      0, 0;     % Tire deflection x2
            0, 0,      0, 0, 0, 1/xmax, 0, 0;     % Tire deflection x6
            0, 0, 0, 1/v_wheel_max, 0, 0, 0, 0;   % x4: Front wheel velocity (STOPS THE +7 SPIKE!)
            0, 0, 0, 0, 0, 0, 0, 1/v_wheel_max;
            zeros(2, 8)];                         % Actuator effort u1, u2

D11_norm = zeros(12,2);

D12_norm = [W_acc * D12; 
            zeros(8, 2); 
            2/umax, 0; 
            0, 2/umax];

beta = 1; 

matrices.A   = A;
matrices.B1  = B;
matrices.B2  = B2 / beta;
matrices.C1  = C1_norm * beta;
matrices.D11 = D11_norm;
matrices.D12 = D12_norm * beta;

hinf = HinfConstr();
contrHinf = Controllers(matrices, hinf, 1);
[Kinf, minval] = contrHinf.solve





% H2 control

matrices.C2 = matrices.C1;
matrices.D22 = matrices.D12;

h2 = H2Constr();
contrH2 = Controllers(matrices, h2, 1);
[Kh2, minvalH2] = contrH2.solve

