classdef L1Constr < Constraints
    %HINFCONSTR Summary of this class goes here
    %   Detailed explanation goes here

    methods
        function [lmis, objective] = build(obj, matrices, vars)
            X = vars.X;
            Y = vars.Y;

            mu = vars.mu;
            psi = vars.psi;

            A = matrices.A;
            B1 = matrices.B1;
            B2 = matrices.B2;
            C3 = matrices.C;
            D32 = matrices.D1;
            D31 = matrices.D2;

            lambda = -max(real(eig(A))) + 10; %10

            n = length(A);
            z = size(C3,1);
            m = size(B1,2);
            d = size(B2,2);

            constr1 = [(A*X + B1*Y)+(A*X + B1*Y)'+ lambda*X,      B2;
                            B2',                                   -mu * eye(d)
                ];

            constr2 = [lambda*X,                  zeros(n,d),               (C3*X+D32*Y)';
                       zeros(d,n),                (psi-mu)*eye(d),            D31';
                       (C3*X+D32*Y),                      D31,                     psi*eye(z) 
                      ];

            lmis = [constr1 <= -obj.tol*eye(d+n);
                constr2 >= obj.tol * eye(n+d+z);
                X >= obj.tol * eye(n);
                mu >= obj.tol;
                ];

            objective = psi;

        end
    end
end