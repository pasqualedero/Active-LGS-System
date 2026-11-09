classdef Region < Constraints
    %REGION Summary of this class goes here
    %   Detailed explanation goes here

    properties
        geomConstr;
    end

    properties(Dependent=true)
        L;
        M;
    end

    methods

        function obj = Region(geomConstr)
            obj.geomConstr = geomConstr;
        end

        function [lmis, objective] = build(obj, matrices, vars)
            X = vars.X;
            Y = vars.Y;

            A = matrices.A;
            B1 = matrices.B1;

            n = length(A);
            m = size(B1,2);

            cl = A*X + B1*Y;

            lmis = [kron(obj.L,X) + kron(obj.M,cl) + kron(obj.M',cl') <= -obj.tol * eye(length(obj.L)*length(X))];

            objective = 0;
               
        end

        function value = get.L(obj)
            [L_list,~] = arrayfun(@(x) x.build(), obj.geomConstr, 'UniformOutput',false);
            value = blkdiag(L_list{:});
        end

        function value = get.M(obj)
            [~,M_list] = arrayfun(@(x) x.build(), obj.geomConstr, 'UniformOutput',false);
            value = blkdiag(M_list{:});
        end

        function add(obj, shape)
            obj.geomConstr(end + 1) = shape;
        end

    end

end