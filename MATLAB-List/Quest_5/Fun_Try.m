function [nTry,dTry] = Fun_Try(Ng,Dg,Nk,Dk)
    Gs=tf(Ng,Dg);
    Ks=tf(Nk,Dk);
    Try=feedback(Gs*Ks,1);
    [nTry,dTry] = tfdata(Try);
end