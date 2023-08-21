function result = final_print(arr_present, map, node, line, load, load_type, dg)
    % 初始化恢复方案
    result = zeros(line, 1);
    
    % 根据位置信息生成恢复方案
    for i = 1:line
        if arr_present(i) == 1
            result(i) = 1;
        end
    end
    
    % 打印恢复方案
    fprintf('故障恢复方案：\n');
    for i = 1:line
        if result(i)~= map(i)
            if result(i) == 1
                fprintf('闭合开关%d\n', i);
            else
             fprintf('断开开关%d\n', i);
            end
        end
    end
    
    % 打印节点信息
    fprintf('节点信息：\n');
    for i = 1:node
        fprintf('节点%d', i);
        if load_type(i) == 1
            fprintf('(一级负荷):');
        elseif load_type(i) == 2
            fprintf('(二级负荷):');
        elseif load_type(i) == 3
            fprintf('(三级负荷):');
        end
        fprintf('负荷量：%f，分布式发电量：%f\n', load(i), dg(i));
    end
end
