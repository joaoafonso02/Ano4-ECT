% Exercício 1

%% 1.a)
fprintf("1 a)\n")
lambda = 1800;          % pps
f = 1000000;            % Bytes
N = 20;                 % times to simulate
P = 100000;             % stopping criteria
alfa = 0.1;             % 90% confidence interval
C = [10, 20, 30, 40];   % 10, 20, 30, 40 Mbps

APD = zeros(length(C), N);
media = zeros(length(C), 1);
term = zeros(length(C), 1);
for i = 1:length(C)  
    for n = 1:N
        [~, APD(i, n), ~, ~] = Simulator1(lambda, C(i), f, P); % it captures only the second value ignoring the others
    end
    
    media(i, 1) = mean(APD(i,:)); % side is 1-by-20
    term(i, 1) = norminv(1-alfa/2) * sqrt(var(APD(i,:))/N);

    fprintf("APD C%d (ms) = %.2e +- %.2e\n", C(i), media(i), term(i)); % check for each C
end

figure(1)
bar(C, APD(:, 1))
hold on
grid on
er = errorbar(C, APD(:, 1), term(:, 1) * -1, term(:, 1));    
xlabel('C, Link Bandwidth (Mbps)')
ylabel('APD, Average Packet Delay (ms)')
title('Average Packet Delay (ms) vs Link Bandwidth (Mbps)');
hold off;
hold off

% Conclusions:

% Increasing Link Capacity Reduces Delay: As observed in the simulation, when the link capacity (C) increases from 10 Mbps to 40 Mbps, the average packet delay decreases. This result can be justified as follows:

    % Reduced Congestion: With a higher link capacity, the network is better equipped to handle the traffic load. Reduced congestion in the network leads to quicker packet transmission and lower queuing delays.
    
    % Faster Packet Processing: The available bandwidth allows for faster processing and transmission of packets, resulting in shorter delays.

% In conclusion, the simulation results demonstlambda that link capacity is a critical factor in determining the average packet delay in a network. Higher link capacities lead to reduced delays, while limited link capacities result in increased delays due to network congestion. This emphasizes the importance of well-designed and adequately provisioned networks to meet Quality of Service expectations.
