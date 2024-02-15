% Exercise 12

%% 12 a)
clear all
close all
clc

load('InputData2.mat')
nNodes= size(Nodes,1);
v = 2*10^5;             % v = 2x10^5 km/sec
D = L/v;                % Propagation Delay matrix

downloadThroughput = [0.7 1.5 2.1 1.0 1.3 2.7 2.2 0.8 1.7 1.9 2.8];
uploadThroughput = [0.1 0.2 0.3 0.1 0.1 0.4 0.3 0.1 0.2 0.3 0.4];

T = [downloadThroughput ; uploadThroughput]';

anycastNodes = [3 5];
sourceNodes = setdiff(1 : nNodes, anycastNodes);

[costs, sP] = bestCostPaths(nNodes, anycastNodes, D);

fprintf("Anycast Nodes = %s\n", num2str(anycastNodes));

[worstCost, worstNode] = max(costs);

fprintf("Node with the worst round-trip delay: %d\n", worstNode);
fprintf('W = %.2f ms \t A = %.2f ms\n', worstCost * 1000, mean(costs) * 1000);