function new_pic = sharpimfilter(pic)
a=[-1,-2,-1;0,0,0;1,2,1]; 
b=[-1,0,1;-2,0,2;-1,0,1];
[h,w]=size(pic);
x1=double(pic);
x2=x1;
for i=1:h-3+1
    for j=1:w-3+1
        c=x1(i:i+(3-1),j:j+(3-1)).*a;
        d=x1(i:i+(3-1),j:j+(3-1)).*b;
        x2(i:i+(3-1),j:j+(3-1))=sqrt(c.^2+d.^2);  %一般赋值两个矩阵相乘结果平方的开方
    end
end
new_pic=uint8(max(x2,0));
end

