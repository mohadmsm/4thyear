function [num,den] = constrained_rationalfit(freq,resp)
    % Enforce conjugate pairs and DC constraint
    fit = rationalfit(freq,resp,12); % Target 12 poles
    
    % Pole processing
    poles = fit.A;
    % Mirror unstable poles to LHP
    poles(real(poles)>0) = conj(poles(real(poles)>0)); 
    % Enforce conjugate pairs
    poles = unique([poles; conj(poles(imag(poles)~=0))]);
    
    % Recalculate residues with DC constraint
    [num,den] = residue(fit.C,poles);
    % Enforce DC match
    num(end) = real(resp(1)) - sum(num./(-poles)); 
end