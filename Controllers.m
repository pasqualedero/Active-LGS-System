classdef Controllers < handle
    %CONTROLLERS H2, L1, Hinf
    %   Synthesis of optimal controllers

    properties
        A 
        B
        C
        D
    end

    properties(Constant=true)
        eps = 1e-5;
    end

    properties(Dependent=true,Access=protected)
        n
    end

    methods
        % constructor
        function obj = Controllers(A,B,C,D)
            obj.A = A;
            obj.B = B;
            obj.C = C;
            obj.D = D;
        end

        % getters
        function value = get.n(obj)
            value = size(obj.A, 1);
        end

        function P = lyapStab(obj)
            clear("yalmip")
            n = obj.n; eps = obj.eps; A = obj.A;
            P = sdpvar(n, n, 'symmetric');
            constraints = [P >= eps*eye(n), A' * P + P * A <= -eye(n)*eps];
            options = sdpsettings('solver','mosek');
            sol = optimize(constraints, [], sdpsettings('verbose', 0));
            if sol.problem == 0
                P = value(P);
            else
                error('Lyapunov inequality infeasible: %s', sol.info);
            end
        end
        
    end
end