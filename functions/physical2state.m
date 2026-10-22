function x0 = physical2state(za_0, phi_0, zf_0, zm_0, dza_0, dphi_0, dzf_0, dzm_0, params)
    % Initialize the 8x1 state vector
    x0 = zeros(8, 1);
    
    % 1. Calculate nonlinear junction positions
    zaf_0 = za_0 - params.lf * sin(phi_0);
    zam_0 = za_0 + params.lm * sin(phi_0);
    
    % 2. Calculate nonlinear junction velocities
    dzaf_0 = dza_0 - params.lf * dphi_0 * cos(phi_0);
    dzam_0 = dza_0 + params.lm * dphi_0 * cos(phi_0);
    
    % 3. Map to the paper's state vector x
    x0(1) = zaf_0 - zf_0;
    x0(2) = zf_0;
    x0(3) = dzaf_0;
    x0(4) = dzf_0;
    x0(5) = zam_0 - zm_0;
    x0(6) = zm_0;
    x0(7) = dzam_0;
    x0(8) = dzm_0;
end