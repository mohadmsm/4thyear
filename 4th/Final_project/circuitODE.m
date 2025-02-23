function dydt = circuitODE(t, y, R,L,C,vs)
    dydt = zeros(2,1);
    dydt(1) = y(2);
    dydt(2) = - (R/L) * y(2) - (1/(L*C)) * y(1) + (1/(L*C)) * vs;
end