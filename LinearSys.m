classdef LinearSys
    %LINEARSYS Implements a linear system
    %   Implements a linear system

    properties
        % nominal
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
        m
        p
    end

    methods
        % constructor
        function obj = LinearSys(A,B,C,D)
            obj.A = A;
            obj.B = B;
            obj.C = C;
            obj.D = D;
        end

        % getters
        function value = get.n(obj)
            value = size(obj.A, 1);
        end

        function value = get.m(obj)
            value = size(obj.B, 2);
        end

        function value = get.p(obj)
            value = size(obj.C, 1);
        end

        % methods
        function P = lyapStab(obj)
            clear("yalmip")
            n = obj.n; eps = obj.eps; A = obj.A;
            P = sdpvar(n, n, 'symmetric');
            constraints = [P >= eps*eye(n), A' * P + P * A <= -eye(n)*eps];
            options = sdpsettings('solver','mosek','verbose',0);
            sol = optimize(constraints, [], options);
            if sol.problem == 0
                P = value(P);
            else
                error('Lyapunov inequality infeasible: %s', sol.info);
            end
        end
       
    end
end