classdef Cone < GeomConstr
    %CIRCLE Summary of this class goes here
    %   Detailed explanation goes here

    properties
        theta
    end

    methods
        function obj = Cone(theta)
            obj.theta = theta;
        end

        function [L,M] = build(obj)
            theta = obj.theta;
            L = zeros(2,2);
            M = [sin(theta), cos(theta);
                -cos(theta),   sin(theta)];
        end
    end
end