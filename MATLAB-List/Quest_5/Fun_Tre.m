function [nTre,dTre] = Fun_Tre(Ng,Dg,Nk,Dk)
    Gs=tf(Ng,Dg);
    Ks=tf(Nk,Dk);
    Tre=feedback(1,Gs*Ks);
    [nTre,dTre] = tfdata(Tre);
end