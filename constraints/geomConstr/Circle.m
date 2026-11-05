classdef Circle < GeomConstr
    %CIRCLE Summary of this class goes here
    %   Detailed explanation goes here

    properties
        r
        q
    end

    methods
        function obj = Circle(r,q)
            obj.r = r;
            obj.q = q;
        end

        function [L,M] = build(obj)
            r = obj.r;
            q = obj.q;
            L = [-r, q; q -r];
            M = [0, 1; 0, 0];
        end
    end
end 