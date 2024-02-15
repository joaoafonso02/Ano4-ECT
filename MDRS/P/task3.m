%% 3 a
states = [10^-6 10^-5 10^-4 10^-3 10^-2];
den = 1 + 8/600 + 8/600 * 5/100 + 8/600 * 5/100 * 2/20 + 8/600 * 5/100 * 2/20 * 1/5;

p(1) = 1 / den 
p(2) = (8/600) / den
p(3) = (8/600 * 5/100) / den
p(4) = (8/600 * 5/100 * 2/20) / den
p(5) = (8/600 * 5/100 * 2/20 * 1/5) / den

%% 3 b
fprintf("3b: the average percentage of time the link is in each of the five states is the same as their probabilities")

%% 3 c
avgBer = sum(p .* states)

%% 3 d
% Tempo médio de permanência T = 1/q inverso das saidas 
avgtime(1) = 1/8; % horas
avgtime(2) = 1/(600 + 5);
avgtime(3) = 1/(100 + 2);
avgtime(4) = 1/(20 + 1);
avgtime(5) = 1/5;

avgtimeInMinutes = zeros(1, length(avgtime));

% Calculate avgTime * 60 for each element and print
for i = 1:length(avgtime)
    avgtimeInMinutes(i) = avgtime(i) * 60;
    fprintf('avgTime(%d) in minutes: %.2f\n', i, avgtimeInMinutes(i));
end

%% 3 e
normal_state = sum(p(1:3))
interference_state = sum(p(4:5))

%% 3 f
avgBerNormal = sum(p(1:3) .* states(1:3)) / normal_state
avgBerInterference = sum(p(4:5) .* states(4:5)) / interference_state

%% 3 g
packet_Size = 64:1500;
bits = 8;
p_oneError = zeros(5, length(packet_Size));

for i = 1 : 5
    % soma de todos os estados vezes probabilidade do estado i
    % aqui é "1 - ..." pq ha erros, caso n houvesse, era de ocultar
    p_oneError = p_oneError + (1 - (1 - states(i)) .^ (packet_Size .* bits)) * p(i);
end

figure(1);
plot(packet_Size, p_oneError, 'b');
title('Prob. of at least one error');
grid on;

%% 3 h
packet_Size = 64:1500;
bits = 8;
p_oneErrorNormal = zeros(5, length(packet_Size));

for i = 1 : 3
    % soma de todos os estados vezes probabilidade do estado i
    p_oneErrorNormal = (p_oneErrorNormal + (1 - (1 - states(i)) .^ (packet_Size .* bits)) * p(i));
end 

p_oneErrorNormal = p_oneErrorNormal ./ p_oneError;
figure(2);
plot(packet_Size, p_oneErrorNormal, 'b');
title('Prob. of Normal State');
grid on;

%% 3 i
packet_Size = 64:1500;
bits = 8;
p_noErrorInter = zeros(5, length(packet_Size));

for i = 1 : 3
    p_noErrorInter = (p_noErrorInter + ((1 - states(i)) .^ (packet_Size .* bits)) * p(i));
end 

p_no = 0
for i = 4 : 5
    p_no = (p_no + ((1 - states(i)) .^ (packet_Size .* bits)) * p(i));
end 

p_noErrorInter = p_no ./ p_noErrorInter;

figure(2);
semilogy(packet_Size, p_noErrorInter, 'b');
title('Prob. of Intereference State');
grid on;


