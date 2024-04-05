%Lista 1:
%Questao 5 ----------------------------------------------------
%for G(s)
Ng=2;
Dg=[1 1];

%for K(s)
Nk=[1 2];
Dk=[1 0];

%Try
[nTry,dTry]=Fun_Try(Ng,Dg,Nk,Dk);
%[Array_Ntry]=cell2mat([nTry,dTry])

%Tre
[nTre, dTre]=Fun_Tre(Ng,Dg,Nk,Dk);
%[Array_Ntre]=cell2mat([nTre,dTre])

%Tru
[nTru,dTru]=Fun_Tru(Ng,Dg,Nk,Dk);
%[Array_Ntru]=cell2mat([nTru,dTru]);