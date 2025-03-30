function val = conv_sine_term(p, omega, t1, t2)
    % Returns integral of e^{p*(tau-t2 )} sin(omega*tau) from tau=t1 to tau=t2    
    % Evaluate indefinite integral at the two boundary points:
    a = -p;  % because inside the integral we have e^{-p tau}
    b = omega;
    
    % Helper inline
    F = @(tau) exp(a*tau).*( a*sin(b*tau) - b*cos(b*tau) )/(a^2 + b^2);
    
    val = exp(p*t2) * ( F(t2) - F(t1) );
end
