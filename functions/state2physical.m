function [za_0, phi_0, zf_0, zm_0, dza_0, dphi_0, dzf_0, dzm_0] = state2physical(x0, params)
    % 1. Landing Gear Velocities
    dzf_0 = x0(4); 
    dzm_0 = x0(8); 
    
    % 2. Landing Gear Positions
    zf_0 = x0(2); 
    zm_0 = x0(6); 
    
    % 3. Fuselage Position and Pitch Angle
    zaf_0 = x0(1) + zf_0; 
    zam_0 = x0(5) + zm_0; 
    phi_0 = asin((zam_0 - zaf_0) / (params.lf + params.lm));
    za_0  = zam_0 - params.lm * sin(phi_0);
    
    % 4. Fuselage Velocity and Pitch Rate
    dzaf_0 = x0(3); 
    dzam_0 = x0(7); 
    dphi_0 = (dzam_0 - dzaf_0) / ((params.lf + params.lm) * cos(phi_0));
    dza_0  = dzam_0 - params.lm * dphi_0 * cos(phi_0);
end