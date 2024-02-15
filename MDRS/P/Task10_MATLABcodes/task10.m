% Exercício 10

%% 10 a)
fprintf("10 a)\n")
clear all
close all
clc

load('InputData2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

MTBF = (450*365*24)./L;
A = MTBF./(MTBF + 24);
A(isnan(A))= 0;
A = A + eye(size(A));
Alog = -log(A);

k= 1;                           % Most available path
sP= cell(2,nFlows);
nSP= zeros(1,nFlows);
sum = 0; % 10 b)

for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(Alog,T(f,1),T(f,2),k);
    sP{1,f}= shortestPath;
    nSP(f)= length(totalCost);
    for i= 1:nSP(f)
        Aaux= Alog;
        path1= sP{1,f}{i};
        for j=2:length(path1)
            Aaux(path1(j),path1(j-1))= inf;
            Aaux(path1(j-1),path1(j))= inf;
        end
        [shortestPath, totalCost] = kShortestPath(Aaux,T(f,1),T(f,2),1);
        if ~isempty(shortestPath)
            sP{2,f}{i}= shortestPath{1};
        end
    end
    av = 1;

    for n = 1 : length(sP{1, f}{1}) - 1 % até ao penultimo
        % first node 
        first  = sP{1, f}{1}(n); 
        % second 
        second = sP{1, f}{1}(n + 1);
        av = av * A(first, second);
    end
    sum = sum + av; % 10 b)

    fprintf('Flow %d: Availability = %.7f - Path = %s\n', f, av, num2str(sP{1, f}{1}));
end

%% 10 b)
fprintf('\n10 b)\nAverage availability= %.7f\n', sum/nFlows);

%% 10 c)
fprintf("10 c)\n")
clear all
close all
clc

load('InputData2.mat')
nNodes= size(Nodes,1);
nLinks= size(Links,1);
nFlows= size(T,1);

MTBF = (450*365*24)./L;
A = MTBF./(MTBF + 24);
A(isnan(A))= 0;
A = A + eye(size(A));
Alog = -log(A);

k= inf;                          
sP= cell(2,nFlows);
nSP= zeros(1,nFlows);
sum = 0;
for f=1:nFlows
    [shortestPath, totalCost] = kShortestPath(Alog,T(f,1),T(f,2),k);
    sP{1,f}= shortestPath;
    nSP(f)= length(totalCost);
    for i= 1:nSP(f)
        Aaux= Alog;
        path1= sP{1,f}{i};
        for j=2:length(path1)
            Aaux(path1(j),path1(j-1))= inf;
            Aaux(path1(j-1),path1(j))= inf;
        end
        [shortestPath, totalCost] = kShortestPath(Aaux,T(f,1),T(f,2),1);
        if ~isempty(shortestPath)
            sP{2,f}{i}= shortestPath{1};
        end
    end
    
    nPaths = 1;
    if length(sP{2,f}) > 1
        nPaths = 2;
    end

     % calculate availabilty
    av = ones(1,2);
    for j = 1 : 2
        if j == 2 && isempty(sP{2,f}{1})
            break
        end

        for n = 1 : length(sP{j, f}{1}) - 1 % penultimo
            % first
            first  = sP{j, f}{1}(n);
            % second
            second = sP{j, f}{1}(n + 1);
            av(j) = av(j) * A(first, second);
        end
    end

    if ~isempty(sP{2,f}{1})
        av(1) = 1 - ((1-av(1)) * (1-av(2)));
    end

    sum = sum + av(1);

    fprintf('Flow %d: Availability = %.7f -\tPath1 = %s\n', f, av(1), num2str(sP{1, f}{1}));
    fprintf('\tPath2 = %s\n', num2str(sP{2, f}{1}));
end
