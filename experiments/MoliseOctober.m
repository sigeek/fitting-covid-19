%% 
clc
clear all
close all
% GET DATA FROM SCRIPT
% add folders to path
addpath('./data/');
addpath('./models/');
addpath('./results/');
addpath('./results/overview');
addpath('./results/january');
addpath('./results/october');
addpath('./models/SIR');
addpath('./models/SEIR');
addpath('./models/SEIIR');
addpath('./models/SEIIRHD');

%retrieve the data structs
[data, dates] = getDataByRegion("Molise");
sizes = size(dates);
size_data = sizes(2);
N = 300516;
%% PLOT DATA
t0 = find(dates=="08-Oct-2020"); 
tf = find(dates=="05-Nov-2020");  
plot_data(data, dates(t0:tf), N, t0, tf, "./results/october/Molise/octoberPlot.png");
%% FITTING SIR MODEL 
beta0 = 0.962/N;  
gamma0 = 0.37; 

I = cast((data.totale_positivi), 'double'); 
R = cast((data.dimessi_guariti), 'double');
S = N-I-R;
X_SIR = [S, I, R];
X_ad_SIR = [S, I, R]/N;

% initial conditions
I0 = I(t0);
R0 = R(t0);
S0 = N-I0-R0;
X0_ad_SIR = [S0 I0 R0]/N;

beta0 = beta0*N;
p0_SIR = [beta0, gamma0];

p_SIR = fit_SIR(X_ad_SIR, X0_ad_SIR, p0_SIR, t0, tf);
fprintf("--- SIR FITTING DONE --- \n");
fprintf("beta: %f, gamma: %f \n", p_SIR(1), p_SIR(2));
%% PLOT SIR 
close all
tp = [7, 14, 21];
plot_SIR(X_SIR, X0_ad_SIR, N, p_SIR, dates, t0, tf, tp, "./results/october/Molise/SIR_fitting.png");
%% FITTING SEIR MODEL
% [S, E, I, R]

E = 0.3*(I); 
S = N-I-E-R;
X = [S, E, I, R];
X_SEIR = [S, E, I, R];
X_ad_SEIR = [S, E, I, R]/N;

% adimensional SEIR model for fitting
% We divide every variable by N
% s = S/N, e= E/N etc.
% [s, e, i, r]
% s' = -(beta*N)*(S/N)*(I/N) = -(beta*N)*s*i
% e' = (beta*N)*(S/N)*(I/N) - alpha*(E/N) = (beta*N)*s*i - alpha*e
% i' = alpha*(E/N)-gamma*(I/N) = alpha*e-gamma*i
% r' = gamma*(I/N) = gamma*i

E0 = E(t0);
I0 = I(t0);
R0 = R(t0);
S0 = N-E0-I0-R0;
X0_ad_SEIR = [S0 E0 I0 R0]/N;

S0 = N;
tau = 5.1; %paper SEIR
alpha0=1/tau;

% initial beta and gamma are taken from the previous simulation results 
beta0 = p_SIR(1);
gamma0 = p_SIR(2);
p0_SEIR = [beta0, alpha0, gamma0];

p_SEIR = fit_SEIR(X_ad_SEIR, X0_ad_SEIR, p0_SEIR, t0, tf);
fprintf("--- SEIR FITTING DONE --- \n");
fprintf("beta: %f, alpha: %f, gamma: %f \n", p_SEIR(1), p_SEIR(2), p_SEIR(3));
%% PLOT SEIR
close all
tp = [7,14, 21];
plot_SEIR(X_SEIR, X0_ad_SEIR, N, p_SEIR, dates, t0, tf, tp,"./results/october/Molise/SEIR_fitting.png");
%% FITTING SEIIR MODEL

S = N-E-I-R;
f0 = 0.6; %cambiato

I_a = (1-f0)*I;
I_s = f0*I;

X_SEIIR = [S, E, I_a, I_s, R];
X_ad_SEIIR = [S, E, I_a, I_s, R]/N;

E0 = E(t0);
I_a0 = I_a(t0);
I_s0 = I_s(t0);
R0 = R(t0);
X0_ad_SEIIR = [S0 E0 I_a0 I_s0 R0]/N;

alpha0 = p_SEIR(2);
gamma0 = p_SEIR(3);

beta_a0 = 0.05;
beta_s0 = 0.675281;

p0_SEIIR = [f0, alpha0, gamma0, beta_a0, beta_s0 ];
p_SEIIR = fit_SEIIR(X_ad_SEIIR, X0_ad_SEIIR, p0_SEIIR, t0, tf);
fprintf("--- SEIIR FITTING DONE --- \n");
fprintf("f0: %f, alpha: %f, gamma: %f, beta_a: %f, beta_s: %f \n"...
    , p_SEIIR(1), p_SEIIR(2), p_SEIIR(3), p_SEIIR(4), p_SEIIR(5));
%% PLOT SEIIR
close all 
tp = [7,14, 21];
plot_SEIIR(X_SEIIR, X0_ad_SEIIR, N, p_SEIIR, dates, t0, tf, tp, "./results/october/Molise/SEIIR_fitting.png");
%% FITTING SEIIRHD MODEL

S = N-E-I-R;

R = cast(data.dimessi_guariti, 'double');
H = cast(data.totale_ospedalizzati, 'double');
D = cast(data.deceduti, 'double');

X_SEIIRHD = [S, E, I_a, I_s, H, R, D];
X_ad_SEIIRHD = [S, E, I_a, I_s, H, R, D]/N;

E0 = E(t0);
I_a0 = I_a(t0);
I_s0 = I_s(t0);
H0 = H(t0);
R0 = R(t0);
D0 = D(t0);
X0_ad_SEIIRHD = [S0 E0 I_a0 I_s0 H0 R0 D0]/N;

f0 = p_SEIIR(1);
alpha0 = p_SEIIR(2);
gamma0 = p_SEIIR(3);
beta_a0 = p_SEIIR(4);
beta_s0 = p_SEIIR(5);

%report settimanali ISS tasso ricovero
nu_s0 = 0.08;
mu0 = 0.0204;

p0_SEIIRHD = [f0, alpha0, gamma0, beta_a0, beta_s0, nu_s0, mu0];

p_SEIIRHD = fit_SEIIRHD(X_ad_SEIIRHD, X0_ad_SEIIRHD, p0_SEIIRHD, t0, tf);
fprintf("--- SEIIRHD FITTING DONE --- \n");
fprintf("f0: %f, alpha: %f, gamma: %f, \n beta_a: %f, beta_s: %f, \n nu_s0: %f, mu0: %f \n"...
        , p_SEIIRHD(1), p_SEIIRHD(2), p_SEIIRHD(3), ...
        p_SEIIRHD(4), p_SEIIRHD(5), p_SEIIRHD(6),...
        p_SEIIRHD(7));

%% PLOT SEIIRHD
close all
tp = [7,14, 21];
plot_SEIIRHD(X_SEIIRHD, X0_ad_SEIIRHD, N, p_SEIIRHD, dates, t0, tf, tp, "./results/october/Molise/SEIIRHD_fitting.png");