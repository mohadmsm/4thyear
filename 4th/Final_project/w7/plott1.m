% --- Plotting functions called by 1D NILT, vector version ----
%----------- Multiple plotting into single figure -------------
function plott1(t,ft)
figure; plot(t,real(ft)); grid on;
%figure; plot(t,imag(ft)); grid on; % optional

% --