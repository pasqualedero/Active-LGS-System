classdef HinfConstr < Constraints
    %HINFCONSTR Summary of this class goes here
    %   Detailed explanation goes here

    methods
        function [lmis, objective] = build(obj, matrices, vars)
            X = vars.X;
            Y = vars.Y;
            gamma = vars.gamma;

            A = matrices.A;
            B1 = matrices.B1;
            B2 = matrices.B2;
            C1 = matrices.C1;
            D11 = matrices.D11;
            D12 = matrices.D12;

            constr = [ (A*X + B1*Y) + (A*X + B1*Y)', B2, (C1*X + D12*Y)'; ...
            B2', -gamma * eye(size(B2,2)), D11'; ...
            (C1*X + D12*Y), D11, -gamma * eye(size(D11,1)) ];

            lmis = [constr <= -obj.tol*eye(length(constr)); X >= obj.tol*eye(length(X))];
            objective = gamma;
               
        end
    end
end