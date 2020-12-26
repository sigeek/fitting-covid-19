%% 
clc
clear all
close all
% GET DATA FROM SCRIPT
% add folders to path
addpath('./data/');
addpath('./models/');

%retrieve the data struct
covid_data = getData;
N = 60.*10^6;
%% FITTING SIR MODEL
% [S, I, R]

I = cast(covid_data.totale_positivi, 'double');
R = cast(covid_data.dimessi_guariti + covid_data.deceduti, 'double');
S = N-I-R;

% DA RIVEDERE PARAMETRI INIZIALI
S0 = N;
%lambda0 = 1 / S0;
% R0 = 2.6
% gamma = 0.37
% Lambda0 = R0*gamma
lambda0 = 0.962/S0;
gamma0 = 0.37; 
% gamma0 da paper 0.37

% adimensional SEIR model for fitting
% We divide every variable by N
% s = S/N, e= E/N etc.
% [s, i, r]
% s' = -(lambda*N)*(S/N)*(I/N) = -(lambda*N)*s*i
% i' = (lambda*N)*(S/N)*(I/N) - (gamma)*(I/N) = (lambda*N)*s*i - gamma*i
% r' = gamma*(I/N) = gamma*i


lambda = lambda0*N;
dates = covid_data.data;
T = length(dates);
t0 = find(dates=="2020-10-08"); %"2020-10-08"
I0 = I(t0);
R0 = R(t0);
S0 = N-I0-R0;
X0 = [S0 I0 R0]/N;

tf = find(dates=="2020-11-05");  %10-30
t_vector = t0:1:tf;
data = [I(t0:1:tf); R(t0:1:tf)]/N;
p0 = [lambda, gamma0];
p_estimate_SIR= fminsearch(@(p) fit_SIR(t_vector, data, p, X0),p0);
%p_estimate_SIR 

%% PLOT SIR
% 7 days forecasts
% p_estimate_SIR = [0.0857, 0.0140];
[t_7d,X_7d] = ode23s(@(t,x) SIR(t,x, p_estimate_SIR), t0:1:tf+7, X0);   

I_pred = X_7d(:, 2); 
R_pred = X_7d(:, 3);


figure(1)
subplot(1,3,1);
xline(tf,'--m');hold on;
plot(t0:tf+7, I(t0:tf+7),'ro');hold on; 
plot(t_7d,N*I_pred,'r', 'LineWidth',2);
plot(t0:tf+7, R(t0:tf+7),'go');hold on;
plot(t_7d, N*R_pred,'g', 'LineWidth',2);
xlabel('Days');ylabel('Number of individuals');
legend('Start forecast', 'I (reported)','I (fitted)', ...
    'R (reported)', 'R (fitted)', 'Location', 'northwest');
title('SIR: 7 days forecasts');
set(gca,'FontSize',12)

% 14 days forecasts
[t_14d,X_14d] = ode23s(@(t,x) SIR(t,x, p_estimate_SIR), t0:1:tf+14, X0);   

I_pred = X_14d(:, 2); 
R_pred = X_14d(:, 3);

subplot(1,3,2);
xline(tf,'--m');hold on;
plot(t0:tf+14, I(t0:tf+14),'ro');hold on; 
plot(t_14d,N*I_pred,'r', 'LineWidth',2);
plot(t0:tf+14, R(t0:tf+14),'go');hold on;
plot(t_14d, N*R_pred,'g', 'LineWidth',2);
xlabel('Days');ylabel('Number of individuals');
legend('Start forecast','I (reported)','I (fitted)', 'R (reported)', 'R (fitted)', 'Location', 'northwest');
title('SIR: 14 days forecasts');
set(gca,'FontSize',12)

% 21 days forecasts
[t_21d,X_21d] = ode23s(@(t,x) SIR(t,x, p_estimate_SIR), t0:1:tf+21, X0);   

I_pred = X_21d(:, 2); 
R_pred = X_21d(:, 3);

subplot(1,3,3);
xline(tf,'--m');hold on;
plot(t0:tf+21, I(t0:tf+21),'ro');hold on; 
plot(t_21d,N*I_pred,'r', 'LineWidth',2);
plot(t0:tf+21, R(t0:tf+21),'go');hold on;
plot(t_21d, N*R_pred,'g', 'LineWidth',2);
xlabel('Days');ylabel('Number of individuals');
legend('Start forecast','I (reported)','I (fitted)', 'R (reported)', 'R (fitted)', 'Location', 'northwest');
title('SIR: 21 days forecasts');
set(gca,'FontSize',12)



