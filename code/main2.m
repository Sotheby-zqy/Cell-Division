totalPages = ceil(num / 9); % 计算总页数，向上取整
new_pic=pic+255*uint8(edge_img);
for pageNum = 1:totalPages
    figure; % 每页创建一个新的图像窗口
    for regionId = 1:9 % 每页展示9个连通区域
        currentLabelId = pageNum * 9 - 8 + regionId; % 计算当前页的连通区域ID
        if currentLabelId <= num % 确保当前ID在有效范围内
            idx = L == currentLabelId;
            [rowInd, colInd] = find(idx); % 找到所有非零点的行和列索引

            % 计算坐标范围
            minRow = min(rowInd); % 最小行坐标
            maxRow = max(rowInd); % 最大行坐标
            minCol = min(colInd); % 最小列坐标
            maxCol = max(colInd); % 最大列坐标
            region = uint8(double(new_pic).*idx);
            region = region(minRow:maxRow,minCol:maxCol,:); % 提取当前连通区域
            subplot(3, 3, regionId); % 3行3列布局
            imshow(region);
            % 添加标题（模拟下方标注），显示当前连通区域的标签ID
            title(sprintf('S：%.2f，C：%.2f', S_list(currentLabelId), C_list(currentLabelId)));
        else
            % 如果没有足够的区域填充当前页，则留空
            subplot(3, 3, regionId);
            title('');
        end
    end
end