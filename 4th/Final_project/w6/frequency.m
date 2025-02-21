clear
clc

% Transmission line parameters (from the appendix)
l = 0.635;          % Length (m)
L_total = 539e-9;   % Total inductance (H)
C_total = 39e-12;   % Total capacitance (F)
R = 0;              % Lossless
G = 0;

% Frequency range (up to 4 GHz to capture all resonances)
f = 0:1e7:1e9;      % 0 to 4 GHz in 10 MHz steps
w = 2*pi*f;

% Resonant frequencies from the appendix (in Hz)
resonant_freqs = [1.08, 2.16, 3.24] * 1e9; % Convert GHz to Hz

% Modal transfer functions (simplified for illustration)
% Each mode contributes to the admittance spectrum
Y_in = zeros(size(f)); % Initialize admittance
for fr = resonant_freqs
    % Modal contribution (simplified as a Lorentzian peak)
    Y_in = Y_in + 1./(1 + 1i*(f - fr/1e9)*1e-9); % Adjust scaling as needed
end

% Plot the amplitude spectrum
figure;
plot(f/1e9, abs(Y_in), 'b', 'LineWidth', 1.5);
hold on;

% Mark expected resonant frequencies
for fr = resonant_freqs/1e9
    xline(fr, '--r', sprintf('%.2f GHz', fr));
end

xlabel('Frequency (GHz)');
ylabel('|Admittance| (S)');
title('Amplitude Spectrum vs. Frequency');
grid on;
legend('Estimated', 'Exact Resonances');