
%% this works fine, but without using the approximation to approximate the next one 
clear all
clc
t = 0:0.01:10;
% find X(s) = (B(s)+Cx(0))/(G+Cs)
%ie 1/s+0.5, x(0)=0
B = @(s) 1./s;
C = 1;
G = 0.5;
Xo =0;
X_func = @(s) (B(s) + C*Xo)./(G+C.*s);
% Approximation order
M = 8;
[poles, residues] = R_Approximation(M);
result = - (1 ./ t) .*sum(real(X_func(poles./t).*residues));
exact = 2*(1-exp(-0.5*t));
error = abs(exact - result);
% Plot error
plot(t, error);
xlabel('Time (t)');
ylabel('Error');

%% try with changing the initial condinition based on the prev approx p.g 123
clear all
clc
t = 0:0.0001:10;
h = t(2) - t(1); % step size
% find X_hat(s) = (B(s)+Cx(q-1))/(G+Cs)
%ie 1/s+1, x(0)=0
B = @(s) 1./s; % input as a unit step 
C = 1;
G = 0.5;
Xo = 0;
X_func = @(s) (B(s) + C*Xo)./(G+C.*s);
M =7;
[poles, residues] = R_Approximation(M);
%find the first Xo assuming X(0) =0 
result(1) = - (1 / (h)) .*sum(real(X_func(poles/(h)).*residues));
X_prev = result(1);
for i=1:length(t)
    if i>1
    X_prev =result(i-1); %use the previous to approximate the next one
    end
    X_hat = @(s) (B(s) + C*X_prev)./(G+C.*s); %X_hat as per p.g123
    result(i) =  - (1 ./ (h)) .*sum(real(X_hat(poles./(h)).*residues));
end
exact = 2*(1-exp(-0.5*t));
error = abs(exact - result);
% Plot error
plot(t, error);
xlabel('Time (t)');
ylabel('Error');
% Display results
%%
% ode45 vs NILT (1/s+0.5) and unit step input
clear all, clc;
F = @(t,y) -0.5*y + 1; % defind dy/dt = -y+1
tspan  = 0:0.01:10;
h = tspan(2) - tspan(1);
[t, y] = ode45(F,tspan,0);
%use NILT0 with prev step
B = @(s) 1./s; % input as a unit step 
C = 1;
G = 0.5;
Xo = 0;
X_func = @(s) (B(s) + C*Xo)./(G+C.*s);
M = 10;
[poles, residues] = R_Approximation(M);
%find the first Xo assuming X(0) =0 
NILT0_result(1) = - (1 / (h)) .*sum(real(X_func(poles/(h)).*residues));
for i=2:length(t)
    X_prev =NILT0_result(i-1); %use the previous to approximate the next one
    X_hat = @(s) (B(s) + C*X_prev)./(G+C.*s); %X_hat as per p.g123
    NILT0_result(i) =  - (1 ./ (h)) .*sum(real(X_hat(poles/(h)).*residues));
end

exact = 2*(1-exp(-0.5*tspan));
NILT_err = abs(NILT0_result-exact);
exact = exact.';
ode_err = abs(y-exact);

% Plot the results
figure(1);

% Plot ode45 result
subplot(2, 2, 1);
plot(t, y(:,1), "Color", "blue");
xlabel('Time (s)');
ylabel('v_0(t) (V)');
title('ODE45 Solution');

% Plot NILT result
subplot(2, 2, 2);
plot(tspan, NILT0_result, "Color", "green");
xlabel('Time (s)');
ylabel('v_0(t) (V)');
title('NILT Solution at M = 5');

% Plot ode45 error
subplot(2, 2, 3);
plot(t, ode_err, "Color", "red");
xlabel('Time (s)');
ylabel('Error (V)');
title('ODE45 Solution Error');

% Plot NILT error
subplot(2, 2, 4);
plot(tspan, NILT_err, "Color", "magenta");
xlabel('Time (s)');
ylabel('Error (V)');
title('NILT Solution Error at M = 5');
