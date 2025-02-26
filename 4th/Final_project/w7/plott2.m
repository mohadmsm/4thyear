%----------- Plotting into separate figures ----------------
function plott2(t,ft)
for k=1:size(ft,1)
 figure; plot(t,real(ft(k,:))); grid on;
 figure; plot(t,imag(ft(k,:))); grid on; % optional
end
