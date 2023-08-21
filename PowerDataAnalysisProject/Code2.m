% 故障恢复算法主程序
clear 
clc 
tic
% 电力系统各个节点的信息
busdata=[1 2 1.03 0 0 0 5 0 -5 5 0 
         2 0 1 0 0.1 0.06 0 0 0 0 0 
         3 0 1 0 0.09 0.04 0 0 0 0 0 
         4 0 1 0 0.12 0.08 0 0 0 0 0 
         5 0 1 0 0.06 0.03 0 0 0 0 0 
         6 0 1 0 0.06 0.02 0 0 0 0 0 
         7 0 1 0 0.2 0.1 0 0 0 0 0 
         8 0 1 0 0.2 0.1 0 0 0 0 0 
         9 0 1 0 0.06 0.02 0 0 0 0 0 
         10 2 1.03 0 0.06 0.02 0.5 0 0 0 0 
         11 0 1 0 0.045 0.03 0 0 0 0 0 
         12 0 1 0 0.06 0.035 0 0 0 0 0 
         13 0 1 0 0.06 0.035 0 0 0 0 0 
         14 0 1 0 0.12 0.08 0 0 0 0 0 
         15 0 1 0 0.06 0.01 0 0 0 0 0 
         16 0 1 0 0.06 0.02 0 0 0 0 0 
         17 0 1 0 0.06 0.02 0 0 0 0 0 
         18 2 1.03 0 0.09 0.04 0.25 0 0 0 0 
         19 2 1.03 0 0.09 0.04 0.5 0 0 0 0 
         20 0 1 0 0.09 0.04 0 0 0 0 0 
         21 0 1 0 0.09 0.04 0 0 0 0 0 
         22 0 1 0 0.09 0.04 0 0 0 0 0 
         23 2 1.03 0 0.09 0.05 0.5 0 0 0 0 
         24 0 1 0 0.42 0.2 0 0 0 0 0 
         25 0 1 0 0.42 0.2 0 0 0 0 0 
         26 0 1 0 0.06 0.025 0 0 0 0 0 
         27 0 1 0 0.06 0.025 0 0 0 0 0 
         28 0 1 0 0.06 0.02 0 0 0 0 0 
         29 0 1 0 0.12 0.07 0 0 0 0 0 
         30 0 1 0 0.2 0.6 0 0 0 0 0 
         31 2 1.03 0 0.15 0.07 0.5 0 0 0 0 
         32 0 1 0 0.21 0.1 0 0 0 0 0 
         33 0 1 0 0.06 0.04 0 0 0 0 0];
% 电力系统中各个支路的信息
    global linedata 
    linedata=[1 2 0.057517155 0.029320025 0 1 
    2 3 0.307548347 0.156643793 0 1 
    3 4 0.228321896 0.116281971 0 1 
    4 5 0.237741734 0.121085465 0 1 
    5 6 0.510917031 0.441048035 0 1 
    6 7 0.116781036 0.386026201 0 1 
    7 8 0.443792888 0.146662508 0 1 
    8 9 0.642545228 0.461634435 0 1 
    9 10 0.651278852 0.461634435 0 1 
    10 11 0.122645041 0.040548971 0 1 
    11 12 0.233562071 0.077230193 0 1 
    12 13 0.915782907 0.720524017 0 1 
    13 14 0.3378665 0.444728634 0 1 
    14 15 0.368683718 0.328134747 0 1 
    15 16 0.465564566 0.339987523 0 1 
    16 17 0.80411728 1.073611978 0 1 
    17 18 0.456643793 0.358078603 0 1 
    2 19 0.102308172 0.097629445 0 1 
    19 20 0.938365565 0.845539613 0 1 
    20 21 0.255458515 0.298440424 0 1 
    21 22 0.442233313 0.584716157 0 1 
    3 23 0.28147224 0.192326887 0 1 
    23 24 0.560199626 0.442358079 0 1 
    24 25 0.558951965 0.437367436 0 1 
    6 26 0.126637555 0.064504055 0 1 
    26 27 0.177292576 0.090268247 0 1 
    27 28 0.660636307 0.582470368 0 1 
    28 29 0.501684342 0.437055521 0 1 
    29 30 0.316593886 0.161260137 0 1 
    30 31 0.607860262 0.600748596 0 1 
    31 32 0.193699314 0.225764192 0 1 
    32 33 0.212726138 0.330754835 0 1 
    8 21 1.247660636 1.247660636 0 1 
    9 15 1.247660636 1.247660636 0 1 
    12 22 1.247660636 1.247660636 0 1 
    18 33 0.311915159 0.311915159 0 1 
    25 29 0.311915159 0.311915159 0 1]; 

