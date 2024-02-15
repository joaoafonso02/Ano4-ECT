% 1 a
p = 0.6;
n = 4;
ans1a = p + (1-p)/n

% 1 b
p = 0.7;
n = 5;
ans1b = (p * n) / (1 + (n-1) * p) 

% 1 c
x = linspace(0,1,10);
x3 = x + 1/3 * (1-x);
x4 = x + 1/4 * (1-x);
x5 = x + 1/5 * (1-x);

figure(1)
plot(x*100, x3*100, 'b-', x*100, x4*100, 'r--', x*100, x5*100, 'g' )
title('1 c')
legend('answer3', 'answer4', 'answer5','location', 'northwest')
grid on
ylim([0 100])
yticks(0:20:100)

% 1 d
x = linspace(0, 1, 100);

k3 = (x*3)./(1 + (3-1)*x);
k4 = (x*4)./(1 + (4-1)*x);
k5 = (x*5)./(1 + (5-1)*x);

figure(2);
plot(100*x, 100*k3, 'b', 100*x, 100*k4, 'r--', 100*x, 100*k5, 'g');
yticks(0:20:100);
xticks(0:10:100);
legend('n=3','n=4','n=5', 'location','northwest');
ylim([0, 100]);
grid on;

