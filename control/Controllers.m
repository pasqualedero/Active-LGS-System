classdef Controllers < handle
    %CONTROLLERS H2, L1, Hinf 
    %   Class for optimal controllers

    properties
        matrices
        con 
        weights

    end

    methods
        function obj = Controllers(matrices, con, weights)
            obj.matrices = matrices;
            obj.con = con;
            obj.weights = weights;
        end

        function [K, minval] = solve(obj)
            clear("yalmip");

            n = length(obj.matrices.A);
            m = size(obj.matrices.B1, 2);

            vars.X = sdpvar(n,n,'symmetric');
            vars.Y = sdpvar(m,n,'full');
            vars.Q = sdpvar(12,12,'symmetric');
           
            vars.gamma = sdpvar(1);
            vars.rho = sdpvar(1);

            [lmis, objective] = obj.con.build(obj.matrices, vars);

            options = sdpsettings('solver', 'mosek', 'verbose', 0);
            sol = optimize(lmis, objective, options);
            
            if sol.problem ~= 0
                error('Controller optimization failed: %s', sol.info);
            end
            
            K = value(vars.Y) / value(vars.X);
            minval = value(objective);

            if isa(obj.con, 'H2Constr')
                minval = sqrt(minval);
            end

        end
    end
end