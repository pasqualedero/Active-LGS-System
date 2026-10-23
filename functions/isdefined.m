function bool = isdefined(M,definit)
%ISDEFINED Check definiteness
%   Check definiteness of M
arguments (Input)
    M {mustBeMatrix}
    definit string {mustBeMember(definit, {'positive','negative','semipos','semineg'})}
end

clear("yalmip");
switch definit
    case 'positive'
        bool = all(eig(M)>0);
    case 'negative'
        bool = all(eig(M)<0);
    case 'semipos'
        bool = all(eig(M)>=0);
    case 'semineg'
        bool = all(eig(M)<=0);
end

if bool
    fprintf('%s is %s definite\n', inputname(1), definit);
else
    warning('%s is not %s definite.', inputname(1), definit);
end
end