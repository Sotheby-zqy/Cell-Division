pic=imread("C:\Users\admin\Desktop\课程报告\细胞分割\42111043+张青怡+大作业\images\dataset\cell3.jpg");
% 本部分代码负责实现 

%图像预处理部分
[x,y,z]=size(pic);
figure(1);
subplot(2,2,1);
imshow(pic);
title("初始图像展示");
B_image=pic(:,:,3);      %图像主体为蓝色，且转灰度图后发现效果不理想，故取B通道
pic1=medfilter(B_image,3);  %中值滤波去噪
subplot(2,2,2);
imshow(pic1);
title("去噪图像展示");
pic2=sharpimfilter(pic1);   %锐化，自定义函数sharpimfilter
subplot(2,2,3);
imshow(pic2);
title("锐化图像展示");
%上述完成了图像的去噪、锐化等预处理操作。
%图像预分割
%大津法Otsu进行二值化预分割,定义函数为Otsu
best_v=Otsu(pic2);
pic3=pic2>best_v;
subplot(2,2,4);
imshow(pic3);
title("大津法分割图像展示");

%对分割后的二值图，实施开运算
se = strel('disk',8); 
pic4 = imopen(pic3,se);
figure(2);
subplot(2,2,1);
imshow(pic4);
title("开运算后图像展示");
%粘连细胞分割——水坝算法分割图像
%现使用bwareaopen函数删除图像中小区域的点（视为噪声）
pic5 = ~bwareaopen(~pic4, 80);  %~表示反转操作，将pic4反转后去除<100的噪声再度反转
subplot(2,2,2);
imshow(pic5);
title("删除噪点区域后");
%水坝分割
pic6 = -bwdist(~pic5);    %对图像进行距离变换操作
subplot(2,2,3);
imshow(pic6);
title("距离变换操作");
pic7 = imextendedmin(pic6,2);    %imextendedmin将会只在我们希望分割的区块中间产生小点
imshowpair(pic4,pic7,"blend")
pic8 = imimposemin(pic6,pic7);
pic8 = watershed(pic8);
pic9=pic4;
pic9(pic8 == 0) = 0;
subplot(2,2,4);
imshow(pic9)
title("水坝切分图");

%四连通区域标记算法统计细胞个数并标注在图上
se = strel('disk', 3);
pic9 = imopen(pic9, se);
pic10 = bwareaopen(pic9, 500);% 使用bwareaopen函数移除面积小于900的连通区域

%利用sobel算子提取边缘轮廓
edge_img=edge(pic10,'sobel'); %记为轮廓线图

[L,num] = bwlabel(pic10, 4); % 第二个参数'4'指定4连通性
pic11 = label2rgb(L, 'jet', [.5 .5 .5]); %使用 'jet'调色盘上的颜色给图中不同细胞上色,背景设置为[.5 .5 .5]
figure(3),subplot(1,2,1);
imshow(pic11), title('细胞着色图');
% 或者，直接在原图上标注数字（这一步较为复杂，需要自定义绘图）
S_list=zeros(1,num);   %定义一个列表用于保存各区块的面积
subplot(1,2,2)
imshowpair(edge_img,pic,"blend")
for k = 1:num
    [r,c] = find(L == k);   %r=c=k标签占领的像素数量=k标签细胞的面积
    S_list(k)=length(r);
    text(mean(c), mean(r), num2str(k), 'Color', 'white', 'HorizontalAlignment', 'center', 'FontSize', 8);  
    %給所有区块的每个区块中写上区块对应的标签
end
title('细胞标签可视化');

%细胞面积已存为S_list
%下面计算细胞的周长，并存为C_list列表
C_list=zeros(1,num);
Lab_Image=L;
for k=1:num
    for i=2:x-1
        for j=2:y-1  %通过一个双层循环遍历图像的所有像素，对于每个像素，使用一系列的条件判断来检查8个邻域像素，
            if ((Lab_Image(i,j)==k && Lab_Image(i-1,j-1)==0) || (Lab_Image(i,j)==k && ...
                 Lab_Image(i-1,j)==0) || (Lab_Image(i,j)==k && Lab_Image(i-1,j+1)==0) || ...
                 (Lab_Image(i,j)==k && Lab_Image(i,j-1)==0) || (Lab_Image(i,j)==k && ...
                 Lab_Image(i,j+1)==0) || (Lab_Image(i,j)==k && Lab_Image(i+1,j-1)==0) || ...
                 (Lab_Image(i,j)==k && Lab_Image(i+1,j)==0) || (Lab_Image(i,j)==k && ...
                 Lab_Image(i+1,j+1)==0))
                C_list(k)=C_list(k)+1;
            end
        end
    end
end
