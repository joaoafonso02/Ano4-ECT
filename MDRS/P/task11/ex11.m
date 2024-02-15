% Exercício 11

%% 11 a)

clear all
close all
clc

load('InputData2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

k = 6;
sP = cell(1, nFlows);
nSP = zeros(1, nFlows);
for f = 1 : nFlows
    [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
    sP{f}= shortestPath;
    nSP(f)= length(totalCost);
end

t = tic;
timeLimit = 15;
bestLoad = inf;
contador = 0;
somador = 0;
alfa = 1;
bestEnergy = inf;
while toc(t) < timeLimit
    % greedy randomized start
    [sol, load, Loads, energy] = greedyRandomizedStrategy(nNodes, Links, T, sP, nSP, L, alfa);
 
    while energy == inf
        [sol, load, Loads, energy] = greedyRandomizedStrategy(nNodes, Links, T, sP, nSP, L, alfa);
    end

    [sol, load, Loads, energy] = HillClimbingStrategy(nNodes, Links, T, sP, nSP, sol, load, Loads, energy, L, alfa);
    if energy < bestEnergy
        bestSol = sol;
        bestLoad = load;
        bestLoads = Loads;
        bestEnergy = energy;
        bestLoadTime = toc(t);
    end
    contador = contador + 1;
    somador = somador + load;
end

sleepy_nodes = "";


fprintf('\t W = %.2f Gbps, No. sol = %d, Av. W = %.2f, time = %.2f sec\n', bestLoad, contador, somador/contador, bestLoadTime);