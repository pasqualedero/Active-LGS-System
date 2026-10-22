clear; close all; clc;
addpath Simullink/ plots/

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

x0 = [0.018 -0.011 0.012 0.015 -0.015 0.011 0.011 0.011]';

dzf_0 = x0(4); 
dzm_0 = x0(8); 

% 2. Landing Gear Positions (mapped from states x2 and x6[cite: 3])
zf_0 = x0(2); 
zm_0 = x0(6); 

% 3. Fuselage Position (za) and Pitch Angle (phi)
% First, find the initial heights of the suspension junctions[cite: 3]
zaf_0 = x0(1) + zf_0; 
zam_0 = x0(5) + zm_0; 

% Exact nonlinear geometric inverse (using asin)
phi_0 = asin((zam_0 - zaf_0) / (params.lf + params.lm));
za_0  = zam_0 - params.lm * sin(phi_0);

% 4. Fuselage Velocity (dza) and Pitch Rate (dphi)
% Extract junction velocities from states x3 and x7
dzaf_0 = x0(3); 
dzam_0 = x0(7); 

% Exact nonlinear velocity inverse (dividing by cos(phi_0))
dphi_0 = (dzam_0 - dzaf_0) / ((params.lf + params.lm) * cos(phi_0));
dza_0  = dzam_0 - params.lm * dphi_0 * cos(phi_0);

simout = sim("Simullink/nlmodel.slx");

t = simout.state.Time; 
x = simout.state.Data; 


