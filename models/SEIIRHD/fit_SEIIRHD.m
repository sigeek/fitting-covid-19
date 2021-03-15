function p = fit_SEIIRHD(X, X0, p0,t0,tf)
% Input 
% X       data: S, E, I, R
% X0      initial conditions: S0, E0, I0, R0
% p0      initial value for the coefficients of the model
% t0      time at which the fitting starts
% tf      time at which the fitting ends  

% Output
% p       estimated parameters

%S = X(:, 1);
E = X(:, 2);
I_a = X(:, 3);
I_s = X(:, 4);
H = X(:, 5);
R = X(:, 6);
D = X(:, 7);
% time vector for fitting
t_vector = t0:1:tf;

data = [E(t0:1:tf); I_a(t0:1:tf); I_s(t0:1:tf); H(t0:1:tf); R(t0:1:tf); D(t0:1:tf)];
lb = zeros(1,7);
ub = ones(1,7);
p = fmincon(@(p) err_SEIIRHD(t_vector, data, p, X0),p0, [], [],[], [], lb, ub);
end