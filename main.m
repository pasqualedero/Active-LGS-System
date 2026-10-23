clear; close all; clc;
addpath Simullink/ plots/ functions/ data/

T = @(params) [ 0,  1,   0, -params.lf,  0, -1,  0,  0;  % x1 = za - lf*phi - zf
      0,  0,   0,   0,  0,  1,  0,  0;  % x2 = zf
      1,  0, -params.lf,   0,  0,  0,  0,  0;  % x3 = dza - lf*dphi
      0,  0,   0,   0,  1,  0,  0,  0;  % x4 = dzf
      0,  1,   0,  params.lm,  0,  0,  0, -1;  % x5 = za + lm*phi - zm
      0,  0,   0,   0,  0,  0,  0,  1;  % x6 = zm
      1,  0,  params.lm,   0,  0,  0,  0,  0;  % x7 = dza + lm*dphi
      0,  0,   0,   0,  0,  0,  1,  0]; % x8 = dzm

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
params.caf_amp  = 20000;
params.caf_freq = 0.4;

params.cam_base = 625000;

params.cfr_base = 4060;

params.cmr_base = 4060;

x0 = [0.18 -0.11 0.12 0.15 -0.15 0.11 0.11 0.11]';

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

[A,B,C,D] = buildLinear(params);
sys = ss(A,B,C,D);
figure
[ylinear,~,xlinear] = initial(sys,x0,t);

% Stability 
eigs = eigs(A);

if all(real(eigs) < 0)
    disp('The linearized system is asymptotically stable.');
else
    disp('The linearized system is unstable.');
end

control = Controllers(A,B,C,D);
P = control.lyapStab;

% Reachability and Controllability/ Observability and Detectability
Wr = gram(sys,"c");
Wo = gram(sys,"o");

isdefined(Wr,"positive");
isdefined(Wo,"positive");

% Define noise 
