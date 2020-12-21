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
% S0 = N;
% I0 = covid_data.nuovi_positivi(1);
% R0 = covid_data.dimessi_guariti(1) + covid_data.deceduti(1);
% X0 = [S0 E0 I0 R0]; 

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
T = length(covid_data.data);
%figure(1);
t0 = find(covid_data.data=="2020-10-08"); %"2020-10-08"
I0 = I(t0);
R0 = R(t0);
S0 = N-I0-R0;
X0 = [S0 I0 R0]/N;

tf = find(covid_data.data=="2020-11-05");  %10-30
T = tf;
t_vector = t0:1:T;
data = [I(t0:1:T); R(t0:1:T)]/N;
p0 = [lambda, gamma0];
p_estimate_SIR= fminsearch(@(p) fit_SIR(t_vector, data, p, X0),p0);
p_estimate_SIR
%% PLOT SIR
[t,X1] = ode23s(@(t,x) SIR(t,x, p_estimate_SIR), t0:1:tf+7, X0);   

I_pred = X1(:, 2); 
R_pred = X1(:, 3);

figure(1)

plot(t0:T, I(t0:T),'ro');hold on; 
plot(t,N*I_pred,'r', 'LineWidth',2);
plot(t0:T, R(t0:T),'go');hold on;
plot(t, N*R_pred,'g', 'LineWidth',2);
xlabel('Days');ylabel('Number di individui');
title('Fitting');
set(gca,'FontSize',14)

%%
% FITTING SEIR MODEL
% [S, E, I, R]
% S0 = N;
% E0 = covid_data.isolamento_domiciliare(1);
% I0 = covid_data.nuovi_positivi(1);
% R0 = covid_data.dimessi_guariti(1) + covid_data.deceduti(1);
% X0 = [S0 E0 I0 R0]; 

E = cast(covid_data.isolamento_domiciliare, 'double');
I = cast(covid_data.totale_positivi, 'double');
R = cast(covid_data.dimessi_guariti + covid_data.deceduti, 'double');
S = N-E-I-R;

% DA RIVEDERE PARAMETRI INIZIALI
S0 = N;
%lambda0 = 1 / S0;
% R0 = 2.6
% gamma = 0.37
% Lambda0 = R0*gamma
%lambda0 = 0.962/S0;
t_incubation = 3; % 5.1 da verificare con paper con studi su Italia
alpha0=1/t_incubation;
%gamma0 = 0.37; 
% gamma0 da paper 0.37
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
t0 = find(covid_data.data=="2020-10-08"); %"2020-10-08"
E0 = E(t0);
I0 = I(t0);
R0 = R(t0);
S0 = N-E0-I0-R0;
X0 = [S0 E0 I0 R0]/N;

tf = find(covid_data.data=="2020-11-05");  %10-30
T = tf;
t_vector = t0:1:T;
data = [E(t0:1:T); I(t0:1:T); R(t0:1:T)]/N;
p0 = [lambda, alpha0, gamma0];
p_estimate= fminsearch(@(p) fit_SEIR(t_vector, data, p, X0),p0);
p_estimate

%% PLOT SEIR
[t,X1] = ode23s(@(t,x) SEIR(t,x, p_estimate), t0:1:tf+7, X0);   

E_pred = X1(:, 2); 
I_pred = X1(:, 3); 
R_pred = X1(:, 4);

figure(1)
plot(t0:T, E(t0:T),'bo');hold on; 
plot(t,N*E_pred,'b', 'LineWidth',2);
plot(t0:T, I(t0:T),'ro');hold on; 
plot(t,N*I_pred,'r', 'LineWidth',2);
plot(t0:T, R(t0:T),'go');hold on;
plot(t, N*R_pred,'g', 'LineWidth',2);
xlabel('Days');ylabel('Number di individui');
title('Fitting');
set(gca,'FontSize',14)

%% FITTING SEIRL MODEL

E = cast(covid_data.isolamento_domiciliare, 'double');
I = cast(covid_data.totale_positivi, 'double');
R = cast(covid_data.dimessi_guariti + covid_data.deceduti, 'double');
L = cast(covid_data.totale_ospedalizzati, 'double');
S = N-E-I-R-L;