%% FITTING SEIR MODEL
% [S, E, I, R]

%E = cast(covid_data.isolamento_domiciliare, 'double');
I = cast(covid_data.totale_positivi, 'double');
R = cast(covid_data.dimessi_guariti + covid_data.deceduti, 'double');
E = 0.09*(I); % 0.09
S = N-E-I-R;

% DA RIVEDERE PARAMETRI INIZIALI
S0 = N;
%lambda0 = 1 / S0;
% R0 = 2.6
% gamma = 0.37
% Lambda0 = R0*gamma
%lambda0 = 0.962/S0;
t_incubation = 3; %3, 5.1 da verificare con paper con studi su Italia
alpha0=1/t_incubation;
%gamma0 = 0.37; 
% gamma0 da paper 0.37

% initial lambda and gamma are taken from the previous simulation results 
lambda0 = p_estimate_SIR(1);
gamma0 = p_estimate_SIR(2);

% adimensional SEIR model for fitting
% We divide every variable by N
% s = S/N, e= E/N etc.
% [s, e, i, r]
% s' = -(lambda*N)*(S/N)*(I/N) = -(lambda*N)*s*i
% e' = (lambda*N)*(S/N)*(I/N) - alpha*(E/N) = (lambda*N)*s*i - alpha*e
% i' = alpha*(E/N)-gamma*(I/N) = alpha*e-gamma*i
% r' = gamma*(I/N) = gamma*i


lambda = lambda0*N;
T = length(covid_data.data);
%figure(1);
t0 = find(dates=="2020-10-08"); %"2020-10-08"
E0 = E(t0);
I0 = I(t0);
R0 = R(t0);
S0 = N-E0-I0-R0;
X0 = [S0 E0 I0 R0]/N;

tf = find(dates=="2020-11-05");  %10-30
t_vector = t0:1:tf;
data = [E(t0:1:tf); I(t0:1:tf); R(t0:1:tf)]/N;
p0 = [lambda, alpha0, gamma0];
p_estimate_SEIR = fminsearch(@(p) fit_SEIR(t_vector, data, p, X0),p0);
p_estimate_SEIR

%% PLOT SEIR
% p_estimate_SEIR = [0.0931, 0.8574, 0.0139 ];
% 7 days forecasts
[t_7d,X_7d] = ode23s(@(t,x) SEIR(t,x, p_estimate_SEIR), t0:1:tf+7, X0);   

E_pred = X_7d(:, 2); 
I_pred = X_7d(:, 3); 
R_pred = X_7d(:, 4);


figure(1)
subplot(1,3,1);
xline(tf,'--m');hold on;
plot(t0:tf+7, E(t0:tf+7),'bo');hold on; 
plot(t_7d,N*E_pred,'b', 'LineWidth',2);
plot(t0:tf+7, I(t0:tf+7),'ro');hold on; 
plot(t_7d,N*I_pred,'r', 'LineWidth',2);
plot(t0:tf+7, R(t0:tf+7),'go');hold on;
plot(t_7d, N*R_pred,'g', 'LineWidth',2);
xlabel('Days');ylabel('Number of individuals');
legend('Start forecast', 'E (reported)','E (fitted)',...
    'I (reported)','I (fitted)', 'R (reported)', 'R (fitted)',...
    'Location', 'northwest');
title('SEIR: 7 days forecasts');
set(gca,'FontSize',12);

% 14 days forecasts
[t_14d,X_14d] = ode23s(@(t,x) SEIR(t,x, p_estimate_SEIR), t0:1:tf+14, X0);   

E_pred = X_14d(:, 2); 
I_pred = X_14d(:, 3); 
R_pred = X_14d(:, 4);

subplot(1,3,2);
xline(tf,'--m');hold on;
plot(t0:tf+14, E(t0:tf+14),'bo');hold on; 
plot(t_14d,N*E_pred,'b', 'LineWidth',2);
plot(t0:tf+14, I(t0:tf+14),'ro');hold on; 
plot(t_14d,N*I_pred,'r', 'LineWidth',2);
plot(t0:tf+14, R(t0:tf+14),'go');hold on;
plot(t_14d, N*R_pred,'g', 'LineWidth',2);
xlabel('Days');ylabel('Number of individuals');
legend('Start forecast', 'E (reported)','E (fitted)',...
    'I (reported)','I (fitted)', 'R (reported)', 'R (fitted)',...
    'Location', 'northwest');
