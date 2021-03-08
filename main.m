%% 
clc
clear all
close all
% GET DATA FROM SCRIPT
% add folders to path
addpath('./data/');
addpath('./models/');
addpath('./results/');
addpath('./models/SIR');
addpath('./models/SEIR');
addpath('./models/SEIIR');
addpath('./models/SEIIRHD');

%retrieve the data structs
[data, dates] = getData;
[dataMolise, datesMolise] = getDataByRegion("Molise");
[dataSardegna, datesSardegna] = getDataByRegion("Sardegna");
sizes = size(dates);
size_data = sizes(2);
N = 60.*10^6;
Nm = 300516;
Ns = 1611621;
%% PLOT OVERVIEW DATA
% da rifare prima della consegna
plot_data(data, dates, N, 1, size_data, "complete");
%% PLOT OCTOBER DATA
t0 = find(dates=="08-Oct-2020"); 
tf = find(dates=="05-Nov-2020"); 
plot_data(data, dates(t0:tf), N, t0, tf, "october");
%% PLOT FEBRUARY DATA FOR MOLISE
t0 = find(dates=="10-Feb-2021"); 
tf = find(dates=="04-Mar-2021"); 
plot_data(dataMolise, datesMolise(t0:tf), N, t0, tf, "Molise");
%% PLOT FEBRUARY DATA FOR SARDEGNA
plot_data(dataSardegna, datesSardegna(t0:tf), N, t0, tf, "Sardegna");
%% FITTING SIR MODEL
% [S, I, R]

beta0 = 0.962/N;  
gamma0 = 0.37; 

% adimensional SIR model for fitting
% We divide every variable by N
% s = S/N, e= E/N etc.
% [s, i, r]
% s' = -(beta*N)*(S/N)*(I/N) = -(beta*N)*s*i
% i' = (beta*N)*(S/N)*(I/N) - (gamma)*(I/N) = (beta*N)*s*i - gamma*i
% r' = gamma*(I/N) = gamma*i

I = cast((data.totale_positivi), 'double'); 
R = cast((data.dimessi_guariti), 'double');
S = N-I-R;
X_SIR = [S, I, R];
X_ad_SIR = [S, I, R]/N;

% initial conditions
t0 = find(dates=="08-Oct-2020"); 
tf = find(dates=="05-Nov-2020"); 
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
tp = [7,14, 21];
plot_SIR(X_SIR, X0_ad_SIR, N, p_SIR, dates, t0, tf, tp,"d");
%% FITTING SIR MODEL x MOLISE
beta0m = 0.962/Nm;  
gamma0m = 0.37; 

Im = cast((dataMolise.totale_positivi), 'double'); 
Rm = cast((dataMolise.dimessi_guariti), 'double');
Sm = Nm-Im-Rm;
Xm_SIR = [Sm, Im, Rm];
Xm_ad_SIR = [Sm, Im, Rm]/Nm;

% initial conditions
tm0 = find(dates=="21-Jan-2021"); %01
tmf = find(dates=="11-Feb-2021"); 
Im0 = Im(tm0);
Rm0 = Rm(tm0);
Sm0 = Nm-Im0-Rm0;
Xm0_ad_SIR = [Sm0 Im0 Rm0]/Nm;

beta0m = beta0m*Nm;
pm0_SIR = [beta0m, gamma0m];

pm_SIR = fit_SIR(Xm_ad_SIR, Xm0_ad_SIR, pm0_SIR, tm0, tmf);
fprintf("--- SIR x MOLISE FITTING DONE --- \n");
fprintf("beta: %f, gamma: %f \n", pm_SIR(1), pm_SIR(2));
%% PLOT SIR x MOLISE
tp = [7, 14, 21];
plot_SIR(Xm_SIR, Xm0_ad_SIR, Nm, pm_SIR, datesMolise, tm0, tmf, tp, "Molise");
%% FITTING SIR MODEL x SARDEGNA
beta0s = 0.05/Ns;  
gamma0s = 0.4; 

Is = cast((dataSardegna.totale_positivi), 'double'); 
Rs = cast((dataSardegna.dimessi_guariti), 'double');
Ss = Ns-Is-Rs;
Xs_SIR = [Ss, Is, Rs];
Xs_ad_SIR = [Ss, Is, Rs]/Ns;

% initial conditions
ts0 = find(dates=="21-Jan-2021"); %01
tsf = find(dates=="11-Feb-2021"); 
Is0 = Is(ts0);
Rs0 = Rs(ts0);
Ss0 = Ns-Is0-Rs0;
Xs0_ad_SIR = [Ss0 Is0 Rs0]/Ns;

beta0s = beta0s*Ns;
ps0_SIR = [beta0s, gamma0s];

