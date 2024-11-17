clear all,clc,close all
syms t 
A = [0 2; -3 -5];
B = [0;1];
C= [1 0];
eat = expm(A*t);
y = mtimes(mtimes(C,eat),B);% example pg26
