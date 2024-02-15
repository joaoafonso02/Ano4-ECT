% Caso estejamos a considerar um sitema mmodelado por um modelo de queueing M/G/1 
   % (1) a chegada de clientes é um processo de Poisson com taxa 
   % (2) o tempo de atendimento S do servidor tem uma distribuição
   % genérica e independente das chegadas dos clientes
   % (3) o sistema tem 1 servidor
   % (4) o sistema acomoda um número infinito de clientes

   % De forma a obter o atraso medio, que corresponde à soma do atraso médio na fila de espera + o tempo medio de atendimento
   % teremos que recorrer a formula ... ()slide 53/60 em que apenas temos conhecimento do lambda que é 1800
   % pacotes por segundo, em seguida, terá que ser calculado portanto as
   % variávies q faltam: E[S] & E[S^2] e por fim obter os resultados

fprintf('\n1.b)\n');
lambda = 1800;          % pps
f = 1000000;            % Bytes
C = [10, 20, 30, 40];   % 10, 20, 30, 40 Mbps

% Calculation of the probability associated with each packet size
prob = (1 - (0.19 + 0.23 + 0.17)) / ((109 - 65 + 1) + (1517 - 111 + 1)); % calculating the probability associated with each packet size that is not 64, 110, or 1518 bytes

bytes = 64:1518;

% Loop through each link capacity to calculate E[S] & E[S^2]
for i = 1:length(C)

    S = (bytes .* 8)./(C(i)*10^6);  % E[S]
    S2 = (bytes .* 8)./(C(i)*10^6); % E[S^2]

    for j = 1:length(bytes)
        if j == 1
            S(j) = S(j) * 0.19;
            S2(j) = S2(j)^2 * 0.19;
        elseif j == 110 - 64 + 1
            S(j) = S(j) * 0.23;
            S2(j) = S2(j)^2 * 0.23;
        elseif j == 1518 - 64 + 1
            S(j) = S(j) * 0.17;
            S2(j) = S2(j)^2 * 0.17;
        else
            S(j) = S(j) * prob;
            S2(j) = S2(j)^2 * prob;
        end
    end

    ES = sum(S);
    ES2 = sum(S2);

    w = lambda * ES2 / (2 * (1 - lambda * ES)) + ES;

    fprintf("For C = %2d Mbps: -->", C(i));
    fprintf(" Av. Packet Delay %.2e (ms)\n", w * 10^3);
end


% as the link capacity (C) increases, the average packet delay decreases, which is in line with the expected behavior in a queuing system.