% Task 1

%% 1 c)
fprintf("starting\n");
clear all
close all
clc

load('InputDataProject2.mat')
nNodes = size(Nodes, 1);
nLinks = size(Links, 1);
nFlows1 = size(T1, 1);

k = 2;
sP = cell(1, nFlows1);
nSP = zeros(1, nFlows1);
for f = 1 : nFlows1
    [shortestPath, totalCost] = kShortestPath(L, T1(f, 1), T1(f, 2), k);
    sP{f} = shortestPath;
    nSP(f) = length(totalCost);
    % candidate paths for each flow
    fprintf('Candidate paths for Flow %d:\n', f);
    for i = 1 : k
        fprintf('%d ', sP{f}{i});
        fprintf('\n');
    end
end

t = tic;
timeLimit = 10;
bestLoad = inf;
contador = 0;
somador = 0;
alfa = 1;
while toc(t) < timeLimit
    % Initialize sol vector with zeros
    sol = zeros(1, nFlows1);

    % greedy randomized start
    [sol, load, Loads, energy] = greedyRandomizedStrategy(nNodes, Links, T1, sP, nSP, L, alfa);

    % Hill climbing
    [sol, load, Loads, energy] = HillClimbingStrategy(nNodes, Links, T1, sP, nSP, sol, load, Loads, energy, L, alfa);
    fprintf("%d", load)
    if load < bestLoad
        bestSol = sol;
        bestLoad = load;
        bestLoads = Loads;
        bestEnergy = energy;
        bestLoadTime = toc(t);
        bestCycles = contador;
    end
    contador = contador + 1;
    somador = somador + load;
end

% Calculate additional metrics
averageLinkLoad = mean(mean(bestLoads(:, 3:4)));
networkEnergy = bestEnergy;
% You need to implement the average round-trip propagation delay calculation

% Find inactive links
inactiveLinks = findInactiveLinks(bestLoads);

% Print the results
fprintf('Worst Link Load: %.2f Gbps\n', max(max(bestLoads(:, 3:4))));
fprintf('Average Link Load: %.2f Gbps\n', averageLinkLoad);
fprintf('Network Energy Consumption: %.2f\n', networkEnergy);
fprintf('Average Round-Trip Propagation Delay: %.2f\n', averagePropagationDelay); % Replace with the actual value
fprintf('Inactive Links: %d (%s)\n', numel(inactiveLinks), num2str(inactiveLinks));
fprintf('Number of Cycles Run by the Algorithm: %d\n', bestCycles);
fprintf('Running Time at Best Solution: %.2f seconds\n', bestLoadTime);

function inactiveLinks = findInactiveLinks(Loads)
    inactiveLinks = find(all(Loads(:, 3:4) == 0, 2));
end
