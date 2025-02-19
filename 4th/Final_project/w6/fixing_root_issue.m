%%
clear all
clc
A = [0, 1, 0;
     0, 0, 1;
     1,-5.9857e+11,-3.2358e+05];
B = [0; 0; 1];
C = [0; 6.1346e+11;-1.7130e+05];
D=0;
%AWE
 t = linspace(0,20e-5,250);
    q = length(B);
    num_moments = 2 * q;
    f = 1e5;
    w0 =2*pi*f;
    s0=i*w0;
    moments = zeros(1, num_moments);
    [r,c]=size(C);
    if r~=1
        C= C';
    end
    for k = 1:num_moments
        moments(k) = (-1)^(k-1) * C * ((s0 * eye(size(A))) - A)^-(k) * B;
    end
    moments(1)=moments(1)+D;
    approx_order = length(B);

    % Construct the moment matrix
    moment_matrix = zeros(approx_order);
    Vector_c = -moments(approx_order+1:2*approx_order)';

    for i = 1:approx_order
        moment_matrix(i, :) = moments(i:i+approx_order-1);
    end

    % Solve for denominator coefficients
    b_matrix = moment_matrix^-1 * Vector_c;

    % Compute poles
    poles = roots([b_matrix', 1]);

    % Compute residues
    V = zeros(approx_order);
    for i = 1:approx_order
        for j = 1:approx_order
            V(i, j) = 1 / (poles(j)^(i-1));
        end
    end

    A_diag = diag(1 ./ poles);
    r_moments = moments(1:approx_order);
    residues = -1 * (A_diag \ (V \ r_moments'));

    % Impulse response
    h_impulse = zeros(size(t));
    for i = 1:approx_order
        h_impulse = h_impulse + residues(i) * exp(poles(i) * t);
    end
    h_s = 0;
    f = 0:10:1e6;
    w = linspace(0.9 * w0, 2 * w0, 1000);
    s=i*w;
    %s=s-s0;
    for i = 1:approx_order
        h_s = h_s + residues(i)./(s-poles(i));
    end
    %h_s = 30./s;
    plot(w./(2*pi),h_s)
    % Step response using recursive convolution
    y_step = zeros(size(t));
    y = zeros(length(poles), 1);

    for n = 2:length(t)
        dt = t(n) - t(n-1);
        exp_term = exp(poles * dt);
        for i = 1:length(poles)
            y(i) = residues(i) * (1 - exp_term(i))/(-poles(i)) * 30 + exp_term(i) * y(i);
        end
        y_step(n) = sum(y);
    end
  %  plot(t,y_step)
%%
clear all
clc
f = 0:10:1e5;
s=i*2*pi*f;
plot(f,h_s)
