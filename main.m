clear; close all; clc;
addpath Simullink/ plots/ functions/ data/ control/ constraints/ constraints/geomConstr/ constraints/lmiPlotter/

% [za_dot, za, phi_dot, phi, zf_dot, zf, zm_dot, zm]
T = @(params) [ 0,  1,   0, -params.lf,  0, -1,  0,  0;  % x1 = za - lf*phi - zf
      0,  0,   0,   0,  0,  1,  0,  0;  % x2 = zf
      1,  0, -params.lf,   0,  0,  0,  0,  0;  % x3 = dza - lf*dphi
      0,  0,   0,   0,  1,  0,  0,  0;  % x4 = dzf
      0,  1,   0,  params.lm,  0,  0,  0, -1;  % x5 = za + lm*phi - zm
      0,  0,   0,   0,  0,  0,  0,  1;  % x6 = zm
      1,  0,  params.lm,   0,  0,  0,  0,  0;  % x7 = dza + lm*dphi
      0,  0,   0,   0,  0,  0,  1,  0]; % x8 = dzm

% init. gains and switch
K = zeros(2,8);
activate_noise = 0;


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
x0 = [0.18 -0.11 0.12 0.15 -0.15 0.11 0.11 0.11]' * 10^-1; % set x0=0 for controllers hyp.
x0 = zeros(8,1);

[za_0, phi_0, zf_0, zm_0, dza_0, dphi_0, dzf_0, dzm_0] = state2physical(x0,params);

sim_freeResp = sim("Simullink/nlmodel.slx");
t = sim_freeResp.state.Time; 
x_free = sim_freeResp.state.Data; 
y_free = sim_freeResp.output.Data;

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

% Free response with noise
activate_noise = 1; 
sim_freeNoise = sim("Simullink/nlmodel.slx");
x_free_noise = sim_freeNoise.state.Data;
y_free_noise = sim_freeNoise.output.Data;

%%
% Constraints

az_max     = 2;    
aphi_max   = 0.8;    
x_strut_max = 0.04;   
v_fuse_max  = 0.15;   
tire_defl_max = 0.015;    
umax       = 120e3;   
v_wheel_max = 0.80;


beta = 1; 

W = @(w1,w2) diag([w1/az_max, w2/aphi_max]);
C = @(W) [W * C1; zeros(2, 8)];
D = @(W,w1,w2) [W * D12; w1/umax, 0; 0, w2/umax];
matrices = @(C,D) struct('A',A,'B1',B,'B2',B2,'C',C,'D2',zeros(size(C,1),size(B2,2)),'D1',D);


%Hinf control
Winf = W(3,5); 
Cinf = C(Winf); 
Dinf = D(Winf,3,7.3);
matrices_hinf = matrices(Cinf,Dinf);

hinf = HinfConstr();
contrHinf = Controllers(matrices_hinf, hinf, 1);
[Kinf, minval] = contrHinf.solve

sys_cl_hinf = ss(A + B*Kinf, B2, matrices_hinf.C + matrices_hinf.D1*Kinf, matrices_hinf.D2);


K = Kinf;
sim_hinf = sim("Simullink/nlmodel.slx");
x_hinf = sim_hinf.state.Data;
y_hinf = sim_hinf.output.Data;
u_hinf = sim_hinf.input.Data;

%% H2 control
W2 = W(2,6); 
C2 = C(W2); 
D2 = D(W2,1,3);
matrices_h2 = matrices(C2,D2);

h2 = H2Constr();
contrH2 = Controllers(matrices_h2, h2, 1);
[Kh2, minvalH2] = contrH2.solve

sys_cl_h2 = ss(A + B*Kh2, B2, matrices_h2.C + matrices_h2.D1*Kh2, matrices_h2.D2);
h2_theoretic = norm(sys_cl_h2,2)
eig(sys_cl_h2)

K = Kh2;
sim_h2 = sim("Simullink/nlmodel.slx");
x_h2 = sim_h2.state.Data;
y_h2 = sim_h2.output.Data;
u_h2 = sim_h2.input.Data;


%% L1 control
W1 = W(3,8); 
C1 = C(W1); 
D1 = D(W1,10,5);
matrices_l1 = matrices(C1,D1);

l1 = L1Constr();
contrL1 = Controllers(matrices_l1, l1, 1);
[Kl1, minvalL1] = contrL1.solve

sys_cl_l1 = ss(A + B*Kl1, B2, matrices_l1.C + matrices_l1.D1*Kl1, matrices_l1.D2);
eig(sys_cl_l1)

K = Kl1;
sim_l1 = sim("Simullink/nlmodel.slx");
x_l1 = sim_l1.state.Data;
y_l1 = sim_l1.output.Data;
u_l1 = sim_l1.input.Data;


%% Multi-obj

% Hinf + Rstab
circle = Circle(40,0);
cone = Cone(pi/12);
sp = SemiPlane(10);

% Multi-objective controller synthesis
reg = Region([circle,cone,sp]);
contrMulti = Controllers(matrices_hinf, [hinf,reg], [1,0]);
[Kmulti, minvalMulti] = contrMulti.solve

K = Kmulti;
sim_hinf_r = sim("Simullink/nlmodel.slx");
x_hinf_r = sim_hinf_r.state.Data;
y_hinf_r = sim_hinf_r.output.Data;
u_hinf_r = sim_hinf_r.input.Data;

