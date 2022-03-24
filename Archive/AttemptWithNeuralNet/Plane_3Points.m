function [a,b,c,d]=Plane_3Points(A,B,C)
normal = cross(A - B, A - C);
a=normal(1);
b=normal(2);
c=normal(3);
d = A(1)*normal(1) + A(2)*normal(2) + A(3)*normal(3);
% a=(B(2)-A(2))*(C(3)-A(3))-(C(2)-A(2))*(B(3)-A(3));
% b=(B(3)-A(3))*(C(1)-A(1))-(C(3)-A(3))*(B(1)-A(1));
% c=(B(1)-A(1))*(C(2)-A(2))-(C(1)-A(1))*(B(2)-A(2));
% d=-(a*A(1)+b*A(2)+c*A(3));
end