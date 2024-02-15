% Exercício 2

%% 2 b)
lambda = 1500;  % pps
C = 10;         % Mbps
f = 1000000;    % Bytes
P = 10000;     % stopping criterion
num_runs = 20;

% Number of VoIP flows
voip_flows = [10, 20, 30, 40];

% Confidence level
alfa = 0.1;  % 90% confidence level

% Initialize arrays to store results
APD_data = zeros(length(voip_flows), num_runs);
APD_voip = zeros(length(voip_flows), num_runs);
APQD_data = zeros(length(voip_flows), num_runs);
APQD_voip = zeros(length(voip_flows), num_runs);

% Calculate mean and confidence intervals for APD_data and APQD_data
APD_data_values = zeros(length(voip_flows), 1);
APD_data_terms = zeros(length(voip_flows), 1);
APD_voip_values = zeros(length(voip_flows), 1);
APD_voip_terms = zeros(length(voip_flows), 1);
APQD_data_values = zeros(length(voip_flows), 1);
APQD_data_terms = zeros(length(voip_flows), 1);
APQD_voip_values = zeros(length(voip_flows), 1);
APQD_voip_terms = zeros(length(voip_flows), 1);

for n_idx = 1:length(voip_flows)
    n = voip_flows(n_idx);
    for run = 1:num_runs
        % Call the Simulator3V2 function to get the results
        [PLd, PLv , APDd , APDv , MPDd, MPDv , APQDd, APQDv, TT] = Simulator4V2(lambda, C, f, P, n);

        % Store the results for each run
        APD_data(n_idx, run) = APDd;
        APD_voip(n_idx, run) = APDv;
        APQD_data(n_idx, run) = APQDd;
        APQD_voip(n_idx, run) = APQDv;
    end

    % Calculate Avg. Packet Delay for Data Packets
    mean_APD_data = mean(APD_data(n_idx, :));
    term_APD_data = norminv(1 - alfa/2) * sqrt(var(APD_data(n_idx, :)) / num_runs);
    APD_data_values(n_idx) = mean_APD_data;
    APD_data_terms(n_idx) = term_APD_data;

    % Calculate Avg. Packet Delay for VoIP Packets
    mean_APD_voip = mean(APD_voip(n_idx, :));
    term_APD_voip = norminv(1 - alfa/2) * sqrt(var(APD_voip(n_idx, :)) / num_runs);
    APD_voip_values(n_idx) = mean_APD_voip;
    APD_voip_terms(n_idx) = term_APD_voip;

    % Calculate Avg. Queuing Delay for Data Packets
    mean_APQD_data = mean(APQD_data(n_idx, :));
    term_APQD_data = norminv(1 - alfa/2) * sqrt(var(APQD_data(n_idx, :)) / num_runs);
    APQD_data_values(n_idx) = mean_APQD_data;
    APQD_data_terms(n_idx) = term_APQD_data;

    % Calculate Avg. Queuing Delay for VoIP Packets
    mean_APQD_voip = mean(APQD_voip(n_idx, :));
    term_APQD_voip = norminv(1 - alfa/2) * sqrt(var(APQD_voip(n_idx, :)) / num_runs);
    APQD_voip_values(n_idx) = mean_APQD_voip;
    APQD_voip_terms(n_idx) = term_APQD_voip;
end

% Print results
for n_idx = 1:length(voip_flows)
    n = voip_flows(n_idx);
    fprintf('Results for n=%d VoIP Flows:\n', n);

    % Print Average Packet Delay for Data Packets with confidence interval
    fprintf('APD data n%d (milliseconds) = %.2f ± %.2f\n', n, APD_data_values(n_idx), APD_data_terms(n_idx));

    % Print Average Packet Delay for VoIP Packets with confidence interval
    fprintf('APD voip n%d (milliseconds) = %.2f ± %.2f\n', n, APD_voip_values(n_idx), APD_voip_terms(n_idx));

    % Print Average Queuing Delay for Data Packets with confidence interval
    fprintf('AQD data n%d (milliseconds) = %.2f ± %.2f\n', n, APQD_data_values(n_idx), APQD_data_terms(n_idx));

    % Print Average Queuing Delay for VoIP Packets with confidence interval
    fprintf('AQD voip n%d (milliseconds) = %.2f ± %.2f\n', n, APQD_voip_values(n_idx), APQD_voip_terms(n_idx));
end

% Create a new figure for Average Delay of Data Packets
figure(1);
bar(voip_flows, APD_data_values);
hold on;
errorbar(voip_flows, APD_data_values, APD_data_terms, 'r.', 'CapSize', 10);
title('Average Delay of Data Packets');
xlabel('Number of VoIP Flows');
ylabel('Average Delay (ms)');
grid on;
legend('Average Delay', 'Confidence Interval');

% Create a new figure for Average Delay of VoIP Packets
figure(2);
bar(voip_flows, APD_voip_values);
hold on;
errorbar(voip_flows, APD_voip_values, APD_voip_terms, 'g.', 'CapSize', 10);
title('Average Delay of VoIP Packets');
xlabel('Number of VoIP Flows');
ylabel('Average Delay (ms)');
grid on;
legend('Average Delay', 'Confidence Interval');

% Create a new figure for Average Queuing Delay of Data Packets
figure(3);
bar(voip_flows, APQD_data_values);
hold on;
errorbar(voip_flows, APQD_data_values, APQD_data_terms, 'b.', 'CapSize', 10);
title('Average Queuing Delay of Data Packets');
xlabel('Number of VoIP Flows');
ylabel('Average Queuing Delay (ms)');
grid on;
legend('Average Queuing Delay', 'Confidence Interval');

% Create a new figure for Average Queuing Delay of VoIP Packets
figure(4);
bar(voip_flows, APQD_voip_values);
hold on;
errorbar(voip_flows, APQD_voip_values, APQD_voip_terms, 'm.', 'CapSize', 10);
title('Average Queuing Delay of VoIP Packets');
xlabel('Number of VoIP Flows');
ylabel('Average Queuing Delay (ms)');
grid on;
legend('Average Queuing Delay', 'Confidence Interval');
