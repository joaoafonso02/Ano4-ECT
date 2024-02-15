% Exercício 1

%% 1 e)

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
        [~, APD(it), ~, TT(it)] = Simulator1V2(lambda(i), C, f, P);
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


%% 1 d)

lambda = [1000, 1300, 1600, 1900];  % Packet arrival lambda (pps)
C = 10;                          % Link capacity (Mbps)
f = 1000000;                      % Bytes
N = 20;                          % Number of simulations
P = 100000;                      % Stopping criteria
b = 10^-5                        % ber
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
        [~, APD(it), ~, TT(it)] = Simulator2V2(lambda(i), C, f, P, b);
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
figure(3);
hold on;
grid on;
bar(lambda, APD_values);
errorbar(lambda, APD_values, APD_terms);
title('Average Packet Delay');
xlabel('Packet Rate (pps)');
ylabel('Avg. Packet Delay (ms)');
hold off;

% 1.ii)
figure(4);
hold on;
grid on;
bar(lambda, TT_values);
errorbar(lambda, TT_values, TT_terms);
title('Average Throughput');
xlabel('Packet Rate (pps)');
ylabel('Average Throughput (Mbps)');
hold off;


