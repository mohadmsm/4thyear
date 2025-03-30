function [poles, residues, d, h] = vectorFitAutoPole(f, H)
%VECTORFITAUTOPOLE   Fit a rational function to frequency response via Vector Fitting.
%   [POLES, RESIDUES, D, H] = VECTORFITAUTOPOLE(F, H) produces a rational approximation 
%   of the complex frequency response H(F) using the two-stage vector fitting method&#8203;:contentReference[oaicite:3]{index=3}.
%
%   Inputs:
%       F - Frequency sample vector (in Hz). Should be a column vector (N x 1).
%       H - Complex frequency response values at frequencies F. Also N x 1.
%
%   Outputs:
%       POLES    - Fitted poles (complex values in the s-plane, s = j*2*pi*F).
%                  Complex poles come in conjugate pairs (for real systems).
%       RESIDUES - Residue corresponding to each pole (complex values).
%                  Complex residues will be conjugates for each pole pair.
%       D        - Constant (direct feed-through) term of the fit (real).
%       H        - Proportional term (coefficient of s) of the fit (real).
%
%   The function fits H(s) (with s = j*2*pi*f) to a rational function of the form:
%       H_fit(s) = sum_{n=1}^{N} (residues_n / (s - poles_n)) + d + h*s,
%   where N is the number of poles used in the fit. The poles and residues may be complex; 
%   any complex poles will occur in conjugate pairs with conjugate residues so that H_fit(s) is real for real s.
%
%   The algorithm automatically chooses an initial set of poles based on the span of F&#8203;:contentReference[oaicite:4]{index=4}. 
%   Poles are initialized as complex conjugate pairs with imaginary parts evenly spanning the frequency range 
%   of the data and with small negative real parts (1% of the imaginary part)&#8203;:contentReference[oaicite:5]{index=5}. This provides a good starting 
%   guess and avoids ill-conditioning issues associated with purely real initial poles&#8203;:contentReference[oaicite:6]{index=6}.
%
%   **Algorithm Overview:**
%   1. **Initial Pole Selection:** Determine the number of poles needed and initialize them as complex pairs 
%      over the frequency range of interest&#8203;:contentReference[oaicite:7]{index=7} (real part = -0.01 * imag part).
%   2. **Stage 1 - Pole Relocation:** Solve a linear least-squares problem to find an intermediate rational 
%      approximation that yields a “scaled” function a(s) and a(s)*f(s) sharing the same initial poles&#8203;:contentReference[oaicite:8]{index=8}. 
%      From this, compute the new poles as the zeros of the fitted scaling function a(s)&#8203;:contentReference[oaicite:9]{index=9}. Flip any unstable poles 
%      to the left half-plane (make real part negative)&#8203;:contentReference[oaicite:10]{index=10}.
%   3. **Stage 2 - Residue Identification:** With the new poles fixed, solve another linear least-squares problem 
%      to find the residues, constant term, and proportional term that best fit the original data&#8203;:contentReference[oaicite:11]{index=11}.
%   4. **Output Cleanup:** Ensure residues of conjugate pole pairs are exact conjugates and that d and h are real.
%
%   **Usage Example:**
%       f = linspace(1e3, 1e6, 201).';      % Frequency vector from 1 kHz to 1 MHz
%       H = someSystemResponse(f);         % Complex frequency response (e.g., impedance)
%       [p, r, d, h] = vectorFitAutoPole(f, H);
%       % Evaluate fitted model on f:
%       s = 1j*2*pi*f; 
%       H_fit = sum(r.'./(s.'-p.'), 2) + d + h*s;   % (This reconstructs H_fit for comparison)
%
%   The above will produce pole-residue representation [p, r] and terms [d, h] that approximate H. 
%   For best results, ensure F and H cover the frequency range of interest and include the significant dynamics of the system.
%
%   Reference:
%   B. Gustavsen and A. Semlyen, "Rational approximation of frequency domain responses by vector fitting," 
%   IEEE Trans. Power Delivery, vol. 14, no. 3, pp. 1052-1061, July 1999&#8203;:contentReference[oaicite:12]{index=12}&#8203;:contentReference[oaicite:13]{index=13}.
%

% Ensure column vectors
f = f(:);
H = H(:);
Npts = length(f);
if length(H) ~= Npts
    error('Input vectors f and H must have the same length.');
end

% Convert frequency in Hz to complex angular frequency s = j*2*pi*f
s = 1j * 2*pi * f;

%%% 1. Select number of initial poles and initialize them %%%
% Heuristic for number of pole pairs based on number of samples and data features.
if Npts < 30
    Npairs = 3;                             % minimum 3 pairs for very few points
else
    % Rough estimate: one pole pair per ~20 samples, capped between 4 and 15 pairs
    Npairs = max(4, min(15, round(Npts/20)));
end
Ninit = 2 * Npairs;                         % total number of poles (including conjugates)
% Frequency range
f_min = min(f); 
f_max = max(f);
if f_min < 0
    error('Frequency values should be non-negative (Hz).');
end
% If the data includes DC (0 Hz) and beyond, start just above 0 to avoid pole at 0
f_start = (f_min > 0) * f_min;  % if f_min is 0, f_start becomes 0 (we'll adjust later)
% Linearly spaced imaginary parts from lowest to highest frequency
p_imag = linspace(f_start, f_max, Npairs);
% Ensure the first imaginary is not exactly zero to avoid a pole at s=0 
if f_start == 0
    p_imag(1) = p_imag(2) / 10;  % set a small value (one order lower than next) if initial was zero
end
% Real part attenuation factor (1% of imaginary part)&#8203;:contentReference[oaicite:14]{index=14}
p_real = -0.01 * p_imag; 
% Form complex conjugate pole pairs
init_poles = [];
for k = 1:Npairs
    a = p_real(k);
    w = 2*pi * p_imag(k);        % convert Hz to rad/s for s-plane position
    % (Using w = 2*pi*f here ensures poles are in rad/s units consistent with s = j*2*pi*f)
    init_poles(end+1,1) = a + 1j*w;   %#ok<*AGROW> add pole
    init_poles(end+1,1) = a - 1j*w;   % and its conjugate
end

% (Optionally, if the function is expected to be very smooth without resonances,
%  one could use real initial poles distributed in frequency&#8203;:contentReference[oaicite:15]{index=15}. 
%  Here we assume general case with possible resonant peaks, hence complex poles&#8203;:contentReference[oaicite:16]{index=16}.)

%%% 2. Stage 1: Pole relocation (solve for scaling function coefficients) %%%
N = length(init_poles);  % number of initial poles (should equal Ninit)
a = init_poles;          % shorthand for initial poles array
% Build the linear system A1 * x1 = b1 for Stage 1 (Equation (4) in the paper&#8203;:contentReference[oaicite:17]{index=17})
% Unknowns x1 consist of: E1..EN (scaling function residues), c1..cN (approximate residues), d, h.
% We construct A1 such that:
%    sum_{n=1..N} [E_n * f(s_k)/(s_k - a_n)] - sum_{n=1..N}[c_n/(s_k - a_n)] - d - h*s_k = -f(s_k)
% This yields a linear system A1 * x1 = b1 at all sample points k.

M = Npts;
% Preallocate matrix (M x (2N + 2)) and vector
A1 = zeros(M, 2*N + 2);
b1 = -H;   % right-hand side is -f(s_k) (since we moved f(s) to the right-hand side in eq (4)&#8203;:contentReference[oaicite:18]{index=18})
% Fill columns for each n = 1..N
for n = 1:N
    A1(:, n)       = H ./ (s - a(n));   % coefficient for E_n: f(s_k)/(s_k - a_n)
    A1(:, N + n)   = -1 ./ (s - a(n));  % coefficient for c_n: -1/(s_k - a_n)
end
% Constant term (d) and proportional term (h) columns
A1(:, 2*N + 1) = -1;         % coefficient for d: -1
A1(:, 2*N + 2) = -s;         % coefficient for h: -s_k
% Solve the overdetermined system by least-squares (Ax = b)&#8203;:contentReference[oaicite:19]{index=19}
x1 = A1 \ b1;
% Extract E and c from solution vector
E = x1(1:N);
c_temp = x1(N+1:2*N);
% (d and h from stage 1 are x1(2N+1) and x1(2N+2), but they pertain to the augmented equation, not directly used further.)

% Compute the new poles as the zeros of a(s) = 1 + sum_{n=1..N} E_n/(s - a_n)&#8203;:contentReference[oaicite:20]{index=20}.
% a(s) = 0 implies 1 + sum_n E_n/(s - a_n) = 0  =>  sum_n E_n/(s - a_n) = -1.
% Multiply both sides by ∏(s - a_n): ∑_n E_n ∏_{m≠n}(s - a_m) + ∏_{m=1..N}(s - a_m) = 0.
% This yields a polynomial of degree N; its roots are the new pole locations&#8203;:contentReference[oaicite:21]{index=21}.
% We will construct this polynomial by summing partial terms.

% Compute polynomial coefficients for P(s) = ∏_{m=1..N} (s - a_m).
P_coeff = poly(a);        % polynomial with roots = a (size N+1 vector, leading coeff 1).
% Construct polynomial Q(s) = ∏(s - a_m) + ∑_{n=1..N} E_n * ∏_{m≠n}(s - a_m).
% Note: ∏_{m≠n}(s - a_m) = P(s) / (s - a_n). We can get its coeff by polynomial division or synthetic division.
Npoly = length(P_coeff) - 1;   % degree N
Q_coeff = zeros(1, Npoly+1);   % polynomial coefficients for Q(s)
% Start with Q(s) = P(s) (coeff)
Q_coeff = P_coeff;
% Add each term E_n * (P(s)/(s - a_n))
for n = 1:N
    % Divide P(s) by (s - a_n) to get R_n(s) = ∏_{m≠n}(s - a_m)
    R_coeff = deconv(P_coeff, [1, -a(n)]);  % polynomial division by (s - a_n)
    % Add E_n * R_coeff to Q_coeff
    Q_coeff_len = length(R_coeff);  % which should be N
    Q_coeff(end-Q_coeff_len+1:end) = Q_coeff(end-Q_coeff_len+1:end) + E(n) * R_coeff;
end
% Now find roots of Q(s) = 0
new_poles = roots(Q_coeff).';
% Ensure column vector form for consistency
new_poles = new_poles(:);

% Stabilize: flip any unstable poles to make them stable (negative real part)&#8203;:contentReference[oaicite:22]{index=22}.
for k = 1:length(new_poles)
    if real(new_poles(k)) > 0
        new_poles(k) = -real(new_poles(k)) + 1j*imag(new_poles(k));
    end
end

%%% 3. Stage 2: Residue identification with updated poles %%%
p = new_poles;   % shorthand for new poles array
N2 = length(p);
% Build linear system A2 * x2 = b2 for Stage 2 (Equation (2) with known poles&#8203;:contentReference[oaicite:23]{index=23}):
% sum_{n=1..N2} [c_n/(s_k - p_n)] + d + h*s_k = H(s_k).
% We set up A2 such that A2 * [c1..cN2, d, h]^T = H (target values).
M2 = Npts;
A2 = zeros(M2, N2 + 2);
b2 = H;   % now the right-hand side is just the original H(s)
for n = 1:N2
    A2(:, n) = 1 ./ (s - p(n));
end
A2(:, N2+1) = 1;    % constant term
A2(:, N2+2) = s;    % proportional term
% Solve least-squares for residues and terms&#8203;:contentReference[oaicite:24]{index=24}
x2 = A2 \ b2;
c_fit = x2(1:N2);
d_fit = x2(N2+1);
h_fit = x2(N2+2);

%%% 4. Enforce conjugate symmetry and real constants for physical consistency %%%
poles = p;
residues = c_fit;
d = real(d_fit);             % ensure constant term is real
h = real(h_fit);             % ensure proportional term is real

% If the system is from real data, complex poles should be in conjugate pairs with conjugate residues.
% We will pair up any complex poles and average their residues to enforce exact conjugates.
tol = 1e-8;
used = false(size(poles));
for i = 1:length(poles)
    if ~used(i)
        pi = poles(i);
        if abs(imag(pi)) < tol
            % Real pole (no pair)
            poles(i)    = real(pi);
            residues(i) = real(residues(i));   % residue should be real for a real pole
            used(i) = true;
        else
            % Find its conjugate partner
            conj_index = find(~used & abs(real(poles) - real(pi)) < tol & ...
                               abs(imag(poles) + imag(pi)) < tol & imag(poles) < 0);
            if ~isempty(conj_index)
                j = conj_index(1);
                % Average the residues to ensure conjugate symmetry
                r_i = residues(i);
                r_j = residues(j);
                new_r_i = (r_i + conj(r_j)) / 2;
                new_r_j = conj(new_r_i);
                residues(i) = new_r_i;
                residues(j) = new_r_j;
                % Ensure pole values are exactly conjugates as well
                poles(i) = (pi + conj(poles(j)))/2;
                poles(j) = conj(poles(i));
                used(i) = true;
                used(j) = true;
            else
                used(i) = true;
            end
        end
    end
end

% Sort poles and residues by increasing imaginary frequency (absolute value)
% to present output in a logical order (real poles first, then lowest to highest frequency pairs).
real_idx = find(abs(imag(poles)) < tol);
comp_idx = find(abs(imag(poles)) >= tol);
% Sort real poles by absolute value (smallest magnitude first)
[~, order_real] = sort(abs(real(poles(real_idx))));
real_idx = real_idx(order_real);
% Sort complex poles by positive imaginary part value
% (group pairs by their positive frequency)
pos_idx = comp_idx(imag(poles(comp_idx)) > 0);
[~, order_pos] = sort(imag(poles(pos_idx)));
pos_idx = pos_idx(order_pos);
% For each positive index, ensure its conjugate index is immediately after
sorted_idx = [real_idx; zeros(size(pos_idx)); zeros(size(pos_idx))];
% Now append complex pairs in sorted order
count = length(real_idx);
for m = 1:length(pos_idx)
    ipos = pos_idx(m);
    % find its conjugate (should exist in comp_idx)
    iconj = find(abs(poles - conj(poles(ipos))) < tol, 1);
    if isempty(iconj)
        iconj = ipos;  % safety (should not happen)
    end
    sorted_idx(count+1) = ipos;
    sorted_idx(count+2) = iconj;
    count = count + 2;
end
sorted_idx(sorted_idx == 0) = [];  % remove any unused slots
poles    = poles(sorted_idx);
residues = residues(sorted_idx);

% Final outputs: poles, residues, d, h (already set).
end
