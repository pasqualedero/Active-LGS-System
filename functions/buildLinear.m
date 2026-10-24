function [A,B,C,D,Dw] = buildLinear(params)
%BUILDLINEAR Load the model derived in paper

M    = params.M;
Mf   = params.Mf;
Mm   = params.Mm;
Iphi = params.Iphi;
lf   = params.lf;
lm   = params.lm;
kaf  = params.kaf;
kam  = params.kam;
kfr  = params.kfr;
kmr  = params.kmr;

caf  = params.caf_base; 
cam  = params.cam_base;
cfr  = params.cfr_base;
cmr  = params.cmr_base;

a1 = (1/M) + (lf^2 / Iphi);
a2 = (1/M) - (lf * lm / Iphi);
a3 = (1/M) + (lm^2 / Iphi);
a4 = 1 / Mf;
a5 = 1 / Mm;
a6 = 1 / M;
a7 = lf / Iphi;
a8 = lm / Iphi;


Af = [ 0,             0,          1,             -1;
       0,             0,          0,              1;
      -a1*kaf,        0,         -a1*caf,         a1*caf;
       a4*kaf,       -a4*kfr,     a4*caf,        -a4*(caf + cfr) ];

Bf = [ 0,       0;
       0,       0;
       a1,      2*a2;
      -a4,      0 ];

Df = [ 0;
      -1;
       0;
       a4*cfr ];

Am = [ 0,             0,          1,             -1;
       0,             0,          0,              1;
      -2*a3*kam,      0,         -2*a3*cam,       2*a3*cam;
       a5*kam,       -a5*kmr,     a5*cam,        -a5*(cam + cmr) ];

Bm = [ 0,       0;
       0,       0;
       a2,      2*a3;
       0,      -a5 ];

Dm = [ 0;
      -1;
       0;
       a5*cmr ];

Afm = [ 0,           0,   0,           0;
        0,           0,   0,           0;
       -2*a2*kam,    0,  -2*a2*cam,    2*a2*cam;
        0,           0,   0,           0 ];

Amf = [ 0,           0,   0,           0;
        0,           0,   0,           0;
       -a2*kaf,      0,  -a2*caf,      a2*caf;
        0,           0,   0,           0 ];

A = [ Af,  Afm; 
          Amf, Am  ];

B = [ Bf; 
          Bm ];

C = zeros(2,8); C(1,1) = 1; C(2,5) = 1;

D = zeros(2,2);

Df = [ 0;
      -1;
       0;
       a4*cfr ];

Dm = [ 0;
      -1;
       0;
       a5*cmr ];

Dw = [ Df, zeros(4,1); 
          zeros(4,1), Dm ];

end