%% 
clc
clear all
close all
% GET DATA FROM SCRIPT
% add folders to path
addpath('./data/');
addpath('./models/');
addpath('./models/SIR');
addpath('./models/SEIR');
addpath('./models/SEIRH');
addpath('./models/SEIRD');

%retrieve the data struct
data = getData;
dates = data.data;
N = 60.*10^6;
%% FITTING SIR MODEL
% [S, I, R]

S0 = N;
% paper SEIR
%lambda0 = 1 / S0;
% R0 = 2.6
% gamma = 0.37
% Lambda0 = R0*gamma
lambda0 = 0.962/S0;
gamma0 = 0.37; 

% adimensional SEIR model for fitting
% We divide every variable by N
% s = S/N, e= E/N etc.
% [s, i, r]
% s' = -(lambda*N)*(S/N)*(I/N) = -(lambda*N)*s*i
% i' = (lambda*N)*(S/N)*(I/N) - (gamma)*(I/N) = (lambda*N)*s*i - gamma*i
% r' = gamma*(I/N) = gamma*i

I = cast(data.totale_positivi, 'double');
R = cast(data.dimessi_guariti + data.deceduti, 'double');
S = N-I-R;
X_SIR = [S, I, R];
X_ad_SIR = [S, I, R]/N;

% initial conditions
t0 = find(dates=="2020-10-08"); % 10-08
tf = find(dates=="2020-11-05"); % 11-05
I0 = I(t0);
R0 = R(t0);
S0 = N-I0-R0;
X0_ad_SIR = [S0 I0 R0]/N;

lambda0 = lambda0*N;
p0_SIR = [lambda0, gamma0];

p_SIR = fit_SIR(X_ad_SIR, X0_ad_SIR, p0_SIR,t0,tf);
%% PLOT SIR
tp = [7, 14, 21];
plot_SIR(X_SIR, X0_ad_SIR, N, p_SIR, t0, tf, tp);
%% FITTING SEIR MODEL
% [S, E, I, R]

E = 0.1*(I); 
S = N-I-E-R;
X = [S, E, I, R];
X_SEIR = [S, E, I, R];
X_ad_SEIR = [S, E, I, R]/N;

% adimensional SEIR model for fitting
% We divide every variable by N
% s = S/N, e= E/N etc.
% [s, e, i, r]
% s' = -(lambda*N)*(S/N)*(I/N) = -(lambda*N)*s*i
% e' = (lambda*N)*(S/N)*(I/N) - alpha*(E/N) = (lambda*N)*s*i - alpha*e
% i' = alpha*(E/N)-gamma*(I/N) = alpha*e-gamma*i
% r' = gamma*(I/N) = gamma*i

E0 = E(t0);
I0 = I(t0);
R0 = R(t0);
S0 = N-E0-I0-R0;
X0_ad_SEIR = [S0 E0 I0 R0]/N;


% DA RIVEDERE PARAMETRI INIZIALI
S0 = N;
%lambda0 = 1 / S0;
% R0 = 2.6
% gamma = 0.37
% Lambda0 = R0*gamma
%lambda0 = 0.962/S0;
t_incubation = 5.1; %5.1 da verificare con paper con studi su Italia
alpha0=1/t_incubation;
%gamma0 = 0.37; 
% gamma0 da paper 0.37

% initial lambda and gamma are taken from the previous simulation results 
lambda0 = p_SIR(1);
gamma0 = p_SIR(2);
p0_SEIR = [lambda0, alpha0, gamma0];

p_SEIR = fit_SEIR(X_ad_SEIR, X0_ad_SEIR, p0_SEIR, t0, tf);

%% PLOT SEIR
plot_SEIR(X_SEIR, X0_ad_SEIR, N, p_SEIR, t0, tf, tp);

%% FITTING SEIRD MODEL

S = N-E-I-R;
D = cast(data.deceduti, 'double');
X_SEIRD = [S, E, I, R, D];
X_ad_SEIRD = [S, E, I, R, D]/N;

E0 = E(t0);
I0 = I(t0);
%H0 = H(t0);
R0 = R(t0);
D0 = D(t0);
X0_ad_SEIRD = [S0 E0 I0 R0 D0]/N;

lambda0 = p_SEIR(1);
alpha0 = p_SEIR(2);
gamma0 = p_SEIR(3);
d0 = 0.04;
ro0 = 1/9;

p0_SEIRD = [lambda0, alpha0, gamma0, d0, ro0 ];

p_SEIRD = fit_SEIRD(X_ad_SEIRD, X0_ad_SEIRD, p0_SEIRD, t0, tf);
p_SEIRD
%% PLOT SEIRD
plot_SEIRD(X_SEIRD, X0_ad_SEIRD, N, p_SEIRD, t0, tf, tp);
%% FITTING SEIRD MODEL, longer period

S = N-E-I-R;
D = cast(data.deceduti, 'double');
X_SEIRD = [S, E, I, R, D];
X_ad_SEIRD = [S, E, I, R, D]/N;

t0 = find(dates=="2020-10-08"); 
tf = find(dates=="2020-11-30"); 

E0 = E(t0);
I0 = I(t0);
%H0 = H(t0);
R0 = R(t0);
D0 = D(t0);
X0_ad_SEIRD = [S0 E0 I0 R0 D0]/N;

lambda0 = 0.962/S0*N;
gamma0 = 0.37; 
t_incubation = 5.1; %5.1 da verificare con paper con studi su Italia
alpha0=1/t_incubation;
d0 = 0.04;
ro0 = 1/9;

p0_SEIRD = [lambda0, alpha0, gamma0, d0, ro0];

p_SEIRD = fit_SEIRD(X_ad_SEIRD, X0_ad_SEIRD, p0_SEIRD, t0, tf);
p_SEIRD

%% PLOT SEIRD
plot_SEIRD(X_SEIRD, X0_ad_SEIRD, N, p_SEIRD, t0, tf, tp);

%% FITTING SEIRH MODEL

S = N-E-I-R;
X_SEIRH = [S, E, I, R];
X_ad_SEIRH = [S, E, I, R]/N;

E0 = E(t0);
I0 = I(t0);
%H0 = H(t0);
R0 = R(t0);
S0 = S(t0);
X0_ad_SEIRH = [S0 E0 I0 R0]/N;

lambda0 = p_SEIR(1);
alpha0 = p_SEIR(2);
gamma0 = p_SEIR(3);
%h0 = (0.084+0.088+0.093+0.08)/4;
h0 = 0.0863;
p0_SEIRH = [lambda0, alpha0, gamma0, h0];

p_SEIRH = fit_SEIRH(X_ad_SEIRH, X0_ad_SEIRH, p0_SEIRH, t0, tf);
p_SEIRH
%% PLOT SEIRH
plot_SEIRH(X_SEIRH, X0_ad_SEIRH, N, p_SEIRH, t0, tf, tp);
