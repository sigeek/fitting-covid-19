% add folder to path
addpath('./data/');
%retrieve the data struct
covid_data = getData;

% [S, E, I, R]
% N = 60.*10^6;
% S0 = N;
% E0 = covid_data.isolamento_domiciliare(1);
% I0 = covid_data.nuovi_positivi(1);
% R0 = covid_data.dimessi_guariti(1) + covid_data.deceduti(1);

% X0 = [S0 E0 I0 R0]; 
lambda0 = 1;
lambda = lambda0 / S0;
t_incubation = 5.1; % da verificare con paper con studi su Italia
alpha0=1/t_incubation;

% adimensional SEIR model for fitting
% We divide every variable by N
% s = S/N, e= E/N etc.
% [s, e, i, r]
% s' = -(lambda*N)*(S/N)*(I/N) = -(lambda*N)*s*i
% e' = (lambda*N)*(S/N)*(I/N) - alpha*(E/N) = (lambda*N)*s*i - alpha*e
% i' = alpha*(E/N)-gamma*(I/N) = alpha*e-gamma*i
% r' = gamma*(I/N) = gamma*i


lambda = lambda*N;
T = length(covid_data.data);
figure(1);
Niter=300;
t0 = find(covid_data.data=="2020-10-08");
% S0 = N- ...;
E0 = covid_data.nuovi_isolamento_domiciliare(t0);
I0 = covid_data.nuovi_positivi(t0);
R0 = covid_data.nuovi_dimessi_guariti(t0) + covid_data.nuovi_deceduti(t0);
X0 = [S0, E0, I0, R0];
X0 = X0/N;
errors = zeros(Niter,1);