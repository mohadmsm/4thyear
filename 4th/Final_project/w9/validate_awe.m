clear
clc
num=[6,26,48,32] ; %results from the given exxample
deno = [1 6 18 24 16];
[A,B,C,D] = create_state_space(num,deno);
w = 2.5i;% expnation point
[p,~,r] = AWE_poles(A,B,C,D,w);
