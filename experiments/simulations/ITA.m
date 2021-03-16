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
%% SEIIRHD MODEL PARAMETERS

I = cast((data.totale_positivi), 'double');
E = 0.3*(I);
R = cast(data.dimessi_guariti, 'double');
H = cast(data.totale_ospedalizzati, 'double');
D = cast(data.deceduti, 'double');

t0 = 1;
E0 = E(t0);
I0 = I(t0);
H0 = H(t0);
R0 = R(t0);
D0 = D(t0);
S0 = N-E0-I0-R0;

timeV = 0:1:50;
%% R0 = 0.5
f1 = 0.5;
I_a1 = (1-f1)*I;
I_s1 = f1*I;
I_a10 = I_a1(t0);
I_s10 = I_s1(t0);
X01= [S0 E0 I_a10 I_s10 H0 R0 D0];

alpha1 = 0.3;
gamma1 = 0.041;
beta_a1 = 0.021;
beta_s1 = 0.023;
nu_s1 = 0.004;
mu1 = 0.002;


R01 = (f1*beta_s1)/(gamma1+mu1+nu_s1) + (1-f1)*beta_a1/gamma1;
fprintf("R0 first simulation: %f \n", R01); 
p1 = [f1, alpha1, gamma1, beta_a1, beta_s1, nu_s1, mu1];
[t_res,x_res1] = ode23s(@(t,x) SEIIRHD(t,x, p1), timeV, X01);  
%% R0 = 1
f2 = 0.55;
I_a2 = (1-f2)*I;
I_s2 = f2*I;
I_a20 = I_a2(t0);
I_s20 = I_s2(t0);
X02= [S0 E0 I_a20 I_s20 H0 R0 D0];

alpha2 = 0.3;
gamma2 = 0.0425;
beta_a2 = 0.05;
beta_s2 = 0.052;
nu_s2 = 0.01;
mu2 = 0.008;

R02 = (f2*beta_s2)/(gamma2+mu2+nu_s2) + (1-f2)*beta_a2/gamma2;
fprintf("R0 second simulation: %f \n", R02); 
p2 = [f2, alpha2, gamma2, beta_a2, beta_s2, nu_s2, mu2];
[t_res,x_res2] = ode23s(@(t,x) SEIIRHD(t,x, p2), timeV, X02);  
%% R0 = 1.5
f3 = 0.7;
I_a3 = (1-f3)*I;
I_s3 = f3*I;
I_a30 = I_a3(t0);
I_s30 = I_s3(t0);
X03 = [S0 E0 I_a30 I_s30 H0 R0 D0];

alpha3 = 0.3;
gamma3 = 0.035;
beta_a3 = 0.081;
beta_s3 = 0.081;
nu_s3 = 0.0245;
mu3 = 0.0105;

R03 = (f3*beta_s3)/(gamma3+mu3+nu_s3) + (1-f3)*beta_a3/gamma3;
fprintf("R0 third simulation: %f \n", R03); 
p3 = [f3, alpha3, gamma3, beta_a3, beta_s3, nu_s3, mu3];
[t_res,x_res3] = ode23s(@(t,x) SEIIRHD(t,x, p3), timeV, X03); 

%% R0 = 3
f4 = 0.8;
I_a4 = (1-f4)*I;
I_s4 = f4*I;
I_a40 = I_a4(t0);
I_s40 = I_s4(t0);
X04 = [S0 E0 I_a40 I_s40 H0 R0 D0];

alpha4 = 0.3;
gamma4 = 0.0375;
beta_a4 = 0.24;
beta_s4 = 0.21;
nu_s4 = 0.03;
mu4 = 0.03;

R04 = (f4*beta_s4)/(gamma4+mu4+nu_s4) + (1-f4)*beta_a4/gamma4;
fprintf("R0 forth simulation: %f \n", R04); 
p4 = [f4, alpha4, gamma4, beta_a4, beta_s4, nu_s4, mu4];
[t_res,x_res4] = ode23s(@(t,x) SEIIRHD(t,x, p4), timeV, X04); 
%%
simulate_SEIIRHD(timeV, x_res1, x_res2, x_res3, x_res4,...
    "./results/simulations/ITA/SEIIRHD.png")
