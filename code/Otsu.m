%大津算法求最优分割阈值，能使前景与背景之前方差最大
function best_v = Otsu(pic)
    pic=double(pic);
    [x,y]=size(pic);
    max_v=max(pic(:));
    min_v=min(pic(:));
    record=zeros(1,max_v-min_v+1);
    pos=min_v:max_v;
    for i=1:length(min_v:max_v)
        front=pic>pos(i);
        sum_F=sum(front(:));
        sum_B=x*y-sum_F;
        all_front=front.*pic;
        avg_F=sum(all_front(:))/sum_F;
        avg_B=(sum(pic(:))-sum(all_front(:)))/sum_B;
        rate_F=sum_F/(x*y);
        rate_B=sum_B/(x*y);
        record(i)=rate_F*rate_B*(avg_F-avg_B)*(avg_F-avg_B);
    end
    [~, flag]=max(record);             % 最大值下标
    best_v=flag;
    end