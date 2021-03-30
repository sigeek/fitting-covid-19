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
t1 = datetime(2020,02,24,0,0,0);
t2 = datetime(2022,12,31,0,0,0);
dates = t1:t2;
N = 60.*10^6;
%% SEIIRHD MODEL PARAMETERS

I = cast((data.totale_positivi), 'double');
E = 0.3*(I);
R = cast(data.dimessi_guariti, 'double');
H = cast(data.totale_ospedalizzati, 'double');
D = cast(data.deceduti, 'double');

t0 = find(dates=="21-Feb-2021"); 
E0 = E(t0);
I0 = I(t0);
H0 = H(t0);
R0 = R(t0);
D0 = D(t0);
S0 = N-E0-I0-R0;

timeV = t0:1:t0+500;
%%
p = [0.5164, 0.0884, 0.0351, ...
    0.0217, 0.0253, 0.0039, 0.0022];
f=p(1);
I_a = (1-f)*I;
I_s = f*I;
I_a0 = I_a(t0);
I_s0 = I_s(t0);
X0= [S0 E0 I_a0 I_s0 H0 R0 D0];

[t,x] = ode23s(@(t,x) SEIIRHD(t,x, p), timeV, X0);  
%%
forecast_SEIIRHD(dates(timeV), x,...
    "./results/simulations/ITA/SEIIRHDMarchForecast.png")