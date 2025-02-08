clear all
clc
N = [-2 -3];% Define the numerator coeff
D = [1 6]; % Define the den coeff
[Q,R]=deconv(N,D);% Perform polynomial division
R = tf(R,D);
R