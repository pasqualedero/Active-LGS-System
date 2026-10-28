%% Plot Comparison of States: Open-Loop (Noise) vs. H-infinity vs. H2
figure('Name', 'Aircraft Active Suspension - State Trajectories', ...
       'Color', 'w', 'Position', [100, 50, 1100, 850]);

% Retrieve simulation time vectors
t_free = sim_freeNoise.state.Time;
t_hinf = sim_hinf.state.Time;
t_h2   = sim_h2.state.Time;

% State descriptions and units based on system coordinates
state_labels = {
    'x_1: Front Strut Deflection (z_a - l_f\phi - z_f)', '[m]';
    'x_2: Front Tire Deflection (z_f)',                 '[m]';
    'x_3: Front Fuselage Velocity (dz_a - l_f d\phi)',  '[m/s]';
    'x_4: Front Wheel Velocity (dz_f)',                 '[m/s]';
    'x_5: Main Strut Deflection (z_a + l_m\phi - z_m)',  '[m]';
    'x_6: Main Tire Deflection (z_m)',                  '[m]';
    'x_7: Main Fuselage Velocity (dz_a + l_m d\phi)',   '[m/s]';
    'x_8: Main Wheel Velocity (dz_m)',                  '[m/s]'
};

% Line specifications
color_free = [0.45, 0.45, 0.45]; % Gray (dashed)
color_hinf = [0.85, 0.33, 0.10]; % Red/Orange
color_h2   = [0.00, 0.45, 0.74]; % Blue

for i = 1:8
    subplot(4, 2, i);
    hold on;
    
    p1 = plot(t_free, x_free_noise(:, i), '--', 'Color', color_free, 'LineWidth', 1.0);
    p2 = plot(t_hinf, x_hinf(:, i),       '-',  'Color', color_hinf, 'LineWidth', 1.1);
    p3 = plot(t_h2,   x_h2(:, i),         '-',  'Color', color_h2,   'LineWidth', 1.1);
    
    ylabel(state_labels{i, 2}, 'FontWeight', 'bold');
    title(state_labels{i, 1}, 'FontSize', 9, 'FontWeight', 'bold');
    grid on;
    box on;
    set(gca, 'FontSize', 9);
    
    if i >= 7
        xlabel('Time [s]', 'FontWeight', 'bold');
    end
    
    % Shared legend on the first subplot
    if i == 1
        legend([p1, p2, p3], {'Open-Loop (Noise)', 'H_\infty Control', 'H_2 Control'}, ...
               'Location', 'northeast', 'FontSize', 8);
    end
    
    hold off;
end

sgtitle('Aircraft Landing Gear Response Comparison', 'FontSize', 14, 'FontWeight', 'bold');










figure('Name', 'Aircraft Active Suspension - Output', ...
       'Color', 'w', 'Position', [100, 50, 1100, 850]);

% Retrieve simulation time vectors
t_free = sim_freeNoise.state.Time;
t_hinf = sim_hinf.state.Time;
t_h2   = sim_h2.state.Time;

% State descriptions and units based on system coordinates
out_labels = {
    'y_1: acc. of fuselage', '[m/s^2]';
    'y_2: angular acc. of fuselage','[m/s^2]'
};

% Line specifications
color_free = [0.45, 0.45, 0.45]; % Gray (dashed)
color_hinf = [0.85, 0.33, 0.10]; % Red/Orange
color_h2   = [0.00, 0.45, 0.74]; % Blue

for i = 1:2
    subplot(2, 1, i);
    hold on;
    
    p1 = plot(t_free, y_free_noise(:, i), '--', 'Color', color_free, 'LineWidth', 1.0);
    p2 = plot(t_hinf, y_hinf(:, i),       '-',  'Color', color_hinf, 'LineWidth', 1.1);
    p3 = plot(t_h2,   y_h2(:, i),         '-',  'Color', color_h2,   'LineWidth', 1.1);
    
    ylabel(out_labels{i, 2}, 'FontWeight', 'bold');
    title(out_labels{i, 1}, 'FontSize', 9, 'FontWeight', 'bold');
    grid on;
    box on;
    set(gca, 'FontSize', 9);
    
    if i >= 7
        xlabel('Time [s]', 'FontWeight', 'bold');
    end
    
    % Shared legend on the first subplot
    if i == 1
        legend([p1, p2, p3], {'Open-Loop (Noise)', 'H_\infty Control', 'H_2 Control'}, ...
               'Location', 'northeast', 'FontSize', 8);
    end
    
    hold off;
end

sgtitle('Aircraft Landing Gear Response Comparison', 'FontSize', 14, 'FontWeight', 'bold');







figure('Name', 'Aircraft Active Suspension - Inputs', ...
       'Color', 'w', 'Position', [100, 50, 1100, 850]);

% State descriptions and units based on system coordinates
out_labels = {
    'u_1: control input (front)', '[N]';
    'u_2: control input (rear)','[N]'
};

% Line specifications
color_hinf = [0.85, 0.33, 0.10]; % Red/Orange
color_h2   = [0.00, 0.45, 0.74]; % Blue

for i = 1:2
    subplot(2, 1, i);
    hold on;
    
    p2 = plot(t_hinf, u_hinf(:, i),       '-',  'Color', color_hinf, 'LineWidth', 1.1);
    p3 = plot(t_h2,   u_h2(:, i),         '-',  'Color', color_h2,   'LineWidth', 1.1);
    
    ylabel(out_labels{i, 2}, 'FontWeight', 'bold');
    title(out_labels{i, 1}, 'FontSize', 9, 'FontWeight', 'bold');
    grid on;
    box on;
    set(gca, 'FontSize', 9);
    
    if i >= 7
        xlabel('Time [s]', 'FontWeight', 'bold');
    end
    
    % Shared legend on the first subplot
    if i == 1
        legend([p2, p3], {'H_\infty Control', 'H_2 Control'}, ...
               'Location', 'northeast', 'FontSize', 8);
    end
    
    hold off;
end

sgtitle('Aircraft Landing Gear Response Comparison', 'FontSize', 14, 'FontWeight', 'bold');