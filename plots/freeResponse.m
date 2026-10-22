figure('Name', 'Front LGS States', 'Color', 'w');

subplot(4,1,1);
plot(t, x(:,1), 'LineWidth', 1.5);
ylabel('x_1 (m)');
title('Front Suspension Deflection (x_1)');
grid on;

subplot(4,1,2);
plot(t, x(:,2), 'LineWidth', 1.5);
ylabel('x_2 (m)');
title('Front Tire Deflection (x_2)');
grid on;

subplot(4,1,3);
plot(t, x(:,3), 'LineWidth', 1.5);
ylabel('x_3 (m/s)');
title('Front Junction Velocity (x_3)');
grid on;

subplot(4,1,4);
plot(t, x(:,4), 'LineWidth', 1.5);
ylabel('x_4 (m/s)');
title('Front Gear Velocity (x_4)');
xlabel('Time (s)');
grid on;

% ---------------------------------------------------------
% Figure 2: Main Landing Gear System (LGS) States
% ---------------------------------------------------------
figure('Name', 'Main LGS States', 'Color', 'w');

subplot(4,1,1);
plot(t, x(:,5), 'LineWidth', 1.5);
ylabel('x_5 (m)');
title('Main Suspension Deflection (x_5)');
grid on;

subplot(4,1,2);
plot(t, x(:,6), 'LineWidth', 1.5);
ylabel('x_6 (m)');
title('Main Tire Deflection (x_6)');
grid on;

subplot(4,1,3);
plot(t, x(:,7), 'LineWidth', 1.5);
ylabel('x_7 (m/s)');
title('Main Junction Velocity (x_7)');
grid on;

subplot(4,1,4);
plot(t, x(:,8), 'LineWidth', 1.5);
ylabel('x_8 (m/s)');
title('Main Gear Velocity (x_8)');
xlabel('Time (s)');
grid on;