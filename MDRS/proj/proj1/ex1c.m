% 1 c)

lambda = [1000, 1300, 1600, 1900];  % Packet arrival lambda (pps)
C = 10;                          % Link capacity (Mbps)
f = 1000000;                      % Bytes
N = 20;                          % Number of simulations
P = 100000;                      % Stopping criteria
alfa = 0.1;                      % 90% confidence interval

% Initialize variables to store simulation results for all lambda
APD_values = zeros(1, length(lambda));
APD_terms = zeros(1, length(lambda));
TT_values = zeros(1, length(lambda));
TT_terms = zeros(1, length(lambda));

for i = 1:length(lambda)
    % Variables to store the simulation results
    PL = zeros(1, N);
    APD = zeros(1, N);
    MPD = zeros(1, N);
    TT = zeros(1, N);

    for it = 1:N
        [~, APD(it), ~, TT(it)] = Simulator1(lambda(i), C, f, P);
    end

    % Calculate Avg. Packet Delay
    media = mean(APD);
    term = norminv(1 - alfa/2) * sqrt(var(APD) / N);
    APD_values(i) = media;
    APD_terms(i) = term;

    % Calculate Avg. Packet Loss
    media = mean(TT);
    term = norminv(1 - alfa/2) * sqrt(var(TT) / N);
    TT_values(i) = media;
    TT_terms(i) = term;
end

% i)
figure(1);
hold on;
grid on;
bar(lambda, APD_values);
errorbar(lambda, APD_values, APD_terms);
title('Average Packet Delay');
xlabel('Packet Rate (pps)');
ylabel('Avg. Packet Delay (ms)');
hold off;

% 1.ii)
figure(2);
hold on;
grid on;
bar(lambda, TT_values);
errorbar(lambda, TT_values, TT_terms);
title('Average Throughput');
xlabel('Packet Rate (pps)');
ylabel('Average Throughput (Mbps)');
hold off;


% Average Packet Delay (APD):

%As packet rate (λ) increases: When the packet arrival rate is high, it means more packets are arriving at the queue in a short period of time. In a network or queuing system, this increased traffic load can lead to congestion. Congestion results in packets having to wait in a queue before being served, which leads to increased delay. This is why you observe an increase in APD as λ increases.

%APD increase of approximately 1 ms: The increase in APD can be attributed to the time packets spend waiting in a queue due to congestion. If the packet arrival rate is near or exceeds the link capacity (C), the system experiences more congestion, causing packets to wait longer.

%Average Throughput (TT):

%As packet rate (λ) increases: When the packet arrival rate increases, it implies that more packets are being transmitted over the network. This can lead to a higher throughput, as more data is transmitted per unit of time.

%TT increase of approximately 5 Mbps per 1000 pps: The increase in TT can be attributed to the increased data transfer rate as more packets are sent. Each additional 1000 pps results in an approximate 5 Mbps increase in throughput, indicating that the network is capable of transmitting more data when the packet arrival rate is higher.

%In summary, the observed increase in APD with an increasing packet rate (λ) is due to congestion, which leads to increased packet delays. On the other hand, the increase in TT with an increasing packet rate reflects the network's capability to transmit more data when it is handling higher packet arrival rates, which is a common behavior in data networks when not fully saturated. These results are consistent with the behavior of queuing systems and network performance under varying loads.
