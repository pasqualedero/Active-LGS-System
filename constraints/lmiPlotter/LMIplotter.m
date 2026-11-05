classdef LMIplotter < handle
    %LMIPLOTTER Summary of this class goes here
    %   Detailed explanation goes here

    properties
        lmiRegion Region
    end

    methods
        function obj = LMIplotter(lmiRegion)
            obj.lmiRegion = lmiRegion;
        end

        function plot(obj)
            L = obj.lmiRegion.L;
            M = obj.lmiRegion.M;

            xv = linspace(-10, 2, 1000);     % range parte reale
            yv = linspace(-8, 8, 1000);      % range parte immaginaria
            [X, Y] = meshgrid(xv, yv);

            inRegion = false(size(X));
            for k = 1:numel(X)
                z = X(k) + 1j*Y(k);
                F = L + z*M + conj(z)*M.';          % hermitiana
                inRegion(k) = max(real(eig(F))) < 0; % definita negativa?
            end

            figure; hold on; grid on
            contourf(X, Y, double(inRegion), [0.5 0.5], 'FaceAlpha', 0.3);
            colormap([1 1 1; 0.6 0.8 1]);
            contour(X, Y, double(inRegion), [0.5 0.5], 'b', 'LineWidth', 1.5); % bordo
            xline(0, 'k--'); yline(0, 'k--');
            xlabel('Re'); ylabel('Im'); axis equal
            title('LMI Region')
        end
    end
end