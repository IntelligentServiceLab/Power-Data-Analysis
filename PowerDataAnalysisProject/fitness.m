function [fit, load_restart, load_cut] = fitness(arr_present, map, node, line, load, dg, load_k)
    % 需要根据具体的适应度计算规则来实现这个函数
    load_restart = 0;
    load_cut = 0;
    for i = 1:node
        if arr_present(i) == -1
            load_cut = load_cut + load(i);
        else
            load_restart = load_restart + load(i);
        end
    end
    fit = load_cut / (load_cut + load_restart);
end