title('SEIR: 14 days forecasts');
set(gca,'FontSize',12);

% 21 days forecasts
[t_21d,X_21d] = ode23s(@(t,x) SEIR(t,x, p_estimate_SEIR), t0:1:tf+21, X0);   

E_pred = X_21d(:, 2); 
I_pred = X_21d(:, 3); 
R_pred = X_21d(:, 4);

subplot(1,3,3);
xline(tf,'--m');hold on;
plot(t0:tf+21, E(t0:tf+21),'bo');hold on; 
plot(t_21d,N*E_pred,'b', 'LineWidth',2);
plot(t0:tf+21, I(t0:tf+21),'ro');hold on; 
plot(t_21d,N*I_pred,'r', 'LineWidth',2);
plot(t0:tf+21, R(t0:tf+21),'go');hold on;
plot(t_21d, N*R_pred,'g', 'LineWidth',2);
xlabel('Days');ylabel('Number of individuals');
legend('Start forecast', 'E (reported)','E (fitted)', ...
    'I (reported)','I (fitted)', 'R (reported)', 'R (fitted)',...
    'Location', 'northwest');
title('SEIR: 21 days forecasts');
set(gca,'FontSize',12);
%% FITTING SEIRL MODEL

I = cast(covid_data.totale_positivi, 'double');
R = cast(covid_data.dimessi_guariti + covid_data.deceduti, 'double');
L = cast(covid_data.totale_ospedalizzati + covid_data.isolamento_domiciliare, 'double');
E = 0.09*(I);
S = N-E-I-R-L;

lambda0 = p_estimate_SEIR(1);
alpha0 = p_estimate_SEIR(2);
gamma0 = p_estimate_SEIR(3);
delta0= 0.07; %1/33

lambda = lambda0*N;
T = length(covid_data.data);
%figure(1);
t0 = find(dates=="2020-10-08"); %"2020-10-08"
E0 = E(t0);
I0 = I(t0);
R0 = R(t0);
L0 = L(t0);
S0 = N-E0-I0-R0;
X0 = [S0 E0 I0 R0 L0]/N;

tf = find(dates=="2020-11-05");  %10-30
t_vector = t0:1:tf;
data = [E(t0:1:tf); I(t0:1:tf); R(t0:1:tf); L(t0:1:tf)]/N;
p0 = [lambda, alpha0, gamma0, delta0];
p_estimate_SEIRL = fminsearch(@(p) fit_SEIRL(t_vector, data, p, X0),p0);
p_estimate_SEIRL

%% PLOT SEIRL
[t_7d,X_7d] = ode23s(@(t,x) SEIRL(t,x, p_estimate_SEIRL), t0:1:tf+7, X0);   

E_pred = X_7d(:, 2); 
I_pred = X_7d(:, 3); 
R_pred = X_7d(:, 4);
L_pred = X_7d(:, 5);


figure(1)
xline(tf,'--m');hold on;
plot(t0:tf+7, E(t0:tf+7),'bo');hold on; 
plot(t_7d,N*E_pred,'b', 'LineWidth',2);
plot(t0:tf+7, I(t0:tf+7),'ro');hold on; 
plot(t_7d,N*I_pred,'r', 'LineWidth',2);
plot(t0:tf+7, R(t0:tf+7),'go');hold on;
plot(t_7d, N*R_pred,'g', 'LineWidth',2);
plot(t_7d,N*L_pred,'y', 'LineWidth',2);
plot(t0:tf+7, L(t0:tf+7),'yo');hold on;
plot(t_7d, N*L_pred,'y', 'LineWidth',2);
xlabel('Days');ylabel('Number of individuals');
legend('Start forecast', 'E (reported)','E (fitted)', ...
    'I (reported)','I (fitted)', 'R (reported)', 'R (fitted)', ...
    'L (reported)', 'L (fitted)', 'Location', 'northwest');
title('SEIRL: 7 days forecasts');
set(gca,'FontSize',12);