%支路数 
line=37; 
%节点数 
node=33; 
%最大迭代次数 
max_gen=500; 
%粒子数 
pop_size=500; 
%维度数(可以变化的支路数） 
global part_size 
part_size=37; 
%学习因子取值，用于控制粒子的速度更新 
c1=1.05; 
c2=1.05; 
%惯性权重的取值范围 
w_max=1.5; 
w_min=0.6; 

%每个节点的负荷量 
load=[0 0.1 0.09 0.12 0.06 0.06 0.2 0.2 0.06 0.06 0.045 0.06 0.06 0.12 0.06 0.06 0.06 0.09 0.09 0.09 0.09 0.09 0.09 0.42 0.42 0.06 0.06 0.06 0.12 0.2 0.15 0.21 0.06]; 

%每个节点的分布式发电量 
dg=[0,0,0,0,0,0,0,0,0,0.500000000000000,0,0,0,0,0,0,0,0.250000000000000,0.2500000000000000,0,0,0,0.2500000000000000,0,0,0,0,0,0,0,0.500000000000000,0,0]; 

%每个节点的负荷类型 
load_type=[2 1 1 3 1 2 2 1 3 2 2 3 1 2 1 3 3 2 3 2 1 1 3 2 1 2 3 2 2 1 3 2 1]; 

% 节点的负荷权重 
for i=1:node 
    switch load_type(i) 
        case 1 
            load_k(i)=100; 
        case 2 
            load_k(i)=10; 
        case 3 
            load_k(i)=1; 
    end 
end 

map = zeros(node, node);
for i = 1:line
    from_bus = linedata(i, 1);
    to_bus = linedata(i, 2);
    map(from_bus, to_bus) = 1;
    map(to_bus, from_bus) = 1;
end


rand('state',sum(100*clock)); 

% gbest 全局最优解 
gbest = zeros(1,part_size+2); 

% pbest 粒子个体历史最优解
pbest = zeros(pop_size,part_size+2); 

% best_record数组：记录每一代的最好的粒子的适应度 
best_record = zeros(max_gen,part_size+2); 

% 初始化当前速度 
alfa=ones(pop_size,part_size)./sqrt(2); 
beta=ones(pop_size,part_size)./sqrt(2); 

flag=1; 

% 初始化粒子群
while flag==1 
    % 粒子位置初始化
    arr_present=rand(pop_size,part_size+2); % 随机生成当前种群的位置
    arr_present=roundn(arr_present,0);
    for j=1:pop_size 
        arr_present(j,1:part_size)=arr_change(arr_present(j,1:part_size),part_size); % arr_change 将位置的值从0和1转换为支路的状态
        [ arr_present(j,(part_size+1)),arr_present(j,(part_size+2)) ] = fitness(arr_present(j,1:part_size),map,node,line,load,dg,load_k); % 全局适应度，个体历史适应度
    end 
    arr_present_num=find(arr_present(:,part_size+2)>0); % 找到适应度大于0的粒子索引
    if arr_present_num 
        flag=0; % 循环结束
    end 
end 

% 把当前种群的位置和适应度赋值给pbest
pbest = arr_present; 

% 找到当前群体中适应度最小的，best_value 
arr_present_num=find(arr_present(:,part_size+2)>0); % arr_present_num数组 找到所有适应度大于0的位置
[best_value best_index] = min(arr_present(arr_present_num,part_size+1)); %初始化全局最优

% 唯一的全局最优值，是当前代所有粒子中最好的一个 
gbest = arr_present(arr_present_num(best_index),:); 

%开始进化，直到最大代数截至
for gen=1:max_gen 
w = w_max-(w_max-w_min)*gen/max_gen; % 线形递减权重，根据当前迭代次数计算惯性权重（旋转角） 
% 当前进化代数：对于每个粒子进行更新和评价 
for j=1:pop_size 
% 更新粒子的位置
arr_present(j,1:part_size)=rand(1,part_size)>(abs(beta(j,:)).^2); 
arr_present(j,1:part_size)=arr_change(arr_present(j,1:part_size),part_size); 
[arr_present(j,(part_size+1)),arr_present(j,(part_size+2))]=fitness(arr_present(j,1:part_size),map,node,line,load,dg,load_k); % fitness 计算位置的适应度

% 适应度评价与可行域限制 
if arr_present(j,end)<pbest(j,end) % 如果当前适应度小于个体历史最优适应度
    pbest(j,:) = arr_present(j,:); % 更新个体的历史最优解 
end 
% d_w 计算速度的更新量
d_w(j,:)=w.*((sign(arr_present(j,part_size+1)-pbest(j,part_size+1))+1)/2.*(pbest(j,1:part_size)-arr_present(j,1:part_size))+(sign(arr_present(j,part_size+1)-gbest(1,part_size+1))+1)/2.*(gbest(1,1:part_size)-arr_present(j,1:part_size))); 
% 更新速度（量子比特位）
alfa(j,:)=cos(d_w(j,:)).*alfa(j,:)-sin(d_w(j,:)).*beta(j,:); 
beta(j,:)=sin(d_w(j,:)).*alfa(j,:)+cos(d_w(j,:)).*beta(j,:); 
end 

% 更新全局的极值 
arr_present_num=find(arr_present(:,part_size+2)>0); % 找到适应度大于0的位置
[best best_index] = min(arr_present( arr_present_num,part_size+1)); % 找到适应度最小的位置
if best<gbest(part_size+1) % 如果当前最优适应度小于全局最优适应度
    gbest=arr_present( arr_present_num(best_index),:); % 更新全局最优解
end 

% best_record 记录当前代的最好粒子的适应度
best_record(gen,:) = gbest; 
end 

result = final_print(gbest(1:part_size),map,node,line,load,load_type,dg); % 输出最终的故障恢复方案和运行时间
[load_restart,load_cut] = final_fitness(gbest(1:part_size),map,node,line,load,dg); 
toc 