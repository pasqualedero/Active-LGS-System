classdef(Abstract=true) GeomConstr < matlab.mixin.Heterogeneous & handle
    %CONSTRAINTS Abstract constraints
    %   Abstract constraints
    methods (Abstract)
        % vars is a struct containing shared sdpvars (e.g: vars.Q, vars.Y, vars.gamma)
        [L,M] = build(obj)
    end
end