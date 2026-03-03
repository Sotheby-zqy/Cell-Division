%自定义中值滤波函数，实现图像去噪
function new_pic = medfilter(pic,n)
N=ones(n,n);
[h,w]=size(pic);
copy_pic=double(pic); %将图像信息流设为double格式
x2=copy_pic;
offset = floor(n/2);
for i = offset+1:h-offset
    for j = offset+1:w-offset
        % 提取当前窗口内的像素值
        b = copy_pic(i-offset:i+offset, j-offset:j+offset).*N;
        % 计算中位数
        s = median(b,[1,2]);
        % 将中位数赋给输出图像的对应位置
        x2(i,j) = s;
    end
end
new_pic=uint8(x2);
end

