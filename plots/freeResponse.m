%% States
% nonlinear
figure('Name', 'LGS States - Free Response', 'Color', 'w');

subplot(4, 2, 1);
plot(t, x_free(:,1), 'LineWidth', 1.5);
ylabel('x_1 (m)');
title('Front Suspension Deflection');
grid on;

subplot(4, 2, 3);
plot(t, x_free(:,2), 'LineWidth', 1.5);
ylabel('x_2 (m)');
title('Front Tire Deflection');
grid on;

subplot(4, 2, 5);
plot(t, x_free(:,3), 'LineWidth', 1.5);
ylabel('x_3 (m/s)');
title('Front Junction Velocity');
grid on;

subplot(4, 2, 7);
plot(t, x_free(:,4), 'LineWidth', 1.5);
ylabel('x_4 (m/s)');
title('Front Gear Velocity');
xlabel('Time (s)');
grid on;

subplot(4, 2, 2);
plot(t, x_free(:,5), 'LineWidth', 1.5);
ylabel('x_5 (m)');
title('Main Suspension Deflection');
grid on;

subplot(4, 2, 4);
plot(t, x_free(:,6), 'LineWidth', 1.5);
ylabel('x_6 (m)');
title('Main Tire Deflection');
grid on;

subplot(4, 2, 6);
plot(t, x_free(:,7), 'LineWidth', 1.5);
ylabel('x_7 (m/s)');
title('Main Junction Velocity');
grid on;

subplot(4, 2, 8);
plot(t, x_free(:,8), 'LineWidth', 1.5);
ylabel('x_8 (m/s)');
title('Main Gear Velocity');
xlabel('Time (s)');
grid on;

% linearized
figure('Name', 'Landing Gear System States', 'Color', 'w');

subplot(4, 2, 1);
plot(t, xlinearized(:,1), 'LineWidth', 1.5);
ylabel('x_1 (m)');
title('Front Suspension Deflection');
grid on;

subplot(4, 2, 3);
plot(t, xlinearized(:,2), 'LineWidth', 1.5);
ylabel('x_2 (m)');
title('Front Tire Deflection');
grid on;

subplot(4, 2, 5);
plot(t, xlinearized(:,3), 'LineWidth', 1.5);
ylabel('x_3 (m/s)');
title('Front Junction Velocity');
grid on;

subplot(4, 2, 7);
plot(t, xlinearized(:,4), 'LineWidth', 1.5);
ylabel('x_4 (m/s)');
title('Front Gear Velocity');
xlabel('Time (s)');
grid on;

subplot(4, 2, 2);
plot(t, xlinearized(:,5), 'LineWidth', 1.5);
ylabel('x_5 (m)');
title('Main Suspension Deflection');
grid on;

subplot(4, 2, 4);
plot(t, xlinearized(:,6), 'LineWidth', 1.5);
ylabel('x_6 (m)');
title('Main Tire Deflection');
grid on;

subplot(4, 2, 6);
plot(t, xlinearized(:,7), 'LineWidth', 1.5);
ylabel('x_7 (m/s)');
title('Main Junction Velocity');
grid on;

subplot(4, 2, 8);
plot(t, xlinearized(:,8), 'LineWidth', 1.5);
ylabel('x_8 (m/s)');
title('Main Gear Velocity');
xlabel('Time (s)');
grid on;

% linear
figure('Name', 'Landing Gear System States', 'Color', 'w');

subplot(4, 2, 1);
plot(t, xlinear(:,1), 'LineWidth', 1.5);
ylabel('x_1 (m)');
title('Front Suspension Deflection');
grid on;

subplot(4, 2, 3);
plot(t, xlinear(:,2), 'LineWidth', 1.5);
ylabel('x_2 (m)');
title('Front Tire Deflection');
grid on;

subplot(4, 2, 5);
plot(t, xlinear(:,3), 'LineWidth', 1.5);
ylabel('x_3 (m/s)');
title('Front Junction Velocity');
grid on;

subplot(4, 2, 7);
plot(t, xlinear(:,4), 'LineWidth', 1.5);
ylabel('x_4 (m/s)');
title('Front Gear Velocity');
xlabel('Time (s)');
grid on;

subplot(4, 2, 2);
plot(t, xlinear(:,5), 'LineWidth', 1.5);
ylabel('x_5 (m)');
title('Main Suspension Deflection');
grid on;

subplot(4, 2, 4);
plot(t, xlinear(:,6), 'LineWidth', 1.5);
ylabel('x_6 (m)');
title('Main Tire Deflection');
grid on;

subplot(4, 2, 6);
plot(t, xlinear(:,7), 'LineWidth', 1.5);
ylabel('x_7 (m/s)');
title('Main Junction Velocity');
grid on;

subplot(4, 2, 8);
plot(t, xlinear(:,8), 'LineWidth', 1.5);
ylabel('x_8 (m/s)');
title('Main Gear Velocity');
xlabel('Time (s)');
grid on;

%% Measurements
% linearized
figure('Name', 'Landing Gear System States - Outputs', 'Color', 'w');

subplot(2, 2, [1 2]);
plot(t, ylinearized(:,1), 'LineWidth', 1.5);
ylabel('y_1 (m)');
title('Front Suspension Deflection');
grid on;

subplot(2, 2, [3 4]);
plot(t, ylinearized(:,2), 'LineWidth', 1.5);
ylabel('y_2 (m)');
title('Front Tire Deflection');
grid on;

% linear
figure('Name', 'Landing Gear System States - Outputs', 'Color', 'w');

subplot(2, 2, [1 2]);
plot(t, ylinear(:,1), 'LineWidth', 1.5);
ylabel('y_1 (m)');
title('Front Suspension Deflection');
grid on;

subplot(2, 2, [3 4]);
plot(t, ylinear(:,2), 'LineWidth', 1.5);
ylabel('y_2 (m)');
title('Front Tire Deflection');
grid on;