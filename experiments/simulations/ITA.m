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
E0 = 0;
I0 = 1;
H0 = 0;
R0 = 0;
D0 = 0;
S0 = N-E0-I0-R0;

timeV = 0:1:50;
%%

lb = [0.3, 0.15, 0, 0, 0, 0, 0];
ub = [0.9, 0.35, 0.4, 0.6, 0.6, 0.4, 0.2];


f = unifrnd(lb(1),ub(1),1,1000);
alpha = unifrnd(lb(2),ub(2),1,1000);
gamma = unifrnd(lb(3),ub(3),1,1000);
beta_a = unifrnd(lb(4),ub(4),1,1000);
beta_s = unifrnd(lb(5),ub(5),1,1000);
nu_s = unifrnd(lb(6),ub(6),1,1000);
mu = unifrnd(lb(7),ub(7),1,1000);

% compute quartiles
fq = quantile(f,[0.25, 0.5, 0.75]);
alphaq = quantile(alpha,[0.25, 0.5, 0.75]);
gammaq = quantile(gamma,[0.25, 0.5, 0.75]);
beta_aq = quantile(beta_a,[0.25, 0.5, 0.75]);
beta_sq = quantile(beta_s,[0.25, 0.5, 0.75]);
nu_sq = quantile(nu_s,[0.25, 0.5, 0.75]);
muq = quantile(mu,[0.25, 0.5, 0.75]);
%% quartile 25%
i = 1;

f1=fq(i);
I_a1 = (1-f1)*I;
I_s1 = f1*I;
I_a10 = I_a1(t0);
I_s10 = I_s1(t0);
X01= [S0 E0 I_a10 I_s10 H0 R0 D0];

alpha1 = alphaq(i);
gamma1 = gammaq(i);
beta_a1 = beta_aq(i);
beta_s1 = beta_sq(i);
nu_s1 = nu_sq(i);
mu1 = muq(i);


R01 = (f1*beta_s1)/(gamma1+mu1+nu_s1) + (1-f1)*beta_a1/gamma1;
fprintf("R0 quartile 0.25: %f \n", R01); 
p1 = [f1, alpha1, gamma1, beta_a1, beta_s1, nu_s1, mu1];
[t_res,x_res1] = ode23s(@(t,x) SEIIRHD(t,x, p1), timeV, X01);  
%% quartile 50%
i = 2;

f2=fq(i);
I_a2 = (1-f2)*I;
I_s2 = f2*I;
I_a20 = I_a2(t0);
I_s20 = I_s2(t0);
X02= [S0 E0 I_a20 I_s20 H0 R0 D0];

alpha2 = alphaq(i);
gamma2 = gammaq(i);
beta_a2 = beta_aq(i);
beta_s2 = beta_sq(i);
nu_s2 = nu_sq(i);
mu2 = muq(i);

R02 = (f2*beta_s2)/(gamma2+mu2+nu_s2) + (1-f2)*beta_a2/gamma2;
fprintf("R0 quartile 0.5: %f \n", R02); 
p2 = [f2, alpha2, gamma2, beta_a2, beta_s2, nu_s2, mu2];
[t_res,x_res2] = ode23s(@(t,x) SEIIRHD(t,x, p2), timeV, X02);  
%% quartile 75%
i=3;

f3=fq(i);
I_a3 = (1-f3)*I;
I_s3 = f3*I;
I_a30 = I_a3(t0);
I_s30 = I_s3(t0);
X03 = [S0 E0 I_a30 I_s30 H0 R0 D0];

alpha3 = alphaq(i);
gamma3 = gammaq(i);
beta_a3 = beta_aq(i);
beta_s3 = beta_sq(i);
nu_s3 = nu_sq(i);
mu3 = muq(i);


R03 = (f3*beta_s3)/(gamma3+mu3+nu_s3) + (1-f3)*beta_a3/gamma3;
fprintf("R0 quartile 0.75: %f \n", R03); 
p3 = [f3, alpha3, gamma3, beta_a3, beta_s3, nu_s3, mu3];
[t_res,x_res3] = ode23s(@(t,x) SEIIRHD(t,x, p3), timeV, X03); 


%% plot
simulate_SEIIRHD(timeV, x_res1, x_res2, x_res3,...
    "./results/simulations/ITA/SEIIRHD.png")

%% sensitivity analysis
den = gamma1 + mu1 + nu_s1;

c_f = (beta_s1/den - beta_a1/gamma1)*(f1/R01);
c_betaa = ((1-f1)/gamma1)*beta_a1/R01;
c_betas = (f1/den)*beta_s1/R01;
c_gamma = (-((f1*beta_s1)/den)^2-(((1-f1)*beta_a1)/gamma1)^2)*gamma1/R01;
c_nus = (-((f1*beta_s1)/den)^2)*nu_s1/R01;
c_mu = (-((f1*beta_s1)/den)^2)*mu1/R01;
