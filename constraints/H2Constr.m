classdef H2Constr < Constraints
    %HINFCONSTR Summary of this class goes here
    %   Detailed explanation goes here

    methods
        function [lmis, objective] = build(obj, matrices, vars)
            X = vars.X;
            Y = vars.Y;
            Q = vars.Q;
            rho = vars.rho;

            A = matrices.A;
            B1 = matrices.B1;
            B2 = matrices.B2;
            C2 = matrices.C2;
            D22 = matrices.D22;

            n = length(A);

            constr1 = [(A*X + B1*Y)+(A*X + B1*Y)',      B2;
                        B2'                             -eye(size(B2',1))
                        ];

            constr2 = [Q                    (C2*X+D22*Y);
                       (C2*X+D22*Y)'                X
                       ];


            constr3 = trace(Q) - rho;


            lmis = [constr1 <= -obj.tol*eye(n+2); 
                    constr2 >= obj.tol * eye(20); 
                    constr3 <= -obj.tol;
                    X >= obj.tol * eye(n);
                    Q >= obj.tol * eye(12);
                    ];
            
            objective = rho;
               
        end
    end
end