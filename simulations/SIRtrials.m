%% 
clc
clear all
close all
addpath('./data/');
addpath('./models/');
addpath('./results/overview');
addpath('./models/SIR');
addpath('./models/SEIR');
addpath('./models/SEIIR');
addpath('./models/SEIIRHD');
N = 60.*10^6;
[data, dates] = getData;
I = cast((data.totale_positivi), 'double'); 
R = cast((data.dimessi_guariti), 'double');

X0= [N I(1) R(1)]; 
%% simulation

% prima simulazione
beta = 0.967/N;      
gamma = 0.37; 
p = [beta, gamma];
timeV = 1:1:50; % tempo asse x
err = rand(1, 50);
% modificare modello -> SIR
% passare nuovo vettore di parametri p
[t,X] = ode23s(@(t,x) SIR(t,x,p), timeV, X0);  
S = X(:, 1); I = X(:, 2); R = X(:, 3);

%seconda simulazione
beta = 0.5/N;      
gamma = 0.3; 
p = [beta, gamma];
timeV = 1:1:50; % tempo asse x
err = rand(1, 50);
% modificare modello -> SIR
% passare nuovo vettore di parametri p
[t,X1] = ode23s(@(t,x) SIR(t,x,p), timeV, X0);  
S1 = X1(:, 1); I1 = X1(:, 2); R1 = X1(:, 3);


plot(t,I,'b',t,I1,'r','LineWidth',2); 
xlabel('Time'); ylabel('Number of individuals');
legend('I','I1'); title('Infected')

