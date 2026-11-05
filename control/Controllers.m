classdef Controllers < handle
    %CONTROLLERS H2, L1, Hinf 
    %   Class for optimal controllers

    properties
        matrices
        con      % list of constraints
        weights  % list of weights

    end

    methods
        function obj = Controllers(matrices, con, weights)
            % plant -> A, B1 (input), B2 (noise)
            % cost  -> C, D1 (input), D2 (noise)
            obj.matrices = matrices; 
            obj.con = con;
            obj.weights = weights;
        end

        function [K, minval] = solve(obj)
            clear("yalmip");

            n = length(obj.matrices.A);
            m = size(obj.matrices.B1, 2);
            z = size(obj.matrices.C, 1);

            vars.X = sdpvar(n,n,'symmetric');
            vars.Y = sdpvar(m,n,'full');
            vars.Q = sdpvar(z,z,'symmetric');
           
            vars.gamma = sdpvar(1);
            vars.rho = sdpvar(1);
            vars.mu = sdpvar(1);
            vars.psi = sdpvar(1);

            lmis = [];
            objectives = 0;

            for i = 1 : length(obj.con)
                [lmi, objective] = obj.con(i).build(obj.matrices, vars);
                lmis = [lmis,lmi];
                objectives = objectives + obj.weights(i) * objective;
            end
                
            options = sdpsettings('solver', 'mosek', 'verbose', 0);
            sol = optimize(lmis, objectives, options);
            
            if sol.problem ~= 0
                error('Controller optimization failed: %s', sol.info);
            end
            
            K = value(vars.Y) / value(vars.X);
            minval = value(objectives);

            if isa(obj.con, 'H2Constr')
                minval = sqrt(minval);
            end

        end
    end
end