clear all
clc
A = [0 2 ; -3 -5];
I = eye(size(A));
E = eig(A);
Modal_matrix = @(a) a * I - A ;
