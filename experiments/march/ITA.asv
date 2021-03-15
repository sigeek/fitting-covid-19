%% 
clc
clear all
close all
% GET DATA FROM SCRIPT
% add folders to path
addpath('./data/');
addpath('./models/');
addpath('./results/march/ITA');
addpath('./models/SEIIRHD');

%retrieve the data structs
[data, dates] = getData;
sizes = size(dates);
size_data = sizes(2);
load dates.mat
N = 60.*10^6;
t0 = find(dates=="20-Feb-2021"); 
tf = find(dates=="14-Mar-2021"); 
%% FITTING SEIIRHD MODEL

I = cast((data.totale_positivi), 'double');
E = 0.3*(I);
R = cast(data.dimessi_guariti, 'double');
H = cast(data.totale_ospedalizzati, 'double');
D = cast(data.deceduti, 'double');

f0 = 0.46;
I_a = (1-f0)*I;
I_s = f0*I;

S = N-E-I-R;

X_SEIIRHD = [S, E, I_a, I_s, H, R, D];
X_ad_SEIIRHD = [S, E, I_a, I_s, H, R, D]/N;

% initial conditions
E0 = E(t0);
I0 = I(t0);
I_a0 = I_a(t0);
I_s0 = I_s(t0);
H0 = H(t0);
R0 = R(t0);
D0 = D(t0);
S0 = N-E0-I0-R0;
X0_ad_SEIIRHD = [S0 E0 I_a0 I_s0 H0 R0 D0]/N;

%% PLOT SEIIRHD MARCH FORECAST
close all
tp = [21];
plot_PI_SEIIRHD(X_SEIIRHD, X0_ad_SEIIRHD, N, dates, t0, tf, tp,...
    "./results/march/ITA/SEIIRHD_PI.png");