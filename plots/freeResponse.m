figure('Name', 'Landing Gear System States', 'Color', 'w');

subplot(4, 2, 1);
plot(t, x(:,1), 'LineWidth', 1.5);
ylabel('x_1 (m)');
title('Front Suspension Deflection');
grid on;

subplot(4, 2, 3);
plot(t, x(:,2), 'LineWidth', 1.5);
ylabel('x_2 (m)');
title('Front Tire Deflection');
grid on;

subplot(4, 2, 5);
plot(t, x(:,3), 'LineWidth', 1.5);
ylabel('x_3 (m/s)');
title('Front Junction Velocity');
grid on;

subplot(4, 2, 7);
plot(t, x(:,4), 'LineWidth', 1.5);
ylabel('x_4 (m/s)');
title('Front Gear Velocity');
xlabel('Time (s)');
grid on;

subplot(4, 2, 2);
plot(t, x(:,5), 'LineWidth', 1.5);
ylabel('x_5 (m)');
title('Main Suspension Deflection');
grid on;

subplot(4, 2, 4);
plot(t, x(:,6), 'LineWidth', 1.5);
ylabel('x_6 (m)');
title('Main Tire Deflection');
grid on;

subplot(4, 2, 6);
plot(t, x(:,7), 'LineWidth', 1.5);
ylabel('x_7 (m/s)');
title('Main Junction Velocity');
grid on;

subplot(4, 2, 8);
plot(t, x(:,8), 'LineWidth', 1.5);
ylabel('x_8 (m/s)');
title('Main Gear Velocity');
xlabel('Time (s)');
grid on;