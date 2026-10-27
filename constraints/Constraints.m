classdef(Abstract=true) Constraints < handle
    %CONSTRAINTS Abstract constraints
    %   Abstract constraints

    properties(Constant)
        tol = 1e-8;
    end

    methods (Abstract)
        % vars is a struct containing shared sdpvars (e.g: vars.Q, vars.Y, vars.gamma)
        [lmis, objective] = build(obj, matrices, vars)
    end
end