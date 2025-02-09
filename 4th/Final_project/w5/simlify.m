clear
clc
syms Y l L s R G C x
z=(R+s*L);
Yy=G+s*C;
Zo = sqrt(z/Yy);
y= sqrt(z*Yy);
Ya = (1+tanh(y*l/2)*sinh(y*l))/(Zo*sinh(y*l));
simplify(Ya)