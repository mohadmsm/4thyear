clear;
clc;
step_data = load('step');
vo = step_data(:,2);
time = step_data(:,1);
line_data = load("data_line");
f = line_data(:,1);
v = line_data(:, 2) + 1i*line_data(:, 3);
%{
plot(time,vo);
xlabel('time (s)')
grid on
title('step response')
%}
plot(f,abs(v));
xlabel("Frequency (Hz)")
ylabel("|Vo|")
grid on
title('Frequency response')