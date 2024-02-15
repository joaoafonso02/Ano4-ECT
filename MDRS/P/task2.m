% 2 a
p = 10^-2;

answ2a = nchoosek(100*8, 0) * (1-p)^(100*8)*100 % 100 bytes = 100*8 bits

% 2 b
p = 10^-3;

answ2b = nchoosek(1000*8, 1) * p * (1-p)^(1000*8 - 1)*100

% 2 c
p = 10^-4;

answ2c = (1 - nchoosek(200*8, 0) * (1-p)^(200*8)) *100