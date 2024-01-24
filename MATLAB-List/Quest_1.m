%Lista 1:
%Questao 1 ----------------------------------------------------
clc
clear
%zeros, poles and gain:
[z, p, k] = tf2zp([5 30 55 30], [1 9 33 65])