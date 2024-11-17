%*************** PLOT2 – FUNCTION DEFINITION ****************%
function pl2                           % plotting into separate figures
global ft t;
for k=1:size(ft,1)
    figure;
    plot(t,ft(k,:)); xlabel('t'); ylabel('f(t)'); grid on;
end