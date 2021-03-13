%% 
clc
clear all
close all
addpath('./data/');
addpath('./models/');
addpath('./results/overview');
addpath('./models/SIR');
N = 60.*10^6;
[data, dates] = getData;
I = cast((data.totale_positivi), 'double'); 
R = cast((data.dimessi_guariti), 'double');
X0= [N I(1) R(1)]; 
%% simulation

beta = 0.967/N;      
gamma = 0.37; 
p = [beta, gamma];
timeV = 1:1:50;
err = rand(1, 50);
[t,X] = ode23s(@(t,x) SIR(t,x,p), timeV, X0);  
S = X(:, 1); I = X(:, 2); R = X(:, 3);

plot(t,S,'b',t,I,'r',t,R,'g','LineWidth',2); 
xlabel('Days'); ylabel('Number of individuals');
legend('S','I','R'); title('SIR model')

%% simulation

beta = 0.008;      
gamma = 0.01; 
p = [beta, gamma];
timeV = 1:1:50;
err = rand(1, 50);
[t,X] = ode23s(@(t,x) SIR(t,x,p), timeV, X0);  
S = X(:, 1); I = X(:, 2); R = X(:, 3);

plot(t,S,'b',t,I,'r',t,R,'g','LineWidth',2); 
xlabel('Days'); ylabel('Number of individuals');
legend('S','I','R'); title('SIR model')
