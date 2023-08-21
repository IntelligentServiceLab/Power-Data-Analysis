function arr_present = arr_change(arr_present, part_size)
    % 将粒子位置的值从0和1转换为实际的线路状态，-1断开，1闭合
    for i = 1:part_size
        if arr_present(i) == 0
            arr_present(i) = -1;
        end
    end
end