function p = fit_SEIR(X, X0, p0,t0,tf)
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
I = X(:, 3);
R = X(:, 4);
% time vector for fitting
t_vector = t0:1:tf;

data = [E(t0:1:tf); I(t0:1:tf); R(t0:1:tf)];
lb = zeros(1,3);
ub = ones(1,3);
options=optimoptions(@fmincon, ...
    'MaxFunctionEvaluations', 10000, 'FunctionTolerance',1e-8,...
    'StepTolerance', 1e-8 );
p = fmincon(@(p) err_SEIR(t_vector, data, p, X0),p0, ...
    [], [], [], [], lb, ub, [], options);
end