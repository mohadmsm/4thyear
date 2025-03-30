function val = exactSinIntegral(p, omega, dt, tn)
% integrateExpSin: returns
%   \int_{t1}^{t2} e^{p*tau} sin(omega*tau) d tau
%
% done via the standard closed-form approach:
%   = Im{ ( e^{(p + j*omega)*tau } ) / (p + j*omega ) } from t1..t2

    numerator = exp((p + 1j*omega)*t2) - exp((p + 1j*omega)*t1);
    denom     = p + 1j*omega;
    val       = imag( numerator / denom );
end
