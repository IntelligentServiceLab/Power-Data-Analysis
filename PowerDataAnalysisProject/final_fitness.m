function [load_restart, load_cut] = final_fitness(arr_present, map, node, line, load, dg)
    load_restart = 0;
    load_cut = 0;
    for i = 1:node
        if arr_present(i) == -1
            load_cut = load_cut + load(i);
        else
            load_restart = load_restart + load(i);
        end
    end
end