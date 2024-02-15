% Exercício 11

%% 11 a)

clear all
close all
clc

load('InputDataProject2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T1,1);
lc = 100;        % Link capacity of 100Gbps
nc = 1000;       % Node capacity of 1000Gbps
v = 2 * 10^5;     % v = 2×105 km/sec
D1 = L / v;

k = 6;
sP = cell(1, nFlows);
nSP = zeros(1, nFlows);
for f = 1 : nFlows
    [shortestPath, totalCost] = kShortestPath(L,T1(f,1),T1(f,2),k);
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
    continuar = true;
    while continuar
        continuar = false;
        sol = zeros(1, nFlows);
        for f = randperm(nFlows)
            bestaux = inf;
            ibest = 0;
            for i = 1: nSP
                sol(f) = 1;
                Loads = calculateLinkLoads(nLinks, Links, T1, sP, sol);
                load = max(max(Loads(:, 3:4)));
                if load <=10*alfa
                    energy = calculateEnergy(T1, sP, nNodes, nc, sol);
                    if energy < bestaux
                        ibest = 1;
                        bestaux = energy;
                    end
                end
            end
            if ibest > 0
                sol(f) = ibest;
            else
                continuar = true;
                break
            end
        end
    end 
    Loads = calculateLinkLoads(nLinks, Links, T1, sP, sol);
    load = max(max(Loads(:, 3:4)));
    energy = calculateEnergy(T1, sP, nNodes, nc, sol);
    if load < bestLoad
        bestSol = sol;
        bestLoad = load;
        bestEnergy= energy;
        bestLoadTime = toc(t);
    end
    contador = contador + 1;
end


sleepy_nodes = "";


fprintf('E = %.2f\tW = %.2f Gbps\tNo. sols = %d\ttime = %.2f\n', bestEnergy, bestLoad, contador, bestLoadTime);