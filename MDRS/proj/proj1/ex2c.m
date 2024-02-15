fprintf('2.c)\n');
lambda = 1500;  % pps
C = 10;         % Mbps
f = 1000000;    % Bytes
P = 100000;     % Stopping criterion
num_runs = 20;

% Number of VoIP flows
voip_flows = [10, 20, 30, 40];

% Confidence level
alfa = 0.1;  % 90% confidence level

% Calculation of the probability associated with each packet size
prob = (1 - (0.19 + 0.23 + 0.17)) / ((109 - 65 + 1) + (1517 - 111 + 1));

bytes = 110:130;
bytes_times_8 = bytes * 8;

for n = voip_flows
    S_data = zeros(1, length(bytes));  % E[S] for data packets
    S2_data = zeros(1, length(bytes)); % E[S^2] for data packets

    S_voip = zeros(1, length(bytes));  % E[S] for VoIP packets
    S2_voip = zeros(1, length(bytes)); % E[S^2] for VoIP packets

    for j = 1:length(bytes)
        if j == 1
            S_data(j) = (bytes_times_8(j)) / (C * 10^6) * 0.19;
            S2_data(j) = ((bytes_times_8(j)) / (C * 10^6))^2 * 0.19;
        elseif j == 110 - 64 + 1
            S_data(j) = (bytes_times_8(j)) / (C * 10^6) * 0.23;
            S2_data(j) = ((bytes_times_8(j)) / (C * 10^6))^2 * 0.23;
        elseif j == 1518 - 64 + 1
            S_data(j) = (bytes_times_8(j)) / (C * 10^6) * 0.17;
            S2_data(j) = ((bytes_times_8(j)) / (C * 10^6))^2 * 0.17;
        else
            S_data(j) = (bytes_times_8(j)) / (C * 10^6) * prob;
            S2_data(j) = ((bytes_times_8(j)) / (C * 10^6))^2 * prob;
        end

        % Adjust weights based on the number of VoIP flows
        S_voip(j) = S_data(j) * (1 - 1/n);
        S2_voip(j) = S2_data(j) * (1 - 1/n);

    end

    ES_data = sum(S_data);
    ES2_data = sum(S2_data);

    ES_voip = sum(S_voip);
    ES2_voip = sum(S2_voip);

    % Calculate traffic intensity for data and VoIP
    rho_data = lambda * ES_data;
    rho_voip = lambda * ES_voip;

    % Calculate Average Delay and Average Queuing Delay
    W_data = (lambda * ES2_data + lambda * ES_data^2) / (2 * (1 - rho_data)) + ES_data;
    Wq_voip = (lambda * ES2_voip + lambda * ES_voip^2) / (2 * (1 - rho_voip)) + ES_voip;

    fprintf('For n = %d VoIP Flows:\n', n);
    fprintf('APD data n%d (milliseconds) = %.4f\n', n, W_data * 10^3);
    fprintf('AQD voip n%d (milliseconds) = %.4f\n', n, Wq_voip * 10^3);
    fprintf('\n');
end
