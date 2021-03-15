function p = fit_SIR(X, X0, p0,t0,tf)
% Input 
% X       data: S, I, R
% X0      initial conditions: S0, I0, R0
% p0      initial value for the coefficients of the model
% t0      time at which the fitting starts
% tf      time at which the fitting ends  

% Output
% p       estimated parameters

%S = X(:, 1);
I = X(:, 2);
R = X(:, 3);
% time vector for fitting
t_vector = t0:1:tf;

data = [I(t0:1:tf); R(t0:1:tf)];
lb = zeros(1,2);
ub = ones(1,2);
options=optimoptions(@fmincon, ...
    'MaxFunctionEvaluations', 10000, 'FunctionTolerance',1e-8,...
    'StepTolerance', 1e-8 );
p = fmincon(@(p) err_SIR(t_vector, data, p, X0),p0, ...
    [], [], [], [], lb, ub, ...
    [], options);
end