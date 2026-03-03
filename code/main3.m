%输入信息包括切分好的细胞区域图，和彩色图像（R通道提取红色染色体，G通道提取绿色染色体）、
pic=imread("C:\Users\zqy\Desktop\数字图像处理\期末\期末\选择1素材\cell1.jpg");
%图像预处理部分
[x,y,z]=size(pic);
R_image=pic(:,:,1);   %先进行红色染色体的识别和统计过程
G_image=pic(:,:,2);
R_img1=medfilter(R_image,3);  %中值滤波去噪
G_img1=medfilter(G_image,3);
%上述完成了图像的去噪、锐化等预处理操作。
%图像预分割
%大津法Otsu进行二值化预分割,定义函数为Otsu
best_v1=Otsu(R_img1);
best_v2=Otsu(G_img1);
R_img2=R_img1>(best_v1)+50;
G_img2=G_img1>(best_v2)+50;
%由于题目要求统计圆形的红色和绿色染色体个数，若为长条形的染色体不统计
%通过查找资料，发现regionprops函数可计算每个连通组件的形状属性，圆形度接近1表示形状接近圆形，而长宽比接近0表示接近圆形，远离0则表示形状更加细长。
R_Count = zeros(1,num);  %用于存放各细胞区域内包含的染色体数量，初始化为零
R_position = {};R_end=1;
G_Count = zeros(1,num); 
G_position = {};G_end=1;
% 设定筛选条件，这里以Eccentricity < 0.9为前提筛选合适的染色体区域
circleThreshold = 0.9;
%solidityThreshold = 0.4; % 固有矩阈值，越高表示越接近圆形
for k=1:num   %对于num个细胞的区域，分别计算和探索
    pic_k = L==k;
    R_cell_k = pic_k.*R_img2;
    R_L = bwlabel(R_cell_k);
    G_cell_k = pic_k.*G_img2;
    G_L= bwlabel(G_cell_k);
    stats_R = regionprops(R_L,'Eccentricity', 'Solidity', 'Centroid'); % 计算属性
    stats_G = regionprops(G_L, 'Eccentricity', 'Solidity', 'Centroid'); % 计算属性
    
    for i = 1:length(stats_R)  %循环统计当前细胞内红色染色体数量和坐标
        eccentricity = stats_R(i).Eccentricity; % 获取长宽比
        centroid = stats_R(i).Centroid; % 获取染色体的中心坐标位置
        % 判断是否接近圆形
        if eccentricity < circleThreshold 
            R_Count(k) = R_Count(k) + 1; % 发现细胞k内符合条件的圆形染色体，计数+1
            centroid = stats_R(i).Centroid;
            R_position{R_end} = centroid;  %坐标记录，+1
            R_end=R_end+1;
        end
    end
    for i = 1:length(stats_G)   %循环统计当前细胞内红色染色体数量和坐标
        eccentricity = stats_G(i).Eccentricity; % 获取长宽比
        solidity = stats_G(i).Solidity; % 获取固有矩
        centroid = stats_G(i).Centroid; % 获取染色体的中心坐标位置
        % 判断是否接近圆形
        if eccentricity < circleThreshold
            G_Count(k) = G_Count(k) + 1; % 发现细胞k内符合条件的圆形染色体，计数+1
            centroid = stats_G(i).Centroid;
            G_position{G_end} = centroid;  %坐标记录，+1
            G_end=G_end+1;
        end
    end
end
%进行绘图并展示红色、绿色染色体
% 初始细胞图像pic图像是RGB模式，便于绘图
figure; % 创建一个新的图形窗口
imshowpair(edge_img,pic,"blend")
hold on; % 保持图像并允许在其上叠加绘图
% 设置圆形的颜色和线型
markerSize = 5;
% 遍历每个斑点的质心坐标并绘制圆形
for m = 1:numel(R_position)    %绘制红色染色体
    centroid = R_position{m};
    scatter(centroid(1), centroid(2), markerSize, 'filled', 'r'); % 绘制圆点
end
for n = 1:numel(G_position)    %绘制红色染色体
    centroid = G_position{n};
    scatter(centroid(1), centroid(2), markerSize, 'filled', 'green'); % 绘制圆点
end
%显示红绿染色体数量文本
for k = 1:num
    [r,c] = find(L == k);   %r=c=k标签占领的像素数量=k标签细胞的面积
    text_t = [num2str(R_Count(k)), ' , ', num2str(G_Count(k))];
    text(mean(c), mean(r), text_t,'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'white', 'FontSize', 10);  
    %給所有区块的每个区块中写上区块对应的标签
end
hold off; % 结束保持状态
title('红绿色染色体位置标注'); % 添加标题