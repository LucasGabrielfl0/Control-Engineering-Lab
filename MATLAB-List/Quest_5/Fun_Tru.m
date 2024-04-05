function [nTru,dTru] = Fun_Tru(Ng,Dg,Nk,Dk)
    Gs=tf(Ng,Dg);
    Ks=tf(Nk,Dk);
    Tru=feedback(Ks,Gs);
    [nTru,dTru] = tfdata(Tru);
end