ps_SIR = fit_SIR(Xs_ad_SIR, Xs0_ad_SIR, ps0_SIR, ts0, tsf);
fprintf("--- SIR x SARDEGNA FITTING DONE --- \n");
fprintf("beta: %f, gamma: %f \n", ps_SIR(1), ps_SIR(2));
%% PLOT SIR x SARDEGNA
tp = [7, 14, 21];
plot_SIR(Xs_SIR, Xs0_ad_SIR, Ns, ps_SIR, datesSardegna, ts0, tsf, tp, "Sardegna");
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
tp = [7,14, 21];
plot_SEIR(X_SEIR, X0_ad_SEIR, N, p_SEIR, dates, t0, tf, tp,"d");
%% FITTING SEIR MODEL x MOLISE
% [S, E, I, R]

Em = 0.1*(Im); 
Sm = Nm-Im-Em-Rm;
Xm = [Sm, Em, Im, Rm];
Xm_SEIR = [Sm, Em, Im, Rm];
Xm_ad_SEIR = [Sm, Em, Im, Rm]/Nm;

Em0 = Em(tm0);
Im0 = Im(tm0);
Rm0 = Rm(tm0);
Sm0 = Nm-Em0-Im0-Rm0;
Xm0_ad_SEIR = [Sm0 Em0 Im0 Rm0]/Nm;

Sm0 = Nm;
tau = 3; %paper SEIR
alpham0=1/tau;

% initial beta and gamma are taken from the previous simulation results 
betam0 = p_SIR(1);
gammam0 = p_SIR(2);
pm0_SEIR = [betam0, alpham0, gammam0];

pm_SEIR = fit_SEIR(Xm_ad_SEIR, Xm0_ad_SEIR, pm0_SEIR, tm0, tmf);
fprintf("--- SEIR x MOLISE FITTING DONE --- \n");
fprintf("beta: %f, alpha: %f, gamma: %f \n", pm_SEIR(1), pm_SEIR(2), pm_SEIR(3));
%% PLOT SEIR x MOLISE
tp = [7, 14, 21];
plot_SEIR(Xm_SEIR, Xm0_ad_SEIR, Nm, pm_SEIR, dates, tm0, tmf, tp,"Molise");
%% FITTING SEIIR MODEL

S = N-E-I-R;
%f presa dal paper
f0 = 0.4264;

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
beta_e0 = 0.251883;

p0_SEIIR = [f0, alpha0, gamma0, beta_a0, beta_s0, beta_e0 ];
p_SEIIR = fit_SEIIR(X_ad_SEIIR, X0_ad_SEIIR, p0_SEIIR, t0, tf);
fprintf("--- SEIIR FITTING DONE --- \n");
fprintf("f0: %f, alpha: %f, gamma: %f, beta_a: %f, beta_s: %f, beta_e: %f \n"...
    , p_SEIIR(1), p_SEIIR(2), p_SEIIR(3), p_SEIIR(4), p_SEIIR(5), p_SEIIR(6));
%% PLOT SEIIR
tp = [7,14, 21];
plot_SEIIR(X_SEIIR, X0_ad_SEIIR, N, p_SEIIR, dates, t0, tf, tp, "d");
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
beta_e0 = p_SEIIR(6);

%report settimanali ISS tasso ricovero
nu_e0 = 0.008;
nu_s0 = 0.08;
mu0 = 0.0204;

p0_SEIIRHD = [f0, alpha0, gamma0, beta_a0, beta_s0, beta_e0, nu_e0, nu_s0, mu0];

p_SEIIRHD = fit_SEIIRHD(X_ad_SEIIRHD, X0_ad_SEIIRHD, p0_SEIIRHD, t0, tf);
fprintf("--- SEIIRHD FITTING DONE --- \n");
fprintf("f0: %f, alpha: %f, gamma: %f, \n beta_a: %f, beta_s: %f, beta_e: %f, \n nu_e0: %f, nu_s0: %f, mu0: %f \n"...
        , p_SEIIRHD(1), p_SEIIRHD(2), p_SEIIRHD(3), ...
        p_SEIIRHD(4), p_SEIIRHD(5), p_SEIIRHD(6),...
        p_SEIIRHD(7), p_SEIIRHD(8), p_SEIIRHD(9));

%% PLOT SEIIRHD
tp = [7,14, 21];
plot_SEIIRHD(X_SEIIRHD, X0_ad_SEIIRHD, N, p_SEIIRHD, dates, t0, tf, tp, "d");
%%
R0 = ((p_SEIIRHD(6)/p_SEIIRHD(7))+((p_SEIIRHD(1)*p_SEIIRHD(5))/(p_SEIIRHD(3)+p_SEIIRHD(9)+p_SEIIRHD(8)))+((1-p_SEIIRHD(1)* p_SEIIRHD(4))/p_SEIIRHD(3)))
