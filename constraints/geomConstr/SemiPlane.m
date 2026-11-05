classdef SemiPlane < GeomConstr
    %CIRCLE Summary of this class goes here
    %   Detailed explanation goes here

    properties
        alpha
    end

    methods
        function obj = SemiPlane(alpha)
            obj.alpha = alpha;
        end

        function [L,M] = build(obj)
            alpha = obj.alpha;
            L = 2*alpha;
            M = 1;
        end
    end
end